Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TE3f4s104823 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:03:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0A0E1D7DD2F
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:03:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NLqKziKcDC6ZKNcF for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 07:03:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QbvMg-0008EY-AG
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 14:03:38 +0000
Message-Id: <20110629140338.286808024@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 10:01:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/27] xfs: split xfs_itruncate_finish
References: <20110629140109.003209430@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-split-xfs_itruncate_finish
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

Split the guts of xfs_itruncate_finish that loop over the existing extents
and calls xfs_bunmapi on them into a new helper, xfs_itruncate_externs.
Make xfs_attr_inactive call it directly instead of xfs_itruncate_finish,
which allows to simplify the latter a lot, by only letting it deal with
the data fork.  As a result xfs_itruncate_finish is renamed to
xfs_itruncate_data to make its use case more obvious.

Also remove the sync parameter from xfs_itruncate_data, which has been
unessecary since the introduction of the busy extent list in 2002, and
completely dead code since 2003 when the XFS_BMAPI_ASYNC parameter was
made a no-op.

I can't actually see why the xfs_attr_inactive needs to set the transaction
sync, but let's keep this patch simple and without changes in behaviour.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2011-06-29 11:35:39.086158618 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2011-06-29 11:35:45.779455690 +0200
@@ -880,15 +880,7 @@ xfs_setattr_size(
 		ip->i_size = iattr->ia_size;
 	} else if (iattr->ia_size <= ip->i_size ||
 		   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
-		/*
-		 * Signal a sync transaction unless we are truncating an
-		 * already unlinked file on a wsync filesystem.
-		 */
-		error = xfs_itruncate_finish(&tp, ip, iattr->ia_size,
-				    XFS_DATA_FORK,
-				    ((ip->i_d.di_nlink != 0 ||
-				      !(mp->m_flags & XFS_MOUNT_WSYNC))
-				     ? 1 : 0));
+		error = xfs_itruncate_data(&tp, ip, iattr->ia_size);
 		if (error)
 			goto out_trans_abort;
 
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2011-06-29 11:35:39.112825141 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2011-06-29 11:35:45.782789005 +0200
@@ -263,7 +263,7 @@ xfs_qm_scall_trunc_qfile(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip);
 
-	error = xfs_itruncate_finish(&tp, ip, 0, XFS_DATA_FORK, 1);
+	error = xfs_itruncate_data(&tp, ip, 0);
 	if (error) {
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 				     XFS_TRANS_ABORT);
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-06-29 11:35:39.126158401 +0200
+++ xfs/fs/xfs/xfs_attr.c	2011-06-29 11:35:45.782789005 +0200
@@ -822,17 +822,21 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	error = xfs_attr_root_inactive(&trans, dp);
 	if (error)
 		goto out;
+
 	/*
-	 * signal synchronous inactive transactions unless this
-	 * is a synchronous mount filesystem in which case we
-	 * know that we're here because we've been called out of
-	 * xfs_inactive which means that the last reference is gone
-	 * and the unlink transaction has already hit the disk so
-	 * async inactive transactions are safe.
+	 * Signal synchronous inactive transactions unless this is a
+	 * synchronous mount filesystem in which case we know that we're here
+	 * because we've been called out of xfs_inactive which means that the
+	 * last reference is gone and the unlink transaction has already hit
+	 * the disk so async inactive transactions are safe.
 	 */
-	if ((error = xfs_itruncate_finish(&trans, dp, 0LL, XFS_ATTR_FORK,
-				(!(mp->m_flags & XFS_MOUNT_WSYNC)
-				 ? 1 : 0))))
+	if (!(mp->m_flags & XFS_MOUNT_WSYNC)) {
+		if (dp->i_d.di_anextents > 0)
+			xfs_trans_set_sync(trans);
+	}
+
+	error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
+	if (error)
 		goto out;
 
 	/*
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-06-29 11:35:39.136158346 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-06-29 11:38:24.515262411 +0200
@@ -52,7 +52,7 @@ kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
 
 /*
- * Used in xfs_itruncate().  This is the maximum number of extents
+ * Used in xfs_itruncate_extents().  This is the maximum number of extents
  * freed from a file in a single transaction.
  */
 #define	XFS_ITRUNC_MAX_EXTENTS	2
@@ -1218,7 +1218,9 @@ xfs_isize_check(
 
 /*
  * Free up the underlying blocks past new_size.  The new size must be
- * smaller than the current size.
+ * smaller than the current size.  This routine can be used both for
+ * the attribute and data fork, and does not modify the inode size,
+ * which is left to the caller.
  *
  * The transaction passed to this routine must have made a permanent log
  * reservation of at least XFS_ITRUNCATE_LOG_RES.  This routine may commit the
@@ -1230,31 +1232,6 @@ xfs_isize_check(
  * will be "held" within the returned transaction.  This routine does NOT
  * require any disk space to be reserved for it within the transaction.
  *
- * The fork parameter must be either XFS_ATTR_FORK or XFS_DATA_FORK, and it
- * indicates the fork which is to be truncated.  For the attribute fork we only
- * support truncation to size 0.
- *
- * We use the sync parameter to indicate whether or not the first transaction
- * we perform might have to be synchronous.  For the attr fork, it needs to be
- * so if the unlink of the inode is not yet known to be permanent in the log.
- * This keeps us from freeing and reusing the blocks of the attribute fork
- * before the unlink of the inode becomes permanent.
- *
- * For the data fork, we normally have to run synchronously if we're being
- * called out of the inactive path or we're being called out of the create path
- * where we're truncating an existing file.  Either way, the truncate needs to
- * be sync so blocks don't reappear in the file with altered data in case of a
- * crash.  wsync filesystems can run the first case async because anything that
- * shrinks the inode has to run sync so by the time we're called here from
- * inactive, the inode size is permanently set to 0.
- *
- * Calls from the truncate path always need to be sync unless we're in a wsync
- * filesystem and the file has already been unlinked.
- *
- * The caller is responsible for correctly setting the sync parameter.  It gets
- * too hard for us to guess here which path we're being called out of just
- * based on inode state.
- *
  * If we get an error, we must return with the inode locked and linked into the
  * current transaction. This keeps things simple for the higher level code,
  * because it always knows that the inode is locked and held in the transaction
@@ -1262,124 +1239,30 @@ xfs_isize_check(
  * dirty on error so that transactions can be easily aborted if possible.
  */
 int
-xfs_itruncate_finish(
-	xfs_trans_t	**tp,
-	xfs_inode_t	*ip,
-	xfs_fsize_t	new_size,
-	int		fork,
-	int		sync)
+xfs_itruncate_extents(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_fsize_t		new_size)
 {
-	xfs_fsblock_t	first_block;
-	xfs_fileoff_t	first_unmap_block;
-	xfs_fileoff_t	last_block;
-	xfs_filblks_t	unmap_len=0;
-	xfs_mount_t	*mp;
-	xfs_trans_t	*ntp;
-	int		done;
-	int		committed;
-	xfs_bmap_free_t	free_list;
-	int		error;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*ntp = *tpp;
+	xfs_bmap_free_t		free_list;
+	xfs_fsblock_t		first_block;
+	xfs_fileoff_t		first_unmap_block;
+	xfs_fileoff_t		last_block;
+	xfs_filblks_t		unmap_len;
+	int			committed;
+	int			error = 0;
+	int			done = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
-	ASSERT((new_size == 0) || (new_size <= ip->i_size));
-	ASSERT(*tp != NULL);
-	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
-	ASSERT(ip->i_transp == *tp);
+	ASSERT(new_size == 0 || new_size <= ip->i_size);
+	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT(ip->i_transp == *tpp);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(ip->i_itemp->ili_lock_flags == 0);
-
-
-	ntp = *tp;
-	mp = (ntp)->t_mountp;
-	ASSERT(! XFS_NOT_DQATTACHED(mp, ip));
-
-	/*
-	 * We only support truncating the entire attribute fork.
-	 */
-	if (fork == XFS_ATTR_FORK) {
-		new_size = 0LL;
-	}
-	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	trace_xfs_itruncate_finish_start(ip, new_size);
-
-	/*
-	 * The first thing we do is set the size to new_size permanently
-	 * on disk.  This way we don't have to worry about anyone ever
-	 * being able to look at the data being freed even in the face
-	 * of a crash.  What we're getting around here is the case where
-	 * we free a block, it is allocated to another file, it is written
-	 * to, and then we crash.  If the new data gets written to the
-	 * file but the log buffers containing the free and reallocation
-	 * don't, then we'd end up with garbage in the blocks being freed.
-	 * As long as we make the new_size permanent before actually
-	 * freeing any blocks it doesn't matter if they get written to.
-	 *
-	 * The callers must signal into us whether or not the size
-	 * setting here must be synchronous.  There are a few cases
-	 * where it doesn't have to be synchronous.  Those cases
-	 * occur if the file is unlinked and we know the unlink is
-	 * permanent or if the blocks being truncated are guaranteed
-	 * to be beyond the inode eof (regardless of the link count)
-	 * and the eof value is permanent.  Both of these cases occur
-	 * only on wsync-mounted filesystems.  In those cases, we're
-	 * guaranteed that no user will ever see the data in the blocks
-	 * that are being truncated so the truncate can run async.
-	 * In the free beyond eof case, the file may wind up with
-	 * more blocks allocated to it than it needs if we crash
-	 * and that won't get fixed until the next time the file
-	 * is re-opened and closed but that's ok as that shouldn't
-	 * be too many blocks.
-	 *
-	 * However, we can't just make all wsync xactions run async
-	 * because there's one call out of the create path that needs
-	 * to run sync where it's truncating an existing file to size
-	 * 0 whose size is > 0.
-	 *
-	 * It's probably possible to come up with a test in this
-	 * routine that would correctly distinguish all the above
-	 * cases from the values of the function parameters and the
-	 * inode state but for sanity's sake, I've decided to let the
-	 * layers above just tell us.  It's simpler to correctly figure
-	 * out in the layer above exactly under what conditions we
-	 * can run async and I think it's easier for others read and
-	 * follow the logic in case something has to be changed.
-	 * cscope is your friend -- rcc.
-	 *
-	 * The attribute fork is much simpler.
-	 *
-	 * For the attribute fork we allow the caller to tell us whether
-	 * the unlink of the inode that led to this call is yet permanent
-	 * in the on disk log.  If it is not and we will be freeing extents
-	 * in this inode then we make the first transaction synchronous
-	 * to make sure that the unlink is permanent by the time we free
-	 * the blocks.
-	 */
-	if (fork == XFS_DATA_FORK) {
-		if (ip->i_d.di_nextents > 0) {
-			/*
-			 * If we are not changing the file size then do
-			 * not update the on-disk file size - we may be
-			 * called from xfs_inactive_free_eofblocks().  If we
-			 * update the on-disk file size and then the system
-			 * crashes before the contents of the file are
-			 * flushed to disk then the files may be full of
-			 * holes (ie NULL files bug).
-			 */
-			if (ip->i_size != new_size) {
-				ip->i_d.di_size = new_size;
-				ip->i_size = new_size;
-				xfs_trans_log_inode(ntp, ip, XFS_ILOG_CORE);
-			}
-		}
-	} else if (sync) {
-		ASSERT(!(mp->m_flags & XFS_MOUNT_WSYNC));
-		if (ip->i_d.di_anextents > 0)
-			xfs_trans_set_sync(ntp);
-	}
-	ASSERT(fork == XFS_DATA_FORK ||
-		(fork == XFS_ATTR_FORK &&
-			((sync && !(mp->m_flags & XFS_MOUNT_WSYNC)) ||
-			 (sync == 0 && (mp->m_flags & XFS_MOUNT_WSYNC)))));
+	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	/*
 	 * Since it is possible for space to become allocated beyond
@@ -1390,70 +1273,34 @@ xfs_itruncate_finish(
 	 * beyond the maximum file size (ie it is the same as last_block),
 	 * then there is nothing to do.
 	 */
+	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
 	last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
-	ASSERT(first_unmap_block <= last_block);
-	done = 0;
-	if (last_block == first_unmap_block) {
-		done = 1;
-	} else {
-		unmap_len = last_block - first_unmap_block + 1;
-	}
+	if (first_unmap_block == last_block)
+		return 0;
+
+	ASSERT(first_unmap_block < last_block);
+	unmap_len = last_block - first_unmap_block + 1;
 	while (!done) {
-		/*
-		 * Free up up to XFS_ITRUNC_MAX_EXTENTS.  xfs_bunmapi()
-		 * will tell us whether it freed the entire range or
-		 * not.  If this is a synchronous mount (wsync),
-		 * then we can tell bunmapi to keep all the
-		 * transactions asynchronous since the unlink
-		 * transaction that made this inode inactive has
-		 * already hit the disk.  There's no danger of
-		 * the freed blocks being reused, there being a
-		 * crash, and the reused blocks suddenly reappearing
-		 * in this file with garbage in them once recovery
-		 * runs.
-		 */
 		xfs_bmap_init(&free_list, &first_block);
 		error = xfs_bunmapi(ntp, ip,
 				    first_unmap_block, unmap_len,
-				    xfs_bmapi_aflag(fork),
+				    xfs_bmapi_aflag(whichfork),
 				    XFS_ITRUNC_MAX_EXTENTS,
 				    &first_block, &free_list,
 				    &done);
-		if (error) {
-			/*
-			 * If the bunmapi call encounters an error,
-			 * return to the caller where the transaction
-			 * can be properly aborted.  We just need to
-			 * make sure we're not holding any resources
-			 * that we were not when we came in.
-			 */
-			xfs_bmap_cancel(&free_list);
-			return error;
-		}
+		if (error)
+			goto out_bmap_cancel;
 
 		/*
 		 * Duplicate the transaction that has the permanent
 		 * reservation and commit the old transaction.
 		 */
-		error = xfs_bmap_finish(tp, &free_list, &committed);
-		ntp = *tp;
+		error = xfs_bmap_finish(tpp, &free_list, &committed);
+		ntp = *tpp;
 		if (committed)
 			xfs_trans_ijoin(ntp, ip);
-
-		if (error) {
-			/*
-			 * If the bmap finish call encounters an error, return
-			 * to the caller where the transaction can be properly
-			 * aborted.  We just need to make sure we're not
-			 * holding any resources that we were not when we came
-			 * in.
-			 *
-			 * Aborting from this point might lose some blocks in
-			 * the file system, but oh well.
-			 */
-			xfs_bmap_cancel(&free_list);
-			return error;
-		}
+		if (error)
+			goto out_bmap_cancel;
 
 		if (committed) {
 			/*
@@ -1464,15 +1311,16 @@ xfs_itruncate_finish(
 		}
 
 		ntp = xfs_trans_dup(ntp);
-		error = xfs_trans_commit(*tp, 0);
-		*tp = ntp;
+		error = xfs_trans_commit(*tpp, 0);
+		*tpp = ntp;
 
 		xfs_trans_ijoin(ntp, ip);
 
 		if (error)
 			return error;
+
 		/*
-		 * transaction commit worked ok so we can drop the extra ticket
+		 * Transaction commit worked ok so we can drop the extra ticket
 		 * reference that we gained in xfs_trans_dup()
 		 */
 		xfs_log_ticket_put(ntp->t_ticket);
@@ -1483,35 +1331,85 @@ xfs_itruncate_finish(
 		if (error)
 			return error;
 	}
+
+	return 0;
+
+out_bmap_cancel:
+	/*
+	 * If the bunmapi call encounters an error, return to the caller where
+	 * the transaction can be properly aborted.  We just need to make sure
+	 * we're not holding any resources that we were not when we came in.
+	 */
+	xfs_bmap_cancel(&free_list);
+	return error;
+}
+
+int
+xfs_itruncate_data(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	xfs_fsize_t		new_size)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	trace_xfs_itruncate_data_start(ip, new_size);
+
 	/*
-	 * Only update the size in the case of the data fork, but
-	 * always re-log the inode so that our permanent transaction
-	 * can keep on rolling it forward in the log.
+	 * The first thing we do is set the size to new_size permanently on
+	 * disk.  This way we don't have to worry about anyone ever being able
+	 * to look at the data being freed even in the face of a crash.
+	 * What we're getting around here is the case where we free a block, it
+	 * is allocated to another file, it is written to, and then we crash.
+	 * If the new data gets written to the file but the log buffers
+	 * containing the free and reallocation don't, then we'd end up with
+	 * garbage in the blocks being freed.  As long as we make the new_size
+	 * permanent before actually freeing any blocks it doesn't matter if
+	 * they get written to.
 	 */
-	if (fork == XFS_DATA_FORK) {
-		xfs_isize_check(mp, ip, new_size);
+	if (ip->i_d.di_nextents > 0) {
 		/*
-		 * If we are not changing the file size then do
-		 * not update the on-disk file size - we may be
-		 * called from xfs_inactive_free_eofblocks().  If we
-		 * update the on-disk file size and then the system
-		 * crashes before the contents of the file are
-		 * flushed to disk then the files may be full of
-		 * holes (ie NULL files bug).
+		 * If we are not changing the file size then do not update
+		 * the on-disk file size - we may be called from
+		 * xfs_inactive_free_eofblocks().  If we update the on-disk
+		 * file size and then the system crashes before the contents
+		 * of the file are flushed to disk then the files may be
+		 * full of holes (ie NULL files bug).
 		 */
 		if (ip->i_size != new_size) {
 			ip->i_d.di_size = new_size;
 			ip->i_size = new_size;
+			xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
 		}
 	}
-	xfs_trans_log_inode(ntp, ip, XFS_ILOG_CORE);
-	ASSERT((new_size != 0) ||
-	       (fork == XFS_ATTR_FORK) ||
-	       (ip->i_delayed_blks == 0));
-	ASSERT((new_size != 0) ||
-	       (fork == XFS_ATTR_FORK) ||
-	       (ip->i_d.di_nextents == 0));
-	trace_xfs_itruncate_finish_end(ip, new_size);
+
+	error = xfs_itruncate_extents(tpp, ip, XFS_DATA_FORK, new_size);
+	if (error)
+		return error;
+
+	/*
+	 * If we are not changing the file size then do not update the on-disk
+	 * file size - we may be called from xfs_inactive_free_eofblocks().
+	 * If we update the on-disk file size and then the system crashes
+	 * before the contents of the file are flushed to disk then the files
+	 * may be full of holes (ie NULL files bug).
+	 */
+	xfs_isize_check(mp, ip, new_size);
+	if (ip->i_size != new_size) {
+		ip->i_d.di_size = new_size;
+		ip->i_size = new_size;
+	}
+
+	ASSERT(new_size != 0 || ip->i_delayed_blks == 0);
+	ASSERT(new_size != 0 || ip->i_d.di_nextents == 0);
+
+	/*
+	 * Always re-log the inode so that our permanent transaction can keep
+	 * on rolling it forward in the log.
+	 */
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+
+	trace_xfs_itruncate_data_end(ip, new_size);
 	return 0;
 }
 
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-06-29 11:35:39.146158294 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-06-29 11:35:45.789455635 +0200
@@ -491,8 +491,10 @@ uint		xfs_ip2xflags(struct xfs_inode *);
 uint		xfs_dic2xflags(struct xfs_dinode *);
 int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
 			   struct xfs_bmap_free *);
-int		xfs_itruncate_finish(struct xfs_trans **, xfs_inode_t *,
-				     xfs_fsize_t, int, int);
+int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
+				      int, xfs_fsize_t);
+int		xfs_itruncate_data(struct xfs_trans **, struct xfs_inode *,
+				   xfs_fsize_t);
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-06-29 11:35:39.162824869 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-06-29 11:35:45.789455635 +0200
@@ -220,15 +220,12 @@ xfs_free_eofblocks(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip);
 
-		error = xfs_itruncate_finish(&tp, ip,
-					     ip->i_size,
-					     XFS_DATA_FORK,
-					     0);
-		/*
-		 * If we get an error at this point we
-		 * simply don't bother truncating the file.
-		 */
+		error = xfs_itruncate_data(&tp, ip, ip->i_size);
 		if (error) {
+			/*
+			 * If we get an error at this point we simply don't
+			 * bother truncating the file.
+			 */
 			xfs_trans_cancel(tp,
 					 (XFS_TRANS_RELEASE_LOG_RES |
 					  XFS_TRANS_ABORT));
@@ -665,16 +662,7 @@ xfs_inactive(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip);
 
-		/*
-		 * normally, we have to run xfs_itruncate_finish sync.
-		 * But if filesystem is wsync and we're in the inactive
-		 * path, then we know that nlink == 0, and that the
-		 * xaction that made nlink == 0 is permanently committed
-		 * since xfs_remove runs as a synchronous transaction.
-		 */
-		error = xfs_itruncate_finish(&tp, ip, 0, XFS_DATA_FORK,
-				(!(mp->m_flags & XFS_MOUNT_WSYNC) ? 1 : 0));
-
+		error = xfs_itruncate_data(&tp, ip, 0);
 		if (error) {
 			xfs_trans_cancel(tp,
 				XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-06-29 11:35:39.099491878 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-06-29 11:35:45.792788951 +0200
@@ -1055,8 +1055,8 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
 DEFINE_EVENT(xfs_itrunc_class, name, \
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size), \
 	TP_ARGS(ip, new_size))
-DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_start);
-DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_end);
+DEFINE_ITRUNC_EVENT(xfs_itruncate_data_start);
+DEFINE_ITRUNC_EVENT(xfs_itruncate_data_end);
 
 TRACE_EVENT(xfs_pagecache_inval,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
