Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B167ED;
	Mon,  1 Jan 2024 01:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwK1p1G4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581A8C433C7;
	Mon,  1 Jan 2024 01:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070930;
	bh=LaZlLLEP2L/fWf6Rk4ZkhLdi5hc9Fr0Bj0OQjIb0WsM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RwK1p1G4gDJILqFxETivP/0lW1obfrpyxudKZ3kThDB8uzQAY1yCf7YMsHoXeAbrl
	 E3zsVd0XLPGe3ur0XNcEV6yPqDsWP7acnAKSY+t5rBshGb2wnJQAEx7JgEspOZNtFR
	 XCWcCOn1vqcmJmB4BBnVOBiZT/mPcc20OPEyQ31m4pFm4wYB5HEx1JMVVGzBCN3Ce6
	 Jx170o0vNkTtEUsetovSg95awdWPG0L9W1zyFKTn6VnA7Y58dmdSP5htsAzmA5t7BV
	 3owI63ANGYeKz6INBB8N/mJuyvRIR39zYgyV2p78xQAFTdicz/tSGMJZeTLha8nYgO
	 v9zfpP0/dxHsg==
Date: Sun, 31 Dec 2023 17:02:09 +9900
Subject: [PATCH 3/9] xfs: create fuzz tests for the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032055.1827358.9623496768181487478.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
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

Create fuzz tests for the realtime refcount btree record and key/ptr
blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs         |    4 ++++
 tests/xfs/1538     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1538.out |    4 ++++
 tests/xfs/1539     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1539.out |    4 ++++
 tests/xfs/1540     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1540.out |    4 ++++
 tests/xfs/1541     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1541.out |    4 ++++
 tests/xfs/1542     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1542.out |    4 ++++
 tests/xfs/1543     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1543.out |    4 ++++
 tests/xfs/1544     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1544.out |    4 ++++
 tests/xfs/1545     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1545.out |    4 ++++
 17 files changed, 363 insertions(+)
 create mode 100755 tests/xfs/1538
 create mode 100644 tests/xfs/1538.out
 create mode 100755 tests/xfs/1539
 create mode 100644 tests/xfs/1539.out
 create mode 100755 tests/xfs/1540
 create mode 100644 tests/xfs/1540.out
 create mode 100755 tests/xfs/1541
 create mode 100644 tests/xfs/1541.out
 create mode 100755 tests/xfs/1542
 create mode 100644 tests/xfs/1542.out
 create mode 100755 tests/xfs/1543
 create mode 100644 tests/xfs/1543.out
 create mode 100755 tests/xfs/1544
 create mode 100644 tests/xfs/1544.out
 create mode 100755 tests/xfs/1545
 create mode 100644 tests/xfs/1545.out


diff --git a/common/xfs b/common/xfs
index b8dd8d4a40..aab04bfb18 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1929,6 +1929,10 @@ _scratch_xfs_find_rgbtree_height() {
 		path_format="/realtime/%u.rmap"
 		bt_prefix="u3.rtrmapbt"
 		;;
+	"refcnt")
+		path_format="/realtime/%u.refcount"
+		bt_prefix="u3.rtrefcbt"
+		;;
 	*)
 		_fail "Don't know about rt btree ${bt_type}"
 		;;
diff --git a/tests/xfs/1538 b/tests/xfs/1538
new file mode 100755
index 0000000000..2bd630fdf1
--- /dev/null
+++ b/tests/xfs/1538
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1538
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt record field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level rtrefcountbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
+
+echo "Fuzz rtrefcountbt recs"
+_scratch_xfs_fuzz_metadata '' 'online' "path -m $path" "addr u${inode_ver}.rtrefcbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrefcountbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1538.out b/tests/xfs/1538.out
new file mode 100644
index 0000000000..968cfd6ef9
--- /dev/null
+++ b/tests/xfs/1538.out
@@ -0,0 +1,4 @@
+QA output created by 1538
+Format and populate
+Fuzz rtrefcountbt recs
+Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1539 b/tests/xfs/1539
new file mode 100755
index 0000000000..8086943211
--- /dev/null
+++ b/tests/xfs/1539
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1539
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt record field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level rtrefcountbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
+
+echo "Fuzz rtrefcountbt recs"
+_scratch_xfs_fuzz_metadata '' 'offline' "path -m $path" "addr u${inode_ver}.rtrefcbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrefcountbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1539.out b/tests/xfs/1539.out
new file mode 100644
index 0000000000..aa3a963dc2
--- /dev/null
+++ b/tests/xfs/1539.out
@@ -0,0 +1,4 @@
+QA output created by 1539
+Format and populate
+Fuzz rtrefcountbt recs
+Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1540 b/tests/xfs/1540
new file mode 100755
index 0000000000..ab8dee2a02
--- /dev/null
+++ b/tests/xfs/1540
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1540
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt record field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_norepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level rtrefcountbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
+
+echo "Fuzz rtrefcountbt recs"
+_scratch_xfs_fuzz_metadata '' 'none' "path -m $path" "addr u${inode_ver}.rtrefcbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrefcountbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1540.out b/tests/xfs/1540.out
new file mode 100644
index 0000000000..37f3311837
--- /dev/null
+++ b/tests/xfs/1540.out
@@ -0,0 +1,4 @@
+QA output created by 1540
+Format and populate
+Fuzz rtrefcountbt recs
+Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1541 b/tests/xfs/1541
new file mode 100755
index 0000000000..18312456f4
--- /dev/null
+++ b/tests/xfs/1541
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1541
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt record field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level rtrefcountbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
+
+echo "Fuzz rtrefcountbt recs"
+_scratch_xfs_fuzz_metadata '' 'both' "path -m $path" "addr u${inode_ver}.rtrefcbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrefcountbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1541.out b/tests/xfs/1541.out
new file mode 100644
index 0000000000..35a9b73471
--- /dev/null
+++ b/tests/xfs/1541.out
@@ -0,0 +1,4 @@
+QA output created by 1541
+Format and populate
+Fuzz rtrefcountbt recs
+Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1542 b/tests/xfs/1542
new file mode 100755
index 0000000000..9246a31a31
--- /dev/null
+++ b/tests/xfs/1542
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1542
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt key/ptr field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level rtrefcountbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
+
+echo "Fuzz rtrefcountbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrefcbt)' 'online' "path -m $path" >> $seqres.full
+echo "Done fuzzing rtrefcountbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1542.out b/tests/xfs/1542.out
new file mode 100644
index 0000000000..55d820b4b1
--- /dev/null
+++ b/tests/xfs/1542.out
@@ -0,0 +1,4 @@
+QA output created by 1542
+Format and populate
+Fuzz rtrefcountbt keyptrs
+Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1543 b/tests/xfs/1543
new file mode 100755
index 0000000000..38afae106a
--- /dev/null
+++ b/tests/xfs/1543
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1543
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt key/ptr field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level rtrefcountbt"
+
+echo "Fuzz rtrefcountbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrefcbt)' 'offline' "path -m $path" >> $seqres.full
+echo "Done fuzzing rtrefcountbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1543.out b/tests/xfs/1543.out
new file mode 100644
index 0000000000..e7afa10744
--- /dev/null
+++ b/tests/xfs/1543.out
@@ -0,0 +1,4 @@
+QA output created by 1543
+Format and populate
+Fuzz rtrefcountbt keyptrs
+Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1544 b/tests/xfs/1544
new file mode 100755
index 0000000000..86b11b1955
--- /dev/null
+++ b/tests/xfs/1544
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1544
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt key/ptr field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_norepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level rtrefcountbt"
+
+echo "Fuzz rtrefcountbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrefcbt)' 'none' "path -m $path" >> $seqres.full
+echo "Done fuzzing rtrefcountbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1544.out b/tests/xfs/1544.out
new file mode 100644
index 0000000000..b39532c160
--- /dev/null
+++ b/tests/xfs/1544.out
@@ -0,0 +1,4 @@
+QA output created by 1544
+Format and populate
+Fuzz rtrefcountbt keyptrs
+Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1545 b/tests/xfs/1545
new file mode 100755
index 0000000000..1dbe03506b
--- /dev/null
+++ b/tests/xfs/1545
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1545
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt key/ptr field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level rtrefcountbt"
+
+echo "Fuzz rtrefcountbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrefcbt)' 'both' "path -m $path" >> $seqres.full
+echo "Done fuzzing rtrefcountbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1545.out b/tests/xfs/1545.out
new file mode 100644
index 0000000000..982a0d64df
--- /dev/null
+++ b/tests/xfs/1545.out
@@ -0,0 +1,4 @@
+QA output created by 1545
+Format and populate
+Fuzz rtrefcountbt keyptrs
+Done fuzzing rtrefcountbt keyptrs

