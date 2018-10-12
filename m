Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52067 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727571AbeJLPzM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Oct 2018 11:55:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id 143-v6so11381521wmf.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Oct 2018 01:23:52 -0700 (PDT)
Date: Fri, 12 Oct 2018 10:23:49 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: PATCH 2/2] xfsprogs: enable sparse checking with "make C=2"
Message-ID: <20181012082349.jwbeww4upejq4cot@odin.usersys.redhat.com>
References: <5b155482-78db-b58d-13d3-a478f79b1558@redhat.com>
 <086806d2-c2e5-bca0-1ade-fb7e5995c7d4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086806d2-c2e5-bca0-1ade-fb7e5995c7d4@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 11:14:14AM -0500, Eric Sandeen wrote:
> Enable "make C=2" sparse checking of all files without rebuilding them.
> 
> This is a bit simpler than redefining CC for the whole build, which
> requires extra commandline definitions and apparently is enough of a
> barrier that nobody's doing sparse checking.
> 
> Note, this requires unreleased sparse after v0.5, which enables the
> CHAR_BIT definition; otherwise it chokes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> --- 
> 
> diff --git a/Makefile b/Makefile
> index 05fe609..9204bed 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -21,14 +21,14 @@ CHECK_OPTS=-Wsparse-all -Wbitwise -Wno-transparent-union -Wno-return-void -Wno-u
>  	-Wno-non-pointer-null -D__CHECK_ENDIAN__ -D__linux__
>  
>  ifeq ("$(origin C)", "command line")
> -  ifeq ("$(C)", "1")
> -    CHECK_CMD=$(CHECK) $(CHECK_OPTS)
> -  else
> -    CHECK_CMD=@true
> -  endif
> +  CHECK_CMD=$(CHECK) $(CHECK_OPTS)
> +  CHECKSRC=$(C)
> +else
> +  CHECK_CMD=@true
> +  CHECKSRC=0
>  endif

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
> -export CHECK_CMD
> +export CHECK_CMD CHECKSRC
>  
>  MAKEOPTS = --no-print-directory Q=$(Q)
>  
> diff --git a/doc/sparse.txt b/doc/sparse.txt
> index c6d1fe7..75b24e0 100644
> --- a/doc/sparse.txt
> +++ b/doc/sparse.txt
> @@ -5,15 +5,12 @@ to check the source code of the open source XFS commands and utilites
>  First you need to install sparse, either from your distribution or from
>  source as provided at http://www.kernel.org/pub/software/devel/sparse/.
>  
> -The xfsprogs Makefile has a convenient shortcut to running sparse, by setting
> -the C ("check") variable on the make commandline.  To perform these checks on
> -files when they get rebuilt, use:
> +Then, run make with "make C=1" to run sparse on all the C files that get
> +recompiled, or use "make C=2" to run sparse on the files whether they need to
> +be recompiled or not.  The latter is a fast way to check the whole tree if you
> +have already built it.
>  
> -	make C=1
> -
> -(Note that xfsprogs does not yet support the kernel convention of checking
> -all C files without compilation via "make C=2", so to run sparse on all
> -C files, start with a "make clean")
> +See the top-level Makefile for a list of which sparse flags are enabled.
>  
>  If you'd rather run sparse more manually, just set the compiler to cgcc,
>  which is a wrapper that calls both sparse and gcc using:
> diff --git a/include/buildrules b/include/buildrules
> index 297e598..c207a16 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -40,6 +40,21 @@ endif
>  # Standard targets
>  #
>  
> +ifeq ($(CHECKSRC),2)
> +
> +# Check every .c file with sparse CHECK_CMD, do not call compiler
> +$(LTCOMMAND) $(LTLIBRARY) : $(SUBDIRS) $(OBJECTS)
> +.PHONY: $(LTCOMMAND) $(LTLIBRARY)
> +
> +%.lo %.o : %.c FORCE
> +	@echo "    [CHECK]  $<"
> +	$(Q)$(CHECK_CMD) $(CFLAGS) $<
> +
> +FORCE:
> +
> +else
> +# Regular build, possibly calling sparse CHECK_CMD as well
> +
>  ifdef LTCOMMAND
>  $(LTCOMMAND) : $(SUBDIRS) $(OBJECTS) $(LTDEPENDENCIES)
>  	@echo "    [LD]     $@"
> @@ -63,6 +78,7 @@ else
>  	$(Q)$(CHECK_CMD) $(CFLAGS) $<
>  
>  endif
> +endif
>  
>  ifdef POTHEAD
>  $(POTHEAD): $(XGETTEXTFILES)
> 

-- 
Carlos
