Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932204AbeGDEvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 00:51:21 -0400
Subject: [PATCH 5/7] xfs/288: update for v5 filesystem support in xfs_db
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Jul 2018 21:51:18 -0700
Message-ID: <153067987888.28393.1495605585039843918.stgit@magnolia>
In-Reply-To: <153067984748.28393.1595618163831671652.stgit@magnolia>
References: <153067984748.28393.1595618163831671652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The xfs_db 'write -d' command has supported v5 filesystems for a few
releases now, and there's nothing about this test that require v4, so
let the test run with v5 if the user so specifies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/288 |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)


diff --git a/tests/xfs/288 b/tests/xfs/288
index e7a08a5d..bccdb6fc 100755
--- a/tests/xfs/288
+++ b/tests/xfs/288
@@ -36,14 +36,8 @@ _supported_os Linux
 _require_scratch
 _require_attrs
 
-# Due to xfs_db's write -d option is still not stable, and there's no
-# plan to support attr3. So only run this case on V4 XFS.
-# Please update this if xfs_db get enough improvement in one day.
-if [ -z "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
-	mkfs_opts="-m crc=0"
-fi
 # get block size ($dbsize) from the mkfs output
-_scratch_mkfs_xfs $mkfs_opts 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
+_scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 
 _scratch_mount

