Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCBEC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 14:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiGNO4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jul 2022 10:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiGNO4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jul 2022 10:56:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A5B5A44D;
        Thu, 14 Jul 2022 07:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40C9261A07;
        Thu, 14 Jul 2022 14:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C72C34115;
        Thu, 14 Jul 2022 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657810596;
        bh=cXu6RrmM6SOIDB9bE5H1LrBbEbluE8g3lUi77zviQ0M=;
        h=From:To:Cc:Subject:Date:From;
        b=kQ+AZ5Qj6kUTH84K4ddCRcTn2YnwHZNLXhpc/I8ShyyIBd+oIxqkri7+/UX7naU/Z
         WBUtAAHDuBbViiY2+w+rl6hA+UEICOiurQoWnI/BDjKRcvW44QPwCRNacik1+H4A2d
         WKVzOJMN9b3fncr7BUCWjze0DtOGVkrfexcmDICZRUkmJbt2iVlzi22gLjdTsXj43f
         m+rDg5BlJhMDZrxNFCCsG6qYU17UOGhWwgANDlBaB4K+CT0gIax0Row1hfzZUhQz56
         fJEl25IQyWZzS43IFYHLajXE7xueLknQiTfppZLAl6TxIitX3Q9gGdYFyB3AYWURUB
         Mn5PKq9B1W9rA==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: [PATCH] generic: new test to verify selinux label of whiteout inode
Date:   Thu, 14 Jul 2022 22:56:32 +0800
Message-Id: <20220714145632.998355-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A but on XFS cause renameat2() with flags=RENAME_WHITEOUT doesn't
apply an selinux label. That's quite different with other fs (e.g.
ext4, tmpfs).

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Hi,

A test case for:
https://lore.kernel.org/linux-xfs/1655775516-8936-1-git-send-email-sandeen@redhat.com/

The patch has been reviewed, but not merged, so there's not commit ID, just send
this patch out to get review at first.

Thanks,
Zorro

 tests/generic/692     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/692.out |  2 ++
 2 files changed, 66 insertions(+)
 create mode 100755 tests/generic/692
 create mode 100644 tests/generic/692.out

diff --git a/tests/generic/692 b/tests/generic/692
new file mode 100755
index 00000000..ccf2213d
--- /dev/null
+++ b/tests/generic/692
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Copyright.  All Rights Reserved.
+#
+# FS QA Test 692
+#
+# Verify selinux label can be kept after RENAME_WHITEOUT. This is
+# a regression test for:
+#   XXXXXXXXXXXX ("xfs: add selinux labels to whiteout inodes")
+#
+. ./common/preamble
+_begin_fstest auto quick rename attr
+
+# Import common functions.
+. ./common/attr
+. ./common/renameat2
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+_require_attrs
+_require_renameat2 whiteout
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	xfs: add selinux labels to whiteout inodes
+
+get_selinux_label()
+{
+	local label
+
+	label=`_getfattr --absolute-names -n security.selinux $@ | sed -n 's/security.selinux=\"\(.*\)\"/\1/p'`
+	if [ ${PIPESTATUS[0]} -ne 0 -o -z "$label" ];then
+		_fail "Fail to get selinux label: $label"
+	fi
+	echo $label
+}
+
+_scratch_mkfs >> $seqres.full 2>&1
+# SELINUX_MOUNT_OPTIONS will be set in common/config if selinux is enabled
+if [ -z "$SELINUX_MOUNT_OPTIONS" ]; then
+	_notrun "Require selinux to be enabled"
+fi
+# This test need to verify selinux labels in objects, so unset this selinux
+# mount option
+export SELINUX_MOUNT_OPTIONS=""
+_scratch_mount
+
+touch $SCRATCH_MNT/f1
+echo "Before RENAME_WHITEOUT" >> $seqres.full
+ls -lZ $SCRATCH_MNT >> $seqres.full 2>&1
+# Expect f1 and f2 have same label after RENAME_WHITEOUT
+$here/src/renameat2 -w $SCRATCH_MNT/f1 $SCRATCH_MNT/f2
+echo "After RENAME_WHITEOUT" >> $seqres.full
+ls -lZ $SCRATCH_MNT >> $seqres.full 2>&1
+label1=`get_selinux_label $SCRATCH_MNT/f1`
+label2=`get_selinux_label $SCRATCH_MNT/f2`
+if [ "$label1" != "$label2" ];then
+	echo "$label1 != $label2"
+fi
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/692.out b/tests/generic/692.out
new file mode 100644
index 00000000..d7521a9f
--- /dev/null
+++ b/tests/generic/692.out
@@ -0,0 +1,2 @@
+QA output created by 692
+Silence is golden
-- 
2.31.1

