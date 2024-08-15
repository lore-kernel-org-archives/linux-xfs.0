Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5F77E107
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723751672; cv=pass; b=aLWqszAWSoJTutauzvRR7wRbV3lXT7IGfR0Vy68A8uL1CYEaR12YrckHOv7FQ5+iW8dkcMQx/dlj9eTvhf5p2hYBkzalGeM3AqI5qq60X3GfkViGkRMawd/+15h8ccK1JSjLakw2ig9TsYNCMGd3z8YGgNU4G1/mjtZAW9ZU0ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723751672; c=relaxed/simple;
	bh=UU3XHi7Hih7iaFgEwTyXlMxqZdauo5OmThWTVmv7d4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTzmC1U+NeTvlDYW3tlGYN6Jt1uNClAcloBjjzd/7H9XIMEs8hxA+Ejq4vwaBdzhPs8MVUrnSu9RfqqzQ3PAkKczpVU+AUnQsg2ORw5mJIkN/zJ73lw1Mxd2Sgq7nGF5tj4mRn+pUKQmHPD2Esib1Iemg9e/r5giK9Ba55ketac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=UmyL015B; arc=pass smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="UmyL015B"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B9032505D4F
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:37:45 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3F010506DA5
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:37:45 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723750665; a=rsa-sha256;
	cv=none;
	b=AJYVVKhghwJtV6f5vNO3nv0+9d8K7Oxg6e/wAObtXArNDU7bKrG1OTie/IZRk6rhPWpTLR
	ctvU+t+YosWQHn6huG1wq30ep7lNpHRlni7zrVR0MHmAPMYsUq8NFGnCUalDX70k05ojzV
	pqbQhGlaU2LUOyQyoVhSlDUnOTpdiRRrzvzPKOEk7K8VqsEd7mcKik+kROFhSXgW4CuJk/
	OHKlk830Py5Qj4AvfK+0egB2k1WZGlIjgllliwRxVja+z1AOPqM/4Vqv2BvMGcM6zbJoXz
	rsWx0AD7xtaJrO1AG275O3X0LuWzVG7FbBGr4SvNVBGCX5RWld2mEO0cv7SRRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723750665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ifarn2MUWQYbQq5OO7YyBq3UvZOk0iHxIPqUL1z3Xq0=;
	b=IO57R+dQLBqEYkHBbh6qdqQj4GDnIIDOW1zmA5fyjemvrrxmg8NruWwmJTv+8MKhisPbDj
	2siLdONNSiwLJ+1Ybb+4/jntunRp/doUXqfM9Qe0LnKt9Mc3pMP7fwcKABwOuZ/hlBkMBf
	9lcw2/WZXNXatH+FiWuCImf4MiQ3cC0vqYNFXNqQLVX79IgNuRzz8CODdWdF6Q0XcrVdo1
	ar5UD4NJf6bo+HwvRQSq0zFN45uJZ9Y2DYFvLz4HMBiAxfaQy9fsUNT6vodBBxzFq8rOu4
	cDvoelwbl2aR04Ce/dISR3gzgEuLqTJnxSdVdeBSLg/TStYmB2D3P6ynPtFymQ==
ARC-Authentication-Results: i=1;
	rspamd-c4b59d8dc-cwtkn;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Eight-Skirt: 6ccc8a0d7b6016f7_1723750665485_2798318950
X-MC-Loop-Signature: 1723750665485:3174574410
X-MC-Ingress-Time: 1723750665485
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.172.63 (trex/7.0.2);
	Thu, 15 Aug 2024 19:37:45 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4WlFlD5WM7zdq
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723750664;
	bh=Ifarn2MUWQYbQq5OO7YyBq3UvZOk0iHxIPqUL1z3Xq0=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=UmyL015BIesdMdR3Dg7/GoY9ZM2JRvK78nt4ze1y+oPZcjWBjNNwEpPKR/sQ9EwLt
	 1b9jWrkx7eDzwmR05KfsIXSmb1t+q+MMlPmdnubElhY/g1kOob/mbCozj3XxB3Nqql
	 Fgk2zXIJptZSpwOUJ4VZTBLnx3LbeT+x2OZxKb1DSrCnNtQuiQM87tWtzyuiFostNc
	 Fi4xvnGYM3bJp6WGqmDULRuBxo82QxA0f34LanlWtzQfSX817tn8xZAqvQAD1rV7r1
	 o7xm/qvDmRQJuiTtP1b/bN3gj26+GI2OBQwddveLcRWD4uw4KvhDgUjwPmoasV0aNp
	 4513iBONQbRGg==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 12:37:43 -0700
Date: Thu, 15 Aug 2024 12:37:43 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [RFC PATCH 1/2] xfs/608: a test case for xfs_bmap_extents_to_btree
 allocation failure
Message-ID: <93406e287e0def5605754f053d8680b11a4a44dd.1723690703.git.kjlx@templeofstupid.com>
References: <cover.1723687224.git.kjlx@templeofstupid.com>
 <cover.1723690703.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1723690703.git.kjlx@templeofstupid.com>

Add a test case that reproduces the xfs_bmap_extents_to_btree warnings
that can be seen when a filesystem runs out of space while performing a
dependent allocation.  This test should be 100% reproducible on older
kernels, prior to the AG-aware allocator re-write.

The test runs a busy work job to keep another AG occupied in order to
trigger the problem regardless of kernel version.  However, this is only
partially successful.  On newer kernels, wiht the AG-aware allocator,
this test now triggers the failure around 40-50% of the time on the
author's test machine.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 tests/xfs/608     | 372 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/608.out |   2 +
 2 files changed, 374 insertions(+)
 create mode 100755 tests/xfs/608
 create mode 100644 tests/xfs/608.out

diff --git a/tests/xfs/608 b/tests/xfs/608
new file mode 100755
index 00000000..9db8d21f
--- /dev/null
+++ b/tests/xfs/608
@@ -0,0 +1,372 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 608
+#
+# This test reproduces the xfs_bmap_extents_to_btree WARN that occurs when XFS
+# fails to allocate a block for the new b-tree in the desired AG.  This should
+# reproduce the issue on kernels that predate the fix for the AG-aware extent
+# allocator (< 6.3).
+#
+. ./common/preamble
+_begin_fstest dangerous insert prealloc punch
+
+# Override the default cleanup function.
+ _cleanup()
+{
+	cd /
+	_destroy_loop_device $LOOP_DEV
+	rm -f $tmp.* $LOOP_FILE
+}
+
+declare -a workers
+
+busy_work()
+{
+	while :
+	do
+		$XFS_IO_PROG -f -c "falloc 0 $BLOCK_SIZE" $BUSY_FILE
+		$XFS_IO_PROG -f -c "fpunch 0 $BLOCK_SIZE" $BUSY_FILE
+	done
+}
+
+kill_busy_procs()
+{
+	for pid in ${workers[@]}; do
+		kill $pid
+		wait $pid
+	done
+	# Despite killing the workers and waiting for them to exit, we still
+	# sometimes get an EBUSY unmounting the loop device.  Wait a second
+	# before returning to give lingering refcounts a chance to reach zero.
+	sleep 1
+}
+
+find_freesp()
+{
+	umount $LOOP_MNT
+	local freesp=$($XFS_DB_PROG $LOOP_DEV -c "agf 1" -c "print freeblks" \
+		| awk '{print $3}')
+	mount -o nodiscard $LOOP_DEV $LOOP_MNT
+	echo $freesp
+}
+
+find_biggest_freesp()
+{
+	umount $LOOP_MNT
+	local freesp=$($XFS_DB_PROG $LOOP_DEV -c 'agf 1' -c 'addr cntroot' \
+		-c btdump | sed -rn  's/^[0-9]+:\[[0-9]+,([0-9]+)\].*/\1/p' \
+		| tail -1)
+	mount -o nodiscard $LOOP_DEV $LOOP_MNT
+	echo $freesp
+}
+
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_test
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "fpunch"
+
+# Require loop devices so that this test can create a small filesystem with
+# a specific geometry that assists in making this easier to reproduce.
+_require_loop
+
+LOOP_FILE=$TEST_DIR/$seq.img
+LOOP_MNT=$TEST_DIR/$seq.mnt
+mkdir -p $LOOP_MNT
+$XFS_IO_PROG -ft -c "truncate 2g" $LOOP_FILE >> $seqres.full
+LOOP_DEV=`_create_loop_device $LOOP_FILE`
+loop_mkfs_addl_opts=
+
+$MKFS_XFS_PROG 2>&1 | grep -q rmapbt && \
+        loop_mkfs_addl_opts="$loop_mkfs_addl_opts,rmapbt=0"
+$MKFS_XFS_PROG 2>&1 | grep -q reflink && \
+        loop_mkfs_addl_opts="$loop_mkfs_addl_opts,reflink=1"
+
+_mkfs_dev "-b size=4096 -m crc=1$loop_mkfs_addl_opts -d size=1708m,agcount=2" \
+       " -l size=1986b" $LOOP_DEV >> $seqres.full
+# nodiscard makes the unbusying of extents more predictable which makes the test
+# repeatable.
+_mount -o nodiscard $LOOP_DEV $LOOP_MNT
+
+BLOCK_SIZE=$(_get_file_block_size $LOOP_MNT)
+
+# Add a directory under the root of LOOP_MNT in order to ensure the files placed
+# there end up in AG 1.
+
+TEST_SUBDIR=testdir/testsubdir
+mkdir -p $LOOP_MNT/$TEST_SUBDIR
+
+# There are 3 files in this test.  The first is allocated to consume most of the
+# space in the AG.  The test then punches holes in the file in order to allow
+# the second file to allocate the fragmented blocks as individual extents.  The
+# second file is written such that it is only a couple of operations away from
+# being converted from in-line extents to a b-tree in its bmbt.  The third file
+# simply exists for us to allocate spare blocks to in order to take the AG right
+# up against ENOSPC.
+
+FILE1=$LOOP_MNT/$TEST_SUBDIR/file1
+FILE2=$LOOP_MNT/$TEST_SUBDIR/file2
+FILE3=$LOOP_MNT/$TEST_SUBDIR/file3
+
+# BUSY_FILE is here to keep AG0 busy on versions of XFS where the allocator is
+# allowed to check lower numbered AGs if it fails in a higher numbered one.
+BUSY_FILE=$LOOP_MNT/testdir/busyfile
+
+# Calculate the number of extents we need in the cnobt and bnobt.  This should
+# be the maximum b-tree leaf size minus one, so that after adding two extents a
+# split is triggered.
+
+# The test is currently set to always use CRC, otherwise this would be 56 if CRC
+# and 16 if not.
+alloc_block_len=56
+allocbt_leaf_maxrecs=$(((BLOCK_SIZE - alloc_block_len) / 8))
+
+# Look at the attrfork offset in FILE2's inode in order to determine the number
+# of extents before this splits to a b-tree.  This test assumes a v5 filesystem
+# so if forkoff is zero, it falls back to LITINO of 336 and uses a bmbt_rec_size
+# of 16.
+touch $FILE2
+file2_inode=$(stat -c '%i' "$FILE2")
+# Temporarily unmount while parameters are gathered via xfs_db
+umount $LOOP_MNT
+forkoff=$($XFS_DB_PROG $LOOP_DEV -c "inode $file2_inode" \
+	-c "print core.forkoff" | awk '{print $3}')
+freeblks=$($XFS_DB_PROG $LOOP_DEV -c "agf 1" \
+	-c "print freeblks" | awk '{print $3}')
+mount -o nodiscard $LOOP_DEV $LOOP_MNT
+
+# We'll recreate FILE2 later.  For now be as empty as we can.
+rm $FILE2
+
+# Some versions of xfs_db contain the agresv command, but not all do.
+# Additionally, some parameters about how much space is actually allocatable
+# aren't visible from xfs_db.  Tracepoints have been helpful in figuring this
+# out when developing the test by hand.  Instead of trying to parse ftrace data
+# and hope that the right tracepoints are available, brute force the actual
+# allocatable maximum size by repeatedly trying to allocate larger offsets
+# subtracted from $freeblks until one succeeds.
+for (( i = 0, ag = 0; ; i++ ))
+do
+	$XFS_IO_PROG -f -c "falloc 0 $(( (freeblks-i)*BLOCK_SIZE ))" $FILE1
+	ag=$(xfs_bmap -v -n 1 $FILE1 | tail -1 | awk '{print $4}')
+	rm $FILE1
+	(( ag == 1 )) && break
+done
+
+# Let free'd extents unbusy
+sleep 30
+
+# At this point, $i is one larger than whatever the allocator thinks the maximum
+# available space is. This is based upon the asssumption that the data
+# allocation we made above set minleft = 1, so the allocation that finally fit
+# into AG 1 has had any reservation withheld along with the space the allocator
+# requested be withheld for any bmbt expansion.
+freeblkseff=$((freeblks - i - 1))
+blocks_withheld=$((i+1))
+
+iforksize=$((forkoff > 0 ? forkoff * 8 : 336))
+maxextents=$((iforksize / 16))
+# We'll need to allocate maxextents - 1 for this test, so that the last
+# allocation to the file forces an extents -> b-tree conversion.
+wanted_extents=$((maxextents - 1))
+
+# The first allocation is just a big chunk into the first file. Grab the
+# majority of the free blocks.
+first_alloc_blocks=$((freeblkseff - 8192))
+
+$XFS_IO_PROG -f -c "falloc 0 $((BLOCK_SIZE * first_alloc_blocks))" $FILE1 >> \
+	$seqres.full
+
+# Insert space in the middle in order to help the allocator pick sequential
+# blocks when we add space back later.  If we don't do this, then it can break
+# up larger extents instead of grabbing the ones we fpunch'd out.
+#
+# The insert offset was chosen arbitrarily and placed towards the beginning of
+# the file for the conveinence of humans.  The insert_blocks size needs to be
+# larger than the space we'll later punch out of file 2 and insert back into
+# file 1.  This is on the order of 7 blocks, so 512 should always be large
+# enough.
+first_insert_offset=$((BLOCK_SIZE * 2083))
+first_insert_blocks=$((BLOCK_SIZE * 512))
+
+$XFS_IO_PROG -f -c "finsert $first_insert_offset $first_insert_blocks" \
+	$FILE1 >> $seqres.full
+
+# Punch 3-block holes into the file.  This number was chosen so that we could
+# re-allocate blocks from these chunks without causing the extent to get removed
+# from the free-space btrees.
+#
+# Punch enough holes to ensure that the bnobt and cnobt end up two extents away
+# from a b-tree split, and overshoot that value by the number we need to consume
+# in the second file to end up with wanted_extents - 1.
+num_holes=$(((allocbt_leaf_maxrecs-2) + (wanted_extents - 1)))
+end_hole_offset=$((num_holes * 4 - 3))
+hole_blocks=$((BLOCK_SIZE * 3))
+
+for i in $(seq 1 4 $end_hole_offset); do
+	$XFS_IO_PROG -f -c "fpunch $((BLOCK_SIZE * i))  $hole_blocks" \
+		$FILE1 >> $seqres.full
+done
+
+# Use the newly created holes to create extents in our victim file.  The goal is
+# to allocate up to the point of b-tree conversion minus 2.  The remaining space
+# is placed in the n-1 extent, and then the last is reserved for the split we
+# trigger later.  The holes are placed after a gap that's left towards the front
+# of the file to allocate the rest of the space.  This is done to get the
+# allocator to give us the contiguous free chunk that would have previously been
+# occupied by the per-AG reservation's free space.
+alloc_hole_seq=$(((wanted_extents - 1) * 4 - 3))
+
+# The offset for the placement of the holes needs to be after the remaining
+# freespace chunk so calculate how big that needs to be first.  We may need to
+# recalculate this value to account for blocks freed from the AGFL later.
+biggest_freesp=$(find_biggest_freesp)
+
+# 3x the biggest chunk of free blocks should be a big enough gap
+hole_offset=$((biggest_freesp * 3))
+
+for i in $(seq 1 4 $alloc_hole_seq); do
+	$XFS_IO_PROG -f \
+		-c "falloc $((BLOCK_SIZE * (i+hole_offset))) $hole_blocks" \
+		$FILE2 >> $seqres.full
+done
+
+# Attempt to compensate for any late-breaking over/undershoot in the desired
+# extent count by checking the number of extents in the bnobt and adding or
+# removing space to try to arrive at the desired number.
+umount $LOOP_MNT
+current_extents=$($XFS_DB_PROG $LOOP_DEV -c 'agf 1' -c 'addr bnoroot' \
+	-c 'btdump' | grep recs | sed -rn 's/^recs\[.*\-([0-9]+)\].*/\1/p' | \
+	awk '{a +=int($1)} END{printf("%d\n", a);}')
+mount -o nodiscard $LOOP_DEV $LOOP_MNT
+
+wanted_allocbt=$((allocbt_leaf_maxrecs-2))
+if [[ $current_extents -gt $wanted_allocbt ]]; then
+	ext_diff=$(( current_extents - wanted_allocbt ))
+	end_offset=$(( ext_diff * 4 - 3 ))
+	for i in $(seq 1 4 $end_offset); do
+		$XFS_IO_PROG -f -c "falloc $((BLOCK_SIZE * i)) $hole_blocks" \
+			$FILE1 >> $seqres.full
+	done
+elif [[ $current_extents -lt $wanted_allocbt ]]; then
+	ext_diff=$(( wanted_allocbt - current_extents ))
+	end_offset=$(( (ext_diff * 4 - 3) + end_hole_offset ))
+	for i in $(seq $end_hole_offset 4 $end_offset); do
+		$XFS_IO_PROG -f -c "fpunch $((BLOCK_SIZE * i )) $hole_blocks" \
+			$FILE1 >> $seqres.full
+	done
+fi
+
+# The previous falloc should have triggered a reverse-split of the freespace
+# btrees.  The next alloc should cause the freelist to be drained.  Recompute
+# the available freespace with the understanding that we'll need to do this
+# again after the AGFL is trimmed by the next allocation.  Leave a few blocks
+# free so that we can use FILE3 to create the last needed set of free extents
+# before triggering a split while simultaneously using the remaining space.
+freesp_remaining=$(find_freesp)
+f2_alloc_blocks=$((freesp_remaining - blocks_withheld - 10))
+
+$XFS_IO_PROG -f -c "falloc 0 $((BLOCK_SIZE * f2_alloc_blocks))" \
+	$FILE2 >> $seqres.full
+
+# Recompute the remaining blocks and let FILE3 consume the remainder of the
+# space.  This is intended to both leave one more free extent in the btrees and
+# take us down to being right before ENOSPC.
+freesp_remaining=$(find_freesp)
+f3_alloc_blocks=$((freesp_remaining - blocks_withheld))
+biggest_freesp=$(find_biggest_freesp)
+
+# Due to variance outside of the control of the test, the remaining freespace
+# may be broken into smaller chunks than it's possible to allocate in a single
+# attempt.  If the test tries to allocate one big chunk, that allocation will
+# fail and consult the next AG.  To prevent that from happening, check the size
+# of the remaining freespace in AG1 and break this allocation into smaller
+# chunks that a) consume space from AG1 and b) do not cause the extents we've
+# carefully added to the freespace trees to get removed.
+if [[ $f3_alloc_blocks -lt $biggest_freesp ]]; then
+	$XFS_IO_PROG -f -c "falloc 0 $((BLOCK_SIZE * f3_alloc_blocks))" \
+		$FILE3 >> $seqres.full
+else
+	alloc_left=$f3_alloc_blocks
+	alloc_blocks=$((biggest_freesp - 1))
+	alloc_ofst=0
+	while ((alloc_left > 0)); do
+		size=$((alloc_blocks * BLOCK_SIZE))
+		$XFS_IO_PROG -f -c "falloc $alloc_ofst $size" \
+			$FILE3 >> $seqres.full
+		alloc_left=$((alloc_left - alloc_blocks))
+		alloc_ofst=$((alloc_ofst + (1000*BLOCK_SIZE)))
+		biggest_freesp=$(find_biggest_freesp)
+		if [[ $alloc_left -lt $biggest_freesp ]]; then
+			alloc_blocks=$alloc_left
+		else
+			alloc_blocks=$((biggest_freesp - 1))
+		fi
+	done
+fi
+
+# That's it for the setup.  Now the test punches out a 12 block extent as one 6
+# block chunk in the middle, followed by two 3 block chunks on either side.  It
+# sleeps after the 6 block chunk so that portion of the extent will un-busy, but
+# the 3 block chunks on either side stay (temporarily) unavailable.  While the
+# chunks on either side are busy, re-allocate some of the space that's been
+# free'd back to FILE1 so that the final falloc to FILE2 brings us to ENOSPC.
+f2_off=2560
+$XFS_IO_PROG -f -c "fpunch $((BLOCK_SIZE * f2_off)) $((BLOCK_SIZE * 6))" \
+	$FILE2 >> $seqres.full
+# Before we finish punching the final holes, start up some busy workers to keep
+# the _other_ AG's locks contended.  This isn't needed to reproduce the problem
+# prior to the AG-aware allocator's arrival.  Ncpu * 4 has been successful at
+# reproducing the problem in places where a lower number of workers succeeds
+# intermittently (or not at all).
+ncpu=$(nproc)
+for ((i=0 ; i < ncpu*4; i++)); do
+	busy_work &
+	workers[$i]=$!
+done
+
+# Wait for first fpunch to unbusy, and then continue with remainder.
+sleep 30
+$XFS_IO_PROG -f -c "fpunch $((BLOCK_SIZE * (f2_off + 6))) $((BLOCK_SIZE * 3))" \
+	$FILE2 >> $seqres.full
+$XFS_IO_PROG -f -c "fpunch $((BLOCK_SIZE * (f2_off - 3))) $((BLOCK_SIZE * 3))" \
+	$FILE2 >> $seqres.full
+
+# Put 7 blocks back into FILE1 to consume some of the space free'd above.
+# The offset here was picked so that the allocator takes blocks from the 3 block
+# chunks we punched earlier, but leaves the extents intact in the freespace
+# trees.
+f1_off=1956
+f1_wanted_blocks=7
+f1_alloc_seq=$((f1_wanted_blocks * 4 - 3))
+for i in $(seq 1 4 $f1_alloc_seq); do
+	$XFS_IO_PROG -f -c "falloc $((BLOCK_SIZE * (i+f1_off))) $BLOCK_SIZE" \
+		$FILE1 >> $seqres.full
+done
+
+# This next falloc should result in FILE2's bmbt getting converted from extents
+# to btree while simultaneously splitting the bnotbt and cnobt.  The first
+# allocation succeeds, splits the free space trees, consumes all the blocks in
+# the agfl, and leaves us in a situation where the second allocation to convert
+# from extents to a btree fails.
+$XFS_IO_PROG -f -c "falloc $((BLOCK_SIZE * f2_off)) $((BLOCK_SIZE * 5))" \
+	$FILE2 >> $seqres.full
+
+# Terminate the busy workers or else umount will return EBUSY.
+kill_busy_procs
+
+umount $LOOP_MNT
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/608.out b/tests/xfs/608.out
new file mode 100644
index 00000000..1e534458
--- /dev/null
+++ b/tests/xfs/608.out
@@ -0,0 +1,2 @@
+QA output created by 608
+Silence is golden
-- 
2.25.1

