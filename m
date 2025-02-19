Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D77B1EEE0;
	Wed, 19 Feb 2025 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926924; cv=none; b=m715mGHDZMY7g2WSlZOu76YZlgeNsDwC9mAbwMRZj00gRsTPg1fnw7rrBjZsVFNagXIt1ktE4LHZtOZLW91MblplBUUVP9lKhE7lSYC7FRrfH8vt2yk7E5ZwnHGqZrK5RAylZA5YyXoM3wuuyge9RPMngbTykxFLw+iXVwnnQpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926924; c=relaxed/simple;
	bh=pBGTiPERqBTZQGPZV4lr3zgi/bGwSg3uR8OeQo4YDKY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HIIXbO4st4yh14l/gMR5axIXdgQQ5h7WjemZEGbu6aPksm4J4sx/1BpwEjIWDgMdZKcAyiiBub/NjWLMCPhwcjEztCz0Foj/OfysfBy9DJWZv0Imcnym7ITm2pP/VemRZHzIhkP0Qdw993MPzSIgiQAhYbhb4yBETchINnkCaL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLjbTlVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLjbTlVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1F4C4CEE2;
	Wed, 19 Feb 2025 01:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926924;
	bh=pBGTiPERqBTZQGPZV4lr3zgi/bGwSg3uR8OeQo4YDKY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CLjbTlVvCw5AfefIYulSO8/qtTBFZVusAqlaCq7TL1JNxdjWjEMwCSr4uF/llg7BW
	 rgtnViJGi8QAiQSikCk/56dhhqcw3KeEcg9dyOjYN0kyHSmNQdMLYghA7rOZVzhdBH
	 JeTHw4uWUxJSiw3c/ChEwff4zS6t7aFjikrHFN28pmsOQPq7pX6ARTws/0oN8qh0mR
	 PQGHdksYK610JjZ9vCu4D+rN2pm3kS1KPt/XjhKK14cT2I61Ajd3568lIS6WMcldH4
	 gHq0uSn2UWWmJV3W3xUA42bHgvKOYSuC9jLh7RoErQyk063tJoIlk0rl0bycGwRU2c
	 ItFUjhunyB80w==
Date: Tue, 18 Feb 2025 17:02:03 -0800
Subject: [PATCH 2/4] xfs: test persistent quota flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589878.4080063.13008930042280912515.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
References: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Test the persistent quota flags that come with the metadir feature.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/563  |    8 ++-
 tests/xfs/1891     |  128 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1891.out |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 282 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1891
 create mode 100644 tests/xfs/1891.out


diff --git a/tests/generic/563 b/tests/generic/563
index 95a928fba5627e..89a71aa44938ea 100755
--- a/tests/generic/563
+++ b/tests/generic/563
@@ -96,7 +96,13 @@ smajor=$((0x`stat -L -c %t $loop_dev`))
 sminor=$((0x`stat -L -c %T $loop_dev`))
 
 _mkfs_dev $loop_dev >> $seqres.full 2>&1
-_mount $loop_dev $SCRATCH_MNT || _fail "mount failed"
+if [ $FSTYP = "xfs" ]; then
+	# Writes to the quota file are captured in cgroup metrics on XFS, so
+	# we require that quota is not enabled at all.
+	_mount $loop_dev -o noquota $SCRATCH_MNT || _fail "mount failed"
+else
+	_mount $loop_dev $SCRATCH_MNT || _fail "mount failed"
+fi
 
 blksize=$(_get_block_size "$SCRATCH_MNT")
 
diff --git a/tests/xfs/1891 b/tests/xfs/1891
new file mode 100755
index 00000000000000..7db94e0976527e
--- /dev/null
+++ b/tests/xfs/1891
@@ -0,0 +1,128 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1891
+#
+# Functionality test for persistent quota accounting and enforcement flags in
+# XFS when metadata directories are enabled.
+#
+. ./common/preamble
+_begin_fstest auto quick quota
+
+. ./common/filter
+. ./common/quota
+
+$MKFS_XFS_PROG 2>&1 | grep -q 'uquota' || \
+	_notrun "mkfs does not support uquota option"
+
+_require_scratch
+_require_xfs_quota
+
+filter_quota_state() {
+	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' \
+	    -e '/max warnings:/d' \
+	    -e '/Blocks grace time:/d' \
+	    -e '/Inodes grace time:/d' \
+		| _filter_scratch
+}
+
+qerase_mkfs_options() {
+	echo "$MKFS_OPTIONS" | sed \
+		-e 's/uquota//g' \
+		-e 's/gquota//g' \
+		-e 's/pquota//g' \
+		-e 's/uqnoenforce//g' \
+		-e 's/gqnoenforce//g' \
+		-e 's/pqnoenforce//g' \
+		-e 's/,,*/,/g'
+}
+
+confirm() {
+	echo "$MOUNT_OPTIONS" | grep -E -q '(qnoenforce|quota)' && \
+		echo "saw quota mount options"
+	_scratch_mount
+	$XFS_QUOTA_PROG -x -c "state -ugp" $SCRATCH_MNT | filter_quota_state
+	_check_xfs_scratch_fs
+	_scratch_unmount
+}
+
+ORIG_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+MKFS_OPTIONS="$(qerase_mkfs_options)"
+
+echo "Test 0: formatting a subset"
+_scratch_mkfs -m uquota,gqnoenforce &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+confirm
+
+echo "Test 1: formatting"
+_scratch_mkfs -m uquota,gquota,pquota &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+confirm
+
+echo "Test 2: only grpquota"
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option grpquota
+confirm
+
+echo "Test 3: repair"
+_scratch_xfs_repair &>> $seqres.full || echo "repair failed?"
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+confirm
+
+echo "Test 4: weird options"
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option pqnoenforce,uquota
+confirm
+
+echo "Test 5: simple recovery"
+_scratch_mkfs -m uquota,gquota,pquota &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+echo "$MOUNT_OPTIONS" | grep -E -q '(qnoenforce|quota)' && \
+	echo "saw quota mount options"
+_scratch_mount
+$XFS_QUOTA_PROG -x -c "state -ugp" $SCRATCH_MNT | filter_quota_state
+touch $SCRATCH_MNT/a
+_scratch_shutdown -v -f >> $seqres.full
+echo shutdown
+_scratch_unmount
+confirm
+
+echo "Test 6: simple recovery with mount options"
+_scratch_mkfs -m uquota,gquota,pquota &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+echo "$MOUNT_OPTIONS" | grep -E -q '(qnoenforce|quota)' && \
+	echo "saw quota mount options"
+_scratch_mount
+$XFS_QUOTA_PROG -x -c "state -ugp" $SCRATCH_MNT | filter_quota_state
+touch $SCRATCH_MNT/a
+_scratch_shutdown -v -f >> $seqres.full
+echo shutdown
+_scratch_unmount
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option gqnoenforce
+confirm
+
+echo "Test 7: user quotaoff recovery"
+_scratch_mkfs -m uquota,gquota,pquota &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+echo "$MOUNT_OPTIONS" | grep -E -q '(qnoenforce|quota)' && \
+	echo "saw quota mount options"
+_scratch_mount
+$XFS_QUOTA_PROG -x -c "state -ugp" $SCRATCH_MNT | filter_quota_state
+touch $SCRATCH_MNT/a
+$XFS_QUOTA_PROG -x -c 'off -u' $SCRATCH_MNT
+_scratch_shutdown -v -f >> $seqres.full
+echo shutdown
+_scratch_unmount
+confirm
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1891.out b/tests/xfs/1891.out
new file mode 100644
index 00000000000000..7e8894088042bb
--- /dev/null
+++ b/tests/xfs/1891.out
@@ -0,0 +1,147 @@
+QA output created by 1891
+Test 0: formatting a subset
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode: N/A
+Test 1: formatting
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Test 2: only grpquota
+saw quota mount options
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Test 3: repair
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Test 4: weird options
+saw quota mount options
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Test 5: simple recovery
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+shutdown
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Test 6: simple recovery with mount options
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+shutdown
+saw quota mount options
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Test 7: user quotaoff recovery
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+shutdown
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)

