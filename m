Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEBCC54EBD
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiLaDQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236355AbiLaDQs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:16:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9481612617;
        Fri, 30 Dec 2022 19:16:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 347B9B81E60;
        Sat, 31 Dec 2022 03:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34B6C433EF;
        Sat, 31 Dec 2022 03:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456604;
        bh=Qq5yXHu74FcPGcCp/6SBS2HS360L6SybVt0W1dE375I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jSBlu3R/8niKlKzskzalUPaND+fjJeKW+5ieNtDVzyEKdUT0QHKewiWK9iC6XfFDC
         2ayVoE3K+JzGe7fyGSaUq6k6JNQUfYzfFaWcQOEtIjNgI3z7YAPw24kWMMNUU6GTbr
         iyLq8iih5o+Y3l27PRFGfqTCW6MFV9UrbHeeOqlcC93OzKEJmsWp3uLqAVojRzSt3t
         Ozv0+Up3ycj/dpd5L9TXP0XS02yvY0kcSNG4ym8TVKD5qBkMEYisMyHn65pGqIGbYb
         q5m7SG2ys0pdHNwC/DoKKP+FhPzC17aujvo2A2aakLLN7AMPkRrBRnNv0V4yiU12EX
         kUYtPp1K1C/rA==
Subject: [PATCH 03/10] xfs: create fuzz tests for the realtime refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:48 -0800
Message-ID: <167243884893.740253.8454100946260224682.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 63eff39d47..7b7b3a35b5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1829,6 +1829,10 @@ _scratch_xfs_find_rgbtree_height() {
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
index 0000000000..e62bf49b29
--- /dev/null
+++ b/tests/xfs/1538
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
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
index 0000000000..36cef96a91
--- /dev/null
+++ b/tests/xfs/1539
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
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
index 0000000000..fa08d3fb54
--- /dev/null
+++ b/tests/xfs/1540
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
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
index 0000000000..ecf6fdc56c
--- /dev/null
+++ b/tests/xfs/1541
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
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
index 0000000000..37ef8a2b4c
--- /dev/null
+++ b/tests/xfs/1542
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
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
index 0000000000..0acd3203e3
--- /dev/null
+++ b/tests/xfs/1543
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
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
index 0000000000..165f96f6a4
--- /dev/null
+++ b/tests/xfs/1544
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
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
index 0000000000..a467662f2f
--- /dev/null
+++ b/tests/xfs/1545
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
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

