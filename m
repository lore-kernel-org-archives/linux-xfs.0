Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T9tC1I002257 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 03:55:12 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DnhTtTlpvhzCRhRv (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 01:55:09 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1S2gFZ-0006CC-Dr
	for xfs@oss.sgi.com; Wed, 29 Feb 2012 09:55:09 +0000
Message-Id: <20120229095509.376594756@bombadil.infradead.org>
Date: Wed, 29 Feb 2012 04:53:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/8] xfs: split in-core and on-disk inode log item fields
References: <20120229095347.009884687@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-ilf_fields-cleanup
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add a new ili_fields member to the inode log item to isolate the in-memory
flags from the ones that actually go to the log.  This will allow tracking
timestamp-only updates for fdatasync and O_DSYNC in the next patch and
prepares for divorcing the on-disk log format from the in-memory log item
a little further down the road.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dfrag.c       |   24 ++++++-------
 fs/xfs/xfs_inode.c       |   71 +++++++++++++++++++---------------------
 fs/xfs/xfs_inode_item.c  |   83 ++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_inode_item.h  |    4 +-
 fs/xfs/xfs_trans_inode.c |    4 +-
 5 files changed, 93 insertions(+), 93 deletions(-)

Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2012-02-28 11:54:03.011932343 +0100
+++ xfs/fs/xfs/xfs_dfrag.c	2012-02-28 12:02:29.639918817 +0100
@@ -215,7 +215,7 @@ xfs_swap_extents(
 	xfs_trans_t	*tp;
 	xfs_bstat_t	*sbp = &sxp->sx_stat;
 	xfs_ifork_t	*tempifp, *ifp, *tifp;
-	int		ilf_fields, tilf_fields;
+	int		src_log_flags, target_log_flags;
 	int		error = 0;
 	int		aforkblks = 0;
 	int		taforkblks = 0;
@@ -385,9 +385,8 @@ xfs_swap_extents(
 	tip->i_delayed_blks = ip->i_delayed_blks;
 	ip->i_delayed_blks = 0;
 
-	ilf_fields = XFS_ILOG_CORE;
-
-	switch(ip->i_d.di_format) {
+	src_log_flags = XFS_ILOG_CORE;
+	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		/* If the extents fit in the inode, fix the
 		 * pointer.  Otherwise it's already NULL or
@@ -397,16 +396,15 @@ xfs_swap_extents(
 			ifp->if_u1.if_extents =
 				ifp->if_u2.if_inline_ext;
 		}
-		ilf_fields |= XFS_ILOG_DEXT;
+		src_log_flags |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		ilf_fields |= XFS_ILOG_DBROOT;
+		src_log_flags |= XFS_ILOG_DBROOT;
 		break;
 	}
 
-	tilf_fields = XFS_ILOG_CORE;
-
-	switch(tip->i_d.di_format) {
+	target_log_flags = XFS_ILOG_CORE;
+	switch (tip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		/* If the extents fit in the inode, fix the
 		 * pointer.  Otherwise it's already NULL or
@@ -416,10 +414,10 @@ xfs_swap_extents(
 			tifp->if_u1.if_extents =
 				tifp->if_u2.if_inline_ext;
 		}
-		tilf_fields |= XFS_ILOG_DEXT;
+		target_log_flags |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		tilf_fields |= XFS_ILOG_DBROOT;
+		target_log_flags |= XFS_ILOG_DBROOT;
 		break;
 	}
 
@@ -427,8 +425,8 @@ xfs_swap_extents(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
-	xfs_trans_log_inode(tp, ip,  ilf_fields);
-	xfs_trans_log_inode(tp, tip, tilf_fields);
+	xfs_trans_log_inode(tp, ip,  src_log_flags);
+	xfs_trans_log_inode(tp, tip, target_log_flags);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2012-02-28 12:01:00.063921211 +0100
+++ xfs/fs/xfs/xfs_inode.c	2012-02-28 12:02:29.643918816 +0100
@@ -1661,8 +1661,8 @@ retry:
 				continue;
 			}
 
-			iip->ili_last_fields = iip->ili_format.ilf_fields;
-			iip->ili_format.ilf_fields = 0;
+			iip->ili_last_fields = iip->ili_fields;
+			iip->ili_fields = 0;
 			iip->ili_logged = 1;
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
@@ -2176,7 +2176,7 @@ xfs_iflush_fork(
 	mp = ip->i_mount;
 	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
-		if ((iip->ili_format.ilf_fields & dataflag[whichfork]) &&
+		if ((iip->ili_fields & dataflag[whichfork]) &&
 		    (ifp->if_bytes > 0)) {
 			ASSERT(ifp->if_u1.if_data != NULL);
 			ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
@@ -2186,8 +2186,8 @@ xfs_iflush_fork(
 
 	case XFS_DINODE_FMT_EXTENTS:
 		ASSERT((ifp->if_flags & XFS_IFEXTENTS) ||
-		       !(iip->ili_format.ilf_fields & extflag[whichfork]));
-		if ((iip->ili_format.ilf_fields & extflag[whichfork]) &&
+		       !(iip->ili_fields & extflag[whichfork]));
+		if ((iip->ili_fields & extflag[whichfork]) &&
 		    (ifp->if_bytes > 0)) {
 			ASSERT(xfs_iext_get_ext(ifp, 0));
 			ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) > 0);
@@ -2197,7 +2197,7 @@ xfs_iflush_fork(
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		if ((iip->ili_format.ilf_fields & brootflag[whichfork]) &&
+		if ((iip->ili_fields & brootflag[whichfork]) &&
 		    (ifp->if_broot_bytes > 0)) {
 			ASSERT(ifp->if_broot != NULL);
 			ASSERT(ifp->if_broot_bytes <=
@@ -2210,14 +2210,14 @@ xfs_iflush_fork(
 		break;
 
 	case XFS_DINODE_FMT_DEV:
-		if (iip->ili_format.ilf_fields & XFS_ILOG_DEV) {
+		if (iip->ili_fields & XFS_ILOG_DEV) {
 			ASSERT(whichfork == XFS_DATA_FORK);
 			xfs_dinode_put_rdev(dip, ip->i_df.if_u2.if_rdev);
 		}
 		break;
 
 	case XFS_DINODE_FMT_UUID:
-		if (iip->ili_format.ilf_fields & XFS_ILOG_UUID) {
+		if (iip->ili_fields & XFS_ILOG_UUID) {
 			ASSERT(whichfork == XFS_DATA_FORK);
 			memcpy(XFS_DFORK_DPTR(dip),
 			       &ip->i_df.if_u2.if_uuid,
@@ -2451,7 +2451,7 @@ xfs_iflush(
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
 		if (iip)
-			iip->ili_format.ilf_fields = 0;
+			iip->ili_fields = 0;
 		xfs_ifunlock(ip);
 		return XFS_ERROR(EIO);
 	}
@@ -2641,36 +2641,33 @@ xfs_iflush_int(
 	xfs_inobp_check(mp, bp);
 
 	/*
-	 * We've recorded everything logged in the inode, so we'd
-	 * like to clear the ilf_fields bits so we don't log and
-	 * flush things unnecessarily.  However, we can't stop
-	 * logging all this information until the data we've copied
-	 * into the disk buffer is written to disk.  If we did we might
-	 * overwrite the copy of the inode in the log with all the
-	 * data after re-logging only part of it, and in the face of
-	 * a crash we wouldn't have all the data we need to recover.
+	 * We've recorded everything logged in the inode, so we'd like to clear
+	 * the ili_fields bits so we don't log and flush things unnecessarily.
+	 * However, we can't stop logging all this information until the data
+	 * we've copied into the disk buffer is written to disk.  If we did we
+	 * might overwrite the copy of the inode in the log with all the data
+	 * after re-logging only part of it, and in the face of a crash we
+	 * wouldn't have all the data we need to recover.
 	 *
-	 * What we do is move the bits to the ili_last_fields field.
-	 * When logging the inode, these bits are moved back to the
-	 * ilf_fields field.  In the xfs_iflush_done() routine we
-	 * clear ili_last_fields, since we know that the information
-	 * those bits represent is permanently on disk.  As long as
-	 * the flush completes before the inode is logged again, then
-	 * both ilf_fields and ili_last_fields will be cleared.
+	 * What we do is move the bits to the ili_last_fields field.  When
+	 * logging the inode, these bits are moved back to the ili_fields field.
+	 * In the xfs_iflush_done() routine we clear ili_last_fields, since we
+	 * know that the information those bits represent is permanently on
+	 * disk.  As long as the flush completes before the inode is logged
+	 * again, then both ili_fields and ili_last_fields will be cleared.
 	 *
-	 * We can play with the ilf_fields bits here, because the inode
-	 * lock must be held exclusively in order to set bits there
-	 * and the flush lock protects the ili_last_fields bits.
-	 * Set ili_logged so the flush done
-	 * routine can tell whether or not to look in the AIL.
-	 * Also, store the current LSN of the inode so that we can tell
-	 * whether the item has moved in the AIL from xfs_iflush_done().
-	 * In order to read the lsn we need the AIL lock, because
-	 * it is a 64 bit value that cannot be read atomically.
-	 */
-	if (iip != NULL && iip->ili_format.ilf_fields != 0) {
-		iip->ili_last_fields = iip->ili_format.ilf_fields;
-		iip->ili_format.ilf_fields = 0;
+	 * We can play with the ili_fields bits here, because the inode lock
+	 * must be held exclusively in order to set bits there and the flush
+	 * lock protects the ili_last_fields bits.  Set ili_logged so the flush
+	 * done routine can tell whether or not to look in the AIL.  Also, store
+	 * the current LSN of the inode so that we can tell whether the item has
+	 * moved in the AIL from xfs_iflush_done().  In order to read the lsn we
+	 * need the AIL lock, because it is a 64 bit value that cannot be read
+	 * atomically.
+	 */
+	if (iip != NULL && iip->ili_fields != 0) {
+		iip->ili_last_fields = iip->ili_fields;
+		iip->ili_fields = 0;
 		iip->ili_logged = 1;
 
 		xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2012-02-28 12:02:00.899919585 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2012-02-28 12:02:29.643918816 +0100
@@ -59,20 +59,20 @@ xfs_inode_item_size(
 
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_DEXT) &&
+		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
 		    ip->i_d.di_nextents > 0 &&
 		    ip->i_df.if_bytes > 0)
 			nvecs++;
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_DBROOT) &&
+		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0)
 			nvecs++;
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_DDATA) &&
+		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0)
 			nvecs++;
 		break;
@@ -95,20 +95,20 @@ xfs_inode_item_size(
 	 */
 	switch (ip->i_d.di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_AEXT) &&
+		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
 		    ip->i_d.di_anextents > 0 &&
 		    ip->i_afp->if_bytes > 0)
 			nvecs++;
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_ABROOT) &&
+		if ((iip->ili_fields & XFS_ILOG_ABROOT) &&
 		    ip->i_afp->if_broot_bytes > 0)
 			nvecs++;
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_ADATA) &&
+		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0)
 			nvecs++;
 		break;
@@ -185,7 +185,6 @@ xfs_inode_item_format(
 	vecp->i_type = XLOG_REG_TYPE_ICORE;
 	vecp++;
 	nvecs++;
-	iip->ili_format.ilf_fields |= XFS_ILOG_CORE;
 
 	/*
 	 * If this is really an old format inode, then we need to
@@ -218,11 +217,11 @@ xfs_inode_item_format(
 
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
 			  XFS_ILOG_DEV | XFS_ILOG_UUID);
 
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_DEXT) &&
+		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
 		    ip->i_d.di_nextents > 0 &&
 		    ip->i_df.if_bytes > 0) {
 			ASSERT(ip->i_df.if_u1.if_extents != NULL);
@@ -251,16 +250,16 @@ xfs_inode_item_format(
 			vecp++;
 			nvecs++;
 		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_DEXT;
+			iip->ili_fields &= ~XFS_ILOG_DEXT;
 		}
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
 			  XFS_ILOG_DEV | XFS_ILOG_UUID);
 
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_DBROOT) &&
+		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			ASSERT(ip->i_df.if_broot != NULL);
 			vecp->i_addr = ip->i_df.if_broot;
@@ -270,7 +269,7 @@ xfs_inode_item_format(
 			nvecs++;
 			iip->ili_format.ilf_dsize = ip->i_df.if_broot_bytes;
 		} else {
-			ASSERT(!(iip->ili_format.ilf_fields &
+			ASSERT(!(iip->ili_fields &
 				 XFS_ILOG_DBROOT));
 #ifdef XFS_TRANS_DEBUG
 			if (iip->ili_root_size > 0) {
@@ -283,15 +282,15 @@ xfs_inode_item_format(
 				ASSERT(ip->i_df.if_broot_bytes == 0);
 			}
 #endif
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_DBROOT;
+			iip->ili_fields &= ~XFS_ILOG_DBROOT;
 		}
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
 			  XFS_ILOG_DEV | XFS_ILOG_UUID);
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_DDATA) &&
+		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
 			ASSERT(ip->i_d.di_size > 0);
@@ -311,25 +310,25 @@ xfs_inode_item_format(
 			nvecs++;
 			iip->ili_format.ilf_dsize = (unsigned)data_bytes;
 		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_DDATA;
+			iip->ili_fields &= ~XFS_ILOG_DDATA;
 		}
 		break;
 
 	case XFS_DINODE_FMT_DEV:
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
 			  XFS_ILOG_DEXT | XFS_ILOG_UUID);
-		if (iip->ili_format.ilf_fields & XFS_ILOG_DEV) {
+		if (iip->ili_fields & XFS_ILOG_DEV) {
 			iip->ili_format.ilf_u.ilfu_rdev =
 				ip->i_df.if_u2.if_rdev;
 		}
 		break;
 
 	case XFS_DINODE_FMT_UUID:
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
 			  XFS_ILOG_DEXT | XFS_ILOG_DEV);
-		if (iip->ili_format.ilf_fields & XFS_ILOG_UUID) {
+		if (iip->ili_fields & XFS_ILOG_UUID) {
 			iip->ili_format.ilf_u.ilfu_uuid =
 				ip->i_df.if_u2.if_uuid;
 		}
@@ -344,18 +343,17 @@ xfs_inode_item_format(
 	 * If there are no attributes associated with the file, then we're done.
 	 */
 	if (!XFS_IFORK_Q(ip)) {
-		iip->ili_format.ilf_size = nvecs;
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
-		return;
+		goto out;
 	}
 
 	switch (ip->i_d.di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
 
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_AEXT) &&
+		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
 		    ip->i_d.di_anextents > 0 &&
 		    ip->i_afp->if_bytes > 0) {
 			ASSERT(ip->i_afp->if_bytes / sizeof(xfs_bmbt_rec_t) ==
@@ -378,15 +376,15 @@ xfs_inode_item_format(
 			vecp++;
 			nvecs++;
 		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_AEXT;
+			iip->ili_fields &= ~XFS_ILOG_AEXT;
 		}
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_AEXT);
 
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_ABROOT) &&
+		if ((iip->ili_fields & XFS_ILOG_ABROOT) &&
 		    ip->i_afp->if_broot_bytes > 0) {
 			ASSERT(ip->i_afp->if_broot != NULL);
 
@@ -397,15 +395,15 @@ xfs_inode_item_format(
 			nvecs++;
 			iip->ili_format.ilf_asize = ip->i_afp->if_broot_bytes;
 		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_ABROOT;
+			iip->ili_fields &= ~XFS_ILOG_ABROOT;
 		}
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
-		iip->ili_format.ilf_fields &=
+		iip->ili_fields &=
 			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
 
-		if ((iip->ili_format.ilf_fields & XFS_ILOG_ADATA) &&
+		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0) {
 			ASSERT(ip->i_afp->if_u1.if_data != NULL);
 
@@ -424,7 +422,7 @@ xfs_inode_item_format(
 			nvecs++;
 			iip->ili_format.ilf_asize = (unsigned)data_bytes;
 		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_ADATA;
+			iip->ili_fields &= ~XFS_ILOG_ADATA;
 		}
 		break;
 
@@ -433,6 +431,14 @@ xfs_inode_item_format(
 		break;
 	}
 
+out:
+	/*
+	 * Now update the log format that goes out to disk from the in-core
+	 * values.  We always write the inode core to make the arithmetic
+	 * games in recovery easier, which isn't a big deal as just about any
+	 * transaction would dirty it anyway.
+	 */
+	iip->ili_format.ilf_fields = XFS_ILOG_CORE | iip->ili_fields;
 	iip->ili_format.ilf_size = nvecs;
 }
 
@@ -517,7 +523,7 @@ xfs_inode_item_trylock(
 
 #ifdef DEBUG
 	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		ASSERT(iip->ili_format.ilf_fields != 0);
+		ASSERT(iip->ili_fields != 0);
 		ASSERT(iip->ili_logged == 0);
 		ASSERT(lip->li_flags & XFS_LI_IN_AIL);
 	}
@@ -549,7 +555,7 @@ xfs_inode_item_unlock(
 	if (iip->ili_extents_buf != NULL) {
 		ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS);
 		ASSERT(ip->i_d.di_nextents > 0);
-		ASSERT(iip->ili_format.ilf_fields & XFS_ILOG_DEXT);
+		ASSERT(iip->ili_fields & XFS_ILOG_DEXT);
 		ASSERT(ip->i_df.if_bytes > 0);
 		kmem_free(iip->ili_extents_buf);
 		iip->ili_extents_buf = NULL;
@@ -557,7 +563,7 @@ xfs_inode_item_unlock(
 	if (iip->ili_aextents_buf != NULL) {
 		ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS);
 		ASSERT(ip->i_d.di_anextents > 0);
-		ASSERT(iip->ili_format.ilf_fields & XFS_ILOG_AEXT);
+		ASSERT(iip->ili_fields & XFS_ILOG_AEXT);
 		ASSERT(ip->i_afp->if_bytes > 0);
 		kmem_free(iip->ili_aextents_buf);
 		iip->ili_aextents_buf = NULL;
@@ -672,8 +678,7 @@ xfs_inode_item_push(
 	 * lock without sleeping, then there must not have been
 	 * anyone in the process of flushing the inode.
 	 */
-	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) ||
-	       iip->ili_format.ilf_fields != 0);
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || iip->ili_fields != 0);
 
 	/*
 	 * Push the inode to it's backing buffer. This will not remove the
@@ -896,7 +901,7 @@ xfs_iflush_abort(
 		 * Clear the inode logging fields so no more flushes are
 		 * attempted.
 		 */
-		iip->ili_format.ilf_fields = 0;
+		iip->ili_fields = 0;
 	}
 	/*
 	 * Release the inode's flush lock since we're done with it.
Index: xfs/fs/xfs/xfs_inode_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.h	2012-02-28 12:01:00.071921207 +0100
+++ xfs/fs/xfs/xfs_inode_item.h	2012-02-28 12:02:29.643918816 +0100
@@ -134,6 +134,7 @@ typedef struct xfs_inode_log_item {
 	unsigned short		ili_lock_flags;	   /* lock flags */
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
+	unsigned int		ili_fields;	   /* fields to be logged */
 	struct xfs_bmbt_rec	*ili_extents_buf;  /* array of logged
 						      data exts */
 	struct xfs_bmbt_rec	*ili_aextents_buf; /* array of logged
@@ -148,8 +149,7 @@ typedef struct xfs_inode_log_item {
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
 {
-	return !ip->i_itemp ||
-		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL);
+	return !ip->i_itemp || !(ip->i_itemp->ili_fields & XFS_ILOG_ALL);
 }
 
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2012-02-28 12:01:00.071921207 +0100
+++ xfs/fs/xfs/xfs_trans_inode.c	2012-02-28 12:02:29.643918816 +0100
@@ -130,12 +130,12 @@ xfs_trans_log_inode(
 	/*
 	 * Always OR in the bits from the ili_last_fields field.
 	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
-	 * routines in the eventual clearing of the ilf_fields bits.
+	 * routines in the eventual clearing of the ili_fields bits.
 	 * See the big comment in xfs_iflush() for an explanation of
 	 * this coordination mechanism.
 	 */
 	flags |= ip->i_itemp->ili_last_fields;
-	ip->i_itemp->ili_format.ilf_fields |= flags;
+	ip->i_itemp->ili_fields |= flags;
 }
 
 #ifdef XFS_TRANS_DEBUG

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
