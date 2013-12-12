Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2681629E0A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 03:41:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B73DAAC008
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:41:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iL03AK6MsOAjmbXa for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 01:41:09 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vr2lR-00015q-8I
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 20:41:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vr2lR-0005t9-7O
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 20:41:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: remote dquot hints
Date: Thu, 12 Dec 2013 20:40:56 +1100
Message-Id: <1386841258-22183-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1386841258-22183-1-git-send-email-david@fromorbit.com>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

group and project quota hints are currently stored on the user
dquot. If we are attaching quotas to the inode, then the group and
project dquots are stored as hints on the user dquot to save having
to look them up again later.

The thing is, the hints are not used for that inode for the rest of
the life of the inode - the dquots are attached directly to the
inode itself - so the only time the hints are used is when an inode
first has dquots attached.

When the hints on the user dquot don't match the dquots being
attache dto the inode, they are then removed and replaced with the
new hints. If a user is concurrently modifying files in different
group and/or project contexts, then this leads to thrashing of the
hints attached to user dquot.

If user quotas are not enabled, then hints are never even used.

So, if the hints are used to avoid the cost of the lookup, is the
cost of the lookup significant enough to justify the hint
infrstructure? Maybe it was once, when there was a global quota
manager shared between all XFS filesystems and was hash table based.

However, lookups are now much simpler, requiring only a single lock and
radix tree lookup local to the filesystem and no hash or LRU
manipulations to be made. Hence the cost of lookup is much lower
than when hints were implemented. Turns out that benchmarks show
that, too, with thir being no differnce in performance when doing
file creation workloads as a single user with user, group and
project quotas enabled - the hints do not make the code go any
faster. In fact, removing the hints shows a 2-3% reduction in the
time it takes to create 50 million inodes....

So, let's just get rid of the hints and the complexity around them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c |  53 ++-----------
 fs/xfs/xfs_dquot.h |   2 -
 fs/xfs/xfs_qm.c    | 214 ++++++-----------------------------------------------
 3 files changed, 29 insertions(+), 240 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6b1e695..4ce4984 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -831,47 +831,6 @@ restart:
 	return (0);
 }
 
-
-STATIC void
-xfs_qm_dqput_final(
-	struct xfs_dquot	*dqp)
-{
-	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
-	struct xfs_dquot	*gdqp;
-	struct xfs_dquot	*pdqp;
-
-	trace_xfs_dqput_free(dqp);
-
-	if (list_lru_add(&qi->qi_lru, &dqp->q_lru))
-		XFS_STATS_INC(xs_qm_dquot_unused);
-
-	/*
-	 * If we just added a udquot to the freelist, then we want to release
-	 * the gdquot/pdquot reference that it (probably) has. Otherwise it'll
-	 * keep the gdquot/pdquot from getting reclaimed.
-	 */
-	gdqp = dqp->q_gdquot;
-	if (gdqp) {
-		xfs_dqlock(gdqp);
-		dqp->q_gdquot = NULL;
-	}
-
-	pdqp = dqp->q_pdquot;
-	if (pdqp) {
-		xfs_dqlock(pdqp);
-		dqp->q_pdquot = NULL;
-	}
-	xfs_dqunlock(dqp);
-
-	/*
-	 * If we had a group/project quota hint, release it now.
-	 */
-	if (gdqp)
-		xfs_qm_dqput(gdqp);
-	if (pdqp)
-		xfs_qm_dqput(pdqp);
-}
-
 /*
  * Release a reference to the dquot (decrement ref-count) and unlock it.
  *
@@ -887,10 +846,14 @@ xfs_qm_dqput(
 
 	trace_xfs_dqput(dqp);
 
-	if (--dqp->q_nrefs > 0)
-		xfs_dqunlock(dqp);
-	else
-		xfs_qm_dqput_final(dqp);
+	if (--dqp->q_nrefs == 0) {
+		struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
+		trace_xfs_dqput_free(dqp);
+
+		if (list_lru_add(&qi->qi_lru, &dqp->q_lru))
+			XFS_STATS_INC(xs_qm_dquot_unused);
+	}
+	xfs_dqunlock(dqp);
 }
 
 /*
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index d22ed00..68a68f7 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -52,8 +52,6 @@ typedef struct xfs_dquot {
 	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
 	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
 
-	struct xfs_dquot*q_gdquot;	/* group dquot, hint only */
-	struct xfs_dquot*q_pdquot;	/* project dquot, hint only */
 	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
 	xfs_dq_logitem_t q_logitem;	/* dquot log item */
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index dd88f0e..d31b88e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -193,47 +193,6 @@ xfs_qm_dqpurge(
 }
 
 /*
- * Release the group or project dquot pointers the user dquots maybe carrying
- * around as a hint, and proceed to purge the user dquot cache if requested.
-*/
-STATIC int
-xfs_qm_dqpurge_hints(
-	struct xfs_dquot	*dqp,
-	void			*data)
-{
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
-	uint			flags = *((uint *)data);
-
-	xfs_dqlock(dqp);
-	if (dqp->dq_flags & XFS_DQ_FREEING) {
-		xfs_dqunlock(dqp);
-		return EAGAIN;
-	}
-
-	/* If this quota has a hint attached, prepare for releasing it now */
-	gdqp = dqp->q_gdquot;
-	if (gdqp)
-		dqp->q_gdquot = NULL;
-
-	pdqp = dqp->q_pdquot;
-	if (pdqp)
-		dqp->q_pdquot = NULL;
-
-	xfs_dqunlock(dqp);
-
-	if (gdqp)
-		xfs_qm_dqrele(gdqp);
-	if (pdqp)
-		xfs_qm_dqrele(pdqp);
-
-	if (flags & XFS_QMOPT_UQUOTA)
-		return xfs_qm_dqpurge(dqp, NULL);
-
-	return 0;
-}
-
-/*
  * Purge the dquot cache.
  */
 void
@@ -241,18 +200,8 @@ xfs_qm_dqpurge_all(
 	struct xfs_mount	*mp,
 	uint			flags)
 {
-	/*
-	 * We have to release group/project dquot hint(s) from the user dquot
-	 * at first if they are there, otherwise we would run into an infinite
-	 * loop while walking through radix tree to purge other type of dquots
-	 * since their refcount is not zero if the user dquot refers to them
-	 * as hint.
-	 *
-	 * Call the special xfs_qm_dqpurge_hints() will end up go through the
-	 * general xfs_qm_dqpurge() against user dquot cache if requested.
-	 */
-	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, &flags);
-
+	if (flags & XFS_QMOPT_UQUOTA)
+		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_GQUOTA)
 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_PQUOTA)
@@ -409,7 +358,6 @@ xfs_qm_dqattach_one(
 	xfs_dqid_t	id,
 	uint		type,
 	uint		doalloc,
-	xfs_dquot_t	*udqhint, /* hint */
 	xfs_dquot_t	**IO_idqpp)
 {
 	xfs_dquot_t	*dqp;
@@ -419,9 +367,9 @@ xfs_qm_dqattach_one(
 	error = 0;
 
 	/*
-	 * See if we already have it in the inode itself. IO_idqpp is
-	 * &i_udquot or &i_gdquot. This made the code look weird, but
-	 * made the logic a lot simpler.
+	 * See if we already have it in the inode itself. IO_idqpp is &i_udquot
+	 * or &i_gdquot. This made the code look weird, but made the logic a lot
+	 * simpler.
 	 */
 	dqp = *IO_idqpp;
 	if (dqp) {
@@ -430,49 +378,10 @@ xfs_qm_dqattach_one(
 	}
 
 	/*
-	 * udqhint is the i_udquot field in inode, and is non-NULL only
-	 * when the type arg is group/project. Its purpose is to save a
-	 * lookup by dqid (xfs_qm_dqget) by caching a group dquot inside
-	 * the user dquot.
-	 */
-	if (udqhint) {
-		ASSERT(type == XFS_DQ_GROUP || type == XFS_DQ_PROJ);
-		xfs_dqlock(udqhint);
-
-		/*
-		 * No need to take dqlock to look at the id.
-		 *
-		 * The ID can't change until it gets reclaimed, and it won't
-		 * be reclaimed as long as we have a ref from inode and we
-		 * hold the ilock.
-		 */
-		if (type == XFS_DQ_GROUP)
-			dqp = udqhint->q_gdquot;
-		else
-			dqp = udqhint->q_pdquot;
-		if (dqp && be32_to_cpu(dqp->q_core.d_id) == id) {
-			ASSERT(*IO_idqpp == NULL);
-
-			*IO_idqpp = xfs_qm_dqhold(dqp);
-			xfs_dqunlock(udqhint);
-			return 0;
-		}
-
-		/*
-		 * We can't hold a dquot lock when we call the dqget code.
-		 * We'll deadlock in no time, because of (not conforming to)
-		 * lock ordering - the inodelock comes before any dquot lock,
-		 * and we may drop and reacquire the ilock in xfs_qm_dqget().
-		 */
-		xfs_dqunlock(udqhint);
-	}
-
-	/*
-	 * Find the dquot from somewhere. This bumps the
-	 * reference count of dquot and returns it locked.
-	 * This can return ENOENT if dquot didn't exist on
-	 * disk and we didn't ask it to allocate;
-	 * ESRCH if quotas got turned off suddenly.
+	 * Find the dquot from somewhere. This bumps the reference count of
+	 * dquot and returns it locked.  This can return ENOENT if dquot didn't
+	 * exist on disk and we didn't ask it to allocate; ESRCH if quotas got
+	 * turned off suddenly.
 	 */
 	error = xfs_qm_dqget(ip->i_mount, ip, id, type,
 			     doalloc | XFS_QMOPT_DOWARN, &dqp);
@@ -490,48 +399,6 @@ xfs_qm_dqattach_one(
 	return 0;
 }
 
-
-/*
- * Given a udquot and group/project type, attach the group/project
- * dquot pointer to the udquot as a hint for future lookups.
- */
-STATIC void
-xfs_qm_dqattach_hint(
-	struct xfs_inode	*ip,
-	int			type)
-{
-	struct xfs_dquot **dqhintp;
-	struct xfs_dquot *dqp;
-	struct xfs_dquot *udq = ip->i_udquot;
-
-	ASSERT(type == XFS_DQ_GROUP || type == XFS_DQ_PROJ);
-
-	xfs_dqlock(udq);
-
-	if (type == XFS_DQ_GROUP) {
-		dqp = ip->i_gdquot;
-		dqhintp = &udq->q_gdquot;
-	} else {
-		dqp = ip->i_pdquot;
-		dqhintp = &udq->q_pdquot;
-	}
-
-	if (*dqhintp) {
-		struct xfs_dquot *tmp;
-
-		if (*dqhintp == dqp)
-			goto done;
-
-		tmp = *dqhintp;
-		*dqhintp = NULL;
-		xfs_qm_dqrele(tmp);
-	}
-
-	*dqhintp = xfs_qm_dqhold(dqp);
-done:
-	xfs_dqunlock(udq);
-}
-
 static bool
 xfs_qm_need_dqattach(
 	struct xfs_inode	*ip)
@@ -562,7 +429,6 @@ xfs_qm_dqattach_locked(
 	uint		flags)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	uint		nquotas = 0;
 	int		error = 0;
 
 	if (!xfs_qm_need_dqattach(ip))
@@ -570,77 +436,39 @@ xfs_qm_dqattach_locked(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	if (XFS_IS_UQUOTA_ON(mp)) {
+	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
 		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
 						flags & XFS_QMOPT_DQALLOC,
-						NULL, &ip->i_udquot);
+						&ip->i_udquot);
 		if (error)
 			goto done;
-		nquotas++;
+		ASSERT(ip->i_udquot);
 	}
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	if (XFS_IS_GQUOTA_ON(mp)) {
+	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
 		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
 						flags & XFS_QMOPT_DQALLOC,
-						ip->i_udquot, &ip->i_gdquot);
-		/*
-		 * Don't worry about the udquot that we may have
-		 * attached above. It'll get detached, if not already.
-		 */
+						&ip->i_gdquot);
 		if (error)
 			goto done;
-		nquotas++;
+		ASSERT(ip->i_gdquot);
 	}
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	if (XFS_IS_PQUOTA_ON(mp)) {
+	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
 		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
 						flags & XFS_QMOPT_DQALLOC,
-						ip->i_udquot, &ip->i_pdquot);
-		/*
-		 * Don't worry about the udquot that we may have
-		 * attached above. It'll get detached, if not already.
-		 */
+						&ip->i_pdquot);
 		if (error)
 			goto done;
-		nquotas++;
+		ASSERT(ip->i_pdquot);
 	}
 
+done:
 	/*
-	 * Attach this group/project quota to the user quota as a hint.
-	 * This WON'T, in general, result in a thrash.
+	 * Don't worry about the dquots that we may have attached before any
+	 * error - they'll get detached later if it has not already been done.
 	 */
-	if (nquotas > 1 && ip->i_udquot) {
-		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-		ASSERT(ip->i_gdquot || !XFS_IS_GQUOTA_ON(mp));
-		ASSERT(ip->i_pdquot || !XFS_IS_PQUOTA_ON(mp));
-
-		/*
-		 * We do not have i_udquot locked at this point, but this check
-		 * is OK since we don't depend on the i_gdquot to be accurate
-		 * 100% all the time. It is just a hint, and this will
-		 * succeed in general.
-		 */
-		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
-			xfs_qm_dqattach_hint(ip, XFS_DQ_GROUP);
-
-		if (ip->i_udquot->q_pdquot != ip->i_pdquot)
-			xfs_qm_dqattach_hint(ip, XFS_DQ_PROJ);
-	}
-
- done:
-#ifdef DEBUG
-	if (!error) {
-		if (XFS_IS_UQUOTA_ON(mp))
-			ASSERT(ip->i_udquot);
-		if (XFS_IS_GQUOTA_ON(mp))
-			ASSERT(ip->i_gdquot);
-		if (XFS_IS_PQUOTA_ON(mp))
-			ASSERT(ip->i_pdquot);
-	}
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-#endif
 	return error;
 }
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
