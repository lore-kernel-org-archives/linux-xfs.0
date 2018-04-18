Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752679AbeDRCKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:10:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I25nl3079930
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:09:59 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8h76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:09:59 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I29xQR026725
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:09:59 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I29wvX012675
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:09:58 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH 1/1] xfs: fix a null pointer dereference in xfs_bmap_extents_to_btree
Date: Wed, 18 Apr 2018 10:09:45 +0800
Message-Id: <1524017385-6671-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Fuzzing tool reports a write to null pointer error in the
xfs_bmap_extents_to_btree, fix it by bailing out on encountering
a null pointer.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 040eeda..90b743d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -724,19 +724,14 @@ xfs_bmap_extents_to_btree(
 	args.wasdel = wasdel;
 	*logflagsp = 0;
 	if ((error = xfs_alloc_vextent(&args))) {
-		xfs_iroot_realloc(ip, -1, whichfork);
 		ASSERT(ifp->if_broot == NULL);
-		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
-		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-		return error;
+		goto err1;
 	}
 
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
-		xfs_iroot_realloc(ip, -1, whichfork);
 		ASSERT(ifp->if_broot == NULL);
-		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
-		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-		return -ENOSPC;
+		error = -ENOSPC;
+		goto err1;
 	}
 	/*
 	 * Allocation can't fail, the space was reserved.
@@ -748,6 +743,10 @@ xfs_bmap_extents_to_btree(
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	abp = xfs_btree_get_bufl(mp, tp, args.fsbno, 0);
+	if (!abp) {
+		error = -ENOSPC;
+		goto err2;
+	}
 	/*
 	 * Fill in the child block.
 	 */
@@ -787,6 +786,15 @@ xfs_bmap_extents_to_btree(
 	*curp = cur;
 	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fbroot(whichfork);
 	return 0;
+
+err2:
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
+err1:
+	xfs_iroot_realloc(ip, -1, whichfork);
+	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+
+	return error;
 }
 
 /*
-- 
2.7.4

