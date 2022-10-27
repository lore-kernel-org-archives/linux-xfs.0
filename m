Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91110FA3741
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 16:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiJ0QnD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 12:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiJ0QnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 12:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FB261B15;
        Thu, 27 Oct 2022 09:43:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E09B1B82641;
        Thu, 27 Oct 2022 16:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E99C433D6;
        Thu, 27 Oct 2022 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666888978;
        bh=9vZqkGOBFyUKJHV/68HLUKRWHqauBdknAJoXY6kgl48=;
        h=From:To:Cc:Subject:Date:From;
        b=QkOYvLMx5y02j8M5mJJ02wSIjPGTwW4BB11A9rzOkg1a5hfwAoQN1sD2KgoNU+txa
         5ZL78biMh/3XLlPkRwTXxsHJpAO3yoTIncDFWaKBJlTKTzPMPiP6fIFhH3MdmqmjHX
         spz/uNlRAzDRF+pW/v/EOyoukcsrTAs4LFcDtQK9rPSnz4rpED3R9nb66BDMdMk7jf
         BMeNSRaUyreRFrwyyoAPy67eGp+ai6pX7omjgFAtrIlYwJonG/XbfQidhIo9dle5QD
         O26t/GljUYYCYnsuhv57e5BDqRw84ZRjOc1wmUM4rkbw3c5gFqbi1mYVT6af1kgqnK
         h68sBkZxNGTwQ==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: new test on xfs with corrupted sb_inopblock
Date:   Fri, 28 Oct 2022 00:42:54 +0800
Message-Id: <20221027164254.1472306-1-zlang@kernel.org>
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
 tests/xfs/555     | 27 +++++++++++++++++++++++++++
 tests/xfs/555.out |  4 ++++
 2 files changed, 31 insertions(+)
 create mode 100755 tests/xfs/555
 create mode 100644 tests/xfs/555.out

diff --git a/tests/xfs/555 b/tests/xfs/555
new file mode 100755
index 00000000..7f46a9af
--- /dev/null
+++ b/tests/xfs/555
@@ -0,0 +1,27 @@
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
+_require_scratch_nocheck
+
+_scratch_mkfs >>$seqres.full
+
+echo "corrupt inopblock of sb 0"
+_scratch_xfs_set_metadata_field "inopblock" "500" "sb 0" >> $seqres.full
+echo "try to mount ..."
+_try_scratch_mount 2>> $seqres.full && _fail "mount should not succeed"
+
+echo "no crash or hang"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/555.out b/tests/xfs/555.out
new file mode 100644
index 00000000..36c3446e
--- /dev/null
+++ b/tests/xfs/555.out
@@ -0,0 +1,4 @@
+QA output created by 555
+corrupt inopblock of sb 0
+try to mount ...
+no crash or hang
-- 
2.31.1

