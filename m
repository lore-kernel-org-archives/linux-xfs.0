Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF721F153D;
	Thu, 16 Jan 2025 23:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070489; cv=none; b=LLXZTn/L8ZU8w9WQHA1TERkThJLkoi1okcnQfWA0aRhJ5B7rRIwngOH0S/TLxiuQwj18dM40NAjmyY2jiipFcZ74LM7HXbN6G+3MZJLFxBDbE/V61ahWNevsD4AUSPr2rPPI1VGuaxTCYSkZCbK6H/gBYdMh3s9MEYutND4bvlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070489; c=relaxed/simple;
	bh=RlRxkb1fN1VvV9kTiHv/S/NWBIPfSDuW4PTCPAiPijE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjVHqUhhHnEE67CcRoNsnDXi2CkXf5j/MhCh1GxoAUucdwijQs9TTwxD2VgJ5ASHVfUb1hKp0otNGY4ccSSrFzD72zzf25YTBWLPWlUU7nelfz1ErVjVDwFMxeY7l01WzK23IIuJ3QYqDn86ZpOsRUYy9Nv8TcLz8V3ACoTWEf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyOLUncC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyOLUncC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F17C4CED6;
	Thu, 16 Jan 2025 23:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070489;
	bh=RlRxkb1fN1VvV9kTiHv/S/NWBIPfSDuW4PTCPAiPijE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SyOLUncCIGj/cJ+ivObNoU4XN22C9B0FrR1BFJ4pqMeZehK52O5yMd5XqTX44e6RF
	 pYNyAuJrgPA/KxAlUuOC86um+0mpoaoyqGghktMo1Vk64ggW1n6z2rTufuLME2ICYb
	 SxBG2rtSGOKbZ6lbZFo0kKrZSj61u75Tw5f6Qxcwm/qK7rU5dZYz+Li2wAh5IWYZMS
	 3FJW76BC2gHJ1fgXhHQTxzUXNtIm2mWbUf8hwRbrfOBiZ5izrIWJtLPuphs/zO5sBx
	 BPfUxpB9krBW6btDBQ9v+Fd+17rgXqxzN9tH2PFqVYRzfwq5x8U9gccmjzPBHZQW6T
	 2UxuMG6Pw/4iA==
Date: Thu, 16 Jan 2025 15:34:49 -0800
Subject: [PATCH 11/11] xfs: test metapath repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975335.1928284.10620285969077946573.stgit@frogsfrogsfrogs>
In-Reply-To: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
References: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Functional testing for metadir path checking and repairs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1874     |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1874.out |   19 ++++++++
 2 files changed, 138 insertions(+)
 create mode 100755 tests/xfs/1874
 create mode 100644 tests/xfs/1874.out


diff --git a/tests/xfs/1874 b/tests/xfs/1874
new file mode 100755
index 00000000000000..2e1af9222fa0bf
--- /dev/null
+++ b/tests/xfs/1874
@@ -0,0 +1,119 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1874
+#
+# Functional test of using online repair to fix metadir paths.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+. ./common/filter
+. ./common/inject
+. ./common/fuzzy
+. ./common/quota
+
+_require_xfs_db_command "link"
+_require_xfs_db_command "unlink"
+_require_scratch
+_require_xfs_stress_online_repair
+
+prepare_fs() {
+	# Format filesystem
+	_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
+	_scratch_mount
+
+	_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
+	_require_xfs_has_feature "$SCRATCH_MNT" realtime
+	_require_xfs_has_feature "$SCRATCH_MNT" metadir
+	_require_xfs_has_feature "$SCRATCH_MNT" parent
+
+	root_inum="$(stat -c '%i' $SCRATCH_MNT)"
+	__stress_scrub_check_commands "%dir%" '' '' 'scrub metapath'
+	_scratch_unmount
+
+	# Stash the /rtgroups inode number and gen
+	rt_metadir_inum=$(_scratch_xfs_get_metadata_field v3.inumber 'path -m /rtgroups')
+	rt_metadir_gen=$(_scratch_xfs_get_metadata_field core.gen 'path -m /rtgroups')
+
+	# Stash the /rtgroups/0.rmap inode number and gen
+	rbm_inum=$(_scratch_xfs_get_metadata_field v3.inumber 'path -m /rtgroups/0.rmap')
+	rbm_gen=$(_scratch_xfs_get_metadata_field core.gen 'path -m /rtgroups/0.rmap')
+
+	# Fuzz parent pointer in rtgroup 0 rmap file
+	_scratch_xfs_db -x \
+		-c 'path -m /rtgroups/0.rmap' \
+		-c "write -d a.sfattr.list[0].parent_dir.inumber $root_inum" >> $seqres.full
+}
+
+simple_online_repair() {
+	echo "check /rtgroups dir" | _tee_kernlog
+	$XFS_IO_PROG -c "scrub directory $rt_metadir_inum $rt_metadir_gen" $SCRATCH_MNT
+
+	echo "check /rtgroups/0.rmap pptr" | _tee_kernlog
+	$XFS_IO_PROG -c "scrub parent $rbm_inum $rbm_gen" $SCRATCH_MNT
+
+	echo "check /rtgroups/0.rmap metapath" | _tee_kernlog
+	$XFS_IO_PROG -c "scrub metapath rtrmapbt 0" $SCRATCH_MNT
+
+	echo "check nlinks" | _tee_kernlog
+	$XFS_IO_PROG -c "scrub nlinks" $SCRATCH_MNT
+
+	# Destroying a metadir path (e.g. /rtgroups/0.rmap) cannot be done
+	# offline because then the mount will fail.  Hence we must use a
+	# specific sequence of online repairs to remove the metadir path link.
+	# Only then can we use the metapath scrubber to restore the link.
+
+	# Force repair the parent directory.  Since /rtgroups/0.rmap has a bad
+	# parent pointer, the "0.rmap" entry in /rtgroups will not be created.
+	echo "fix /rtgroups dir" | _tee_kernlog
+	$XFS_IO_PROG -x -c "repair -R directory $rt_metadir_inum $rt_metadir_gen" $SCRATCH_MNT
+
+	# Force repair the parent pointer.  Since the "0.rmap" entry in
+	# /rtgroups no longer exists and no other directories count the
+	# rtgroup 0 rmap as a parent, this will fail cross-referencing after
+	# the repair.
+	echo "fix /rtgroups/0.rmap pptr" | _tee_kernlog
+	$XFS_IO_PROG -x -c "repair -R parent $rbm_inum $rbm_gen" $SCRATCH_MNT
+
+	# Now that we've completely erased the /rtgroups/0.rmap path, check
+	# that the link is indeed lost, and restore the link.
+	echo "fix /rtgroups/0.rmap metapath" | _tee_kernlog
+	$XFS_IO_PROG -x -c "repair metapath rtrmapbt 0" $SCRATCH_MNT
+
+	# Make sure we're not missing any link count
+	echo "fix nlinks" | _tee_kernlog
+	$XFS_IO_PROG -x -c "repair nlinks" $SCRATCH_MNT
+}
+
+echo Part 1: Use raw ioctls to detect the error and fix it.
+prepare_fs
+_scratch_mount
+simple_online_repair
+_check_scratch_fs
+_scratch_unmount
+
+echo Part 2: Use xfs_scrub to detect the error and fix it.
+prepare_fs
+_scratch_mount
+echo "fix with xfs_scrub" | _tee_kernlog
+_scratch_scrub &>> $seqres.full
+echo "xfs_scrub returned $?" >> $seqres.full
+_check_scratch_fs
+_scratch_unmount
+
+echo Part 3: Use xfs_repair to detect the error and fix it.
+prepare_fs
+echo "fix with xfs_repair" | _tee_kernlog
+echo repair?? >> $seqres.full
+_scratch_xfs_repair &>> $seqres.full
+echo "xfs_repair returned $?" >> $seqres.full
+_scratch_mount
+_check_scratch_fs
+_scratch_unmount
+
+echo "done with test" | _tee_kernlog
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1874.out b/tests/xfs/1874.out
new file mode 100644
index 00000000000000..ff4497363d8063
--- /dev/null
+++ b/tests/xfs/1874.out
@@ -0,0 +1,19 @@
+QA output created by 1874
+Part 1: Use raw ioctls to detect the error and fix it.
+check /rtgroups dir
+Corruption detected during cross-referencing.
+check /rtgroups/0.rmap pptr
+Corruption detected during cross-referencing.
+check /rtgroups/0.rmap metapath
+check nlinks
+fix /rtgroups dir
+fix /rtgroups/0.rmap pptr
+Corruption remains.
+Corruption still detected during cross-referencing.
+fix /rtgroups/0.rmap metapath
+fix nlinks
+Part 2: Use xfs_scrub to detect the error and fix it.
+fix with xfs_scrub
+Part 3: Use xfs_repair to detect the error and fix it.
+fix with xfs_repair
+done with test

