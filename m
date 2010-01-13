Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DEnZnD163495 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 08:49:35 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F44E162352
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 06:50:30 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id hG2iHRgqabKdDB58 for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 06:50:30 -0800 (PST)
References: <1263377007-4500-1-git-send-email-david@fromorbit.com>
Message-Id: <8F499EB9-6813-46CF-999C-F7F1DFABA9A6@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <1263377007-4500-1-git-send-email-david@fromorbit.com>
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH] xfsprogs: Make the compile output cleaner V2
Date: Wed, 13 Jan 2010 08:50:29 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Jan 13, 2010, at 4:03 AM, Dave Chinner <david@fromorbit.com> wrote:

> We don't need to see every compiler command line for every file that
> is compiled. This makes it hard to see warnings and errors during
> compile. For progress notification, we really only need to see the
> diretory/file being operated on.
>
> Turn down the verbosity of output by suppressing various make output
> and provide better overall visibility of which directory is being
> operated on, what the operation is and what is being done to the
> files by the build/clean process. Also fix the top level clean rule
> so that we don't run configure scripts after a make clean, only after
> a make distclean.
>
> Sample output from a build:
>
> ....
> Building libxlog
>    [CC] xfs_log_recover.c
>    [CC] util.c
>    [LD] libxlog.la
> Building libxcmd
>    [CC] command.c
>    [CC] input.c
>    [CC] paths.c
>    [CC] projects.c
>    [CC] help.c
>    [CC] quit.c
>    [LD] libxcmd.la
> ....
>
> Sample output from cleaning:
>
> $ make clean
> Cleaning include
> Cleaning libxfs
> Cleaning libxlog
> Cleaning libxcmd
> Cleaning libhandle
> Cleaning libdisk
> Cleaning copy
> Cleaning db
> ....
>
> If you want to see a noisy build (i.e. every command), use:
>
> $ make Q=
>
> and that will output all the commands that are now suppressed by
> default.
>
> Portions of this patch were contributed by Eric Sandeen.
>
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
> Makefile            |   43 +++++++++++++++++++++++++++++--------------
> doc/Makefile        |    3 ++-
> include/Makefile    |    3 ++-
> include/buildmacros |   10 +++++-----
> include/buildrules  |   30 +++++++++++++++++++++---------
> mkfs/Makefile       |    3 ++-
> 6 files changed, 61 insertions(+), 31 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 2d394e4..62c4258 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -2,6 +2,21 @@
> # Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
> #
>
> +ifeq ("$(origin V)", "command line")
> +  BUILD_VERBOSE = $(V)
> +endif
> +ifndef BUILD_VERBOSE
> +  BUILD_VERBOSE = 0
> +endif
> +
> +ifeq ($(BUILD_VERBOSE),1)
> +  Q =
> +else
> +  Q = @
> +endif
> +
> +MAKEOPTS = --no-print-directory Q=$(Q)
> +
> TOPDIR = .
> HAVE_BUILDDEFS = $(shell test -f $(TOPDIR)/include/builddefs && echo  
> yes || echo no)
>
> @@ -15,7 +30,7 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
> CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh  
> ltmain.sh
> LSRCFILES = configure.in release.sh README VERSION $(CONFIGURE)
>
> -LDIRT = config.log .dep config.status config.cache confdefs.h  
> conftest* \
> +DISTDIRT = config.log .dep config.status config.cache confdefs.h  
> conftest* \
>    built .census install.* install-dev.* *.gz autom4te.cache/*  
> libtool \
>    include/builddefs include/platform_defs.h
>
> @@ -36,9 +51,9 @@ SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
>
> default: include/builddefs include/platform_defs.h
> ifeq ($(HAVE_BUILDDEFS), no)
> -    $(MAKE) -C . $@
> +    $(Q)$(MAKE) $(MAKEOPTS) -C . $@
> else
> -    $(MAKE) $(SUBDIRS)
> +    $(Q)$(MAKE) $(MAKEOPTS) $(SUBDIRS)
> endif
>
> # tool/lib dependencies
> @@ -80,7 +95,7 @@ include/platform_defs.h: include/builddefs
> ## Recover from the removal of $@
>    @if test -f $@; then :; else \
>        rm -f include/builddefs; \
> -        $(MAKE) $(AM_MAKEFLAGS) include/builddefs; \
> +        $(MAKE) $(MAKEOPTS) $(AM_MAKEFLAGS) include/builddefs; \
>    fi
>
> install: default $(addsuffix -install,$(SUBDIRS))
> @@ -101,29 +116,29 @@ install-qa: install $(addsuffix -install-qa,$ 
> (SUBDIRS))
>    $(MAKE) -C $* install-qa
>
> distclean: clean
> -    rm -f $(LDIRT)
> +    $(Q)rm -f $(DISTDIRT)
>
> realclean: distclean
> -    rm -f $(CONFIGURE)
> +    $(Q)rm -f $(CONFIGURE)
>
> #
> # All this gunk is to allow for a make dist on an unconfigured tree
> #
> dist: include/builddefs include/platform_defs.h default
> ifeq ($(HAVE_BUILDDEFS), no)
> -    $(MAKE) -C . $@
> +    $(Q)$(MAKE) $(MAKEOPTS) -C . $@
> else
> -    $(MAKE) $(SRCTAR)
> +    $(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
> endif
>
> deb: include/builddefs include/platform_defs.h
> ifeq ($(HAVE_BUILDDEFS), no)
> -    $(MAKE) -C . $@
> +    $(Q)$(MAKE) $(MAKEOPTS) -C . $@
> else
> -    $(MAKE) $(SRCDIR)
> -    $(MAKE) -C po
> -    $(MAKE) source-link
> -    cd $(SRCDIR) && dpkg-buildpackage
> +    $(Q)$(MAKE) $(MAKEOPTS) $(SRCDIR)
> +    $(Q)$(MAKE) $(MAKEOPTS) -C po
> +    $(Q)$(MAKE) $(MAKEOPTS) source-link
> +    $(Q)cd $(SRCDIR) && dpkg-buildpackage
> endif
>
> $(SRCDIR) : $(_FORCE)
> @@ -131,6 +146,6 @@ $(SRCDIR) : $(_FORCE)
>    mkdir -p $@
>
> $(SRCTAR) : default $(SRCDIR)
> -    $(MAKE) source-link
> +    $(Q)$(MAKE) $(MAKEOPTS) source-link
>    unset TAPE; $(TAR) -cf - $(SRCDIR) | $(ZIP) --best > $@ && \
>    echo Wrote: $@
> diff --git a/doc/Makefile b/doc/Makefile
> index 8f65b66..86ac2ca 100644
> --- a/doc/Makefile
> +++ b/doc/Makefile
> @@ -13,7 +13,8 @@ default: CHANGES.gz
> include $(BUILDRULES)
>
> CHANGES.gz:
> -    $(ZIP) --best -c < CHANGES > $@
> +    @echo "    [ZIP]    $@"
> +    $(Q)$(ZIP) --best -c < CHANGES > $@
>
> install: default
>    $(INSTALL) -m 755 -d $(PKG_DOC_DIR)
> diff --git a/include/Makefile b/include/Makefile
> index d89480e..bc787db 100644
> --- a/include/Makefile
> +++ b/include/Makefile
> @@ -43,7 +43,8 @@ LDIRT = xfs disk
> default install: xfs disk
>
> xfs disk:
> -    $(LN_S) . $@
> +    @echo "    [LN]     $@"
> +    $(Q)$(LN_S) . $@
>
> include $(BUILDRULES)
>
> diff --git a/include/buildmacros b/include/buildmacros
> index 099570f..62babca 100644
> --- a/include/buildmacros
> +++ b/include/buildmacros
> @@ -13,7 +13,7 @@ LDFLAGS += $(LOADERFLAGS) $(LLDFLAGS)
> LTLDFLAGS += $(LOADERFLAGS)
> LDLIBS = $(LLDLIBS) $(PLDLIBS) $(MALLOCLIB)
>
> -MAKEOPTS = --no-print-directory
> +MAKEOPTS = --no-print-directory Q=$(Q)
> SRCFILES = Makefile $(HFILES) $(CFILES) $(LSRCFILES) $(LFILES) $ 
> (YFILES)
> SRCFILES += $(QAHFILES)
>
> @@ -45,10 +45,10 @@ LIBNAME = $(basename $(LTLIBRARY))
> LTOBJECTS = $(OBJECTS:.o=.lo)
> LTVERSION = $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)
>
> -LTLINK = $(LIBTOOL) --tag=CC --mode=link $(CC)
> -LTEXEC = $(LIBTOOL) --mode=execute
> -LTINSTALL = $(LIBTOOL) --mode=install $(INSTALL)
> -LTCOMPILE = $(LIBTOOL) --tag=CC --mode=compile $(CCF)
> +LTLINK = $(LIBTOOL) --quiet --tag=CC --mode=link $(CC)
> +LTEXEC = $(LIBTOOL) --quiet --mode=execute
> +LTINSTALL = $(LIBTOOL) --quiet --mode=install $(INSTALL)
> +LTCOMPILE = $(LIBTOOL) --quiet --tag=CC --mode=compile $(CCF)
>
> ifeq ($(ENABLE_SHARED),yes)
> LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)
> diff --git a/include/buildrules b/include/buildrules
> index a06d480..464dfe3 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -7,10 +7,11 @@ _BUILDRULES_INCLUDED_ = 1
> include $(TOPDIR)/include/builddefs
>
> clean clobber : $(addsuffix -clean,$(SUBDIRS))
> -    rm -f $(DIRT)
> -    rm -fr $(DIRDIRT)
> +    $(Q)rm -f $(DIRT)
> +    $(Q)rm -fr $(DIRDIRT)
> %-clean:
> -    $(MAKE) -C $* clean
> +    @echo "Cleaning $*"
> +    $(Q)$(MAKE) $(MAKEOPTS) -C $* clean
>
> # Never blow away subdirs
> ifdef SUBDIRS
> @@ -18,7 +19,8 @@ ifdef SUBDIRS
> .PHONY: $(SUBDIRS)
>
> $(SUBDIRS):
> -    $(MAKE) -C $@
> +    @echo "Building $@"
> +    $(Q)$(MAKE) $(MAKEOPTS) -q -C $@ || $(MAKE) $(MAKEOPTS) -C $@
> endif
>
> source-link:
> @@ -38,20 +40,29 @@ source-link:
>
> ifdef LTCOMMAND
> $(LTCOMMAND) : $(SUBDIRS) $(OBJECTS) $(LTDEPENDENCIES)
> -    $(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
> +    @echo "    [LD]     $@"
> +    $(Q)$(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
> endif
>
> ifdef LTLIBRARY
> $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
> -    $(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
> +    @echo "    [LD]     $@"
> +    $(Q)$(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
>
> %.lo: %.c
> -    $(LTCOMPILE) -c $<
> +    @echo "    [CC]     $@"
> +    $(Q)$(LTCOMPILE) -c $<
> +else
> +%.o: %.c
> +    @echo "    [CC]     $@"
> +    $(Q)$(CC) $(CFLAGS) -c $<
> +
> endif
>
> ifdef POTHEAD
> $(POTHEAD): $(XGETTEXTFILES)
> -    $(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $ 
> (XGETTEXTFILES)
> +    @echo "    [GETTXT] $@"
> +    $(Q)$(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $ 
> (XGETTEXTFILES)
>
> # Update translations
> update-po: $(POTHEAD) $(wildcard $(TOPDIR)/po/*.po)
> @@ -70,7 +81,8 @@ update-po: $(POTHEAD) $(wildcard $(TOPDIR)/po/*.po)
>    done
>
> %.mo: %.po
> -    $(MSGFMT) -c --statistics -o $@ $<
> +    @echo "    [MSGFMT] $@"
> +    $(Q)$(MSGFMT) -c --statistics -o $@ $<
> endif
>
> endif # _BUILDRULES_INCLUDED_
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 9fcadf2..a749262 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -36,7 +36,8 @@ endif
> include $(BUILDRULES)
>
> $(FSTYP):
> -    $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $(PLDLIBS)
> +    @echo "    [CC]     $@"
> +    $(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $ 
> (PLDLIBS)
>
> install: default
>    $(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
> -- 
> 1.6.5
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
