Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468652107;
	Fri, 11 Oct 2024 01:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611156; cv=none; b=WZKeIvEq3gLELBljOtkBP5qpMaORnvGIu9USW5lT2S75K0HiBH3gOatNEF/Sgk15K7KsHVM67F/Q5hcrIR6vgq4hqNxLysMZJBd31N2oV/oEeKcyLKfC+IuMap+XK33QhmVMqKUJlMrDhd6oZ0NhzromfAHgulHIiwZ/yUIyOhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611156; c=relaxed/simple;
	bh=NgT3xqZ4ZSnZWqhIQBDho7i2NrAYNRKpWdnIwlBGQyQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sxCfqML4d4ucONB5tcc9cIVD5fGlfCVttF3SglB2BHb4he1gwR4mmUMq6gapcPm58CtBaQZ4vSqbzmLmJHHVk9pw1Uzvvu34VBTH3u0XQnzlS62n46IfrkANVJwLK2zTAMulNnVnCKlj5nP5QlAHgVpJLLaD8mVMtjX/IVtzfFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubxx4DxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubxx4DxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F443C4CEC5;
	Fri, 11 Oct 2024 01:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611156;
	bh=NgT3xqZ4ZSnZWqhIQBDho7i2NrAYNRKpWdnIwlBGQyQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ubxx4DxVDbQaZ5mVuGIJmswDkwdlcZeiZ76AMhMfu7Wvg2WwWslhTR6IZxyBYqssL
	 dxehgjZRg2vUZ0gvnpJnUvJP1jbQPg5T/nXQOB64/QPPsyY9+aMEBRR9ZNyfse4MFA
	 QoK9Sas4aofW39g8o4I+5RmKiY/zyYXxMqtr7q/pE/ab6d6pi0n4naIisK+JlCQzYE
	 gvw4pVHpQFu2+ISLGHJRDPrqB7/Aaylxu+XoEL1dXREbLTByAb0oLIZxnJek6aJAeM
	 uvq6dDuEqhhVkvDrFvGf5PSXaLUg0eKHpYE5J73/o2By9lvehja9tk9oeSWZPz+ZRz
	 SNrjZZZ9IeCaA==
Date: Thu, 10 Oct 2024 18:45:55 -0700
Subject: [PATCH 3/4] xfs: test persistent quota flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860659140.4189705.17399104557432681489.stgit@frogsfrogsfrogs>
In-Reply-To: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
References: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/563  |    8 ++-
 tests/xfs/1891     |  128 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1891.out |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 282 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1891
 create mode 100644 tests/xfs/1891.out


diff --git a/tests/generic/563 b/tests/generic/563
index 0a8129a60ea28f..3f3c335f84b371 100755
--- a/tests/generic/563
+++ b/tests/generic/563
@@ -92,7 +92,13 @@ smajor=$((0x`stat -L -c %t $LOOP_DEV`))
 sminor=$((0x`stat -L -c %T $LOOP_DEV`))
 
 _mkfs_dev $LOOP_DEV >> $seqres.full 2>&1
-_mount $LOOP_DEV $SCRATCH_MNT || _fail "mount failed"
+if [ $FSTYP = "xfs" ]; then
+	# Writes to the quota file are captured in cgroup metrics on XFS, so
+	# we require that quota is not enabled at all.
+	_mount $LOOP_DEV -o noquota $SCRATCH_MNT || _fail "mount failed"
+else
+	_mount $LOOP_DEV $SCRATCH_MNT || _fail "mount failed"
+fi
 
 drop_io_cgroup=
 grep -q -w io $cgdir/cgroup.subtree_control || drop_io_cgroup=1
diff --git a/tests/xfs/1891 b/tests/xfs/1891
new file mode 100755
index 00000000000000..53009571a95a03
--- /dev/null
+++ b/tests/xfs/1891
@@ -0,0 +1,128 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
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

