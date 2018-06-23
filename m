Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbeFWRvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Jun 2018 13:51:00 -0400
Date: Sat, 23 Jun 2018 10:50:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs: test inode allocation state missmatch corruption
Message-ID: <20180623175041.GE4841@magnolia>
References: <20180623172916.22133-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180623172916.22133-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 01:29:16AM +0800, Zorro Lang wrote:
> There's a situation where the directory structure and the inobt
> thinks the inode is free, but the inode on disk thinks it is still
> in use. XFS should detect it and prevent the kernel from oopsing
> on lookup.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> Old V2: https://marc.info/?l=fstests&m=152605509711179&w=2
> 
> V3 did below changes:
> 1) Update description
> 2) Change function name _filter_dmesg to filter_dmesg
> 3) Add _require_xfs_mkfs_crc
> 
> Thanks,
> Zorro
> 
>  tests/xfs/999     | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |   2 ++
>  tests/xfs/group   |   1 +
>  3 files changed, 107 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..6057c3b7
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,104 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 999
> +#
> +# Test a corruption when the directory structure and the inobt thinks the inode
> +# is free, but the inode on disk thinks it is still in use.
> +#
> +# This case test same bug (upstream linux commit ee457001ed6c) as xfs/132, but
> +# through different code path.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
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
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch_nocheck
> +_require_no_xfs_bug_on_assert
> +# need mkfs crc=0 below
> +_require_xfs_mkfs_crc
> +
> +filter_dmesg()
> +{
> +	local warn1="Internal error xfs_trans_cancel.*fs/xfs/xfs_trans\.c.*"
> +	local warn2="WARNING:.*fs/xfs/xfs_message\.c:.*assfail.*"
> +
> +	sed -e "s#$warn1#Intentional error in xfs_trans_cancel#" \
> +	    -e "s#$warn2#Intentional warnings in assfail#"
> +}
> +
> +# Use crc=0, due to this crash is only possible on v4 XFS or v5 XFS mounted
> +# with the ikeep mount option. For all other V5 XFS, this problem cannot
> +# occur because we don't read inodes we are allocating from disk - we simply
> +# overwrite them with the new inode information.

Um, if v5+ikeep also reproduces this then why not _scratch_mkfs with no
options and inject ikeep into MOUNT_OPTIONS if a v5 fs was built?

(Also I thought v5 did read inodes that we're allocating from disk
now...)

> +_scratch_mkfs_xfs -m crc=0 >> $seqres.full 2>&1

With this we'll never have any coverage of v5 filesystems at all.

--D

> +blksz=$(_scratch_xfs_get_sb_field blocksize)
> +agcount=$(_scratch_xfs_get_sb_field agcount)
> +
> +_scratch_mount
> +# Create a directory for later allocation in same AG (AG 0, due to this's an
> +# empty XFS for now)
> +mkdir $SCRATCH_MNT/dir
> +
> +# Allocate 1 block for testfile
> +$XFS_IO_PROG -fc "pwrite 0 $blksz" -c fsync $SCRATCH_MNT/dir/testfile >> $seqres.full
> +inum=`stat -c %i $SCRATCH_MNT/dir/testfile`
> +_scratch_unmount
> +
> +# Find the AG which contains testfile
> +agi=`_scratch_xfs_db -c "convert inode $inum agno" | sed -e 's/^.*(\([0-9]*\).*$/\1/g'`
> +
> +# Due to we only allocate 1 block for testfile, and this's the only one data
> +# block we use. So we use single level inobt, So the ${agi}->root->recs[1]
> +# should be the only one record points the chunk which contains testfile's
> +# inode.
> +# An exmaple of inode record is as below:
> +#   recs[1] = [startino,freecount,free] 1:[1024,59,0xffffffffffffffe0]
> +freecount=$(_scratch_xfs_get_metadata_field "recs[1].freecount" \
> +					    "agi $agi" "addr root")
> +fmask=$(_scratch_xfs_get_metadata_field "recs[1].free" "agi $agi" "addr root")
> +
> +# fmask shift right 1 bit, and freecount++, to mark testfile inode as free in
> +# inobt. (But the inode itself isn't freed, it still has allocated block)
> +freecount="$((freecount + 1))"
> +fmask="$((fmask / 2))"
> +_scratch_xfs_set_metadata_field "recs[1].freecount" "$freecount" \
> +				"agi $agi" "addr root" >/dev/null
> +_scratch_xfs_set_metadata_field "recs[1].free" "$fmask" \
> +				"agi $agi" "addr root" >/dev/null
> +
> +# Mount again and create a new inode cover that inode we just 'freed' from inobt
> +_scratch_mount
> +$XFS_IO_PROG -fc "pwrite 0 $blksz" -c fsync $SCRATCH_MNT/dir/newfile 2>&1 | \
> +	grep -i "Structure needs cleaning" | _filter_scratch
> +
> +# filter a intentional internal errors
> +_check_dmesg filter_dmesg
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..cb8d9e34
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +SCRATCH_MNT/dir/newfile: Structure needs cleaning
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 932ab909..4bea7b2b 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -447,3 +447,4 @@
>  447 auto mount
>  448 auto quick fuzzers
>  449 auto quick
> +999 auto quick
> -- 
> 2.14.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
