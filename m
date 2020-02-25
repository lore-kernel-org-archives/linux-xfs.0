Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213F4C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E09E221927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KjQ9N7Wj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgBYAPc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:15:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAPc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:15:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08dLG130005;
        Tue, 25 Feb 2020 00:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hAx+CTyEeo2HXeUK9UVkSlzaweneMHlNlrpyHE8gwno=;
 b=KjQ9N7Wj2k8bODzPtyq3/MoQw7K++KTLYQAfzJ4VCdfV72o3gSek6TMe05SrDyiZeJXv
 Ymih9rVX0c+qqIuYkisbL+kqzJW/ZIxC+La3AALSozOgqQm+6Yw5UDlFEqn0RXQbUnXR
 H54OzInsd5HqvYSDdcIoX5izZxfUK7F2vIGrCiOsmluhGF3f2+OlVtN0RUbn4JQIVThM
 MbecM4Qkyqb34/QQSXWx1fYtz43W4NiRaRASTcacK0EvX90DUAXggml7P2MOqeMQ1pMG
 Xl18gdh2K+h/D6Pvxwv80F+9eje9/Vh5iyYs9UgZyNgZGBxXaFeWBzYo0pulomuxw/ln Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yavxrjs37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P088Wo158191;
        Tue, 25 Feb 2020 00:15:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yby5e9umm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0FNJ5001687;
        Tue, 25 Feb 2020 00:15:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:15:23 -0800
Subject: [PATCH 11/14] xfs: make xfs_trans_get_buf return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Mon, 24 Feb 2020 16:15:22 -0800
Message-ID: <158258972213.453666.11693993244847448504.stgit@magnolia>
In-Reply-To: <158258964941.453666.10913737544282124969.stgit@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: ce92464c180b60e79022bdf1175b7737a11f59b7

Convert xfs_trans_get_buf() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |   12 ++++--------
 libxfs/xfs_btree.c  |   23 ++++++++++++++++-------
 libxfs/xfs_ialloc.c |   12 ++++++------
 libxfs/xfs_sb.c     |    9 +++++----
 mkfs/proto.c        |   10 ++++++++--
 5 files changed, 39 insertions(+), 27 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 33ab5d73..16e2a468 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -114,22 +114,18 @@ int	libxfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
 				  struct xfs_buf_map *map, int nmaps,
 				  xfs_buf_flags_t flags, struct xfs_buf **bpp,
 				  const struct xfs_buf_ops *ops);
-static inline struct xfs_buf *
+static inline int
 libxfs_trans_get_buf(
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*btp,
 	xfs_daddr_t		blkno,
 	int			numblks,
-	uint			flags)
+	uint			flags,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
-	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	error = libxfs_trans_get_buf_map(tp, btp, &map, 1, flags, &bp);
-	if (error)
-		return NULL;
-	return bp;
+	return libxfs_trans_get_buf_map(tp, btp, &map, 1, flags, bpp);
 }
 
 static inline int
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index ead05a46..aeaa9623 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -685,11 +685,16 @@ xfs_btree_get_bufl(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_fsblock_t	fsbno)		/* file system block number */
 {
+	struct xfs_buf		*bp;
 	xfs_daddr_t		d;		/* real disk block address */
+	int			error;
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0);
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 /*
@@ -703,12 +708,17 @@ xfs_btree_get_bufs(
 	xfs_agnumber_t	agno,		/* allocation group number */
 	xfs_agblock_t	agbno)		/* allocation group block number */
 {
+	struct xfs_buf		*bp;
 	xfs_daddr_t		d;		/* real disk block address */
+	int			error;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agbno != NULLAGBLOCK);
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0);
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 /*
@@ -1267,11 +1277,10 @@ xfs_btree_get_buf_block(
 	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
 	if (error)
 		return error;
-	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
-				 mp->m_bsize, 0);
-
-	if (!*bpp)
-		return -ENOMEM;
+	error = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d, mp->m_bsize,
+			0, bpp);
+	if (error)
+		return error;
 
 	(*bpp)->b_ops = cur->bc_ops->buf_ops;
 	*block = XFS_BUF_TO_BLOCK(*bpp);
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index baa99551..00b33263 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -271,6 +271,7 @@ xfs_ialloc_inode_init(
 	int			i, j;
 	xfs_daddr_t		d;
 	xfs_ino_t		ino = 0;
+	int			error;
 
 	/*
 	 * Loop over the new block(s), filling in the inodes.  For small block
@@ -322,12 +323,11 @@ xfs_ialloc_inode_init(
 		 */
 		d = XFS_AGB_TO_DADDR(mp, agno, agbno +
 				(j * M_IGEO(mp)->blocks_per_cluster));
-		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					 mp->m_bsize *
-					 M_IGEO(mp)->blocks_per_cluster,
-					 XBF_UNMAPPED);
-		if (!fbuf)
-			return -ENOMEM;
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+				mp->m_bsize * M_IGEO(mp)->blocks_per_cluster,
+				XBF_UNMAPPED, &fbuf);
+		if (error)
+			return error;
 
 		/* Initialize the inode buffers and log them appropriately. */
 		fbuf->b_ops = &xfs_inode_buf_ops;
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d3d5e11d..687e33d8 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1162,13 +1162,14 @@ xfs_sb_get_secondary(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	ASSERT(agno != 0 && agno != NULLAGNUMBER);
-	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0);
-	if (!bp)
-		return -ENOMEM;
+			XFS_FSS_TO_BB(mp, 1), 0, &bp);
+	if (error)
+		return error;
 	bp->b_ops = &xfs_sb_buf_ops;
 	xfs_buf_oneshot(bp);
 	*bpp = bp;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 26a613fe..ab01c8b0 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -254,8 +254,14 @@ newfile(
 			exit(1);
 		}
 		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-		bp = libxfs_trans_get_buf(logit ? tp : NULL, mp->m_dev, d,
-			nb << mp->m_blkbb_log, 0);
+		error = -libxfs_trans_get_buf(logit ? tp : NULL, mp->m_dev, d,
+				nb << mp->m_blkbb_log, 0, &bp);
+		if (error) {
+			fprintf(stderr,
+				_("%s: cannot allocate buffer for file\n"),
+				progname);
+			exit(1);
+		}
 		memmove(bp->b_addr, buf, len);
 		if (len < bp->b_bcount)
 			memset((char *)bp->b_addr + len, 0, bp->b_bcount - len);

