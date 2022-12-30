Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A31C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbiLaAlg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiLaAle (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:41:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5741DDE5;
        Fri, 30 Dec 2022 16:41:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A18161D52;
        Sat, 31 Dec 2022 00:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63297C433EF;
        Sat, 31 Dec 2022 00:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447292;
        bh=YsDWovGILNhQa7ey8AJBVGDOT6YYQ52UjuMRQCEqMgg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t+JwrUaLGz0w0aPo5jhcLI/ZwSkNJXledZjengkvcFJjAMdXWTMZKFKMx7nJ7KBMf
         TXcaEWu2Sw61KM9auVS+oDsHoGkwab4PmkGgdeVXtGECokTDfyOTIk37E2I18O9MXs
         tPMzzr9aD6pmkD9ydGpkH7PMiTt2jYDSOCuV0X3mmCBdzQgNzZYqw5U5+qz+lMLa9E
         Oy+LMW6a7PFbcMTgaAsLcDTKtohiXzjzWeu3tMUMIbB9Vo0UPqhxEGl8y1vvYp72bp
         Vx1WSo2IzaohhlS84HXcYqEP631qtZNRnTxClWM4jvRWv2Gz6193F3AfmngrJ87R2X
         zmchij8fqZuvA==
Subject: [PATCH 2/4] xfs: race fsstress with online repair for inode and fork
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:18 -0800
Message-ID: <167243875862.725760.4136098626843388017.stgit@magnolia>
In-Reply-To: <167243875835.725760.8458608166534095780.stgit@magnolia>
References: <167243875835.725760.8458608166534095780.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For each XFS_SCRUB_TYPE_* that looks at inode and data/attr/cow fork
metadata, create a test that runs that repairer in the foreground and
fsstress in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/807     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/807.out |    2 ++
 tests/xfs/808     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/808.out |    2 ++
 tests/xfs/846     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/846.out |    2 ++
 6 files changed, 121 insertions(+)
 create mode 100755 tests/xfs/807
 create mode 100644 tests/xfs/807.out
 create mode 100755 tests/xfs/808
 create mode 100644 tests/xfs/808.out
 create mode 100755 tests/xfs/846
 create mode 100644 tests/xfs/846.out


diff --git a/tests/xfs/807 b/tests/xfs/807
new file mode 100755
index 0000000000..e32a37057d
--- /dev/null
+++ b/tests/xfs/807
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 807
+#
+# Race fsstress and data fork repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
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
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -s "repair bmapbtd" -t "%datafile%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/807.out b/tests/xfs/807.out
new file mode 100644
index 0000000000..3752a5f715
--- /dev/null
+++ b/tests/xfs/807.out
@@ -0,0 +1,2 @@
+QA output created by 807
+Silence is golden
diff --git a/tests/xfs/808 b/tests/xfs/808
new file mode 100755
index 0000000000..378b606427
--- /dev/null
+++ b/tests/xfs/808
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 808
+#
+# Race fsstress and attr fork repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+. ./common/attr
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_attrs
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -x 'xattr' -s "repair bmapbta" -t "%attrfile%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/808.out b/tests/xfs/808.out
new file mode 100644
index 0000000000..8825342849
--- /dev/null
+++ b/tests/xfs/808.out
@@ -0,0 +1,2 @@
+QA output created by 808
+Silence is golden
diff --git a/tests/xfs/846 b/tests/xfs/846
new file mode 100755
index 0000000000..8388a22730
--- /dev/null
+++ b/tests/xfs/846
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 846
+#
+# Race fsstress and CoW fork repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" reflink
+_scratch_xfs_stress_online_repair -s "repair bmapbtc" -t "%cowfile%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/846.out b/tests/xfs/846.out
new file mode 100644
index 0000000000..c88a3035c3
--- /dev/null
+++ b/tests/xfs/846.out
@@ -0,0 +1,2 @@
+QA output created by 846
+Silence is golden

