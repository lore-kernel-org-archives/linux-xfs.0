Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECCAC282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06ACE20678
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nxv4YyJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbgAISo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:44:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729778AbgAISo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 13:44:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdEmt130533
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xGiQJOwr0TzB/PCNOdWtZSMZ4+UPshLLb0IZ+9TJR90=;
 b=nxv4YyJ304emEybLXv6n1VWCvnCBRSruTetOuSht0tFRBuZoxBEhWqJH9WRsuuoJ2D3P
 WJydZO2C9QfOv1SARxfUpKdEwAa3sEVucNWwRJ8AUpayz1/U0VrILin5SI+m2pZaFiFw
 JNQVOrQATZMipneo9HYMBetJMPP2YljhWhG9mUuCw6+U40V/AjHpjdRbOLyUpsAuX9aM
 9cK0auTk2b4FD60jXmxiljOrIeWuqfVBXBBEs6Beif65D6LxPBO+p8aAiZmszIBRboZV
 h5s/urF+fWx5IJk7YY2P8zhMQ4OPCwEI05dfZB3ihnXnWUO3qbasf618RPDiMbQmlDJX tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xajnqcrty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdCpD171380
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xdmryueme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:56 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 009IitMR011855
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 10:44:54 -0800
Subject: [PATCH 2/5] xfs: fix memory corruption during remote attr value
 buffer invalidation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Jan 2020 10:44:54 -0800
Message-ID: <157859549406.164065.17179006268680393660.stgit@magnolia>
In-Reply-To: <157859548029.164065.5207227581806532577.stgit@magnolia>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090154
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
 fs/xfs/libxfs/xfs_attr_remote.c |   21 +++++++++++++++++++--
 fs/xfs/xfs_attr_inactive.c      |   34 ++++++----------------------------
 2 files changed, 25 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 6babdaac6057..1765f5351f9e 100644
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
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5ff49523d8ea..5c83dd3611af 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -30,17 +30,13 @@
  */
 STATIC int
 xfs_attr3_leaf_freextent(
-	struct xfs_trans	**trans,
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
 
@@ -64,28 +60,12 @@ xfs_attr3_leaf_freextent(
 		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
 
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
+		if (map.br_startblock != HOLESTARTBLOCK)
+			xfs_attr_rmtval_stale(dp, &map);
 
 		tblkno += map.br_blockcount;
 		tblkcnt -= map.br_blockcount;
@@ -174,9 +154,7 @@ xfs_attr3_leaf_inactive(
 	 */
 	error = 0;
 	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_leaf_freextent(trans, dp,
-				lp->valueblk, lp->valuelen);
-
+		tmp = xfs_attr3_leaf_freextent(dp, lp->valueblk, lp->valuelen);
 		if (error == 0)
 			error = tmp;	/* save only the 1st errno */
 	}

