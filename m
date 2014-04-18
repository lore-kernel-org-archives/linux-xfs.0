Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 20A9E7F86
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:59:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9899304043
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 17:58:59 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id KHRu1Cq9Bd5h1bdQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Apr 2014 17:58:58 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s3I0wvYV011248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:57 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3I0wubm025258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:57 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3I0wurr020917 for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:56 GMT
Message-ID: <535078CD.6050500@oracle.com>
Date: Fri, 18 Apr 2014 08:58:53 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 09/10] xfs: introduce per allocation group bulkstat
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

Introduce xfs_perag_bulkstat(), we can return stat information in bulk by
inode as per the given allocation group number and start inode number in
it via a new ioctl(2) in the future.  Similar to the per allocation group
inumbers, we could perform bulkstat in parallel with that.

Refactor xfs_bulkstat() with it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 288 +++++++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_itable.h |  20 ++++
 2 files changed, 180 insertions(+), 128 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 56e1d5f..58dc182 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -337,86 +337,44 @@ xfs_bulkstat_ag_ichunk(
 }
 
 /*
- * Return stat information in bulk (by-inode) for the filesystem.
+ * Return stat information in bulk (by-inode) in an allocation group until
+ * we run out of the AG or user buffers.
  */
-int					/* error status */
-xfs_bulkstat(
-	xfs_mount_t		*mp,	/* mount point for filesystem */
-	xfs_ino_t		*lastinop, /* last inode returned */
-	int			*ubcountp, /* size of buffer/count returned */
-	bulkstat_one_pf		formatter, /* func that'd fill a single buf */
-	size_t			statstruct_size, /* sizeof struct filling */
-	char			__user *ubuffer, /* buffer with inode stats */
-	int			*done)	/* 1 if there are more stats to get */
+int
+xfs_perag_bulkstat(
+	struct xfs_mount		*mp,
+	struct xfs_agbulkstat		*agbulkp,
+	struct xfs_inobt_rec_incore	*irbuf,
+	size_t				nirbuf,
+	bulkstat_one_pf			formatter,
+	size_t				statstruct_size)
 {
-	xfs_buf_t		*agbp;	/* agi header buffer */
-	xfs_agi_t		*agi;	/* agi header data */
-	xfs_agino_t		agino;	/* inode # in allocation group */
-	xfs_agnumber_t		agno;	/* allocation group number */
-	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
-	int			end_of_ag; /* set if we've seen the ag end */
-	int			error;	/* error code */
-	int                     fmterror;/* bulkstat formatter result */
-	int			i;	/* loop index */
-	int			icount;	/* count of inodes good in irbuf */
-	size_t			irbsize; /* size of irec buffer in bytes */
-	xfs_ino_t		ino;	/* inode number (filesystem) */
-	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
-	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
-	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
-	xfs_ino_t		lastino; /* last inode number returned */
-	int			nirbuf;	/* size of irbuf */
-	int			rval;	/* return value error code */
-	int			tmp;	/* result value from btree calls */
-	int			ubcount; /* size of user's buffer */
-	int			ubleft;	/* bytes left in user's buffer */
-	char			__user *ubufp;	/* pointer into user's buffer */
-	int			ubelem;	/* spaces used in user's buffer */
-
-	/*
-	 * Get the last inode value, see if there's nothing to do.
-	 */
-	ino = (xfs_ino_t)*lastinop;
-	lastino = ino;
-	agno = XFS_INO_TO_AGNO(mp, ino);
-	agino = XFS_INO_TO_AGINO(mp, ino);
-	if (agno >= mp->m_sb.sb_agcount ||
-	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
-		*done = 1;
-		*ubcountp = 0;
-		return 0;
-	}
-	ubcount = *ubcountp; /* statstruct's */
-	ubleft = ubcount * statstruct_size; /* bytes */
-	*ubcountp = ubelem = 0;
-	*done = 0;
-	fmterror = 0;
-	ubufp = ubuffer;
-	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
-	if (!irbuf)
-		return ENOMEM;
-
-	nirbuf = irbsize / sizeof(*irbuf);
+	xfs_agnumber_t			agno = agbulkp->ab_agno;
+	xfs_agino_t			agino = *(agbulkp->ab_aginop);
+	xfs_ino_t			lastino = XFS_AGINO_TO_INO(mp, agno,
+								   agino);
+	char				__user *ubuffer = agbulkp->ab_ubuffer;
+	int				ubcount = agbulkp->ab_icount;
+	int				ubelem = 0;/* # elements written */
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_buf			*agbp = NULL;
+	int				ubleft_bytes;
+	int				error;
+
+	ubleft_bytes = ubcount * statstruct_size;
+	for (;;) {
+		struct xfs_inobt_rec_incore	*irbp = irbuf;
+		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
+		struct xfs_agi			*agi;
+		int				stat;
+		int				icount = 0;/* # inodes in irbuf */
+		bool				end_of_ag = false;
 
-	/*
-	 * Loop over the allocation groups, starting from the last
-	 * inode returned; 0 means start of the allocation group.
-	 */
-	rval = 0;
-	while (XFS_BULKSTAT_UBLEFT(ubleft) && agno < mp->m_sb.sb_agcount) {
-		cond_resched();
 		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
 		if (error)
 			break;
 		agi = XFS_BUF_TO_AGI(agbp);
-		/*
-		 * Allocate and initialize a btree cursor for ialloc btree.
-		 */
 		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
-		irbp = irbuf;
-		irbufend = irbuf + nirbuf;
-		end_of_ag = 0;
-		icount = 0;
 		if (agino > 0) {
 			/*
 			 * In the middle of an allocation group, we need to get
@@ -434,32 +392,34 @@ xfs_bulkstat(
 				irbp++;
 				agino += r.ir_startino + XFS_INODES_PER_CHUNK;
 			}
-			/* Increment to the next record */
-			error = xfs_btree_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &stat);
+			if (error)
+				break;
+			if (!stat)
+				end_of_ag = true;
 		} else {
 			/* Start of ag.  Lookup the first inode chunk */
-			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
+			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
+			if (error || !stat)
+				break;
 		}
-		if (error)
-			break;
 
 		/*
-		 * Loop through inode btree records in this ag,
-		 * until we run out of inodes or space in the buffer.
+		 * Loop over inode btree records in this AG until we run out of
+		 * inodes or space in the buffer.
 		 */
 		while (irbp < irbufend && icount < ubcount) {
 			struct xfs_inobt_rec_incore	r;
 
-			error = xfs_inobt_get_rec(cur, &r, &i);
-			if (error || i == 0) {
-				end_of_ag = 1;
+			error = xfs_inobt_get_rec(cur, &r, &stat);
+			if (error)
+				break;
+			if (!stat) {
+				end_of_ag = true;
 				break;
 			}
 
-			/*
-			 * If this chunk has any allocated inodes, save it.
-			 * Also start read-ahead now for this chunk.
-			 */
+			/* If this chunk has any allocated inodes, save it */
 			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
 				xfs_bulkstat_ichunk_ra(mp, agno, &r);
 				irbp->ir_startino = r.ir_startino;
@@ -468,77 +428,149 @@ xfs_bulkstat(
 				irbp++;
 				icount += XFS_INODES_PER_CHUNK - r.ir_freecount;
 			}
-			/*
-			 * Set agino to after this chunk and bump the cursor.
-			 */
+
+			/* Set agino to after this chunk and bump the cursor */
 			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
-			error = xfs_btree_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &stat);
+			if (error)
+				break;
+			if (!stat) {
+				end_of_ag = true;
+				break;
+			}
+
 			cond_resched();
 		}
+
+		/* Break if previously there is any error has happened */
+		if (error)
+			break;
 		/*
-		 * Drop the btree buffers and the agi buffer.
-		 * We can't hold any of the locks these represent
-		 * when calling iget.
+		 * Drop the btree buffers and the agi buffer.  We can't hold
+		 * any of the locks these represent when calling iget.
 		 */
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
 		xfs_buf_relse(agbp);
-		/*
-		 * Now format all the good inodes into the user's buffer.
-		 */
+		agbp = NULL;
+
 		irbufend = irbp;
 		for (irbp = irbuf;
-		     irbp < irbufend && XFS_BULKSTAT_UBLEFT(ubleft); irbp++) {
-			struct xfs_bulkstat_agichunk ac;
+		     irbp < irbufend && XFS_BULKSTAT_UBLEFT(ubleft_bytes);
+		     irbp++) {
+			struct xfs_bulkstat_agichunk	ac;
 
 			ac.ac_lastino = lastino;
 			ac.ac_ubuffer = ubuffer;
-			ac.ac_ubleft = ubleft;
+			ac.ac_ubleft = ubleft_bytes;
 			ac.ac_ubelem = ubelem;
 			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
 					formatter, statstruct_size, &ac);
 			if (error)
-				rval = error;
-
+				break;
 			lastino = ac.ac_lastino;
-			ubleft = ac.ac_ubleft;
+			ubleft_bytes = ac.ac_ubleft;
 			ubelem = ac.ac_ubelem;
 
 			cond_resched();
 		}
-		/*
-		 * Set up for the next loop iteration.
-		 */
-		if (XFS_BULKSTAT_UBLEFT(ubleft)) {
-			if (end_of_ag) {
-				agno++;
-				agino = 0;
-			} else
-				agino = XFS_INO_TO_AGINO(mp, lastino);
-		} else
+
+		if (error || end_of_ag || !XFS_BULKSTAT_UBLEFT(ubleft_bytes))
 			break;
+
+		/* Set up for the next loop iteration */
+		agino = XFS_INO_TO_AGINO(mp, lastino);
 	}
+
+	if (!error) {
+		agbulkp->ab_ocount = ubelem;
+		*(agbulkp->ab_aginop) = XFS_INO_TO_AGINO(mp, lastino);
+	}
+
+	if (cur) {
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+	if (agbp)
+		xfs_buf_relse(agbp);
+
+	return error;
+}
+
+/*
+ * Return stat information in bulk (by-inode) for the filesystem.
+ */
+int
+xfs_bulkstat(
+	struct xfs_mount	*mp,	/* mount point for filesystem */
+	xfs_ino_t		*lastinop, /* last inode returned */
+	int			*ubcountp, /* size of buffer/count returned */
+	bulkstat_one_pf		formatter, /* func that'd fill a single buf */
+	size_t			statstruct_size, /* sizeof struct filling */
+	char			__user *ubuffer, /* buffer with inode stats */
+	int			*done)	/* 1 if there are more stats to get */
+{
+	xfs_ino_t		lastino = *lastinop;/* last inode number */
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, lastino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, lastino);
+	int			ubleft = *ubcountp;/* size of user's buffer */
+	size_t			irbsize;/* size of irec buffer in bytes */
+	int			nirbuf;	/* size of irbuf */
+	int			error;	/* error code */
+	struct xfs_inobt_rec_incore *irbuf;/* start of irec buffer */
+
+	/* The given last inode number is beyond file system range, done */
+	if (agno >= mp->m_sb.sb_agcount ||
+	    lastino != XFS_AGINO_TO_INO(mp, agno, agino)) {
+		*ubcountp = 0;
+		*done = 1;
+		return 0;
+	}
+
+	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
+	if (!irbuf)
+		return ENOMEM;
+	nirbuf = irbsize / sizeof(*irbuf);
+
+	*done = 0;
 	/*
-	 * Done, we're either out of filesystem or space to put the data.
-	 */
-	kmem_free(irbuf);
-	*ubcountp = ubelem;
-	/*
-	 * Found some inodes, return them now and return the error next time.
+	 * Loop over the allocation groups, starting from the last inode
+	 * returned; 0 means start of the allocation group.
 	 */
-	if (ubelem)
-		rval = 0;
-	if (agno >= mp->m_sb.sb_agcount) {
+	do {
+		struct xfs_agbulkstat	agbulk;
+
+		agbulk.ab_agno = agno;
+		agbulk.ab_aginop = &agino;
+		agbulk.ab_ubuffer = ubuffer;
+		agbulk.ab_icount = ubleft;
+		agbulk.ab_ocount = 0;
+		error = xfs_perag_bulkstat(mp, &agbulk, irbuf, nirbuf,
+					   formatter, statstruct_size);
+		if (error)
+			break;
+
+		ubleft -= agbulk.ab_ocount;
+		ASSERT(ubleft >= 0);
+		if (!ubleft)
+			break;
+
 		/*
-		 * If we ran out of filesystem, mark lastino as off
-		 * the end of the filesystem, so the next call
-		 * will return immediately.
+		 * No more inodes in current allocation group, however the user
+		 * requires more.  Proceed to loop over the next one.
 		 */
-		*lastinop = (xfs_ino_t)XFS_AGINO_TO_INO(mp, agno, 0);
+		agino = 0;
+	} while (++agno < mp->m_sb.sb_agcount);
+
+	kmem_free(irbuf);
+
+	if (!error) {
+		*ubcountp -= ubleft;
+		*lastinop = XFS_AGINO_TO_INO(mp, agno, agino);
 		*done = 1;
-	} else
-		*lastinop = (xfs_ino_t)lastino;
+	}
 
-	return rval;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index d3e004e..0488960 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -47,6 +47,26 @@ xfs_bulkstat_ag_ichunk(
 	struct xfs_bulkstat_agichunk	*acp);
 
 /*
+ * Structures returned stat information in bulk (by-inode) per AG.
+ */
+struct xfs_agbulkstat {
+	xfs_agnumber_t	ab_agno;	/* AG number */
+	xfs_agino_t	*ab_aginop;	/* last agino returned */
+	char		__user *ab_ubuffer; /* pointer into user's buffer */
+	__uint32_t	ab_icount;	/* count of entries in buffer */
+	__uint32_t	ab_ocount;	/* output counter */
+};
+
+int
+xfs_perag_bulkstat(
+	struct xfs_mount		*mp,
+	struct xfs_agbulkstat		*agbulkp,
+	struct xfs_inobt_rec_incore	*irbuf,
+	size_t				nirbuf,
+	bulkstat_one_pf			formatter,
+	size_t				statstruct_size);
+
+/*
  * Values for stat return value.
  */
 #define BULKSTAT_RV_NOTHING	0
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
