Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 272297F86
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 08:33:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05FE2304032
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 06:33:10 -0800 (PST)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id PLpE7rzutHF5JpC7
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 06:33:10 -0800 (PST)
Message-ID: <52E7BFA0.4040204@fb.com>
Date: Tue, 28 Jan 2014 09:33:04 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test btrfs send issue with non-aligned clone
	operations
References: <1389476202-19683-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1389476202-19683-1-git-send-email-fdmanana@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Filipe David Borba Manana <fdmanana@gmail.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org


On 01/11/2014 04:36 PM, Filipe David Borba Manana wrote:
> Test for an issue in btrfs send where it sent clone operations to user
> space with a range (offset + length) that was not aligned with the block
> size. This caused the btrfs receive command to send such clone operations
> to the ioctl clone API, which would return -EINVAL errors to btrfs receive,
> causing the receive command to abort immediately.
>
> This corresponding btrfs linux kernel patch that fixes this issue is at:
>
> https://patchwork.kernel.org/patch/3470401/
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>   tests/btrfs/025     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/025.out |   18 ++++++++++
>   tests/btrfs/group   |    1 +
>   3 files changed, 117 insertions(+)
>   create mode 100755 tests/btrfs/025
>   create mode 100644 tests/btrfs/025.out
>
> diff --git a/tests/btrfs/025 b/tests/btrfs/025
> new file mode 100755
> index 0000000..5f13832
> --- /dev/null
> +++ b/tests/btrfs/025
> @@ -0,0 +1,98 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/025
> +#
> +# Test for an issue in btrfs send where it sent clone operations to user
> +# space with a range (offset + length) that was not aligned with the block
> +# size. This caused the btrfs receive command to send such clone operations
> +# to the ioctl clone API, which would return -EINVAL errors to btrfs receive,
> +# causing the receive command to abort immediately.
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
> +tmp=`mktemp -d`
> +
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
> +rm -f $seqres.full
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +$XFS_IO_PROG -f -c "truncate 819200" $SCRATCH_MNT/foo | _filter_xfs_io
> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
> +
> +$XFS_IO_PROG -c "falloc -k 819200 667648" $SCRATCH_MNT/foo | _filter_xfs_io
> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
> +
> +$XFS_IO_PROG -f -c "pwrite 1482752 2978" $SCRATCH_MNT/foo | _filter_xfs_io
> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
> +
> +$BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1 | \
> +    _filter_scratch
> +
> +$XFS_IO_PROG -f -c "truncate 883305" $SCRATCH_MNT/foo | _filter_xfs_io
> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
> +
> +$BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2 | \
> +    _filter_scratch
> +
> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap 2>&1 | _filter_scratch
> +$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
> +    -f $tmp/2.snap 2>&1 | _filter_scratch
> +
> +md5sum $SCRATCH_MNT/foo | _filter_scratch
> +md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> +
> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
> +md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
> +
> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> +
> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/025.out b/tests/btrfs/025.out
> new file mode 100644
> index 0000000..aaad4ab
> --- /dev/null
> +++ b/tests/btrfs/025.out
> @@ -0,0 +1,18 @@
> +QA output created by 025
> +FSSync 'SCRATCH_MNT'
> +FSSync 'SCRATCH_MNT'
> +wrote 2978/2978 bytes at offset 1482752
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +FSSync 'SCRATCH_MNT'
> +Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap1'
> +FSSync 'SCRATCH_MNT'
> +Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap2'
> +At subvol SCRATCH_MNT/mysnap1
> +At subvol SCRATCH_MNT/mysnap2
> +129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/foo
> +42b6369eae2a8725c1aacc0440e597aa  SCRATCH_MNT/mysnap1/foo
> +129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/mysnap2/foo
> +At subvol mysnap1
> +42b6369eae2a8725c1aacc0440e597aa  SCRATCH_MNT/mysnap1/foo
> +At snapshot mysnap2
> +129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/mysnap2/foo

Same feedback as earlier, don't rely on the output from btrfs send, just 
use run_check.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
