Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54132 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbeG3Q0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 12:26:55 -0400
Date: Mon, 30 Jul 2018 07:51:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4] xfs: test inode allocation state missmatch corruption
Message-ID: <20180730145129.GU30972@magnolia>
References: <20180730071551.24735-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730071551.24735-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 03:15:51PM +0800, Zorro Lang wrote:
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
> Sorry, it's been long time since I last sent v3 of this case... For bringing
> your memory, please check below link:
> V3 review history: https://marc.info/?t=152986575600003&r=1&w=2
> V2 review history: https://marc.info/?t=152605514200002&r=1&w=2
> 
> As Darrick suggested to cover v5 filesystems testing last time, I did below
> changes:
> 1) Remove "-m crc=0" mkfs option, but add "-m finobt=0"
> 2) Use "ikeep" mount option if test on V5.
> 3) Remove a useless dmesg filter from filter_dmesg()
> 4) Use _require_no_xfs_debug
> 5) Use _require_xfs_mkfs_finobt
> 
> About the problem:
>   "Does this test leave the scratch fs mounted but shut down if the kernel hasn't been patched?"
> I have to say "yes, it does". I have no idea about how we deal with this issue,
> feel free to remind me if I missed some discussion:)

unmount it, usually...

> Thanks,
> Zorro
> 
> 
>  tests/xfs/999     | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |   2 +
>  tests/xfs/group   |   1 +
>  3 files changed, 116 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..785a84d0
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,113 @@
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
> +_require_xfs_mkfs_finobt
> +
> +# Skip the verifier "xfs_check_agi_freecount()" which verify the number of free
> +# inodes in the AGI is correct, when XFS_DEBUG is enabled
> +_require_no_xfs_debug
> +
> +filter_dmesg()
> +{
> +	local warn1="Internal error xfs_trans_cancel.*fs/xfs/xfs_trans\.c.*"
> +
> +	sed -e "s#$warn1#Intentional error in xfs_trans_cancel#"
> +}
> +
> +# If enable free inode B+tree, this case will fail on xfs_dialloc_ag_update_inobt,
> +# that's not what we want to test. Due to finobt feature is not necessary for this
> +# test, so disable it directly.
> +_scratch_mkfs_xfs -m finobt=0 | _filter_mkfs 2>$tmp.mkfs >> $seqres.full
> +
> +# On V5 filesystem, this case can't trigger bug because it doesn't read inodes
> +# we are allocating from disk - it simply overwrites them with new inode
> +# information. So use ikeep mount option to stop that.
> +source $tmp.mkfs
> +mount_opt=""
> +if [ $_fs_has_crcs -eq 1 ]; then
> +	mount_opt="-o ikeep"
> +fi
> +
> +blksz=$(_scratch_xfs_get_sb_field blocksize)
> +agcount=$(_scratch_xfs_get_sb_field agcount)
> +
> +_scratch_mount $mount_opt
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
> +_scratch_mount $mount_opt
> +$XFS_IO_PROG -fc "pwrite 0 $blksz" -c fsync $SCRATCH_MNT/dir/newfile 2>&1 | \
> +	grep -i "Structure needs cleaning" | _filter_scratch
> +
> +# filter a intentional internal errors
> +_check_dmesg filter_dmesg
> +
> +# success, all done
> +status=0
> +exit

...aside from that, the rest looks ok to me.

--D

> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..cb8d9e34
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +SCRATCH_MNT/dir/newfile: Structure needs cleaning
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 976a12c2..f9178d3b 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -487,3 +487,4 @@
>  487 dangerous_fuzzers dangerous_norepair
>  488 dangerous_fuzzers dangerous_norepair
>  489 dangerous_fuzzers dangerous_norepair
> +999 auto quick
> -- 
> 2.14.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
