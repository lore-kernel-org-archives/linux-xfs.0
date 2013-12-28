Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E2F07F3F
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 05:20:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B21C304032
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 03:20:33 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FyvrBAi85wH4ReDs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 03:20:31 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBSBKU2Z030508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:20:31 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBKToC020395
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:20:30 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBKTO9002379 for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:20:29 GMT
Message-ID: <52BEB3FA.5080402@oracle.com>
Date: Sat, 28 Dec 2013 19:20:26 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/10] xfs: consolidate xfs_inumbers
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
 fs/xfs/xfs_itable.c | 163 +++++++++++++++++++++++-----------------------------
 1 file changed, 72 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 692671c..4d262f6 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -558,12 +558,12 @@ xfs_bulkstat_single(
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
@@ -573,121 +573,102 @@ xfs_inumbers_fmt(
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
+	int			left = *count;
+	struct xfs_btree_cur	*cur = NULL;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_inogrp	*buffer;
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
-			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
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
 		}
-		error = xfs_inobt_get_rec(cur, &r, &i);
-		if (error || i == 0) {
-			xfs_buf_relse(agbp);
-			agbp = NULL;
-			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-			cur = NULL;
-			agno++;
-			agino = 0;
-			continue;
+		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &stat);
+		if (error)
+			break;
+		if (!stat) {
+			/* Done, proceed to look up the next AG */
+			goto next_ag;
 		}
+
+		error = xfs_inobt_get_rec(cur, &r, &stat);
+		if (error)
+			break;
+		XFS_WANT_CORRUPTED_GOTO(stat == 1, error0);
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
+		if (!--left)
+			break;
+
+		error = xfs_btree_increment(cur, 0, &stat);
+		if (error)
+			break;
+		if (stat) {
+			/*
+			 * The agino value has already been bumped, just try
+			 * to skip up to it.
+			 */
+			agino += XFS_INODES_PER_CHUNK;
+			continue;
 		}
-	}
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
+			error = formatter(ubuffer, buffer, bufidx, &written);
+			if (!error)
 				*count += bufidx;
 		}
 		*lastino = XFS_AGINO_TO_INO(mp, agno, agino);
 	}
+
+error0:
 	kmem_free(buffer);
 	if (cur)
 		xfs_btree_del_cursor(cur, (error ? XFS_BTREE_ERROR :
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
