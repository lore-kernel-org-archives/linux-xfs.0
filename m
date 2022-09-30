Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD865C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Sep 2022 11:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiI3Le2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Sep 2022 07:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiI3LeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2022 07:34:05 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACAFF8FAE;
        Fri, 30 Sep 2022 04:27:30 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mf7DF5fPkzpTDQ;
        Fri, 30 Sep 2022 19:24:29 +0800 (CST)
Received: from huawei.com (10.175.124.27) by kwepemi500019.china.huawei.com
 (7.221.188.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 30 Sep
 2022 19:27:27 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <zlang@redhat.com>, <dchinner@redhat.com>, <djwong@kernel.org>
CC:     <fstests@vger.kernel.org>, <guoxuenan@huawei.com>,
        <houtao1@huawei.com>, <jack.qiu@huawei.com>,
        <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH v3] xfs/554: xfs add illegal bestfree array size inject for leaf dir
Date:   Fri, 30 Sep 2022 19:53:00 +0800
Message-ID: <20220930115300.3311245-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929113213.4r7be3dbr5r2nqqn@zlang-mailbox>
References: <20220929113213.4r7be3dbr5r2nqqn@zlang-mailbox>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test leaf dir allocting new block when bestfree array size
less than data blocks count, which may lead to UAF.

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 tests/xfs/554     | 96 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/554.out |  7 ++++
 2 files changed, 103 insertions(+)
 create mode 100755 tests/xfs/554
 create mode 100644 tests/xfs/554.out

diff --git a/tests/xfs/554 b/tests/xfs/554
new file mode 100755
index 00000000..ee088fdc
--- /dev/null
+++ b/tests/xfs/554
@@ -0,0 +1,96 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
+#
+# FS QA Test No. 554
+#
+# Check the running state of the XFS under illegal bestfree count
+# for leaf directory format.
+
+. ./common/preamble
+_begin_fstest auto quick dangerous
+
+# Import common functions.
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+
+# Remove all entries in the last logic dir data block
+leaf_dir_remove_lastdb_entries()
+{
+	local dir_ino=$1
+	local blks_pdirb=$2
+	local nblocks=$(_scratch_xfs_get_metadata_field 'core.nblocks' "inode ${dir_ino}")
+	#last dir data block index = total blocks - one leaf dir block - one dir block
+	local last_db=$((nblocks - blks_pdirb * 2))
+
+	echo "last dir block $last_db" >> $seqres.full
+	_scratch_xfs_db -c "inode $dir_ino" -c "dblock ${last_db}" -c 'p du' |\
+		grep ".name =" | sed -e 's/^.*.name = //g' \
+		-e 's/\"//g' > $tmp.ldb_ents ||\
+		_fail "get last dir block entries failed"
+	cat $tmp.ldb_ents >> $seqres.full
+	_scratch_mount
+	cat $tmp.ldb_ents | while read f
+	do
+		rm -rf ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/$f
+	done
+	_scratch_unmount
+}
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+echo "Create and check leaf dir"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+dirblksz=`$XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize |
+	sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'`
+
+# Usually, following routine will create a directory with one leaf block
+# and three data block, meanwhile, the last data block is not full.
+__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dirblksz / 12))"
+leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
+_scratch_unmount
+
+# Delete directory entries in the last directory block,
+leaf_dir_remove_lastdb_entries ${leaf_dir} $((dirblksz / blksz))
+
+# Check leaf directory
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+__populate_check_xfs_dir "${leaf_dir}" "leaf"
+
+# Inject abnormal bestfree count
+echo "Inject bad bestfree count."
+_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock ${leaf_lblk}" \
+	-c "write ltail.bestcount 0"
+
+# Adding new entries to S_IFDIR.FMT_LEAF. Since we delete the files
+# in last directory block, current dir block have no spare space for new
+# entry. With ltail.bestcount setting illegally (eg. bestcount=0), then
+# creating new directories, which will trigger xfs to allocate new dir
+# block, meanwhile, exception will be triggered.
+# Root cause is that xfs don't examin the number bestfree slots, when the
+# slots number less than dir data blocks, if we need to allocate new dir
+# data block and update the bestfree array, we will use the dir block number
+# as index to assign bestfree array, while we did not check the leaf buf
+# boundary which may cause UAF or other memory access problem.
+echo "Add directory entries to trigger exception."
+_scratch_mount
+seq 1 $((dirblksz / 24)) | while read d
+do
+	mkdir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/TEST$(printf "%.04d" "$d")" >> $seqres.full 2>&1
+done
+_scratch_unmount
+
+# Bad bestfree count should be found and fixed by xfs_repair
+_scratch_xfs_repair -n >> $seqres.full 2>&1
+egrep -q 'leaf block.*bad tail' $seqres.full && echo "Repair found problems."
+_repair_scratch_fs >> $seqres.full 2>&1 || _fail "Repair failed!"
+
+# Success, all done
+status=0
+exit
diff --git a/tests/xfs/554.out b/tests/xfs/554.out
new file mode 100644
index 00000000..398ee7d5
--- /dev/null
+++ b/tests/xfs/554.out
@@ -0,0 +1,7 @@
+QA output created by 554
+Format and mount
+Create and check leaf dir
+Inject bad bestfree count.
+ltail.bestcount = 0
+Add directory entries to trigger exception.
+Repair found problems.
-- 
2.25.1

