Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34023C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbiLaAmh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiLaAmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:42:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E5D1DDE2;
        Fri, 30 Dec 2022 16:42:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3616361D58;
        Sat, 31 Dec 2022 00:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D810C433EF;
        Sat, 31 Dec 2022 00:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447354;
        bh=ardYTeTGdVKlvKtNdtjlZWnLBRfGlP3Ase+bd+ofVTQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oTXOiQj/u0DhbGJ3IDS0f8FA7wvsJQYgcEfpTEfdohqW+fUYjRx5CpzcMxD+MtQXT
         0oYwr3k5x7YxCbXDzwfAo7T9xnDzNrxoLrF9E8GOJSGyXCNkGsEJxyp5HMI7j95IaR
         +ZEH6G7igFNf7AHCcN1mDJOMskS/dtzhPtfNNF7cz4jE3REyWfOzb6fZ/Et3vUPyvH
         83W5S8jaI2WVF806L4yMRaAAYbY3APvyXvwyAosKA2eXKIiIVSq8Rzv/DSUKlqot4J
         G0dbHH1Di87OuWnNWJw5GLMPN38EZ6kz0QTxMztyQKsbECxgLGGkxkxT3xeLFWiEuO
         N0eB1C7BcwgXw==
Subject: [PATCH 1/1] xfs: race fsstress with online scrub and repair for
 quotacheck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876474.727185.6330332863953257231.stgit@magnolia>
In-Reply-To: <167243876462.727185.1053988846654244651.stgit@magnolia>
References: <167243876462.727185.1053988846654244651.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create tests to race fsstress with quota count check and repair while
running fsstress in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/715     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/715.out |    2 ++
 tests/xfs/812     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/812.out |    2 ++
 4 files changed, 84 insertions(+)
 create mode 100755 tests/xfs/715
 create mode 100644 tests/xfs/715.out
 create mode 100755 tests/xfs/812
 create mode 100644 tests/xfs/812.out


diff --git a/tests/xfs/715 b/tests/xfs/715
new file mode 100755
index 0000000000..eca979b297
--- /dev/null
+++ b/tests/xfs/715
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 715
+#
+# Race fsstress and quotacheck repair for a while to see if we crash or
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
+_require_xfs_quota_acct_enabled "$SCRATCH_DEV" any
+_scratch_xfs_stress_online_repair -s "repair quotacheck"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/715.out b/tests/xfs/715.out
new file mode 100644
index 0000000000..b5947d898b
--- /dev/null
+++ b/tests/xfs/715.out
@@ -0,0 +1,2 @@
+QA output created by 715
+Silence is golden
diff --git a/tests/xfs/812 b/tests/xfs/812
new file mode 100755
index 0000000000..f84494e392
--- /dev/null
+++ b/tests/xfs/812
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 812
+#
+# Race fsstress and quotacheck scrub for a while to see if we crash or
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_quota_acct_enabled "$SCRATCH_DEV" any
+_scratch_xfs_stress_scrub -s "scrub quotacheck"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/812.out b/tests/xfs/812.out
new file mode 100644
index 0000000000..d8dbb15dc7
--- /dev/null
+++ b/tests/xfs/812.out
@@ -0,0 +1,2 @@
+QA output created by 812
+Silence is golden

