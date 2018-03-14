Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34874 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933149AbeCNDVv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Mar 2018 23:21:51 -0400
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
References: <20180313205911.26082-1-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <44fa85af-7d59-9909-20e4-c8351f630fb4@sandeen.net>
Date: Tue, 13 Mar 2018 23:21:48 -0400
MIME-Version: 1.0
In-Reply-To: <20180313205911.26082-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu

On 3/13/18 4:59 PM, Luis R. Rodriguez wrote:
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
> different types of configuration files, if none is specified we look for
> the default type, /etc/mkfs.xfs.d/default, and you can override with -T.
> For instance, if you specify:
> 
> 	mkfs.xfs -T experimental -f /dev/loop0

Ok, since you have to fix it all anyway, can we please use "-c" for config
instead of "-T" for type?  Because that's confusing w/ mkfs's '-t' for
the filesystem type, and mke2fs's -t for *cough* fs-type ... this isn't
a type (xfs,ext4,msdos,f2fs) and it's not an fs-type ala mke2fs
(PTSD from big/huge/largefile/largefile4 ... I really don't want
The Internet to start writing config files for a "webserver" type for
xfs.  Can we just call them 'configs'?)

> The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> file. If you really need to override the full path of the configuration
> file you may use the MKFS_XFS_CONFIG environment variable.
> 
> To use /etc/ be sure to configure xfsprogs with:
> 
>  ./configure --sysconfdir=/etc/

surely this should be made default?

> To verify what configuration file is used on a system use the typical:
> 
>   mkfs.xfs -N

Nitpick: -N by itself is not valid, it's treated as an error.
When it does get a config file, IMHO it should give its name, not just
"custom configuration file"

> There is only a subset of options allowed to be set on the configuration
> file, 

I think this is problematic - allowing only booleans is pretty
arbitrary.

> and currently only 1 or 0 are acceptable values. The default
> parameters you can override on a configuration file and their current
> built-in default settings are:
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
> 
> We have floated around enough bike shedding emails to have at least reached
> a consensus on the fact that we'd be only supporting a mimimum set of default
> parameters and would strive to simplify our parser as much as possible.

See above - sorry for not chiming in sooner, but I don't think an arbitrary
restriction to the boolean options will be sufficient in the long run.

...
snip
...

> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 7a2a62686717..231c96196ab9 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -63,6 +63,7 @@ PKG_LIB_DIR	= @libdir@@libdirsuffix@
>  PKG_INC_DIR	= @includedir@/xfs
>  DK_INC_DIR	= @includedir@/disk
>  PKG_MAN_DIR	= @mandir@
> +PKG_ETC_DIR	= @sysconfdir@
>  PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
>  PKG_LOCALE_DIR	= @datadir@/locale
>  
> @@ -194,6 +195,7 @@ endif
>  
>  GCFLAGS = $(DEBUG) \
>  	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
> +	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
>  	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
>  
>  ifeq ($(ENABLE_GETTEXT),yes)
> diff --git a/man/man5/mkfs.xfs.d.5 b/man/man5/mkfs.xfs.d.5
> new file mode 100644
> index 000000000000..89fd28c79139
> --- /dev/null
> +++ b/man/man5/mkfs.xfs.d.5
> @@ -0,0 +1,121 @@
> +.TH mkfs.xfs.d 5
> +.SH NAME
> +mkfs.xfs.d \- mkfs.xfs configuration directory

IMHO this is all far too wordy, will put my editor hat on later.


<snip>

> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c37806..18489b3a19ff 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -83,6 +83,23 @@ and
>  .B \-l internal \-l size=10m
>  are equivalent.
>  .PP
> +An optional XFS configuration type file directory
> +.B mkfs.xfs.d (5)
> +exists to help fine tune default parameters which can be used when calling
> +.B mkfs.xfs (8), by default type will be used by default, /etc/mkfs.xfs.d/default.

Optional mkfs.xfs configuration files may be stored in mkfs.xfs.d,
which may be used to override built-in mkfs.xfs default parameters.

> +Command line arguments directly passed to

drop "directly," commandline args are area always "directly" passed.

> +.B mkfs.xfs (8)
> +will always override parameters set it the configuration type file.

drop "type."

> +You can override configuration file type on the
> +.B mkfs.xfs.d (5)
> +directory by using the -t parameter and secifying the type.

A config file may be selected with the -c option as described below.

> Alternatively
> +you can set and use the MKFS_XFS_CONFIG environment variable to override
> +the default full path of the first file
> +.B mkfs.xfs (8)
> +looks for.

(How do you envision this env var being used?  How is this better than
simply allowing -t to specify a full path?)

> +If you use -t the type configuration file must be present under
> +.B mkfs.xfs.d (8).

Hm I'll try to wordsmith all this as well.

> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1ca6a2d148c4..e66330a50b68 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -21,7 +21,11 @@
>  #include "xfs_multidisk.h"
>  #include "libxcmd.h"
>  
> -
> +#define MKFS_XFS_CONF_DIR	ROOT_SYSCONFDIR "/mkfs.xfs.d/"
> +#define CONFIG_MAX_KEY		1024
> +#define CONFIG_MAX_VALUE	PATH_MAX
> +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> +#define PARAM_OPTS		"T:b:d:i:l:L:m:n:KNp:qr:s:CfV"

what dave said ;)

also re: what dave said - functioning properly only if -t/-T/-c is given
first on the commandline is a little odd, though it makes some semantic
sense to specify a config file first then additional options so I can
live with it, I think.

But it really must then fail, as opposed to silently ignoring it,
if the option comes later.

<snip wow a whole lot of lines to parse the configfile>

Ok, so my configfile-containing-actual-commandlines was shot down,
but I'm a bit dismayed at the LOC required to re-parse the configfile,
especially when it's not even handling all options....

I'll have to take more time to review the bulk of the code, but the
behavioral issues above need to be addressed I think.

-Eric
