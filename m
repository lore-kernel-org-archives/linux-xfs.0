Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoKkE153461 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9036715EED4F
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	E2sZ4AiTugr8yZF7 for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:19 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xG-0002xO-IC
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:18 +0000
Message-Id: <20110710205018.525481665@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/11] xfs: remove the dead QUOTADEBUG debug
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-QUOTADEBUG
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

Remove the dead hash table test rid which has been rotting away under
QUOTADEBUG, including some code that was compiled for normal debug
builds, but not actually called without QUOTADEBUG, and enable a few
cheap debug checks that were hidden under QUOTADEBUG for normal
debug builds.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2011-07-09 09:16:00.999021718 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.c	2011-07-09 09:34:20.332299394 +0200
@@ -220,7 +220,7 @@ xfs_qm_adjust_dqtimers(
 {
 	ASSERT(d->d_id);
 
-#ifdef QUOTADEBUG
+#ifdef DEBUG
 	if (d->d_blk_hardlimit)
 		ASSERT(be64_to_cpu(d->d_blk_softlimit) <=
 		       be64_to_cpu(d->d_blk_hardlimit));
@@ -231,6 +231,7 @@ xfs_qm_adjust_dqtimers(
 		ASSERT(be64_to_cpu(d->d_rtb_softlimit) <=
 		       be64_to_cpu(d->d_rtb_hardlimit));
 #endif
+
 	if (!d->d_btimer) {
 		if ((d->d_blk_softlimit &&
 		     (be64_to_cpu(d->d_bcount) >=
@@ -1423,45 +1424,6 @@ xfs_qm_dqpurge(
 }
 
 
-#ifdef QUOTADEBUG
-void
-xfs_qm_dqprint(xfs_dquot_t *dqp)
-{
-	struct xfs_mount	*mp = dqp->q_mount;
-
-	xfs_debug(mp, "-----------KERNEL DQUOT----------------");
-	xfs_debug(mp, "---- dquotID =  %d",
-		(int)be32_to_cpu(dqp->q_core.d_id));
-	xfs_debug(mp, "---- type    =  %s", DQFLAGTO_TYPESTR(dqp));
-	xfs_debug(mp, "---- fs      =  0x%p", dqp->q_mount);
-	xfs_debug(mp, "---- blkno   =  0x%x", (int) dqp->q_blkno);
-	xfs_debug(mp, "---- boffset =  0x%x", (int) dqp->q_bufoffset);
-	xfs_debug(mp, "---- blkhlimit =  %Lu (0x%x)",
-		be64_to_cpu(dqp->q_core.d_blk_hardlimit),
-		(int)be64_to_cpu(dqp->q_core.d_blk_hardlimit));
-	xfs_debug(mp, "---- blkslimit =  %Lu (0x%x)",
-		be64_to_cpu(dqp->q_core.d_blk_softlimit),
-		(int)be64_to_cpu(dqp->q_core.d_blk_softlimit));
-	xfs_debug(mp, "---- inohlimit =  %Lu (0x%x)",
-		be64_to_cpu(dqp->q_core.d_ino_hardlimit),
-		(int)be64_to_cpu(dqp->q_core.d_ino_hardlimit));
-	xfs_debug(mp, "---- inoslimit =  %Lu (0x%x)",
-		be64_to_cpu(dqp->q_core.d_ino_softlimit),
-		(int)be64_to_cpu(dqp->q_core.d_ino_softlimit));
-	xfs_debug(mp, "---- bcount  =  %Lu (0x%x)",
-		be64_to_cpu(dqp->q_core.d_bcount),
-		(int)be64_to_cpu(dqp->q_core.d_bcount));
-	xfs_debug(mp, "---- icount  =  %Lu (0x%x)",
-		be64_to_cpu(dqp->q_core.d_icount),
-		(int)be64_to_cpu(dqp->q_core.d_icount));
-	xfs_debug(mp, "---- btimer  =  %d",
-		(int)be32_to_cpu(dqp->q_core.d_btimer));
-	xfs_debug(mp, "---- itimer  =  %d",
-		(int)be32_to_cpu(dqp->q_core.d_itimer));
-	xfs_debug(mp, "---------------------------");
-}
-#endif
-
 /*
  * Give the buffer a little push if it is incore and
  * wait on the flush lock.
Index: xfs/fs/xfs/quota/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.h	2011-07-01 09:55:06.090830194 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.h	2011-07-09 09:34:20.332299394 +0200
@@ -116,12 +116,6 @@ static inline void xfs_dqfunlock(xfs_dqu
 				     (XFS_IS_UQUOTA_ON((d)->q_mount)) : \
 				     (XFS_IS_OQUOTA_ON((d)->q_mount))))
 
-#ifdef QUOTADEBUG
-extern void		xfs_qm_dqprint(xfs_dquot_t *);
-#else
-#define xfs_qm_dqprint(a)
-#endif
-
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
 extern int		xfs_qm_dqpurge(xfs_dquot_t *);
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2011-07-08 14:21:56.765799266 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2011-07-09 09:34:20.335632727 +0200
@@ -67,32 +67,6 @@ static struct shrinker xfs_qm_shaker = {
 	.seeks = DEFAULT_SEEKS,
 };
 
-#ifdef DEBUG
-extern struct mutex	qcheck_lock;
-#endif
-
-#ifdef QUOTADEBUG
-static void
-xfs_qm_dquot_list_print(
-	struct xfs_mount *mp)
-{
-	xfs_dquot_t	*dqp;
-	int		i = 0;
-
-	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist_lock, qi_mplist) {
-		xfs_debug(mp, "   %d. \"%d (%s)\"   "
-				  "bcnt = %lld, icnt = %lld, refs = %d",
-			i++, be32_to_cpu(dqp->q_core.d_id),
-			DQFLAGTO_TYPESTR(dqp),
-			(long long)be64_to_cpu(dqp->q_core.d_bcount),
-			(long long)be64_to_cpu(dqp->q_core.d_icount),
-			dqp->q_nrefs);
-	}
-}
-#else
-static void xfs_qm_dquot_list_print(struct xfs_mount *mp) { }
-#endif
-
 /*
  * Initialize the XQM structure.
  * Note that there is not one quota manager per file system.
@@ -165,9 +139,6 @@ xfs_Gqm_init(void)
 	atomic_set(&xqm->qm_totaldquots, 0);
 	xqm->qm_dqfree_ratio = XFS_QM_DQFREE_RATIO;
 	xqm->qm_nrefs = 0;
-#ifdef DEBUG
-	mutex_init(&qcheck_lock);
-#endif
 	return xqm;
 
  out_free_udqhash:
@@ -204,9 +175,6 @@ xfs_qm_destroy(
 	mutex_lock(&xqm->qm_dqfrlist_lock);
 	list_for_each_entry_safe(dqp, n, &xqm->qm_dqfrlist, q_freelist) {
 		xfs_dqlock(dqp);
-#ifdef QUOTADEBUG
-		xfs_debug(dqp->q_mount, "FREELIST destroy 0x%p", dqp);
-#endif
 		list_del_init(&dqp->q_freelist);
 		xfs_Gqm->qm_dqfrlist_cnt--;
 		xfs_dqunlock(dqp);
@@ -214,9 +182,6 @@ xfs_qm_destroy(
 	}
 	mutex_unlock(&xqm->qm_dqfrlist_lock);
 	mutex_destroy(&xqm->qm_dqfrlist_lock);
-#ifdef DEBUG
-	mutex_destroy(&qcheck_lock);
-#endif
 	kmem_free(xqm);
 }
 
@@ -409,11 +374,6 @@ xfs_qm_mount_quotas(
 		xfs_warn(mp, "Failed to initialize disk quotas.");
 		return;
 	}
-
-#ifdef QUOTADEBUG
-	if (XFS_IS_QUOTA_ON(mp))
-		xfs_qm_internalqcheck(mp);
-#endif
 }
 
 /*
@@ -866,8 +826,8 @@ xfs_qm_dqattach_locked(
 	}
 
  done:
-#ifdef QUOTADEBUG
-	if (! error) {
+#ifdef DEBUG
+	if (!error) {
 		if (XFS_IS_UQUOTA_ON(mp))
 			ASSERT(ip->i_udquot);
 		if (XFS_IS_OQUOTA_ON(mp))
@@ -1733,8 +1693,6 @@ xfs_qm_quotacheck(
 	mp->m_qflags &= ~(XFS_OQUOTA_CHKD | XFS_UQUOTA_CHKD);
 	mp->m_qflags |= flags;
 
-	xfs_qm_dquot_list_print(mp);
-
  error_return:
 	if (error) {
 		xfs_warn(mp,
@@ -2096,9 +2054,6 @@ xfs_qm_write_sb_changes(
 	xfs_trans_t	*tp;
 	int		error;
 
-#ifdef QUOTADEBUG
-	xfs_notice(mp, "Writing superblock quota changes");
-#endif
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
 	if ((error = xfs_trans_reserve(tp, 0,
 				      mp->m_sb.sb_sectsize + 128, 0,
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2011-07-09 09:16:00.999021718 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2011-07-09 09:34:20.338966060 +0200
@@ -622,7 +622,6 @@ xfs_qm_scall_setqlim(
 	xfs_trans_log_dquot(tp, dqp);
 
 	error = xfs_trans_commit(tp, 0);
-	xfs_qm_dqprint(dqp);
 	xfs_qm_dqrele(dqp);
 
  out_unlock:
@@ -657,7 +656,6 @@ xfs_qm_scall_getquota(
 		xfs_qm_dqput(dqp);
 		return XFS_ERROR(ENOENT);
 	}
-	/* xfs_qm_dqprint(dqp); */
 	/*
 	 * Convert the disk dquot to the exportable format
 	 */
@@ -906,354 +904,3 @@ xfs_qm_dqrele_all_inodes(
 	ASSERT(mp->m_quotainfo);
 	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags);
 }
-
-/*------------------------------------------------------------------------*/
-#ifdef DEBUG
-/*
- * This contains all the test functions for XFS disk quotas.
- * Currently it does a quota accounting check. ie. it walks through
- * all inodes in the file system, calculating the dquot accounting fields,
- * and prints out any inconsistencies.
- */
-xfs_dqhash_t *qmtest_udqtab;
-xfs_dqhash_t *qmtest_gdqtab;
-int	      qmtest_hashmask;
-int	      qmtest_nfails;
-struct mutex  qcheck_lock;
-
-#define DQTEST_HASHVAL(mp, id) (((__psunsigned_t)(mp) + \
-				 (__psunsigned_t)(id)) & \
-				(qmtest_hashmask - 1))
-
-#define DQTEST_HASH(mp, id, type)   ((type & XFS_DQ_USER) ? \
-				     (qmtest_udqtab + \
-				      DQTEST_HASHVAL(mp, id)) : \
-				     (qmtest_gdqtab + \
-				      DQTEST_HASHVAL(mp, id)))
-
-#define DQTEST_LIST_PRINT(l, NXT, title) \
-{ \
-	  xfs_dqtest_t	*dqp; int i = 0;\
-	  xfs_debug(NULL, "%s (#%d)", title, (int) (l)->qh_nelems); \
-	  for (dqp = (xfs_dqtest_t *)(l)->qh_next; dqp != NULL; \
-	       dqp = (xfs_dqtest_t *)dqp->NXT) { \
-		xfs_debug(dqp->q_mount,		\
-			"  %d. \"%d (%s)\"  bcnt = %d, icnt = %d", \
-			 ++i, dqp->d_id, DQFLAGTO_TYPESTR(dqp),	     \
-			 dqp->d_bcount, dqp->d_icount); } \
-}
-
-typedef struct dqtest {
-	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
-	struct list_head q_hashlist;
-	xfs_dqhash_t	*q_hash;	/* the hashchain header */
-	xfs_mount_t	*q_mount;	/* filesystem this relates to */
-	xfs_dqid_t	d_id;		/* user id or group id */
-	xfs_qcnt_t	d_bcount;	/* # disk blocks owned by the user */
-	xfs_qcnt_t	d_icount;	/* # inodes owned by the user */
-} xfs_dqtest_t;
-
-STATIC void
-xfs_qm_hashinsert(xfs_dqhash_t *h, xfs_dqtest_t *dqp)
-{
-	list_add(&dqp->q_hashlist, &h->qh_list);
-	h->qh_version++;
-	h->qh_nelems++;
-}
-STATIC void
-xfs_qm_dqtest_print(
-	struct xfs_mount	*mp,
-	struct dqtest		*d)
-{
-	xfs_debug(mp, "-----------DQTEST DQUOT----------------");
-	xfs_debug(mp, "---- dquot ID = %d", d->d_id);
-	xfs_debug(mp, "---- fs       = 0x%p", d->q_mount);
-	xfs_debug(mp, "---- bcount   = %Lu (0x%x)",
-		d->d_bcount, (int)d->d_bcount);
-	xfs_debug(mp, "---- icount   = %Lu (0x%x)",
-		d->d_icount, (int)d->d_icount);
-	xfs_debug(mp, "---------------------------");
-}
-
-STATIC void
-xfs_qm_dqtest_failed(
-	xfs_dqtest_t	*d,
-	xfs_dquot_t	*dqp,
-	char		*reason,
-	xfs_qcnt_t	a,
-	xfs_qcnt_t	b,
-	int		error)
-{
-	qmtest_nfails++;
-	if (error)
-		xfs_debug(dqp->q_mount,
-			"quotacheck failed id=%d, err=%d\nreason: %s",
-			d->d_id, error, reason);
-	else
-		xfs_debug(dqp->q_mount,
-			"quotacheck failed id=%d (%s) [%d != %d]",
-			d->d_id, reason, (int)a, (int)b);
-	xfs_qm_dqtest_print(dqp->q_mount, d);
-	if (dqp)
-		xfs_qm_dqprint(dqp);
-}
-
-STATIC int
-xfs_dqtest_cmp2(
-	xfs_dqtest_t	*d,
-	xfs_dquot_t	*dqp)
-{
-	int err = 0;
-	if (be64_to_cpu(dqp->q_core.d_icount) != d->d_icount) {
-		xfs_qm_dqtest_failed(d, dqp, "icount mismatch",
-			be64_to_cpu(dqp->q_core.d_icount),
-			d->d_icount, 0);
-		err++;
-	}
-	if (be64_to_cpu(dqp->q_core.d_bcount) != d->d_bcount) {
-		xfs_qm_dqtest_failed(d, dqp, "bcount mismatch",
-			be64_to_cpu(dqp->q_core.d_bcount),
-			d->d_bcount, 0);
-		err++;
-	}
-	if (dqp->q_core.d_blk_softlimit &&
-	    be64_to_cpu(dqp->q_core.d_bcount) >=
-	    be64_to_cpu(dqp->q_core.d_blk_softlimit)) {
-		if (!dqp->q_core.d_btimer && dqp->q_core.d_id) {
-			xfs_debug(dqp->q_mount,
-				"%d [%s] BLK TIMER NOT STARTED",
-				d->d_id, DQFLAGTO_TYPESTR(d));
-			err++;
-		}
-	}
-	if (dqp->q_core.d_ino_softlimit &&
-	    be64_to_cpu(dqp->q_core.d_icount) >=
-	    be64_to_cpu(dqp->q_core.d_ino_softlimit)) {
-		if (!dqp->q_core.d_itimer && dqp->q_core.d_id) {
-			xfs_debug(dqp->q_mount,
-				"%d [%s] INO TIMER NOT STARTED",
-				d->d_id, DQFLAGTO_TYPESTR(d));
-			err++;
-		}
-	}
-#ifdef QUOTADEBUG
-	if (!err) {
-		xfs_debug(dqp->q_mount, "%d [%s] qchecked",
-			d->d_id, DQFLAGTO_TYPESTR(d));
-	}
-#endif
-	return (err);
-}
-
-STATIC void
-xfs_dqtest_cmp(
-	xfs_dqtest_t	*d)
-{
-	xfs_dquot_t	*dqp;
-	int		error;
-
-	/* xfs_qm_dqtest_print(d); */
-	if ((error = xfs_qm_dqget(d->q_mount, NULL, d->d_id, d->dq_flags, 0,
-				 &dqp))) {
-		xfs_qm_dqtest_failed(d, NULL, "dqget failed", 0, 0, error);
-		return;
-	}
-	xfs_dqtest_cmp2(d, dqp);
-	xfs_qm_dqput(dqp);
-}
-
-STATIC int
-xfs_qm_internalqcheck_dqget(
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_dqtest_t	**O_dq)
-{
-	xfs_dqtest_t	*d;
-	xfs_dqhash_t	*h;
-
-	h = DQTEST_HASH(mp, id, type);
-	list_for_each_entry(d, &h->qh_list, q_hashlist) {
-		if (d->d_id == id && mp == d->q_mount) {
-			*O_dq = d;
-			return (0);
-		}
-	}
-	d = kmem_zalloc(sizeof(xfs_dqtest_t), KM_SLEEP);
-	d->dq_flags = type;
-	d->d_id = id;
-	d->q_mount = mp;
-	d->q_hash = h;
-	INIT_LIST_HEAD(&d->q_hashlist);
-	xfs_qm_hashinsert(h, d);
-	*O_dq = d;
-	return (0);
-}
-
-STATIC void
-xfs_qm_internalqcheck_get_dquots(
-	xfs_mount_t	*mp,
-	xfs_dqid_t	uid,
-	xfs_dqid_t	projid,
-	xfs_dqid_t	gid,
-	xfs_dqtest_t	**ud,
-	xfs_dqtest_t	**gd)
-{
-	if (XFS_IS_UQUOTA_ON(mp))
-		xfs_qm_internalqcheck_dqget(mp, uid, XFS_DQ_USER, ud);
-	if (XFS_IS_GQUOTA_ON(mp))
-		xfs_qm_internalqcheck_dqget(mp, gid, XFS_DQ_GROUP, gd);
-	else if (XFS_IS_PQUOTA_ON(mp))
-		xfs_qm_internalqcheck_dqget(mp, projid, XFS_DQ_PROJ, gd);
-}
-
-
-STATIC void
-xfs_qm_internalqcheck_dqadjust(
-	xfs_inode_t		*ip,
-	xfs_dqtest_t		*d)
-{
-	d->d_icount++;
-	d->d_bcount += (xfs_qcnt_t)ip->i_d.di_nblocks;
-}
-
-STATIC int
-xfs_qm_internalqcheck_adjust(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	void		__user *buffer,	/* not used */
-	int		ubsize,		/* not used */
-	int		*ubused,	/* not used */
-	int		*res)		/* bulkstat result code */
-{
-	xfs_inode_t		*ip;
-	xfs_dqtest_t		*ud, *gd;
-	uint			lock_flags;
-	boolean_t		ipreleased;
-	int			error;
-
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
-
-	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
-		*res = BULKSTAT_RV_NOTHING;
-		xfs_debug(mp, "%s: ino=%llu, uqino=%llu, gqino=%llu\n",
-			__func__, (unsigned long long) ino,
-			(unsigned long long) mp->m_sb.sb_uquotino,
-			(unsigned long long) mp->m_sb.sb_gquotino);
-		return XFS_ERROR(EINVAL);
-	}
-	ipreleased = B_FALSE;
- again:
-	lock_flags = XFS_ILOCK_SHARED;
-	if ((error = xfs_iget(mp, NULL, ino, 0, lock_flags, &ip))) {
-		*res = BULKSTAT_RV_NOTHING;
-		return (error);
-	}
-
-	/*
-	 * This inode can have blocks after eof which can get released
-	 * when we send it to inactive. Since we don't check the dquot
-	 * until the after all our calculations are done, we must get rid
-	 * of those now.
-	 */
-	if (! ipreleased) {
-		xfs_iunlock(ip, lock_flags);
-		IRELE(ip);
-		ipreleased = B_TRUE;
-		goto again;
-	}
-	xfs_qm_internalqcheck_get_dquots(mp,
-					(xfs_dqid_t) ip->i_d.di_uid,
-					(xfs_dqid_t) xfs_get_projid(ip),
-					(xfs_dqid_t) ip->i_d.di_gid,
-					&ud, &gd);
-	if (XFS_IS_UQUOTA_ON(mp)) {
-		ASSERT(ud);
-		xfs_qm_internalqcheck_dqadjust(ip, ud);
-	}
-	if (XFS_IS_OQUOTA_ON(mp)) {
-		ASSERT(gd);
-		xfs_qm_internalqcheck_dqadjust(ip, gd);
-	}
-	xfs_iunlock(ip, lock_flags);
-	IRELE(ip);
-	*res = BULKSTAT_RV_DIDONE;
-	return (0);
-}
-
-
-/* PRIVATE, debugging */
-int
-xfs_qm_internalqcheck(
-	xfs_mount_t	*mp)
-{
-	xfs_ino_t	lastino;
-	int		done, count;
-	int		i;
-	int		error;
-
-	lastino = 0;
-	qmtest_hashmask = 32;
-	count = 5;
-	done = 0;
-	qmtest_nfails = 0;
-
-	if (! XFS_IS_QUOTA_ON(mp))
-		return XFS_ERROR(ESRCH);
-
-	xfs_log_force(mp, XFS_LOG_SYNC);
-	XFS_bflush(mp->m_ddev_targp);
-	xfs_log_force(mp, XFS_LOG_SYNC);
-	XFS_bflush(mp->m_ddev_targp);
-
-	mutex_lock(&qcheck_lock);
-	/* There should be absolutely no quota activity while this
-	   is going on. */
-	qmtest_udqtab = kmem_zalloc(qmtest_hashmask *
-				    sizeof(xfs_dqhash_t), KM_SLEEP);
-	qmtest_gdqtab = kmem_zalloc(qmtest_hashmask *
-				    sizeof(xfs_dqhash_t), KM_SLEEP);
-	do {
-		/*
-		 * Iterate thru all the inodes in the file system,
-		 * adjusting the corresponding dquot counters
-		 */
-		error = xfs_bulkstat(mp, &lastino, &count,
-				 xfs_qm_internalqcheck_adjust,
-				 0, NULL, &done);
-		if (error) {
-			xfs_debug(mp, "Bulkstat returned error 0x%x", error);
-			break;
-		}
-	} while (!done);
-
-	xfs_debug(mp, "Checking results against system dquots");
-	for (i = 0; i < qmtest_hashmask; i++) {
-		xfs_dqtest_t	*d, *n;
-		xfs_dqhash_t	*h;
-
-		h = &qmtest_udqtab[i];
-		list_for_each_entry_safe(d, n, &h->qh_list, q_hashlist) {
-			xfs_dqtest_cmp(d);
-			kmem_free(d);
-		}
-		h = &qmtest_gdqtab[i];
-		list_for_each_entry_safe(d, n, &h->qh_list, q_hashlist) {
-			xfs_dqtest_cmp(d);
-			kmem_free(d);
-		}
-	}
-
-	if (qmtest_nfails) {
-		xfs_debug(mp, "******** quotacheck failed  ********");
-		xfs_debug(mp, "failures = %d", qmtest_nfails);
-	} else {
-		xfs_debug(mp, "******** quotacheck successful! ********");
-	}
-	kmem_free(qmtest_udqtab);
-	kmem_free(qmtest_gdqtab);
-	mutex_unlock(&qcheck_lock);
-	return (qmtest_nfails);
-}
-
-#endif /* DEBUG */
Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2011-07-09 09:16:01.002355051 +0200
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2011-07-09 09:34:20.338966060 +0200
@@ -387,18 +387,18 @@ xfs_trans_apply_dquot_deltas(
 				qtrx->qt_delbcnt_delta;
 			totalrtbdelta = qtrx->qt_rtbcount_delta +
 				qtrx->qt_delrtb_delta;
-#ifdef QUOTADEBUG
+#ifdef DEBUG
 			if (totalbdelta < 0)
 				ASSERT(be64_to_cpu(d->d_bcount) >=
-				       (xfs_qcnt_t) -totalbdelta);
+				       -totalbdelta);
 
 			if (totalrtbdelta < 0)
 				ASSERT(be64_to_cpu(d->d_rtbcount) >=
-				       (xfs_qcnt_t) -totalrtbdelta);
+				       -totalrtbdelta);
 
 			if (qtrx->qt_icount_delta < 0)
 				ASSERT(be64_to_cpu(d->d_icount) >=
-				       (xfs_qcnt_t) -qtrx->qt_icount_delta);
+				       -qtrx->qt_icount_delta);
 #endif
 			if (totalbdelta)
 				be64_add_cpu(&d->d_bcount, (xfs_qcnt_t)totalbdelta);
@@ -642,11 +642,6 @@ xfs_trans_dqresv(
 	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
 	     (XFS_IS_OQUOTA_ENFORCED(dqp->q_mount) &&
 	      (XFS_QM_ISPDQ(dqp) || XFS_QM_ISGDQ(dqp))))) {
-#ifdef QUOTADEBUG
-		xfs_debug(mp,
-			"BLK Res: nblks=%ld + resbcount=%Ld > hardlimit=%Ld?",
-			nblks, *resbcountp, hardlimit);
-#endif
 		if (nblks > 0) {
 			/*
 			 * dquot is locked already. See if we'd go over the
Index: xfs/fs/xfs/xfs.h
===================================================================
--- xfs.orig/fs/xfs/xfs.h	2011-07-01 09:55:06.147496859 +0200
+++ xfs/fs/xfs/xfs.h	2011-07-09 09:34:20.342299393 +0200
@@ -22,7 +22,6 @@
 #define STATIC
 #define DEBUG 1
 #define XFS_BUF_LOCK_TRACKING 1
-/* #define QUOTADEBUG 1 */
 #endif
 
 #include <linux-2.6/xfs_linux.h>
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-07-09 09:16:01.015688384 +0200
+++ xfs/fs/xfs/xfs_mount.c	2011-07-09 09:34:20.342299393 +0200
@@ -1089,10 +1089,6 @@ xfs_mount_reset_sbqflags(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return 0;
 
-#ifdef QUOTADEBUG
-	xfs_notice(mp, "Writing superblock quota changes");
-#endif
-
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
 	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
 				      XFS_DEFAULT_LOG_COUNT);
Index: xfs/fs/xfs/quota/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.h	2011-07-01 09:55:06.134163527 +0200
+++ xfs/fs/xfs/quota/xfs_qm.h	2011-07-09 09:34:20.342299393 +0200
@@ -163,10 +163,4 @@ extern int		xfs_qm_scall_getqstat(xfs_mo
 extern int		xfs_qm_scall_quotaon(xfs_mount_t *, uint);
 extern int		xfs_qm_scall_quotaoff(xfs_mount_t *, uint);
 
-#ifdef DEBUG
-extern int		xfs_qm_internalqcheck(xfs_mount_t *);
-#else
-#define xfs_qm_internalqcheck(mp)	(0)
-#endif
-
 #endif /* __XFS_QM_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
