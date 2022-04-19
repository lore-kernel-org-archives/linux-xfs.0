Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C696CC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 17:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354517AbiDSRfB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 13:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354030AbiDSRfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:35:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDDA36E26;
        Tue, 19 Apr 2022 10:32:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CC63B818ED;
        Tue, 19 Apr 2022 17:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAA8C385A7;
        Tue, 19 Apr 2022 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650389535;
        bh=XX1NfusDbCV/pcaxIRPEu+GFASsAls9CoG04VaWXnFw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EW9AopzXse/UF8it8Hib/jC0S6TQR3glqT12eMepe2YFkK9k9v1e2F1KSeK6cNkT0
         T4CQNN/KaRjQ1MKukb9H4ZvXpILHY2nwEl5Tda54Fh03boV+dF/8Uu9BWh1whnyYxu
         1ep3KL2UtG+Tb5rD8aMy+NZ/aqZPcy4uIAjzZ3wqFPS/DlryerSFVcCHnBfaCQ1cff
         jlfGZFX3VxfZADIZEVp8StqQFMg9GDxP/GAO4dRbSBfMQ4CeGHJQaNooFGyLMhPDxv
         mhJ1/NkEgin2iE5FPQw2nnKOy2M9OhotWNfaeeaUu1imfQIweUqDnlr0VlOrXSi6Dn
         KDSLVwG9THlNg==
Subject: [PATCH 1/2] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Date:   Tue, 19 Apr 2022 10:32:15 -0700
Message-ID: <165038953550.1677711.12931148474635467556.stgit@magnolia>
In-Reply-To: <165038952992.1677711.6313258860719066297.stgit@magnolia>
References: <165038952992.1677711.6313258860719066297.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test to make sure that nonzero error returns from
a filesystem's ->sync_fs implementation are actually passed back to
userspace when the call stack involves syncfs(2).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@redhat.com>
---
 tests/xfs/839     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/839.out |    2 ++
 2 files changed, 44 insertions(+)
 create mode 100755 tests/xfs/839
 create mode 100644 tests/xfs/839.out


diff --git a/tests/xfs/839 b/tests/xfs/839
new file mode 100755
index 00000000..9bfe93ef
--- /dev/null
+++ b/tests/xfs/839
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 839
+#
+# Regression test for kernel commits:
+#
+# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
+# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
+#
+# During a code inspection, I noticed that sync_filesystem ignores the return
+# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
+# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
+# that syncfs(2) does not capture internal filesystem errors that are neither
+# visible from the block device (e.g. media error) nor recorded in s_wb_err.
+# XFS historically returned 0 from ->sync_fs even if there were log failures,
+# so that had to be corrected as well.
+#
+# The kernel commits above fix this problem, so this test tries to trigger the
+# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
+# hope that the EIO generated as a result of the filesystem being shut down is
+# only visible via ->sync_fs.
+#
+. ./common/preamble
+_begin_fstest auto quick shutdown
+
+# real QA test starts here
+
+# Modify as appropriate.
+_require_xfs_io_command syncfs
+_require_scratch_nocheck
+_require_scratch_shutdown
+
+# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
+# bother checking the filesystem afterwards since we never wrote anything.
+_scratch_mount
+$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/839.out b/tests/xfs/839.out
new file mode 100644
index 00000000..f275cdcc
--- /dev/null
+++ b/tests/xfs/839.out
@@ -0,0 +1,2 @@
+QA output created by 839
+syncfs: Input/output error

