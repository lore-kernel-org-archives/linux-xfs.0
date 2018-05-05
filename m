Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37366 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751118AbeEEQ1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 May 2018 12:27:49 -0400
Date: Sat, 5 May 2018 09:27:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs/132: remove duplicate test
Message-ID: <20180505162724.GD4116@magnolia>
References: <1525516282-23276-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525516282-23276-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, May 05, 2018 at 01:31:22PM +0300, Amir Goldstein wrote:
> Test description says: "This is the same test as generic/156 except
> that we also check the inode reflink flag.", only since commit
> f1c3fee ("xfs: remove NOCOW_FL testing from test") it is almost
> exactly the same test as generic/156.
> almost - because since xfs/132 diverged from generic/156 the change
> 911efb0 ("reflink: change to relative margins") is only applied to
> the original test.
> 
> Anyway, there doesn't seem to be a reason to keep this duplicated
> test anymore, so remove it.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Yeah, this one can go away now.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/xfs/132     | 126 ------------------------------------------------------
>  tests/xfs/132.out |  12 ------
>  tests/xfs/group   |   1 -
>  3 files changed, 139 deletions(-)
>  delete mode 100755 tests/xfs/132
>  delete mode 100644 tests/xfs/132.out
> 
> diff --git a/tests/xfs/132 b/tests/xfs/132
> deleted file mode 100755
> index 178e268..0000000
> --- a/tests/xfs/132
> +++ /dev/null
> @@ -1,126 +0,0 @@
> -#! /bin/bash
> -# FS QA Test No. 132
> -#
> -# Ensure that fallocate on reflinked files actually CoWs the shared blocks.
> -#   - Record fs block usage (0)
> -#   - Create a file and some reflink copies
> -#   - Record fs block usage (1)
> -#   - funshare half of one of the copies
> -#   - Record fs block usage (2)
> -#   - funshare all of the copies
> -#   - Record fs block usage (3)
> -#   - rewrite the original file
> -#   - Record fs block usage (4)
> -#   - Compare fs block usage of 0-4 to ensure that block usage behaves as
> -#     we expect.
> -#   - Compare the status of the inode reflink flag at each step.
> -#
> -# "funshare" refers to fallocate copy-on-writing the shared blocks
> -#
> -# This is the same test as generic/156 except that we also check the inode
> -# reflink flag.
> -#
> -#-----------------------------------------------------------------------
> -# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
> -#
> -# This program is free software; you can redistribute it and/or
> -# modify it under the terms of the GNU General Public License as
> -# published by the Free Software Foundation.
> -#
> -# This program is distributed in the hope that it would be useful,
> -# but WITHOUT ANY WARRANTY; without even the implied warranty of
> -# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -# GNU General Public License for more details.
> -#
> -# You should have received a copy of the GNU General Public License
> -# along with this program; if not, write the Free Software Foundation,
> -# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> -#-----------------------------------------------------------------------
> -
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> -
> -here=`pwd`
> -tmp=/tmp/$$
> -status=1    # failure is the default!
> -trap "_cleanup; exit \$status" 0 1 2 3 15
> -
> -_cleanup()
> -{
> -    cd /
> -    rm -rf $tmp.* $testdir
> -}
> -
> -# get standard environment, filters and checks
> -. ./common/rc
> -. ./common/filter
> -. ./common/attr
> -. ./common/reflink
> -
> -# real QA test starts here
> -_supported_os Linux
> -_require_test_reflink
> -_require_test_lsattr
> -_require_cp_reflink
> -_require_xfs_io_command "funshare"
> -
> -rm -f $seqres.full
> -
> -testdir=$TEST_DIR/test-$seq
> -rm -rf $testdir
> -mkdir $testdir
> -
> -echo "Create the original file blocks"
> -blksz="$(_get_block_size $testdir)"
> -blks=2000
> -margin=100
> -sz=$((blksz * blks))
> -free_blocks0=$(stat -f $testdir -c '%f')
> -nr=4
> -filesize=$((blksz * nr))
> -_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
> -_test_cycle_mount
> -
> -echo "Create the reflink copies"
> -for i in `seq 2 $nr`; do
> -	_cp_reflink $testdir/file1 $testdir/file$i
> -done
> -_test_cycle_mount
> -free_blocks1=$(stat -f $testdir -c '%f')
> -
> -echo "funshare part of a file"
> -$XFS_IO_PROG -f -c "funshare 0 $((sz / 2))" $testdir/file2
> -_test_cycle_mount
> -
> -echo "funshare some of the copies"
> -$XFS_IO_PROG -f -c "funshare 0 $sz" $testdir/file2
> -$XFS_IO_PROG -f -c "funshare 0 $sz" $testdir/file3
> -_test_cycle_mount
> -free_blocks2=$(stat -f $testdir -c '%f')
> -
> -echo "funshare the rest of the files"
> -$XFS_IO_PROG -f -c "funshare 0 $sz" $testdir/file4
> -$XFS_IO_PROG -f -c "funshare 0 $sz" $testdir/file1
> -_test_cycle_mount
> -free_blocks3=$(stat -f $testdir -c '%f')
> -
> -echo "Rewrite the original file"
> -_pwrite_byte 0x65 0 $sz $testdir/file1 >> $seqres.full
> -_test_cycle_mount
> -free_blocks4=$(stat -f $testdir -c '%f')
> -#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
> -
> -_within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
> -
> -_within_tolerance "free blocks after nocow'ing some copies" $free_blocks2 $((free_blocks1 - (2 * blks))) $margin -v
> -
> -_within_tolerance "free blocks after nocow'ing all copies" $free_blocks3 $((free_blocks2 - blks)) $margin -v
> -
> -_within_tolerance "free blocks after overwriting original" $free_blocks4 $free_blocks3 $margin -v
> -
> -_within_tolerance "free blocks after all tests" $free_blocks4 $((free_blocks0 - (4 * blks))) $margin -v
> -
> -# success, all done
> -status=0
> -exit
> diff --git a/tests/xfs/132.out b/tests/xfs/132.out
> deleted file mode 100644
> index 3d1281c..0000000
> --- a/tests/xfs/132.out
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -QA output created by 132
> -Create the original file blocks
> -Create the reflink copies
> -funshare part of a file
> -funshare some of the copies
> -funshare the rest of the files
> -Rewrite the original file
> -free blocks after reflinking is in range
> -free blocks after nocow'ing some copies is in range
> -free blocks after nocow'ing all copies is in range
> -free blocks after overwriting original is in range
> -free blocks after all tests is in range
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 39e259e..32bf4f7 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -129,7 +129,6 @@
>  129 auto quick clone
>  130 fuzzers clone
>  131 auto quick clone
> -132 auto quick clone
>  133 dangerous_fuzzers
>  134 dangerous_fuzzers
>  135 auto logprint quick v2log
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
