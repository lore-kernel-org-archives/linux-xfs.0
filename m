Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6190C7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 15:48:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25066304039
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 13:48:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nbkJJ98ZAJQPxtnC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2014 13:48:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WNTaq-0003cL-2k
	for xfs@oss.sgi.com; Tue, 11 Mar 2014 20:48:08 +0000
Date: Tue, 11 Mar 2014 13:48:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfs: simplify filestreams by taking advantake of the
	dentry cache
Message-ID: <20140311204808.GA13875@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

In Linux we will always be able to find a parent for a file that is
currently active for I/O. Take care of this fact by using the dcache for
doing parent lookups.  While the dcache has lots of hot locks and cache
lines I suspect this is still better than filling the mru cache with
items for all active files that have filestreams.  If however hitting
the dcache hard in this path causes problems with might have to use
a different strategy here.

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 12b6e77..2ffb10a 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -32,100 +32,27 @@
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
 
-#ifdef XFS_FILESTREAMS_TRACE
-
-ktrace_t *xfs_filestreams_trace_buf;
-
-STATIC void
-xfs_filestreams_trace(
-	xfs_mount_t	*mp,	/* mount point */
-	int		type,	/* type of trace */
-	const char	*func,	/* source function */
-	int		line,	/* source line number */
-	__psunsigned_t	arg0,
-	__psunsigned_t	arg1,
-	__psunsigned_t	arg2,
-	__psunsigned_t	arg3,
-	__psunsigned_t	arg4,
-	__psunsigned_t	arg5)
-{
-	ktrace_enter(xfs_filestreams_trace_buf,
-		(void *)(__psint_t)(type | (line << 16)),
-		(void *)func,
-		(void *)(__psunsigned_t)current_pid(),
-		(void *)mp,
-		(void *)(__psunsigned_t)arg0,
-		(void *)(__psunsigned_t)arg1,
-		(void *)(__psunsigned_t)arg2,
-		(void *)(__psunsigned_t)arg3,
-		(void *)(__psunsigned_t)arg4,
-		(void *)(__psunsigned_t)arg5,
-		NULL, NULL, NULL, NULL, NULL, NULL);
-}
-
-#define TRACE0(mp,t)			TRACE6(mp,t,0,0,0,0,0,0)
-#define TRACE1(mp,t,a0)			TRACE6(mp,t,a0,0,0,0,0,0)
-#define TRACE2(mp,t,a0,a1)		TRACE6(mp,t,a0,a1,0,0,0,0)
-#define TRACE3(mp,t,a0,a1,a2)		TRACE6(mp,t,a0,a1,a2,0,0,0)
-#define TRACE4(mp,t,a0,a1,a2,a3)	TRACE6(mp,t,a0,a1,a2,a3,0,0)
-#define TRACE5(mp,t,a0,a1,a2,a3,a4)	TRACE6(mp,t,a0,a1,a2,a3,a4,0)
-#define TRACE6(mp,t,a0,a1,a2,a3,a4,a5) \
-	xfs_filestreams_trace(mp, t, __func__, __LINE__, \
-				(__psunsigned_t)a0, (__psunsigned_t)a1, \
-				(__psunsigned_t)a2, (__psunsigned_t)a3, \
-				(__psunsigned_t)a4, (__psunsigned_t)a5)
-
-#define TRACE_AG_SCAN(mp, ag, ag2) \
-		TRACE2(mp, XFS_FSTRM_KTRACE_AGSCAN, ag, ag2);
-#define TRACE_AG_PICK1(mp, max_ag, maxfree) \
-		TRACE2(mp, XFS_FSTRM_KTRACE_AGPICK1, max_ag, maxfree);
-#define TRACE_AG_PICK2(mp, ag, ag2, cnt, free, scan, flag) \
-		TRACE6(mp, XFS_FSTRM_KTRACE_AGPICK2, ag, ag2, \
-			 cnt, free, scan, flag)
-#define TRACE_UPDATE(mp, ip, ag, cnt, ag2, cnt2) \
-		TRACE5(mp, XFS_FSTRM_KTRACE_UPDATE, ip, ag, cnt, ag2, cnt2)
-#define TRACE_FREE(mp, ip, pip, ag, cnt) \
-		TRACE4(mp, XFS_FSTRM_KTRACE_FREE, ip, pip, ag, cnt)
-#define TRACE_LOOKUP(mp, ip, pip, ag, cnt) \
-		TRACE4(mp, XFS_FSTRM_KTRACE_ITEM_LOOKUP, ip, pip, ag, cnt)
-#define TRACE_ASSOCIATE(mp, ip, pip, ag, cnt) \
-		TRACE4(mp, XFS_FSTRM_KTRACE_ASSOCIATE, ip, pip, ag, cnt)
-#define TRACE_MOVEAG(mp, ip, pip, oag, ocnt, nag, ncnt) \
-		TRACE6(mp, XFS_FSTRM_KTRACE_MOVEAG, ip, pip, oag, ocnt, nag, ncnt)
-#define TRACE_ORPHAN(mp, ip, ag) \
-		TRACE2(mp, XFS_FSTRM_KTRACE_ORPHAN, ip, ag);
-
-
-#else
 #define TRACE_AG_SCAN(mp, ag, ag2)
 #define TRACE_AG_PICK1(mp, max_ag, maxfree)
 #define TRACE_AG_PICK2(mp, ag, ag2, cnt, free, scan, flag)
-#define TRACE_UPDATE(mp, ip, ag, cnt, ag2, cnt2)
 #define TRACE_FREE(mp, ip, pip, ag, cnt)
 #define TRACE_LOOKUP(mp, ip, pip, ag, cnt)
-#define TRACE_ASSOCIATE(mp, ip, pip, ag, cnt)
-#define TRACE_MOVEAG(mp, ip, pip, oag, ocnt, nag, ncnt)
-#define TRACE_ORPHAN(mp, ip, ag)
-#endif
 
 static kmem_zone_t *item_zone;
 
-/*
- * Structure for associating a file or a directory with an allocation group.
- * The parent directory pointer is only needed for files, but since there will
- * generally be vastly more files than directories in the cache, using the same
- * data structure simplifies the code with very little memory overhead.
- */
-typedef struct fstrm_item
-{
-	xfs_agnumber_t	ag;	/* AG currently in use for the file/directory. */
-	xfs_inode_t	*ip;	/* inode self-pointer. */
-	xfs_inode_t	*pip;	/* Parent directory inode pointer. */
-} fstrm_item_t;
+struct xfs_fstrm_item {
+	struct xfs_mount	*mp;
+	xfs_agnumber_t		ag;	/* AG in use for this directory */
+};
+
+enum xfs_fstrm_alloc {
+	XFS_PICK_USERDATA = 1,
+	XFS_PICK_LOWSPACE = 2,
+};
 
 /*
  * Allocation group filestream associations are tracked with per-ag atomic
- * counters.  These counters allow _xfs_filestream_pick_ag() to tell whether a
+ * counters.  These counters allow xfs_filestream_pick_ag() to tell whether a
  * particular AG already has active filestreams associated with it. The mount
  * point's m_peraglock is used to protect these counters from per-ag array
  * re-allocation during a growfs operation.  When xfs_growfs_data_private() is
@@ -200,23 +127,44 @@ xfs_filestream_put_ag(
 	xfs_perag_put(pag);
 }
 
+static void
+xfs_fstrm_free_func(
+	unsigned long		key,
+	void			*data)
+{
+	struct xfs_fstrm_item	*item = data;
+	struct xfs_mount	*mp = item->mp;
+
+	/* Drop the reference taken on the AG when the item was added. */
+	xfs_filestream_put_ag(mp, item->ag);
+
+	TRACE_FREE(mp, ip, NULL, item->ag,
+		   xfs_filestream_peek_ag(mp, item->ag));
+
+	kmem_zone_free(item_zone, item);
+}
+
 /*
  * Scan the AGs starting at startag looking for an AG that isn't in use and has
  * at least minlen blocks free.
  */
 static int
-_xfs_filestream_pick_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	startag,
-	xfs_agnumber_t	*agp,
-	int		flags,
-	xfs_extlen_t	minlen)
+xfs_filestream_pick_ag(
+	struct xfs_inode	*ip,
+	xfs_agnumber_t		startag,
+	xfs_agnumber_t		*agp,
+	int			flags,
+	xfs_extlen_t		minlen)
 {
-	int		streams, max_streams;
-	int		err, trylock, nscan;
-	xfs_extlen_t	longest, free, minfree, maxfree = 0;
-	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
-	struct xfs_perag *pag;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_fstrm_item	*item;
+	struct xfs_perag	*pag;
+	xfs_extlen_t		longest, free, minfree, maxfree = 0;
+	xfs_agnumber_t		ag, max_ag = NULLAGNUMBER;
+	int			streams, max_streams;
+	int			err, trylock, nscan;
+
+	ASSERT(S_ISDIR(ip->i_d.di_mode));
 
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
@@ -320,208 +268,55 @@ next_ag:
 
 	TRACE_AG_PICK2(mp, startag, *agp, streams, free, nscan, flags);
 
-	return 0;
-}
-
-/*
- * Set the allocation group number for a file or a directory, updating inode
- * references and per-AG references as appropriate.
- */
-static int
-_xfs_filestream_update_ag(
-	xfs_inode_t	*ip,
-	xfs_inode_t	*pip,
-	xfs_agnumber_t	ag)
-{
-	int		err = 0;
-	xfs_mount_t	*mp;
-	xfs_mru_cache_t	*cache;
-	fstrm_item_t	*item;
-	xfs_agnumber_t	old_ag;
-	xfs_inode_t	*old_pip;
-
-	/*
-	 * Either ip is a regular file and pip is a directory, or ip is a
-	 * directory and pip is NULL.
-	 */
-	ASSERT(ip && ((S_ISREG(ip->i_d.di_mode) && pip &&
-	               S_ISDIR(pip->i_d.di_mode)) ||
-	              (S_ISDIR(ip->i_d.di_mode) && !pip)));
-
-	mp = ip->i_mount;
-	cache = mp->m_filestream;
-
-	item = xfs_mru_cache_lookup(cache, ip->i_ino);
-	if (item) {
-		ASSERT(item->ip == ip);
-		old_ag = item->ag;
-		item->ag = ag;
-		old_pip = item->pip;
-		item->pip = pip;
-		xfs_mru_cache_done(cache);
-
-		/*
-		 * If the AG has changed, drop the old ref and take a new one,
-		 * effectively transferring the reference from old to new AG.
-		 */
-		if (ag != old_ag) {
-			xfs_filestream_put_ag(mp, old_ag);
-			xfs_filestream_get_ag(mp, ag);
-		}
-
-		/*
-		 * If ip is a file and its pip has changed, drop the old ref and
-		 * take a new one.
-		 */
-		if (pip && pip != old_pip) {
-			IRELE(old_pip);
-			IHOLD(pip);
-		}
-
-		TRACE_UPDATE(mp, ip, old_ag, xfs_filestream_peek_ag(mp, old_ag),
-				ag, xfs_filestream_peek_ag(mp, ag));
+	if (*agp == NULLAGNUMBER)
 		return 0;
-	}
 
+	err = ENOMEM;
 	item = kmem_zone_zalloc(item_zone, KM_MAYFAIL);
 	if (!item)
-		return ENOMEM;
+		goto out_put_ag;
 
-	item->ag = ag;
-	item->ip = ip;
-	item->pip = pip;
+	item->ag = *agp;
+	item->mp = mp;
 
-	err = xfs_mru_cache_insert(cache, ip->i_ino, item);
+	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, item);
 	if (err) {
-		kmem_zone_free(item_zone, item);
-		return err;
+		if (err == EEXIST)
+			err = 0;
+		goto out_free_item;
 	}
 
-	/* Take a reference on the AG. */
-	xfs_filestream_get_ag(mp, ag);
-
-	/*
-	 * Take a reference on the inode itself regardless of whether it's a
-	 * regular file or a directory.
-	 */
-	IHOLD(ip);
-
-	/*
-	 * In the case of a regular file, take a reference on the parent inode
-	 * as well to ensure it remains in-core.
-	 */
-	if (pip)
-		IHOLD(pip);
-
-	TRACE_UPDATE(mp, ip, ag, xfs_filestream_peek_ag(mp, ag),
-			ag, xfs_filestream_peek_ag(mp, ag));
-
 	return 0;
-}
-
-/* xfs_fstrm_free_func(): callback for freeing cached stream items. */
-STATIC void
-xfs_fstrm_free_func(
-	unsigned long	ino,
-	void		*data)
-{
-	fstrm_item_t	*item  = (fstrm_item_t *)data;
-	xfs_inode_t	*ip = item->ip;
-
-	ASSERT(ip->i_ino == ino);
 
-	xfs_iflags_clear(ip, XFS_IFILESTREAM);
-
-	/* Drop the reference taken on the AG when the item was added. */
-	xfs_filestream_put_ag(ip->i_mount, item->ag);
-
-	TRACE_FREE(ip->i_mount, ip, item->pip, item->ag,
-		xfs_filestream_peek_ag(ip->i_mount, item->ag));
-
-	/*
-	 * _xfs_filestream_update_ag() always takes a reference on the inode
-	 * itself, whether it's a file or a directory.  Release it here.
-	 * This can result in the inode being freed and so we must
-	 * not hold any inode locks when freeing filesstreams objects
-	 * otherwise we can deadlock here.
-	 */
-	IRELE(ip);
-
-	/*
-	 * In the case of a regular file, _xfs_filestream_update_ag() also
-	 * takes a ref on the parent inode to keep it in-core.  Release that
-	 * too.
-	 */
-	if (item->pip)
-		IRELE(item->pip);
-
-	/* Finally, free the memory allocated for the item. */
+out_free_item:
 	kmem_zone_free(item_zone, item);
+out_put_ag:
+	xfs_filestream_put_ag(mp, *agp);
+	return err;
 }
 
-/*
- * xfs_filestream_init() is called at xfs initialisation time to set up the
- * memory zone that will be used for filestream data structure allocation.
- */
-int
-xfs_filestream_init(void)
-{
-	item_zone = kmem_zone_init(sizeof(fstrm_item_t), "fstrm_item");
-	if (!item_zone)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/*
- * xfs_filestream_uninit() is called at xfs termination time to destroy the
- * memory zone that was used for filestream data structure allocation.
- */
-void
-xfs_filestream_uninit(void)
+static struct xfs_inode *
+xfs_filestreams_get_parent(
+	struct xfs_inode	*ip)
 {
-	kmem_zone_destroy(item_zone);
-}
+	struct inode		*inode = VFS_I(ip), *dir = NULL;
+	struct dentry		*dentry, *parent;
 
-/*
- * xfs_filestream_mount() is called when a file system is mounted with the
- * filestream option.  It is responsible for allocating the data structures
- * needed to track the new file system's file streams.
- */
-int
-xfs_filestream_mount(
-	xfs_mount_t	*mp)
-{
-	int		err;
-	unsigned int	lifetime, grp_count;
+	dentry = d_find_alias(inode);
+	if (!dentry)
+		goto out;
 
-	/*
-	 * The filestream timer tunable is currently fixed within the range of
-	 * one second to four minutes, with five seconds being the default.  The
-	 * group count is somewhat arbitrary, but it'd be nice to adhere to the
-	 * timer tunable to within about 10 percent.  This requires at least 10
-	 * groups.
-	 */
-	lifetime  = xfs_fstrm_centisecs * 10;
-	grp_count = 10;
+	parent = dget_parent(dentry);
+	if (!parent)
+		goto out_dput;
 
-	err = xfs_mru_cache_create(&mp->m_filestream, lifetime, grp_count,
-	                     xfs_fstrm_free_func);
+	dir = igrab(parent->d_inode);
+	dput(parent);
 
-	return err;
-}
-
-/*
- * xfs_filestream_unmount() is called when a file system that was mounted with
- * the filestream option is unmounted.  It drains the data structures created
- * to track the file system's file streams and frees all the memory that was
- * allocated.
- */
-void
-xfs_filestream_unmount(
-	xfs_mount_t	*mp)
-{
-	xfs_mru_cache_destroy(mp->m_filestream);
+out_dput:
+	dput(dentry);
+out:
+	return dir ? XFS_I(dir) : NULL;
 }
 
 /*
@@ -530,92 +325,58 @@ xfs_filestream_unmount(
  */
 xfs_agnumber_t
 xfs_filestream_lookup_ag(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_mru_cache_t	*cache;
-	fstrm_item_t	*item;
-	xfs_agnumber_t	ag;
-	int		ref;
-
-	if (!S_ISREG(ip->i_d.di_mode) && !S_ISDIR(ip->i_d.di_mode)) {
-		ASSERT(0);
-		return NULLAGNUMBER;
-	}
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_fstrm_item	*item;
+	struct xfs_inode	*pip = NULL;
+	xfs_agnumber_t		ag = NULLAGNUMBER;
+	int			ref = 0;
 
-	cache = ip->i_mount->m_filestream;
-	item = xfs_mru_cache_lookup(cache, ip->i_ino);
-	if (!item) {
-		TRACE_LOOKUP(ip->i_mount, ip, NULL, NULLAGNUMBER, 0);
-		return NULLAGNUMBER;
-	}
+	ASSERT(S_ISREG(ip->i_d.di_mode));
+
+	pip = xfs_filestreams_get_parent(ip);
+	if (!pip)
+		goto out;
+
+	item = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	if (!item)
+		goto out;
 
-	ASSERT(ip == item->ip);
 	ag = item->ag;
-	ref = xfs_filestream_peek_ag(ip->i_mount, ag);
-	xfs_mru_cache_done(cache);
+	xfs_mru_cache_done(mp->m_filestream);
 
-	TRACE_LOOKUP(ip->i_mount, ip, item->pip, ag, ref);
+	ref = xfs_filestream_peek_ag(ip->i_mount, ag);
+out:
+	TRACE_LOOKUP(mp, ip, pip, ag, ref);
+	IRELE(pip);
 	return ag;
 }
 
 /*
- * xfs_filestream_associate() should only be called to associate a regular file
- * with its parent directory.  Calling it with a child directory isn't
- * appropriate because filestreams don't apply to entire directory hierarchies.
- * Creating a file in a child directory of an existing filestream directory
- * starts a new filestream with its own allocation group association.
+ * Make sure a directory has a filestream associated with it.
  *
- * Returns < 0 on error, 0 if successful association occurred, > 0 if
- * we failed to get an association because of locking issues.
+ * This is called when creating regular files in an directory that has
+ * filestreams enabled, so that a stream is ready by the time we need it
+ * in the allocator for the files inside the directory.
  */
 int
 xfs_filestream_associate(
-	xfs_inode_t	*pip,
-	xfs_inode_t	*ip)
+	struct xfs_inode	*pip)
 {
-	xfs_mount_t	*mp;
-	xfs_mru_cache_t	*cache;
-	fstrm_item_t	*item;
-	xfs_agnumber_t	ag, rotorstep, startag;
-	int		err = 0;
+	struct xfs_mount	*mp = pip->i_mount;
+	struct xfs_fstrm_item	*item;
+	xfs_agnumber_t		startag, ag;
 
 	ASSERT(S_ISDIR(pip->i_d.di_mode));
-	ASSERT(S_ISREG(ip->i_d.di_mode));
-	if (!S_ISDIR(pip->i_d.di_mode) || !S_ISREG(ip->i_d.di_mode))
-		return -EINVAL;
-
-	mp = pip->i_mount;
-	cache = mp->m_filestream;
 
 	/*
-	 * We have a problem, Houston.
-	 *
-	 * Taking the iolock here violates inode locking order - we already
-	 * hold the ilock. Hence if we block getting this lock we may never
-	 * wake. Unfortunately, that means if we can't get the lock, we're
-	 * screwed in terms of getting a stream association - we can't spin
-	 * waiting for the lock because someone else is waiting on the lock we
-	 * hold and we cannot drop that as we are in a transaction here.
-	 *
-	 * Lucky for us, this inversion is not a problem because it's a
-	 * directory inode that we are trying to lock here.
-	 *
-	 * So, if we can't get the iolock without sleeping then just give up
+	 * If the directory already has a file stream associated we're done.
 	 */
-	if (!xfs_ilock_nowait(pip, XFS_IOLOCK_EXCL))
-		return 1;
-
-	/* If the parent directory is already in the cache, use its AG. */
-	item = xfs_mru_cache_lookup(cache, pip->i_ino);
+	item = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
 	if (item) {
-		ASSERT(item->ip == pip);
-		ag = item->ag;
-		xfs_mru_cache_done(cache);
-
-		TRACE_LOOKUP(mp, pip, pip, ag, xfs_filestream_peek_ag(mp, ag));
-		err = _xfs_filestream_update_ag(ip, pip, ag);
-
-		goto exit;
+		xfs_mru_cache_done(mp->m_filestream);
+		return 0;
 	}
 
 	/*
@@ -623,202 +384,97 @@ xfs_filestream_associate(
 	 * use the directory inode's AG.
 	 */
 	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
-		rotorstep = xfs_rotorstep;
+		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
 		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
 		                 (mp->m_sb.sb_agcount * rotorstep);
 	} else
 		startag = XFS_INO_TO_AGNO(mp, pip->i_ino);
 
-	/* Pick a new AG for the parent inode starting at startag. */
-	err = _xfs_filestream_pick_ag(mp, startag, &ag, 0, 0);
-	if (err || ag == NULLAGNUMBER)
-		goto exit_did_pick;
-
-	/* Associate the parent inode with the AG. */
-	err = _xfs_filestream_update_ag(pip, NULL, ag);
-	if (err)
-		goto exit_did_pick;
-
-	/* Associate the file inode with the AG. */
-	err = _xfs_filestream_update_ag(ip, pip, ag);
-	if (err)
-		goto exit_did_pick;
-
-	TRACE_ASSOCIATE(mp, ip, pip, ag, xfs_filestream_peek_ag(mp, ag));
-
-exit_did_pick:
-	/*
-	 * If _xfs_filestream_pick_ag() returned a valid AG, remove the
-	 * reference it took on it, since the file and directory will have taken
-	 * their own now if they were successfully cached.
-	 */
-	if (ag != NULLAGNUMBER)
-		xfs_filestream_put_ag(mp, ag);
-
-exit:
-	xfs_iunlock(pip, XFS_IOLOCK_EXCL);
-	return -err;
+	return xfs_filestream_pick_ag(pip, startag, &ag, 0, 0);
 }
 
 /*
- * Pick a new allocation group for the current file and its file stream.  This
- * function is called by xfs_bmap_filestreams() with the mount point's per-ag
- * lock held.
+ * Pick a new allocation group for the current file and its file stream.
+ *
+ * This is called when the allocator can't find a suitable extent in the
+ * current AG, and we have to move the stream into a new AG with more space.
  */
 int
 xfs_filestream_new_ag(
 	struct xfs_bmalloca	*ap,
 	xfs_agnumber_t		*agp)
 {
-	int		flags, err;
-	xfs_inode_t	*ip, *pip = NULL;
-	xfs_mount_t	*mp;
-	xfs_mru_cache_t	*cache;
-	xfs_extlen_t	minlen;
-	fstrm_item_t	*dir, *file;
-	xfs_agnumber_t	ag = NULLAGNUMBER;
-
-	ip = ap->ip;
-	mp = ip->i_mount;
-	cache = mp->m_filestream;
-	minlen = ap->length;
-	*agp = NULLAGNUMBER;
-
-	/*
-	 * Look for the file in the cache, removing it if it's found.  Doing
-	 * this allows it to be held across the dir lookup that follows.
-	 */
-	file = xfs_mru_cache_remove(cache, ip->i_ino);
-	if (file) {
-		ASSERT(ip == file->ip);
-
-		/* Save the file's parent inode and old AG number for later. */
-		pip = file->pip;
-		ag = file->ag;
-
-		/* Look for the file's directory in the cache. */
-		dir = xfs_mru_cache_lookup(cache, pip->i_ino);
-		if (dir) {
-			ASSERT(pip == dir->ip);
-
-			/*
-			 * If the directory has already moved on to a new AG,
-			 * use that AG as the new AG for the file. Don't
-			 * forget to twiddle the AG refcounts to match the
-			 * movement.
-			 */
-			if (dir->ag != file->ag) {
-				xfs_filestream_put_ag(mp, file->ag);
-				xfs_filestream_get_ag(mp, dir->ag);
-				*agp = file->ag = dir->ag;
-			}
-
-			xfs_mru_cache_done(cache);
-		}
+	struct xfs_inode	*ip = ap->ip, *pip;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_extlen_t		minlen = ap->length;
+	struct xfs_fstrm_item	*item;
+	xfs_agnumber_t		startag = 0;
+	int			flags, err = 0;
 
-		/*
-		 * Put the file back in the cache.  If this fails, the free
-		 * function needs to be called to tidy up in the same way as if
-		 * the item had simply expired from the cache.
-		 */
-		err = xfs_mru_cache_insert(cache, ip->i_ino, file);
-		if (err) {
-			xfs_fstrm_free_func(ip->i_ino, file);
-			return err;
-		}
+	*agp = NULLAGNUMBER;
 
-		/*
-		 * If the file's AG was moved to the directory's new AG, there's
-		 * nothing more to be done.
-		 */
-		if (*agp != NULLAGNUMBER) {
-			TRACE_MOVEAG(mp, ip, pip,
-					ag, xfs_filestream_peek_ag(mp, ag),
-					*agp, xfs_filestream_peek_ag(mp, *agp));
-			return 0;
-		}
-	}
+	pip = xfs_filestreams_get_parent(ip);
+	if (!pip)
+		goto exit;
 
-	/*
-	 * If the file's parent directory is known, take its iolock in exclusive
-	 * mode to prevent two sibling files from racing each other to migrate
-	 * themselves and their parent to different AGs.
-	 *
-	 * Note that we lock the parent directory iolock inside the child
-	 * iolock here.  That's fine as we never hold both parent and child
-	 * iolock in any other place.  This is different from the ilock,
-	 * which requires locking of the child after the parent for namespace
-	 * operations.
-	 */
-	if (pip)
-		xfs_ilock(pip, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
+	item = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
+	if (item)
+		startag = (item->ag + 1) % mp->m_sb.sb_agcount;
 
-	/*
-	 * A new AG needs to be found for the file.  If the file's parent
-	 * directory is also known, it will be moved to the new AG as well to
-	 * ensure that files created inside it in future use the new AG.
-	 */
-	ag = (ag == NULLAGNUMBER) ? 0 : (ag + 1) % mp->m_sb.sb_agcount;
 	flags = (ap->userdata ? XFS_PICK_USERDATA : 0) |
 	        (ap->flist->xbf_low ? XFS_PICK_LOWSPACE : 0);
 
-	err = _xfs_filestream_pick_ag(mp, ag, agp, flags, minlen);
-	if (err || *agp == NULLAGNUMBER)
-		goto exit;
-
+	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
+	
 	/*
-	 * If the file wasn't found in the file cache, then its parent directory
-	 * inode isn't known.  For this to have happened, the file must either
-	 * be pre-existing, or it was created long enough ago that its cache
-	 * entry has expired.  This isn't the sort of usage that the filestreams
-	 * allocator is trying to optimise, so there's no point trying to track
-	 * its new AG somehow in the filestream data structures.
+	 * Only free the item here so we skip over the old AG earlier.
 	 */
-	if (!pip) {
-		TRACE_ORPHAN(mp, ip, *agp);
-		goto exit;
-	}
-
-	/* Associate the parent inode with the AG. */
-	err = _xfs_filestream_update_ag(pip, NULL, *agp);
-	if (err)
-		goto exit;
-
-	/* Associate the file inode with the AG. */
-	err = _xfs_filestream_update_ag(ip, pip, *agp);
-	if (err)
-		goto exit;
-
-	TRACE_MOVEAG(mp, ip, pip, NULLAGNUMBER, 0,
-			*agp, xfs_filestream_peek_ag(mp, *agp));
+	if (item)
+		xfs_fstrm_free_func(pip->i_ino, item);
 
+	IRELE(pip);
 exit:
+	if (*agp == NULLAGNUMBER)
+		*agp = 0;
+	return err;
+}
+
+int
+xfs_filestream_mount(
+	xfs_mount_t	*mp)
+{
 	/*
-	 * If _xfs_filestream_pick_ag() returned a valid AG, remove the
-	 * reference it took on it, since the file and directory will have taken
-	 * their own now if they were successfully cached.
+	 * The filestream timer tunable is currently fixed within the range of
+	 * one second to four minutes, with five seconds being the default.  The
+	 * group count is somewhat arbitrary, but it'd be nice to adhere to the
+	 * timer tunable to within about 10 percent.  This requires at least 10
+	 * groups.
 	 */
-	if (*agp != NULLAGNUMBER)
-		xfs_filestream_put_ag(mp, *agp);
-	else
-		*agp = 0;
+	return xfs_mru_cache_create(&mp->m_filestream, xfs_fstrm_centisecs * 10,
+				    10, xfs_fstrm_free_func);
+}
 
-	if (pip)
-		xfs_iunlock(pip, XFS_IOLOCK_EXCL);
+void
+xfs_filestream_unmount(
+	xfs_mount_t	*mp)
+{
+	xfs_mru_cache_destroy(mp->m_filestream);
+}
 
-	return err;
+
+/* needs to return a positive errno for the init path */
+int
+xfs_filestream_init(void)
+{
+	item_zone = kmem_zone_init(sizeof(struct xfs_fstrm_item), "fstrm_item");
+	if (!item_zone)
+		return -ENOMEM;
+	return 0;
 }
 
-/*
- * Remove an association between an inode and a filestream object.
- * Typically this is done on last close of an unlinked file.
- */
 void
-xfs_filestream_deassociate(
-	xfs_inode_t	*ip)
+xfs_filestream_uninit(void)
 {
-	xfs_mru_cache_t	*cache = ip->i_mount->m_filestream;
-
-	xfs_mru_cache_delete(cache, ip->i_ino);
+	kmem_zone_destroy(item_zone);
 }
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 6d61dbe..215ab6ad 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -20,50 +20,21 @@
 
 struct xfs_mount;
 struct xfs_inode;
-struct xfs_perag;
 struct xfs_bmalloca;
 
-#ifdef XFS_FILESTREAMS_TRACE
-#define XFS_FSTRM_KTRACE_INFO		1
-#define XFS_FSTRM_KTRACE_AGSCAN		2
-#define XFS_FSTRM_KTRACE_AGPICK1	3
-#define XFS_FSTRM_KTRACE_AGPICK2	4
-#define XFS_FSTRM_KTRACE_UPDATE		5
-#define XFS_FSTRM_KTRACE_FREE		6
-#define	XFS_FSTRM_KTRACE_ITEM_LOOKUP	7
-#define	XFS_FSTRM_KTRACE_ASSOCIATE	8
-#define	XFS_FSTRM_KTRACE_MOVEAG		9
-#define	XFS_FSTRM_KTRACE_ORPHAN		10
-
-#define XFS_FSTRM_KTRACE_SIZE	16384
-extern ktrace_t *xfs_filestreams_trace_buf;
-
-#endif
-
-/* allocation selection flags */
-typedef enum xfs_fstrm_alloc {
-	XFS_PICK_USERDATA = 1,
-	XFS_PICK_LOWSPACE = 2,
-} xfs_fstrm_alloc_t;
-
-/* prototypes for filestream.c */
 int xfs_filestream_init(void);
 void xfs_filestream_uninit(void);
 int xfs_filestream_mount(struct xfs_mount *mp);
 void xfs_filestream_unmount(struct xfs_mount *mp);
 xfs_agnumber_t xfs_filestream_lookup_ag(struct xfs_inode *ip);
-int xfs_filestream_associate(struct xfs_inode *dip, struct xfs_inode *ip);
-void xfs_filestream_deassociate(struct xfs_inode *ip);
+int xfs_filestream_associate(struct xfs_inode *dip);
 int xfs_filestream_new_ag(struct xfs_bmalloca *ap, xfs_agnumber_t *agp);
 
-
-/* filestreams for the inode? */
 static inline int
 xfs_inode_is_filestream(
 	struct xfs_inode	*ip)
 {
 	return (ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
-		xfs_iflags_test(ip, XFS_IFILESTREAM) ||
 		(ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM);
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3a137e9..f04df2e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -845,11 +845,9 @@ xfs_ialloc(
 
 	/* now we have set up the vfs inode we can associate the filestream */
 	if (filestreams) {
-		error = xfs_filestream_associate(pip, ip);
-		if (error < 0)
-			return -error;
-		if (!error)
-			xfs_iflags_set(ip, XFS_IFILESTREAM);
+		error = xfs_filestream_associate(pip);
+		if (error)
+			return error;
 	}
 
 	*ipp = ip;
@@ -1587,16 +1585,6 @@ xfs_release(
 		int truncated;
 
 		/*
-		 * If we are using filestreams, and we have an unlinked
-		 * file that we are processing the last close on, then nothing
-		 * will be able to reopen and write to this file. Purge this
-		 * inode from the filestreams cache so that it doesn't delay
-		 * teardown of the inode.
-		 */
-		if ((ip->i_d.di_nlink == 0) && xfs_inode_is_filestream(ip))
-			xfs_filestream_deassociate(ip);
-
-		/*
 		 * If we previously truncated this file and removed old data
 		 * in the process, we want to initiate "early" writeout on
 		 * the last close.  This is an attempt to combat the notorious
@@ -2552,15 +2540,6 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
-	/*
-	 * If we are using filestreams, kill the stream association.
-	 * If the file is still open it may get a new one but that
-	 * will get killed on last close in xfs_close() so we don't
-	 * have to worry about that.
-	 */
-	if (!is_dir && link_zero && xfs_inode_is_filestream(ip))
-		xfs_filestream_deassociate(ip);
-
 	return 0;
 
  out_bmap_cancel:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 65e2350..9bbafdd 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -199,7 +199,6 @@ xfs_set_projid(struct xfs_inode *ip,
 #define XFS_ISTALE		(1 << 1) /* inode has been staled */
 #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
 #define XFS_INEW		(1 << 3) /* inode has just been allocated */
-#define XFS_IFILESTREAM		(1 << 4) /* inode is in a filestream dir. */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
 #define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
@@ -215,8 +214,7 @@ xfs_set_projid(struct xfs_inode *ip,
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | \
-	 XFS_IFILESTREAM);
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
 
 /*
  * Synchronize processes attempting to flush the in-core inode back to disk.
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 4aff563..c25db90 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -443,6 +443,7 @@ xfs_mru_cache_insert(
 	void		*value)
 {
 	xfs_mru_cache_elem_t *elem;
+	int error;
 
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
@@ -453,8 +454,8 @@ xfs_mru_cache_insert(
 		return ENOMEM;
 
 	if (radix_tree_preload(GFP_KERNEL)) {
-		kmem_zone_free(xfs_mru_elem_zone, elem);
-		return ENOMEM;
+		error = ENOMEM;
+		goto out_free_item;
 	}
 
 	INIT_LIST_HEAD(&elem->list_node);
@@ -463,13 +464,20 @@ xfs_mru_cache_insert(
 
 	spin_lock(&mru->lock);
 
-	radix_tree_insert(&mru->store, key, elem);
+	error = -radix_tree_insert(&mru->store, key, elem);
 	radix_tree_preload_end();
+	if (error) {
+		spin_unlock(&mru->lock);
+		goto out_free_item;
+	}
 	_xfs_mru_cache_list_insert(mru, elem);
 
 	spin_unlock(&mru->lock);
 
 	return 0;
+out_free_item:
+	kmem_zone_free(xfs_mru_elem_zone, elem);
+	return error;
 }
 
 /*
@@ -506,21 +514,6 @@ xfs_mru_cache_remove(
 }
 
 /*
- * To remove and element and call the free function, call xfs_mru_cache_delete()
- * with the data store and the element's key.
- */
-void
-xfs_mru_cache_delete(
-	xfs_mru_cache_t	*mru,
-	unsigned long	key)
-{
-	void		*value = xfs_mru_cache_remove(mru, key);
-
-	if (value)
-		mru->free_func(key, value);
-}
-
-/*
  * To look up an element using its key, call xfs_mru_cache_lookup() with the
  * data store and the element's key.  If found, the element will be moved to the
  * head of the MRU list to indicate that it's been touched.
diff --git a/fs/xfs/xfs_mru_cache.h b/fs/xfs/xfs_mru_cache.h
index 36dd3ec..b3cf7a5 100644
--- a/fs/xfs/xfs_mru_cache.h
+++ b/fs/xfs/xfs_mru_cache.h
@@ -46,7 +46,6 @@ void xfs_mru_cache_destroy(struct xfs_mru_cache *mru);
 int xfs_mru_cache_insert(struct xfs_mru_cache *mru, unsigned long key,
 				void *value);
 void * xfs_mru_cache_remove(struct xfs_mru_cache *mru, unsigned long key);
-void xfs_mru_cache_delete(struct xfs_mru_cache *mru, unsigned long key);
 void *xfs_mru_cache_lookup(struct xfs_mru_cache *mru, unsigned long key);
 void xfs_mru_cache_done(struct xfs_mru_cache *mru);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
