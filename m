Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74EBDC33C9E
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 09:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55E862073A
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 09:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgAHJ2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 04:28:51 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51996 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727205AbgAHJ2v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Jan 2020 04:28:51 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C828A7ADC278D822FC12;
        Wed,  8 Jan 2020 17:28:49 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 Jan 2020
 17:28:39 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <guaneryu@gmail.com>, <darrick.wong@oracle.com>
CC:     <jbacik@fusionio.com>, <fstests@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>, <yukuai3@huawei.com>,
        <zhengbin13@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] xfs/126: fix that corrupt xattr might fail with a small probability
Date:   Wed, 8 Jan 2020 17:27:58 +0800
Message-ID: <20200108092758.41363-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The cmd used in xfs_db to corrupt xattr is "blocktrash -x 32
-y $((blksz * 8)) -n8 -3", which means select random 8 bit from 32 to
end of the block, and the changed bits are randomized. However,
there is a small chance that corrupting xattr failed because irrelevant
bits are chossen or the chooosen bits are not changed, which lead to
output missmatch:
QA output created by 126                    QA output created by 126
+ create scratch fs                         + create scratch fs
+ mount fs image                            + mount fs image
+ make some files                           + make some files
+ check fs                                  + check fs
+ check xattr                               + check xattr
+ corrupt xattr                             + corrupt xattr
+ mount image && modify xattr               + mount image && modify xattr
+ repair fs                                 + repair fs
+ mount image (2)                           + mount image (2)
+ chattr -R -i                              + chattr -R -i
+ modify xattr (2)                          + modify xattr (2)
                                            > # file: tmp/scratch/attrfile
                                            > user.x00000000="0000000000000000"
                                            >
+ check fs (2)                              + check fs (2)

Fix the problem by adding a seed for random processing to select same
bits each time, and inverting the selected bits.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 tests/xfs/126 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/126 b/tests/xfs/126
index 4f9f8cf9..9b57e58b 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -37,7 +37,7 @@ test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
 _require_populate_commands
 _require_xfs_db_blocktrash_z_command
-test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -2"
 
 rm -f $seqres.full
 
@@ -72,7 +72,7 @@ echo "+ corrupt xattr"
 loff=1
 while true; do
 	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" | grep -q 'file attr block is unmapped' && break
-	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -s 1024 -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 
-- 
2.17.2

