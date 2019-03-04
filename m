Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDVT0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 16:19:26 -0500
Subject: [PATCH 2/5] xfs/010: use correct type for finobt corrupting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Mar 2019 13:19:22 -0800
Message-ID: <155173436278.767.10161710001222466116.stgit@magnolia>
In-Reply-To: <155173434205.767.15128498725168844621.stgit@magnolia>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use 'type finobt' for corrupting the finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/010 |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/010 b/tests/xfs/010
index ee1595c8..e220a651 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -63,14 +63,14 @@ _corrupt_finobt_records()
 			_filter_dbval`
 
 	# Corrupt a freecount value. This should never exceed 64.
-	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
 		-c "write recs[1].freecount 70" $dev
 
 	# Create a corrupted non-free record, which should never appear in the
 	# finobt.
-	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
 		 -c "write recs[2].freecount 0" $dev
-	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
 		-c "write recs[2].free 0" $dev
 }
 
