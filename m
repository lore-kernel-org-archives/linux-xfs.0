Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973BBC54EE9
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 09:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiIBJWo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 05:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbiIBJWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 05:22:41 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC9FB5E5F;
        Fri,  2 Sep 2022 02:22:40 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MJspS6h0DzHncf;
        Fri,  2 Sep 2022 17:20:48 +0800 (CST)
Received: from huawei.com (10.175.124.27) by kwepemi500019.china.huawei.com
 (7.221.188.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 17:22:37 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <zlang@kernel.org>, <fstests@vger.kernel.org>
CC:     <djwong@kernel.org>, <dchinner@redhat.com>,
        <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <zhengbin13@huawei.com>,
        <jack.qiu@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH fstests] xfs/554: xfs add illegal bestfree array size inject for leaf dir
Date:   Fri, 2 Sep 2022 17:40:46 +0800
Message-ID: <20220902094046.3891252-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test leaf dir allocting new block when bestfree array size
less than data blocks count, which may lead to UAF.

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 tests/xfs/554     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/554.out |  6 ++++++
 2 files changed, 54 insertions(+)
 create mode 100755 tests/xfs/554
 create mode 100644 tests/xfs/554.out

diff --git a/tests/xfs/554 b/tests/xfs/554
new file mode 100755
index 00000000..fcf45731
--- /dev/null
+++ b/tests/xfs/554
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
+#
+# FS QA Test No. 554
+#
+# Test leaf dir bestfree array size match with dir disk size
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+# Import common functions.
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_check_dmesg
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount  >> $seqres.full 2>&1
+
+echo "Create and check leaf dir"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+dblksz="$($XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dblksz / 12))"
+leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
+_scratch_unmount
+__populate_check_xfs_dir "${leaf_dir}" "leaf"
+
+echo "Inject bad bestfress array size"
+_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock 8388608" -c "write ltail.bestcount 0"
+
+echo "Test add entry to dir"
+_scratch_mount
+touch ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/{1..100}.txt > /dev/null 2>&1
+_scratch_unmount 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+
+# check demsg error
+_check_dmesg
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/554.out b/tests/xfs/554.out
new file mode 100644
index 00000000..ea1f30cc
--- /dev/null
+++ b/tests/xfs/554.out
@@ -0,0 +1,6 @@
+QA output created by 554
+Format and mount
+Create and check leaf dir
+Inject bad bestfress array size
+ltail.bestcount = 0
+Test add entry to dir
-- 
2.25.1

