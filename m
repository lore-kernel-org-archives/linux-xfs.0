Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40278 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbeECVs2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 17:48:28 -0400
Date: Thu, 3 May 2018 14:48:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/9] xfs_info: move to xfs_spaceman
Message-ID: <20180503214803.GD26569@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401957530.13048.12736391147882277807.stgit@magnolia>
 <e47b3348-d036-4d83-fc61-fd42ab385ba7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e47b3348-d036-4d83-fc61-fd42ab385ba7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 04:17:00PM -0500, Eric Sandeen wrote:
> On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move xfs_info to be under spaceman so that we can remove growfs -N.
> 
> Seems ok in general, though how will this work with Dave's upcoming
> special subvol-files-no-they're-devices-no-they're-files?
> 
> Do we worry about all that later?  I guess?

I think we can worry about that later seeing as Dave hasn't posted
patches recently. :)

> (I guess we don't document -p as it's for internal use)
> 
> Modulo that concern,

FWIW this patch just moves xfs_info to use spaceman instead of growfs,
so I'll go blather about xfs_db/xfs_spaceman switcheroo in that patch.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> -Eric
> 
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
