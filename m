Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32854 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934677AbeCGUd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 15:33:58 -0500
Date: Wed, 7 Mar 2018 12:33:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/16] xfs_info: move to xfs_spaceman
Message-ID: <20180307203350.GW18989@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993167183.22223.13501751102361596724.stgit@magnolia>
 <6cc21a4a-7936-eb7c-c655-1a5c826f7f07@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc21a4a-7936-eb7c-c655-1a5c826f7f07@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org

On Tue, Mar 06, 2018 at 09:50:09PM -0600, Eric Sandeen wrote:
> On 3/1/18 1:14 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move xfs_info to be under spaceman so that we can remove growfs -N.
> 
> A while back we made xfs_growfs/ xfs_info fail on not-mount-points:
> 
> [root@localhost sandeen]# touch file
> 
> file not on xfs:
> 
> [root@localhost sandeen]# xfs_info file
> xfs_info: specified file ["/"] is not on an XFS filesystem
> 
> file on xfs,  not mounpoint:
> 
> [root@localhost sandeen]# xfs_info mnt/foo
> xfs_info: mnt/foo is not a mounted XFS filesystem
> 
> now if we point at a file not on xfs:
> 
> # ./spaceman/xfs_spaceman -c info /tmp/foo 
> XFS_IOC_FSGEOMETRY: Inappropriate ioctl for device
> (we lost the friendly failure string)
> 
> if we point at a file that's on xfs but is not a mountpoint:
> 
> # ./spaceman/xfs_spaceman -c info foo

So this raises some theoretical issues.  Right now spaceman applies its
management to whatever fs backs the inode that we opened from the cli
arguments.  If this will be the only scope forever and ever then we
could require that the pathnames on the cli actually be mountpoints and
enforce with the same mntent parsing that scrub/fsr currently use.

Will we ever want to be able to perform space management on specific
files?  I don't know that we do, but I also don't think we want to trade
away that option.

I think I'd rather change the info command to require a mount point, and
maybe that will just be a quirk of the info command.

> meta-data=/dev/sdc1              isize=256    agcount=4, agsize=61047598 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
> ...
> 
> we get the underlying geometry.
> 
> Given that we now have tools which /can/ deal directly with image files,
> I think that spaceman itself should probably continue to reject such requests
> for image files, lest the user get the underlying geometry instead of the
> image info as might have been hoped for...
> 
> but we really need a better way to determine "is this an xfs mountpoint"

It occurs to me that the manpage for info and growfs both say "mount
point", not "root directory of an xfs filesystem".  Since we can bind
mount anything anywhere on Linux, what does that even mean?

If I do:

# mount /dev/sda1 /home
# mount /home/djwong/foo /opt --bind
# xfs_info /opt

Should that succeed?  The manpage would seem to say yes.  Maybe it's
just time to hoist the mountpoint check code to libfrog and rework
scrub/fsr/spaceman to use it.

--D

> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  growfs/Makefile      |    2 --
> >  growfs/xfs_info.sh   |   32 --------------------------------
> >  spaceman/Makefile    |    2 ++
> >  spaceman/init.c      |    5 ++++-
> >  spaceman/xfs_info.sh |   32 ++++++++++++++++++++++++++++++++
> >  5 files changed, 38 insertions(+), 35 deletions(-)
> >  delete mode 100755 growfs/xfs_info.sh
> >  create mode 100755 spaceman/xfs_info.sh
> > 
> > 
> > diff --git a/growfs/Makefile b/growfs/Makefile
> > index f0190e4..adcd84b 100644
> > --- a/growfs/Makefile
> > +++ b/growfs/Makefile
> > @@ -20,7 +20,6 @@ endif
> >  
> >  LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD) $(LIBFROG)
> >  LLDFLAGS = -static-libtool-libs
> > -LSRCFILES = xfs_info.sh
> >  
> >  default: depend $(LTCOMMAND)
> >  
> > @@ -29,7 +28,6 @@ include $(BUILDRULES)
> >  install: default
> >  	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> >  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
> > -	$(INSTALL) -m 755 xfs_info.sh $(PKG_SBIN_DIR)/xfs_info
> >  install-dev:
> >  
> >  -include .dep
> > diff --git a/growfs/xfs_info.sh b/growfs/xfs_info.sh
> > deleted file mode 100755
> > index b85f120..0000000
> > --- a/growfs/xfs_info.sh
> > +++ /dev/null
> > @@ -1,32 +0,0 @@
> > -#!/bin/sh -f
> > -#
> > -# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
> > -#
> > -
> > -OPTS=""
> > -USAGE="Usage: xfs_info [-V] [-t mtab] mountpoint"
> > -
> > -while getopts "t:V" c
> > -do
> > -	case $c in
> > -	t)	OPTS="-t $OPTARG" ;;
> > -	V)	xfs_growfs -p xfs_info -V
> > -		status=$?
> > -		exit $status
> > -		;;
> > -	*)	echo $USAGE 1>&2
> > -		exit 2
> > -		;;
> > -	esac
> > -done
> > -set -- extra "$@"
> > -shift $OPTIND
> > -case $# in
> > -	1)	xfs_growfs -p xfs_info -n $OPTS "$1"
> > -		status=$?
> > -		;;
> > -	*)	echo $USAGE 1>&2
> > -		exit 2
> > -		;;
> > -esac
> > -exit $status
> > diff --git a/spaceman/Makefile b/spaceman/Makefile
> > index c1d903b..0d5ae2d 100644
> > --- a/spaceman/Makefile
> > +++ b/spaceman/Makefile
> > @@ -8,6 +8,7 @@ include $(TOPDIR)/include/builddefs
> >  LTCOMMAND = xfs_spaceman
> >  HFILES = init.h space.h
> >  CFILES = info.c init.c file.c prealloc.c trim.c
> > +LSRCFILES = xfs_info.sh
> >  
> >  LLDLIBS = $(LIBXCMD) $(LIBFROG)
> >  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
> > @@ -35,6 +36,7 @@ include $(BUILDRULES)
> >  install: default
> >  	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> >  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
> > +	$(INSTALL) -m 755 xfs_info.sh $(PKG_SBIN_DIR)/xfs_info
> >  install-dev:
> >  
> >  -include .dep
> > diff --git a/spaceman/init.c b/spaceman/init.c
> > index 895504f..91c773f 100644
> > --- a/spaceman/init.c
> > +++ b/spaceman/init.c
> > @@ -81,11 +81,14 @@ init(
> >  	textdomain(PACKAGE);
> >  
> >  	fs_table_initialise(0, NULL, 0, NULL);
> > -	while ((c = getopt(argc, argv, "c:V")) != EOF) {
> > +	while ((c = getopt(argc, argv, "c:p:V")) != EOF) {
> >  		switch (c) {
> >  		case 'c':
> >  			add_user_command(optarg);
> >  			break;
> > +		case 'p':
> > +			progname = optarg;
> > +			break;
> >  		case 'V':
> >  			printf(_("%s version %s\n"), progname, VERSION);
> >  			exit(0);
> > diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
> > new file mode 100755
> > index 0000000..5df0a26
> > --- /dev/null
> > +++ b/spaceman/xfs_info.sh
> > @@ -0,0 +1,32 @@
> > +#!/bin/sh -f
> > +#
> > +# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
> > +#
> > +
> > +OPTS=""
> > +USAGE="Usage: xfs_info [-V] [-t mtab] mountpoint"
> > +
> > +while getopts "t:V" c
> > +do
> > +	case $c in
> > +	t)	OPTS="-t $OPTARG" ;;
> > +	V)	xfs_spaceman -p xfs_info -V
> > +		status=$?
> > +		exit $status
> > +		;;
> > +	*)	echo $USAGE 1>&2
> > +		exit 2
> > +		;;
> > +	esac
> > +done
> > +set -- extra "$@"
> > +shift $OPTIND
> > +case $# in
> > +	1)	xfs_spaceman -p xfs_info -c "info" $OPTS "$1"
> > +		status=$?
> > +		;;
> > +	*)	echo $USAGE 1>&2
> > +		exit 2
> > +		;;
> > +esac
> > +exit $status
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
