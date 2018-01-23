Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59632 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751080AbeAWIrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 03:47:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0N8klIM186404
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2018 08:47:36 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2fp1hbg2fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2018 08:47:36 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0N8gZkx030426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2018 08:42:36 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0N8gZ35010248
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2018 08:42:35 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH 1/1] xfs: bmap code cleanup
Date: Tue, 23 Jan 2018 16:42:24 +0800
Message-Id: <1516696944-11996-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Remove the extent size hint and realtime inode relevant code from
the xfs_bmapi_reserve_delalloc since it is not called on the inode
with extent size hint set or on a realtime inode.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1bddbba6b80c..8b4ab1932b58 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3876,8 +3876,6 @@ xfs_bmapi_reserve_delalloc(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
-	char			rt = XFS_IS_REALTIME_INODE(ip);
-	xfs_extlen_t		extsz;
 	int			error;
 	xfs_fileoff_t		aoff = off;
 
@@ -3892,31 +3890,25 @@ xfs_bmapi_reserve_delalloc(
 		prealloc = alen - len;
 
 	/* Figure out the extent size, adjust alen */
-	if (whichfork == XFS_COW_FORK)
-		extsz = xfs_get_cowextsz_hint(ip);
-	else
-		extsz = xfs_get_extsz_hint(ip);
-	if (extsz) {
+	if (whichfork == XFS_COW_FORK) {
 		struct xfs_bmbt_irec	prev;
+		xfs_extlen_t extsz = xfs_get_cowextsz_hint(ip);
 
 		if (!xfs_iext_peek_prev_extent(ifp, icur, &prev))
 			prev.br_startoff = NULLFILEOFF;
 
-		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, rt, eof,
+		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, 0, eof,
 					       1, 0, &aoff, &alen);
 		ASSERT(!error);
 	}
 
-	if (rt)
-		extsz = alen / mp->m_sb.sb_rextsize;
-
 	/*
 	 * Make a transaction-less quota reservation for delayed allocation
 	 * blocks.  This number gets adjusted later.  We return if we haven't
 	 * allocated blocks already inside this loop.
 	 */
 	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
-			rt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+						XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		return error;
 
@@ -3927,12 +3919,7 @@ xfs_bmapi_reserve_delalloc(
 	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
 	ASSERT(indlen > 0);
 
-	if (rt) {
-		error = xfs_mod_frextents(mp, -((int64_t)extsz));
-	} else {
-		error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
-	}
-
+	error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
 	if (error)
 		goto out_unreserve_quota;
 
@@ -3963,14 +3950,11 @@ xfs_bmapi_reserve_delalloc(
 	return 0;
 
 out_unreserve_blocks:
-	if (rt)
-		xfs_mod_frextents(mp, extsz);
-	else
-		xfs_mod_fdblocks(mp, alen, false);
+	xfs_mod_fdblocks(mp, alen, false);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
-		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0, rt ?
-				XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0,
+						XFS_QMOPT_RES_REGBLKS);
 	return error;
 }
 
-- 
2.14.1

