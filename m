Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56202 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 15/18] xfs_repair: fix 'bno' shadow vars in scan.c
Date: Wed, 10 Oct 2018 15:01:19 -0500
Message-Id: <1539201682-22198-16-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

scan.c has 3 functions which accept 'bno' as an argument, but then use a
local variable of the same name for a different purpose in an inner scope,
which causes sparse warnings.
Rename these inner-scope loop variables 'agbno' to fix this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/scan.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 65a76e2..12ca314 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -738,7 +738,7 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	}
 
 	for (i = 0; i < numrecs; i++)  {
-		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
+		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);
 
 		/*
 		 * XXX - put sibling detection right here.
@@ -749,17 +749,17 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * pointer mismatch, try and extract as much data
 		 * as possible.
 		 */
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
 			switch (magic) {
 			case XFS_ABTB_CRC_MAGIC:
 			case XFS_ABTB_MAGIC:
-				scan_sbtree(bno, level, agno, suspect,
+				scan_sbtree(agbno, level, agno, suspect,
 					    scan_allocbt, 0, magic, priv,
 					    &xfs_allocbt_buf_ops);
 				break;
 			case XFS_ABTC_CRC_MAGIC:
 			case XFS_ABTC_MAGIC:
-				scan_sbtree(bno, level, agno, suspect,
+				scan_sbtree(agbno, level, agno, suspect,
 					    scan_allocbt, 0, magic, priv,
 					    &xfs_allocbt_buf_ops);
 				break;
@@ -1177,7 +1177,7 @@ advance:
 	}
 
 	for (i = 0; i < numrecs; i++)  {
-		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
+		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);
 
 		/*
 		 * XXX - put sibling detection right here.
@@ -1199,12 +1199,12 @@ advance:
 			/* Look for impossible flags. */
 			do_warn(
 	_("invalid flags in high key %u of %s btree block %u/%u\n"),
-				i, name, agno, bno);
+				i, name, agno, agbno);
 			continue;
 		}
 
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
-			scan_sbtree(bno, level, agno, suspect, scan_rmapbt, 0,
+		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
+			scan_sbtree(agbno, level, agno, suspect, scan_rmapbt, 0,
 				    magic, priv, &xfs_rmapbt_buf_ops);
 		}
 	}
@@ -1419,10 +1419,10 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	}
 
 	for (i = 0; i < numrecs; i++)  {
-		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
+		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);
 
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
-			scan_sbtree(bno, level, agno, suspect, scan_refcbt, 0,
+		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
+			scan_sbtree(agbno, level, agno, suspect, scan_refcbt, 0,
 				    magic, priv, &xfs_refcountbt_buf_ops);
 		}
 	}
-- 
1.8.3.1
