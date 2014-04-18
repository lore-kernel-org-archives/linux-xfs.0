Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 109867F66
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:58:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E887E304043
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 17:58:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bF2iTYP4FJLHGRvG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Apr 2014 17:58:34 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s3I0wXl8015869
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:34 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	s3I0wWrA024978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:33 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3I0wWLr015870 for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:32 GMT
Message-ID: <535078B5.4010700@oracle.com>
Date: Fri, 18 Apr 2014 08:58:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 04/10] xfs: introduce per allocation group inumbers
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

Introduce xfs_perag_inumbers(), it could be used to fetch the inode number
tables per allocation group via a new ioctl(2) in the future.  Also, that
would be a net win considering the scalability for a file system with huge
number of inodes as multiple allocation groups can be scanned in parallel,
refactor xfs_inumbers() with it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 179 ++++++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_itable.h |  13 +++-
 2 files changed, 123 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2025bd0..62cf2f8 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -570,105 +570,150 @@ xfs_inumbers_fmt(
 }
 
 /*
- * Return inode number table for the filesystem.
+ * Return inode number table in an allocation group.  Record how many elements
+ * have been written out and update the last allocation group inode number on
+ * success.  Otherwise, those values will remain the same and return error.
  */
-int					/* error status */
-xfs_inumbers(
-	struct xfs_mount	*mp,/* mount point for filesystem */
-	xfs_ino_t		*lastino,/* last inode returned */
-	int			*count,/* size of buffer/count returned */
-	void			__user *ubuffer,/* buffer with inode desc */
+static int
+xfs_perag_inumbers(
+	struct xfs_mount	*mp,
+	struct xfs_aginumbers	*aip,
+	struct xfs_inogrp	*buffer,
+	int			bcount,
 	inumbers_fmt_pf		formatter)
 {
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, *lastino);
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, *lastino);
-	struct xfs_btree_cur	*cur = NULL;
-	struct xfs_buf		*agbp = NULL;
-	struct xfs_inogrp	*buffer;
-	int			left = *count;
-	int			bcount;
-	int			bufidx;
+	xfs_agnumber_t		agno = aip->ai_agno;
+	xfs_agino_t		agino = *(aip->ai_lastip);
+	char			*ubuffer = aip->ai_ubuffer;
+	int			ubleft = aip->ai_icount;
+	int			bufidx = 0;
+	long			count = 0;/* # elements written out */
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agbp;
+	struct xfs_btree_cur	*cur;
+	int			stat;
 	int			error;
 
-	*count = 0;
-	if (agno >= mp->m_sb.sb_agcount ||
-	    *lastino != XFS_AGINO_TO_INO(mp, agno, agino))
-		return 0;
-
-	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
-	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
-	bufidx = error = 0;
-	do {
+	error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
+	if (error)
+		return error;
+	agi = XFS_BUF_TO_AGI(agbp);
+	cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
+	/* Done if failed to lookup or no inode chuck is found */
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &stat);
+	if (error || !stat)
+		goto error0;
+
+	for (;;) {
 		struct xfs_inobt_rec_incore	r;
-		int				stat;
-
-		if (!agbp) {
-			error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
-			if (error)
-				break;
-			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
-			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
-						 &stat);
-			if (error)
-				break;
-			if (!stat)
-				goto next_ag;
-		}
 
 		error = xfs_inobt_get_rec(cur, &r, &stat);
-		if (error || !stat)
+		if (error || !stat) {
+			pr_info("xfs_inobt_get_rec: stat=%d\n", stat);
 			break;
+		}
 
 		agino = r.ir_startino + XFS_INODES_PER_CHUNK - 1;
-		buffer[bufidx].xi_startino =
-			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
-		buffer[bufidx].xi_alloccount =
-			XFS_INODES_PER_CHUNK - r.ir_freecount;
+		buffer[bufidx].xi_startino = XFS_AGINO_TO_INO(mp, agno,
+							      r.ir_startino);
+		buffer[bufidx].xi_alloccount = XFS_INODES_PER_CHUNK -
+					       r.ir_freecount;
 		buffer[bufidx].xi_allocmask = ~r.ir_free;
-		if (++bufidx == bcount) {
+		/* Run out of the given buffer range, it's time to write out */
+		if (++bufidx == ubleft) {
 			long	written;
 
 			error = formatter(ubuffer, buffer, bufidx, &written);
 			if (error)
 				break;
-			ubuffer += written;
-			*count += bufidx;
+			count += bufidx;
 			bufidx = 0;
+			break;
 		}
-		if (!--left)
+		if (!--ubleft)
 			break;
 
+		/* Done if failed or there are no rightward entries */
 		error = xfs_btree_increment(cur, 0, &stat);
-		if (error)
+		if (error || !stat)
 			break;
-		if (stat)
-			continue;
-
-next_ag:
-		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-		cur = NULL;
-		xfs_buf_relse(agbp);
-		agbp = NULL;
-		agino = 0;
-	} while (++agno < mp->m_sb.sb_agcount);
+	}
 
 	if (!error) {
+		/*
+		 * There might have remaining inode number tables reside in
+		 * buffer which have not yet been written out if we iterate
+		 * beyond inode btree.  We need to handle them separately.
+		 */
 		if (bufidx) {
 			long	written;
 
 			error = formatter(ubuffer, buffer, bufidx, &written);
-			if (!error)
-				*count += bufidx;
+			if (error)
+				goto error0;
+			count += bufidx;
 		}
-		*lastino = XFS_AGINO_TO_INO(mp, agno, agino);
+		/* Update the last AG inode number */
+		*(aip->ai_lastip) = agino;
+		/* Record how many elements have been written out */
+		aip->ai_ocount = count;
 	}
 
-	kmem_free(buffer);
-	if (cur)
-		xfs_btree_del_cursor(cur, (error ? XFS_BTREE_ERROR :
-					   XFS_BTREE_NOERROR));
-	if (agbp)
-		xfs_buf_relse(agbp);
+error0:
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_buf_relse(agbp);
+
+	return error;
+}
+
+/* Return inode number table for the filesystem */
+int
+xfs_inumbers(
+	struct xfs_mount	*mp,/* mount point for filesystem */
+	xfs_ino_t		*lastinop,/* last inode returned */
+	int			*ubcountp,/* size of buffer/count returned */
+	void			__user *ubuffer,/* buffer with inode desc */
+	inumbers_fmt_pf		formatter)
+{
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, *lastinop);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, *lastinop);
+	int			ubleft = *ubcountp;
+	struct xfs_inogrp	*buffer;
+	int			count;
+	int			error;
 
+	*ubcountp = 0;
+	if (agno >= mp->m_sb.sb_agcount ||
+	    *lastinop != XFS_AGINO_TO_INO(mp, agno, agino))
+		return 0;
+
+	count = MIN(ubleft, (int)(PAGE_SIZE / sizeof(*buffer)));
+	buffer = kmem_alloc(count * sizeof(*buffer), KM_SLEEP);
+	do {
+		struct xfs_aginumbers	ai;
+
+		ai.ai_agno = agno;
+		ai.ai_lastip = &agino;
+		ai.ai_icount = ubleft;
+		ai.ai_ubuffer = ubuffer;
+		ai.ai_ocount = 0;
+		error = xfs_perag_inumbers(mp, &ai, buffer, count, formatter);
+		if (error)
+			break;
+
+		*ubcountp += ai.ai_ocount;
+		ubleft -= ai.ai_ocount;
+		ASSERT(ubleft >= 0);
+		if (!ubleft)
+			break;
+
+		ubuffer = ai.ai_ubuffer;
+		agino = 0;
+	} while (++agno < mp->m_sb.sb_agcount);
+
+	if (!error)
+		*lastinop = XFS_AGINO_TO_INO(mp, agno, agino);
+
+	kmem_free(buffer);
 	return error;
 }
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 21dbbd7..9c3e535 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -83,17 +83,26 @@ xfs_bulkstat_one(
 
 typedef int (*inumbers_fmt_pf)(
 	void			__user *ubuffer, /* buffer to write to */
-	const xfs_inogrp_t	*buffer,	/* buffer to read from */
+	const struct xfs_inogrp	*buffer,	/* buffer to read from */
 	long			count,		/* # of elements to read */
 	long			*written);	/* # of bytes written */
 
 int
 xfs_inumbers_fmt(
 	void			__user *ubuffer, /* buffer to write to */
-	const xfs_inogrp_t	*buffer,	/* buffer to read from */
+	const struct xfs_inogrp	*buffer,	/* buffer to read from */
 	long			count,		/* # of elements to read */
 	long			*written);	/* # of bytes written */
 
+/* This structure is used for xfs_inumbers per allocation group */
+struct xfs_aginumbers {
+	xfs_agnumber_t		ai_agno;/* AG number */
+	xfs_agino_t		*ai_lastip;/* last AG inode number */
+	char			__user *ai_ubuffer;/* user buffer to write to */
+	__uint32_t		ai_icount;/* # of elements to read */
+	__uint32_t		ai_ocount;/* # of elements written */
+};
+
 int					/* error status */
 xfs_inumbers(
 	xfs_mount_t		*mp,	/* mount point for filesystem */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
