Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCD1C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jul 2022 06:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGYGNe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jul 2022 02:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGYGNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 02:13:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B409BC8F;
        Sun, 24 Jul 2022 23:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F75460FF9;
        Mon, 25 Jul 2022 06:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33112C341C6;
        Mon, 25 Jul 2022 06:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658729611;
        bh=TWD+f5K8dbn0rosMxpTVoH3YMU0H20P2+B4CJogiJtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mag6VyjOUR3PxkfHL+K6pkqO04cDBmc/JfUz0HxHNMUMVrocF/mHCnNbbmc9D5oAU
         gCa1PRE68eMF/3/2D8PMWgD3fTzNKRSD8Q1LTwTyFclBHjNgg04GAVgZNVKA38SzSH
         stn1BYLaXH5OeDgA1ZnoA0nsrm7+3jk3VbPEIfuw+nigXmGPb5yXblhG7Lt1ut1K6e
         sPAEZMlo8QisVb3h1oWwHfpd8u5rG6R9jDJi1DyNfoa/spefsPTLcJ3X2SR9OwMwH7
         edikreiRs2lMU2oKvx/lFm96npTJbyeHxaEkVHye3QnXYqQ1cjSvrqA9hxZyNON4iw
         Lcv7NnzFvr/Fg==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     amir73il@gmail.com, sandeen@redhat.com, linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic: new test to verify selinux label of whiteout inode
Date:   Mon, 25 Jul 2022 14:13:27 +0800
Message-Id: <20220725061327.266746-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220714145632.998355-1-zlang@kernel.org>
References: <20220714145632.998355-1-zlang@kernel.org>
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

Thanks the review points from Amir, this v2 did below changes:
1) Add "whiteout" group
2) Add commit ID from xfs-linux xfs-5.20-merge-2 (will change if need)
3) Rebase to latest fstests for-next branch

Thanks,
Zorro

 tests/generic/693     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/693.out |  2 ++
 2 files changed, 66 insertions(+)
 create mode 100755 tests/generic/693
 create mode 100644 tests/generic/693.out

diff --git a/tests/generic/693 b/tests/generic/693
new file mode 100755
index 00000000..adf191c4
--- /dev/null
+++ b/tests/generic/693
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Copyright.  All Rights Reserved.
+#
+# FS QA Test No. 693
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
diff --git a/tests/generic/693.out b/tests/generic/693.out
new file mode 100644
index 00000000..01884ea5
--- /dev/null
+++ b/tests/generic/693.out
@@ -0,0 +1,2 @@
+QA output created by 693
+Silence is golden
-- 
2.31.1

