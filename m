Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcLoi226689 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BE7712A5D9
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:38:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	fdBAOkyYJtov0L8e for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:38:19 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYB-00070x-JO
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:19 +0000
Message-Id: <20110831203819.547731641@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:36:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/14] xfs: implement lazy removal for the dquot freelist
References: <20110831203647.455809764@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-lazy-lru
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

Do not remove dquots from the freelist when we grab a reference to them in
xfs_qm_dqlookup, but leave them on the freelist util scanning notices that
they have a reference.  This speeds up the lookup fastpath, and greatly
simplifies the lock ordering constraints.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-30 13:44:03.421343244 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-30 13:46:10.698003465 +0200
@@ -719,58 +719,25 @@ xfs_qm_dqlookup(
 		 * dqlock to look at the id field of the dquot, since the
 		 * id can't be modified without the hashlock anyway.
 		 */
-		if (be32_to_cpu(dqp->q_core.d_id) == id && dqp->q_mount == mp) {
-			trace_xfs_dqlookup_found(dqp);
+		if (be32_to_cpu(dqp->q_core.d_id) != id || dqp->q_mount != mp)
+			continue;
 
-			/*
-			 * All in core dquots must be on the dqlist of mp
-			 */
-			ASSERT(!list_empty(&dqp->q_mplist));
+		trace_xfs_dqlookup_found(dqp);
 
-			xfs_dqlock(dqp);
-			if (dqp->q_nrefs == 0) {
-				ASSERT(!list_empty(&dqp->q_freelist));
-				if (!mutex_trylock(&xfs_Gqm->qm_dqfrlist_lock)) {
-					trace_xfs_dqlookup_want(dqp);
-
-					/*
-					 * We may have raced with dqreclaim_one()
-					 * (and lost). So, flag that we don't
-					 * want the dquot to be reclaimed.
-					 */
-					dqp->dq_flags |= XFS_DQ_WANT;
-					xfs_dqunlock(dqp);
-					mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-					xfs_dqlock(dqp);
-					dqp->dq_flags &= ~(XFS_DQ_WANT);
-				}
-
-				if (dqp->q_nrefs == 0) {
-					/* take it off the freelist */
-					trace_xfs_dqlookup_freelist(dqp);
-					list_del_init(&dqp->q_freelist);
-					xfs_Gqm->qm_dqfrlist_cnt--;
-				}
-				XFS_DQHOLD(dqp);
-				mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-			} else {
-				XFS_DQHOLD(dqp);
-			}
+		xfs_dqlock(dqp);
+		XFS_DQHOLD(dqp);
 
-			/*
-			 * move the dquot to the front of the hashchain
-			 */
-			ASSERT(mutex_is_locked(&qh->qh_lock));
-			list_move(&dqp->q_hashlist, &qh->qh_list);
-			trace_xfs_dqlookup_done(dqp);
-			*O_dqpp = dqp;
-			return 0;
-		}
+		/*
+		 * move the dquot to the front of the hashchain
+		 */
+		list_move(&dqp->q_hashlist, &qh->qh_list);
+		trace_xfs_dqlookup_done(dqp);
+		*O_dqpp = dqp;
+		return 0;
 	}
 
 	*O_dqpp = NULL;
-	ASSERT(mutex_is_locked(&qh->qh_lock));
-	return (1);
+	return 1;
 }
 
 /*
@@ -1030,8 +997,10 @@ xfs_qm_dqput(
 		if (--dqp->q_nrefs == 0) {
 			trace_xfs_dqput_free(dqp);
 
-			list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
-			xfs_Gqm->qm_dqfrlist_cnt++;
+			if (list_empty(&dqp->q_freelist)) {
+				list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
+				xfs_Gqm->qm_dqfrlist_cnt++;
+			}
 
 			/*
 			 * If we just added a udquot to the freelist, then
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-08-30 13:43:55.358010318 +0200
+++ xfs/fs/xfs/xfs_trace.h	2011-08-30 13:44:44.621341157 +0200
@@ -741,8 +741,6 @@ DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
 DEFINE_DQUOT_EVENT(xfs_dqread);
 DEFINE_DQUOT_EVENT(xfs_dqread_fail);
 DEFINE_DQUOT_EVENT(xfs_dqlookup_found);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_want);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_freelist);
 DEFINE_DQUOT_EVENT(xfs_dqlookup_done);
 DEFINE_DQUOT_EVENT(xfs_dqget_hit);
 DEFINE_DQUOT_EVENT(xfs_dqget_miss);
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-08-30 13:44:03.424676577 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-08-30 13:47:09.364667161 +0200
@@ -518,13 +518,12 @@ xfs_qm_dqpurge_int(
 	 * get them off mplist and hashlist, but leave them on freelist.
 	 */
 	list_for_each_entry_safe(dqp, n, &q->qi_dqlist, q_mplist) {
-		/*
-		 * It's OK to look at the type without taking dqlock here.
-		 * We're holding the mplist lock here, and that's needed for
-		 * a dqreclaim.
-		 */
-		if ((dqp->dq_flags & dqtype) == 0)
+		xfs_dqlock(dqp);
+		if ((dqp->dq_flags & dqtype) == 0) {
+			xfs_dqunlock(dqp);
 			continue;
+		}
+		xfs_dqunlock(dqp);
 
 		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
 			nrecl = q->qi_dqreclaims;
@@ -1692,14 +1691,15 @@ again:
 		xfs_dqlock(dqp);
 
 		/*
-		 * We are racing with dqlookup here. Naturally we don't
-		 * want to reclaim a dquot that lookup wants. We release the
-		 * freelist lock and start over, so that lookup will grab
-		 * both the dquot and the freelistlock.
+		 * This dquot has already been grabbed by dqlookup.
+		 * Remove it from the freelist and try again.
 		 */
-		if (dqp->dq_flags & XFS_DQ_WANT) {
+		if (dqp->q_nrefs) {
 			trace_xfs_dqreclaim_want(dqp);
 			XQM_STATS_INC(xqmstats.xs_qm_dqwants);
+
+			list_del_init(&dqp->q_freelist);
+			xfs_Gqm->qm_dqfrlist_cnt--;
 			restarts++;
 			startagain = 1;
 			goto dqunlock;
Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2011-08-30 13:44:03.428009910 +0200
+++ xfs/fs/xfs/xfs_quota.h	2011-08-30 13:46:10.721336798 +0200
@@ -87,7 +87,6 @@ typedef struct xfs_dqblk {
 #define XFS_DQ_PROJ		0x0002		/* project quota */
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
 #define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
-#define XFS_DQ_WANT		0x0010		/* for lookup/reclaim race */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
@@ -95,8 +94,7 @@ typedef struct xfs_dqblk {
 	{ XFS_DQ_USER,		"USER" }, \
 	{ XFS_DQ_PROJ,		"PROJ" }, \
 	{ XFS_DQ_GROUP,		"GROUP" }, \
-	{ XFS_DQ_DIRTY,		"DIRTY" }, \
-	{ XFS_DQ_WANT,		"WANT" }
+	{ XFS_DQ_DIRTY,		"DIRTY" }
 
 /*
  * In the worst case, when both user and group quotas are on,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
