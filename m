Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F17BC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbiLaAv3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiLaAv2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:51:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE9413F29;
        Fri, 30 Dec 2022 16:51:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A48061D2F;
        Sat, 31 Dec 2022 00:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B455BC433D2;
        Sat, 31 Dec 2022 00:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447883;
        bh=8LLs4pCq9/BgRdhgzfHNtXb8G5E7vOwRdCiNzA2nHNI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XaywzjagCVAXHIwZJkb1vEgcwJ4W3lagzKUV9o7MNhDzAl/K3MCu8Ucxmt5ad2Nt+
         JLMj32KjECzLwie8ZTSyVumHNrW5/0FIeDGdLi6mUFtyy5R2x8zFNkf2wKPus/psot
         8up1qzQyrXaEO0mcC02XMZF8IXDcU7Ai+4NCi3zO/C7sMwwPMGSkjn565roFEuYg7D
         wzD4/MUc4NxQnRI+1+mfOecrR5IFVpBF51WADlVE1aUMQXZ6Yo8BMn6moJjd2OZeVQ
         WB84GUGj7x5eIjF6pDjNeUeNwz3+2n8jvLRf8uLtu4KZZruB3xkXwHix4PGfIE9X2M
         xI4BGcgIlqAOg==
Subject: [PATCH 4/5] xfs: fuzz test both repair strategies
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878522.731641.10548859117911021800.stgit@magnolia>
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

Add more fuzz tests to examine the effectiveness of online and then
offline repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1500     |   35 +++++++++++++++++++++++++++++++++++
 tests/xfs/1500.out |    4 ++++
 tests/xfs/1501     |   35 +++++++++++++++++++++++++++++++++++
 tests/xfs/1501.out |    4 ++++
 tests/xfs/1502     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1502.out |    6 ++++++
 tests/xfs/1503     |   35 +++++++++++++++++++++++++++++++++++
 tests/xfs/1503.out |    4 ++++
 tests/xfs/1504     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1504.out |    4 ++++
 tests/xfs/1505     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1505.out |    4 ++++
 tests/xfs/1506     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1506.out |    4 ++++
 tests/xfs/1507     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1507.out |    4 ++++
 tests/xfs/1508     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1508.out |    4 ++++
 tests/xfs/1509     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1509.out |    4 ++++
 tests/xfs/1510     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1510.out |    4 ++++
 tests/xfs/1511     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1511.out |    4 ++++
 tests/xfs/1512     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1512.out |    5 +++++
 tests/xfs/1513     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1513.out |    5 +++++
 tests/xfs/1514     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1514.out |    5 +++++
 tests/xfs/1515     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1515.out |    5 +++++
 tests/xfs/1516     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1516.out |    5 +++++
 tests/xfs/1517     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1517.out |    5 +++++
 tests/xfs/1518     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1518.out |    5 +++++
 tests/xfs/1519     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1519.out |    5 +++++
 tests/xfs/1520     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1520.out |    5 +++++
 tests/xfs/1521     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1521.out |    5 +++++
 tests/xfs/1522     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1522.out |    5 +++++
 tests/xfs/1523     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1523.out |    5 +++++
 tests/xfs/1524     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1524.out |    5 +++++
 tests/xfs/1525     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1525.out |    5 +++++
 tests/xfs/1526     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1526.out |    5 +++++
 tests/xfs/1527     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1527.out |    5 +++++
 tests/xfs/1530     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1530.out |    4 ++++
 tests/xfs/1531     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1531.out |    5 +++++
 tests/xfs/1532     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1532.out |    5 +++++
 tests/xfs/1533     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1533.out |    5 +++++
 tests/xfs/1534     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1534.out |    4 ++++
 tests/xfs/1535     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1535.out |    4 ++++
 tests/xfs/1536     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1536.out |    4 ++++
 tests/xfs/1537     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1537.out |    5 +++++
 tests/xfs/1560     |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1560.out |   10 ++++++++++
 tests/xfs/1561     |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1561.out |   10 ++++++++++
 76 files changed, 1709 insertions(+)
 create mode 100755 tests/xfs/1500
 create mode 100644 tests/xfs/1500.out
 create mode 100755 tests/xfs/1501
 create mode 100644 tests/xfs/1501.out
 create mode 100755 tests/xfs/1502
 create mode 100644 tests/xfs/1502.out
 create mode 100755 tests/xfs/1503
 create mode 100644 tests/xfs/1503.out
 create mode 100755 tests/xfs/1504
 create mode 100644 tests/xfs/1504.out
 create mode 100755 tests/xfs/1505
 create mode 100644 tests/xfs/1505.out
 create mode 100755 tests/xfs/1506
 create mode 100644 tests/xfs/1506.out
 create mode 100755 tests/xfs/1507
 create mode 100644 tests/xfs/1507.out
 create mode 100755 tests/xfs/1508
 create mode 100644 tests/xfs/1508.out
 create mode 100755 tests/xfs/1509
 create mode 100644 tests/xfs/1509.out
 create mode 100755 tests/xfs/1510
 create mode 100644 tests/xfs/1510.out
 create mode 100755 tests/xfs/1511
 create mode 100644 tests/xfs/1511.out
 create mode 100755 tests/xfs/1512
 create mode 100644 tests/xfs/1512.out
 create mode 100755 tests/xfs/1513
 create mode 100644 tests/xfs/1513.out
 create mode 100755 tests/xfs/1514
 create mode 100644 tests/xfs/1514.out
 create mode 100755 tests/xfs/1515
 create mode 100644 tests/xfs/1515.out
 create mode 100755 tests/xfs/1516
 create mode 100644 tests/xfs/1516.out
 create mode 100755 tests/xfs/1517
 create mode 100644 tests/xfs/1517.out
 create mode 100755 tests/xfs/1518
 create mode 100644 tests/xfs/1518.out
 create mode 100755 tests/xfs/1519
 create mode 100644 tests/xfs/1519.out
 create mode 100755 tests/xfs/1520
 create mode 100644 tests/xfs/1520.out
 create mode 100755 tests/xfs/1521
 create mode 100644 tests/xfs/1521.out
 create mode 100755 tests/xfs/1522
 create mode 100644 tests/xfs/1522.out
 create mode 100755 tests/xfs/1523
 create mode 100644 tests/xfs/1523.out
 create mode 100755 tests/xfs/1524
 create mode 100644 tests/xfs/1524.out
 create mode 100755 tests/xfs/1525
 create mode 100644 tests/xfs/1525.out
 create mode 100755 tests/xfs/1526
 create mode 100644 tests/xfs/1526.out
 create mode 100755 tests/xfs/1527
 create mode 100644 tests/xfs/1527.out
 create mode 100755 tests/xfs/1530
 create mode 100644 tests/xfs/1530.out
 create mode 100755 tests/xfs/1531
 create mode 100644 tests/xfs/1531.out
 create mode 100755 tests/xfs/1532
 create mode 100644 tests/xfs/1532.out
 create mode 100755 tests/xfs/1533
 create mode 100644 tests/xfs/1533.out
 create mode 100755 tests/xfs/1534
 create mode 100644 tests/xfs/1534.out
 create mode 100755 tests/xfs/1535
 create mode 100644 tests/xfs/1535.out
 create mode 100755 tests/xfs/1536
 create mode 100644 tests/xfs/1536.out
 create mode 100755 tests/xfs/1537
 create mode 100644 tests/xfs/1537.out
 create mode 100755 tests/xfs/1560
 create mode 100644 tests/xfs/1560.out
 create mode 100755 tests/xfs/1561
 create mode 100644 tests/xfs/1561.out


diff --git a/tests/xfs/1500 b/tests/xfs/1500
new file mode 100755
index 0000000000..cae5e05caf
--- /dev/null
+++ b/tests/xfs/1500
@@ -0,0 +1,35 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1500
+#
+# Populate a XFS filesystem and fuzz every superblock field.
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
+echo "Fuzz superblock"
+_scratch_xfs_fuzz_metadata '' 'both' 'sb 1' >> $seqres.full
+echo "Done fuzzing superblock"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1500.out b/tests/xfs/1500.out
new file mode 100644
index 0000000000..bb485204c7
--- /dev/null
+++ b/tests/xfs/1500.out
@@ -0,0 +1,4 @@
+QA output created by 1500
+Format and populate
+Fuzz superblock
+Done fuzzing superblock
diff --git a/tests/xfs/1501 b/tests/xfs/1501
new file mode 100755
index 0000000000..867584ebbe
--- /dev/null
+++ b/tests/xfs/1501
@@ -0,0 +1,35 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1501
+#
+# Populate a XFS filesystem and fuzz every AGF field.
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
+echo "Fuzz AGF"
+_scratch_xfs_fuzz_metadata '' 'both' 'agf 0' >> $seqres.full
+echo "Done fuzzing AGF"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1501.out b/tests/xfs/1501.out
new file mode 100644
index 0000000000..0c8b1be2a5
--- /dev/null
+++ b/tests/xfs/1501.out
@@ -0,0 +1,4 @@
+QA output created by 1501
+Format and populate
+Fuzz AGF
+Done fuzzing AGF
diff --git a/tests/xfs/1502 b/tests/xfs/1502
new file mode 100755
index 0000000000..04116d6d0e
--- /dev/null
+++ b/tests/xfs/1502
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1502
+#
+# Populate a XFS filesystem and fuzz every AGFL field.
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
+echo "Fuzz AGFL"
+_scratch_xfs_fuzz_metadata '' 'both' 'agfl 0' >> $seqres.full
+echo "Done fuzzing AGFL"
+
+# Restore a correct copy of the filesystem before we start the second round of
+# fuzzing.  This avoids corruption errors from xfs_db when we probe for flfirst
+# in the AGF and later when _scratch_xfs_fuzz_metadata probes the AGFL fields.
+__scratch_xfs_fuzz_mdrestore
+flfirst=$(_scratch_xfs_db -c 'agf 0' -c 'p flfirst' | sed -e 's/flfirst = //g')
+
+echo "Fuzz AGFL flfirst"
+SCRATCH_XFS_LIST_METADATA_FIELDS="bno[${flfirst}]" _scratch_xfs_fuzz_metadata '' 'both' 'agfl 0' >> $seqres.full
+echo "Done fuzzing AGFL flfirst"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1502.out b/tests/xfs/1502.out
new file mode 100644
index 0000000000..99c0facdac
--- /dev/null
+++ b/tests/xfs/1502.out
@@ -0,0 +1,6 @@
+QA output created by 1502
+Format and populate
+Fuzz AGFL
+Done fuzzing AGFL
+Fuzz AGFL flfirst
+Done fuzzing AGFL flfirst
diff --git a/tests/xfs/1503 b/tests/xfs/1503
new file mode 100755
index 0000000000..8c4b125dfa
--- /dev/null
+++ b/tests/xfs/1503
@@ -0,0 +1,35 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1503
+#
+# Populate a XFS filesystem and fuzz every AGI field.
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
+echo "Fuzz AGI"
+_scratch_xfs_fuzz_metadata '' 'both' 'agi 0' >> $seqres.full
+echo "Done fuzzing AGI"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1503.out b/tests/xfs/1503.out
new file mode 100644
index 0000000000..0029001317
--- /dev/null
+++ b/tests/xfs/1503.out
@@ -0,0 +1,4 @@
+QA output created by 1503
+Format and populate
+Fuzz AGI
+Done fuzzing AGI
diff --git a/tests/xfs/1504 b/tests/xfs/1504
new file mode 100755
index 0000000000..e2712e646d
--- /dev/null
+++ b/tests/xfs/1504
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1504
+#
+# Populate a XFS filesystem and fuzz every bnobt field.
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
+path="$(_scratch_xfs_find_agbtree_height 'bno' 2)" || \
+	_fail "could not find two-level bnobt"
+
+echo "Fuzz bnobt recs"
+_scratch_xfs_fuzz_metadata '' 'both'  "$path" 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing bnobt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1504.out b/tests/xfs/1504.out
new file mode 100644
index 0000000000..2c8162dd31
--- /dev/null
+++ b/tests/xfs/1504.out
@@ -0,0 +1,4 @@
+QA output created by 1504
+Format and populate
+Fuzz bnobt recs
+Done fuzzing bnobt recs
diff --git a/tests/xfs/1505 b/tests/xfs/1505
new file mode 100755
index 0000000000..dbf850f8b4
--- /dev/null
+++ b/tests/xfs/1505
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1505
+#
+# Populate a XFS filesystem and fuzz every bnobt key/pointer.
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
+path="$(_scratch_xfs_find_agbtree_height 'bno' 2)" || \
+	_fail "could not find two-level bnobt"
+
+echo "Fuzz bnobt keyptr"
+_scratch_xfs_fuzz_metadata '' 'both'  "$path" 'addr bnoroot' >> $seqres.full
+echo "Done fuzzing bnobt keyptr"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1505.out b/tests/xfs/1505.out
new file mode 100644
index 0000000000..7c326a36dc
--- /dev/null
+++ b/tests/xfs/1505.out
@@ -0,0 +1,4 @@
+QA output created by 1505
+Format and populate
+Fuzz bnobt keyptr
+Done fuzzing bnobt keyptr
diff --git a/tests/xfs/1506 b/tests/xfs/1506
new file mode 100755
index 0000000000..efce4928fa
--- /dev/null
+++ b/tests/xfs/1506
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1506
+#
+# Populate a XFS filesystem and fuzz every cntbt field.
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
+path="$(_scratch_xfs_find_agbtree_height 'cnt' 2)" || \
+	_fail "could not find two-level cntbt"
+
+echo "Fuzz cntbt"
+_scratch_xfs_fuzz_metadata '' 'both'  "$path" 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing cntbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1506.out b/tests/xfs/1506.out
new file mode 100644
index 0000000000..bed44c625b
--- /dev/null
+++ b/tests/xfs/1506.out
@@ -0,0 +1,4 @@
+QA output created by 1506
+Format and populate
+Fuzz cntbt
+Done fuzzing cntbt
diff --git a/tests/xfs/1507 b/tests/xfs/1507
new file mode 100755
index 0000000000..7cece6854d
--- /dev/null
+++ b/tests/xfs/1507
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1507
+#
+# Populate a XFS filesystem and fuzz every inobt field.
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
+_scratch_xfs_fuzz_metadata '' 'both'  "$path" 'addr root' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing inobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1507.out b/tests/xfs/1507.out
new file mode 100644
index 0000000000..3607a3a554
--- /dev/null
+++ b/tests/xfs/1507.out
@@ -0,0 +1,4 @@
+QA output created by 1507
+Format and populate
+Fuzz inobt
+Done fuzzing inobt
diff --git a/tests/xfs/1508 b/tests/xfs/1508
new file mode 100755
index 0000000000..e2b38a9242
--- /dev/null
+++ b/tests/xfs/1508
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1508
+#
+# Populate a XFS filesystem and fuzz every finobt field.
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
+_require_xfs_finobt
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'fino' 2)" || \
+	_fail "could not find two-level finobt"
+
+echo "Fuzz finobt"
+_scratch_xfs_fuzz_metadata '' 'both'  "$path" 'addr free_root' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing finobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1508.out b/tests/xfs/1508.out
new file mode 100644
index 0000000000..08b8e704b4
--- /dev/null
+++ b/tests/xfs/1508.out
@@ -0,0 +1,4 @@
+QA output created by 1508
+Format and populate
+Fuzz finobt
+Done fuzzing finobt
diff --git a/tests/xfs/1509 b/tests/xfs/1509
new file mode 100755
index 0000000000..c90c4e6784
--- /dev/null
+++ b/tests/xfs/1509
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1509
+#
+# Populate a XFS filesystem and fuzz every rmapbt field.
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
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rmapbt"
+
+echo "Fuzz rmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'both' "$path" 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing rmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1509.out b/tests/xfs/1509.out
new file mode 100644
index 0000000000..95a25b005f
--- /dev/null
+++ b/tests/xfs/1509.out
@@ -0,0 +1,4 @@
+QA output created by 1509
+Format and populate
+Fuzz rmapbt recs
+Done fuzzing rmapbt recs
diff --git a/tests/xfs/1510 b/tests/xfs/1510
new file mode 100755
index 0000000000..fd8b994a98
--- /dev/null
+++ b/tests/xfs/1510
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1510
+#
+# Populate a XFS filesystem and fuzz every rmapbt key/pointer field.
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
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rmapbt"
+
+echo "Fuzz rmapbt keyptr"
+_scratch_xfs_fuzz_metadata '' 'both' "$path" 'addr rmaproot' >> $seqres.full
+echo "Done fuzzing rmapbt keyptr"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1510.out b/tests/xfs/1510.out
new file mode 100644
index 0000000000..0d5d467e2e
--- /dev/null
+++ b/tests/xfs/1510.out
@@ -0,0 +1,4 @@
+QA output created by 1510
+Format and populate
+Fuzz rmapbt keyptr
+Done fuzzing rmapbt keyptr
diff --git a/tests/xfs/1511 b/tests/xfs/1511
new file mode 100755
index 0000000000..ac945c17ed
--- /dev/null
+++ b/tests/xfs/1511
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1511
+#
+# Populate a XFS filesystem and fuzz every refcountbt key/pointer field.
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
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level refcountbt"
+
+echo "Fuzz refcountbt"
+_scratch_xfs_fuzz_metadata '' 'both'  "$path" 'addr refcntroot' >> $seqres.full
+echo "Done fuzzing refcountbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1511.out b/tests/xfs/1511.out
new file mode 100644
index 0000000000..0628ebe519
--- /dev/null
+++ b/tests/xfs/1511.out
@@ -0,0 +1,4 @@
+QA output created by 1511
+Format and populate
+Fuzz refcountbt
+Done fuzzing refcountbt
diff --git a/tests/xfs/1512 b/tests/xfs/1512
new file mode 100755
index 0000000000..9e3b859e1b
--- /dev/null
+++ b/tests/xfs/1512
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1512
+#
+# Populate a XFS filesystem and fuzz every btree-format directory inode field.
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
+echo "Find btree-format dir inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1512.out b/tests/xfs/1512.out
new file mode 100644
index 0000000000..c28f0fc936
--- /dev/null
+++ b/tests/xfs/1512.out
@@ -0,0 +1,5 @@
+QA output created by 1512
+Format and populate
+Find btree-format dir inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1513 b/tests/xfs/1513
new file mode 100755
index 0000000000..5b1ed15290
--- /dev/null
+++ b/tests/xfs/1513
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1513
+#
+# Populate a XFS filesystem and fuzz every extents-format file inode field.
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
+echo "Find extents-format file inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_EXTENTS)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1513.out b/tests/xfs/1513.out
new file mode 100644
index 0000000000..6ee6f85ac3
--- /dev/null
+++ b/tests/xfs/1513.out
@@ -0,0 +1,5 @@
+QA output created by 1513
+Format and populate
+Find extents-format file inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1514 b/tests/xfs/1514
new file mode 100755
index 0000000000..8f530466d8
--- /dev/null
+++ b/tests/xfs/1514
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1514
+#
+# Populate a XFS filesystem and fuzz every btree-format file inode field.
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
+echo "Find btree-format file inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1514.out b/tests/xfs/1514.out
new file mode 100644
index 0000000000..9bebc6d1a0
--- /dev/null
+++ b/tests/xfs/1514.out
@@ -0,0 +1,5 @@
+QA output created by 1514
+Format and populate
+Find btree-format file inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1515 b/tests/xfs/1515
new file mode 100755
index 0000000000..7a67448a40
--- /dev/null
+++ b/tests/xfs/1515
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1515
+#
+# Populate a XFS filesystem and fuzz every bmbt block field.
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
+echo "Find bmbt block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_BTREE)
+_scratch_unmount
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "inode ${inum}")
+
+echo "Fuzz bmbt"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "addr u${inode_ver}.bmbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing bmbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1515.out b/tests/xfs/1515.out
new file mode 100644
index 0000000000..239ad87fa9
--- /dev/null
+++ b/tests/xfs/1515.out
@@ -0,0 +1,5 @@
+QA output created by 1515
+Format and populate
+Find bmbt block
+Fuzz bmbt
+Done fuzzing bmbt
diff --git a/tests/xfs/1516 b/tests/xfs/1516
new file mode 100755
index 0000000000..9c89964f85
--- /dev/null
+++ b/tests/xfs/1516
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1516
+#
+# Populate a XFS filesystem and fuzz every symlink remote block field.
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
+echo "Find symlink remote block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFLNK.FMT_EXTENTS)
+_scratch_unmount
+
+echo "Fuzz symlink remote block"
+_scratch_xfs_fuzz_metadata '' 'both' "inode ${inum}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing symlink remote block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1516.out b/tests/xfs/1516.out
new file mode 100644
index 0000000000..043db933d2
--- /dev/null
+++ b/tests/xfs/1516.out
@@ -0,0 +1,5 @@
+QA output created by 1516
+Format and populate
+Find symlink remote block
+Fuzz symlink remote block
+Done fuzzing symlink remote block
diff --git a/tests/xfs/1517 b/tests/xfs/1517
new file mode 100755
index 0000000000..e54f081281
--- /dev/null
+++ b/tests/xfs/1517
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1517
+#
+# Populate a XFS filesystem and fuzz every inline directory inode field.
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
+echo "Find inline-format dir inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_INLINE)
+_scratch_unmount
+
+echo "Fuzz inline-format dir inode"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inline-format dir inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1517.out b/tests/xfs/1517.out
new file mode 100644
index 0000000000..94063af2ab
--- /dev/null
+++ b/tests/xfs/1517.out
@@ -0,0 +1,5 @@
+QA output created by 1517
+Format and populate
+Find inline-format dir inode
+Fuzz inline-format dir inode
+Done fuzzing inline-format dir inode
diff --git a/tests/xfs/1518 b/tests/xfs/1518
new file mode 100755
index 0000000000..14b1d74837
--- /dev/null
+++ b/tests/xfs/1518
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1518
+#
+# Populate a XFS filesystem and fuzz every block-format dir block field.
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
+echo "Find data-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_BLOCK)
+_scratch_unmount
+
+echo "Fuzz data-format dir block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing data-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1518.out b/tests/xfs/1518.out
new file mode 100644
index 0000000000..a3831196fd
--- /dev/null
+++ b/tests/xfs/1518.out
@@ -0,0 +1,5 @@
+QA output created by 1518
+Format and populate
+Find data-format dir block
+Fuzz data-format dir block
+Done fuzzing data-format dir block
diff --git a/tests/xfs/1519 b/tests/xfs/1519
new file mode 100755
index 0000000000..98d719d33f
--- /dev/null
+++ b/tests/xfs/1519
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1519
+#
+# Populate a XFS filesystem and fuzz every data-format dir block field.
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
+echo "Find data-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAF)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+echo "Fuzz data-format dir block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "dblock 0" >> $seqres.full
+echo "Done fuzzing data-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1519.out b/tests/xfs/1519.out
new file mode 100644
index 0000000000..d1607473d5
--- /dev/null
+++ b/tests/xfs/1519.out
@@ -0,0 +1,5 @@
+QA output created by 1519
+Format and populate
+Find data-format dir block
+Fuzz data-format dir block
+Done fuzzing data-format dir block
diff --git a/tests/xfs/1520 b/tests/xfs/1520
new file mode 100755
index 0000000000..fedee5a52f
--- /dev/null
+++ b/tests/xfs/1520
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1520
+#
+# Populate a XFS filesystem and fuzz every leaf1-format dir block field.
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
+echo "Find leaf1-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAF)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz))
+echo "Fuzz leaf1-format dir block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing leaf1-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1520.out b/tests/xfs/1520.out
new file mode 100644
index 0000000000..a97bf281f6
--- /dev/null
+++ b/tests/xfs/1520.out
@@ -0,0 +1,5 @@
+QA output created by 1520
+Format and populate
+Find leaf1-format dir block
+Fuzz leaf1-format dir block
+Done fuzzing leaf1-format dir block
diff --git a/tests/xfs/1521 b/tests/xfs/1521
new file mode 100755
index 0000000000..9d9bfcf407
--- /dev/null
+++ b/tests/xfs/1521
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1521
+#
+# Populate a XFS filesystem and fuzz every leafn-format dir block field.
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
+echo "Find leafn-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( ( (2 ** 35) / blk_sz) + 1))
+echo "Fuzz leafn-format dir block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing leafn-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1521.out b/tests/xfs/1521.out
new file mode 100644
index 0000000000..c47f0f08c5
--- /dev/null
+++ b/tests/xfs/1521.out
@@ -0,0 +1,5 @@
+QA output created by 1521
+Format and populate
+Find leafn-format dir block
+Fuzz leafn-format dir block
+Done fuzzing leafn-format dir block
diff --git a/tests/xfs/1522 b/tests/xfs/1522
new file mode 100755
index 0000000000..1ae8eac378
--- /dev/null
+++ b/tests/xfs/1522
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1522
+#
+# Populate a XFS filesystem and fuzz every node-format dir block field.
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
+echo "Find node-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+echo "Fuzz node-format dir block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing node-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1522.out b/tests/xfs/1522.out
new file mode 100644
index 0000000000..ae26b05740
--- /dev/null
+++ b/tests/xfs/1522.out
@@ -0,0 +1,5 @@
+QA output created by 1522
+Format and populate
+Find node-format dir block
+Fuzz node-format dir block
+Done fuzzing node-format dir block
diff --git a/tests/xfs/1523 b/tests/xfs/1523
new file mode 100755
index 0000000000..345bc6e57a
--- /dev/null
+++ b/tests/xfs/1523
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1523
+#
+# Populate a XFS filesystem and fuzz every freeindex-format dir block field.
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
+echo "Find freeindex-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 36) / blk_sz ))
+echo "Fuzz freeindex-format dir block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing freeindex-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1523.out b/tests/xfs/1523.out
new file mode 100644
index 0000000000..b4dd1270ae
--- /dev/null
+++ b/tests/xfs/1523.out
@@ -0,0 +1,5 @@
+QA output created by 1523
+Format and populate
+Find freeindex-format dir block
+Fuzz freeindex-format dir block
+Done fuzzing freeindex-format dir block
diff --git a/tests/xfs/1524 b/tests/xfs/1524
new file mode 100755
index 0000000000..6602fac980
--- /dev/null
+++ b/tests/xfs/1524
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1524
+#
+# Populate a XFS filesystem and fuzz every inline attr inode field.
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
+echo "Find inline-format attr inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_LOCAL)
+_scratch_unmount
+
+echo "Fuzz inline-format attr inode"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inline-format attr inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1524.out b/tests/xfs/1524.out
new file mode 100644
index 0000000000..2afb919ce8
--- /dev/null
+++ b/tests/xfs/1524.out
@@ -0,0 +1,5 @@
+QA output created by 1524
+Format and populate
+Find inline-format attr inode
+Fuzz inline-format attr inode
+Done fuzzing inline-format attr inode
diff --git a/tests/xfs/1525 b/tests/xfs/1525
new file mode 100755
index 0000000000..78ae622739
--- /dev/null
+++ b/tests/xfs/1525
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1525
+#
+# Populate a XFS filesystem and fuzz every leaf-format attr block field.
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
+echo "Find leaf-format attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_LEAF)
+_scratch_unmount
+
+echo "Fuzz leaf-format attr block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" 'ablock 0' >> $seqres.full
+echo "Done fuzzing leaf-format attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1525.out b/tests/xfs/1525.out
new file mode 100644
index 0000000000..dda2601e13
--- /dev/null
+++ b/tests/xfs/1525.out
@@ -0,0 +1,5 @@
+QA output created by 1525
+Format and populate
+Find leaf-format attr block
+Fuzz leaf-format attr block
+Done fuzzing leaf-format attr block
diff --git a/tests/xfs/1526 b/tests/xfs/1526
new file mode 100755
index 0000000000..7efe2fdbfc
--- /dev/null
+++ b/tests/xfs/1526
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1526
+#
+# Populate a XFS filesystem and fuzz every node-format attr block field.
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
+echo "Find node-format attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_NODE)
+_scratch_unmount
+
+echo "Fuzz node-format attr block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "ablock 0" >> $seqres.full
+echo "Done fuzzing node-format attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1526.out b/tests/xfs/1526.out
new file mode 100644
index 0000000000..ef7b4c7a9e
--- /dev/null
+++ b/tests/xfs/1526.out
@@ -0,0 +1,5 @@
+QA output created by 1526
+Format and populate
+Find node-format attr block
+Fuzz node-format attr block
+Done fuzzing node-format attr block
diff --git a/tests/xfs/1527 b/tests/xfs/1527
new file mode 100755
index 0000000000..9ebcbe7117
--- /dev/null
+++ b/tests/xfs/1527
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1527
+#
+# Populate a XFS filesystem and fuzz every external attr block field.
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
+echo "Find external attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_EXTENTS_REMOTE3K)
+_scratch_unmount
+
+echo "Fuzz external attr block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "ablock 1" >> $seqres.full
+echo "Done fuzzing external attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1527.out b/tests/xfs/1527.out
new file mode 100644
index 0000000000..a79038cccf
--- /dev/null
+++ b/tests/xfs/1527.out
@@ -0,0 +1,5 @@
+QA output created by 1527
+Format and populate
+Find external attr block
+Fuzz external attr block
+Done fuzzing external attr block
diff --git a/tests/xfs/1530 b/tests/xfs/1530
new file mode 100755
index 0000000000..6225391078
--- /dev/null
+++ b/tests/xfs/1530
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1530
+#
+# Populate a XFS filesystem and fuzz every refcountbt field.
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
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_agbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level refcountbt"
+
+echo "Fuzz refcountbt"
+_scratch_xfs_fuzz_metadata '' 'both'  "$path" 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing refcountbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1530.out b/tests/xfs/1530.out
new file mode 100644
index 0000000000..4c2f39053e
--- /dev/null
+++ b/tests/xfs/1530.out
@@ -0,0 +1,4 @@
+QA output created by 1530
+Format and populate
+Fuzz refcountbt
+Done fuzzing refcountbt
diff --git a/tests/xfs/1531 b/tests/xfs/1531
new file mode 100755
index 0000000000..43a446e538
--- /dev/null
+++ b/tests/xfs/1531
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1531
+#
+# Populate a XFS filesystem and fuzz every btree-format attr inode field.
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
+echo "Find btree-format attr inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1531.out b/tests/xfs/1531.out
new file mode 100644
index 0000000000..6c4deceaf0
--- /dev/null
+++ b/tests/xfs/1531.out
@@ -0,0 +1,5 @@
+QA output created by 1531
+Format and populate
+Find btree-format attr inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1532 b/tests/xfs/1532
new file mode 100755
index 0000000000..1aa65139a6
--- /dev/null
+++ b/tests/xfs/1532
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1532
+#
+# Populate a XFS filesystem and fuzz every blockdev inode field.
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
+echo "Find blockdev inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFBLK)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1532.out b/tests/xfs/1532.out
new file mode 100644
index 0000000000..4bb5defc3f
--- /dev/null
+++ b/tests/xfs/1532.out
@@ -0,0 +1,5 @@
+QA output created by 1532
+Format and populate
+Find blockdev inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1533 b/tests/xfs/1533
new file mode 100755
index 0000000000..e873432a0e
--- /dev/null
+++ b/tests/xfs/1533
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1533
+#
+# Populate a XFS filesystem and fuzz every local-format symlink inode field.
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
+echo "Find local-format symlink inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFLNK.FMT_LOCAL)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1533.out b/tests/xfs/1533.out
new file mode 100644
index 0000000000..198e5266fc
--- /dev/null
+++ b/tests/xfs/1533.out
@@ -0,0 +1,5 @@
+QA output created by 1533
+Format and populate
+Find local-format symlink inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1534 b/tests/xfs/1534
new file mode 100755
index 0000000000..20a0faa56f
--- /dev/null
+++ b/tests/xfs/1534
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1534
+#
+# Populate a XFS filesystem and fuzz every user dquot field.
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+_require_quota
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
+
+echo "Fuzz user 0 dquot"
+_scratch_xfs_fuzz_metadata '' 'both'  "dquot -u 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1534.out b/tests/xfs/1534.out
new file mode 100644
index 0000000000..0e5484adfc
--- /dev/null
+++ b/tests/xfs/1534.out
@@ -0,0 +1,4 @@
+QA output created by 1534
+Format and populate
+Fuzz user 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1535 b/tests/xfs/1535
new file mode 100755
index 0000000000..c6b268621c
--- /dev/null
+++ b/tests/xfs/1535
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1535
+#
+# Populate a XFS filesystem and fuzz every group dquot field.
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+_require_quota
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
+
+echo "Fuzz group 0 dquot"
+_scratch_xfs_fuzz_metadata '' 'both'  "dquot -g 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1535.out b/tests/xfs/1535.out
new file mode 100644
index 0000000000..ad317e3673
--- /dev/null
+++ b/tests/xfs/1535.out
@@ -0,0 +1,4 @@
+QA output created by 1535
+Format and populate
+Fuzz group 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1536 b/tests/xfs/1536
new file mode 100755
index 0000000000..20d054df6f
--- /dev/null
+++ b/tests/xfs/1536
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1536
+#
+# Populate a XFS filesystem and fuzz every project dquot field.
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+_require_quota
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
+
+echo "Fuzz project 0 dquot"
+_scratch_xfs_fuzz_metadata '' 'both'  "dquot -p 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1536.out b/tests/xfs/1536.out
new file mode 100644
index 0000000000..8738d707dd
--- /dev/null
+++ b/tests/xfs/1536.out
@@ -0,0 +1,4 @@
+QA output created by 1536
+Format and populate
+Fuzz project 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1537 b/tests/xfs/1537
new file mode 100755
index 0000000000..21f962dfaf
--- /dev/null
+++ b/tests/xfs/1537
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1537
+#
+# Populate a XFS filesystem and fuzz every single-leafn-format dir block field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+#
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
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Find single-leafn-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAFN)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+echo "Fuzz single-leafn-format dir block"
+_scratch_xfs_fuzz_metadata '' 'both'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing single-leafn-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1537.out b/tests/xfs/1537.out
new file mode 100644
index 0000000000..f298ecce6b
--- /dev/null
+++ b/tests/xfs/1537.out
@@ -0,0 +1,5 @@
+QA output created by 1537
+Format and populate
+Find single-leafn-format dir block
+Fuzz single-leafn-format dir block
+Done fuzzing single-leafn-format dir block
diff --git a/tests/xfs/1560 b/tests/xfs/1560
new file mode 100755
index 0000000000..456f079919
--- /dev/null
+++ b/tests/xfs/1560
@@ -0,0 +1,49 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1560
+#
+# Populate a XFS filesystem and fuzz the data mappings of every directory type.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+#
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_bothrepair
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
+_scratch_xfs_set_dir_fuzz_types
+
+# Now fuzz the block maps of each directory type.
+for dirtype in "${SCRATCH_XFS_DIR_FUZZ_TYPES[@]}"; do
+	echo "Fuzz block map for ${dirtype}" | tee -a $seqres.full
+
+	# Restore a correct copy of the filesystem before we start a round of
+	# fuzzing.  This avoids corruption errors from xfs_db when
+	# _scratch_xfs_fuzz_metadata probes the directory block fields.
+	__scratch_xfs_fuzz_mdrestore
+
+	_scratch_mount
+	inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_${dirtype})
+	_scratch_unmount
+
+	_scratch_xfs_fuzz_metadata 'u*.bmx' 'both'  "inode ${inum}" >> $seqres.full
+	echo "Done fuzzing dir map ${dirtype}"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1560.out b/tests/xfs/1560.out
new file mode 100644
index 0000000000..429cd3e0ce
--- /dev/null
+++ b/tests/xfs/1560.out
@@ -0,0 +1,10 @@
+QA output created by 1560
+Format and populate
+Fuzz block map for BLOCK
+Done fuzzing dir map BLOCK
+Fuzz block map for LEAF
+Done fuzzing dir map LEAF
+Fuzz block map for LEAFN
+Done fuzzing dir map LEAFN
+Fuzz block map for NODE
+Done fuzzing dir map NODE
diff --git a/tests/xfs/1561 b/tests/xfs/1561
new file mode 100755
index 0000000000..936e4c264f
--- /dev/null
+++ b/tests/xfs/1561
@@ -0,0 +1,49 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1561
+#
+# Populate a XFS filesystem and fuzz the attr mappings of every xattr type.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+#
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_bothrepair
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
+_scratch_xfs_set_xattr_fuzz_types
+
+# Now fuzz the block maps of each xattr type.
+for attrtype in "${SCRATCH_XFS_XATTR_FUZZ_TYPES[@]}"; do
+	echo "Fuzz block map for ${attrtype}" | tee -a $seqres.full
+
+	# Restore a correct copy of the filesystem before we start a round of
+	# fuzzing.  This avoids corruption errors from xfs_db when
+	# _scratch_xfs_fuzz_metadata probes the xattr block fields.
+	__scratch_xfs_fuzz_mdrestore
+
+	_scratch_mount
+	inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_${attrtype})
+	_scratch_unmount
+
+	_scratch_xfs_fuzz_metadata 'a*.bmx' 'both'  "inode ${inum}" >> $seqres.full
+	echo "Done fuzzing attr map ${attrtype}"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1561.out b/tests/xfs/1561.out
new file mode 100644
index 0000000000..39e5dcba71
--- /dev/null
+++ b/tests/xfs/1561.out
@@ -0,0 +1,10 @@
+QA output created by 1561
+Format and populate
+Fuzz block map for EXTENTS_REMOTE3K
+Done fuzzing attr map EXTENTS_REMOTE3K
+Fuzz block map for EXTENTS_REMOTE4K
+Done fuzzing attr map EXTENTS_REMOTE4K
+Fuzz block map for LEAF
+Done fuzzing attr map LEAF
+Fuzz block map for NODE
+Done fuzzing attr map NODE

