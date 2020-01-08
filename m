Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9FEC33C9E
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 693AB2072B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B1pzUfQ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgAHEVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:21:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52104 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAHEVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:21:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JJDQ035717
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9JLmfYRGpmd+/PDcu34n9++WEXoPYc5k+uebAFWqTfM=;
 b=B1pzUfQ5Q7UVcbUx8hUUmO+FcHzELXc/Vk6SBQZ9k+k1jYPtVT3ddpQLVkRKKWy24Jgp
 rS8/EavKA+hUzy9qVF1/5qeviU/c4LuAMcAsbRHc8ytiUWwzIYyEvhdYIGOfAZopGqPE
 fb9JF0KyIavqVXGpkylNzVaXpnr+V0tSO96nAubNQSPqHemBiP4C2CWLPPHQYSeSSzT7
 XeIkoCJ+a66rUPauL8Esmc6qJcyh4G+OD00Ljqc7qmzMRROwmHhSmkobMl2MX188RhI6
 KDgWE2ahiKIstxGDPqrHJ+S4/agW+wWoJoVotrpHMCDtYYGiil+cFJ18yf3gGmBDN5Z9 ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xakbqscq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:21:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JIt0061027
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:19:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xcqbjvjj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:19:19 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0084IESL011926
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:18:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:18:14 -0800
Subject: [PATCH 1/3] xfs: refactor remote attr value buffer invalidation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:18:11 -0800
Message-ID: <157845709180.84011.3139453026212575913.stgit@magnolia>
In-Reply-To: <157845708352.84011.17764262087965041304.stgit@magnolia>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While running generic/103, I observed what looks like memory corruption
and (with slub debugging turned on) a slub redzone warning on i386 when
inactivating an inode with a 64k remote attr value.

On a v5 filesystem, maximally sized remote attr values require one block
more than 64k worth of space to hold both the remote attribute value
header (64 bytes).  On a 4k block filesystem this results in a 68k
buffer; on a 64k block filesystem, this would be a 128k buffer.  Note
that even though we'll never use more than 65,600 bytes of this buffer,
XFS_MAX_BLOCKSIZE is 64k.

This is a problem because the definition of struct xfs_buf_log_format
allows for XFS_MAX_BLOCKSIZE worth of dirty bitmap (64k).  On i386 when we
invalidate a remote attribute, xfs_trans_binval zeroes all 68k worth of
the dirty map, writing right off the end of the log item and corrupting
memory.  We've gotten away with this on x86_64 for years because the
compiler inserts a u32 padding on the end of struct xfs_buf_log_format.

Fortunately for us, remote attribute values are written to disk with
xfs_bwrite(), which is to say that they are not logged.  Fix the problem
by removing all places where we could end up creating a buffer log item
for a remote attribute value and leave a note explaining why.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   66 ++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr_remote.h |    1 +
 fs/xfs/xfs_attr_inactive.c      |   29 +----------------
 3 files changed, 51 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a6ef5df42669..6ffe0eb8b422 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -25,6 +25,23 @@
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
+/*
+ * Remote Attribute Values
+ * =======================
+ *
+ * Remote extended attribute values are conceptually simple -- they're written
+ * to data blocks mapped by an inode's attribute fork, and they have an upper
+ * size limit of 64k.  Setting a value does not involve the XFS log.
+ *
+ * However, on a v5 filesystem, maximally sized remote attr values require one
+ * block more than 64k worth of space to hold both the remote attribute value
+ * header (64 bytes).  On a 4k block filesystem this results in a 68k buffer;
+ * on a 64k block filesystem, this would be a 128k buffer.  Note that the log
+ * format can only handle a dirty buffer of XFS_MAX_BLOCKSIZE length (64k).
+ * Therefore, we /must/ ensure that remote attribute value buffers never touch
+ * the logging system and therefore never have a log item.
+ */
+
 /*
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
@@ -401,7 +418,7 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_trans_read_buf(mp, args->trans,
+			error = xfs_trans_read_buf(mp, NULL,
 						   mp->m_ddev_targp,
 						   dblkno, dblkcnt, 0, &bp,
 						   &xfs_attr3_rmt_buf_ops);
@@ -411,7 +428,7 @@ xfs_attr_rmtval_get(
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
-			xfs_trans_brelse(args->trans, bp);
+			xfs_buf_relse(bp);
 			if (error)
 				return error;
 
@@ -552,6 +569,34 @@ xfs_attr_rmtval_set(
 	return 0;
 }
 
+/* Mark stale any buffers for the remote value. */
+void
+xfs_attr_rmtval_stale(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*map)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		dblkno;
+	int			dblkcnt;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (map->br_startblock == HOLESTARTBLOCK)
+		return;
+
+	dblkno = XFS_FSB_TO_DADDR(mp, map->br_startblock),
+	dblkcnt = XFS_FSB_TO_BB(mp, map->br_blockcount);
+
+	/*
+	 * If the "remote" value is in the cache, remove it.
+	 */
+	bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
+	if (bp) {
+		xfs_buf_stale(bp);
+		xfs_buf_relse(bp);
+	}
+}
+
 /*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
@@ -560,7 +605,6 @@ int
 xfs_attr_rmtval_remove(
 	struct xfs_da_args	*args)
 {
-	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error;
@@ -575,9 +619,6 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	while (blkcnt > 0) {
 		struct xfs_bmbt_irec	map;
-		struct xfs_buf		*bp;
-		xfs_daddr_t		dblkno;
-		int			dblkcnt;
 		int			nmap;
 
 		/*
@@ -592,18 +633,7 @@ xfs_attr_rmtval_remove(
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
 
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
-		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
-
-		/*
-		 * If the "remote" value is in the cache, remove it.
-		 */
-		bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
-		if (bp) {
-			xfs_buf_stale(bp);
-			xfs_buf_relse(bp);
-			bp = NULL;
-		}
+		xfs_attr_rmtval_stale(args->dp, &map);
 
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9d20b66ad379..ce7287ac5b1f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -11,5 +11,6 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+void xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map);
 
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5ff49523d8ea..20453ce69a4b 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -36,11 +36,8 @@ xfs_attr3_leaf_freextent(
 	int			blkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	struct xfs_buf		*bp;
 	xfs_dablk_t		tblkno;
-	xfs_daddr_t		dblkno;
 	int			tblkcnt;
-	int			dblkcnt;
 	int			nmap;
 	int			error;
 
@@ -63,35 +60,13 @@ xfs_attr3_leaf_freextent(
 		ASSERT(nmap == 1);
 		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
 
-		/*
-		 * If it's a hole, these are already unmapped
-		 * so there's nothing to invalidate.
-		 */
-		if (map.br_startblock != HOLESTARTBLOCK) {
-
-			dblkno = XFS_FSB_TO_DADDR(dp->i_mount,
-						  map.br_startblock);
-			dblkcnt = XFS_FSB_TO_BB(dp->i_mount,
-						map.br_blockcount);
-			bp = xfs_trans_get_buf(*trans,
-					dp->i_mount->m_ddev_targp,
-					dblkno, dblkcnt, 0);
-			if (!bp)
-				return -ENOMEM;
-			xfs_trans_binval(*trans, bp);
-			/*
-			 * Roll to next transaction.
-			 */
-			error = xfs_trans_roll_inode(trans, dp);
-			if (error)
-				return error;
-		}
+		xfs_attr_rmtval_stale(dp, &map);
 
 		tblkno += map.br_blockcount;
 		tblkcnt -= map.br_blockcount;
 	}
 
-	return 0;
+	return xfs_trans_roll_inode(trans, dp);
 }
 
 /*

