Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53106 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbeJLPyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Oct 2018 11:54:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id 189-v6so11448392wmw.2
        for <linux-xfs@vger.kernel.org>; Fri, 12 Oct 2018 01:22:51 -0700 (PDT)
Date: Fri, 12 Oct 2018 10:22:47 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfsprogs: enable sparse checking with make C=1
Message-ID: <20181012082247.piys2rxsfiljpnqq@odin.usersys.redhat.com>
References: <5b155482-78db-b58d-13d3-a478f79b1558@redhat.com>
 <97a4f428-9c9c-7bd7-7d6f-f2bf3a39b9ac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a4f428-9c9c-7bd7-7d6f-f2bf3a39b9ac@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 11:12:52AM -0500, Eric Sandeen wrote:
> Enable "make C=1" sparse checking when files get rebuilt.  To check
> all files, run "make clean" first.
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
> index d031a60..05fe609 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -16,6 +16,20 @@ else
>    Q = @
>  endif
>  
> +CHECK=sparse
> +CHECK_OPTS=-Wsparse-all -Wbitwise -Wno-transparent-union -Wno-return-void -Wno-undef \
> +	-Wno-non-pointer-null -D__CHECK_ENDIAN__ -D__linux__
> +
> +ifeq ("$(origin C)", "command line")
> +  ifeq ("$(C)", "1")
> +    CHECK_CMD=$(CHECK) $(CHECK_OPTS)
> +  else
> +    CHECK_CMD=@true
> +  endif
> +endif
> +
> +export CHECK_CMD
> +
>  MAKEOPTS = --no-print-directory Q=$(Q)

Looks good
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
>  TOPDIR = .
> diff --git a/doc/sparse.txt b/doc/sparse.txt
> index 36a34a0..c6d1fe7 100644
> --- a/doc/sparse.txt
> +++ b/doc/sparse.txt
> @@ -5,9 +5,18 @@ to check the source code of the open source XFS commands and utilites
>  First you need to install sparse, either from your distribution or from
>  source as provided at http://www.kernel.org/pub/software/devel/sparse/.
>  
> -To simply build the xfsprogs source code while checking the source using
> -sparse just set the compiler to cgcc, which is a wrapper that calls both
> -sparse and gcc using:
> +The xfsprogs Makefile has a convenient shortcut to running sparse, by setting
> +the C ("check") variable on the make commandline.  To perform these checks on
> +files when they get rebuilt, use:
> +
> +	make C=1
> +
> +(Note that xfsprogs does not yet support the kernel convention of checking
> +all C files without compilation via "make C=2", so to run sparse on all
> +C files, start with a "make clean")
> +
> +If you'd rather run sparse more manually, just set the compiler to cgcc,
> +which is a wrapper that calls both sparse and gcc using:
>  
>  	CC=cgcc ./configure
>  
> diff --git a/include/buildrules b/include/buildrules
> index c57fdfc..297e598 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -54,10 +54,13 @@ $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
>  %.lo: %.c
>  	@echo "    [CC]     $@"
>  	$(Q)$(LTCOMPILE) -c $<
> +	$(Q)$(CHECK_CMD) $(CFLAGS) $<
>  else
> +
>  %.o: %.c
>  	@echo "    [CC]     $@"
>  	$(Q)$(CC) $(CFLAGS) -c $<
> +	$(Q)$(CHECK_CMD) $(CFLAGS) $<
>  
>  endif
>  
> 

-- 
Carlos
