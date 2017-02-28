Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751045AbdB1IPF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 03:15:05 -0500
Date: Tue, 28 Feb 2017 16:15:02 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/4] reflink: test adjacency of reflinked blocks
Message-ID: <20170228081502.GG16443@eguan.usersys.redhat.com>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
 <148798517790.25833.2585159479268361866.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148798517790.25833.2585159479268361866.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@djwong.org>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Feb 24, 2017 at 05:12:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we reflink a file with N blocks to another file one block at a time,
> does the destination file end up with the same number of extents as the
> source file?  In other words, does the filesystem succeed at combining
> adjacent mappings into a maximal extents?

I'm not sure if this is a standard behavior and applies to btrfs too?
But btrfs is failing this test now:

+f1 (1) != f2 (32)
+s1 (1) != s2 (32)

Fix test or btrfs? I'm taking it if btrfs is the one to be fixed :)

Thanks,
Eryu

> 
> Signed-off-by: Darrick J. Wong <djwong@djwong.org>
> ---
>  tests/generic/930     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/930.out |   11 +++++
>  tests/generic/group   |    1 
>  3 files changed, 118 insertions(+)
>  create mode 100755 tests/generic/930
>  create mode 100644 tests/generic/930.out
> 
> 
> diff --git a/tests/generic/930 b/tests/generic/930
> new file mode 100755
> index 0000000..15d8cbf
> --- /dev/null
> +++ b/tests/generic/930
> @@ -0,0 +1,106 @@
> +#! /bin/bash
> +# FS QA Test No. 930
> +#
> +# Check that reflinking adjacent blocks in a file produces a single
> +# block mapping extent.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 7 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +	wait
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs generic
> +_require_scratch_reflink
> +_require_fiemap
> +
> +echo "Format and mount"
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +testdir=$SCRATCH_MNT/test-$seq
> +mkdir $testdir
> +
> +blocks=32
> +blksz=65536
> +sz=$((blocks * blksz))
> +
> +echo "Create the original files"
> +$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1 >> $seqres.full
> +_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
> +seq 0 $blksz $((sz - blksz)) | while read offset; do
> +	_reflink_range $testdir/file1 $offset $testdir/file2 $offset $blksz >> $seqres.full
> +done
> +
> +echo "Compare files"
> +md5sum $testdir/file1 | _filter_scratch
> +md5sum $testdir/file2 | _filter_scratch
> +
> +echo "Check extent counts"
> +f1=$(_count_extents $testdir/file1)
> +f2=$(_count_extents $testdir/file2)
> +s1=$($XFS_IO_PROG -c 'fiemap -v' $testdir/file1 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$')
> +s2=$($XFS_IO_PROG -c 'fiemap -v' $testdir/file2 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$')
> +
> +# Did the fs combine the extent mappings when we made f2?
> +test $f1 -eq $f2 || echo "f1 ($f1) != f2 ($f2)"
> +test $s1 -eq $s2 || echo "s1 ($s1) != s2 ($s2)"
> +test $f1 -eq $s1 || echo "f1 ($f1) != s1 ($f1)"
> +test $f2 -eq $s2 || echo "f2 ($f2) != s2 ($f2)"
> +
> +_scratch_cycle_mount
> +
> +echo "Compare files after remounting"
> +md5sum $testdir/file1 | _filter_scratch
> +md5sum $testdir/file2 | _filter_scratch
> +
> +echo "Check extent counts"
> +f1=$(_count_extents $testdir/file1)
> +f2=$(_count_extents $testdir/file2)
> +s1=$($XFS_IO_PROG -c 'fiemap -v' $testdir/file1 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$')
> +s2=$($XFS_IO_PROG -c 'fiemap -v' $testdir/file2 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$')
> +
> +# Are the mappings still combined?
> +test $f1 -eq $f2 || echo "f1 ($f1) != f2 ($f2)"
> +test $s1 -eq $s2 || echo "s1 ($s1) != s2 ($s2)"
> +test $f1 -eq $s1 || echo "f1 ($f1) != s1 ($f1)"
> +test $f2 -eq $s2 || echo "f2 ($f2) != s2 ($f2)"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/930.out b/tests/generic/930.out
> new file mode 100644
> index 0000000..556108a
> --- /dev/null
> +++ b/tests/generic/930.out
> @@ -0,0 +1,11 @@
> +QA output created by 930
> +Format and mount
> +Create the original files
> +Compare files
> +de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-930/file1
> +de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-930/file2
> +Check extent counts
> +Compare files after remounting
> +de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-930/file1
> +de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-930/file2
> +Check extent counts
> diff --git a/tests/generic/group b/tests/generic/group
> index d0bc47d..4b4df66 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -411,3 +411,4 @@
>  406 auto quick dangerous
>  407 auto quick clone metadata
>  408 auto quick clone dedupe metadata
> +930 auto quick clone
> 
