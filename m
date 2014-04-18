Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6583A7F66
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:58:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C0998F8049
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 17:58:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2u2DgDo1kkXc4eSH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Apr 2014 17:58:31 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s3I0wUjK015829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:30 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3I0wTSW020459
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:30 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id
	s3I0wT7j024913 for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:29 GMT
Message-ID: <535078B2.8010601@oracle.com>
Date: Fri, 18 Apr 2014 08:58:26 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 03/10] xfs: consolidate xfs_inumbers
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

To fetch the file system number tables, we currently just ignore the
errors and proceed to loop over the next AG or bump agino to the next
chunk in case of btree operations failed, that is not properly because
those errors might hint us potential file system problems.

This patch rework xfs_inumbers() to handle the btree operation errors
as well as the loop conditions.  Also, add pre-checkups for the given
inode, we can save alloc/free the format buffer once against an invalid
inode number.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 159 ++++++++++++++++++++++------------------------------
 1 file changed, 67 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f34e95a..2025bd0 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -559,12 +559,12 @@ xfs_bulkstat_single(
 int
 xfs_inumbers_fmt(
 	void			__user *ubuffer, /* buffer to write to */
-	const xfs_inogrp_t	*buffer,	/* buffer to read from */
+	const struct xfs_inogrp	*buffer,	/* buffer to read from */
 	long			count,		/* # of elements to read */
 	long			*written)	/* # of bytes written */
 {
 	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
-		return -EFAULT;
+		return XFS_ERROR(EFAULT);
 	*written = count * sizeof(*buffer);
 	return 0;
 }
@@ -574,126 +574,101 @@ xfs_inumbers_fmt(
  */
 int					/* error status */
 xfs_inumbers(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	*lastino,	/* last inode returned */
-	int		*count,		/* size of buffer/count returned */
-	void		__user *ubuffer,/* buffer with inode descriptions */
-	inumbers_fmt_pf	formatter)
+	struct xfs_mount	*mp,/* mount point for filesystem */
+	xfs_ino_t		*lastino,/* last inode returned */
+	int			*count,/* size of buffer/count returned */
+	void			__user *ubuffer,/* buffer with inode desc */
+	inumbers_fmt_pf		formatter)
 {
-	xfs_buf_t	*agbp;
-	xfs_agino_t	agino;
-	xfs_agnumber_t	agno;
-	int		bcount;
-	xfs_inogrp_t	*buffer;
-	int		bufidx;
-	xfs_btree_cur_t	*cur;
-	int		error;
-	xfs_inobt_rec_incore_t r;
-	int		i;
-	xfs_ino_t	ino;
-	int		left;
-	int		tmp;
-
-	ino = (xfs_ino_t)*lastino;
-	agno = XFS_INO_TO_AGNO(mp, ino);
-	agino = XFS_INO_TO_AGINO(mp, ino);
-	left = *count;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, *lastino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, *lastino);
+	struct xfs_btree_cur	*cur = NULL;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_inogrp	*buffer;
+	int			left = *count;
+	int			bcount;
+	int			bufidx;
+	int			error;
+
 	*count = 0;
+	if (agno >= mp->m_sb.sb_agcount ||
+	    *lastino != XFS_AGINO_TO_INO(mp, agno, agino))
+		return 0;
+
 	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
 	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
-	error = bufidx = 0;
-	cur = NULL;
-	agbp = NULL;
-	while (left > 0 && agno < mp->m_sb.sb_agcount) {
-		if (agbp == NULL) {
+	bufidx = error = 0;
+	do {
+		struct xfs_inobt_rec_incore	r;
+		int				stat;
+
+		if (!agbp) {
 			error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
-			if (error) {
-				/*
-				 * If we can't read the AGI of this ag,
-				 * then just skip to the next one.
-				 */
-				ASSERT(cur == NULL);
-				agbp = NULL;
-				agno++;
-				agino = 0;
-				continue;
-			}
+			if (error)
+				break;
 			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
 			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
-						 &tmp);
-			if (error) {
-				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-				cur = NULL;
-				xfs_buf_relse(agbp);
-				agbp = NULL;
-				/*
-				 * Move up the last inode in the current
-				 * chunk.  The lookup_ge will always get
-				 * us the first inode in the next chunk.
-				 */
-				agino += XFS_INODES_PER_CHUNK - 1;
-				continue;
-			}
-		}
-		error = xfs_inobt_get_rec(cur, &r, &i);
-		if (error || i == 0) {
-			xfs_buf_relse(agbp);
-			agbp = NULL;
-			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-			cur = NULL;
-			agno++;
-			agino = 0;
-			continue;
+						 &stat);
+			if (error)
+				break;
+			if (!stat)
+				goto next_ag;
 		}
+
+		error = xfs_inobt_get_rec(cur, &r, &stat);
+		if (error || !stat)
+			break;
+
 		agino = r.ir_startino + XFS_INODES_PER_CHUNK - 1;
 		buffer[bufidx].xi_startino =
 			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
 		buffer[bufidx].xi_alloccount =
 			XFS_INODES_PER_CHUNK - r.ir_freecount;
 		buffer[bufidx].xi_allocmask = ~r.ir_free;
-		bufidx++;
-		left--;
-		if (bufidx == bcount) {
-			long written;
-			if (formatter(ubuffer, buffer, bufidx, &written)) {
-				error = XFS_ERROR(EFAULT);
+		if (++bufidx == bcount) {
+			long	written;
+
+			error = formatter(ubuffer, buffer, bufidx, &written);
+			if (error)
 				break;
-			}
 			ubuffer += written;
 			*count += bufidx;
 			bufidx = 0;
 		}
-		if (left) {
-			error = xfs_btree_increment(cur, 0, &tmp);
-			if (error) {
-				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-				cur = NULL;
-				xfs_buf_relse(agbp);
-				agbp = NULL;
-				/*
-				 * The agino value has already been bumped.
-				 * Just try to skip up to it.
-				 */
-				agino += XFS_INODES_PER_CHUNK;
-				continue;
-			}
-		}
-	}
+		if (!--left)
+			break;
+
+		error = xfs_btree_increment(cur, 0, &stat);
+		if (error)
+			break;
+		if (stat)
+			continue;
+
+next_ag:
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+		xfs_buf_relse(agbp);
+		agbp = NULL;
+		agino = 0;
+	} while (++agno < mp->m_sb.sb_agcount);
+
 	if (!error) {
 		if (bufidx) {
-			long written;
-			if (formatter(ubuffer, buffer, bufidx, &written))
-				error = XFS_ERROR(EFAULT);
-			else
+			long	written;
+
+			error = formatter(ubuffer, buffer, bufidx, &written);
+			if (!error)
 				*count += bufidx;
 		}
 		*lastino = XFS_AGINO_TO_INO(mp, agno, agino);
 	}
+
 	kmem_free(buffer);
 	if (cur)
 		xfs_btree_del_cursor(cur, (error ? XFS_BTREE_ERROR :
 					   XFS_BTREE_NOERROR));
 	if (agbp)
 		xfs_buf_relse(agbp);
+
 	return error;
 }
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
