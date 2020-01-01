Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8160C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74FA3206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l04rk8Q/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgAABFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:05:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbgAABFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:05:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00114PEo107059
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rRi8v3RuEeLMK0lzZtO9+0GcV+ZJlqNCf2AeJ8ZB/9g=;
 b=l04rk8Q/ZJ9kmzIXjlzbM98a4W0f5laO5GhKp4ZcQwooOgyFjZ+bmOiDUVUD3jALuR+V
 FuA+3uIoyEa8UR7XQT6wCB5KIXW1opVsblpmp35NHV+9qPj6/WdAfWhU3HzPeN0HbqX/
 Zo/ag5/q0FpRhUmi+MsCVBlAz04oeYrVas38gLiZNrZ2Tkxin2jvCZJ97mhQJMNCewqa
 ekaz4GFhuSUqWYSVpmSG6WqZehjCcXJ1ct9zPYv87SDdJxUdlGc/89m/8Wkvda1GAkZo
 y+yn4ueMGW7GQzxYOkNHtdlfLhCaAFLm9UtB38aBSD1dliw641rvue0ywf9OVNiixI2y yA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115NsQ039742
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medf8j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00114CZA008983
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:04:12 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:04:12 -0800
Subject: [PATCH 4/6] xfs: create a new inode fork block unmap helper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:04:10 -0800
Message-ID: <157784065009.1358958.14015933199979186985.stgit@magnolia>
In-Reply-To: <157784062523.1358958.17318700801044648140.stgit@magnolia>
References: <157784062523.1358958.17318700801044648140.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new helper to unmap blocks from an inode's fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    3 +++
 fs/xfs/xfs_inode.c       |   29 ++++-------------------------
 3 files changed, 50 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 84ddd4654975..f15cc7cc3b62 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6327,3 +6327,46 @@ xfs_bmap_validate_extent(
 	return xfs_bmap_validate_extent_raw(ip->i_mount,
 			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
 }
+
+/*
+ * Used in xfs_itruncate_extents().  This is the maximum number of extents
+ * freed from a file in a single transaction.
+ */
+#define	XFS_ITRUNC_MAX_EXTENTS	2
+
+/*
+ * Unmap every extent in part of an inode's fork.  We don't do any higher level
+ * invalidation work at all.
+ */
+int
+xfs_bunmapi_range(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_fileoff_t		startoff,
+	xfs_filblks_t		unmap_len,
+	int			bunmapi_flags)
+{
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	bunmapi_flags |= xfs_bmapi_aflag(whichfork);
+	while (unmap_len > 0) {
+		ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
+		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len,
+				bunmapi_flags, XFS_ITRUNC_MAX_EXTENTS);
+		if (error)
+			goto out;
+
+		/*
+		 * Duplicate the transaction that has the permanent
+		 * reservation and commit the old transaction.
+		 */
+		error = xfs_defer_finish(tpp);
+		if (error)
+			goto out;
+	}
+out:
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 07c9726d40c2..ec29d5012a49 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -286,5 +286,8 @@ xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
 		int flags);
+int	xfs_bunmapi_range(struct xfs_trans **tpp, struct xfs_inode *ip,
+		int whichfork, xfs_fileoff_t startoff, xfs_filblks_t unmap_len,
+		int bunmapi_flags);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c6986517074e..8a424fac2d27 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -38,12 +38,6 @@
 
 kmem_zone_t *xfs_inode_zone;
 
-/*
- * Used in xfs_itruncate_extents().  This is the maximum number of extents
- * freed from a file in a single transaction.
- */
-#define	XFS_ITRUNC_MAX_EXTENTS	2
-
 STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
@@ -1519,7 +1513,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
 	xfs_fileoff_t		last_block;
-	xfs_filblks_t		unmap_len;
 	int			error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -1533,8 +1526,6 @@ xfs_itruncate_extents_flags(
 
 	trace_xfs_itruncate_extents_start(ip, new_size);
 
-	flags |= xfs_bmapi_aflag(whichfork);
-
 	/*
 	 * Since it is possible for space to become allocated beyond
 	 * the end of the file (in a crash where the space is allocated
@@ -1550,22 +1541,10 @@ xfs_itruncate_extents_flags(
 		return 0;
 
 	ASSERT(first_unmap_block < last_block);
-	unmap_len = last_block - first_unmap_block + 1;
-	while (unmap_len > 0) {
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
-				flags, XFS_ITRUNC_MAX_EXTENTS);
-		if (error)
-			goto out;
-
-		/*
-		 * Duplicate the transaction that has the permanent
-		 * reservation and commit the old transaction.
-		 */
-		error = xfs_defer_finish(&tp);
-		if (error)
-			goto out;
-	}
+	error = xfs_bunmapi_range(&tp, ip, whichfork, first_unmap_block,
+			last_block - first_unmap_block + 1, flags);
+	if (error)
+		goto out;
 
 	if (whichfork == XFS_DATA_FORK) {
 		/* Remove all pending CoW reservations. */

