Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfAACUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:20:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012Eu1i019131
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:30 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pp0btp79v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:20:30 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012KOXh026528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:25 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012KOxG027479
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:24 GMT
Subject: [PATCH 13/22] xfs: hoist xfs_iunlink to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:20:23 -0800
Message-ID: <154630922342.18437.8517945462006681478.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move xfs_iunlink and xfs_iunlink_remove to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |  267 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    3 
 fs/xfs/xfs_inode.c             |  268 ----------------------------------------
 3 files changed, 270 insertions(+), 268 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index fa9baea5be6d..b67d72cb8e38 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -16,6 +16,7 @@
 #include "xfs_inode_util.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
+#include "xfs_error.h"
 
 /*
  * helper function to extract extent size hint from inode
@@ -519,3 +520,269 @@ xfs_dir_ialloc(
 
 	return 0;
 }
+
+/*
+ * This is called when the inode's link count goes to 0 or we are creating a
+ * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
+ * set to true as the link count is dropped to zero by the VFS after we've
+ * created the file successfully, so we have to add it to the unlinked list
+ * while the link count is non-zero.
+ *
+ * We place the on-disk inode on a list in the AGI.  It will be pulled from this
+ * list when the inode is freed.
+ */
+int
+xfs_iunlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*agibp;
+	struct xfs_buf		*ibp;
+	xfs_agino_t		agino;
+	short			bucket_index;
+	int			offset;
+	int			error;
+
+	ASSERT(VFS_I(ip)->i_mode != 0);
+
+	/*
+	 * Get the agi buffer first.  It ensures lock ordering
+	 * on the list.
+	 */
+	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
+	if (error)
+		return error;
+	agi = XFS_BUF_TO_AGI(agibp);
+
+	/*
+	 * Get the index into the agi hash table for the
+	 * list this inode will go on.
+	 */
+	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	ASSERT(agino != 0);
+	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	ASSERT(agi->agi_unlinked[bucket_index]);
+	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
+
+	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
+		/*
+		 * There is already another inode in the bucket we need
+		 * to add ourselves to.  Add us at the front of the list.
+		 * Here we put the head pointer into our next pointer,
+		 * and then we fall through to point the head at us.
+		 */
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
+		if (error)
+			return error;
+
+		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
+		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
+		offset = ip->i_imap.im_boffset +
+			offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc the inode CRC if appropriate */
+		xfs_dinode_calc_crc(mp, dip);
+
+		xfs_trans_inode_buf(tp, ibp);
+		xfs_trans_log_buf(tp, ibp, offset,
+				  (offset + sizeof(xfs_agino_t) - 1));
+		xfs_inobp_check(mp, ibp);
+	}
+
+	/*
+	 * Point the bucket head pointer at the inode being inserted.
+	 */
+	ASSERT(agino != 0);
+	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
+	offset = offsetof(xfs_agi_t, agi_unlinked) +
+		(sizeof(xfs_agino_t) * bucket_index);
+	xfs_trans_log_buf(tp, agibp, offset,
+			  (offset + sizeof(xfs_agino_t) - 1));
+	return 0;
+}
+
+/*
+ * Pull the on-disk inode from the AGI unlinked list.
+ */
+int
+xfs_iunlink_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp;
+	struct xfs_agi		*agi;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*agibp;
+	struct xfs_buf		*ibp;
+	struct xfs_buf		*last_ibp;
+	struct xfs_dinode	*last_dip = NULL;
+	xfs_ino_t		next_ino;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	xfs_agino_t		next_agino;
+	short			bucket_index;
+	int			offset, last_offset = 0;
+	int			error;
+
+	mp = tp->t_mountp;
+	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+
+	/*
+	 * Get the agi buffer first.  It ensures lock ordering
+	 * on the list.
+	 */
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(agibp);
+
+	/*
+	 * Get the index into the agi hash table for the
+	 * list this inode will go on.
+	 */
+	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	if (!xfs_verify_agino(mp, agno, agino))
+		return -EFSCORRUPTED;
+	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	if (!xfs_verify_agino(mp, agno,
+			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				agi, sizeof(*agi));
+		return -EFSCORRUPTED;
+	}
+
+	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
+		/*
+		 * We're at the head of the list.  Get the inode's on-disk
+		 * buffer to see if there is anyone after us on the list.
+		 * Only modify our next pointer if it is not already NULLAGINO.
+		 * This saves us the overhead of dealing with the buffer when
+		 * there is no need to change it.
+		 */
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
+		if (error) {
+			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
+				__func__, error);
+			return error;
+		}
+		next_agino = be32_to_cpu(dip->di_next_unlinked);
+		ASSERT(next_agino != 0);
+		if (next_agino != NULLAGINO) {
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+			offset = ip->i_imap.im_boffset +
+				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc the inode CRC if appropriate */
+			xfs_dinode_calc_crc(mp, dip);
+
+			xfs_trans_inode_buf(tp, ibp);
+			xfs_trans_log_buf(tp, ibp, offset,
+					  (offset + sizeof(xfs_agino_t) - 1));
+			xfs_inobp_check(mp, ibp);
+		} else {
+			xfs_trans_brelse(tp, ibp);
+		}
+		/*
+		 * Point the bucket head pointer at the next inode.
+		 */
+		ASSERT(next_agino != 0);
+		ASSERT(next_agino != agino);
+		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
+		offset = offsetof(xfs_agi_t, agi_unlinked) +
+			(sizeof(xfs_agino_t) * bucket_index);
+		xfs_trans_log_buf(tp, agibp, offset,
+				  (offset + sizeof(xfs_agino_t) - 1));
+	} else {
+		/*
+		 * We need to search the list for the inode being freed.
+		 */
+		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+		last_ibp = NULL;
+		while (next_agino != agino) {
+			struct xfs_imap	imap;
+
+			if (last_ibp)
+				xfs_trans_brelse(tp, last_ibp);
+
+			imap.im_blkno = 0;
+			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
+
+			error = xfs_imap(mp, tp, next_ino, &imap, 0);
+			if (error) {
+				xfs_warn(mp,
+	"%s: xfs_imap returned error %d.",
+					 __func__, error);
+				return error;
+			}
+
+			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
+					       &last_ibp, 0, 0);
+			if (error) {
+				xfs_warn(mp,
+	"%s: xfs_imap_to_bp returned error %d.",
+					__func__, error);
+				return error;
+			}
+
+			last_offset = imap.im_boffset;
+			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
+			if (!xfs_verify_agino(mp, agno, next_agino)) {
+				XFS_CORRUPTION_ERROR(__func__,
+						XFS_ERRLEVEL_LOW, mp,
+						last_dip, sizeof(*last_dip));
+				return -EFSCORRUPTED;
+			}
+		}
+
+		/*
+		 * Now last_ibp points to the buffer previous to us on the
+		 * unlinked list.  Pull us from the list.
+		 */
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
+		if (error) {
+			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
+				__func__, error);
+			return error;
+		}
+		next_agino = be32_to_cpu(dip->di_next_unlinked);
+		ASSERT(next_agino != 0);
+		ASSERT(next_agino != agino);
+		if (next_agino != NULLAGINO) {
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+			offset = ip->i_imap.im_boffset +
+				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc the inode CRC if appropriate */
+			xfs_dinode_calc_crc(mp, dip);
+
+			xfs_trans_inode_buf(tp, ibp);
+			xfs_trans_log_buf(tp, ibp, offset,
+					  (offset + sizeof(xfs_agino_t) - 1));
+			xfs_inobp_check(mp, ibp);
+		} else {
+			xfs_trans_brelse(tp, ibp);
+		}
+		/*
+		 * Point the previous inode on the list to the next inode.
+		 */
+		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
+		ASSERT(next_agino != 0);
+		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc the inode CRC if appropriate */
+		xfs_dinode_calc_crc(mp, last_dip);
+
+		xfs_trans_inode_buf(tp, last_ibp);
+		xfs_trans_log_buf(tp, last_ibp, offset,
+				  (offset + sizeof(xfs_agino_t) - 1));
+		xfs_inobp_check(mp, last_ibp);
+	}
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 5e2608f99fad..bb403d3386ad 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -96,4 +96,7 @@ extern const struct xfs_ialloc_ops xfs_default_ialloc_ops;
 int xfs_dir_ialloc(struct xfs_trans **tpp, const struct xfs_ialloc_args *args,
 		   struct xfs_inode **ipp);
 
+int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_inode *ip);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 167fe4ec48bd..30c2f1076db0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -47,8 +47,6 @@
 kmem_zone_t *xfs_inode_zone;
 
 STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
-STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
-STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
 
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
@@ -1653,272 +1651,6 @@ xfs_inactive(
 	xfs_qm_dqdetach(ip);
 }
 
-/*
- * This is called when the inode's link count goes to 0 or we are creating a
- * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
- * set to true as the link count is dropped to zero by the VFS after we've
- * created the file successfully, so we have to add it to the unlinked list
- * while the link count is non-zero.
- *
- * We place the on-disk inode on a list in the AGI.  It will be pulled from this
- * list when the inode is freed.
- */
-STATIC int
-xfs_iunlink(
-	struct xfs_trans *tp,
-	struct xfs_inode *ip)
-{
-	xfs_mount_t	*mp = tp->t_mountp;
-	xfs_agi_t	*agi;
-	xfs_dinode_t	*dip;
-	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
-	xfs_agino_t	agino;
-	short		bucket_index;
-	int		offset;
-	int		error;
-
-	ASSERT(VFS_I(ip)->i_mode != 0);
-
-	/*
-	 * Get the agi buffer first.  It ensures lock ordering
-	 * on the list.
-	 */
-	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
-	if (error)
-		return error;
-	agi = XFS_BUF_TO_AGI(agibp);
-
-	/*
-	 * Get the index into the agi hash table for the
-	 * list this inode will go on.
-	 */
-	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	ASSERT(agino != 0);
-	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	ASSERT(agi->agi_unlinked[bucket_index]);
-	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
-
-	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
-		/*
-		 * There is already another inode in the bucket we need
-		 * to add ourselves to.  Add us at the front of the list.
-		 * Here we put the head pointer into our next pointer,
-		 * and then we fall through to point the head at us.
-		 */
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
-				       0, 0);
-		if (error)
-			return error;
-
-		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
-		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
-		offset = ip->i_imap.im_boffset +
-			offsetof(xfs_dinode_t, di_next_unlinked);
-
-		/* need to recalc the inode CRC if appropriate */
-		xfs_dinode_calc_crc(mp, dip);
-
-		xfs_trans_inode_buf(tp, ibp);
-		xfs_trans_log_buf(tp, ibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
-		xfs_inobp_check(mp, ibp);
-	}
-
-	/*
-	 * Point the bucket head pointer at the inode being inserted.
-	 */
-	ASSERT(agino != 0);
-	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
-	offset = offsetof(xfs_agi_t, agi_unlinked) +
-		(sizeof(xfs_agino_t) * bucket_index);
-	xfs_trans_log_buf(tp, agibp, offset,
-			  (offset + sizeof(xfs_agino_t) - 1));
-	return 0;
-}
-
-/*
- * Pull the on-disk inode from the AGI unlinked list.
- */
-STATIC int
-xfs_iunlink_remove(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip)
-{
-	xfs_ino_t	next_ino;
-	xfs_mount_t	*mp;
-	xfs_agi_t	*agi;
-	xfs_dinode_t	*dip;
-	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
-	xfs_agnumber_t	agno;
-	xfs_agino_t	agino;
-	xfs_agino_t	next_agino;
-	xfs_buf_t	*last_ibp;
-	xfs_dinode_t	*last_dip = NULL;
-	short		bucket_index;
-	int		offset, last_offset = 0;
-	int		error;
-
-	mp = tp->t_mountp;
-	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-
-	/*
-	 * Get the agi buffer first.  It ensures lock ordering
-	 * on the list.
-	 */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
-
-	agi = XFS_BUF_TO_AGI(agibp);
-
-	/*
-	 * Get the index into the agi hash table for the
-	 * list this inode will go on.
-	 */
-	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	if (!xfs_verify_agino(mp, agno, agino))
-		return -EFSCORRUPTED;
-	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	if (!xfs_verify_agino(mp, agno,
-			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				agi, sizeof(*agi));
-		return -EFSCORRUPTED;
-	}
-
-	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
-		/*
-		 * We're at the head of the list.  Get the inode's on-disk
-		 * buffer to see if there is anyone after us on the list.
-		 * Only modify our next pointer if it is not already NULLAGINO.
-		 * This saves us the overhead of dealing with the buffer when
-		 * there is no need to change it.
-		 */
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
-				       0, 0);
-		if (error) {
-			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
-				__func__, error);
-			return error;
-		}
-		next_agino = be32_to_cpu(dip->di_next_unlinked);
-		ASSERT(next_agino != 0);
-		if (next_agino != NULLAGINO) {
-			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			offset = ip->i_imap.im_boffset +
-				offsetof(xfs_dinode_t, di_next_unlinked);
-
-			/* need to recalc the inode CRC if appropriate */
-			xfs_dinode_calc_crc(mp, dip);
-
-			xfs_trans_inode_buf(tp, ibp);
-			xfs_trans_log_buf(tp, ibp, offset,
-					  (offset + sizeof(xfs_agino_t) - 1));
-			xfs_inobp_check(mp, ibp);
-		} else {
-			xfs_trans_brelse(tp, ibp);
-		}
-		/*
-		 * Point the bucket head pointer at the next inode.
-		 */
-		ASSERT(next_agino != 0);
-		ASSERT(next_agino != agino);
-		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
-		offset = offsetof(xfs_agi_t, agi_unlinked) +
-			(sizeof(xfs_agino_t) * bucket_index);
-		xfs_trans_log_buf(tp, agibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
-	} else {
-		/*
-		 * We need to search the list for the inode being freed.
-		 */
-		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-		last_ibp = NULL;
-		while (next_agino != agino) {
-			struct xfs_imap	imap;
-
-			if (last_ibp)
-				xfs_trans_brelse(tp, last_ibp);
-
-			imap.im_blkno = 0;
-			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
-
-			error = xfs_imap(mp, tp, next_ino, &imap, 0);
-			if (error) {
-				xfs_warn(mp,
-	"%s: xfs_imap returned error %d.",
-					 __func__, error);
-				return error;
-			}
-
-			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
-					       &last_ibp, 0, 0);
-			if (error) {
-				xfs_warn(mp,
-	"%s: xfs_imap_to_bp returned error %d.",
-					__func__, error);
-				return error;
-			}
-
-			last_offset = imap.im_boffset;
-			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
-			if (!xfs_verify_agino(mp, agno, next_agino)) {
-				XFS_CORRUPTION_ERROR(__func__,
-						XFS_ERRLEVEL_LOW, mp,
-						last_dip, sizeof(*last_dip));
-				return -EFSCORRUPTED;
-			}
-		}
-
-		/*
-		 * Now last_ibp points to the buffer previous to us on the
-		 * unlinked list.  Pull us from the list.
-		 */
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
-				       0, 0);
-		if (error) {
-			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
-				__func__, error);
-			return error;
-		}
-		next_agino = be32_to_cpu(dip->di_next_unlinked);
-		ASSERT(next_agino != 0);
-		ASSERT(next_agino != agino);
-		if (next_agino != NULLAGINO) {
-			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			offset = ip->i_imap.im_boffset +
-				offsetof(xfs_dinode_t, di_next_unlinked);
-
-			/* need to recalc the inode CRC if appropriate */
-			xfs_dinode_calc_crc(mp, dip);
-
-			xfs_trans_inode_buf(tp, ibp);
-			xfs_trans_log_buf(tp, ibp, offset,
-					  (offset + sizeof(xfs_agino_t) - 1));
-			xfs_inobp_check(mp, ibp);
-		} else {
-			xfs_trans_brelse(tp, ibp);
-		}
-		/*
-		 * Point the previous inode on the list to the next inode.
-		 */
-		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
-		ASSERT(next_agino != 0);
-		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
-
-		/* need to recalc the inode CRC if appropriate */
-		xfs_dinode_calc_crc(mp, last_dip);
-
-		xfs_trans_inode_buf(tp, last_ibp);
-		xfs_trans_log_buf(tp, last_ibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
-		xfs_inobp_check(mp, last_ibp);
-	}
-	return 0;
-}
-
 /*
  * A big issue when freeing the inode cluster is that we _cannot_ skip any
  * inodes that are in memory - they all must be marked stale and attached to
