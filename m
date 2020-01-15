Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1608EC33CB3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E0C214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UMdJrJHt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgAORDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:03:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgAORDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:03:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhPW9037037;
        Wed, 15 Jan 2020 17:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Lc8Ai6q3cquENGGssZSVgRakZnvzjrc7lK28o4plgW4=;
 b=UMdJrJHtxzKqMxJBywi3ha5zq0NWKs7UPfZEMyZRZ334CJ+k6/Wc1PB2usMdY75fpLgP
 AWP9k2tpv0uSQdsYU1NFwDQ+ADMMM9MW3Bc6675nwZr4CkKvAjrwaO2G6uHxG9Kg9MHx
 rjZ/lvRu86t1IL13MublrAqSNQCsnR1Oos3+00CDo/Hn6xukZNv2riyFZ4uONydhXysp
 UOG+AUSOlX7JIEfUA10WmFGLFxCR0IKN0PdMJlHa0prkz+qRQzt2g4wOUha9V4eJdNR3
 iW9klDzQAvVNAV231jYXm3i32W89I38KnlqKvWbhp6UzMCpVCBiEuLd406wuCVx6EZcq KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sde5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiW7I183095;
        Wed, 15 Jan 2020 17:03:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xj1apwq32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:07 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH37Y6023320;
        Wed, 15 Jan 2020 17:03:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:07 -0800
Subject: [PATCH 2/7] xfs: fix memory corruption during remote attr value
 buffer invalidation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:03:06 -0800
Message-ID: <157910778615.2028015.18198430975182240025.stgit@magnolia>
In-Reply-To: <157910777330.2028015.5017943601641757827.stgit@magnolia>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
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
for a remote attribute value and leave a note explaining why.  Next,
replace the open-coded buffer invalidation with a call to the helper we
created in the previous patch that does better checking for bad metadata
before marking the buffer stale.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   37 ++++++++++++++++++++++++-----
 fs/xfs/xfs_attr_inactive.c      |   50 ++++++++++++---------------------------
 2 files changed, 46 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index df1ab0569481..a266d05df146 100644
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
@@ -401,17 +418,25 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_trans_read_buf(mp, args->trans,
-						   mp->m_ddev_targp,
-						   dblkno, dblkcnt, 0, &bp,
-						   &xfs_attr3_rmt_buf_ops);
-			if (error)
+			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
+					&xfs_attr3_rmt_buf_ops);
+			if (!bp)
+				return -ENOMEM;
+			error = bp->b_error;
+			if (error) {
+				xfs_buf_ioerror_alert(bp, __func__);
+				xfs_buf_relse(bp);
+
+				/* bad CRC means corrupted metadata */
+				if (error == -EFSBADCRC)
+					error = -EFSCORRUPTED;
 				return error;
+			}
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
-			xfs_trans_brelse(args->trans, bp);
+			xfs_buf_relse(bp);
 			if (error)
 				return error;
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5ff49523d8ea..edb079087a0c 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -25,22 +25,20 @@
 #include "xfs_error.h"
 
 /*
- * Look at all the extents for this logical region,
- * invalidate any buffers that are incore/in transactions.
+ * Invalidate any incore buffers associated with this remote attribute value
+ * extent.   We never log remote attribute value buffers, which means that they
+ * won't be attached to a transaction and are therefore safe to mark stale.
+ * The actual bunmapi will be taken care of later.
  */
 STATIC int
-xfs_attr3_leaf_freextent(
-	struct xfs_trans	**trans,
+xfs_attr3_rmt_stale(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		blkno,
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
 
@@ -57,35 +55,19 @@ xfs_attr3_leaf_freextent(
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
-		if (error) {
+		if (error)
 			return error;
-		}
-		ASSERT(nmap == 1);
-		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
+		if (XFS_IS_CORRUPT(dp->i_mount, nmap != 1))
+			return -EFSCORRUPTED;
 
 		/*
-		 * If it's a hole, these are already unmapped
-		 * so there's nothing to invalidate.
+		 * Mark any incore buffers for the remote value as stale.  We
+		 * never log remote attr value buffers, so the buffer should be
+		 * easy to kill.
 		 */
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
+		error = xfs_attr_rmtval_stale(dp, &map, 0);
+		if (error)
+			return error;
 
 		tblkno += map.br_blockcount;
 		tblkcnt -= map.br_blockcount;
@@ -174,9 +156,7 @@ xfs_attr3_leaf_inactive(
 	 */
 	error = 0;
 	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_leaf_freextent(trans, dp,
-				lp->valueblk, lp->valuelen);
-
+		tmp = xfs_attr3_rmt_stale(dp, lp->valueblk, lp->valuelen);
 		if (error == 0)
 			error = tmp;	/* save only the 1st errno */
 	}

