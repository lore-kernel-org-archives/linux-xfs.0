Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D78C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbiLaAn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiLaAnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:43:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42661E3EE;
        Fri, 30 Dec 2022 16:43:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B69FB81E64;
        Sat, 31 Dec 2022 00:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3889AC433EF;
        Sat, 31 Dec 2022 00:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447401;
        bh=Xx5mVyLBQLbrjlHGIEqWBKDAGQrvCI0Dw5woSU0IbzE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZwhCPIVr95wbt6tTVZA7kUFzAsBNMGif1HE5W7XiSNW8fCWpemletLz4KKPNGOnt3
         n28XWBuPiKui4GN5GcAIZVvXzk4ipSKnkeHTTwU+LhXThrHLZYuMci9Z0aCm5Wzj/h
         ExLjRGkvA5HD3mkzfzV8AJz+XZpE97oBGZR+uIfQWaWy3RRSwxyuJBrBFb1ij2LOzw
         J6hY7wvOzQXbi006l+1Q8T4BU4c6Z7Yv48hLGumzHbxhpaRdSHBWF5XYJRyjb+bX53
         JL0y4+B/yj3cfX4WFsxRBSSQK1NIfGhzXpgdOGLGmNZYXst3UcnwBDugJY6OiGfWoE
         YpwLg1tAczNPQ==
Subject: [PATCH 2/2] xfs: race fsstress with online repair for summary
 counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:30 -0800
Message-ID: <167243877066.727863.17049913756292072572.stgit@magnolia>
In-Reply-To: <167243877039.727863.13765266441029212988.stgit@magnolia>
References: <167243877039.727863.13765266441029212988.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create tests to race fsstress with fs summary counter repair while
running fsstress in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/714     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/714.out |    2 ++
 tests/xfs/762     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/762.out |    2 ++
 4 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/714
 create mode 100644 tests/xfs/714.out
 create mode 100755 tests/xfs/762
 create mode 100644 tests/xfs/762.out


diff --git a/tests/xfs/714 b/tests/xfs/714
new file mode 100755
index 0000000000..c1b6cd919a
--- /dev/null
+++ b/tests/xfs/714
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 714
+#
+# Race fsstress and fscounter repair for a while to see if we crash or livelock.
+# Summary counter repair requires us to freeze the filesystem to stop all
+# filesystem activity, so we can't have userspace wandering in and thawing it.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+# Override the default cleanup function.
+_cleanup()
+{
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -rf $tmp.*
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
+_scratch_xfs_stress_online_repair -s "repair fscounters"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/714.out b/tests/xfs/714.out
new file mode 100644
index 0000000000..f5ce748b71
--- /dev/null
+++ b/tests/xfs/714.out
@@ -0,0 +1,2 @@
+QA output created by 714
+Silence is golden
diff --git a/tests/xfs/762 b/tests/xfs/762
new file mode 100755
index 0000000000..0f70b632a3
--- /dev/null
+++ b/tests/xfs/762
@@ -0,0 +1,46 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 762
+#
+# Race fsstress and fscounter repair on the realtime device for a while to see
+# if we crash or livelock.  Summary counter repair requires us to freeze the
+# filesystem to stop all filesystem activity, so we can't have userspace
+# wandering in and thawing it.
+#
+. ./common/preamble
+_begin_fstest auto quick rw scrub realtime
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
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
+_require_realtime
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+
+# Force all files to be allocated on the realtime device
+_xfs_force_bdev realtime $SCRATCH_MNT
+_scratch_xfs_stress_online_repair -s 'scrub fscounters' -s "repair fscounters"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/762.out b/tests/xfs/762.out
new file mode 100644
index 0000000000..fbaeb29706
--- /dev/null
+++ b/tests/xfs/762.out
@@ -0,0 +1,2 @@
+QA output created by 762
+Silence is golden

