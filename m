Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08BURjX036339 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 05:30:28 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2100CEEB2D5
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 03:31:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	CRqsybUXJkXs6gFh for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2010 03:31:17 -0800 (PST)
Date: Fri, 8 Jan 2010 22:31:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Inode reclaim fixes (was Re: 2.6.31 xfs_fs_destroy_inode:
	cannot reclaim)
Message-ID: <20100108113114.GA8654@discord.disaster>
References: <89c4f90c0910270341r7833f490g60810f2817eb0950@mail.gmail.com>
	<89c4f90c0910280519k759230c1r7b1586932ac792f7@mail.gmail.com>
	<20091030101601.GA11142@infradead.org>
	<4AF0422D.1070104@news-service.com>
	<20091114162126.GB17658@infradead.org>
	<4B0A8075.8080008@news-service.com>
	<20091211115932.GA20632@infradead.org>
	<4B3F9F88.9030307@news-service.com>
	<20100107110446.GA13802@discord.disaster>
	<4B45CFAC.4000607@news-service.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B45CFAC.4000607@news-service.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Patrick,

I've attached two compendium patches that will hopefully fix
the inode reclaim problems you've been seeing - one is for 2.6.31,
the other is for 2.6.32. I've cc'd this to the XFS list ѕo that
anyone else who has been seeing crashes, assert failures and
general nastiness around inode reclaim can test them as well.

These are not final patches - there's a few changes that Christoph
has picked up on during review - so there'll be another round of
patches before checkins and -stable backports can be requested.

I'm hoping that these patches fix your problem, because with them
I can't make my machines fall over anymore....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs-inode-reclaim-2.6.31"

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a220d36..793f5d0 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -926,13 +926,37 @@ xfs_fs_alloc_inode(
  */
 STATIC void
 xfs_fs_destroy_inode(
-	struct inode	*inode)
+	struct inode		*inode)
 {
-	xfs_inode_t		*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	xfs_itrace_entry(ip);
 
 	XFS_STATS_INC(vn_reclaim);
-	if (xfs_reclaim(ip))
-		panic("%s: cannot reclaim 0x%p\n", __func__, inode);
+
+	/* bad inode, get out here ASAP */
+	if (is_bad_inode(inode))
+		goto out_reclaim;
+
+	xfs_ioend_wait(ip);
+
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+
+	/*
+	 * We should never get here with one of the reclaim flags already set.
+	 */
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+
+	/*
+	 * we always use background reclaim here because even if the
+	 * inode is clean, it still may be under IO and hence we have
+	 * to take the flush lock. The background reclaim path handles
+	 * this more efficiently than we can here, so simply let background
+	 * reclaim tear down all inodes.
+	 */
+out_reclaim:
+	xfs_inode_set_reclaim_tag(ip);
 }
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 98ef624..cfc2e70 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -54,7 +54,8 @@ xfs_inode_ag_lookup(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	uint32_t		*first_index,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	int			nr_found;
 	struct xfs_inode	*ip;
@@ -64,7 +65,10 @@ xfs_inode_ag_lookup(
 	 * as the tree is sparse and a gang lookup walks to find
 	 * the number of objects requested.
 	 */
-	read_lock(&pag->pag_ici_lock);
+	if (write_lock)
+		write_lock(&pag->pag_ici_lock);
+	else
+		read_lock(&pag->pag_ici_lock);
 	if (tag == XFS_ICI_NO_TAG) {
 		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 				(void **)&ip, *first_index, 1);
@@ -88,7 +92,10 @@ xfs_inode_ag_lookup(
 	return ip;
 
 unlock:
-	read_unlock(&pag->pag_ici_lock);
+	if (write_lock)
+		write_unlock(&pag->pag_ici_lock);
+	else
+		read_unlock(&pag->pag_ici_lock);
 	return NULL;
 }
 
@@ -99,7 +106,8 @@ xfs_inode_ag_walk(
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	struct xfs_perag	*pag = &mp->m_perag[ag];
 	uint32_t		first_index;
@@ -113,7 +121,8 @@ restart:
 		int		error = 0;
 		xfs_inode_t	*ip;
 
-		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
+		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag,
+						write_lock);
 		if (!ip)
 			break;
 
@@ -147,7 +156,8 @@ xfs_inode_ag_iterator(
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	int			error = 0;
 	int			last_error = 0;
@@ -156,7 +166,8 @@ xfs_inode_ag_iterator(
 	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
 		if (!mp->m_perag[ag].pag_ici_init)
 			continue;
-		error = xfs_inode_ag_walk(mp, ag, execute, flags, tag);
+		error = xfs_inode_ag_walk(mp, ag, execute, flags, tag,
+					write_lock);
 		if (error) {
 			last_error = error;
 			if (error == EFSCORRUPTED)
@@ -180,18 +191,20 @@ xfs_sync_inode_valid(
 		return EFSCORRUPTED;
 	}
 
-	/*
-	 * If we can't get a reference on the inode, it must be in reclaim.
-	 * Leave it for the reclaim code to flush. Also avoid inodes that
-	 * haven't been fully initialised.
-	 */
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM)) {
+		read_unlock(&pag->pag_ici_lock);
+		return ENOENT;
+	}
+
+	/* If we can't get a reference on the inode, it must be in reclaim. */
 	if (!igrab(inode)) {
 		read_unlock(&pag->pag_ici_lock);
 		return ENOENT;
 	}
 	read_unlock(&pag->pag_ici_lock);
 
-	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+	if (is_bad_inode(inode)) {
 		IRELE(ip);
 		return ENOENT;
 	}
@@ -281,7 +294,7 @@ xfs_sync_data(
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
 	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags,
-				      XFS_ICI_NO_TAG);
+				      XFS_ICI_NO_TAG, 0);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -303,7 +316,7 @@ xfs_sync_attr(
 	ASSERT((flags & ~SYNC_WAIT) == 0);
 
 	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags,
-				     XFS_ICI_NO_TAG);
+				     XFS_ICI_NO_TAG, 0);
 }
 
 STATIC int
@@ -647,36 +660,11 @@ xfs_syncd_stop(
 	kthread_stop(mp->m_sync_task);
 }
 
-int
+STATIC int
 xfs_reclaim_inode(
 	xfs_inode_t	*ip,
-	int		locked,
 	int		sync_mode)
 {
-	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
-
-	/* The hash lock here protects a thread in xfs_iget_core from
-	 * racing with us on linking the inode back with a vnode.
-	 * Once we have the XFS_IRECLAIM flag set it will not touch
-	 * us.
-	 */
-	write_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
-	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
-		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
-		if (locked) {
-			xfs_ifunlock(ip);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
-		return -EAGAIN;
-	}
-	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(ip->i_mount, pag);
-
 	/*
 	 * If the inode is still dirty, then flush it out.  If the inode
 	 * is not in the AIL, then it will be OK to flush it delwri as
@@ -688,14 +676,14 @@ xfs_reclaim_inode(
 	 * We get the flush lock regardless, though, just to make sure
 	 * we don't free it while it is being flushed.
 	 */
-	if (!locked) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_iflock(ip);
-	}
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_iflock(ip);
 
 	/*
 	 * In the case of a forced shutdown we rely on xfs_iflush() to
 	 * wait for the inode to be unpinned before returning an error.
+	 * Because we hold the flush lock, we know that the inode cannot
+	 * be under IO, so if it reports clean it can be reclaimed.
 	 */
 	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
 		/* synchronize with xfs_iflush_done */
@@ -770,14 +758,24 @@ xfs_reclaim_inode_now(
 	struct xfs_perag	*pag,
 	int			flags)
 {
-	/* ignore if already under reclaim */
-	if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-		read_unlock(&pag->pag_ici_lock);
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget from racing
+	 * with us starting reclaim on the inode.  Once we have the
+	 * XFS_IRECLAIM flag set it will not touch us.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
+		/* ignore as it is already under reclaim */
+		spin_unlock(&ip->i_flags_lock);
+		write_unlock(&pag->pag_ici_lock);
 		return 0;
 	}
-	read_unlock(&pag->pag_ici_lock);
+	__xfs_iflags_set(ip, XFS_IRECLAIM);
+	spin_unlock(&ip->i_flags_lock);
+	write_unlock(&pag->pag_ici_lock);
 
-	return xfs_reclaim_inode(ip, 0, flags);
+	return xfs_reclaim_inode(ip, flags);
 }
 
 int
@@ -786,5 +784,5 @@ xfs_reclaim_inodes(
 	int		mode)
 {
 	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode_now, mode,
-					XFS_ICI_RECLAIM_TAG);
+					XFS_ICI_RECLAIM_TAG, 1);
 }
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 5912060..0cef0b8 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -44,7 +44,6 @@ void xfs_quiesce_attr(struct xfs_mount *mp);
 
 void xfs_flush_inodes(struct xfs_inode *ip);
 
-int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
@@ -56,6 +55,6 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags, int tag);
+	int flags, int tag, int write_lock);
 
 #endif
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 4e4276b..1024e4f 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -894,7 +894,7 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG, 0);
 }
 
 /*------------------------------------------------------------------------*/
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index ecbf8b4..883bca9 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -538,17 +538,21 @@ xfs_ireclaim(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 
 	XFS_STATS_INC(xs_ig_reclaims);
 
 	/*
-	 * Remove the inode from the per-AG radix tree.  It doesn't matter
-	 * if it was never added to it because radix_tree_delete can deal
-	 * with that case just fine.
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
 	 */
 	pag = xfs_get_perag(mp, ip->i_ino);
 	write_lock(&pag->pag_ici_lock);
-	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	if (!radix_tree_delete(&pag->pag_ici_root, agino))
+		ASSERT(0);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index da428b3..64373bc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2877,10 +2877,14 @@ xfs_iflush(
 	mp = ip->i_mount;
 
 	/*
-	 * If the inode isn't dirty, then just release the inode
-	 * flush lock and do nothing.
+	 * If the inode isn't dirty, then just release the inode flush lock and
+	 * do nothing. Treat stale inodes the same; we cannot rely on the
+	 * backing buffer remaining stale in cache for the remaining life of
+	 * the stale inode and so xfs_itobp() below may give us a buffer that
+	 * no longer contains inodes below. Doing this stale check here also
+	 * avoids forcing the log on pinned, stale inodes.
 	 */
-	if (xfs_inode_clean(ip)) {
+	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 492d75b..15875e5 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2461,52 +2461,6 @@ xfs_set_dmattrs(
 	return error;
 }
 
-int
-xfs_reclaim(
-	xfs_inode_t	*ip)
-{
-
-	xfs_itrace_entry(ip);
-
-	ASSERT(!VN_MAPPED(VFS_I(ip)));
-
-	/* bad inode, get out here ASAP */
-	if (is_bad_inode(VFS_I(ip))) {
-		xfs_ireclaim(ip);
-		return 0;
-	}
-
-	xfs_ioend_wait(ip);
-
-	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
-
-	/*
-	 * Make sure the atime in the XFS inode is correct before freeing the
-	 * Linux inode.
-	 */
-	xfs_synchronize_atime(ip);
-
-	/*
-	 * If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise break the link between the xfs inode and the
-	 * linux inode and clean up the xfs inode later. This avoids flushing
-	 * the inode to disk during the delete operation itself.
-	 *
-	 * When breaking the link, we need to set the XFS_IRECLAIMABLE flag
-	 * first to ensure that xfs_iunpin() will never see an xfs inode
-	 * that has a linux inode being reclaimed. Synchronisation is provided
-	 * by the i_flags_lock.
-	 */
-	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_iflock(ip);
-		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		return xfs_reclaim_inode(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
-	}
-	xfs_inode_set_reclaim_tag(ip);
-	return 0;
-}
-
 /*
  * xfs_alloc_file_space()
  *      This routine allocates disk space for the given file.
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index a9e102d..167a467 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -38,7 +38,6 @@ int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, mode_t mode, struct xfs_inode **ipp,
 		cred_t *credp);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
-int xfs_reclaim(struct xfs_inode *ip);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
 		xfs_flock64_t *bf, xfs_off_t offset, int attr_flags);
 int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs-inode-reclaim-2.6.32"

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 18a4b8e..f3c622a 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -930,13 +930,37 @@ xfs_fs_alloc_inode(
  */
 STATIC void
 xfs_fs_destroy_inode(
-	struct inode	*inode)
+	struct inode		*inode)
 {
-	xfs_inode_t		*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	xfs_itrace_entry(ip);
 
 	XFS_STATS_INC(vn_reclaim);
-	if (xfs_reclaim(ip))
-		panic("%s: cannot reclaim 0x%p\n", __func__, inode);
+
+	/* bad inode, get out here ASAP */
+	if (is_bad_inode(inode))
+		goto out_reclaim;
+
+	xfs_ioend_wait(ip);
+
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+
+	/*
+	 * We should never get here with one of the reclaim flags already set.
+	 */
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+
+	/*
+	 * we always use background reclaim here because even if the
+	 * inode is clean, it still may be under IO and hence we have
+	 * to take the flush lock. The background reclaim path handles
+	 * this more efficiently than we can here, so simply let background
+	 * reclaim tear down all inodes.
+	 */
+out_reclaim:
+	xfs_inode_set_reclaim_tag(ip);
 }
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 961df0a..897fcb5 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -54,7 +54,8 @@ xfs_inode_ag_lookup(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	uint32_t		*first_index,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	int			nr_found;
 	struct xfs_inode	*ip;
@@ -64,7 +65,10 @@ xfs_inode_ag_lookup(
 	 * as the tree is sparse and a gang lookup walks to find
 	 * the number of objects requested.
 	 */
-	read_lock(&pag->pag_ici_lock);
+	if (write_lock)
+		write_lock(&pag->pag_ici_lock);
+	else
+		read_lock(&pag->pag_ici_lock);
 	if (tag == XFS_ICI_NO_TAG) {
 		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 				(void **)&ip, *first_index, 1);
@@ -88,7 +92,10 @@ xfs_inode_ag_lookup(
 	return ip;
 
 unlock:
-	read_unlock(&pag->pag_ici_lock);
+	if (write_lock)
+		write_unlock(&pag->pag_ici_lock);
+	else
+		read_unlock(&pag->pag_ici_lock);
 	return NULL;
 }
 
@@ -99,7 +106,8 @@ xfs_inode_ag_walk(
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	struct xfs_perag	*pag = &mp->m_perag[ag];
 	uint32_t		first_index;
@@ -113,7 +121,8 @@ restart:
 		int		error = 0;
 		xfs_inode_t	*ip;
 
-		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
+		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag,
+						write_lock);
 		if (!ip)
 			break;
 
@@ -147,7 +156,8 @@ xfs_inode_ag_iterator(
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	int			error = 0;
 	int			last_error = 0;
@@ -156,7 +166,8 @@ xfs_inode_ag_iterator(
 	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
 		if (!mp->m_perag[ag].pag_ici_init)
 			continue;
-		error = xfs_inode_ag_walk(mp, ag, execute, flags, tag);
+		error = xfs_inode_ag_walk(mp, ag, execute, flags, tag,
+					write_lock);
 		if (error) {
 			last_error = error;
 			if (error == EFSCORRUPTED)
@@ -180,18 +191,20 @@ xfs_sync_inode_valid(
 		return EFSCORRUPTED;
 	}
 
-	/*
-	 * If we can't get a reference on the inode, it must be in reclaim.
-	 * Leave it for the reclaim code to flush. Also avoid inodes that
-	 * haven't been fully initialised.
-	 */
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM)) {
+		read_unlock(&pag->pag_ici_lock);
+		return ENOENT;
+	}
+
+	/* If we can't get a reference on the inode, it must be in reclaim. */
 	if (!igrab(inode)) {
 		read_unlock(&pag->pag_ici_lock);
 		return ENOENT;
 	}
 	read_unlock(&pag->pag_ici_lock);
 
-	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+	if (is_bad_inode(inode)) {
 		IRELE(ip);
 		return ENOENT;
 	}
@@ -281,7 +294,7 @@ xfs_sync_data(
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
 	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags,
-				      XFS_ICI_NO_TAG);
+				      XFS_ICI_NO_TAG, 0);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -303,7 +316,7 @@ xfs_sync_attr(
 	ASSERT((flags & ~SYNC_WAIT) == 0);
 
 	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags,
-				     XFS_ICI_NO_TAG);
+				     XFS_ICI_NO_TAG, 0);
 }
 
 STATIC int
@@ -663,36 +676,11 @@ xfs_syncd_stop(
 	kthread_stop(mp->m_sync_task);
 }
 
-int
+STATIC int
 xfs_reclaim_inode(
 	xfs_inode_t	*ip,
-	int		locked,
 	int		sync_mode)
 {
-	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
-
-	/* The hash lock here protects a thread in xfs_iget_core from
-	 * racing with us on linking the inode back with a vnode.
-	 * Once we have the XFS_IRECLAIM flag set it will not touch
-	 * us.
-	 */
-	write_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
-	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
-		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
-		if (locked) {
-			xfs_ifunlock(ip);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
-		return -EAGAIN;
-	}
-	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(ip->i_mount, pag);
-
 	/*
 	 * If the inode is still dirty, then flush it out.  If the inode
 	 * is not in the AIL, then it will be OK to flush it delwri as
@@ -704,14 +692,14 @@ xfs_reclaim_inode(
 	 * We get the flush lock regardless, though, just to make sure
 	 * we don't free it while it is being flushed.
 	 */
-	if (!locked) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_iflock(ip);
-	}
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_iflock(ip);
 
 	/*
 	 * In the case of a forced shutdown we rely on xfs_iflush() to
 	 * wait for the inode to be unpinned before returning an error.
+	 * Because we hold the flush lock, we know that the inode cannot
+	 * be under IO, so if it reports clean it can be reclaimed.
 	 */
 	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
 		/* synchronize with xfs_iflush_done */
@@ -771,14 +759,24 @@ xfs_reclaim_inode_now(
 	struct xfs_perag	*pag,
 	int			flags)
 {
-	/* ignore if already under reclaim */
-	if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-		read_unlock(&pag->pag_ici_lock);
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget from racing
+	 * with us starting reclaim on the inode.  Once we have the
+	 * XFS_IRECLAIM flag set it will not touch us.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
+		/* ignore as it is already under reclaim */
+		spin_unlock(&ip->i_flags_lock);
+		write_unlock(&pag->pag_ici_lock);
 		return 0;
 	}
-	read_unlock(&pag->pag_ici_lock);
+	__xfs_iflags_set(ip, XFS_IRECLAIM);
+	spin_unlock(&ip->i_flags_lock);
+	write_unlock(&pag->pag_ici_lock);
 
-	return xfs_reclaim_inode(ip, 0, flags);
+	return xfs_reclaim_inode(ip, flags);
 }
 
 int
@@ -787,5 +785,5 @@ xfs_reclaim_inodes(
 	int		mode)
 {
 	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode_now, mode,
-					XFS_ICI_RECLAIM_TAG);
+					XFS_ICI_RECLAIM_TAG, 1);
 }
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 27920eb..ea932b4 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -44,7 +44,6 @@ void xfs_quiesce_attr(struct xfs_mount *mp);
 
 void xfs_flush_inodes(struct xfs_inode *ip);
 
-int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
@@ -55,6 +54,6 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags, int tag);
+	int flags, int tag, int write_lock);
 
 #endif
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 5d1a3b9..f99cfa4 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -893,7 +893,7 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG, 0);
 }
 
 /*------------------------------------------------------------------------*/
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 80e5264..40e8775 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -511,17 +511,21 @@ xfs_ireclaim(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 
 	XFS_STATS_INC(xs_ig_reclaims);
 
 	/*
-	 * Remove the inode from the per-AG radix tree.  It doesn't matter
-	 * if it was never added to it because radix_tree_delete can deal
-	 * with that case just fine.
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
 	 */
 	pag = xfs_get_perag(mp, ip->i_ino);
 	write_lock(&pag->pag_ici_lock);
-	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	if (!radix_tree_delete(&pag->pag_ici_root, agino))
+		ASSERT(0);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b92a4fa..13d7d21 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2877,10 +2877,14 @@ xfs_iflush(
 	mp = ip->i_mount;
 
 	/*
-	 * If the inode isn't dirty, then just release the inode
-	 * flush lock and do nothing.
+	 * If the inode isn't dirty, then just release the inode flush lock and
+	 * do nothing. Treat stale inodes the same; we cannot rely on the
+	 * backing buffer remaining stale in cache for the remaining life of
+	 * the stale inode and so xfs_itobp() below may give us a buffer that
+	 * no longer contains inodes below. Doing this stale check here also
+	 * avoids forcing the log on pinned, stale inodes.
 	 */
-	if (xfs_inode_clean(ip)) {
+	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index b572f7e..3fac146 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2456,46 +2456,6 @@ xfs_set_dmattrs(
 	return error;
 }
 
-int
-xfs_reclaim(
-	xfs_inode_t	*ip)
-{
-
-	xfs_itrace_entry(ip);
-
-	ASSERT(!VN_MAPPED(VFS_I(ip)));
-
-	/* bad inode, get out here ASAP */
-	if (is_bad_inode(VFS_I(ip))) {
-		xfs_ireclaim(ip);
-		return 0;
-	}
-
-	xfs_ioend_wait(ip);
-
-	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
-
-	/*
-	 * If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise break the link between the xfs inode and the
-	 * linux inode and clean up the xfs inode later. This avoids flushing
-	 * the inode to disk during the delete operation itself.
-	 *
-	 * When breaking the link, we need to set the XFS_IRECLAIMABLE flag
-	 * first to ensure that xfs_iunpin() will never see an xfs inode
-	 * that has a linux inode being reclaimed. Synchronisation is provided
-	 * by the i_flags_lock.
-	 */
-	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_iflock(ip);
-		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		return xfs_reclaim_inode(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
-	}
-	xfs_inode_set_reclaim_tag(ip);
-	return 0;
-}
-
 /*
  * xfs_alloc_file_space()
  *      This routine allocates disk space for the given file.
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index a9e102d..167a467 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -38,7 +38,6 @@ int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, mode_t mode, struct xfs_inode **ipp,
 		cred_t *credp);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
-int xfs_reclaim(struct xfs_inode *ip);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
 		xfs_flock64_t *bf, xfs_off_t offset, int attr_flags);
 int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--ReaqsoxgOBHFXBhH--
