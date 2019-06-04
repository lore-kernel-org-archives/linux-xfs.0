Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39100 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfFDVuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:50:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LoI5o074193
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:37 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2suevdfwbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Loa6V013024
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2swnhbugec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54LoY5X012060
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:34 GMT
Subject: [PATCH 10/10] xfs: refactor INUMBERS to use iwalk functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:50:33 -0700
Message-ID: <155968503328.1657646.15035810252397604734.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we have generic functions to walk inode records, refactor the
INUMBERS implementation to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   |   20 ++++--
 fs/xfs/xfs_ioctl.h   |    2 +
 fs/xfs/xfs_ioctl32.c |   35 ++++------
 fs/xfs/xfs_itable.c  |  168 ++++++++++++++++++++------------------------------
 fs/xfs/xfs_itable.h  |   22 +------
 fs/xfs/xfs_iwalk.c   |  161 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_iwalk.h   |   12 ++++
 7 files changed, 262 insertions(+), 158 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 43734901aeb9..4fa9a2c8b029 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -732,6 +732,16 @@ xfs_bulkstat_one_fmt(
 	return xfs_ibulk_advance(breq, sizeof(struct xfs_bstat));
 }
 
+int
+xfs_inumbers_fmt(
+	struct xfs_ibulk	*breq,
+	const struct xfs_inogrp	*igrp)
+{
+	if (copy_to_user(breq->ubuffer, igrp, sizeof(*igrp)))
+		return -EFAULT;
+	return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
+}
+
 STATIC int
 xfs_ioc_bulkstat(
 	xfs_mount_t		*mp,
@@ -779,13 +789,9 @@ xfs_ioc_bulkstat(
 	 * parameter to maintain correct function.
 	 */
 	if (cmd == XFS_IOC_FSINUMBERS) {
-		int	count = breq.icount;
-
-		breq.startino = lastino;
-		error = xfs_inumbers(mp, &breq.startino, &count,
-					bulkreq.ubuffer, xfs_inumbers_fmt);
-		breq.ocount = count;
-		lastino = breq.startino;
+		breq.startino = lastino + 1;
+		error = xfs_inumbers(&breq, xfs_inumbers_fmt);
+		lastino = breq.startino - 1;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
 		breq.startino = lastino;
 		error = xfs_bulkstat_one(&breq, xfs_bulkstat_one_fmt);
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index f32c8aadfeba..fb303eaa8863 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -79,7 +79,9 @@ xfs_set_dmattrs(
 
 struct xfs_ibulk;
 struct xfs_bstat;
+struct xfs_inogrp;
 
 int xfs_bulkstat_one_fmt(struct xfs_ibulk *breq, const struct xfs_bstat *bstat);
+int xfs_inumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
 
 #endif
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index add15819daf3..dd53a9692e68 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -85,22 +85,17 @@ xfs_compat_growfs_rt_copyin(
 
 STATIC int
 xfs_inumbers_fmt_compat(
-	void			__user *ubuffer,
-	const struct xfs_inogrp	*buffer,
-	long			count,
-	long			*written)
+	struct xfs_ibulk	*breq,
+	const struct xfs_inogrp	*igrp)
 {
-	compat_xfs_inogrp_t	__user *p32 = ubuffer;
-	long			i;
+	struct compat_xfs_inogrp __user *p32 = breq->ubuffer;
 
-	for (i = 0; i < count; i++) {
-		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
-		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
-		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
-			return -EFAULT;
-	}
-	*written = count * sizeof(*p32);
-	return 0;
+	if (put_user(igrp->xi_startino,   &p32->xi_startino) ||
+	    put_user(igrp->xi_alloccount, &p32->xi_alloccount) ||
+	    put_user(igrp->xi_allocmask,  &p32->xi_allocmask))
+		return -EFAULT;
+
+	return xfs_ibulk_advance(breq, sizeof(struct compat_xfs_inogrp));
 }
 
 #else
@@ -225,7 +220,7 @@ xfs_compat_ioc_bulkstat(
 	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
 	 * functions and structure size are the correct ones to use ...
 	 */
-	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
+	inumbers_fmt_pf		inumbers_func = xfs_inumbers_fmt_compat;
 	bulkstat_one_fmt_pf	bs_one_func = xfs_bulkstat_one_fmt_compat;
 
 #ifdef CONFIG_X86_X32
@@ -286,13 +281,9 @@ xfs_compat_ioc_bulkstat(
 	 * parameter to maintain correct function.
 	 */
 	if (cmd == XFS_IOC_FSINUMBERS_32) {
-		int	count = breq.icount;
-
-		breq.startino = lastino;
-		error = xfs_inumbers(mp, &breq.startino, &count,
-				bulkreq.ubuffer, inumbers_func);
-		breq.ocount = count;
-		lastino = breq.startino;
+		breq.startino = lastino + 1;
+		error = xfs_inumbers(&breq, inumbers_func);
+		lastino = breq.startino - 1;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
 		breq.startino = lastino;
 		error = xfs_bulkstat_one(&breq, bs_one_func);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 06abe5c9c0ee..bade54d6ac64 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -259,121 +259,85 @@ xfs_bulkstat(
 	return error;
 }
 
-int
-xfs_inumbers_fmt(
-	void			__user *ubuffer, /* buffer to write to */
-	const struct xfs_inogrp	*buffer,	/* buffer to read from */
-	long			count,		/* # of elements to read */
-	long			*written)	/* # of bytes written */
+struct xfs_inumbers_chunk {
+	inumbers_fmt_pf		formatter;
+	struct xfs_ibulk	*breq;
+};
+
+/*
+ * INUMBERS
+ * ========
+ * This is how we export inode btree records to userspace, so that XFS tools
+ * can figure out where inodes are allocated.
+ */
+
+/*
+ * Format the inode group structure and report it somewhere.
+ *
+ * Similar to xfs_bulkstat_one_int, lastino is the inode cursor as we walk
+ * through the filesystem so we move it forward unless there was a runtime
+ * error.  If the formatter tells us the buffer is now full we also move the
+ * cursor forward and abort the walk.
+ */
+STATIC int
+xfs_inumbers_walk(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	const struct xfs_inobt_rec_incore *irec,
+	void			*data)
 {
-	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
-		return -EFAULT;
-	*written = count * sizeof(*buffer);
-	return 0;
+	struct xfs_inogrp	inogrp = {
+		.xi_startino	= XFS_AGINO_TO_INO(mp, agno, irec->ir_startino),
+		.xi_alloccount	= irec->ir_count - irec->ir_freecount,
+		.xi_allocmask	= ~irec->ir_free,
+	};
+	struct xfs_inumbers_chunk *ic = data;
+	xfs_agino_t		agino;
+	int			error;
+
+	error = ic->formatter(ic->breq, &inogrp);
+	if (error && error != XFS_IBULK_BUFFER_FULL)
+		return error;
+	if (error == XFS_IBULK_BUFFER_FULL)
+		error = XFS_INOBT_WALK_ABORT;
+
+	agino = irec->ir_startino + XFS_INODES_PER_CHUNK;
+	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, agino);
+	return error;
 }
 
 /*
  * Return inode number table for the filesystem.
  */
-int					/* error status */
+int
 xfs_inumbers(
-	struct xfs_mount	*mp,/* mount point for filesystem */
-	xfs_ino_t		*lastino,/* last inode returned */
-	int			*count,/* size of buffer/count returned */
-	void			__user *ubuffer,/* buffer with inode descriptions */
+	struct xfs_ibulk	*breq,
 	inumbers_fmt_pf		formatter)
 {
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, *lastino);
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, *lastino);
-	struct xfs_btree_cur	*cur = NULL;
-	struct xfs_buf		*agbp = NULL;
-	struct xfs_inogrp	*buffer;
-	int			bcount;
-	int			left = *count;
-	int			bufidx = 0;
+	struct xfs_inumbers_chunk ic = {
+		.formatter	= formatter,
+		.breq		= breq,
+	};
 	int			error = 0;
 
-	*count = 0;
-	if (agno >= mp->m_sb.sb_agcount ||
-	    *lastino != XFS_AGINO_TO_INO(mp, agno, agino))
-		return error;
+	breq->ocount = 0;
 
-	bcount = min(left, (int)(PAGE_SIZE / sizeof(*buffer)));
-	buffer = kmem_zalloc(bcount * sizeof(*buffer), KM_SLEEP);
-	do {
-		struct xfs_inobt_rec_incore	r;
-		int				stat;
-
-		if (!agbp) {
-			error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
-			if (error)
-				break;
-
-			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
-						    XFS_BTNUM_INO);
-			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
-						 &stat);
-			if (error)
-				break;
-			if (!stat)
-				goto next_ag;
-		}
-
-		error = xfs_inobt_get_rec(cur, &r, &stat);
-		if (error)
-			break;
-		if (!stat)
-			goto next_ag;
-
-		agino = r.ir_startino + XFS_INODES_PER_CHUNK - 1;
-		buffer[bufidx].xi_startino =
-			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
-		buffer[bufidx].xi_alloccount = r.ir_count - r.ir_freecount;
-		buffer[bufidx].xi_allocmask = ~r.ir_free;
-		if (++bufidx == bcount) {
-			long	written;
-
-			error = formatter(ubuffer, buffer, bufidx, &written);
-			if (error)
-				break;
-			ubuffer += written;
-			*count += bufidx;
-			bufidx = 0;
-		}
-		if (!--left)
-			break;
-
-		error = xfs_btree_increment(cur, 0, &stat);
-		if (error)
-			break;
-		if (stat)
-			continue;
-
-next_ag:
-		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-		cur = NULL;
-		xfs_buf_relse(agbp);
-		agbp = NULL;
-		agino = 0;
-		agno++;
-	} while (agno < mp->m_sb.sb_agcount);
-
-	if (!error) {
-		if (bufidx) {
-			long	written;
-
-			error = formatter(ubuffer, buffer, bufidx, &written);
-			if (!error)
-				*count += bufidx;
-		}
-		*lastino = XFS_AGINO_TO_INO(mp, agno, agino);
-	}
+	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
+		return 0;
+
+	error = xfs_inobt_walk(breq->mp, NULL, breq->startino,
+			xfs_inumbers_walk, breq->icount, &ic);
 
-	kmem_free(buffer);
-	if (cur)
-		xfs_btree_del_cursor(cur, error);
-	if (agbp)
-		xfs_buf_relse(agbp);
+	/*
+	 * We found some inode groups, so clear the error status and return
+	 * them.  The lastino pointer will point directly at the inode that
+	 * triggered any error that occurred, so on the next call the error
+	 * will be triggered again and propagated to userspace as there will be
+	 * no formatted inode groups in the buffer.
+	 */
+	if (breq->ocount > 0)
+		error = 0;
 
 	return error;
 }
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index a2562fe8d282..b4c89454e27a 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -46,25 +46,9 @@ typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
 int xfs_bulkstat_one(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
 int xfs_bulkstat(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
 
-typedef int (*inumbers_fmt_pf)(
-	void			__user *ubuffer, /* buffer to write to */
-	const xfs_inogrp_t	*buffer,	/* buffer to read from */
-	long			count,		/* # of elements to read */
-	long			*written);	/* # of bytes written */
+typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
+		const struct xfs_inogrp *igrp);
 
-int
-xfs_inumbers_fmt(
-	void			__user *ubuffer, /* buffer to write to */
-	const xfs_inogrp_t	*buffer,	/* buffer to read from */
-	long			count,		/* # of elements to read */
-	long			*written);	/* # of bytes written */
-
-int					/* error status */
-xfs_inumbers(
-	xfs_mount_t		*mp,	/* mount point for filesystem */
-	xfs_ino_t		*last,	/* last inode returned */
-	int			*count,	/* size of buffer/count returned */
-	void			__user *buffer, /* buffer with inode info */
-	inumbers_fmt_pf		formatter);
+int xfs_inumbers(struct xfs_ibulk *breq, inumbers_fmt_pf formatter);
 
 #endif	/* __XFS_ITABLE_H__ */
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index c4a9c4c246b7..3a35d1cf7e14 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -66,7 +66,10 @@ struct xfs_iwalk_ag {
 	unsigned int			nr_recs;
 
 	/* Inode walk function and data pointer. */
-	xfs_iwalk_fn			iwalk_fn;
+	union {
+		xfs_iwalk_fn		iwalk_fn;
+		xfs_inobt_walk_fn	inobt_walk_fn;
+	};
 	void				*data;
 };
 
@@ -104,16 +107,18 @@ xfs_iwalk_ichunk_ra(
 
 /*
  * Lookup the inode chunk that the given @agino lives in and then get the
- * record if we found the chunk.  Set the bits in @irec's free mask that
- * correspond to the inodes before @agino so that we skip them.  This is how we
- * restart an inode walk that was interrupted in the middle of an inode record.
+ * record if we found the chunk.  If @trim is set, set the bits in @irec's free
+ * mask that correspond to the inodes before @agino so that we skip them.
+ * This is how we restart an inode walk that was interrupted in the middle of
+ * an inode record.
  */
 STATIC int
 xfs_iwalk_grab_ichunk(
 	struct xfs_btree_cur		*cur,	/* btree cursor */
 	xfs_agino_t			agino,	/* starting inode of chunk */
 	int				*icount,/* return # of inodes grabbed */
-	struct xfs_inobt_rec_incore	*irec)	/* btree record */
+	struct xfs_inobt_rec_incore	*irec,	/* btree record */
+	bool				trim)
 {
 	int				idx;	/* index into inode chunk */
 	int				stat;
@@ -141,6 +146,12 @@ xfs_iwalk_grab_ichunk(
 		return 0;
 	}
 
+	/* Return the entire record if the caller wants the whole thing. */
+	if (!trim) {
+		*icount = irec->ir_count;
+		return 0;
+	}
+
 	idx = agino - irec->ir_startino;
 
 	/*
@@ -262,7 +273,8 @@ xfs_iwalk_ag_start(
 	xfs_agino_t		agino,
 	struct xfs_btree_cur	**curpp,
 	struct xfs_buf		**agi_bpp,
-	int			*has_more)
+	int			*has_more,
+	bool			trim)
 {
 	struct xfs_mount	*mp = iwag->mp;
 	struct xfs_trans	*tp = iwag->tp;
@@ -286,7 +298,7 @@ xfs_iwalk_ag_start(
 	 * have to deal with tearing down the cursor to walk the records.
 	 */
 	error = xfs_iwalk_grab_ichunk(*curpp, agino, &icount,
-			&iwag->recs[iwag->nr_recs]);
+			&iwag->recs[iwag->nr_recs], trim);
 	if (error)
 		return error;
 	if (icount)
@@ -365,7 +377,8 @@ xfs_iwalk_ag(
 	/* Set up our cursor at the right place in the inode btree. */
 	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
 	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
-	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
+	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more,
+			true);
 
 	while (!error && has_more && !xfs_pwork_want_abort(&iwag->pwork)) {
 		struct xfs_inobt_rec_incore	*irec;
@@ -561,3 +574,135 @@ xfs_iwalk_threaded(
 		return xfs_pwork_destroy_poll(&pctl);
 	return xfs_pwork_destroy(&pctl);
 }
+
+/* For each inuse inode in each cached inobt record, call our function. */
+STATIC int
+xfs_inobt_walk_ag_recs(
+	struct xfs_iwalk_ag		*iwag)
+{
+	struct xfs_mount		*mp = iwag->mp;
+	struct xfs_trans		*tp = iwag->tp;
+	struct xfs_inobt_rec_incore	*irec;
+	unsigned int			i;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	for (i = 0, irec = iwag->recs; i < iwag->nr_recs; i++, irec++) {
+		trace_xfs_iwalk_ag_rec(mp, agno, irec);
+		error = iwag->inobt_walk_fn(mp, tp, agno, irec, iwag->data);
+		if (error)
+			return error;
+	}
+
+	iwag->nr_recs = 0;
+	return 0;
+}
+
+/*
+ * Walk all inode btree records in a single AG, from @iwag->startino to the end
+ * of the AG.
+ */
+STATIC int
+xfs_inobt_walk_ag(
+	struct xfs_iwalk_ag		*iwag)
+{
+	struct xfs_mount		*mp = iwag->mp;
+	struct xfs_trans		*tp = iwag->tp;
+	struct xfs_buf			*agi_bp = NULL;
+	struct xfs_btree_cur		*cur = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agino_t			agino;
+	int				has_more;
+	int				error = 0;
+
+	/* Set up our cursor at the right place in the inode btree. */
+	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
+	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more,
+			false);
+
+	while (!error && has_more && !xfs_pwork_want_abort(&iwag->pwork)) {
+		struct xfs_inobt_rec_incore	*irec;
+
+		cond_resched();
+
+		/* Fetch the inobt record. */
+		irec = &iwag->recs[iwag->nr_recs];
+		error = xfs_inobt_get_rec(cur, irec, &has_more);
+		if (error || !has_more)
+			break;
+
+		/*
+		 * If there's space in the buffer for more records, increment
+		 * the btree cursor and grab more.
+		 */
+		if (++iwag->nr_recs < iwag->sz_recs) {
+			error = xfs_btree_increment(cur, 0, &has_more);
+			if (error || !has_more)
+				break;
+			continue;
+		}
+
+		/*
+		 * Otherwise, we need to save cursor state and run the callback
+		 * function on the cached records.  The run_callbacks function
+		 * is supposed to return a cursor pointing to the record where
+		 * we would be if we had been able to increment like above.
+		 */
+		error = xfs_iwalk_run_callbacks(iwag, xfs_inobt_walk_ag_recs,
+				agno, &cur, &agi_bp, &has_more);
+	}
+
+	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
+
+	/* Walk any records left behind in the cache. */
+	if (iwag->nr_recs == 0 || error || xfs_pwork_want_abort(&iwag->pwork))
+		return error;
+
+	return xfs_inobt_walk_ag_recs(iwag);
+}
+
+/*
+ * Walk all inode btree records in the filesystem starting from @startino.  The
+ * @inobt_walk_fn will be called for each btree record, being passed the incore
+ * record and @data.  @max_prefetch controls how many inobt records we try to
+ * cache ahead of time.
+ */
+int
+xfs_inobt_walk(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		startino,
+	xfs_inobt_walk_fn	inobt_walk_fn,
+	unsigned int		max_prefetch,
+	void			*data)
+{
+	struct xfs_iwalk_ag	iwag = {
+		.mp		= mp,
+		.tp		= tp,
+		.inobt_walk_fn	= inobt_walk_fn,
+		.data		= data,
+		.startino	= startino,
+		.pwork		= XFS_PWORK_SINGLE_THREADED,
+	};
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	int			error;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	xfs_iwalk_set_prefetch(&iwag, max_prefetch * XFS_INODES_PER_CHUNK);
+	error = xfs_iwalk_alloc(&iwag);
+	if (error)
+		return error;
+
+	for (; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_inobt_walk_ag(&iwag);
+		if (error)
+			break;
+		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+	}
+
+	xfs_iwalk_free(&iwag);
+	return error;
+}
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 76d8f87a39ef..20bee93d4676 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -18,4 +18,16 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, bool poll,
 		void *data);
 
+/* Walk all inode btree records in the filesystem starting from @startino. */
+typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
+				 xfs_agnumber_t agno,
+				 const struct xfs_inobt_rec_incore *irec,
+				 void *data);
+/* Return value (for xfs_inobt_walk_fn) that aborts the walk immediately. */
+#define XFS_INOBT_WALK_ABORT	(XFS_IWALK_ABORT)
+
+int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_ino_t startino, xfs_inobt_walk_fn inobt_walk_fn,
+		unsigned int max_prefetch, void *data);
+
 #endif /* __XFS_IWALK_H__ */
