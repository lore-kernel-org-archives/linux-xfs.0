Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18461 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753825AbdIDPOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 11:14:46 -0400
Date: Mon, 4 Sep 2017 08:14:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] generic: reserve correct indirect blocks for delalloc
 write path
Message-ID: <20170904151440.GE4671@magnolia>
References: <20170904093819.28708-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904093819.28708-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 04, 2017 at 05:38:19PM +0800, Eryu Guan wrote:
> Test that XFS reserves reasonable indirect blocks for delalloc and
> speculative allocation, and doesn't cause any fdblocks corruption.
> 
> This was inspired by an XFS but that too large 'indlen' was returned by
> xfs_bmap_worst_indlen() which can't fit in a 17 bits value
> (STARTBLOCKVALBITS is defined as 17), then leaked 1 << 17 blocks in
> sb_fdblocks.
> 
> This was only seen on XFS with rmapbt feature enabled, but nothing
> prevents the test from being a generic test.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> 
> This reproduces sb_fdblocks corruption issue for me with 1k block size
> rmapbt enabled XFS on x86_64 and ppc64 hosts. Other block size XFS pass
> the test now.

Looks reasonable; does the revert patch (posted earlier) fix it?

--D

> 
>  tests/generic/456     | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/456.out |   2 +
>  tests/generic/group   |   1 +
>  3 files changed, 116 insertions(+)
>  create mode 100755 tests/generic/456
>  create mode 100644 tests/generic/456.out
> 
> diff --git a/tests/generic/456 b/tests/generic/456
> new file mode 100755
> index 000000000000..b878c67c6b0e
> --- /dev/null
> +++ b/tests/generic/456
> @@ -0,0 +1,113 @@
> +#! /bin/bash
> +# FS QA Test 456
> +#
> +# Test that XFS reserves reasonable indirect blocks for delalloc and
> +# speculative allocation, and doesn't cause any fdblocks corruption.
> +#
> +# This was inspired by an XFS but that too large 'indlen' was returned by
> +# xfs_bmap_worst_indlen() which can't fit in a 17 bits value (STARTBLOCKVALBITS
> +# is defined as 17), then leaked 1 << 17 blocks in sb_fdblocks.
> +#
> +# This was only seen on XFS with rmapbt feature enabled, but nothing prevents
> +# the test from being a generic test.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
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
> +testfile=$SCRATCH_MNT/1G_file.$seq
> +file_size=$((1024 * 1024 * 1024))
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +saved_dirty_background_ratio=0
> +saved_dirty_ratio=0
> +
> +save_dirty_ratio()
> +{
> +	saved_dirty_background_ratio=`cat /proc/sys/vm/dirty_background_ratio`
> +	saved_dirty_ratio=`cat /proc/sys/vm/dirty_ratio`
> +}
> +
> +set_dirty_ratio()
> +{
> +	echo 100 > /proc/sys/vm/dirty_background_ratio
> +	echo 100 > /proc/sys/vm/dirty_ratio
> +}
> +
> +restore_dirty_ratio()
> +{
> +	if [ $saved_dirty_background_ratio -ne 0 ]; then
> +		echo $saved_dirty_background_ratio > /proc/sys/vm/dirty_background_ratio
> +	fi
> +	if [ $saved_dirty_ratio -ne 0 ]; then
> +		echo $saved_dirty_ratio > /proc/sys/vm/dirty_ratio
> +	fi
> +}
> +
> +_cleanup()
> +{
> +	cd /
> +	restore_dirty_ratio
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +# test with scratch device, because test is known to corrupt fs, we don't want
> +# the corruption affect subsequent tests
> +_require_scratch
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +# need at least 1G free space
> +_require_fs_space $SCRATCH_MNT $((1024 * 1024))
> +
> +# To reproduce the bug, we need to keep enough dirty data in memory (1G at
> +# least), so that a large enough delay allocated extent is kept in memory, then
> +# speculative preallocation could allocate large number of blocks based on the
> +# existing extent size.
> +# So we set dirty_background_ratio and dirty_ratio to 100% uncontitionally,
> +# even if the total memory is less than 1G, there's no harm to run a test on a
> +# such host.
> +save_dirty_ratio
> +set_dirty_ratio
> +
> +# buffer write a 1G file, which is enough to trigger the bug,
> +# _check_filesystems will complain about fs corruption after test
> +$XFS_IO_PROG -fc "pwrite -b 1m 0 $file_size" $testfile >/dev/null 2>&1
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/456.out b/tests/generic/456.out
> new file mode 100644
> index 000000000000..248dfeb2ad90
> --- /dev/null
> +++ b/tests/generic/456.out
> @@ -0,0 +1,2 @@
> +QA output created by 456
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 6422d51033af..e9f08ab4ef79 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -458,3 +458,4 @@
>  453 auto quick dir
>  454 auto quick attr
>  455 auto rw
> +456 auto quick rw
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
