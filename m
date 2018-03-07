Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54202 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754086AbeCGDuL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 22:50:11 -0500
Subject: Re: [PATCH 14/16] xfs_info: move to xfs_spaceman
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993167183.22223.13501751102361596724.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6cc21a4a-7936-eb7c-c655-1a5c826f7f07@sandeen.net>
Date: Tue, 6 Mar 2018 21:50:09 -0600
MIME-Version: 1.0
In-Reply-To: <151993167183.22223.13501751102361596724.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

On 3/1/18 1:14 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move xfs_info to be under spaceman so that we can remove growfs -N.

A while back we made xfs_growfs/ xfs_info fail on not-mount-points:

[root@localhost sandeen]# touch file

file not on xfs:

[root@localhost sandeen]# xfs_info file
xfs_info: specified file ["/"] is not on an XFS filesystem

file on xfs,  not mounpoint:

[root@localhost sandeen]# xfs_info mnt/foo
xfs_info: mnt/foo is not a mounted XFS filesystem

now if we point at a file not on xfs:

# ./spaceman/xfs_spaceman -c info /tmp/foo 
XFS_IOC_FSGEOMETRY: Inappropriate ioctl for device
(we lost the friendly failure string)

if we point at a file that's on xfs but is not a mountpoint:

# ./spaceman/xfs_spaceman -c info foo
meta-data=/dev/sdc1              isize=256    agcount=4, agsize=61047598 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
...

we get the underlying geometry.

Given that we now have tools which /can/ deal directly with image files,
I think that spaceman itself should probably continue to reject such requests
for image files, lest the user get the underlying geometry instead of the
image info as might have been hoped for...

but we really need a better way to determine "is this an xfs mountpoint"

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  growfs/Makefile      |    2 --
>  growfs/xfs_info.sh   |   32 --------------------------------
>  spaceman/Makefile    |    2 ++
>  spaceman/init.c      |    5 ++++-
>  spaceman/xfs_info.sh |   32 ++++++++++++++++++++++++++++++++
>  5 files changed, 38 insertions(+), 35 deletions(-)
>  delete mode 100755 growfs/xfs_info.sh
>  create mode 100755 spaceman/xfs_info.sh
> 
> 
> diff --git a/growfs/Makefile b/growfs/Makefile
> index f0190e4..adcd84b 100644
> --- a/growfs/Makefile
> +++ b/growfs/Makefile
> @@ -20,7 +20,6 @@ endif
>  
>  LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
> -LSRCFILES = xfs_info.sh
>  
>  default: depend $(LTCOMMAND)
>  
> @@ -29,7 +28,6 @@ include $(BUILDRULES)
>  install: default
>  	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
> -	$(INSTALL) -m 755 xfs_info.sh $(PKG_SBIN_DIR)/xfs_info
>  install-dev:
>  
>  -include .dep
> diff --git a/growfs/xfs_info.sh b/growfs/xfs_info.sh
> deleted file mode 100755
> index b85f120..0000000
> --- a/growfs/xfs_info.sh
> +++ /dev/null
> @@ -1,32 +0,0 @@
> -#!/bin/sh -f
> -#
> -# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
> -#
> -
> -OPTS=""
> -USAGE="Usage: xfs_info [-V] [-t mtab] mountpoint"
> -
> -while getopts "t:V" c
> -do
> -	case $c in
> -	t)	OPTS="-t $OPTARG" ;;
> -	V)	xfs_growfs -p xfs_info -V
> -		status=$?
> -		exit $status
> -		;;
> -	*)	echo $USAGE 1>&2
> -		exit 2
> -		;;
> -	esac
> -done
> -set -- extra "$@"
> -shift $OPTIND
> -case $# in
> -	1)	xfs_growfs -p xfs_info -n $OPTS "$1"
> -		status=$?
> -		;;
> -	*)	echo $USAGE 1>&2
> -		exit 2
> -		;;
> -esac
> -exit $status
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> index c1d903b..0d5ae2d 100644
> --- a/spaceman/Makefile
> +++ b/spaceman/Makefile
> @@ -8,6 +8,7 @@ include $(TOPDIR)/include/builddefs
>  LTCOMMAND = xfs_spaceman
>  HFILES = init.h space.h
>  CFILES = info.c init.c file.c prealloc.c trim.c
> +LSRCFILES = xfs_info.sh
>  
>  LLDLIBS = $(LIBXCMD) $(LIBFROG)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
> @@ -35,6 +36,7 @@ include $(BUILDRULES)
>  install: default
>  	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
> +	$(INSTALL) -m 755 xfs_info.sh $(PKG_SBIN_DIR)/xfs_info
>  install-dev:
>  
>  -include .dep
> diff --git a/spaceman/init.c b/spaceman/init.c
> index 895504f..91c773f 100644
> --- a/spaceman/init.c
> +++ b/spaceman/init.c
> @@ -81,11 +81,14 @@ init(
>  	textdomain(PACKAGE);
>  
>  	fs_table_initialise(0, NULL, 0, NULL);
> -	while ((c = getopt(argc, argv, "c:V")) != EOF) {
> +	while ((c = getopt(argc, argv, "c:p:V")) != EOF) {
>  		switch (c) {
>  		case 'c':
>  			add_user_command(optarg);
>  			break;
> +		case 'p':
> +			progname = optarg;
> +			break;
>  		case 'V':
>  			printf(_("%s version %s\n"), progname, VERSION);
>  			exit(0);
> diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
> new file mode 100755
> index 0000000..5df0a26
> --- /dev/null
> +++ b/spaceman/xfs_info.sh
> @@ -0,0 +1,32 @@
> +#!/bin/sh -f
> +#
> +# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +
> +OPTS=""
> +USAGE="Usage: xfs_info [-V] [-t mtab] mountpoint"
> +
> +while getopts "t:V" c
> +do
> +	case $c in
> +	t)	OPTS="-t $OPTARG" ;;
> +	V)	xfs_spaceman -p xfs_info -V
> +		status=$?
> +		exit $status
> +		;;
> +	*)	echo $USAGE 1>&2
> +		exit 2
> +		;;
> +	esac
> +done
> +set -- extra "$@"
> +shift $OPTIND
> +case $# in
> +	1)	xfs_spaceman -p xfs_info -c "info" $OPTS "$1"
> +		status=$?
> +		;;
> +	*)	echo $USAGE 1>&2
> +		exit 2
> +		;;
> +esac
> +exit $status
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
