Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2404AC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 08:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbiFCIZI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 04:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiFCIZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 04:25:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C4B1C12E;
        Fri,  3 Jun 2022 01:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F5DB82234;
        Fri,  3 Jun 2022 08:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE52C34114;
        Fri,  3 Jun 2022 08:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654244701;
        bh=KYJyqbiy4NSg0fidZ6aYjs/VPfyn0QQrpQcVL+FaLIc=;
        h=From:To:Cc:Subject:Date:From;
        b=pOQCw87nCfW2dLzcbrH04jBMq5b2JaMNk4FgCBESCEkGf5GztESYmmymIKkNwKcyO
         S0W2knHNuDVyeEwgiV/weD9956tfpVVf22gjhxRYy3zMNRr4uWretSiMYeSqAPzu5h
         G0n3FOlh9U0xJ0wq6S7gPDmEsncP64oCg/X/L5Zb8n/rLcKaYmiKW2V5MoK3tL+sI2
         Xp+1cgj/57LhNuJL1MEbJsc5c4l9qtmgVPDD4X3enXpjQzbbgfJmP6Y/0Ka8vCm7q1
         VjKTIkKpJuncwpdHmwEHfpTHHDLKfmyF3bkldOdtlXFrqt8TJjObuEsFP43lARkCMp
         71kkWpWTNVvgw==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org
Subject: [PATCH v2] xfs: corrupted xattr should not block removexattr
Date:   Fri,  3 Jun 2022 16:24:57 +0800
Message-Id: <20220603082457.2449343-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After we corrupted an attr leaf block (under node block), getxattr
might hit EFSCORRUPTED in xfs_attr_node_get when it does
xfs_attr_node_hasname. A known bug cause xfs_attr_node_get won't do
xfs_buf_trans release job, then a subsequent removexattr will hang.

This case covers a1de97fe296c ("xfs: Fix the free logic of state in
xfs_attr_node_hasname")

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Thanks the review from Darrick, V2 add/remove some comments, and give
more information to that _fail line. There might be still some disputed
places, likes the _try_scratch_mount fail return and the way to create
and get/remove xattrs. Please Feel free to tell me if you feel something
isn't good enough.

Thanks,
Zorro

 tests/xfs/999     | 80 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 2 files changed, 82 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..73577577
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# This's a regression test for:
+#   a1de97fe296c ("xfs: Fix the free logic of state in xfs_attr_node_hasname")
+#
+# After we corrupted an attr leaf block (under node block), getxattr might hit
+# EFSCORRUPTED in xfs_attr_node_get when it does xfs_attr_node_hasname. A bug
+# cause xfs_attr_node_get won't do xfs_buf_trans release job, then a subsequent
+# removexattr will hang.
+#
+. ./common/preamble
+_begin_fstest auto quick attr
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_fixed_by_kernel_commit a1de97fe296c \
+       "xfs: Fix the free logic of state in xfs_attr_node_hasname"
+
+_require_scratch_nocheck
+# Only test with v5 xfs on-disk format
+_require_scratch_xfs_crc
+_require_attrs
+_require_populate_commands
+_require_xfs_db_blocktrash_z_command
+
+_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+source $tmp.mkfs
+_scratch_mount
+
+# Create more than $((dbsize / 32)) xattr entries to force the creation of a
+# node block and two (or more) leaf blocks, which we need for this test.
+nr_xattr="$((dbsize / 32))"
+localfile="${SCRATCH_MNT}/attrfile"
+touch $localfile
+for ((i=0; i<nr_xattr; i++));do
+	$SETFATTR_PROG -n user.x$(printf "%.09d" "$i") -v "aaaaaaaaaaaaaaaa" $localfile
+done
+inumber="$(stat -c '%i' $localfile)"
+_scratch_unmount
+
+# Expect the ablock 0 is a node block, later ablocks(>=1) are leaf blocks, then corrupt
+# the last leaf block. (Don't corrupt node block, or can't reproduce the bug)
+magic=$(_scratch_xfs_get_metadata_field "hdr.info.hdr.magic" "inode $inumber" "ablock 0")
+level=$(_scratch_xfs_get_metadata_field "hdr.level" "inode $inumber" "ablock 0")
+count=$(_scratch_xfs_get_metadata_field "hdr.count" "inode $inumber" "ablock 0")
+if [ "$magic" = "0x3ebe" -a "$level" = "1" ];then
+	# Corrupt the last leaf block
+	_scratch_xfs_db -x -c "inode ${inumber}" -c "ablock $count" -c "stack" \
+		-c "blocktrash -x 32 -y $((dbsize*8)) -3 -z" >> $seqres.full
+else
+	_fail "The ablock 0 (magic=$magic, level=$level) isn't a root node block, maybe case issue"
+fi
+
+# This's the real testing, expect removexattr won't hang or panic.
+if _try_scratch_mount >> $seqres.full 2>&1; then
+	for ((i=0; i<nr_xattr; i++));do
+		$GETFATTR_PROG -n user.x$(printf "%.09d" "$i") $localfile >/dev/null 2>&1
+		$SETFATTR_PROG -x user.x$(printf "%.09d" "$i") $localfile 2>/dev/null
+	done
+else
+	# Due to we corrupt the xfs manually, so can't be sure if xfs can
+	# detect this corruption and refuse the mount directly in one day.
+	# If so, it's not a testing fail, so "notrun" directly to mark this
+	# test isn't really done
+	_notrun "XFS refused to mount with this xattr corrutpion, test skipped"
+fi
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 00000000..3b276ca8
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
-- 
2.31.1

