Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0AN0flt011830 for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 17:00:45 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 951B817CBD2F
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 12:29:51 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ppETDXidzXuF6Amv for
	<xfs@oss.sgi.com>; Sat, 10 Jan 2009 12:29:51 -0800 (PST)
Message-ID: <4969053E.2060903@sandeen.net>
Date: Sat, 10 Jan 2009 14:29:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add test 199, bad_features2 correction
References: <20090103205309.GB20346@infradead.org>
In-Reply-To: <20090103205309.GB20346@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Index: xfstests-dev/199
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/199	2009-01-03 20:36:06.000000000 +0000
> @@ -0,0 +1,65 @@
> +#! /bin/sh
> +# FS QA Test No. 199
> +#
> +# Check that a filesystem first mounted read-only and then remounted
> +# performs the features2 fixup properly.

Seems fine.  Would it be worth adding a few more lines to also test that
a simple rw mount (w/o going through ro first) also properly fixes it?

-Eric

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2008 Christoph Hellwig.
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=hch@lst.de
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	cd /
> +	umount $SCRATCH_MNT >/dev/null 2>&1
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_scratch
> +
> +_scratch_mkfs_xfs >/dev/null 2>&1
> +
> +#
> +# Print the current flags.  Just a dummy so that the test breaks
> +# in an obvious way when the default feature flags changed in mkfs
> +#
> +echo "Default feature2 flags:"
> +xfs_db -x $SCRATCH_DEV -c 'sb' -c 'print features2'
> +xfs_db -x $SCRATCH_DEV -c 'sb' -c 'print bad_features2'
> +
> +#
> +# Now clear the normal flags
> +#
> +echo "Clearing features2:"
> +xfs_db -x $SCRATCH_DEV -c 'sb' -c 'write features2 0'
> +
> +#
> +# And print the flags after a mount ro and remount rw
> +_scratch_mount -o ro
> +_scratch_mount -o remount,rw
> +umount $SCRATCH_MNT
> +echo "Features 2 after mount ro and remount rw:"
> +xfs_db -x $SCRATCH_DEV -c 'sb' -c 'print features2'
> +
> +# success, all done
> +echo "*** done"
> +rm -f $seq.full
> +status=0
> Index: xfstests-dev/group
> ===================================================================
> --- xfstests-dev.orig/group	2009-01-03 20:24:09.000000000 +0000
> +++ xfstests-dev/group	2009-01-03 20:24:48.000000000 +0000
> @@ -300,3 +300,4 @@
>  195 ioctl dump auto
>  196 quota auto
>  197 dir auto
> +199 mount auto
> Index: xfstests-dev/199.out
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/199.out	2009-01-03 20:46:08.000000000 +0000
> @@ -0,0 +1,9 @@
> +QA output created by 199
> +Default feature2 flags:
> +features2 = 0x8
> +bad_features2 = 0x8
> +Clearing features2:
> +features2 = 0
> +Features 2 after mount ro and remount rw:
> +features2 = 0x8
> +*** done
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
