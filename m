Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n674ATtI124290 for <xfs@oss.sgi.com>; Mon, 6 Jul 2009 23:10:29 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E255D347997
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2009 21:11:03 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id RNHy0V5CwW65hsHE for
	<xfs@oss.sgi.com>; Mon, 06 Jul 2009 21:11:03 -0700 (PDT)
Message-ID: <4A52CAD6.1070807@sandeen.net>
Date: Mon, 06 Jul 2009 23:11:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add tests to check log size scaling
References: <20090705194111.GA3834@infradead.org>
In-Reply-To: <20090705194111.GA3834@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
> XFS-QA test to check that log size scaling works correctly
> for old and new maximum log sizes.
> 
> [hch: split into two testcases for old "small" log scaling and the
>  large logs that require recent xfsprogs, and reduce the maximum
>  size by 1GB to make it possible to run the test on 32 bit platforms]
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

minor question below

> 
> Index: xfstests-dev/216
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/216	2009-07-05 09:11:49.000000000 +0000
> @@ -0,0 +1,79 @@
> +#! /bin/sh
> +# FS QA Test No. 216
> +#
> +# log size mkfs test - ensure the log size scaling works for small filesystems
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=dgc@sgi.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +    _cleanup_testdir
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_setup_testdir
> +_require_scratch
> +_scratch_mkfs_xfs >/dev/null 2>&1
> +_scratch_mount

Any reason to do this on the scratch dir vs. the test dir?  (Since
scratch dir became optional, I figure stuff that can go on the test dev
instead, probably should?)

not a big deal, it looks fine otherwise.

-Eric

> +_require_loop
> +LOOP_DEV=$SCRATCH_MNT/test_fs
> +LOOP_MNT=$SCRATCH_MNT/test_fs_dir
> +
> +_do_mkfs()
> +{
> +	for i in $*; do
> +		echo -n "fssize=${i}g "
> +		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
> +			-d name=$LOOP_DEV,size=${i}g |grep log
> +		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
> +		echo "test write" > $LOOP_MNT/test
> +		umount $LOOP_MNT
> +	done
> +}
> +# make large holey file
> +$XFS_IO_PROG -f -c "truncate 256g" $LOOP_DEV
> +
> +#make loopback mount dir
> +mkdir $LOOP_MNT
> +
> +# walk over standard sizes (up to 256GB)
> +_do_mkfs 1 2 4 8 16 32 64 128 256
> +
> +status=0
> +exit
> Index: xfstests-dev/216.out
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/216.out	2009-07-05 09:07:36.000000000 +0000
> @@ -0,0 +1,10 @@
> +QA output created by 216
> +fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
> +fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
> +fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
> +fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
> +fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
> +fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
> +fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
> +fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
> Index: xfstests-dev/group
> ===================================================================
> --- xfstests-dev.orig/group	2009-07-04 18:07:55.000000000 +0000
> +++ xfstests-dev/group	2009-07-05 09:16:04.000000000 +0000
> @@ -324,3 +324,5 @@
>  213 rw auto prealloc quick
>  214 rw auto prealloc quick
>  215 auto metadata quick
> +216 log metadata auto quick
> +217 log metadata auto
> Index: xfstests-dev/217
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/217	2009-07-05 09:26:57.000000000 +0000
> @@ -0,0 +1,89 @@
> +#! /bin/sh
> +# FS QA Test No. 217
> +#
> +# large log size mkfs test - ensure the log size scaling works
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=dgc@sgi.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +    _cleanup_testdir
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_setup_testdir
> +_require_scratch
> +_scratch_mkfs_xfs >/dev/null 2>&1
> +_scratch_mount
> +
> +_require_loop
> +LOOP_DEV=$SCRATCH_MNT/test_fs
> +LOOP_MNT=$SCRATCH_MNT/test_fs_dir
> +
> +_do_mkfs()
> +{
> +	for i in $*; do
> +		echo -n "fssize=${i}g "
> +		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
> +			-d name=$LOOP_DEV,size=${i}g |grep log
> +		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
> +		echo "test write" > $LOOP_MNT/test
> +		umount $LOOP_MNT
> +	done
> +}
> +# make large holey file
> +$XFS_IO_PROG -f -c "truncate 16383g" $LOOP_DEV
> +
> +#make loopback mount dir
> +mkdir $LOOP_MNT
> +
> +# test if large logs are supported
> +$MKFS_XFS_PROG -f -l size=256m -d name=$LOOP_DEV,size=10g > /dev/null 2>&1
> +if [ $? -ne 0 ]; then
> +	_notrun "large log sizes not supported by mkfs"
> +fi
> +
> +#
> +# walk over "new" sizes supported by recent xfsprogs.
> +# Note that the last test is for 16TB-1GB as 32bit platforms only support
> +# device slightly smaller than 16TB.
> +#
> +_do_mkfs 512 1024 2048 4096 8192 16383
> +
> +status=0
> +exit
> Index: xfstests-dev/217.out
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/217.out	2009-07-05 09:20:17.000000000 +0000
> @@ -0,0 +1,7 @@
> +QA output created by 217
> +fssize=512g log      =internal log           bsize=4096   blocks=65536, version=2
> +fssize=1024g log      =internal log           bsize=4096   blocks=131072, version=2
> +fssize=2048g log      =internal log           bsize=4096   blocks=262144, version=2
> +fssize=4096g log      =internal log           bsize=4096   blocks=521728, version=2
> +fssize=8192g log      =internal log           bsize=4096   blocks=521728, version=2
> +fssize=16383g log      =internal log           bsize=4096   blocks=521728, version=2
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
