Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 299167F53
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 23:26:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89E84AC004
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:25:59 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NwaIaOQjn7mSuiRz for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 21:25:57 -0800 (PST)
Date: Mon, 24 Feb 2014 16:25:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add test for btrfs send issuing premature
	rmdir operations
Message-ID: <20140224052553.GJ4317@dastard>
References: <1392820352-8550-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392820352-8550-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 19, 2014 at 02:32:32PM +0000, Filipe David Borba Manana wrote:
> Regression test for btrfs incremental send issue where a rmdir instruction
> is sent against an orphan directory inode which is not empty yet, causing
> btrfs receive to fail when it attempts to remove the directory.
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
>    Btrfs: fix send attempting to rmdir non-empty directories
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  tests/btrfs/041     |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/041.out |    1 +
>  tests/btrfs/group   |    1 +
>  3 files changed, 155 insertions(+)
>  create mode 100755 tests/btrfs/041
>  create mode 100644 tests/btrfs/041.out
> 
> diff --git a/tests/btrfs/041 b/tests/btrfs/041
> new file mode 100755
> index 0000000..9de9326
> --- /dev/null
> +++ b/tests/btrfs/041
> @@ -0,0 +1,153 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/041
> +#
> +# Regression test for btrfs incremental send issue where a rmdir instruction
> +# is sent against an orphan directory inode which is not empty yet, causing
> +# btrfs receive to fail when it attempts to remove the directory.
> +#
> +# This issue is fixed by the following linux kernel btrfs patch:
> +#
> +#   Btrfs: fix send attempting to rmdir non-empty directories
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=`mktemp -d`
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    rm -fr $tmp
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_need_to_be_root
> +
> +FSSUM_PROG=$here/src/fssum
> +[ -x $FSSUM_PROG ] || _notrun "fssum not built"

This is duplicated across several tests now. Perhaps this should be
factored now into a _requires_fssum helper (separate patch is
fine)?

> +
> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV

you should be able to use _check_scratch_fs() here. I note that the
btrfs path does not unmount the scratch device, so you should update
it to do so (like _check_xfs_filesytem does) and then
_check_scratch_fs() will just Do The Right Thing.

> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
> +run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full
> +
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
> +run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full

Hasn't run_check already redirected everything to $seqres.full?

> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV

_check_scratch_fs() here too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
