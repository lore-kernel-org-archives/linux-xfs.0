Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D53C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiLaDNf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:13:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C97DE59;
        Fri, 30 Dec 2022 19:13:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76543CE1A8E;
        Sat, 31 Dec 2022 03:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37DFC433EF;
        Sat, 31 Dec 2022 03:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456401;
        bh=9otW2tY5YJ64W7OHZ0lFKHYt+JIqExoagm6LZarf58s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gy4UURmXUtEJBAITMkIoryT9ccrtsnxoIoeqGGfaHuIm1pF0WbACz+1Iw6wPGpsVg
         C/NbK6UqgmNTzRtuis0UgSCxyHt6jzcnOd/xPlBA/3CPwhUtO1UTDG9MoGGJ3cbKYU
         OJB5lpB76shskErL65ug2JNVpqF99tCA6eJBi8Ofv132mdFLcP+MkhHmo0GLbKTY3C
         KfyR9TgCJHoA9n40VIl+a25M4vY53LHalPFmb87yydBrrBn8mQ60rQOppKTj+sBar6
         C6iz5y7PKiiAfwlBj+XctNM2T2YEHdCpvVv9+5E/8ZM+D1SsnSWyZNAk99/8hCAwPN
         DeBZvQUCcRdqA==
Subject: [PATCH 03/13] xfs: race fsstress with realtime rmap btree scrub and
 repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884434.739669.12054091532223880164.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Race checking and rebuilding realtime rmap btrees with fsstress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/781     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/781.out |    2 ++
 tests/xfs/817     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/817.out |    2 ++
 tests/xfs/821     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/821.out |    2 ++
 6 files changed, 132 insertions(+)
 create mode 100755 tests/xfs/781
 create mode 100644 tests/xfs/781.out
 create mode 100755 tests/xfs/817
 create mode 100644 tests/xfs/817.out
 create mode 100755 tests/xfs/821
 create mode 100644 tests/xfs/821.out


diff --git a/tests/xfs/781 b/tests/xfs/781
new file mode 100755
index 0000000000..938777952f
--- /dev/null
+++ b/tests/xfs/781
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 781
+#
+# Race fsstress and rtrmapbt repair for a while to see if we crash or livelock.
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
+_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_online_repair -s "repair rtrmapbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/781.out b/tests/xfs/781.out
new file mode 100644
index 0000000000..e7f74cf644
--- /dev/null
+++ b/tests/xfs/781.out
@@ -0,0 +1,2 @@
+QA output created by 781
+Silence is golden
diff --git a/tests/xfs/817 b/tests/xfs/817
new file mode 100755
index 0000000000..88d0a18e8d
--- /dev/null
+++ b/tests/xfs/817
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 817
+#
+# Race fsstress and rtrmapbt scrub for a while to see if we crash or livelock.
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
+_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_scrub -s "scrub rtrmapbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/817.out b/tests/xfs/817.out
new file mode 100644
index 0000000000..86920a4fc6
--- /dev/null
+++ b/tests/xfs/817.out
@@ -0,0 +1,2 @@
+QA output created by 817
+Silence is golden
diff --git a/tests/xfs/821 b/tests/xfs/821
new file mode 100755
index 0000000000..45b999e3b5
--- /dev/null
+++ b/tests/xfs/821
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 821
+#
+# Race fsstress and realtime bitmap repair for a while to see if we crash or
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
+_scratch_xfs_stress_online_repair -s "repair rtbitmap" -s "repair rgbitmap %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/821.out b/tests/xfs/821.out
new file mode 100644
index 0000000000..17994b8627
--- /dev/null
+++ b/tests/xfs/821.out
@@ -0,0 +1,2 @@
+QA output created by 821
+Silence is golden

