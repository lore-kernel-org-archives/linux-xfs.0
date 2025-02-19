Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A34286292;
	Wed, 19 Feb 2025 01:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927254; cv=none; b=LpZ9oDjIMt0aHxOOh9mb7jOOamK9veoAQrn5n78DHcLQuUas2HxCLIS6uMhNKpxDrWXF4Uzm1WFcsZXh0TiTwbUFK4KFrwApB4JM3ggTzLIhChk4kIqI6jBVhgAoNRCMz52rh177+01yX+NoOHsrUWzyh5rangLJ8UlMuMrordk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927254; c=relaxed/simple;
	bh=WgI89AN0pGswD+bl59uDtxJx91MXt58IiLhP3CiA6eg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PnKO+F7CRtzeklWFH5Wawyy3OfcdxJ6TDbvpq4DvsW+hVRZoEX9UVWFj3dllxRZSTjhkr7Ssnk56JTq1AI9TbmSR6TiHD/J6L3E3+fAwZlDx6IyHHsS+cCP6UyUHZna6Hlt2hnzlg9v6zpP67QgEApcfy5uaJaCy1gW8W1XUASA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPFNM5Cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPFNM5Cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C3CC4CEE2;
	Wed, 19 Feb 2025 01:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927254;
	bh=WgI89AN0pGswD+bl59uDtxJx91MXt58IiLhP3CiA6eg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gPFNM5CjrUUYxGh84aKmBcgkl0rHTeKI3/8wgEgTQIxEaNIDDoyaCeNorNIzuzfkB
	 kyGt8YR81BFW2MOqZdVlTaYeVJaDlZ2yFv0P9T2OshIxg5pNFIWacZZnQNA0lF0qZs
	 AaT9S9s6XeTtMYDkPbxAYArE4tEE7WdhHh8Gd98mwf6afRp7v9ZtQqHmateDVT7Brw
	 vrraMQZ1fffjehOlobNZt/xewh645rrNKYEOjxyOfksgXYyK9r0pxPm8NP5Y/Etgcn
	 hX9mYl3j2Fp4BiNwnqGbbiqk2X1W838fSLANUIsjjtf8/8gLlutGB7AyyNmtJ1W8V/
	 kp2A02VDjx+pw==
Date: Tue, 18 Feb 2025 17:07:33 -0800
Subject: [PATCH 2/7] xfs: create fuzz tests for the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591790.4081089.16064589606169363675.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs         |    4 ++++
 tests/xfs/1538     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1538.out |    4 ++++
 tests/xfs/1539     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1539.out |    4 ++++
 tests/xfs/1540     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1540.out |    4 ++++
 tests/xfs/1541     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1541.out |    4 ++++
 tests/xfs/1542     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1542.out |    4 ++++
 tests/xfs/1543     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1543.out |    4 ++++
 tests/xfs/1544     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1544.out |    4 ++++
 tests/xfs/1545     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1545.out |    4 ++++
 17 files changed, 339 insertions(+)
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
index 1be8cbf1c563d9..2c903d71c9170b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1842,6 +1842,10 @@ _scratch_xfs_find_rgbtree_height() {
 		path_format="/rtgroups/%u.rmap"
 		bt_prefix="u3.rtrmapbt"
 		;;
+	"refcnt")
+		path_format="/rtgroups/%u.refcount"
+		bt_prefix="u3.rtrefcbt"
+		;;
 	*)
 		_fail "Don't know about rt btree ${bt_type}"
 		;;
diff --git a/tests/xfs/1538 b/tests/xfs/1538
new file mode 100755
index 00000000000000..6b88ef4dcf3135
--- /dev/null
+++ b/tests/xfs/1538
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1538
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt record field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
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
index 00000000000000..968cfd6ef98ff1
--- /dev/null
+++ b/tests/xfs/1538.out
@@ -0,0 +1,4 @@
+QA output created by 1538
+Format and populate
+Fuzz rtrefcountbt recs
+Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1539 b/tests/xfs/1539
new file mode 100755
index 00000000000000..41a7707a111cf9
--- /dev/null
+++ b/tests/xfs/1539
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1539
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt record field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers repair fuzzers_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
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
index 00000000000000..aa3a963dc2a612
--- /dev/null
+++ b/tests/xfs/1539.out
@@ -0,0 +1,4 @@
+QA output created by 1539
+Format and populate
+Fuzz rtrefcountbt recs
+Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1540 b/tests/xfs/1540
new file mode 100755
index 00000000000000..ee94dcf0c6bae9
--- /dev/null
+++ b/tests/xfs/1540
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1540
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt record field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers fuzzers_norepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
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
index 00000000000000..37f3311837ad24
--- /dev/null
+++ b/tests/xfs/1540.out
@@ -0,0 +1,4 @@
+QA output created by 1540
+Format and populate
+Fuzz rtrefcountbt recs
+Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1541 b/tests/xfs/1541
new file mode 100755
index 00000000000000..16c6e82eca3e5b
--- /dev/null
+++ b/tests/xfs/1541
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1541
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt record field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
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
index 00000000000000..35a9b73471639e
--- /dev/null
+++ b/tests/xfs/1541.out
@@ -0,0 +1,4 @@
+QA output created by 1541
+Format and populate
+Fuzz rtrefcountbt recs
+Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1542 b/tests/xfs/1542
new file mode 100755
index 00000000000000..08cad4f7584292
--- /dev/null
+++ b/tests/xfs/1542
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1542
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt key/ptr field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
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
index 00000000000000..55d820b4b16778
--- /dev/null
+++ b/tests/xfs/1542.out
@@ -0,0 +1,4 @@
+QA output created by 1542
+Format and populate
+Fuzz rtrefcountbt keyptrs
+Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1543 b/tests/xfs/1543
new file mode 100755
index 00000000000000..47302787082a30
--- /dev/null
+++ b/tests/xfs/1543
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1543
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt key/ptr field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers repair fuzzers_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
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
index 00000000000000..e7afa10744c5db
--- /dev/null
+++ b/tests/xfs/1543.out
@@ -0,0 +1,4 @@
+QA output created by 1543
+Format and populate
+Fuzz rtrefcountbt keyptrs
+Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1544 b/tests/xfs/1544
new file mode 100755
index 00000000000000..b61166e1bdc3ea
--- /dev/null
+++ b/tests/xfs/1544
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1544
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt key/ptr field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers fuzzers_norepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
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
index 00000000000000..b39532c160dafe
--- /dev/null
+++ b/tests/xfs/1544.out
@@ -0,0 +1,4 @@
+QA output created by 1544
+Format and populate
+Fuzz rtrefcountbt keyptrs
+Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1545 b/tests/xfs/1545
new file mode 100755
index 00000000000000..6c1460d98ee4a2
--- /dev/null
+++ b/tests/xfs/1545
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1545
+#
+# Populate a XFS filesystem and fuzz every rtrefcountbt key/ptr field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
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
index 00000000000000..982a0d64df4353
--- /dev/null
+++ b/tests/xfs/1545.out
@@ -0,0 +1,4 @@
+QA output created by 1545
+Format and populate
+Fuzz rtrefcountbt keyptrs
+Done fuzzing rtrefcountbt keyptrs

