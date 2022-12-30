Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A79C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbiLaAmV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiLaAmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:42:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D33D1DDE2;
        Fri, 30 Dec 2022 16:42:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A330F61D52;
        Sat, 31 Dec 2022 00:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B87FC433D2;
        Sat, 31 Dec 2022 00:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447339;
        bh=DGuHekiM4RFpZKnuATGj7KMjrJbc89l/q9O7FiN1LiI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tkPsFFS5aWXC9Bh8aZMIZrcVxlwpdm497ULuOT81X2zqaUnsrlPCAJsa2AstlzLG1
         sBytHpZhonJorceo72+o/N4ul0sI4sIPfP9BWMoN2QoP7ZvGFcf0jAtsFdIfeU5esN
         i5gT9wdN/Nk07ATAvRx7KVbcS5IDLhtjhhHC+Ppu+EyAyOt72FmerykyDqaMOgakPK
         2Yg4OV6jZVPCEjJ3oFTpTdWFEJYnrZ0NZdCWCYVx3Jrx7MXJ7p6F0NoSldelJOdMUn
         EG89VGigNyvgo51k5TPjr1ffSlsGZQz7KhLq/iB+5vaxMYgDBybZa1bzQ98XGbuDmA
         nDUlrOrjUZieg==
Subject: [PATCH 1/1] xfs: race fsstress with online scrub and repair for quota
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876182.726678.5993728572164871488.stgit@magnolia>
In-Reply-To: <167243876170.726678.17872891128076933126.stgit@magnolia>
References: <167243876170.726678.17872891128076933126.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create tests to race fsstress with dquot repair while running fsstress
in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/809     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/809.out |    2 ++
 tests/xfs/810     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/810.out |    2 ++
 tests/xfs/811     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/811.out |    2 ++
 6 files changed, 126 insertions(+)
 create mode 100755 tests/xfs/809
 create mode 100644 tests/xfs/809.out
 create mode 100755 tests/xfs/810
 create mode 100644 tests/xfs/810.out
 create mode 100755 tests/xfs/811
 create mode 100644 tests/xfs/811.out


diff --git a/tests/xfs/809 b/tests/xfs/809
new file mode 100755
index 0000000000..35ac02ff85
--- /dev/null
+++ b/tests/xfs/809
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 809
+#
+# Race fsstress and user quota repair for a while to see if we crash or
+# livelock.
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_quota_acct_enabled "$SCRATCH_DEV" usrquota
+_scratch_xfs_stress_online_repair -s "repair usrquota"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/809.out b/tests/xfs/809.out
new file mode 100644
index 0000000000..e90865ca8f
--- /dev/null
+++ b/tests/xfs/809.out
@@ -0,0 +1,2 @@
+QA output created by 809
+Silence is golden
diff --git a/tests/xfs/810 b/tests/xfs/810
new file mode 100755
index 0000000000..7387910504
--- /dev/null
+++ b/tests/xfs/810
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 810
+#
+# Race fsstress and group quota repair for a while to see if we crash or
+# livelock.
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_quota_acct_enabled "$SCRATCH_DEV" grpquota
+_scratch_xfs_stress_online_repair -s "repair grpquota"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/810.out b/tests/xfs/810.out
new file mode 100644
index 0000000000..90f12fdd21
--- /dev/null
+++ b/tests/xfs/810.out
@@ -0,0 +1,2 @@
+QA output created by 810
+Silence is golden
diff --git a/tests/xfs/811 b/tests/xfs/811
new file mode 100755
index 0000000000..1e13940b46
--- /dev/null
+++ b/tests/xfs/811
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 811
+#
+# Race fsstress and project quota repair for a while to see if we crash or
+# livelock.
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_quota_acct_enabled "$SCRATCH_DEV" prjquota
+_scratch_xfs_stress_online_repair -s "repair prjquota"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/811.out b/tests/xfs/811.out
new file mode 100644
index 0000000000..cf30f69bdc
--- /dev/null
+++ b/tests/xfs/811.out
@@ -0,0 +1,2 @@
+QA output created by 811
+Silence is golden

