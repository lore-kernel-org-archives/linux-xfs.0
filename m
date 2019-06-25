Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46359 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbfFYCx7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 22:53:59 -0400
Date: Tue, 25 Jun 2019 10:53:51 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 1/1] xfs: check for COW overflows in i_delayed_blks
Message-ID: <20190625025351.GP15846@desktop>
References: <156089205119.347309.8343884194087205290.stgit@magnolia>
 <156089205776.347309.3970978868590991055.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156089205776.347309.3970978868590991055.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, bfoster@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jun 18, 2019 at 02:07:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> With the new copy on write functionality it's possible to reserve so
> much COW space for a file that we end up overflowing i_delayed_blks.
> The only user-visible effect of this is to cause totally wrong i_blocks
> output in stat, so check for that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Test looks fine to me and it runs well too.

Brian, really appreciate if you could help review this new version again
as well!

Thanks,
Eryu

> ---
>  tests/xfs/907     |  199 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/907.out |    8 ++
>  tests/xfs/group   |    1 
>  3 files changed, 208 insertions(+)
>  create mode 100755 tests/xfs/907
>  create mode 100644 tests/xfs/907.out
> 
> 
> diff --git a/tests/xfs/907 b/tests/xfs/907
> new file mode 100755
> index 00000000..92cd0399
> --- /dev/null
> +++ b/tests/xfs/907
> @@ -0,0 +1,199 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 907
> +#
> +# Try to overflow i_delayed_blks by setting the largest cowextsize hint
> +# possible, creating a sparse file with a single byte every cowextsize bytes,
> +# reflinking it, and retouching every written byte to see if we can create
> +# enough speculative COW reservations to overflow i_delayed_blks.
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
> +	test -n "$loop_mount" && $UMOUNT_PROG $loop_mount > /dev/null 2>&1
> +	test -n "$loop_dev" && _destroy_loop_device $loop_dev
> +	rm -rf $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/reflink
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs xfs
> +_require_scratch_reflink
> +_require_cp_reflink
> +_require_loop
> +_require_xfs_debug	# needed for xfs_bmap -c
> +
> +MAXEXTLEN=2097151	# cowextsize can't be more than MAXEXTLEN
> +
> +echo "Format and mount"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Create a huge sparse filesystem on the scratch device because that's what
> +# we're going to need to guarantee that we have enough blocks to overflow in
> +# the first place.  We need to have at least enough free space on that huge fs
> +# to handle one written block every MAXEXTLEN blocks and to reserve 2^32 blocks
> +# in the COW fork.  There needs to be sufficient space in the scratch
> +# filesystem to handle a 256M log, all the per-AG metadata, and all the data
> +# written to the test file.
> +#
> +# Worst case, a 64k-block fs needs to be about 300TB.  Best case, a 1k block
> +# filesystem needs ~5TB.  For the most common 4k case we only need a ~20TB fs.
> +#
> +# In practice, the author observed that the space required on the scratch fs
> +# never exceeded ~800M even for a 300T 6k-block filesystem, so we'll just ask
> +# for about 1.2GB.
> +blksz=$(_get_file_block_size "$SCRATCH_MNT")
> +nr_cows="$(( ((2 ** 32) / MAXEXTLEN) + 100 ))"
> +blks_needed="$(( nr_cows * (1 + MAXEXTLEN) ))"
> +loop_file_sz="$(( ((blksz * blks_needed) * 12 / 10) / 512 * 512 ))"
> +_require_fs_space $SCRATCH_MNT 1234567
> +
> +loop_file=$SCRATCH_MNT/a.img
> +loop_mount=$SCRATCH_MNT/a
> +$XFS_IO_PROG -f -c "truncate $loop_file_sz" $loop_file
> +loop_dev=$(_create_loop_device $loop_file)
> +
> +# Now we have to create the source file.  The goal is to overflow a 32-bit
> +# i_delayed_blks, which means that we have to create at least that many delayed
> +# allocation block reservations.  Take advantage of the fact that a cowextsize
> +# hint causes creation of large speculative delalloc reservations in the cow
> +# fork to reduce the amount of work we have to do.
> +#
> +# The maximum cowextsize can only be set to MAXEXTLEN fs blocks on a filesystem
> +# whose AGs each have more than MAXEXTLEN * 2 blocks.  This we can do easily
> +# with a multi-terabyte filesystem, so start by setting up the hint.  Note that
> +# the current fsxattr interface specifies its u32 cowextsize hint in units of
> +# bytes and therefore can't handle MAXEXTLEN * blksz on most filesystems, so we
> +# set it via mkfs because mkfs takes units of fs blocks, not bytes.
> +
> +_mkfs_dev -d cowextsize=$MAXEXTLEN -l size=256m $loop_dev >> $seqres.full
> +mkdir $loop_mount
> +mount $loop_dev $loop_mount
> +
> +echo "Create crazy huge file"
> +huge_file="$loop_mount/a"
> +touch "$huge_file"
> +blksz=$(_get_file_block_size "$loop_mount")
> +extsize_bytes="$(( MAXEXTLEN * blksz ))"
> +
> +# Make sure it actually set a hint.
> +curr_cowextsize_str="$($XFS_IO_PROG -c 'cowextsize' "$huge_file")"
> +echo "$curr_cowextsize_str" >> $seqres.full
> +cowextsize_bytes="$(echo "$curr_cowextsize_str" | sed -e 's/^.\([0-9]*\).*$/\1/g')"
> +test "$cowextsize_bytes" -eq 0 && echo "could not set cowextsize?"
> +
> +# Now we have to seed the file with sparse contents.  Remember, the goal is to
> +# create a little more than 2^32 delayed allocation blocks in the COW fork with
> +# as little effort as possible.  We know that speculative COW preallocation
> +# will create MAXEXTLEN-length reservations for us, so that means we should
> +# be able to get away with touching a single byte every extsize_bytes.  We
> +# do this backwards to avoid having to move EOF.
> +seq $nr_cows -1 0 | while read n; do
> +	off="$((n * extsize_bytes))"
> +	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
> +done
> +
> +echo "Reflink crazy huge file"
> +_cp_reflink "$huge_file" "$huge_file.b"
> +
> +# Now that we've shared all the blocks in the file, we touch them all again
> +# to create speculative COW preallocations.
> +echo "COW crazy huge file"
> +seq $nr_cows -1 0 | while read n; do
> +	off="$((n * extsize_bytes))"
> +	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
> +done
> +
> +# Compare the number of blocks allocated to this file (as reported by stat)
> +# against the number of blocks that are in the COW fork.  If either one is
> +# less than 2^32 then we have evidence of an overflow problem.
> +echo "Check crazy huge file"
> +allocated_stat_blocks="$(stat -c %b "$huge_file")"
> +stat_blksz="$(stat -c %B "$huge_file")"
> +allocated_fsblocks=$(( allocated_stat_blocks * stat_blksz / blksz ))
> +
> +# Make sure we got enough COW reservations to overflow a 32-bit counter.
> +
> +# Return the number of delalloc & real blocks given bmap output for a fork of a
> +# file.  Output is in units of 512-byte blocks.
> +count_fork_blocks() {
> +	$AWK_PROG "
> +{
> +	if (\$3 == \"delalloc\") {
> +		x += \$4;
> +	} else if (\$3 == \"hole\") {
> +		;
> +	} else {
> +		x += \$6;
> +	}
> +}
> +END {
> +	print(x);
> +}
> +"
> +}
> +
> +# Count the number of blocks allocated to a file based on the xfs_bmap output.
> +# Output is in units of filesystem blocks.
> +count_file_fork_blocks() {
> +	local tag="$1"
> +	local file="$2"
> +	local args="$3"
> +
> +	$XFS_IO_PROG -c "bmap $args -l -p -v" "$huge_file" > $tmp.extents
> +	echo "$tag fork map" >> $seqres.full
> +	cat $tmp.extents >> $seqres.full
> +	local sectors="$(count_fork_blocks < $tmp.extents)"
> +	echo "$(( sectors / (blksz / 512) ))"
> +}
> +
> +cowblocks=$(count_file_fork_blocks cow "$huge_file" "-c")
> +attrblocks=$(count_file_fork_blocks attr "$huge_file" "-a")
> +datablocks=$(count_file_fork_blocks data "$huge_file" "")
> +
> +# Did we create more than 2^32 blocks in the cow fork?
> +# Make sure the test actually set us up for the overflow.
> +echo "datablocks is $datablocks" >> $seqres.full
> +echo "attrblocks is $attrblocks" >> $seqres.full
> +echo "cowblocks is $cowblocks" >> $seqres.full
> +test "$cowblocks" -lt $((2 ** 32)) && \
> +	echo "cowblocks (${cowblocks}) should be more than 2^32!"
> +
> +# Does stat's block allocation count exceed 2^32?
> +# This is how we detect the incore delalloc count overflow.
> +echo "stat blocks is $allocated_fsblocks" >> $seqres.full
> +test "$allocated_fsblocks" -lt $((2 ** 32)) && \
> +	echo "stat blocks (${allocated_fsblocks}) should be more than 2^32!"
> +
> +# Finally, does st_blocks match what we computed from the forks?
> +# Sanity check the values computed from the forks.
> +expected_allocated_fsblocks=$((datablocks + cowblocks + attrblocks))
> +echo "expected stat blocks is $expected_allocated_fsblocks" >> $seqres.full
> +
> +_within_tolerance "st_blocks" $allocated_fsblocks $expected_allocated_fsblocks 2% -v
> +
> +echo "Test done"
> +# Quick check the large sparse fs, but skip xfs_db because it doesn't scale
> +# well on a multi-terabyte filesystem.
> +LARGE_SCRATCH_DEV=yes _check_xfs_filesystem $loop_dev none none
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/907.out b/tests/xfs/907.out
> new file mode 100644
> index 00000000..cc07d659
> --- /dev/null
> +++ b/tests/xfs/907.out
> @@ -0,0 +1,8 @@
> +QA output created by 907
> +Format and mount
> +Create crazy huge file
> +Reflink crazy huge file
> +COW crazy huge file
> +Check crazy huge file
> +st_blocks is in range
> +Test done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ffe4ae12..e528c559 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -504,3 +504,4 @@
>  504 auto quick mkfs label
>  505 auto quick spaceman
>  506 auto quick health
> +907 clone
> 
