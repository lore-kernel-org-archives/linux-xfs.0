Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800CEC38145
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 01:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiIBBua (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 21:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiIBBuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 21:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B8F58DC2;
        Thu,  1 Sep 2022 18:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1674E60B4A;
        Fri,  2 Sep 2022 01:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDA2C433C1;
        Fri,  2 Sep 2022 01:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662083421;
        bh=0cJ5XTNhRbIkFCUvRdV2q5WFK49PHrWEHO6qKh9yox8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjtRS8onQMjZIzJJqwh5UjZelEUfh44y35Vg44GujkgE9bUuErLXx1sx3YPlQHKFi
         UUZNrzLjGgAyNElWOsaTZ+/5Zorw1THNMiz5aCqRmt4kdaW/b1//JmFBwvz1zBNour
         RgLKWQZhiRFKJtugzu+L/0qfr6iAbVmhOKNA6zbkAber8B1lxNotVuH2RW661KvxaV
         L7stL8DC25+pXwCiCJF1JVyeiiYgV+0zEJwWq5neSTHz+hs+QbCzY+999BmpJUmmaf
         xayx5gg4tyP1cQdrCckVTi/sgJlru6hib2IwOnePXo14Im9Vm9sy1U/WyKmRTuWwK5
         QFzEr3ImU3S6Q==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v4] generic: new test to verify selinux label of whiteout inode
Date:   Fri,  2 Sep 2022 09:50:18 +0800
Message-Id: <20220902015018.4036984-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <CADJHv_vX+7tONjguTw8ZgyV9uE=OW=RtZQ_FdF2-ViGaxQbzYw@mail.gmail.com>
References: <CADJHv_vX+7tONjguTw8ZgyV9uE=OW=RtZQ_FdF2-ViGaxQbzYw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A bug on XFS cause renameat2() with flags=RENAME_WHITEOUT doesn't
apply an selinux label. That's quite different with other fs (e.g.
ext4, tmpfs).

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

V3 -> V4:
1) Fix a typo
2) replace `` with $()

V2 -> V3:
Rebase to latest fstests for-next branch again

V1 -> V2:
1) Add "whiteout" group
2) Add commit ID which fix that bug
3) Rebase to latest fstests for-next branch

Thanks,
Zorro


 tests/generic/695     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/695.out |  2 ++
 2 files changed, 66 insertions(+)
 create mode 100755 tests/generic/695
 create mode 100644 tests/generic/695.out

diff --git a/tests/generic/695 b/tests/generic/695
new file mode 100755
index 00000000..3f65020a
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
+	label=$(_getfattr --absolute-names -n security.selinux $@ | sed -n 's/security.selinux=\"\(.*\)\"/\1/p')
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
+label1=$(get_selinux_label $SCRATCH_MNT/f1)
+label2=$(get_selinux_label $SCRATCH_MNT/f2)
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

