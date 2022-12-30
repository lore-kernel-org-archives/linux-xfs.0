Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED06C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiLaAxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAxp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:53:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DB813F29;
        Fri, 30 Dec 2022 16:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914E461D47;
        Sat, 31 Dec 2022 00:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14F1C433D2;
        Sat, 31 Dec 2022 00:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448024;
        bh=TdfAfb7GW40/sE8S+wGYtWPmR6jcqncVM9qAKz84ftc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kysAYZZ3gEjT37cC7KHjs+7YoipvDg4USw1qfxNfpcp4q+Qrr358LdGMxdRcEiGSc
         R6bCoJULfMGy855xaE4mZr9CdJpB90j/MjpXKYi0QGRA02R8BjW/urJV71C/XgfeUL
         8W9ytHsAhmma36k0J1RmD5DigKVQz1XfvYb5g0B8G8JZxtUnb21zHapzO/BjsWteQR
         JjaOX4Hk9ssjL3b4jYeMvXHUZNlder/ndq8zNnivhYF1i5tYFZ0jVf1m1UX3DFU8l8
         vvSuPYgdyLHlC+90Y+JlngDa0rDt3PuKBjuzXnuhOrjHEQJLxH2hcPVabKUSN7TwKX
         49cb42fPlxDsw==
Subject: [PATCH 1/1] xfs: race fsstress with online repair of realtime summary
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:52 -0800
Message-ID: <167243879205.732554.15899325554709079259.stgit@magnolia>
In-Reply-To: <167243879193.732554.7976867017693507837.stgit@magnolia>
References: <167243879193.732554.7976867017693507837.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create tests to race fsstress with rt summary file repair while running
fsstress in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/813     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/813.out |    2 ++
 2 files changed, 50 insertions(+)
 create mode 100755 tests/xfs/813
 create mode 100644 tests/xfs/813.out


diff --git a/tests/xfs/813 b/tests/xfs/813
new file mode 100755
index 0000000000..5efe923c75
--- /dev/null
+++ b/tests/xfs/813
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 813
+#
+# Race fsstress and realtime summary repair for a while to see if we crash or
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
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+# XXX the realtime summary scrubber isn't currently implemented upstream.
+# Don't bother trying to fix it on those kernels
+$XFS_IO_PROG -c 'scrub rtsummary' -c 'scrub rtsummary' "$SCRATCH_MNT" 2>&1 | \
+	grep -q 'Scan was not complete' && \
+	_notrun "rtsummary scrub is incomplete"
+
+_scratch_xfs_stress_online_repair -s "repair rtsummary"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/813.out b/tests/xfs/813.out
new file mode 100644
index 0000000000..f0c2a12bea
--- /dev/null
+++ b/tests/xfs/813.out
@@ -0,0 +1,2 @@
+QA output created by 813
+Silence is golden

