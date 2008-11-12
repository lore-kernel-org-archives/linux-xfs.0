Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 01:36:34 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC9aPUH031289
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:36:26 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2F48154AD03
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:36:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id desl9xbdEuSUxCWr for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:36:25 -0800 (PST)
Date: Wed, 12 Nov 2008 04:36:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] factor out xfs_read_agi helper
Message-ID: <20081112093625.GF8896@infradead.org>
References: <20081027133901.GB1109@infradead.org> <20081028050852.GA17077@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028050852.GA17077@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Oct 28, 2008 at 04:08:52PM +1100, Dave Chinner wrote:
> >  	if (error) {
> >  		cmn_err(CE_WARN,
> > -			"xfs_iunlink_remove: xfs_trans_read_buf()  returned an error %d on %s.  Returning error.",
> > +			"xfs_iunlink_remove: xfs_read_agi() returned an error %d on %s. Returning error.",
> >  			error, mp->m_fsname);
> >  		return error;
> >  	}
> 
> Do we need this warning here? xfs_read_agi() will have already
> issued an error, right? Also, xfs_fs_cmn_err() is probably better
> to use here rather than manually encoding the fsname into the error
> message....

If xfs_trans_read_buf fail we don't issue a warning in xfs_read_agi, but
if the agi validations fails we do.  Given that xfs_trans_read_buf
already warns by itself that's not needed and we can remove the warning
here.  Note that various other callers in log recovery also print
messages when xfs_read_agi fails, which we can remove, too.

> > +				error = xfs_read_agi(mp, NULL, agno, &agibp);
> > +				ASSERT(error == 0);
> > +				if (error) {
> > +					xfs_fs_cmn_err(CE_ALERT, mp,
> > +					"xlog_recover_process_iunlinks(#2)"
> > +					"agi read failed agno %d error %d",
> > +							agno, error);
> 
> Move the assert into the if (error) branch after the message is
> logged so that it is clear the reason for the assert failure.

I've killed the error branch completely based on the rationale above.

-- 

factor out xfs_read_agi helper

Add a helper to read the AGI header and perform basic verification.
Based on hunks from a larger patch from Dave Chinner.

(First sent on Juli 23rd)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_ag.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ag.h	2008-11-10 14:03:59.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_ag.h	2008-11-12 10:25:40.000000000 +0100
@@ -142,6 +142,9 @@ typedef struct xfs_agi {
 #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
 #define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)XFS_BUF_PTR(bp))
 
+extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
+				xfs_agnumber_t agno, struct xfs_buf **bpp);
+
 /*
  * The third a.g. block contains the a.g. freelist, an array
  * of block pointers to blocks owned by the allocation btree code.
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-11-10 14:03:59.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-11-12 10:25:40.000000000 +0100
@@ -1462,70 +1462,95 @@ xfs_ialloc_log_agi(
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
+#ifdef DEBUG
+STATIC void
+xfs_check_agi_unlinked(
+	struct xfs_agi		*agi)
+{
+	int			i;
+
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
+		ASSERT(agi->agi_unlinked[i]);
+}
+#else
+#define xfs_check_agi_unlinked(agi)
+#endif
+
 /*
  * Read in the allocation group header (inode allocation section)
  */
 int
-xfs_ialloc_read_agi(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_buf_t	**bpp)		/* allocation group hdr buf */
+xfs_read_agi(
+	struct xfs_mount	*mp,	/* file system mount structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_buf		**bpp)	/* allocation group hdr buf */
 {
-	xfs_agi_t	*agi;		/* allocation group header */
-	int		agi_ok;		/* agi is consistent */
-	xfs_buf_t	*bp;		/* allocation group hdr buf */
-	xfs_perag_t	*pag;		/* per allocation group data */
-	int		error;
+	struct xfs_agi		*agi;	/* allocation group header */
+	int			agi_ok;	/* agi is consistent */
+	int			error;
 
 	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp);
+			XFS_FSS_TO_BB(mp, 1), 0, bpp);
 	if (error)
 		return error;
-	ASSERT(bp && !XFS_BUF_GETERROR(bp));
+
+	ASSERT(*bpp && !XFS_BUF_GETERROR(*bpp));
+	agi = XFS_BUF_TO_AGI(*bpp);
 
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	agi = XFS_BUF_TO_AGI(bp);
-	agi_ok =
-		be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
+	agi_ok = be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
+		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
+		be32_to_cpu(agi->agi_seqno) == agno;
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
 			XFS_RANDOM_IALLOC_READ_AGI))) {
-		XFS_CORRUPTION_ERROR("xfs_ialloc_read_agi", XFS_ERRLEVEL_LOW,
+		XFS_CORRUPTION_ERROR("xfs_read_agi", XFS_ERRLEVEL_LOW,
 				     mp, agi);
-		xfs_trans_brelse(tp, bp);
+		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
+
+	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGI, XFS_AGI_REF);
+
+	xfs_check_agi_unlinked(agi);
+	return 0;
+}
+
+int
+xfs_ialloc_read_agi(
+	struct xfs_mount	*mp,	/* file system mount structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_buf		**bpp)	/* allocation group hdr buf */
+{
+	struct xfs_agi		*agi;	/* allocation group header */
+	struct xfs_perag	*pag;	/* per allocation group data */
+	int			error;
+
+	error = xfs_read_agi(mp, tp, agno, bpp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(*bpp);
 	pag = &mp->m_perag[agno];
+
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
 		pag->pagi_init = 1;
-	} else {
-		/*
-		 * It's possible for these to be out of sync if
-		 * we are in the middle of a forced shutdown.
-		 */
-		ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-			XFS_FORCED_SHUTDOWN(mp));
-	}
-
-#ifdef DEBUG
-	{
-		int	i;
-
-		for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
-			ASSERT(agi->agi_unlinked[i]);
 	}
-#endif
 
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGI, XFS_AGI_REF);
-	*bpp = bp;
+	/*
+	 * It's possible for these to be out of sync if
+	 * we are in the middle of a forced shutdown.
+	 */
+	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
+		XFS_FORCED_SHUTDOWN(mp));
 	return 0;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-11-10 14:03:59.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-11-12 10:31:45.000000000 +0100
@@ -1837,13 +1837,10 @@ xfs_iunlink(
 	xfs_dinode_t	*dip;
 	xfs_buf_t	*agibp;
 	xfs_buf_t	*ibp;
-	xfs_agnumber_t	agno;
-	xfs_daddr_t	agdaddr;
 	xfs_agino_t	agino;
 	short		bucket_index;
 	int		offset;
 	int		error;
-	int		agi_ok;
 
 	ASSERT(ip->i_d.di_nlink == 0);
 	ASSERT(ip->i_d.di_mode != 0);
@@ -1851,31 +1848,15 @@ xfs_iunlink(
 
 	mp = tp->t_mountp;
 
-	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	agdaddr = XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp));
-
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
 	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, agdaddr,
-				   XFS_FSS_TO_BB(mp, 1), 0, &agibp);
+	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
 	if (error)
 		return error;
-
-	/*
-	 * Validate the magic number of the agi block.
-	 */
 	agi = XFS_BUF_TO_AGI(agibp);
-	agi_ok =
-		be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
-	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IUNLINK,
-			XFS_RANDOM_IUNLINK))) {
-		XFS_CORRUPTION_ERROR("xfs_iunlink", XFS_ERRLEVEL_LOW, mp, agi);
-		xfs_trans_brelse(tp, agibp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
+
 	/*
 	 * Get the index into the agi hash table for the
 	 * list this inode will go on.
@@ -1935,7 +1916,6 @@ xfs_iunlink_remove(
 	xfs_buf_t	*agibp;
 	xfs_buf_t	*ibp;
 	xfs_agnumber_t	agno;
-	xfs_daddr_t	agdaddr;
 	xfs_agino_t	agino;
 	xfs_agino_t	next_agino;
 	xfs_buf_t	*last_ibp;
@@ -1943,45 +1923,20 @@ xfs_iunlink_remove(
 	short		bucket_index;
 	int		offset, last_offset = 0;
 	int		error;
-	int		agi_ok;
 
-	/*
-	 * First pull the on-disk inode from the AGI unlinked list.
-	 */
 	mp = tp->t_mountp;
-
 	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	agdaddr = XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp));
 
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
 	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, agdaddr,
-				   XFS_FSS_TO_BB(mp, 1), 0, &agibp);
-	if (error) {
-		cmn_err(CE_WARN,
-			"xfs_iunlink_remove: xfs_trans_read_buf()  returned an error %d on %s.  Returning error.",
-			error, mp->m_fsname);
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
 		return error;
-	}
-	/*
-	 * Validate the magic number of the agi block.
-	 */
+
 	agi = XFS_BUF_TO_AGI(agibp);
-	agi_ok =
-		be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
-	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IUNLINK_REMOVE,
-			XFS_RANDOM_IUNLINK_REMOVE))) {
-		XFS_CORRUPTION_ERROR("xfs_iunlink_remove", XFS_ERRLEVEL_LOW,
-				     mp, agi);
-		xfs_trans_brelse(tp, agibp);
-		cmn_err(CE_WARN,
-			"xfs_iunlink_remove: XFS_TEST_ERROR()  returned an error on %s.  Returning EFSCORRUPTED.",
-			 mp->m_fsname);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
+
 	/*
 	 * Get the index into the agi hash table for the
 	 * list this inode will go on.
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-11-10 14:03:59.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-11-12 10:31:46.000000000 +0100
@@ -3117,19 +3117,16 @@ xlog_recover_clear_agi_bucket(
 	int		error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_CLEAR_AGI_BUCKET);
-	error = xfs_trans_reserve(tp, 0, XFS_CLEAR_AGI_BUCKET_LOG_RES(mp), 0, 0, 0);
-	if (!error)
-		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-				   XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				   XFS_FSS_TO_BB(mp, 1), 0, &agibp);
+	error = xfs_trans_reserve(tp, 0, XFS_CLEAR_AGI_BUCKET_LOG_RES(mp),
+				  0, 0, 0);
 	if (error)
 		goto out_abort;
 
-	error = EINVAL;
-	agi = XFS_BUF_TO_AGI(agibp);
-	if (be32_to_cpu(agi->agi_magicnum) != XFS_AGI_MAGIC)
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
 		goto out_abort;
 
+	agi = XFS_BUF_TO_AGI(agibp);
 	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
 	offset = offsetof(xfs_agi_t, agi_unlinked) +
 		 (sizeof(xfs_agino_t) * bucket);
@@ -3190,16 +3187,17 @@ xlog_recover_process_iunlinks(
 		/*
 		 * Find the agi for this ag.
 		 */
-		agibp = xfs_buf_read(mp->m_ddev_targp,
-				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				XFS_FSS_TO_BB(mp, 1), 0);
-		if (XFS_BUF_ISERROR(agibp)) {
-			xfs_ioerror_alert("xlog_recover_process_iunlinks(#1)",
-				log->l_mp, agibp,
-				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)));
+		error = xfs_read_agi(mp, NULL, agno, &agibp);
+		if (error) {
+			/*
+			 * AGI is b0rked. Don't process it.
+			 *
+			 * We should probably mark the filesystem as corrupt
+			 * after we've recovered all the ag's we can....
+			 */
+			continue;
 		}
 		agi = XFS_BUF_TO_AGI(agibp);
-		ASSERT(XFS_AGI_MAGIC == be32_to_cpu(agi->agi_magicnum));
 
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
 
@@ -3278,22 +3276,12 @@ xlog_recover_process_iunlinks(
 
 				/*
 				 * Reacquire the agibuffer and continue around
-				 * the loop.
+				 * the loop. This should never fail as we know
+				 * the buffer was good earlier on.
 				 */
-				agibp = xfs_buf_read(mp->m_ddev_targp,
-						XFS_AG_DADDR(mp, agno,
-							XFS_AGI_DADDR(mp)),
-						XFS_FSS_TO_BB(mp, 1), 0);
-				if (XFS_BUF_ISERROR(agibp)) {
-					xfs_ioerror_alert(
-				"xlog_recover_process_iunlinks(#2)",
-						log->l_mp, agibp,
-						XFS_AG_DADDR(mp, agno,
-							XFS_AGI_DADDR(mp)));
-				}
+				error = xfs_read_agi(mp, NULL, agno, &agibp);
+				ASSERT(error == 0);
 				agi = XFS_BUF_TO_AGI(agibp);
-				ASSERT(XFS_AGI_MAGIC == be32_to_cpu(
-					agi->agi_magicnum));
 			}
 		}
 
@@ -3980,11 +3968,9 @@ xlog_recover_check_summary(
 {
 	xfs_mount_t	*mp;
 	xfs_agf_t	*agfp;
-	xfs_agi_t	*agip;
 	xfs_buf_t	*agfbp;
 	xfs_buf_t	*agibp;
 	xfs_daddr_t	agfdaddr;
-	xfs_daddr_t	agidaddr;
 	xfs_buf_t	*sbbp;
 #ifdef XFS_LOUD_RECOVERY
 	xfs_sb_t	*sbp;
@@ -3993,6 +3979,7 @@ xlog_recover_check_summary(
 	__uint64_t	freeblks;
 	__uint64_t	itotal;
 	__uint64_t	ifree;
+	int		error;
 
 	mp = log->l_mp;
 
@@ -4016,21 +4003,14 @@ xlog_recover_check_summary(
 			    be32_to_cpu(agfp->agf_flcount);
 		xfs_buf_relse(agfbp);
 
-		agidaddr = XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp));
-		agibp = xfs_buf_read(mp->m_ddev_targp, agidaddr,
-				XFS_FSS_TO_BB(mp, 1), 0);
-		if (XFS_BUF_ISERROR(agibp)) {
-			xfs_ioerror_alert("xlog_recover_check_summary(agi)",
-					  mp, agibp, agidaddr);
-		}
-		agip = XFS_BUF_TO_AGI(agibp);
-		ASSERT(XFS_AGI_MAGIC == be32_to_cpu(agip->agi_magicnum));
-		ASSERT(XFS_AGI_GOOD_VERSION(be32_to_cpu(agip->agi_versionnum)));
-		ASSERT(be32_to_cpu(agip->agi_seqno) == agno);
-
-		itotal += be32_to_cpu(agip->agi_count);
-		ifree += be32_to_cpu(agip->agi_freecount);
-		xfs_buf_relse(agibp);
+		error = xfs_read_agi(mp, NULL, agno, &agibp);
+		if (!error) {
+			struct xfs_agi	*agi = XFS_BUF_TO_AGI(agibp);
+
+			itotal += be32_to_cpu(agi->agi_count);
+			ifree += be32_to_cpu(agi->agi_freecount);
+			xfs_buf_relse(agibp);
+		}
 	}
 
 	sbbp = xfs_getsb(mp, 0);
