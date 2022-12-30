Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A5BC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiLaDRg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiLaDRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:17:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217312733;
        Fri, 30 Dec 2022 19:17:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71247CE1AC9;
        Sat, 31 Dec 2022 03:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6DCC433D2;
        Sat, 31 Dec 2022 03:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456650;
        bh=ae3fZkhjUkgPu/1AAmCrMHrl9N7H8i267tWgT46MGSo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IqWrx82FlQWfK+VFgP+urnxIiYm8J7zT3sb4cfpWx+7CVDskztyN1aCUhK3ZYx7wx
         DyM3M4yTl+rG/zsxwao/f9uzgVGLzPf8/1kCJpOZ/kIV19tyQgpwLpwWkeAv84bIpu
         yBBjwAfuqwumpmv7u5iGBFrTqQEpqWxCNYT+uUmC7qzEPfMTEQ2hIRl1ks1bakETPe
         uIWjC95RkFA0sk3Rg5C49pGLXfsCi4aWCjcsfZ2m8RYWDfgNQyNirpsvkOQX1Ayics
         6K0Ssm+KW0ZAn5024SAhFK7y0J1VbOKmAraczHzGB/rcv5pJh8jhtwruGLFtjVpFt8
         3BmknVJRDqd3w==
Subject: [PATCH 06/10] xfs: race fsstress with realtime refcount btree scrub
 and repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:49 -0800
Message-ID: <167243884932.740253.9910252200044886209.stgit@magnolia>
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

Race checking and rebuilding realtime refcount btrees with fsstress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/818     |   43 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/818.out |    2 ++
 tests/xfs/819     |   43 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/819.out |    2 ++
 4 files changed, 90 insertions(+)
 create mode 100755 tests/xfs/818
 create mode 100644 tests/xfs/818.out
 create mode 100755 tests/xfs/819
 create mode 100644 tests/xfs/819.out


diff --git a/tests/xfs/818 b/tests/xfs/818
new file mode 100755
index 0000000000..aabe636750
--- /dev/null
+++ b/tests/xfs/818
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 818
+#
+# Race fsstress and rt refcount btree scrub for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
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
+_require_realtime
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_require_xfs_has_feature "$SCRATCH_MNT" reflink
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_scrub -s "scrub rtrefcountbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/818.out b/tests/xfs/818.out
new file mode 100644
index 0000000000..cb0997862e
--- /dev/null
+++ b/tests/xfs/818.out
@@ -0,0 +1,2 @@
+QA output created by 818
+Silence is golden
diff --git a/tests/xfs/819 b/tests/xfs/819
new file mode 100755
index 0000000000..e302ed1fdc
--- /dev/null
+++ b/tests/xfs/819
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 819
+#
+# Race fsstress and rt refcount btree scrub for a while to see if we crash or
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
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_require_xfs_has_feature "$SCRATCH_MNT" reflink
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_online_repair -s "repair rtrefcountbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/819.out b/tests/xfs/819.out
new file mode 100644
index 0000000000..f5df7622a7
--- /dev/null
+++ b/tests/xfs/819.out
@@ -0,0 +1,2 @@
+QA output created by 819
+Silence is golden

