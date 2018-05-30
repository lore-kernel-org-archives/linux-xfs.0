Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60536 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752854AbeE3DdI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 23:33:08 -0400
Subject: Re: [PATCH v4 3/4] mkfs.xfs: add configuration file parsing support
 using our own parser
References: <20180529220603.29420-1-mcgrof@kernel.org>
 <20180529220603.29420-4-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bf2052b1-91ae-3564-33fa-8cd029ab54f0@sandeen.net>
Date: Tue, 29 May 2018 22:33:04 -0500
MIME-Version: 1.0
In-Reply-To: <20180529220603.29420-4-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On 5/29/18 5:06 PM, Luis R. Rodriguez wrote:
> You may want to stick to specific set of configuration options when
> creating filesystems with mkfs.xfs -- sometimes due to pure technical
> reasons, but some other times to ensure systems remain compatible as
> new features are introduced with older kernels, or if you always want
> to take advantage of some new feature which would otherwise typically
> be disruptive.
> 
> This adds support for parsing a configuration file to override defaults
> parameters to be used for mkfs.xfs.
> 
> We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
> different configuration files, if none is specified we look for the
> default configuration file, /etc/mkfs.xfs.d/default. You can override
> with -c.  For instance, if you specify:
> 
> 	mkfs.xfs -c experimental -f /dev/loop0
> 
> The search path for the configuration file will be:
> 
> 	1) $PWD/experimental
> 	2) /etc/mkfs.xfs.d/experimental

by default this still lands in /usr/etc/mkfs.xfs.d - is there a way to
default to /etc ?  (see below)

> Absolute paths are supported, in which case they will be used directly
> and the mkfs.xfs.d directory is ignored.
> 
> To verify what configuration file is used on a system use the typical:
> 
>    mkfs.xfs -N
> 
> There is only a subset of options allowed to be set on the configuration
> file. The default parameters you can override on a configuration file and
> their current built-in default settings are:
> 
> [data]
> noalign=0
> 
> [inode]
> align=1
> projid32bit=1
> sparse=0
> 
> [log]
> lazy-count=1
> 
> [metadata]
> crc=1
> finobt=1
> rmapbt=0
> reflink=0
> 
> [naming]
> ftype=1
> 
> [rtdev]
> noalign=0
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>   configure.ac                           |   6 +-
>   include/builddefs.in                   |   2 +
>   man/man5/Makefile                      |   2 +
>   man/man5/mkfs.xfs.d.5.in               | 151 ++++++++
>   man/man8/Makefile                      |   2 +
>   man/man8/{mkfs.xfs.8 => mkfs.xfs.8.in} |  27 ++
>   mkfs/Makefile                          |   2 +-
>   mkfs/config.c                          | 645 +++++++++++++++++++++++++++++++++
>   mkfs/config.h                          |  10 +-
>   mkfs/xfs_mkfs.c                        |  76 +++-
>   10 files changed, 909 insertions(+), 14 deletions(-)
>   create mode 100644 man/man5/mkfs.xfs.d.5.in
>   rename man/man8/{mkfs.xfs.8 => mkfs.xfs.8.in} (96%)
>   create mode 100644 mkfs/config.c
> 
> diff --git a/configure.ac b/configure.ac
> index 508eefede073..94c5bda725f2 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -233,5 +233,9 @@ AC_CHECK_SIZEOF([char *])
>   AC_TYPE_UMODE_T
>   AC_MANUAL_FORMAT
>   
> -AC_CONFIG_FILES([include/builddefs])
> +AC_CONFIG_FILES([
> +	include/builddefs
> +	man/man5/mkfs.xfs.d.5
> +	man/man8/mkfs.xfs.8
> +])
>   AC_OUTPUT
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 8aac06cf90dc..e1ee9f7ba086 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -62,6 +62,7 @@ PKG_LIB_DIR	= @libdir@@libdirsuffix@
>   PKG_INC_DIR	= @includedir@/xfs
>   DK_INC_DIR	= @includedir@/disk
>   PKG_MAN_DIR	= @mandir@
> +PKG_ETC_DIR	= @sysconfdir@

can configure scripts somehow default this to /etc ?  I think this works:

diff --git a/configure.ac b/configure.ac
index 94c5bda..8f6c793 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,6 +6,8 @@ AC_CONFIG_SRCDIR([include/libxfs.h])
  AC_CONFIG_HEADER(include/platform_defs.h)
  AC_PREFIX_DEFAULT(/usr)
  
+test "$sysconfdir" = '${prefix}/etc' && sysconfdir=/etc
+
  AC_PROG_INSTALL
  AC_PROG_LIBTOOL

>   PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
>   PKG_LOCALE_DIR	= @datadir@/locale
>   
> @@ -196,6 +197,7 @@ endif
>   
>   GCFLAGS = $(DEBUG) \
>   	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
> +	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
>   	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
>   
>   ifeq ($(ENABLE_GETTEXT),yes)
> diff --git a/man/man5/Makefile b/man/man5/Makefile
> index fe0aef6f016b..0b33122b064e 100644
> --- a/man/man5/Makefile
> +++ b/man/man5/Makefile
> @@ -19,3 +19,5 @@ install : default
>   	$(INSTALL) -m 755 -d $(MAN_DEST)
>   	$(INSTALL_MAN)
>   install-dev :
> +
> +LDIRT += mkfs.xfs.d.5
> diff --git a/man/man5/mkfs.xfs.d.5.in b/man/man5/mkfs.xfs.d.5.in
> new file mode 100644
> index 000000000000..287877ce029d
> --- /dev/null
> +++ b/man/man5/mkfs.xfs.d.5.in
> @@ -0,0 +1,151 @@
> +.TH mkfs.xfs.d 5
> +.SH NAME
> +mkfs.xfs.d \- mkfs.xfs configuration directory
> +.SH DESCRIPTION
> +.B mkfs.xfs (8)

.BR mkfs.xfs (8)

so that it alternates bold/regular, similar fix for all instances below.

> +uses a set of initial default parameters for configuration.
> +
> +The built-in mkfs defaults are decided by the XFS community. New features are
> +only enabled by default when the community consider them stable.  One can
> +override these defaults on the
> +.B mkfs.xfs (8)
> +command line, but there are cases where it is desirable for the distro or the

colloquial, "distribution" please

(actually I'd like to edit this a lot still - maybe just leave it as is and
I'll take a crack at it)


...

> +look for the following configuration files and use the first one it finds:
> +.IP
> +.B $PWD/experimental
> +.br
> +.B @sysconfdir@/mkfs.xfs.d/experimental
> +.PP

This gets replaced as:

${prefix}/etc/mkfs.xfs.d/experimental

which is probably not as intended.  (though I think maybe my configure.ac
patch above makes that go away ...)

Anyway, I really still don't like this "look for the file in pwd by default"
thing.  I get it that a bare filename is technically a relative path, but
I still think this will lead to surprise, confusion, and sadness when a
similar filename just happens to exist in the hapless admin's $PWD.  I may
need to arm-wrestle dave over this.


> diff --git a/man/man8/Makefile b/man/man8/Makefile
> index 36620da172ae..2a6548079997 100644
> --- a/man/man8/Makefile
> +++ b/man/man8/Makefile
> @@ -19,3 +19,5 @@ install : default
>   	$(INSTALL) -m 755 -d $(MAN_DEST)
>   	$(INSTALL_MAN)
>   install-dev :
> +
> +LDIRT += mkfs.xfs.8
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8.in
> similarity index 96%
> rename from man/man8/mkfs.xfs.8
> rename to man/man8/mkfs.xfs.8.in
> index 4b8c78c37806..81e2753bd2b5 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8.in

-c should be added to the synopsis, yes?
The first mention of -c in this manpage is:

"If present, and if -c is not used" which is a very odd introduction.  ;)

> @@ -83,6 +83,24 @@ and
>   .B \-l internal \-l size=10m
>   are equivalent.
>   .PP
> +An optional XFS configuration file directory
> +.B mkfs.xfs.d (5)
> +exists to help fine tune different default parameters which can be used when
> +calling
> +.B mkfs.xfs (8).
> +If present, and if
> +.B -c
> +is not used, the default configuration file @sysconfigdir@/mkfs.xfs.d/default

s/sysconfigdir/sysconfdir/ or this won't get replaced.

...

> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index c84f9b6ae63b..c7815b3e106b 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
>   LTCOMMAND = mkfs.xfs
>   
>   HFILES =
> -CFILES = proto.c xfs_mkfs.c
> +CFILES = proto.c xfs_mkfs.c config.c
>   
>   LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
>   	$(LIBUUID)

... snip stuff i'll circle back to, sorry for being a bit rando ...

> +/*
> + * If the file is not found -1 is returned and errno set. Otherwise
> + * the file descriptor is returned.
> + */
> +int
> +open_cli_config(
> +	char			*cli_config_file,
> +	char			**fpath)
> +{
> +	int			fd, len;
> +	char			*final_path = NULL;
> +	char			*relative_path= NULL;
> +	unsigned int		i;
> +
> +	if (strlen(cli_config_file) > 2) {
> +		if (cli_config_file[0] == '.' && cli_config_file[1] == '/')
> +			final_path = cli_config_file;
> +		else if (cli_config_file[0] == '.' && cli_config_file[1] == '.')
> +			final_path = cli_config_file;
> +		else if (cli_config_file[0] == '/')
> +			final_path = cli_config_file;
> +		else
> +			relative_path = cli_config_file;
> +	} else if (strlen(cli_config_file) == 1) {
> +		if (cli_config_file[0] == '.' || cli_config_file[0] == '/') {
> +			errno = EINVAL;
> +			return -1;
> +		} else
> +			relative_path = cli_config_file;
> +	}

I mentioned the problem w/ strlen == 2; I also noticed that you can
point -c at i.e. /dev/sdb1 and it'll try to read it.  Dave suggested that
a stat and rejection of anything but a regular file is in order here.


bed();

will look more tomorrow.
