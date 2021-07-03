Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DC7C07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 03:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74256108B
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 03:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhGCDG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhGCDG4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:06:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31C9F6108B
        for <linux-xfs@vger.kernel.org>; Sat,  3 Jul 2021 03:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281463;
        bh=qRqzUrxwFez3OFUoCIoIKzPWunfWnlRGFmUN00FsYFI=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=GpRVlvNjNb7HPk3JOW4Vn4Jl7/3zXeOZ4612jZ0qEwzON1M4eusutlTD2VQ/ylcsB
         QObpMFvc5d/3hZEIqaT3h/KTqQ0QycwFSHBb5iH4dbWMVVGdkYEgAAwfr9JXycldT1
         9pb8fUmvnRkL3CZJUwoNSiIBvbqNw3T6smcGoPSSlqxA4iWVCgS0B1/1Yln/O0O7uv
         w3Ua+YSUo1yENfWXc4OireOxTYJTI8Yt69XGClXQ7O4hYHgK4J31TjBEh2f7pNRhNU
         d+46DQoJwiaX3b6uzAPmVkayOcuULUZHCdxFLWYzIAnRIo1Do9tt5pv0sqSPZ2ahxc
         9hB88XAdmdX7A==
Date:   Fri, 2 Jul 2021 20:04:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [RFC PATCH] xfs: test regression in shrink when EOFS splits a sparse
 inode cluster
Message-ID: <20210703030422.GE24788@locust>
References: <20210703030157.GC24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703030157.GC24788@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a targeted regression test for the patch "xfs: check for sparse
inode clusters that cross new EOAG when shrinking", which was found by
running the random-loopy shrink stresser xfs/168.

The original shrink implementation assumed that if we could allocate the
last free extent in the filesystem, it was ok to proceed with the fs
shrink.  Unfortunately, this isn't quite the case -- if there's a sparse
inode cluster such that the blocks at the end of the cluster are free,
it is not ok to shrink the fs to the point that part of the cluster
hangs off the end of the filesystem.  Doing so results in repair and
scrub marking the filesystem corrupt, so we must not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/778     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/778.out |    2 +
 2 files changed, 192 insertions(+)
 create mode 100755 tests/xfs/778
 create mode 100644 tests/xfs/778.out

diff --git a/tests/xfs/778 b/tests/xfs/778
new file mode 100755
index 00000000..73cebaf1
--- /dev/null
+++ b/tests/xfs/778
@@ -0,0 +1,190 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 778
+#
+# Ensure that online shrink does not let us shrink the fs such that the end
+# of the filesystem is now in the middle of a sparse inode cluster.
+#
+. ./common/preamble
+_begin_fstest auto quick shrink
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_scratch
+_require_xfs_sparse_inodes
+_require_scratch_xfs_shrink
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+
+_scratch_mkfs "-d size=50m -m crc=1 -i sparse" |
+	_filter_mkfs > /dev/null 2> $tmp.mkfs
+. $tmp.mkfs	# for isize
+cat $tmp.mkfs >> $seqres.full
+
+daddr_to_fsblocks=$((dbsize / 512))
+
+convert_units() {
+	_scratch_xfs_db -f -c "$@" | sed -e 's/^.*(\([0-9]*\)).*$/\1/g'
+}
+
+# Figure out the next possible inode number after the log, since we can't
+# shrink or relocate the log
+logstart=$(_scratch_xfs_get_metadata_field 'logstart' 'sb')
+if [ $logstart -gt 0 ]; then
+	logblocks=$(_scratch_xfs_get_metadata_field 'logblocks' 'sb')
+	logend=$((logstart + logblocks))
+	logend_agno=$(convert_units "convert fsb $logend agno")
+	logend_agino=$(convert_units "convert fsb $logend agino")
+else
+	logend_agno=0
+	logend_agino=0
+fi
+
+_scratch_mount
+_xfs_force_bdev data $SCRATCH_MNT
+old_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
+
+mkdir $SCRATCH_MNT/save/
+sino=$(stat -c '%i' $SCRATCH_MNT/save)
+
+_consume_freesp()
+{
+	file=$1
+
+	# consume nearly all available space (leave ~1MB)
+	avail=`_get_available_space $SCRATCH_MNT`
+	filesizemb=$((avail / 1024 / 1024 - 1))
+	$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $file
+}
+
+# Allocate inodes in a directory until failure.
+_alloc_inodes()
+{
+	dir=$1
+
+	i=0
+	while [ true ]; do
+		touch $dir/$i 2>> $seqres.full || break
+		i=$((i + 1))
+	done
+}
+
+# Find a sparse inode cluster after logend_agno/logend_agino.
+find_sparse_clusters()
+{
+	for ((agno = agcount - 1; agno >= logend_agno; agno--)); do
+		_scratch_xfs_db -c "agi $agno" -c "addr root" -c "btdump" | \
+			tr ':[,]' '    ' | \
+			awk -v "agno=$agno" \
+			    -v "agino=$logend_agino" \
+'{if ($2 >= agino && and(strtonum($3), 0x8000)) {printf("%s %s %s\n", agno, $2, $3);}}' | \
+			tac
+	done
+}
+
+# Calculate the fs inode chunk size based on the inode size and fixed 64-inode
+# record. This value is used as the target level of free space fragmentation
+# induced by the test (i.e., max size of free extents). We don't need to go
+# smaller than a full chunk because the XFS block allocator tacks on alignment
+# requirements to the size of the requested allocation. In other words, a chunk
+# sized free chunk is not enough to guarantee a successful chunk sized
+# allocation.
+XFS_INODES_PER_CHUNK=64
+CHUNK_SIZE=$((isize * XFS_INODES_PER_CHUNK))
+
+_consume_freesp $SCRATCH_MNT/spc
+
+# Now that the fs is nearly full, punch holes in every other $CHUNK_SIZE range
+# of the space consumer file.  The goal here is to end up with a sparse cluster
+# at the end of the fs (and past any internal log), where the chunks at the end
+# of the cluster are sparse.
+
+offset=`_get_filesize $SCRATCH_MNT/spc`
+offset=$((offset - $CHUNK_SIZE * 2))
+nr=0
+while [ $offset -ge 0 ]; do
+	$XFS_IO_PROG -c "fpunch $offset $CHUNK_SIZE" $SCRATCH_MNT/spc \
+		2>> $seqres.full || _fail "fpunch failed"
+
+	# allocate as many inodes as possible
+	mkdir -p $SCRATCH_MNT/urk/offset.$offset > /dev/null 2>&1
+	_alloc_inodes $SCRATCH_MNT/urk/offset.$offset
+
+	offset=$((offset - $CHUNK_SIZE * 2))
+
+	# Every five times through the loop, see if we got a sparse cluster
+	nr=$((nr + 1))
+	if [ $((nr % 5)) -eq 4 ]; then
+		_scratch_unmount
+		find_sparse_clusters > $tmp.clusters
+		if [ -s $tmp.clusters ]; then
+			break;
+		fi
+		_scratch_mount
+	fi
+done
+
+test -s $tmp.clusters || _notrun "Could not create a sparse inode cluster"
+
+echo clusters >> $seqres.full
+cat $tmp.clusters >> $seqres.full
+
+# Figure out which inode numbers are in that last cluster.  We need to preserve
+# that cluster but delete everything else ahead of shrinking.
+icluster_agno=$(head -n 1 $tmp.clusters | cut -d ' ' -f 1)
+icluster_agino=$(head -n 1 $tmp.clusters | cut -d ' ' -f 2)
+icluster_ino=$(convert_units "convert agno $icluster_agno agino $icluster_agino ino")
+
+# Check that the save directory isn't going to prevent us from shrinking
+test $sino -lt $icluster_ino || \
+	echo "/save inode comes after target cluster, test may fail"
+
+# Save the inodes in the last cluster and delete everything else
+_scratch_mount
+rm -r $SCRATCH_MNT/spc
+for ((ino = icluster_ino; ino < icluster_ino + XFS_INODES_PER_CHUNK; ino++)); do
+	find $SCRATCH_MNT/urk/ -inum "$ino" -print0 | xargs -r -0 mv -t $SCRATCH_MNT/save/
+done
+rm -rf $SCRATCH_MNT/urk/ $SCRATCH_MNT/save/*/*
+sync
+$XFS_IO_PROG -c 'fsmap -vvvvv' $SCRATCH_MNT &>> $seqres.full
+
+# Propose shrinking the filesystem such that the end of the fs ends up in the
+# sparse part of our sparse cluster.  Remember, the last block of that cluster
+# ought to be free.
+target_ino=$((icluster_ino + XFS_INODES_PER_CHUNK - 1))
+for ((ino = target_ino; ino >= icluster_ino; ino--)); do
+	found=$(find $SCRATCH_MNT/save/ -inum "$ino" | wc -l)
+	test $found -gt 0 && break
+
+	ino_daddr=$(convert_units "convert ino $ino daddr")
+	new_size=$((ino_daddr / daddr_to_fsblocks))
+
+	echo "Hope to fail at shrinking to $new_size" >> $seqres.full
+	$XFS_GROWFS_PROG -D $new_size $SCRATCH_MNT &>> $seqres.full
+	res=$?
+
+	# Make sure shrink did not work
+	new_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
+	if [ "$new_dblocks" != "$old_dblocks" ]; then
+		echo "should not have shrank $old_dblocks -> $new_dblocks"
+		break
+	fi
+
+	if [ $res -eq 0 ]; then
+		echo "shrink to $new_size (ino $ino) should have failed"
+		break
+	fi
+done
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/778.out b/tests/xfs/778.out
new file mode 100644
index 00000000..e80f72a3
--- /dev/null
+++ b/tests/xfs/778.out
@@ -0,0 +1,2 @@
+QA output created by 778
+Silence is golden
