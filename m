Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8061C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 03:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353461AbiCPDbu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351275AbiCPDbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 23:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7C15EDD6;
        Tue, 15 Mar 2022 20:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDA4C61716;
        Wed, 16 Mar 2022 03:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CECC340ED;
        Wed, 16 Mar 2022 03:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401435;
        bh=aeUFknBcWBelMSTUFf2w3tHyo65gOicRWbiyY82fQJ8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s8TfA/WcmChY2KOvGiAPrCw0rVu6yRk7nZ3GEwl5M/52dcRCViTQ7GTxQmLEVDm+q
         Tgj2j6+ClVaNK9ag4NWx7yd29kP/hGYlCyNKQhLzKReLHCpISBi8yJPoNsDbDcXXm6
         Zntcz0Qxs+wxuj/VoSpwB8ZDARA1byX7fEYurihy4jB6XLB3KOJiokWw93Owp2O/qd
         w8QMpfIGEDSTuXP/DgDNgFARhxpUaTIWV86m5B/5DJ7P6pqoUtEs+8wY45oo7kABZg
         hcR7Lthej9f7VOPFbPVEToQyDVrohxyjGoDFSWtvxPMw5BXOSbT0SdQIIy6c27SctE
         WoWuaff4xdBCg==
Subject: [PATCH 1/2] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 15 Mar 2022 20:30:35 -0700
Message-ID: <164740143497.3371809.2959237196772812909.stgit@magnolia>
In-Reply-To: <164740142940.3371809.12686819717405148022.stgit@magnolia>
References: <164740142940.3371809.12686819717405148022.stgit@magnolia>
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

