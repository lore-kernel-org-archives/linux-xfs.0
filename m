Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191AAFA3742
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 15:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJ1Pnn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJ1Pnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 11:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9131D1CFF12;
        Fri, 28 Oct 2022 08:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36BED62911;
        Fri, 28 Oct 2022 15:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3F8C433D6;
        Fri, 28 Oct 2022 15:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666971820;
        bh=fO1n2lDN7W2o/GCIoMtSS2SNcdeghXYUPoFe6p2Qcnw=;
        h=From:To:Cc:Subject:Date:From;
        b=R68esQitMsxMsR2rrndWaNVis/3wP9X0WSJfBZPfS35Pu7YYUgtbjO1wxUhSzRUS4
         /GZXMfnGAQej4z9FaqsyOj57nhEcKfQnqcYBUev/fbRaAS+eOpQ1KCyAJ1IN/SWfY7
         2jl49ffMshxhE/K17qjH6lfJalUmPTNgdOdbwH3tyjGU6gtXYH5M3s+wWyWwfhIVT5
         LHW/Xv5ZW//x7zjGd9IK0Mfz442Q6viFTzioLg9Nv81WBqulBoWJhhxmfiJdq2BjRt
         TaVSZxYrgVBgXyGkeiWP4wEtcTkW81m2C3fNaEpZiflvQ4it3+tJ5fg/ST4MH729jp
         7g3fOTNNAKauQ==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: new test on xfs with corrupted sb_inopblock
Date:   Fri, 28 Oct 2022 23:43:37 +0800
Message-Id: <20221028154337.1788413-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There's a known bug fix 392c6de98af1 ("xfs: sanitize sb_inopblock in
xfs_mount_validate_sb"). So try to corrupt the sb_inopblock of xfs,
to cover this bug.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

V2 does below changes:
1) Add _fixed_by_kernel_commit ...
2) Repair and check the xfs at the test end

Thanks,
Zorro

 tests/xfs/555     | 32 ++++++++++++++++++++++++++++++++
 tests/xfs/555.out |  6 ++++++
 2 files changed, 38 insertions(+)
 create mode 100755 tests/xfs/555
 create mode 100644 tests/xfs/555.out

diff --git a/tests/xfs/555 b/tests/xfs/555
new file mode 100755
index 00000000..a4024501
--- /dev/null
+++ b/tests/xfs/555
@@ -0,0 +1,32 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 555
+#
+# Corrupt xfs sb_inopblock, make sure no crash. This's a test coverage of
+# 392c6de98af1 ("xfs: sanitize sb_inopblock in xfs_mount_validate_sb")
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+# real QA test starts here
+_supported_fs xfs
+_fixed_by_kernel_commit 392c6de98af1 \
+	"xfs: sanitize sb_inopblock in xfs_mount_validate_sb"
+_require_scratch
+
+_scratch_mkfs >>$seqres.full
+echo "corrupt inopblock of sb 0"
+_scratch_xfs_set_metadata_field "inopblock" "500" "sb 0" >> $seqres.full
+echo "try to mount ..."
+_try_scratch_mount 2>> $seqres.full && _fail "mount should not succeed!"
+echo "no crash or hang"
+echo "repair corrupted sb 0"
+_scratch_xfs_repair >> $seqres.full 2>&1
+echo "check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || echo "fs isn't fixed!"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/555.out b/tests/xfs/555.out
new file mode 100644
index 00000000..4f1b01a2
--- /dev/null
+++ b/tests/xfs/555.out
@@ -0,0 +1,6 @@
+QA output created by 555
+corrupt inopblock of sb 0
+try to mount ...
+no crash or hang
+repair corrupted sb 0
+check fs
-- 
2.31.1

