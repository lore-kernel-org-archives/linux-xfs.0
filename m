Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48664 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfF1Vuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 17:50:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SLneog162765
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 21:50:37 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t9c9q7n9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 21:50:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SLo1Ji159068
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 21:50:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t99f5t4f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 21:50:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5SLoaQh012808
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 21:50:36 GMT
Date: Fri, 28 Jun 2019 13:51:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: mysterious test failure when running xfstests on XFS
Message-ID: <20190628205154.GF5179@magnolia>
References: <20190628202117.GA15307@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628202117.GA15307@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>

On Fri, Jun 28, 2019 at 04:21:17PM -0400, Theodore Ts'o wrote:
> When trying to make sure a change to a test works on other file
> systems, I noticed the failure:
> 
> xfs_db: error - read only 0 of 32768 bytes
> xfs_db: /tmp/1577.img is invalid (cannot read first 512 bytes)
> 
> When I tried tracking down where this failure was coming from, I found
> this:
> 
> ++ export 'XFS_IO_PROG=/root/xfstests/bin/xfs_io -i'
> ++ XFS_IO_PROG='/root/xfstests/bin/xfs_io -i'
> ++ '[' xfs == xfs ']'
> ++ touch /tmp/10216.img
> ++ /root/xfstests/bin/mkfs.xfs -d file,name=/tmp/10216.img,size=512m
> ++ /root/xfstests/bin/xfs_db -x -c 'uuid generate' /tmp/10216.img
> ++ grep -q 'invalid UUID\|supported on V5 fs'
> xfs_db: error - read only 0 of 32768 bytes
> xfs_db: /tmp/10216.img is invalid (cannot read first 512 bytes)
> ++ rm -f /tmp/10216.img
> 
> Apparently the issue is that the mkfs.xfs is failing, but in init_rc
> we redirect the output to /dev/null:
> 
> 		touch /tmp/$$.img
> 		$MKFS_XFS_PROG -d file,name=/tmp/$$.img,size=512m >/dev/null 2>&1
> 		# xfs_db will return 0 even if it can't generate a new uuid, so
> 		# check the output to make sure if it can change UUID of V5 xfs
> 		$XFS_DB_PROG -x -c "uuid generate" /tmp/$$.img \
> 			| grep -q "invalid UUID\|supported on V5 fs" \
> 			&& export XFS_COPY_PROG="$XFS_COPY_PROG -d"
> 		rm -f /tmp/$$.img
> 
> From a test script:
> 
> rm -f $IMAGE
> + rm -f /tmp/10216.img
> touch $IMAGE
> + touch /tmp/10216.img
> ./xfsprogs-dev/mkfs/mkfs.xfs  -d file,name=$IMAGE,size=512m
> + ./xfsprogs-dev/mkfs/mkfs.xfs -d file,name=/tmp/10216.img,size=512m
> mkfs.xfs: Use the -f option to force overwrite.

Hmmm, mkfs.xfs always requires -f if it was built without blkid since it
then won't have the ability to determine if there's already a filesystem
on the device you're trying to format.  Was your xfsprogs was built
without blkid?

$ strings /opt/root/xfstests/bin/mkfs.xfs | grep blkid
$ ldd /opt/root/xfstests/bin/mkfs.xfs
        not a dynamic executable

Yep.  Rummaging through the xfstests-bld repo... aha!

     export LOCAL_CONFIGURE_OPTIONS="$cross --prefix=/ --disable-lib64 --disable-gettext --disable-libicu --disable-blkid" ; \

/me traces it to this commit:

24c24367f36a36 ("build-all: disable blkid when building xfsprogs")

2019-02-19, I guess nobody's updated their xfstests-bld repos since
before then; I certainly hadn't. :)

Hmm... these days xfsprogs really wants to be built with libblkid since
(a) that's the configuration that most distros ship and (b) some of the
online utilities (like xfs_scrub) really /do/ want blkid information to
try to guess the level of parallelism of the device.

What's less clear is how to proceed from here -- should kvm-xfstests
download and build upstream libblkid and then point the xfsprogs build
at it?

I suppose we could change xfstests to detect if mkfs isn't linked
against libblkid and inject a "-f" into XFS_MKFS_PROG, though that could
cause other problems with tests that might not be expecting non-force
mode.

--D

> 
> A simple way to reproduce this:
> 
> 1)  Download the root_fs.img.amd64:
> 
> https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/root_fs.img.amd64
> 
> 2)  Run the command:
> 
> 	kvm-xfstests -I /tmp/root_fs.img.amd64 -c xfs generic/001
> 
> 3)  Observe the failure:
> 
> generic/001 2s ... 	[16:15:48][    5.187808] run fstests generic/001 at 2019-06-28 16:15:48
>  [16:15:51]- output mismatch (see /results/xfs/results-4k/generic/001.out.bad)
>     --- tests/generic/001.out	2019-06-10 00:02:54.000000000 -0400
>     +++ /results/xfs/results-4k/generic/001.out.bad	2019-06-28 16:15:51.631596912 -0400
>     @@ -1,4 +1,6 @@
>      QA output created by 001
>     +xfs_db: error - read only 0 of 32768 bytes
>     +xfs_db: /tmp/1577.img is invalid (cannot read first 512 bytes)
>      cleanup
>      setup ....................................
>      iter 1 chain ... check ....................................
>     ...
>     (Run 'diff -u /root/xfstests/tests/generic/001.out /results/xfs/results-4k/generic/001.out.bad'  to)
> Ran: generic/001
> Failures: generic/001
> 
> I know this used to work, but I'm not sure at what point this started
> failing for me.   Is there anything obvious?
> 
> 
> 						- Ted
