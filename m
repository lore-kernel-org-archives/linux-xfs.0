Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2NSw1d109644 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 17:28:59 -0600
Date: Fri, 2 Dec 2011 15:28:57 -0800
From: Phil White <pwhite@sgi.com>
Subject: Re: [7/8] xfstests: add a new test that runs fsstress under ENOSPC
	conditions
Message-ID: <20111202232857.GE28903@caliban.corp.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: xfs@oss.sgi.com

On Sat, Oct 29, 2011 at 12:48:16AM -0000, Dmitry Monakhov wrote:
> During stress testing we want to cover as much code paths as possible
> fsstress is very good for this purpose. But it has expandable nature
> (disk usage almost continually grow). So once it goes in no ENOSPC
> condition it will be where till the end. But by running 'dd' writers
> in parallel we can regularly trigger ENOSPC but only for a limited
> periods of time because each time it opens the same file with O_TRUNC.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> ---
> 264     |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  264.out |    5 +++
>  group   |    1 +
>  3 files changed, 92 insertions(+), 0 deletions(-)
>  create mode 100755 264
>  create mode 100644 264.out
> 
> diff --git a/264 b/264
> new file mode 100755
> index 0000000..fc6df23
> --- /dev/null
> +++ b/264
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# FSQA Test No. 264
> +#
> +# Run fsstress and ENSPC hitters in parallel, check fs consistency an the end
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
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
> +owner=dmonakhov@openvz.org
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +# Disable all sync operations to get higher load
> +FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
> +_workout()
> +{
> +	echo ""
> +	echo "Run fsstress"
> +	echo ""
> +	num_iterations=10
> +	enospc_time=2
> +	out=$SCRATCH_MNT/fsstress.$$
> +	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
> +	echo "fsstress $args" >> $here/$seq.full
> +	$FSSTRESS_PROG $args > /dev/null 2>&1 &
> +	pid=$!
> +	echo "Run dd writers in parallel"
> +	for ((i=0; i < num_iterations; i++))
> +	do
> +		# File will be opened with O_TRUNC each time
> +		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M count=1 \
> +			> /dev/null 2>&1
> +		sleep $enospc_time
> +	done
> +	kill $pid
> +	wait $pid
> +}
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_need_to_be_root
> +
> +umount $SCRATCH_DEV 2>/dev/null
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
> +_scratch_mount
> +
> +if ! _workout; then
> +	umount $SCRATCH_DEV 2>/dev/null
> +	exit
> +fi
> +
> +if ! _scratch_unmount; then
> +	echo "failed to umount"
> +	status=1
> +	exit
> +fi
> +_check_scratch_fs
> +status=$?
> +exit
> diff --git a/264.out b/264.out
> new file mode 100644
> index 0000000..81b50e5
> --- /dev/null
> +++ b/264.out
> @@ -0,0 +1,5 @@
> +QA output created by 264
> +
> +Run fsstress
> +
> +Run dd writers in parallel
> diff --git a/group b/group
> index 2a8970c..e79c29b 100644
> --- a/group
> +++ b/group
> @@ -377,3 +377,4 @@ deprecated
>  261 auto quick quota
>  262 auto quick quota
>  263 rw auto quick
> +264 auto rw prealloc ioctl enospc

Looks good to me.

Reviewed-By: Phil White <pwhite@sgi.com>
Tested-By: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
