Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfE2CQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 22:16:55 -0400
Date: Tue, 28 May 2019 19:16:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/5] generic: copy_file_range bounds test
Message-ID: <20190529021636.GB5244@magnolia>
References: <20190526084535.999-1-amir73il@gmail.com>
 <20190526084535.999-5-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526084535.999-5-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Sun, May 26, 2019 at 11:45:34AM +0300, Amir Goldstein wrote:
> Test that copy_file_range will return the correct errors for various
> error conditions and boundary constraints.
> 
> [Amir] Split out cross-device copy_range test and use only scratch dev.
> Split out immutable/swapfile test cases to reduce the requirements to
> run the bounds check to minimum and get coverage for more filesystems.
> Remove the tests for read past EOF and write after chmod -r,
> because we decided to stick with read(2)/write(2) semantics.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/generic/990     | 123 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/990.out |  37 +++++++++++++
>  tests/generic/group   |   1 +
>  3 files changed, 161 insertions(+)
>  create mode 100755 tests/generic/990
>  create mode 100644 tests/generic/990.out
> 
> diff --git a/tests/generic/990 b/tests/generic/990
> new file mode 100755
> index 00000000..5e2421b6
> --- /dev/null
> +++ b/tests/generic/990
> @@ -0,0 +1,123 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 990
> +#
> +# Exercise copy_file_range() syscall error conditions.
> +#
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs generic
> +
> +rm -f $seqres.full
> +
> +_require_test
> +_require_xfs_io_command "copy_range"
> +#
> +# This test effectively requires xfs_io v4.20 with the commits
> +#  2a42470b xfs_io: copy_file_range length is a size_t
> +#  1a05efba io: open pipes in non-blocking mode

So, uh, is this going to cause test hangs on xfsprogs < 4.20?

--D

> +#
> +# The same xfs_io release also included the new 'chmod' command.
> +# Use this fake requirement to prevent the test case of copy_range with fifo
> +# from hanging the test with old xfs_io.
> +#
> +_require_xfs_io_command "chmod"
> +
> +testdir="$TEST_DIR/test-$seq"
> +rm -rf $testdir
> +mkdir $testdir
> +
> +rm -f $seqres.full
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
> +
> +echo source range overlaps destination range in same file returns EINVAL
> +$XFS_IO_PROG -f -c "copy_range -s 32k -d 48k -l 32k $testdir/file" $testdir/file
> +
> +echo
> +echo destination file O_RDONLY returns EBADF
> +$XFS_IO_PROG -f -r -c "copy_range -l 32k $testdir/file" $testdir/copy
> +
> +echo
> +echo destination file O_APPEND returns EBADF
> +$XFS_IO_PROG -f -a -c "copy_range -l 32k $testdir/file" $testdir/copy
> +
> +echo
> +echo source/destination as directory returns EISDIR
> +$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir
> +$XFS_IO_PROG -f -c "copy_range -l 32k $testdir" $testdir/copy
> +
> +echo
> +echo source/destination as blkdev returns EINVAL
> +mknod $testdir/dev1 b 1 3
> +$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir/dev1
> +$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/dev1" $testdir/copy
> +
> +echo
> +echo source/destination as chardev returns EINVAL
> +mknod $testdir/dev2 c 1 3
> +$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir/dev2
> +$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/dev2" $testdir/copy
> +
> +echo
> +echo source/destination as FIFO returns EINVAL
> +mkfifo $testdir/fifo
> +$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir/fifo
> +$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/fifo" $testdir/copy
> +
> +max_off=$((8 * 2**60 - 65536 - 1))
> +min_off=65537
> +
> +echo
> +echo length beyond 8EiB wraps around 0 returns EOVERFLOW
> +$XFS_IO_PROG -f -c "copy_range -l 10e -s $max_off $testdir/file" $testdir/copy
> +$XFS_IO_PROG -f -c "copy_range -l 10e -d $max_off $testdir/file" $testdir/copy
> +
> +echo
> +echo source range beyond 8TiB returns 0
> +$XFS_IO_PROG -c "copy_range -s $max_off -l $min_off -d 0 $testdir/file" $testdir/copy
> +
> +echo
> +echo destination range beyond 8TiB returns EFBIG
> +$XFS_IO_PROG -c "copy_range -l $min_off -s 0 -d $max_off $testdir/file" $testdir/copy
> +
> +echo
> +echo destination larger than rlimit returns EFBIG
> +rm -f $testdir/copy
> +$XFS_IO_PROG -c "truncate 128k" $testdir/file
> +
> +# need a wrapper so the "File size limit exceeded" error can be filtered
> +do_rlimit_copy()
> +{
> +	$XFS_IO_PROG -f -c "copy_range -l 32k -s 0 -d 16m $testdir/file" $testdir/copy
> +}
> +
> +ulimit -f $((8 * 1024))
> +ulimit -c 0
> +do_rlimit_copy 2>&1 | grep -o "File size limit exceeded"
> +ulimit -f unlimited
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/990.out b/tests/generic/990.out
> new file mode 100644
> index 00000000..05d137de
> --- /dev/null
> +++ b/tests/generic/990.out
> @@ -0,0 +1,37 @@
> +QA output created by 990
> +source range overlaps destination range in same file returns EINVAL
> +copy_range: Invalid argument
> +
> +destination file O_RDONLY returns EBADF
> +copy_range: Bad file descriptor
> +
> +destination file O_APPEND returns EBADF
> +copy_range: Bad file descriptor
> +
> +source/destination as directory returns EISDIR
> +copy_range: Is a directory
> +copy_range: Is a directory
> +
> +source/destination as blkdev returns EINVAL
> +copy_range: Invalid argument
> +copy_range: Invalid argument
> +
> +source/destination as chardev returns EINVAL
> +copy_range: Invalid argument
> +copy_range: Invalid argument
> +
> +source/destination as FIFO returns EINVAL
> +copy_range: Invalid argument
> +copy_range: Invalid argument
> +
> +length beyond 8EiB wraps around 0 returns EOVERFLOW
> +copy_range: Value too large for defined data type
> +copy_range: Value too large for defined data type
> +
> +source range beyond 8TiB returns 0
> +
> +destination range beyond 8TiB returns EFBIG
> +copy_range: File too large
> +
> +destination larger than rlimit returns EFBIG
> +File size limit exceeded
> diff --git a/tests/generic/group b/tests/generic/group
> index 4c100781..86802d54 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -552,3 +552,4 @@
>  547 auto quick log
>  988 auto quick copy_range
>  989 auto quick copy_range swap
> +990 auto quick copy_range
> -- 
> 2.17.1
> 
