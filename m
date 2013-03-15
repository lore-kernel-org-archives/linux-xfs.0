Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 346E07FB9
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 21:19:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FBAE8F804B
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 19:19:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7C4PpZCsiYz88CGr for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 19:19:53 -0700 (PDT)
Date: Fri, 15 Mar 2013 13:19:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: test writing to device node on an RO filesystem
Message-ID: <20130315021951.GG21651@dastard>
References: <514243C0.1000309@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <514243C0.1000309@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 14, 2013 at 04:40:16PM -0500, Eric Sandeen wrote:
> we should be able to open device nodes for writing even
> if they live on a readonly filesytem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (I may have *cough* broken this on a backport once, hence the test)
> 
> diff --git a/315 b/315
> new file mode 100755
> index 0000000..8b8ecc6
> --- /dev/null
> +++ b/315
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# FS QA Test No. 315
> +#
> +# Test that we can write to a device node residing on a RO filesystem
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
> +owner=sandeen@redhat.com	
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +
> +DEVNULL=$SCRATCH_MNT/devnull
> +DEVZERO=$SCRATCH_MNT/devzero
> +
> +_scratch_mount

You need to _scratch_mkfs first.

> +rm -f $DEVNULL $DEVZERO
> +
> +mknod $DEVNULL c 1 3 || _fail "Could not create devnull device"
> +mknod $DEVZERO c 1 5 || _fail "Could not create devzero device"
> +
> +_scratch_unmount || _fail "Could not unmount scratch device"
> +_scratch_mount -o ro || _fail "Could not remount scratch readonly"
> +
> +# We should be able to read & write to/from these devices even on an RO fs
> +echo "== try to create new file"
> +touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
> +echo "== prite to null device"
> +xfs_io -c "pwrite 0 512" /dev/null | _filter_xfs_io
> +echo "== pread from zero device"
> +xfs_io -c "pread 0 512" /dev/zero | _filter_xfs_io

$XFS_IO_PROG

Yeah, I know, we don't do that in lots of places, but we should
change them all to the Proper Way....

> +
> +echo "== truncating write to null device"
> +echo foo >> $DEVNULL 2>&1 | _filter_scratch

That doesn't truncate.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
