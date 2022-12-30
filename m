Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F3AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbiLaAlH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiLaAlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:41:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF6D1D0C8;
        Fri, 30 Dec 2022 16:41:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE0E061D50;
        Sat, 31 Dec 2022 00:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A86C433D2;
        Sat, 31 Dec 2022 00:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447261;
        bh=tyouE0/BiPchaXN6mjhC/xGdlxUJ0OI8Ato1gc3+B4A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g3M7gRpyEwbsq9WIU/0kcOW9JgTsSmCFktsQQwh0CW5pOB/CJYn+YjehL/qzt7jI5
         PRCxeALQcpDQPLwrSj7wuQ8UN9ayYNszb7n5H1HKwJGOInpFTb19LVvxNvwCwIu/Ie
         1UzdUTPSHF8MjJ9sTuE2v0HmzX9Qc+rV5J+a16TZ6QsTMy9iiFlsu248kEfiN/yd61
         jObW5f52pqtiWQOyA1AjCM3Dg/7jIc54ja6hz1dTjkqqqyzkQdsKcBmDi6n0xZekAD
         cmf209TdfYLkCG7Uti36KFUOLkV29YRXuBR97VrBgJy0Rmg+Sulpn/4PIwKd8UwA/P
         FzsOGhi9XvV0g==
Subject: [PATCH 1/1] xfs: race fsstress with online repair for inode record
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875550.724875.35173902093167169.stgit@magnolia>
In-Reply-To: <167243875538.724875.4064833218427202716.stgit@magnolia>
References: <167243875538.724875.4064833218427202716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a test that runs the inode record repairer in the foreground and
fsstress in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/806     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/806.out |    2 ++
 2 files changed, 40 insertions(+)
 create mode 100755 tests/xfs/806
 create mode 100644 tests/xfs/806.out


diff --git a/tests/xfs/806 b/tests/xfs/806
new file mode 100755
index 0000000000..e07f9f9141
--- /dev/null
+++ b/tests/xfs/806
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 806
+#
+# Race fsstress and inode record repair for a while to see if we crash or
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
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -s "repair inode" -t "%file%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/806.out b/tests/xfs/806.out
new file mode 100644
index 0000000000..463bd7f008
--- /dev/null
+++ b/tests/xfs/806.out
@@ -0,0 +1,2 @@
+QA output created by 806
+Silence is golden

