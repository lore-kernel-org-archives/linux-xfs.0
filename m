Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97938C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbiLaAvo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiLaAvo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:51:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C8B164AF;
        Fri, 30 Dec 2022 16:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 140A4CE19E1;
        Sat, 31 Dec 2022 00:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54084C433D2;
        Sat, 31 Dec 2022 00:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447899;
        bh=9i7Y2aQnrCVI4oRd3YBxQ1nAoeN3pV8ynsITdPc06eM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R3zXEi+sZILhSyHveMSTAq2qvBnBWg7BjRW1iZTcjFmS5pffMPVzwTn7JQxvbqnvb
         THoe4M/ODslYow9jRQhJ0f/b+wJEezkpFuGKwMc+efO3/EY52plHQcH9DaOdYyWxAK
         GGioqrssebP4plwqIBDuJXX89U6ltvEaZvZGge0gpaxwA29hvrTHM8fDxfe4ZC0Rgz
         iPIlWGefS5VXC1mzz/KQ9WhOTDxRXd5CM5ynTGwnVTSSJou0edRC3UgC9RlOlb71o3
         bZr48If4afayHAj2AVT8fW3S9O4f+TkSOlRV0vCapgxIQ43bvXIrUZQLNn0ANlGGgv
         FHlkOvE/ZMPdw==
Subject: [PATCH 5/5] fuzzy: fuzz test key/pointers of inode btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878535.731641.3126908985481377916.stgit@magnolia>
In-Reply-To: <167243878469.731641.981302372644525592.stgit@magnolia>
References: <167243878469.731641.981302372644525592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Test what happens when we fuzz the key/pointer blocks (aka the interior
nodes) of the inode btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1570     |   36 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1570.out |    4 ++++
 tests/xfs/1571     |   36 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1571.out |    4 ++++
 tests/xfs/1572     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1572.out |    4 ++++
 tests/xfs/1573     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1573.out |    4 ++++
 8 files changed, 163 insertions(+)
 create mode 100755 tests/xfs/1570
 create mode 100644 tests/xfs/1570.out
 create mode 100755 tests/xfs/1571
 create mode 100644 tests/xfs/1571.out
 create mode 100755 tests/xfs/1572
 create mode 100755 tests/xfs/1572.out
 create mode 100755 tests/xfs/1573
 create mode 100644 tests/xfs/1573.out


diff --git a/tests/xfs/1570 b/tests/xfs/1570
new file mode 100755
index 0000000000..c2d144e298
--- /dev/null
+++ b/tests/xfs/1570
@@ -0,0 +1,36 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1570
+#
+# Populate a XFS filesystem and fuzz every inobt key/pointer field.
+# Use xfs_repair to fix the corruption.
+#
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'ino' 2)" || \
+	_fail "could not find two-level inobt"
+
+echo "Fuzz inobt"
+_scratch_xfs_fuzz_metadata '' 'offline'  "$path" 'addr root' >> $seqres.full
+echo "Done fuzzing inobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1570.out b/tests/xfs/1570.out
new file mode 100644
index 0000000000..b3977dca57
--- /dev/null
+++ b/tests/xfs/1570.out
@@ -0,0 +1,4 @@
+QA output created by 1570
+Format and populate
+Fuzz inobt
+Done fuzzing inobt
diff --git a/tests/xfs/1571 b/tests/xfs/1571
new file mode 100755
index 0000000000..c64b321ff6
--- /dev/null
+++ b/tests/xfs/1571
@@ -0,0 +1,36 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1571
+#
+# Populate a XFS filesystem and fuzz every inobt key/pointer field.
+# Use xfs_scrub to fix the corruption.
+#
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'ino' 2)" || \
+	_fail "could not find two-level inobt"
+
+echo "Fuzz inobt"
+_scratch_xfs_fuzz_metadata '' 'online'  "$path" 'addr root' >> $seqres.full
+echo "Done fuzzing inobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1571.out b/tests/xfs/1571.out
new file mode 100644
index 0000000000..292e8bdec4
--- /dev/null
+++ b/tests/xfs/1571.out
@@ -0,0 +1,4 @@
+QA output created by 1571
+Format and populate
+Fuzz inobt
+Done fuzzing inobt
diff --git a/tests/xfs/1572 b/tests/xfs/1572
new file mode 100755
index 0000000000..abcdc2397f
--- /dev/null
+++ b/tests/xfs/1572
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1572
+#
+# Populate a XFS filesystem and fuzz every inobt key/pointer field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'ino' 2)" || \
+	_fail "could not find two-level inobt"
+
+echo "Fuzz inobt"
+_scratch_xfs_fuzz_metadata '' 'both'  "$path" 'addr root' >> $seqres.full
+echo "Done fuzzing inobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1572.out b/tests/xfs/1572.out
new file mode 100755
index 0000000000..8afa3ea075
--- /dev/null
+++ b/tests/xfs/1572.out
@@ -0,0 +1,4 @@
+QA output created by 1572
+Format and populate
+Fuzz inobt
+Done fuzzing inobt
diff --git a/tests/xfs/1573 b/tests/xfs/1573
new file mode 100755
index 0000000000..7a816e59b8
--- /dev/null
+++ b/tests/xfs/1573
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1573
+#
+# Populate a XFS filesystem and fuzz every inobt key/pointer field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_norepair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'ino' 2)" || \
+	_fail "could not find two-level inobt"
+
+echo "Fuzz inobt"
+_scratch_xfs_fuzz_metadata '' 'none'  "$path" 'addr root' >> $seqres.full
+echo "Done fuzzing inobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1573.out b/tests/xfs/1573.out
new file mode 100644
index 0000000000..cef5aef758
--- /dev/null
+++ b/tests/xfs/1573.out
@@ -0,0 +1,4 @@
+QA output created by 1573
+Format and populate
+Fuzz inobt
+Done fuzzing inobt

