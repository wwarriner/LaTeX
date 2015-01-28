% HMC Math dept HW class file
% v0.04 by Eric J. Malm, 10 Mar 2005
% v0.05 by William Warriner, 23 Jan 2014
%  - Added close paren to problem statement and solution numbers, i.e. the
%    optional arguments. Should make optional. Added \textit{} to solution
%    number.
% v0.06 by William Warriner, 24 Feb 2014
%  - Added dependence to uabhw.sty.
%  - Passed document parindent to minipage environment for problems.
% v0.07 by William Warriner, 25 Feb 2014
%  - Fixed redefinition issue with \mylength by declaring outside
%    environment
%  - TODO add environment-dependent "answer" box.
%  - TODO fix \begin{center} bug: if that immediately follows 
%    \begin{solution} then it will center the solution title.
%  - TODO fix minipage losing floats (probably have to ditch minipage?)

%%% IDENTIFICATION --------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}[1995/01/01]
\ProvidesClass{uabpset}
    [2005/03/10 v0.04 HMC Math Dept problem set class]

%%% INITIAL CODE ----------------------------------------------------------

% test whether the document is being compiled with PDFTeX
\RequirePackage{ifpdf}

%%% DECLARATION OF OPTIONS ------------------------------------------------
%% Header Options: header*, no header
\newif\ifhmcpset@header

% no header block in upper right hand corner
\DeclareOption{noheader}{%
    \hmcpset@headerfalse%
}

% do print header block
\DeclareOption{header}{%
    \hmcpset@headertrue%
}

%% Font Options: palatino*, cm
\newif\ifhmcpset@palatino

% use palatino fonts
\DeclareOption{palatino}{%
    \hmcpset@palatinotrue%
}

% use compuer modern fonts
\DeclareOption{cm}{%
    \hmcpset@palatinofalse%
}

%% Problem Boxing: boxed*, unboxed
\newif\ifhmcpset@boxed

% box problem statements
\DeclareOption{boxed}{%
    \hmcpset@boxedtrue%
}
   
% don't box problem statements
\DeclareOption{unboxed}{%
    \hmcpset@boxedfalse%
}
   
% pass remaining options to article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

%%% EXECUTION OF OPTIONS --------------------------------------------------
%% default to:
% including header, 
% loading mathpazo package for palatino fonts,
% boxing problem statements
\ExecuteOptions{header,palatino,boxed}

\ProcessOptions

%%% PACKAGE LOADING -------------------------------------------------------
%% based on std article class
\LoadClass{article}


%% Font loading: Palatino text/math fonts
\ifhmcpset@palatino
    \RequirePackage{mathpazo}
\fi

%% UAB homework style classes and commands.
\RequirePackage{uabhw}

%% AMSLaTeX math environments and symbols
\RequirePackage{amsmath}
\RequirePackage{amssymb}

%% boxed minipage for boxed problem environment
\RequirePackage{boxedminipage}

%%% MAIN CODE -------------------------------------------------------------
%% Tell dvips/pdflatex correct page size
\ifpdf
  \AtBeginDocument{%
    \setlength{\pdfpageheight}{\paperheight}%
    \setlength{\pdfpagewidth}{\paperwidth}%
  }
\else
  \AtBeginDvi{\special{papersize=\the\paperwidth,\the\paperheight}}%
\fi


%% Problem set environments
% boxed problem environment
\newlength{\myindent}%
\newenvironment{problem}[1][]{%
  \setlength{\myindent}{\the\parindent}%
  \ifhmcpset@boxed\def\hmcpset@probenv{boxed}\else\def\hmcpset@probenv{}\fi%
  \bigskip% put space before problem statement box %
  \noindent\begin{\hmcpset@probenv minipage}{\columnwidth}%
  \def\@tempa{#1}%
  \ifx\@tempa\empty%
    \hmcpset@probformat{Problem }
  \else%
    \hmcpset@probformat{Problem #1)}\hspace{0.5em}%
  \fi%
  \parindent=\myindent\relax%
}{%
  \end{\hmcpset@probenv minipage}%
}
% display optional argument to problem in bold
\let\hmcpset@probformat\textbf

% solution environment with endmark and optional argument
\newenvironment{solution}[1][]{%
  \begin{trivlist}%
    \def\@tempa{#1}%
    \ifx\@tempa\empty%
      \item[\hskip\labelsep\relax\textbf{Solution:}]%
    \else%
      \item[\hskip\labelsep\relax\textbf{Solution:} (\textit{#1})]%
    \fi%
}{%
  \mbox{}\penalty10000\hfill\hmcpset@endmark%
  \end{trivlist}%
}

% default endmark is small black square
\def\hmcpset@endmark{\ensuremath{\scriptscriptstyle\blacksquare}}

%% Problem set list, for top of document
\newcommand{\problemlist}[1]{\begin{center}\large{#1}\end{center}}

%% commands for upper-right id header block
\newcommand{\headerblock}{%
\begin{flushright}
\mbox{\hmcpset@name}\protect\\
\mbox{\hmcpset@class}\protect\\
\mbox{\hmcpset@assignment}\protect\\
\hmcpset@duedate%
\ifx\hmcpset@extraline\empty\else\protect\\\hmcpset@extraline\fi%
\end{flushright}%
}

% put id header block at start of document
\ifhmcpset@header\AtBeginDocument{\headerblock}\fi

% internal state for headerblock
\def\hmcpset@name{}
\def\hmcpset@class{}
\def\hmcpset@assignment{}
\def\hmcpset@duedate{}
\def\hmcpset@extraline{}

% commands to set header block info
\newcommand{\name}[1]{\def\hmcpset@name{#1}}
\newcommand{\class}[1]{\def\hmcpset@class{#1}}
\newcommand{\assignment}[1]{\def\hmcpset@assignment{#1}}
\newcommand{\duedate}[1]{\def\hmcpset@duedate{#1}}
\newcommand{\extraline}[1]{\def\hmcpset@extraline{#1}}
