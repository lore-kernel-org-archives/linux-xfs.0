Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE1C7ED;
	Mon,  1 Jan 2024 00:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGZLACV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048AFC433C8;
	Mon,  1 Jan 2024 00:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070179;
	bh=0rGAP2nUYoGfBWecZZpNrGvhtQtcbLvm2IEy5aLlduk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HGZLACV8maqGsxa+9Bvd0TYzWKL83OGe/KqfsQ956m/yIvESQffHrc5K0+OTKQ9Ok
	 WyzSlqSeFEty/NOpOX+U5Jm5TxQX7m08/v03+hnL8EOAJttdESW+2AdvWf9WjnCpq+
	 jEv/KR43d9puY5a/LEk0f7PcxIR+O6aLpJvJXprCjuw2NIaIvsHf1SSfu//hR25Ryp
	 fDuludGzFWMwOLO/WB9Pegxra7mQKbS/euuL8KGl9JJPJXBrEWSNHe7SIuI3uPmdHL
	 qx6g3IGcg6KPz/9clfpNh9CQqVxc1IrOMAgeFN2qUf1WJYV3RTjm3+J0XEdmHHzId6
	 AwWJkvv8exU0g==
Date: Sun, 31 Dec 2023 16:49:38 +9900
Subject: [PATCH 2/2] scrub: test correction of directory tree corruptions
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170405028920.1825187.17678779855858911812.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028893.1825187.7753896310306155652.stgit@frogsfrogsfrogs>
References: <170405028893.1825187.7753896310306155652.stgit@frogsfrogsfrogs>
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

Make sure that we can fix directory tree loops and multiply-owned dirs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1866     |  122 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1866.out |   19 ++++++
 tests/xfs/1867     |  133 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1867.out |   25 ++++++++
 tests/xfs/1868     |  121 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1868.out |   21 +++++++
 tests/xfs/1869     |  157 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1869.out |   32 +++++++++++
 tests/xfs/1870     |  146 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1870.out |   30 ++++++++++
 tests/xfs/1871     |   78 ++++++++++++++++++++++++++
 tests/xfs/1871.out |    2 +
 12 files changed, 886 insertions(+)
 create mode 100755 tests/xfs/1866
 create mode 100644 tests/xfs/1866.out
 create mode 100755 tests/xfs/1867
 create mode 100644 tests/xfs/1867.out
 create mode 100755 tests/xfs/1868
 create mode 100644 tests/xfs/1868.out
 create mode 100755 tests/xfs/1869
 create mode 100644 tests/xfs/1869.out
 create mode 100755 tests/xfs/1870
 create mode 100644 tests/xfs/1870.out
 create mode 100755 tests/xfs/1871
 create mode 100644 tests/xfs/1871.out


diff --git a/tests/xfs/1866 b/tests/xfs/1866
new file mode 100755
index 0000000000..280c33da3e
--- /dev/null
+++ b/tests/xfs/1866
@@ -0,0 +1,122 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1866
+#
+# Functional testing for online fsck of a directory loop that is not accessible
+# from the root directory.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+# Import common functions.
+. ./common/filter
+. ./common/inject
+. ./common/fuzzy
+. ./common/populate
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
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+	__stress_scrub_check_commands "%dir%" '' '' 'scrub dirtree'
+
+	# Begin by creating the following directory tree:
+	# root["A"]->A
+	# A["B"]->B
+	# B["C"]->C
+	mkdir -p "$SCRATCH_MNT/A/B/C"
+
+	root_inum="$(stat -c '%i' "$SCRATCH_MNT/")"
+	a_inum="$(stat -c '%i' "$SCRATCH_MNT/A")"
+	b_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B")"
+	c_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C")"
+
+	echo "root: $root_inum; a: $a_inum; b: $b_inum; c: $c_inum" >> $seqres.full
+
+	# Next, we complete the loop by creating C["A"]->A and deleting root["A"]->A.
+	# Directory tree is now:
+	# A["B"]->B
+	# B["C"]->C
+	# C["A"]->A
+	_scratch_unmount
+
+	root_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $root_inum")
+	a_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $a_inum")
+	b_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $b_inum")
+	c_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $c_inum")
+
+	_scratch_xfs_db \
+		-c "echo before root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before C $c_inum" -c "inode $c_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before A $a_inum" -c "inode $a_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+
+	_scratch_xfs_db -x \
+		-c "inode $c_inum" -c "link -i $a_inum A" \
+		-c "inode $root_inum" -c "unlink A" \
+		>> $seqres.full
+
+	_scratch_xfs_db \
+		-c "echo after root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo after C $c_inum" -c "inode $c_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo after A $a_inum" -c "inode $a_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+}
+
+simple_online_repair() {
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+
+	echo "repair root"
+	$XFS_IO_PROG -x -c "repair dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "repair A"
+	$XFS_IO_PROG -x -c "repair dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "repair B"
+	$XFS_IO_PROG -x -c "repair dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "repair C"
+	$XFS_IO_PROG -x -c "repair dirtree $c_inum $c_gen" $SCRATCH_MNT
+
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+}
+
+# Part 1: Use raw ioctls to detect the loop and fix it.
+prepare_fs
+_scratch_mount
+simple_online_repair
+_check_scratch_fs
+_scratch_unmount
+
+# Part 2: Use xfs_scrub to detect the loop and fix it.
+prepare_fs
+_scratch_mount
+_scratch_scrub &>> $seqres.full
+echo "xfs_scrub returned $?" >> $seqres.full
+_check_scratch_fs
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1866.out b/tests/xfs/1866.out
new file mode 100644
index 0000000000..b6b08aea7f
--- /dev/null
+++ b/tests/xfs/1866.out
@@ -0,0 +1,19 @@
+QA output created by 1866
+check root
+check A
+Corruption detected.
+check B
+Corruption detected.
+check C
+Corruption detected.
+repair root
+Metadata did not need repair or optimization.
+repair A
+repair B
+Metadata did not need repair or optimization.
+repair C
+Metadata did not need repair or optimization.
+check root
+check A
+check B
+check C
diff --git a/tests/xfs/1867 b/tests/xfs/1867
new file mode 100755
index 0000000000..2c34b56503
--- /dev/null
+++ b/tests/xfs/1867
@@ -0,0 +1,133 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1867
+#
+# Functional testing for online fsck of a directory loop that is accessible
+# from the root directory.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+# Import common functions.
+. ./common/filter
+. ./common/inject
+. ./common/fuzzy
+. ./common/populate
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
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+	__stress_scrub_check_commands "%dir%" '' '' 'scrub dirtree'
+
+	# Begin by creating the following directory tree:
+	# root["A"]->A
+	# A["B"]->B
+	# B["C"]->C
+	# C["D"]->D
+	mkdir -p "$SCRATCH_MNT/A/B/C/D"
+
+	root_inum="$(stat -c '%i' "$SCRATCH_MNT/")"
+	a_inum="$(stat -c '%i' "$SCRATCH_MNT/A")"
+	b_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B")"
+	c_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C")"
+	d_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C/D")"
+
+	echo "root: $root_inum; a: $a_inum; b: $b_inum; c: $c_inum; d: $d_inum" >> $seqres.full
+
+	# Next, we complete the loop by creating D["B1"]->B.  Directory tree is now:
+	# root["A"]->A
+	# A["B"]->B
+	# B["C"]->C
+	# C["D"]->D
+	# D["B1"]->B
+	_scratch_unmount
+
+	root_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $root_inum")
+	a_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $a_inum")
+	b_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $b_inum")
+	c_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $c_inum")
+	d_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $d_inum")
+
+	_scratch_xfs_db \
+		-c "echo before root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before D $d_inum" -c "inode $d_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before B $b_inum" -c "inode $b_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+
+	_scratch_xfs_db -x \
+		-c "inode $d_inum" -c "link -i $b_inum B1" \
+		>> $seqres.full
+
+	_scratch_xfs_db \
+		-c "echo after root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo after D $c_inum" -c "inode $d_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo after B $a_inum" -c "inode $b_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+}
+
+simple_online_repair() {
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "check D"
+	$XFS_IO_PROG -c "scrub dirtree $d_inum $d_gen" $SCRATCH_MNT
+
+	echo "repair root"
+	$XFS_IO_PROG -x -c "repair dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "repair A"
+	$XFS_IO_PROG -x -c "repair dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "repair D"
+	$XFS_IO_PROG -x -c "repair dirtree $d_inum $d_gen" $SCRATCH_MNT
+	echo "repair B"
+	$XFS_IO_PROG -x -c "repair dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "repair C"
+	$XFS_IO_PROG -x -c "repair dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "repair D"
+	$XFS_IO_PROG -x -c "repair dirtree $d_inum $d_gen" $SCRATCH_MNT
+
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "check D"
+	$XFS_IO_PROG -c "scrub dirtree $d_inum $d_gen" $SCRATCH_MNT
+}
+
+# Part 1: Use raw ioctls to detect the loop and fix it.
+prepare_fs
+_scratch_mount
+simple_online_repair
+_check_scratch_fs
+_scratch_unmount
+
+# Part 2: Use xfs_scrub to detect the loop and fix it.
+prepare_fs
+_scratch_mount
+_scratch_scrub &>> $seqres.full
+echo "xfs_scrub returned $?" >> $seqres.full
+_check_scratch_fs
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1867.out b/tests/xfs/1867.out
new file mode 100644
index 0000000000..88fbb85e50
--- /dev/null
+++ b/tests/xfs/1867.out
@@ -0,0 +1,25 @@
+QA output created by 1867
+check root
+check A
+check B
+Corruption detected.
+check C
+Corruption detected during cross-referencing.
+check D
+Corruption detected during cross-referencing.
+repair root
+Metadata did not need repair or optimization.
+repair A
+Metadata did not need repair or optimization.
+repair D
+Corruption still detected during cross-referencing.
+repair B
+repair C
+Metadata did not need repair or optimization.
+repair D
+Metadata did not need repair or optimization.
+check root
+check A
+check B
+check C
+check D
diff --git a/tests/xfs/1868 b/tests/xfs/1868
new file mode 100755
index 0000000000..7436343c0c
--- /dev/null
+++ b/tests/xfs/1868
@@ -0,0 +1,121 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1868
+#
+# Functional testing for online fsck of a directory chain that is not
+# accessible from the root directory.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+# Import common functions.
+. ./common/filter
+. ./common/inject
+. ./common/fuzzy
+. ./common/populate
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
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+	__stress_scrub_check_commands "%dir%" '' '' 'scrub dirtree'
+
+	# Begin by creating the following directory tree:
+	# root["A"]->A
+	# A["B"]->B
+	# B["C"]->C
+	mkdir -p "$SCRATCH_MNT/A/B/C"
+
+	root_inum="$(stat -c '%i' "$SCRATCH_MNT/")"
+	a_inum="$(stat -c '%i' "$SCRATCH_MNT/A")"
+	b_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B")"
+	c_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C")"
+
+	echo "root: $root_inum; a: $a_inum; b: $b_inum; c: $c_inum" >> $seqres.full
+
+	# Next, we sever the tree by deleting root["A"]->A.  Directory tree is now:
+	# A["B"]->B
+	# B["C"]->C
+	_scratch_unmount
+
+	root_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $root_inum")
+	a_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $a_inum")
+	b_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $b_inum")
+	c_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $c_inum")
+
+	_scratch_xfs_db \
+		-c "echo before root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before C $c_inum" -c "inode $c_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before A $a_inum" -c "inode $a_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+
+	_scratch_xfs_db -x \
+		-c "inode $root_inum" -c "unlink A" \
+		>> $seqres.full
+
+	_scratch_xfs_db \
+		-c "echo after root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo after C $c_inum" -c "inode $c_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo after A $a_inum" -c "inode $a_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+}
+
+simple_online_repair() {
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+
+	echo "repair C"
+	$XFS_IO_PROG -x -c "repair dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "repair root"
+	$XFS_IO_PROG -x -c "repair dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "repair A"
+	$XFS_IO_PROG -x -c "repair dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "repair B"
+	$XFS_IO_PROG -x -c "repair dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "repair C"
+	$XFS_IO_PROG -x -c "repair dirtree $c_inum $c_gen" $SCRATCH_MNT
+
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+}
+
+# Part 1: Use raw ioctls to detect the chain and fix it.
+prepare_fs
+_scratch_mount
+simple_online_repair
+_check_scratch_fs
+_scratch_unmount
+
+# Part 2: Use xfs_scrub to detect the chain and fix it.
+prepare_fs
+_scratch_mount
+_scratch_scrub &>> $seqres.full
+echo "xfs_scrub returned $?" >> $seqres.full
+_check_scratch_fs
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1868.out b/tests/xfs/1868.out
new file mode 100644
index 0000000000..f4f444ed52
--- /dev/null
+++ b/tests/xfs/1868.out
@@ -0,0 +1,21 @@
+QA output created by 1868
+check root
+check A
+Corruption detected.
+check B
+Corruption detected during cross-referencing.
+check C
+Corruption detected during cross-referencing.
+repair C
+Corruption still detected during cross-referencing.
+repair root
+Metadata did not need repair or optimization.
+repair A
+repair B
+Metadata did not need repair or optimization.
+repair C
+Metadata did not need repair or optimization.
+check root
+check A
+check B
+check C
diff --git a/tests/xfs/1869 b/tests/xfs/1869
new file mode 100755
index 0000000000..188bc0adc8
--- /dev/null
+++ b/tests/xfs/1869
@@ -0,0 +1,157 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1869
+#
+# Functional testing for online fsck of a multiply-owned directory that is
+# accessible from the root directory.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+# Import common functions.
+. ./common/filter
+. ./common/inject
+. ./common/fuzzy
+. ./common/populate
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
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+	__stress_scrub_check_commands "%dir%" '' '' 'scrub dirtree'
+
+	# Begin by creating the following directory tree:
+	# root["A"]->A
+	# A["B"]->B
+	# B["C"]->C
+	# C["D"]->D
+	# root["Z"]->Z
+	# Z["Y"]->Y
+	mkdir -p "$SCRATCH_MNT/A/B/C/D" "$SCRATCH_MNT/Z/Y"
+
+	root_inum="$(stat -c '%i' "$SCRATCH_MNT/")"
+	a_inum="$(stat -c '%i' "$SCRATCH_MNT/A")"
+	b_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B")"
+	c_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C")"
+	d_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C/D")"
+	z_inum="$(stat -c '%i' "$SCRATCH_MNT/Z")"
+	y_inum="$(stat -c '%i' "$SCRATCH_MNT/Z/Y")"
+
+	echo "root: $root_inum; a: $a_inum; b: $b_inum; c: $c_inum; d: $d_inum" >> $seqres.full
+	echo "root: $root_inum; z: $z_inum; y: $y_inum" >> $seqres.full
+
+	# Next, we create the multiply-owned directory by creating Y["C1"]->C.
+	# Directory tree is now:
+	# root["A"]->A
+	# A["B"]->B
+	# B["C"]->C
+	# C["D"]->D
+	# root["Z"]->Z
+	# Z["Y"]->Y
+	# Y["C1"]->C
+	_scratch_unmount
+
+	root_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $root_inum")
+	a_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $a_inum")
+	b_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $b_inum")
+	c_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $c_inum")
+	d_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $d_inum")
+	z_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $z_inum")
+	y_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $y_inum")
+
+	_scratch_xfs_db \
+		-c "echo before root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before Y $y_inum" -c "inode $y_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before B $b_inum" -c "inode $b_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before C $c_inum" -c "inode $c_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+
+	_scratch_xfs_db -x \
+		-c "inode $y_inum" -c "link -i $c_inum C1" \
+		>> $seqres.full
+
+	_scratch_xfs_db \
+		-c "echo before root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before Y $y_inum" -c "inode $y_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before B $b_inum" -c "inode $b_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before C $c_inum" -c "inode $c_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+}
+
+simple_online_repair() {
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "check D"
+	$XFS_IO_PROG -c "scrub dirtree $d_inum $d_gen" $SCRATCH_MNT
+	echo "check Z"
+	$XFS_IO_PROG -c "scrub dirtree $z_inum $z_gen" $SCRATCH_MNT
+	echo "check Y"
+	$XFS_IO_PROG -c "scrub dirtree $y_inum $y_gen" $SCRATCH_MNT
+
+	echo "repair D"
+	$XFS_IO_PROG -x -c "repair dirtree $d_inum $d_gen" $SCRATCH_MNT
+	echo "repair root"
+	$XFS_IO_PROG -x -c "repair dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "repair A"
+	$XFS_IO_PROG -x -c "repair dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "repair B"
+	$XFS_IO_PROG -x -c "repair dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "repair C"
+	$XFS_IO_PROG -x -c "repair dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "repair D"
+	$XFS_IO_PROG -x -c "repair dirtree $d_inum $d_gen" $SCRATCH_MNT
+	echo "repair Z"
+	$XFS_IO_PROG -x -c "repair dirtree $z_inum $z_gen" $SCRATCH_MNT
+	echo "repair Y"
+	$XFS_IO_PROG -x -c "repair dirtree $y_inum $y_gen" $SCRATCH_MNT
+
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "check D"
+	$XFS_IO_PROG -c "scrub dirtree $d_inum $d_gen" $SCRATCH_MNT
+	echo "check Z"
+	$XFS_IO_PROG -c "scrub dirtree $z_inum $z_gen" $SCRATCH_MNT
+	echo "check Y"
+	$XFS_IO_PROG -c "scrub dirtree $y_inum $y_gen" $SCRATCH_MNT
+}
+
+# Part 1: Use raw ioctls to detect the multi-parent dir and fix it.
+prepare_fs
+_scratch_mount
+simple_online_repair
+_check_scratch_fs
+_scratch_unmount
+
+# Part 2: Use xfs_scrub to detect the multi-parent dir and fix it.
+prepare_fs
+_scratch_mount
+_scratch_scrub &>> $seqres.full
+echo "xfs_scrub returned $?" >> $seqres.full
+_check_scratch_fs
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1869.out b/tests/xfs/1869.out
new file mode 100644
index 0000000000..a7ea4c2223
--- /dev/null
+++ b/tests/xfs/1869.out
@@ -0,0 +1,32 @@
+QA output created by 1869
+check root
+check A
+check B
+check C
+Corruption detected.
+check D
+Corruption detected during cross-referencing.
+check Z
+check Y
+repair D
+Corruption still detected during cross-referencing.
+repair root
+Metadata did not need repair or optimization.
+repair A
+Metadata did not need repair or optimization.
+repair B
+Metadata did not need repair or optimization.
+repair C
+repair D
+Metadata did not need repair or optimization.
+repair Z
+Metadata did not need repair or optimization.
+repair Y
+Metadata did not need repair or optimization.
+check root
+check A
+check B
+check C
+check D
+check Z
+check Y
diff --git a/tests/xfs/1870 b/tests/xfs/1870
new file mode 100755
index 0000000000..c4a32de061
--- /dev/null
+++ b/tests/xfs/1870
@@ -0,0 +1,146 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1870
+#
+# Functional testing for online fsck of a directory loop that is inaccessible
+# from the root directory and has subdirectories.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+# Import common functions.
+. ./common/filter
+. ./common/inject
+. ./common/fuzzy
+. ./common/populate
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
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+	__stress_scrub_check_commands "%dir%" '' '' 'scrub dirtree'
+
+	# Begin by creating the following directory tree:
+	# root["A"]->A
+	# A["B"]->B
+	# B["C"]->C
+	# C["D"]->D
+	# D["E"]->E
+	mkdir -p "$SCRATCH_MNT/A/B/C/D/E"
+
+	root_inum="$(stat -c '%i' "$SCRATCH_MNT/")"
+	a_inum="$(stat -c '%i' "$SCRATCH_MNT/A")"
+	b_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B")"
+	c_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C")"
+	d_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C/D")"
+	e_inum="$(stat -c '%i' "$SCRATCH_MNT/A/B/C/D/E")"
+
+	echo "root: $root_inum; a: $a_inum; b: $b_inum; c: $c_inum; d: $d_inum; e: $e_inum" >> $seqres.full
+
+	# Complete the loop by creating D["B1"]->B and severing A["B"]->B.  Directory
+	# tree is now:
+	# root["A"]->A
+	# B["C"]->C
+	# C["D"]->D
+	# D["E"]->E
+	# D["B1"]->B
+	_scratch_unmount
+
+	root_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $root_inum")
+	a_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $a_inum")
+	b_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $b_inum")
+	c_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $c_inum")
+	d_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $d_inum")
+	e_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $e_inum")
+
+	_scratch_xfs_db \
+		-c "echo before root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before A $d_inum" -c "inode $a_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before D $d_inum" -c "inode $d_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before B $b_inum" -c "inode $b_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+
+	_scratch_xfs_db -x \
+		-c "inode $d_inum" -c "link -i $b_inum B1" \
+		-c "inode $a_inum" -c "unlink B" \
+		>> $seqres.full
+
+	_scratch_xfs_db \
+		-c "echo before root $root_inum" -c "inode $root_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before A $d_inum" -c "inode $a_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before D $d_inum" -c "inode $d_inum" -c 'print core.nlinkv2' -c "ls" \
+		-c "echo before B $b_inum" -c "inode $b_inum" -c 'print core.nlinkv2' -c "parent" \
+		>> $seqres.full
+}
+
+simple_online_repair() {
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "check D"
+	$XFS_IO_PROG -c "scrub dirtree $d_inum $d_gen" $SCRATCH_MNT
+	echo "check E"
+	$XFS_IO_PROG -c "scrub dirtree $e_inum $e_gen" $SCRATCH_MNT
+
+	echo "repair root"
+	$XFS_IO_PROG -x -c "repair dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "repair A"
+	$XFS_IO_PROG -x -c "repair dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "repair E"
+	$XFS_IO_PROG -x -c "repair dirtree $e_inum $e_gen" $SCRATCH_MNT
+	echo "repair B"
+	$XFS_IO_PROG -x -c "repair dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "repair C"
+	$XFS_IO_PROG -x -c "repair dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "repair D"
+	$XFS_IO_PROG -x -c "repair dirtree $d_inum $d_gen" $SCRATCH_MNT
+	echo "repair E"
+	$XFS_IO_PROG -x -c "repair dirtree $e_inum $e_gen" $SCRATCH_MNT
+
+	echo "check root"
+	$XFS_IO_PROG -c "scrub dirtree $root_inum $root_gen" $SCRATCH_MNT
+	echo "check A"
+	$XFS_IO_PROG -c "scrub dirtree $a_inum $a_gen" $SCRATCH_MNT
+	echo "check B"
+	$XFS_IO_PROG -c "scrub dirtree $b_inum $b_gen" $SCRATCH_MNT
+	echo "check C"
+	$XFS_IO_PROG -c "scrub dirtree $c_inum $c_gen" $SCRATCH_MNT
+	echo "check D"
+	$XFS_IO_PROG -c "scrub dirtree $d_inum $d_gen" $SCRATCH_MNT
+	echo "check E"
+	$XFS_IO_PROG -c "scrub dirtree $e_inum $e_gen" $SCRATCH_MNT
+}
+
+# Part 1: Use raw ioctls to detect the loop and fix it.
+prepare_fs
+_scratch_mount
+simple_online_repair
+_check_scratch_fs
+_scratch_unmount
+
+# Part 2: Use xfs_scrub to detect the loop and fix it.
+prepare_fs
+_scratch_mount
+_scratch_scrub &>> $seqres.full
+echo "xfs_scrub returned $?" >> $seqres.full
+_check_scratch_fs
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1870.out b/tests/xfs/1870.out
new file mode 100644
index 0000000000..8274c6602c
--- /dev/null
+++ b/tests/xfs/1870.out
@@ -0,0 +1,30 @@
+QA output created by 1870
+check root
+check A
+check B
+Corruption detected.
+check C
+Corruption detected.
+check D
+Corruption detected.
+check E
+Corruption detected during cross-referencing.
+repair root
+Metadata did not need repair or optimization.
+repair A
+Metadata did not need repair or optimization.
+repair E
+Corruption still detected during cross-referencing.
+repair B
+repair C
+Metadata did not need repair or optimization.
+repair D
+Metadata did not need repair or optimization.
+repair E
+Metadata did not need repair or optimization.
+check root
+check A
+check B
+check C
+check D
+check E
diff --git a/tests/xfs/1871 b/tests/xfs/1871
new file mode 100755
index 0000000000..760259d18b
--- /dev/null
+++ b/tests/xfs/1871
@@ -0,0 +1,78 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1871
+#
+# Race rename and directory tree structure corruption detector for a while to
+# exercise the dirtree code's directory path invalidation and its ability to
+# handle unlinked directories.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+__stress_scrub_check_commands "%dir%" '' '' 'scrub dirtree'
+
+parentA="$SCRATCH_MNT/a"
+parentB="$SCRATCH_MNT/b"
+child="$parentA/c/d/e/f/g/h/i/j/k/l/m/n/o/p"
+unlinked="$SCRATCH_MNT/unlinked"
+
+mkdir -p "$parentA" "$parentB" "$child" "$unlinked"
+
+# Find handle info for the child so that we can scrub by handle
+child_inum="$(stat -c '%i' "$child")"
+_scratch_unmount
+child_gen=$(_scratch_xfs_get_metadata_field core.gen "inode $child_inum")
+_scratch_mount
+
+# Queue up a bunch of scrub requests per invocation
+ioargs=()
+for ((i = 0; i < 100; i++)); do
+	ioargs+=('-c' "scrub dirtree $child_inum $child_gen")
+done
+
+renamer() {
+	# Make sure the scrubber handles unlinked directories correctly
+	# by squatting on an empty directory
+	cd "$unlinked"
+	rm -r -f "$unlinked"
+
+	# Bounce the second level directory between parents to stress the
+	# invalidation detector
+	while [ -e $RUNNING_FILE ]; do
+		mv "$parentA/c" "$parentB/"
+		mv "$parentB/c" "$parentA/"
+	done
+}
+
+RUNNING_FILE="$SCRATCH_MNT/run"
+touch $RUNNING_FILE
+renamer &
+
+# Exercise the directory tree scrubber in two ways -- scrubbing the lowest
+# subdir by handle, and running xfs_scrub on the entire fs.
+while _soak_loop_running $((10 * TIME_FACTOR)); do
+	$XFS_IO_PROG "${ioargs[@]}" "$SCRATCH_MNT"
+	XFS_SCRUB_PHASE=5 _scratch_scrub -n >> $seqres.full
+done
+rm -f $RUNNING_FILE
+wait
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1871.out b/tests/xfs/1871.out
new file mode 100644
index 0000000000..24331e63d5
--- /dev/null
+++ b/tests/xfs/1871.out
@@ -0,0 +1,2 @@
+QA output created by 1871
+Silence is golden

