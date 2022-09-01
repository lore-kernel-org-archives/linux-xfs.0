Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BA7C54EE9
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Sep 2022 14:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiIAOfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 10:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbiIAOfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 10:35:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D3D1A825;
        Thu,  1 Sep 2022 07:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0060E61D44;
        Thu,  1 Sep 2022 14:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CB4C433D6;
        Thu,  1 Sep 2022 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662042903;
        bh=UVUZa3kUR0wSInbe83acw9bVhEeigAl/rf7NUa/DVSg=;
        h=From:To:Cc:Subject:Date:From;
        b=KwyWUQni4ybEi8ppdLhQmRhHiX299h7YjqaGrmide7cosSAluozyVsdqLd/39Pmi+
         sK+YsrW2YVZTPoqZExOGJCjOL4Iqkl477gh4LCvu6jq873d8mAw1YQRoHtxKw1xUv0
         n59Ku/aMXTZW9gcnem1Yi1nE/rASMQLeNEIDZFvFn8c9e+Ah1MEP6c1FWiHsWdKEur
         5NP2v31SnKKpRhrAvu8LDDkgZyOrMGG9HrCHL5+QntKY8bpDZGGC9e7efgKGuybWct
         zFaIRmCs38iyzdxiqQlPVYmfBxFWm0c3uhYU4aNPyx3OQfMeyJVatNOi/ZCjUW3BGT
         8ERrPNgAG4t7A==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] generic: new test to verify selinux label of whiteout inode
Date:   Thu,  1 Sep 2022 22:34:59 +0800
Message-Id: <20220901143459.3883118-1-zlang@kernel.org>
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

V1 -> V2:
1) Add "whiteout" group
2) Add commit ID which fix that bug
3) Rebase to latest fstests for-next branch

V2 -> V3:
Rebase to latest fstests for-next branch again

Thanks,
Zorro

 tests/generic/695     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/695.out |  2 ++
 2 files changed, 66 insertions(+)
 create mode 100755 tests/generic/695
 create mode 100644 tests/generic/695.out

diff --git a/tests/generic/695 b/tests/generic/695
new file mode 100755
index 00000000..f04d4b3d
--- /dev/null
+++ b/tests/generic/695
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Copyright.  All Rights Reserved.
+#
+# FS QA Test No. 695
+#
+# Verify selinux label can be kept after RENAME_WHITEOUT. This is
+# a regression test for:
+#   70b589a37e1a ("xfs: add selinux labels to whiteout inodes")
+#
+. ./common/preamble
+_begin_fstest auto quick rename attr whiteout
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
+_fixed_by_kernel_commit 70b589a37e1a \
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
diff --git a/tests/generic/695.out b/tests/generic/695.out
new file mode 100644
index 00000000..1332ff16
--- /dev/null
+++ b/tests/generic/695.out
@@ -0,0 +1,2 @@
+QA output created by 695
+Silence is golden
-- 
2.31.1

