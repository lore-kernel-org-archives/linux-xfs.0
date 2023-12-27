Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBA17ED;
	Mon,  1 Jan 2024 00:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SApRtcAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9456C433C8;
	Mon,  1 Jan 2024 00:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070366;
	bh=tPy+L+JF0wSvbyGlgNcV0r3z6+erjEBI3a7qJgCBLhQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SApRtcApRCp5Wggwr+ZSRbOfxC01jTUYtloQg0HJIOwn4OZ4lVhKB+1ZQtDKhIZ7I
	 mPxX+5L2Mne/PKu1d2WhQkQZVQD0Xfko50Hy9/RBOmVcZ76QEFLfLXUmqsh0Ds4np9
	 UP2bWcU5cid0pkgYxMDrG159qQV0kJRasiZCeQtsszagHatKCtN/aTnVGiwZhJiQPi
	 ofGwYbkSZAMElJqdiPLAnMV5v2r/JvJYtBU6og9mLVTZn4JQL39BfjsJzlWSG3I6rD
	 HAswKJV9KtWR5mRDpT04LgfjuDAEBjTxkAB+NQeySwhWoKGv7G6qJn57f0CGLE5yc5
	 BEdrkD7+tAMRg==
Date: Sun, 31 Dec 2023 16:52:46 +9900
Subject: [PATCH 11/11] xfs: test metapath repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029995.1826032.5475480252505208153.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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

Functional testing for metadir path checking and repairs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1874     |  132 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1874.out |   16 ++++++
 2 files changed, 148 insertions(+)
 create mode 100755 tests/xfs/1874
 create mode 100644 tests/xfs/1874.out


diff --git a/tests/xfs/1874 b/tests/xfs/1874
new file mode 100755
index 0000000000..a00b58773f
--- /dev/null
+++ b/tests/xfs/1874
@@ -0,0 +1,132 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1874
+#
+# Functional test of using online repair to fix metadir paths.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+# Override the default cleanup function.
+# _cleanup()
+# {
+# 	cd /
+# 	rm -r -f $tmp.*
+# }
+
+# Import common functions.
+source ./common/filter
+source ./common/inject
+source ./common/fuzzy
+source ./common/quota
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
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
+	$XFS_INFO_PROG $SCRATCH_MNT | grep -q 'metadir=1' || \
+		_notrun "metadata directories must be enabled"
+
+	$XFS_INFO_PROG $SCRATCH_MNT | grep -q 'parent=1' || \
+		_notrun "parent pointers must be enabled"
+
+	root_inum="$(stat -c '%i' $SCRATCH_MNT)"
+	__stress_scrub_check_commands "%dir%" '' '' 'scrub metapath'
+	_scratch_unmount
+
+	# Stash the /realtime inode number and gen
+	rt_metadir_inum=$(_scratch_xfs_get_metadata_field v3.inumber 'path -m /realtime')
+	rt_metadir_gen=$(_scratch_xfs_get_metadata_field core.gen 'path -m /realtime')
+
+	# Stash the /realtime/bitmap inode number and gen
+	rbm_inum=$(_scratch_xfs_get_metadata_field v3.inumber 'path -m /realtime/bitmap')
+	rbm_gen=$(_scratch_xfs_get_metadata_field core.gen 'path -m /realtime/bitmap')
+
+	# Fuzz parent pointer in rtbitmap file
+	_scratch_xfs_db -x \
+		-c 'path -m /realtime/bitmap' \
+		-c "write -d a.sfattr.list[0].parent_ino $root_inum" >> $seqres.full.
+}
+
+simple_online_repair() {
+	echo "check /realtime dir" | _tee_kernlog
+	$XFS_IO_PROG -c "scrub directory $rt_metadir_inum $rt_metadir_gen" $SCRATCH_MNT
+
+	echo "check /realtime/bitmap pptr" | _tee_kernlog
+	$XFS_IO_PROG -c "scrub parent $rbm_inum $rbm_gen" $SCRATCH_MNT
+
+	echo "check /realtime/bitmap metapath" | _tee_kernlog
+	$XFS_IO_PROG -c "scrub metapath rtbitmap" $SCRATCH_MNT
+
+	echo "check nlinks" | _tee_kernlog
+	$XFS_IO_PROG -c "scrub nlinks" $SCRATCH_MNT
+
+	# Destroying a metadir path (e.g. /realtime/bitmap) cannot be done
+	# offline because then the mount will fail.  Hence we must use a
+	# specific sequence of online repairs to remove the metadir path link.
+	# Only then can we use the metapath scrubber to restore the link.
+
+	# Force repair the parent directory.  Since /realtime/bitmap has a bad
+	# parent pointer, the "bitmap" entry in /realtime will not be created.
+	echo "fix /realtime dir" | _tee_kernlog
+	$XFS_IO_PROG -x -c "repair -R directory $rt_metadir_inum $rt_metadir_gen" $SCRATCH_MNT
+
+	# Force repair the parent pointer.  Since the "bitmap" entry in
+	# /realtime no longer exists and no other directories count the
+	# rtbitmap as a parent, this will fail cross-referencing after the
+	# repair.
+	echo "fix /realtime/bitmap pptr" | _tee_kernlog
+	$XFS_IO_PROG -x -c "repair -R parent $rbm_inum $rbm_gen" $SCRATCH_MNT
+
+	# Now that we've completely erased the /realtime/bitmap path, check
+	# that the link is indeed lost, and restore the link.
+	echo "fix /realtime/bitmap metapath" | _tee_kernlog
+	$XFS_IO_PROG -x -c "repair metapath rtbitmap" $SCRATCH_MNT
+
+	# Make sure we're not missing any link count
+	echo "fix nlinks" | _tee_kernlog
+	$XFS_IO_PROG -x -c "repair nlinks" $SCRATCH_MNT
+}
+
+# Part 1: Use raw ioctls to detect the error and fix it.
+prepare_fs
+_scratch_mount
+simple_online_repair
+_check_scratch_fs
+_scratch_unmount
+
+# Part 2: Use xfs_scrub to detect the error and fix it.
+prepare_fs
+_scratch_mount
+echo "fix with xfs_scrub" | _tee_kernlog
+_scratch_scrub &>> $seqres.full
+echo "xfs_scrub returned $?" >> $seqres.full
+_check_scratch_fs
+_scratch_unmount
+
+# Part 3: Use xfs_repair to detect the error and fix it.
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
index 0000000000..1c29698283
--- /dev/null
+++ b/tests/xfs/1874.out
@@ -0,0 +1,16 @@
+QA output created by 1874
+check /realtime dir
+Corruption detected during cross-referencing.
+check /realtime/bitmap pptr
+Corruption detected during cross-referencing.
+check /realtime/bitmap metapath
+check nlinks
+fix /realtime dir
+fix /realtime/bitmap pptr
+Corruption remains.
+Corruption still detected during cross-referencing.
+fix /realtime/bitmap metapath
+fix nlinks
+fix with xfs_scrub
+fix with xfs_repair
+done with test

