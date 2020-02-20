Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80075C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C49E21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LC0HiMxP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTBpZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:45:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:45:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hmOi093308;
        Thu, 20 Feb 2020 01:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=w0/eOSYQRNTFvvjOfL48igY+UT2FcfOFwZ9N2sk5dzs=;
 b=LC0HiMxP19M/nDuoORHAPbWbiJiA6uNkHSaUcGqIhCGtC+Axr19GwuQfRjFKZJGUbXhh
 ecLi6BmmsTUrTwv1ZUYKmbVV+kpznDGtmx5TihbJThTZlTCVPqrjSRiHZCkzdRQdLwY8
 3dIQBar7aTFvLbUF2+KQ4S5E+Fp9y1r5OSDOJZAJs1Aj0kII+xmluwjf+3lvwvtPnxgU
 RHeHwfVorqyKcYKwTcOHsWhJ4104TcBhAAhRztHNSrMTvDaa4XUkT/Ne6FrbjmhCRHBI
 1+3iA9SsbZ0UvHgZyt8Uq9cs+DGabzrYhz5n1hQguHXdK2CkKegJ4rQRt7LXg+V53kE+ NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8udd6tjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gAXC146559;
        Thu, 20 Feb 2020 01:45:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2y8ud4q16p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:17 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1jGeO003945;
        Thu, 20 Feb 2020 01:45:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:45:16 -0800
Subject: [PATCH 07/14] xfs: make xfs_buf_get return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 19 Feb 2020 17:45:15 -0800
Message-ID: <158216311557.603628.14700591914069588.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=2 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=2
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 841263e93310595c30653a9f530b2d7bbeed5aae

Convert xfs_buf_get() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h       |   22 +++----
 libxfs/rdwr.c            |   11 ++--
 libxfs/xfs_attr_remote.c |    6 +-
 libxfs/xfs_sb.c          |    8 +--
 repair/phase5.c          |  138 +++++++++++++++++++++++++++++++++-------------
 5 files changed, 122 insertions(+), 63 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 06847ad5..064587a6 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -143,9 +143,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_dirty(buf, flags) \
 	libxfs_trace_dirtybuf(__FUNCTION__, __FILE__, __LINE__, \
 			      (buf), (flags))
-#define libxfs_buf_get(dev, daddr, len) \
+#define libxfs_buf_get(dev, daddr, len, bpp) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (daddr), (len))
+			    (dev), (daddr), (len), (bpp))
 #define libxfs_buf_get_map(dev, map, nmaps, flags, bpp) \
 	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags), (bpp))
@@ -161,9 +161,9 @@ int libxfs_trace_readbuf_map(const char *func, const char *file, int line,
 			const struct xfs_buf_ops *ops);
 void libxfs_trace_dirtybuf(const char *func, const char *file, int line,
 			struct xfs_buf *bp, int flags);
-struct xfs_buf *libxfs_trace_getbuf(const char *func, const char *file,
-			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
-			size_t len);
+int libxfs_trace_getbuf(const char *func, const char *file, int line,
+			struct xfs_buftarg *btp, xfs_daddr_t daddr,
+			size_t len, struct xfs_buf **bpp);
 int libxfs_trace_getbuf_map(const char *func, const char *file, int line,
 			struct xfs_buftarg *btp, struct xfs_buf_map *map,
 			int nmaps, int flags, struct xfs_buf **bpp);
@@ -180,20 +180,16 @@ int libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
 			int nmaps, int flags, struct xfs_buf **bpp);
 void	libxfs_buf_relse(struct xfs_buf *);
 
-static inline struct xfs_buf*
+static inline int
 libxfs_buf_get(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
-	size_t			numblks)
+	size_t			numblks,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
-	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	error = libxfs_buf_get_map(target, &map, 1, 0, &bp);
-	if (error)
-		return NULL;
-	return bp;
+	return libxfs_buf_get_map(target, &map, 1, 0, bpp);
 }
 
 static inline struct xfs_buf*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 222ef441..a05e0fee 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -458,21 +458,22 @@ libxfs_trace_dirtybuf(
 	libxfs_buf_dirty(bp, flags);
 }
 
-struct xfs_buf *
+int
 libxfs_trace_getbuf(
 	const char		*func,
 	const char		*file,
 	int			line,
 	struct xfs_buftarg	*btp,
 	xfs_daddr_t		blkno,
-	size_t			len)
+	size_t			len,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
+	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	libxfs_buf_get_map(target, &map, 1, 0, &bp);
+	error = libxfs_buf_get_map(target, &map, 1, 0, bpp);
 	__add_trace(bp, func, file, line);
-	return bp;
+	return error;
 }
 
 int
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 00371bdc..88163ea8 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -544,9 +544,9 @@ xfs_attr_rmtval_set(
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt);
-		if (!bp)
-			return -ENOMEM;
+		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, &bp);
+		if (error)
+			return error;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 
 		xfs_attr_rmtval_copyin(mp, bp, args->dp->i_ino, &offset,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 4f750d19..d3d5e11d 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -962,9 +962,9 @@ xfs_update_secondary_sbs(
 	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
 		struct xfs_buf		*bp;
 
-		bp = xfs_buf_get(mp->m_ddev_targp,
+		error = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-				 XFS_FSS_TO_BB(mp, 1));
+				 XFS_FSS_TO_BB(mp, 1), &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
@@ -972,12 +972,12 @@ xfs_update_secondary_sbs(
 		 * superblocks un-updated than updated, and xfs_repair may
 		 * pick them over the properly-updated primary.
 		 */
-		if (!bp) {
+		if (error) {
 			xfs_warn(mp,
 		"error allocating secondary superblock for ag %d",
 				agno);
 			if (!saved_error)
-				saved_error = -ENOMEM;
+				saved_error = error;
 			continue;
 		}
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 561a6b3f..a505715f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -652,6 +652,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
 	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
+	int			error;
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
@@ -692,9 +693,13 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 
 		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
 
-		lptr->buf_p = libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+		error = -libxfs_buf_get(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
+		if (error)
+			do_error(
+	_("Cannot grab free space btree buffer, err=%d"),
+					error);
 		lptr->agbno = agbno;
 
 		if (lptr->modulo)
@@ -752,6 +757,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	bt_stat_level_t		*lptr;
 	xfs_extlen_t		freeblks;
 	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
+	int			error;
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
@@ -770,9 +776,13 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		lptr = &btree_curs->level[i];
 
 		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+		error = -libxfs_buf_get(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
+		if (error)
+			do_error(
+	_("Cannot grab free space btree buffer, err=%d"),
+					error);
 
 		if (i == btree_curs->num_levels - 1)
 			btree_curs->root = agbno;
@@ -881,9 +891,14 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
 			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
 
-			lptr->buf_p = libxfs_buf_get(mp->m_dev,
+			error = -libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
-					XFS_FSB_TO_BB(mp, 1));
+					XFS_FSB_TO_BB(mp, 1),
+					&lptr->buf_p);
+			if (error)
+				do_error(
+	_("Cannot grab free space btree buffer, err=%d"),
+						error);
 		}
 	}
 
@@ -1021,6 +1036,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
 	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
+	int			error;
 
 	level++;
 
@@ -1059,9 +1075,12 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 
 		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
 
-		lptr->buf_p = libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+		error = -libxfs_buf_get(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
+		if (error)
+			do_error(_("Cannot grab inode btree buffer, err=%d"),
+					error);
 		lptr->agbno = agbno;
 
 		if (lptr->modulo)
@@ -1108,10 +1127,14 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	xfs_buf_t	*agi_buf;
 	xfs_agi_t	*agi;
 	int		i;
+	int		error;
 
-	agi_buf = libxfs_buf_get(mp->m_dev,
+	error = -libxfs_buf_get(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			mp->m_sb.sb_sectsize/BBSIZE);
+			mp->m_sb.sb_sectsize / BBSIZE, &agi_buf);
+	if (error)
+		do_error(_("Cannot grab AG %u AGI buffer, err=%d"),
+				agno, error);
 	agi_buf->b_ops = &xfs_agi_buf_ops;
 	agi = XFS_BUF_TO_AGI(agi_buf);
 	memset(agi, 0, mp->m_sb.sb_sectsize);
@@ -1173,6 +1196,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	int			spmask;
 	uint64_t		sparse;
 	uint16_t		holemask;
+	int			error;
 
 	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);
 
@@ -1180,9 +1204,12 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		lptr = &btree_curs->level[i];
 
 		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+		error = -libxfs_buf_get(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
+		if (error)
+			do_error(_("Cannot grab inode btree buffer, err=%d"),
+					error);
 
 		if (i == btree_curs->num_levels - 1)
 			btree_curs->root = agbno;
@@ -1313,9 +1340,14 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
 			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
 
-			lptr->buf_p = libxfs_buf_get(mp->m_dev,
+			error = -libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
-					XFS_FSB_TO_BB(mp, 1));
+					XFS_FSB_TO_BB(mp, 1),
+					&lptr->buf_p);
+			if (error)
+				do_error(
+	_("Cannot grab inode btree buffer, err=%d"),
+						error);
 		}
 	}
 
@@ -1429,6 +1461,7 @@ prop_rmap_cursor(
 	xfs_agblock_t		agbno;
 	struct bt_stat_level	*lptr;
 	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
+	int			error;
 
 	level++;
 
@@ -1467,9 +1500,12 @@ prop_rmap_cursor(
 
 		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
 
-		lptr->buf_p = libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+		error = -libxfs_buf_get(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
+		if (error)
+			do_error(_("Cannot grab rmapbt buffer, err=%d"),
+					error);
 		lptr->agbno = agbno;
 
 		if (lptr->modulo)
@@ -1577,9 +1613,12 @@ build_rmap_tree(
 		lptr = &btree_curs->level[i];
 
 		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+		error = -libxfs_buf_get(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
+		if (error)
+			do_error(_("Cannot grab rmapbt buffer, err=%d"),
+					error);
 
 		if (i == btree_curs->num_levels - 1)
 			btree_curs->root = agbno;
@@ -1677,9 +1716,14 @@ _("Insufficient memory to construct reverse-map cursor."));
 			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
 			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
 
-			lptr->buf_p = libxfs_buf_get(mp->m_dev,
+			error = -libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
-					XFS_FSB_TO_BB(mp, 1));
+					XFS_FSB_TO_BB(mp, 1),
+					&lptr->buf_p);
+			if (error)
+				do_error(
+	_("Cannot grab rmapbt buffer, err=%d"),
+						error);
 		}
 	}
 	free_slab_cursor(&rmap_cur);
@@ -1781,6 +1825,7 @@ prop_refc_cursor(
 	xfs_agblock_t		agbno;
 	struct bt_stat_level	*lptr;
 	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_REFC);
+	int			error;
 
 	level++;
 
@@ -1819,9 +1864,12 @@ prop_refc_cursor(
 
 		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
 
-		lptr->buf_p = libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+		error = -libxfs_buf_get(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
+		if (error)
+			do_error(_("Cannot grab refcountbt buffer, err=%d"),
+					error);
 		lptr->agbno = agbno;
 
 		if (lptr->modulo)
@@ -1884,9 +1932,12 @@ build_refcount_tree(
 		lptr = &btree_curs->level[i];
 
 		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+		error = -libxfs_buf_get(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
+		if (error)
+			do_error(_("Cannot grab refcountbt buffer, err=%d"),
+					error);
 
 		if (i == btree_curs->num_levels - 1)
 			btree_curs->root = agbno;
@@ -1972,9 +2023,14 @@ _("Insufficient memory to construct refcount cursor."));
 			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
 			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
 
-			lptr->buf_p = libxfs_buf_get(mp->m_dev,
+			error = -libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
-					XFS_FSB_TO_BB(mp, 1));
+					XFS_FSB_TO_BB(mp, 1),
+					&lptr->buf_p);
+			if (error)
+				do_error(
+	_("Cannot grab refcountbt buffer, err=%d"),
+						error);
 		}
 	}
 	free_slab_cursor(&refc_cur);
@@ -2007,9 +2063,12 @@ build_agf_agfl(
 	__be32			*freelist;
 	int			error;
 
-	agf_buf = libxfs_buf_get(mp->m_dev,
+	error = -libxfs_buf_get(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			mp->m_sb.sb_sectsize/BBSIZE);
+			mp->m_sb.sb_sectsize / BBSIZE, &agf_buf);
+	if (error)
+		do_error(_("Cannot grab AG %u AGF buffer, err=%d"),
+				agno, error);
 	agf_buf->b_ops = &xfs_agf_buf_ops;
 	agf = XFS_BUF_TO_AGF(agf_buf);
 	memset(agf, 0, mp->m_sb.sb_sectsize);
@@ -2079,9 +2138,12 @@ build_agf_agfl(
 		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* initialise the AGFL, then fill it if there are blocks left over. */
-	agfl_buf = libxfs_buf_get(mp->m_dev,
+	error = -libxfs_buf_get(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-			mp->m_sb.sb_sectsize/BBSIZE);
+			mp->m_sb.sb_sectsize / BBSIZE, &agfl_buf);
+	if (error)
+		do_error(_("Cannot grab AG %u AGFL buffer, err=%d"),
+				agno, error);
 	agfl_buf->b_ops = &xfs_agfl_buf_ops;
 	agfl = XFS_BUF_TO_AGFL(agfl_buf);
 

