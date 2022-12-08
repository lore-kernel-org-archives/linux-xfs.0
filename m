Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE57C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Dec 2022 07:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLHH3O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Dec 2022 02:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiLHH3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2022 02:29:13 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C8F46674;
        Wed,  7 Dec 2022 23:29:10 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=ziyangzhang@linux.alibaba.com;NM=0;PH=DS;RN=8;SR=0;TI=SMTPD_---0VWpNSaC_1670484546;
Received: from localhost.localdomain(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWpNSaC_1670484546)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 15:29:07 +0800
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        hsiangkao@linux.alibaba.com, allison.henderson@oracle.com,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [PATCH V5 1/2] common/xfs: Add a helper to export inode core size
Date:   Thu,  8 Dec 2022 15:28:42 +0800
Message-Id: <20221208072843.1866615-2-ZiyangZhang@linux.alibaba.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
References: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some xfs test cases need the number of bytes reserved for only the inode
record, excluding the immediate fork areas. Now the value is hard-coded
and it is not a good chioce. Add a helper in common/xfs to export the
inode core size.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
---
 common/xfs    | 15 +++++++++++++++
 tests/xfs/335 |  3 ++-
 tests/xfs/336 |  3 ++-
 tests/xfs/337 |  3 ++-
 tests/xfs/341 |  3 ++-
 tests/xfs/342 |  3 ++-
 6 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/common/xfs b/common/xfs
index 8ac1964e..674384a9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1486,3 +1486,18 @@ _require_xfsrestore_xflag()
 	$XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
 			_notrun 'xfsrestore does not support -x flag.'
 }
+
+# Number of bytes reserved for only the inode record, excluding the
+# immediate fork areas.
+_xfs_get_inode_core_bytes()
+{
+	local dir="$1"
+	
+	if _xfs_has_feature "$dir" crc; then
+		# v5 filesystems
+		echo 176
+	else
+		# v4 filesystems
+		echo 96
+	fi
+}
diff --git a/tests/xfs/335 b/tests/xfs/335
index ccc508e7..3f5223ee 100755
--- a/tests/xfs/335
+++ b/tests/xfs/335
@@ -31,7 +31,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
 echo "Create a three-level rtrmapbt"
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_ptrs=$(( (blksz - 56) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
diff --git a/tests/xfs/336 b/tests/xfs/336
index b1de8e5f..a686fab4 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -42,7 +42,8 @@ rm -rf $metadump_file
 echo "Create a three-level rtrmapbt"
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_ptrs=$(( (blksz - 56) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
diff --git a/tests/xfs/337 b/tests/xfs/337
index a2515e36..3bdef4e3 100755
--- a/tests/xfs/337
+++ b/tests/xfs/337
@@ -33,7 +33,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_ptrs=$(( (blksz - 56) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
diff --git a/tests/xfs/341 b/tests/xfs/341
index f026aa37..72f75318 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -33,7 +33,8 @@ rtextsz_blks=$((rtextsz / blksz))
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
 blocks=$((i_ptrs * bt_recs + 1))
diff --git a/tests/xfs/342 b/tests/xfs/342
index 1ae414eb..0b3b136c 100755
--- a/tests/xfs/342
+++ b/tests/xfs/342
@@ -30,7 +30,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
 blocks=$((i_ptrs * bt_recs + 1))
-- 
2.18.4

