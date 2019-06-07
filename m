Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfFGLYi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 07:24:38 -0400
Date: Fri, 7 Jun 2019 07:24:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/1] xfs: check for COW overflows in i_delayed_blks
Message-ID: <20190607112429.GA57123@bfoster>
References: <155968302402.1647082.16959798703857853077.stgit@magnolia>
 <155968303075.1647082.5031279746723706503.stgit@magnolia>
 <20190606191449.GB2791@bfoster>
 <20190606200249.GA1688126@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606200249.GA1688126@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jun 06, 2019 at 01:02:49PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 06, 2019 at 03:14:50PM -0400, Brian Foster wrote:
> > On Tue, Jun 04, 2019 at 02:17:10PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > With the new copy on write functionality it's possible to reserve so
> > > much COW space for a file that we end up overflowing i_delayed_blks.
> > > The only user-visible effect of this is to cause totally wrong i_blocks
> > > output in stat, so check for that.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  tests/xfs/907     |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/907.out |    8 ++
> > >  tests/xfs/group   |    1 
> > >  3 files changed, 232 insertions(+)
> > >  create mode 100755 tests/xfs/907
> > >  create mode 100644 tests/xfs/907.out
> > > 
> > > 
> > > diff --git a/tests/xfs/907 b/tests/xfs/907
> > > new file mode 100755
> > > index 00000000..d85f12da
> > > --- /dev/null
> > > +++ b/tests/xfs/907
> > > @@ -0,0 +1,223 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0+
> > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 907
> > > +#
> > > +# Try to overflow i_delayed_blks by setting the largest cowextsize hint
> > > +# possible, creating a sparse file with a single byte every cowextsize bytes,
> > > +# reflinking it, and retouching every written byte to see if we can create
> > > +# enough speculative COW reservations to overflow i_delayed_blks.
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 7 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	test -n "$loop_mount" && $UMOUNT_PROG $loop_mount > /dev/null 2>&1
> > > +	test -n "$loop_dev" && _destroy_loop_device $loop_dev
> > > +	rm -rf $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/reflink
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_os Linux
> > > +_supported_fs xfs
> > > +_require_scratch_reflink
> > > +_require_cp_reflink
> > > +_require_loop
> > > +_require_xfs_debug	# needed for xfs_bmap -c
> > > +
> > > +MAXEXTLEN=2097151	# cowextsize can't be more than MAXEXTLEN
> > > +
> > > +echo "Format and mount"
> > > +_scratch_mkfs > "$seqres.full" 2>&1
> > > +_scratch_mount
> > > +
> > > +# Create a huge sparse filesystem on the scratch device because that's what
> > > +# we're going to need to guarantee that we have enough blocks to overflow in
> > > +# the first place.  We need to have at least enough free space on that huge fs
> > > +# to handle one written block every MAXEXTLEN blocks and to reserve 2^32 blocks
> > > +# in the COW fork.  There needs to be sufficient space in the scratch
> > > +# filesystem to handle a 256M log, all the per-AG metadata, and all the data
> > > +# written to the test file.
> > > +#
> > > +# Worst case, a 64k-block fs needs to be about 300TB.  Best case, a 1k block
> > > +# filesystem needs ~5TB.  For the most common 4k case we only need a ~20TB fs.
> > > +#
> > > +# nr_cows is the number of writes we make to the filesystem.
> > > +# blks_needed is the number of free blocks we need in the fs to trigger the
> > > +#     overflow.  The destination file needs to have more than 2^32 blocks
> > > +#     reserved for COW, and the source file needs to have 1 block written every
> > > +#     MAXEXTLEN blocks (i.e. 2^32/MAXEXTLEN blocks) to set up the destination
> > > +#     file.
> > > +# loop_file_sz is the size of the filesystem we have to create to produce the
> > > +#     overflow problems.  This is 20% more than blks_needed, and rounded to the
> > > +#     nearest 512b so losetup doesn't whine.
> > > +# est_nr_ags is a guess at the AG count, assuming that we'll have one AG per
> > > +#     terabyte (which assumes that we need a multi-terabyte filesystem for this
> > > +#     test).  We assume we'll need 16 blocks for AG metadata and 128K for inode
> > > +#     chunks.
> > > +# space_reqd_kb is the size of the huge sparse filesystem --
> > > +#     256M for the log, per-AG metadata, and 10% more space than however much
> > > +#     we will write to both test files.
> > > +blksz=$(_get_file_block_size "$SCRATCH_MNT")
> > > +nr_cows="$(( ((2 ** 32) / MAXEXTLEN) + 100 ))"
> > > +blks_needed="$(( nr_cows * (1 + MAXEXTLEN) ))"
> > > +loop_file_sz="$(( ((blksz * blks_needed) * 12 / 10) / 512 * 512 ))"
> > > +est_nr_ags="$(( (loop_file_sz / (2 ** 40)) + 1 ))"
> > > +est_ag_space_kb="$(( (est_nr_ags * 16 * blksz / 1024) + 128 ))"
> > > +est_file_space_kb="$(( (((nr_cows * blksz) * 11 / 10) / 1024) ))"
> > > +space_reqd_kb="$(( 262144 + est_ag_space_kb + 2 * est_file_space_kb ))"
> > > +cat >> $seqres.full << ENDL
> > > +blksz: $blksz
> > > +nr_cows: $nr_cows
> > > +blks_needed: $blks_needed
> > > +loop_file_sz: $loop_file_sz
> > > +est_nr_ags: $est_nr_ags
> > > +est_ag_space_kb: $est_ag_space_kb
> > > +est_file_space_kb: $est_file_space_kb
> > > +space_reqd_kb: $space_reqd_kb
> > > +ENDL
> > > +_require_fs_space $SCRATCH_MNT $space_reqd_kb
> > > +
> > 
> > This seems like it would be simpler to just create the worst case sparse
> > fs (say 300TB or so) then make sure the scratch device has enough free
> > blocks to accommodate the number of COWs (plus slop) that need to occur
> > in the loop fs to overflow the counter. I don't have a 64k box handy,
> > but the metadata size difference between a sparse 20TB fs and 300TB fs
> > over a 4k scratch fs is only a few MB. Hm?
> 
> <shrug> Originally it did just hardcode 300T, and Eryu complained that
> xfs_db would OOM when it tried to deal with a 300T filesystem.  I
> changed the test to avoid xfs_db, but then it occurred to me (running on
> a slow arm64 box) that the mkfs and xfs_repair runtimes could be cut
> down considerably if the loop fs was only as large as it needed to be.
> 

Interesting.. do you recall how much of a difference it made? I don't
see much more than a second or two difference on my test vm, but I
haven't tried any slow arm or 64k page boxes.

Even then, that could be accomplished with a simple calculation of the
2^32 block requirement multiplied against the block size plus some slop
value like 1GB without significantly changing timing. I.e., the whole
big hunk above could be reduced to something like:

# Calculate the fs size based on block size and the number of delalloc blocks we
# must be able to reserve to overflow. Add some room to account for fs
# metadata overhead and round to 512b so losetup doesn't complain.
nr_cows="$(( ( (2 ** 32) / MAXEXTLEN ) + 100 ))"
loop_file_sz=$(( (nr_cows * MAXEXTLEN * blksz * 12 / 10) / 512 * 512 ))

>From there, we could either push the _require_fs_space() down after the
mkfs:

# Now that we've formatted the filesystem, make sure the scratch fs has enough
# room for $nr_cows blocks in two files, again allowing for some overhead.
_require_fs_space $SCRATCH_MNT $(( ( 2 * nr_cows * blksz * 12 / 10 ) / 1024 ))

Or if that's too hacky, just enforce a worst case value for the fs
metadata portion of the required space. As mentioned, the difference I
see between 20T and 300T on a 4k scratch dev is ~6MB. fiemap shows most
of that made up as 40 512b extents, which is 20kb. Extrapolate that out
to a 64k scratch fs and we come in under 20MB. ISTM we could just take
add something like 500MB/1GB to the _require_fs_space() calculation
above to account for the 256MB log + all other fs structure and still
allow the test to run in most cases.

Hmmmm.. unless I'm miscalculating, even the nr_cows portion of the
required space only comes out to ~320MB with a 64k scratch dev. Perhaps
we could skip all of this (except for the sizing of the loop file) and
just '_require_fs_space <1GB>' at the top of the test with a couple
lines of comment to document the worst case calculation. That leaves
plenty of extra space and is still small enough that it likely won't
filter out in most test envs. I also don't think we need to push
anything more than the resulting mkfs output to the $seqres.full file,
so altogether that allows us to remove almost a screen full of
calculation cruft from the test (if you account for the huge comment
required to document the calculations).

> > > +loop_file=$SCRATCH_MNT/a.img
> > > +loop_mount=$SCRATCH_MNT/a
> > > +$XFS_IO_PROG -f -c "truncate $loop_file_sz" $loop_file
> > > +loop_dev=$(_create_loop_device $loop_file)
> > > +
> > > +# Now we have to create the source file.  The goal is to overflow a 32-bit
> > > +# i_delayed_blks, which means that we have to create at least that many delayed
> > > +# allocation block reservations.  Take advantage of the fact that a cowextsize
> > > +# hint causes creation of large speculative delalloc reservations in the cow
> > > +# fork to reduce the amount of work we have to do.
> > > +#
> > > +# The maximum cowextsize can only be set to MAXEXTLEN fs blocks on a filesystem
> > > +# whose AGs each have more than MAXEXTLEN * 2 blocks.  This we can do easily
> > > +# with a multi-terabyte filesystem, so start by setting up the hint.  Note that
> > > +# the current fsxattr interface specifies its u32 cowextsize hint in units of
> > > +# bytes and therefore can't handle MAXEXTLEN * blksz on most filesystems, so we
> > > +# set it via mkfs because mkfs takes units of fs blocks, not bytes.
> > > +
> > > +_mkfs_dev -d cowextsize=$MAXEXTLEN -l size=256m $loop_dev >> $seqres.full
> > > +mkdir $loop_mount
> > > +mount $loop_dev $loop_mount
> > > +
> > > +echo "Create crazy huge file"
> > > +huge_file="$loop_mount/a"
> > > +touch "$huge_file"
> > > +blksz=$(_get_file_block_size "$loop_mount")
> > > +extsize_bytes="$(( MAXEXTLEN * blksz ))"
> > > +
> > > +# Make sure it actually set a hint.
> > > +curr_cowextsize_str="$($XFS_IO_PROG -c 'cowextsize' "$huge_file")"
> > > +echo "$curr_cowextsize_str" >> $seqres.full
> > > +cowextsize_bytes="$(echo "$curr_cowextsize_str" | sed -e 's/^.\([0-9]*\).*$/\1/g')"
> > > +test "$cowextsize_bytes" -eq 0 && echo "could not set cowextsize?"
> > > +
> > > +# Now we have to seed the file with sparse contents.  Remember, the goal is to
> > > +# create a little more than 2^32 delayed allocation blocks in the COW fork with
> > > +# as little effort as possible.  We know that speculative COW preallocation
> > > +# will create MAXEXTLEN-length reservations for us, so that means we should
> > > +# be able to get away with touching a single byte every extsize_bytes.  We
> > > +# do this backwards to avoid having to move EOF.
> > > +seq $nr_cows -1 0 | while read n; do
> > > +	off="$((n * extsize_bytes))"
> > > +	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
> > > +done
> > > +
> > > +echo "Reflink crazy huge file"
> > > +_cp_reflink "$huge_file" "$huge_file.b"
> > > +
> > > +# Now that we've shared all the blocks in the file, we touch them all again
> > > +# to create speculative COW preallocations.
> > > +echo "COW crazy huge file"
> > > +seq $nr_cows -1 0 | while read n; do
> > > +	off="$((n * extsize_bytes))"
> > > +	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
> > > +done
> > > +
> > > +# Compare the number of blocks allocated to this file (as reported by stat)
> > > +# against the number of blocks that are in the COW fork.  If either one is
> > > +# less than 2^32 then we have evidence of an overflow problem.
> > > +echo "Check crazy huge file"
> > > +allocated_stat_blocks="$(stat -c %b "$huge_file")"
> > > +stat_blksz="$(stat -c %B "$huge_file")"
> > > +allocated_fsblocks=$(( allocated_stat_blocks * stat_blksz / blksz ))
> > > +
> > > +# Make sure we got enough COW reservations to overflow a 32-bit counter.
> > > +
> > > +# Return the number of delalloc & real blocks given bmap output for a fork of a
> > > +# file.  Output is in units of 512-byte blocks.
> > > +count_fork_blocks() {
> > > +	$AWK_PROG "
> > > +{
> > > +	if (\$3 == \"delalloc\") {
> > > +		x += \$4;
> > > +	} else if (\$3 == \"hole\") {
> > > +		;
> > > +	} else {
> > > +		x += \$6;
> > > +	}
> > > +}
> > > +END {
> > > +	print(x);
> > > +}
> > > +"
> > > +}
> > > +
> > > +# Count the number of blocks allocated to a file based on the xfs_bmap output.
> > > +# Output is in units of filesystem blocks.
> > > +count_file_fork_blocks() {
> > > +	local tag="$1"
> > > +	local file="$2"
> > > +	local args="$3"
> > > +
> > > +	$XFS_IO_PROG -c "bmap $args -l -p -v" "$huge_file" > $tmp.extents
> > > +	echo "$tag fork map" >> $seqres.full
> > > +	cat $tmp.extents >> $seqres.full
> > > +	local sectors="$(count_fork_blocks < $tmp.extents)"
> > > +	echo "$(( sectors / (blksz / 512) ))"
> > > +}
> > > +
> > > +cowblocks=$(count_file_fork_blocks cow "$huge_file" "-c")
> > > +attrblocks=$(count_file_fork_blocks attr "$huge_file" "-a")
> > > +datablocks=$(count_file_fork_blocks data "$huge_file" "")
> > > +
> > > +# Did we create more than 2^32 blocks in the cow fork?
> > > +echo "datablocks is $datablocks" >> $seqres.full
> > > +echo "attrblocks is $attrblocks" >> $seqres.full
> > > +echo "cowblocks is $cowblocks" >> $seqres.full
> > > +test "$cowblocks" -lt $((2 ** 32)) && \
> > > +	echo "cowblocks (${cowblocks}) should be more than 2^32!"
> 
> This part checks that the test did what we expect.
> 

Ok, I guess I'd just tweak the one liner comments to explain the purpose
of each of these checks rather than reiterate the code. E.g., for the
check above:

# did cow speculative prealloc reserve enough to overflow?

> > > +
> > > +# Does stat's block allocation count exceed 2^32?

# detect delalloc count overflow via the stat data

> > > +echo "stat blocks is $allocated_fsblocks" >> $seqres.full
> > > +test "$allocated_fsblocks" -lt $((2 ** 32)) && \
> > > +	echo "stat blocks (${allocated_fsblocks}) should be more than 2^32!"
> 
> This part detects the problem in the incore state.
> 
> > > +# Finally, does st_blocks match what we computed from the forks?

# sanity check the values computed from the forks

Brian

> > > +expected_allocated_fsblocks=$((datablocks + cowblocks + attrblocks))
> > > +echo "expected stat blocks is $expected_allocated_fsblocks" >> $seqres.full
> > > +
> > > +_within_tolerance "st_blocks" $allocated_fsblocks $expected_allocated_fsblocks 2% -v
> 
> And this one on is a second sanity check that the test did roughly what
> we expected.
> 
> > > +
> > 
> > Similar question with the post-processing stuff... how much of this is
> > to detect the problem vs. determine the test sequence did what we
> > expect?
> 
> (Answered above.)
> 
> > Does the fs check below report corruption or is it purely
> > in-core state that ends up broken?
> 
> It's only the incore state that ends up broken.
> 
> --D
> 
> > Brian
> > 
> > > +echo "Test done"
> > > +# Quick check the large sparse fs, but skip xfs_db because it doesn't scale
> > > +# well on a multi-terabyte filesystem.
> > > +LARGE_SCRATCH_DEV=yes _check_xfs_filesystem $loop_dev none none
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/907.out b/tests/xfs/907.out
> > > new file mode 100644
> > > index 00000000..cc07d659
> > > --- /dev/null
> > > +++ b/tests/xfs/907.out
> > > @@ -0,0 +1,8 @@
> > > +QA output created by 907
> > > +Format and mount
> > > +Create crazy huge file
> > > +Reflink crazy huge file
> > > +COW crazy huge file
> > > +Check crazy huge file
> > > +st_blocks is in range
> > > +Test done
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index ffe4ae12..e528c559 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -504,3 +504,4 @@
> > >  504 auto quick mkfs label
> > >  505 auto quick spaceman
> > >  506 auto quick health
> > > +907 clone
> > > 
