Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DHt6xM138593 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 12:55:06 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfstests: test 220: double inode free in xfs_dqrele_inode
Date: Tue, 13 Oct 2009 12:55:55 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AD9C@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091012235059.GA2318@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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

On , Christoph Hellwig wrote:
> Trivial test case that mounts a filesystem with user quotas, then turns
> quotas off an unmounts.  Based on a testcase in a bug report from
> Utako Kusaka <u-kusaka@wm.jp.nec.com>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>
 
> Index: xfstests-dev/220
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/220	2009-10-12 23:49:43.000000000 +0000
> @@ -0,0 +1,71 @@
> +#! /bin/sh
> +# FS QA Test No. 220
> +#
> +# Test that turning quotas off on a mounted filesystem doesn't crash
> +# the system.
> +#
> +# Based on a bug report from Utako Kusaka <u-kusaka@wm.jp.nec.com>.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2009 Christoph Hellwig.  All Rights Reserved.
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
> +#
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
> +	umount $SCRATCH_DEV >/dev/null 2>&1
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +. ./common.quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_scratch
> +_require_quota
> +
> +echo "Silence is golden."
> +
> +# create scratch filesystem
> +_scratch_mkfs_xfs >/dev/null 2>&1
> +
> +# mount  with quotas enabled
> +_scratch_mount -o uquota
> +
> +# turn off quota
> +xfs_quota -x -c off $SCRATCH_DEV
> +
> +# and unmount (this used to crash)
> +umount $SCRATCH_DEV
> +
> +status=0
> +exit $status
> Index: xfstests-dev/220.out
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/220.out	2009-10-11 17:00:02.000000000 +0000
> @@ -0,0 +1,2 @@
> +QA output created by 220
> +Silence is golden.
> Index: xfstests-dev/group
> ===================================================================
> --- xfstests-dev.orig/group	2009-10-11 16:44:37.000000000 +0000
> +++ xfstests-dev/group	2009-10-11 16:45:07.000000000 +0000
> @@ -329,3 +329,4 @@ prealloc
>  217 log metadata auto
>  218 auto fsr quick
>  219 auto quota quick
> +220 auto quota quick
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
