Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D04D17CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 02:09:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A19C5304039
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 00:09:45 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fHOtg4sRKlm6upaH for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 00:09:39 -0800 (PST)
Date: Tue, 9 Feb 2016 19:09:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/23] reflink: test CoW across a mixed range of block
	types with cowextsize set
Message-ID: <20160209080923.GM19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011335.23099.47260.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209011335.23099.47260.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 05:13:35PM -0800, Darrick J. Wong wrote:
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/215     |  108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/215.out |   14 +++++
>  tests/xfs/218     |  108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/218.out |   14 +++++
>  tests/xfs/219     |  108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/219.out |   14 +++++
>  tests/xfs/221     |  108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/221.out |   14 +++++
>  tests/xfs/223     |  113 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/223.out |   14 +++++
>  tests/xfs/224     |  113 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/224.out |   14 +++++
>  tests/xfs/225     |  108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/225.out |   14 +++++
>  tests/xfs/226     |  108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/226.out |   14 +++++
>  tests/xfs/228     |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/228.out |   14 +++++
>  tests/xfs/230     |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/230.out |   14 +++++
>  tests/xfs/group   |   10 ++++
>  21 files changed, 1298 insertions(+)
>  create mode 100755 tests/xfs/215
>  create mode 100644 tests/xfs/215.out
>  create mode 100755 tests/xfs/218
>  create mode 100644 tests/xfs/218.out
>  create mode 100755 tests/xfs/219
>  create mode 100644 tests/xfs/219.out
>  create mode 100755 tests/xfs/221
>  create mode 100644 tests/xfs/221.out
>  create mode 100755 tests/xfs/223
>  create mode 100644 tests/xfs/223.out
>  create mode 100755 tests/xfs/224
>  create mode 100644 tests/xfs/224.out
>  create mode 100755 tests/xfs/225
>  create mode 100644 tests/xfs/225.out
>  create mode 100755 tests/xfs/226
>  create mode 100644 tests/xfs/226.out
>  create mode 100755 tests/xfs/228
>  create mode 100644 tests/xfs/228.out
>  create mode 100755 tests/xfs/230
>  create mode 100644 tests/xfs/230.out
> 
> 
> diff --git a/tests/xfs/215 b/tests/xfs/215
> new file mode 100755
> index 0000000..8dd5cb5
> --- /dev/null
> +++ b/tests/xfs/215
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# FS QA Test No. 215
> +#
> +# Ensuring that copy on write in direct-io mode works when the CoW
> +# range originally covers multiple extents, some unwritten, some not.
> +#   - Set cowextsize hint.
> +#   - Create a file and fallocate a second file.
> +#   - Reflink the odd blocks of the first file into the second file.
> +#   - directio CoW across the halfway mark, starting with the unwritten extent.
> +#   - Check that the files are now different where we say they're different.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
> +
> +seq=`basename "$0"`
> +seqres="$RESULT_DIR/$seq"
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -rf "$tmp".*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_os Linux
> +_require_scratch_reflink
> +_require_xfs_io_command "falloc"
> +
> +rm -f "$seqres.full"
> +
> +echo "Format and mount"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount >> "$seqres.full" 2>&1
> +
> +testdir="$SCRATCH_MNT/test-$seq"
> +rm -rf $testdir
> +mkdir $testdir
> +
> +echo "Create the original files"
> +blksz=65536
> +nr=64
> +real_blksz=$(stat -f -c '%S' "$testdir")
> +internal_blks=$((blksz * nr / real_blksz))
> +"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
> +_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
> +$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
> +_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
> +seq 0 2 $((nr-1)) | while read f; do
> +	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
> +	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
> +done

This looks like several tests use this setup. Factor?

> +_scratch_remount
> +
> +echo "Compare files"
> +md5sum "$testdir/file1" | _filter_scratch
> +md5sum "$testdir/file3" | _filter_scratch
> +md5sum "$testdir/file3.chk" | _filter_scratch
> +
> +echo "directio CoW across the transition"
> +"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
> +_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
> +_scratch_remount

These could really do with local variables to keep the verbosity
down and make it easy to change in future.

off=$((blksz * nr / 4))
iosz=$((blksz * nr / 2))

$XFS_IO_PROG -d -c "pwrite -S 0x63 -b $iosz $off $iosz" $testdir/file3
_pwrite_byte 0x63 $off $iosz $testdir/file3.chk

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
