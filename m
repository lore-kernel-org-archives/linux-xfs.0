Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o31Ce4e0120188 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 07:40:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29B661DCA200
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 05:41:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Ez7xwzKpb1BPMSHw for <xfs@oss.sgi.com>;
	Thu, 01 Apr 2010 05:41:49 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	19171197-1927428
	for <xfs@oss.sgi.com>; Thu, 01 Apr 2010 23:11:48 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1NxJiU-0002I1-Pr
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:46 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NxJiU-0001pM-G8
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: convert the dquot hash list to use list heads
Date: Thu,  1 Apr 2010 23:41:30 +1100
Message-Id: <1270125691-29266-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1270125691-29266-1-git-send-email-david@fromorbit.com>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Convert the dquot hash list on the filesystem to use listhead
infrastructure rather than the roll-your-own in the quota code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h   |    1 -
 fs/xfs/quota/xfs_dquot.c       |   32 ++++++++++----------------------
 fs/xfs/quota/xfs_dquot.h       |    9 ++-------
 fs/xfs/quota/xfs_qm.c          |    9 +++++----
 fs/xfs/quota/xfs_qm_syscalls.c |   34 +++++++++++++---------------------
 fs/xfs/quota/xfs_quota_priv.h  |   33 ---------------------------------
 6 files changed, 30 insertions(+), 88 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 915004f..10c869d 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -667,7 +667,6 @@ DEFINE_DQUOT_EVENT(xfs_dqread_fail);
 DEFINE_DQUOT_EVENT(xfs_dqlookup_found);
 DEFINE_DQUOT_EVENT(xfs_dqlookup_want);
 DEFINE_DQUOT_EVENT(xfs_dqlookup_freelist);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_move);
 DEFINE_DQUOT_EVENT(xfs_dqlookup_done);
 DEFINE_DQUOT_EVENT(xfs_dqget_hit);
 DEFINE_DQUOT_EVENT(xfs_dqget_miss);
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 838289b..ad64ab6 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -122,8 +122,7 @@ xfs_qm_dqinit(
 		 dqp->q_nrefs = 0;
 		 dqp->q_blkno = 0;
 		 INIT_LIST_HEAD(&dqp->q_mplist);
-		 dqp->HL_NEXT = NULL;
-		 dqp->HL_PREVP = NULL;
+		 INIT_LIST_HEAD(&dqp->q_hashlist);
 		 dqp->q_bufoffset = 0;
 		 dqp->q_fileoffset = 0;
 		 dqp->q_transp = NULL;
@@ -752,7 +751,6 @@ xfs_qm_dqlookup(
 {
 	xfs_dquot_t		*dqp;
 	uint			flist_locked;
-	xfs_dquot_t		*d;
 
 	ASSERT(mutex_is_locked(&qh->qh_lock));
 
@@ -761,7 +759,7 @@ xfs_qm_dqlookup(
 	/*
 	 * Traverse the hashchain looking for a match
 	 */
-	for (dqp = qh->qh_next; dqp != NULL; dqp = dqp->HL_NEXT) {
+	list_for_each_entry(dqp, &qh->qh_list, q_hashlist) {
 		/*
 		 * We already have the hashlock. We don't need the
 		 * dqlock to look at the id field of the dquot, since the
@@ -828,21 +826,10 @@ xfs_qm_dqlookup(
 			 * move the dquot to the front of the hashchain
 			 */
 			ASSERT(mutex_is_locked(&qh->qh_lock));
-			if (dqp->HL_PREVP != &qh->qh_next) {
-				trace_xfs_dqlookup_move(dqp);
-				if ((d = dqp->HL_NEXT))
-					d->HL_PREVP = dqp->HL_PREVP;
-				*(dqp->HL_PREVP) = d;
-				d = qh->qh_next;
-				d->HL_PREVP = &dqp->HL_NEXT;
-				dqp->HL_NEXT = d;
-				dqp->HL_PREVP = &qh->qh_next;
-				qh->qh_next = dqp;
-			}
+			list_move(&dqp->q_hashlist, &qh->qh_list);
 			trace_xfs_dqlookup_done(dqp);
 			*O_dqpp = dqp;
-			ASSERT(mutex_is_locked(&qh->qh_lock));
-			return (0);
+			return 0;
 		}
 	}
 
@@ -1034,7 +1021,8 @@ xfs_qm_dqget(
 	 */
 	ASSERT(mutex_is_locked(&h->qh_lock));
 	dqp->q_hash = h;
-	XQM_HASHLIST_INSERT(h, dqp);
+	list_add(&dqp->q_hashlist, &h->qh_list);
+	h->qh_version++;
 
 	/*
 	 * Attach this dquot to this filesystem's list of all dquots,
@@ -1387,7 +1375,7 @@ int
 xfs_qm_dqpurge(
 	xfs_dquot_t	*dqp)
 {
-	xfs_dqhash_t	*thishash;
+	xfs_dqhash_t	*qh = dqp->q_hash;
 	xfs_mount_t	*mp = dqp->q_mount;
 
 	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
@@ -1453,8 +1441,8 @@ xfs_qm_dqpurge(
 	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
 	       !(dqp->q_logitem.qli_item.li_flags & XFS_LI_IN_AIL));
 
-	thishash = dqp->q_hash;
-	XQM_HASHLIST_REMOVE(thishash, dqp);
+	list_del_init(&dqp->q_hashlist);
+	qh->qh_version++;
 	list_del_init(&dqp->q_mplist);
 	mp->m_quotainfo->qi_dqreclaims++;
 	mp->m_quotainfo->qi_dquots--;
@@ -1470,7 +1458,7 @@ xfs_qm_dqpurge(
 	memset(&dqp->q_core, 0, sizeof(dqp->q_core));
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
-	mutex_unlock(&thishash->qh_lock);
+	mutex_unlock(&qh->qh_lock);
 	return (0);
 }
 
diff --git a/fs/xfs/quota/xfs_dquot.h b/fs/xfs/quota/xfs_dquot.h
index 6992a67..169b3c2 100644
--- a/fs/xfs/quota/xfs_dquot.h
+++ b/fs/xfs/quota/xfs_dquot.h
@@ -33,17 +33,12 @@
  * The hash chain headers (hash buckets)
  */
 typedef struct xfs_dqhash {
-	struct xfs_dquot *qh_next;
+	struct list_head  qh_list;
 	struct mutex	  qh_lock;
 	uint		  qh_version;	/* ever increasing version */
 	uint		  qh_nelems;	/* number of dquots on the list */
 } xfs_dqhash_t;
 
-typedef struct xfs_dqlink {
-	struct xfs_dquot  *ql_next;	/* forward link */
-	struct xfs_dquot **ql_prevp;	/* pointer to prev ql_next */
-} xfs_dqlink_t;
-
 struct xfs_mount;
 struct xfs_trans;
 
@@ -57,7 +52,6 @@ struct xfs_trans;
 typedef struct xfs_dqmarker {
 	struct xfs_dquot*dqm_flnext;	/* link to freelist: must be first */
 	struct xfs_dquot*dqm_flprev;
-	xfs_dqlink_t	 dqm_hashlist;	/* link to the hash chain */
 	uint		 dqm_flags;	/* various flags (XFS_DQ_*) */
 } xfs_dqmarker_t;
 
@@ -67,6 +61,7 @@ typedef struct xfs_dqmarker {
 typedef struct xfs_dquot {
 	xfs_dqmarker_t	 q_lists;	/* list ptrs, q_flags (marker) */
 	struct list_head q_mplist;	/* mount's list of dquots */
+	struct list_head q_hashlist;	/* mount's list of dquots */
 	xfs_dqhash_t	*q_hash;	/* the hashchain header */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
 	struct xfs_trans*q_transp;	/* trans this belongs to currently */
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index e9c2de2..891666f 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -277,7 +277,7 @@ xfs_qm_rele_quotafs_ref(
 		if (dqp->dq_flags & XFS_DQ_INACTIVE) {
 			ASSERT(dqp->q_mount == NULL);
 			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
-			ASSERT(dqp->HL_PREVP == NULL);
+			ASSERT(list_empty(&dqp->q_hashlist));
 			ASSERT(list_empty(&dqp->q_mplist));
 			XQM_FREELIST_REMOVE(dqp);
 			xfs_dqunlock(dqp);
@@ -1176,7 +1176,7 @@ xfs_qm_list_init(
 	int		n)
 {
 	mutex_init(&list->qh_lock);
-	list->qh_next = NULL;
+	INIT_LIST_HEAD(&list->qh_list);
 	list->qh_version = 0;
 	list->qh_nelems = 0;
 }
@@ -1976,7 +1976,7 @@ startagain:
 		if (dqp->dq_flags & XFS_DQ_INACTIVE) {
 			ASSERT(mp == NULL);
 			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
-			ASSERT(dqp->HL_PREVP == NULL);
+			ASSERT(list_empty(&dqp->q_hashlist));
 			ASSERT(list_empty(&dqp->q_mplist));
 			XQM_FREELIST_REMOVE(dqp);
 			xfs_dqunlock(dqp);
@@ -2055,7 +2055,8 @@ startagain:
 		list_del_init(&dqp->q_mplist);
 		mp->m_quotainfo->qi_dquots--;
 		mp->m_quotainfo->qi_dqreclaims++;
-		XQM_HASHLIST_REMOVE(dqp->q_hash, dqp);
+		list_del_init(&dqp->q_hashlist);
+		dqp->q_hash->qh_version++;
 		XQM_FREELIST_REMOVE(dqp);
 		dqpout = dqp;
 		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 7275e51..24a94da 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -931,6 +931,7 @@ struct mutex  qcheck_lock;
 
 typedef struct dqtest {
 	xfs_dqmarker_t	q_lists;
+	struct list_head q_hashlist;
 	xfs_dqhash_t	*q_hash;	/* the hashchain header */
 	xfs_mount_t	*q_mount;	/* filesystem this relates to */
 	xfs_dqid_t	d_id;		/* user id or group id */
@@ -941,14 +942,9 @@ typedef struct dqtest {
 STATIC void
 xfs_qm_hashinsert(xfs_dqhash_t *h, xfs_dqtest_t *dqp)
 {
-	xfs_dquot_t *d;
-	if (((d) = (h)->qh_next))
-		(d)->HL_PREVP = &((dqp)->HL_NEXT);
-	(dqp)->HL_NEXT = d;
-	(dqp)->HL_PREVP = &((h)->qh_next);
-	(h)->qh_next = (xfs_dquot_t *)dqp;
-	(h)->qh_version++;
-	(h)->qh_nelems++;
+	list_add(&dqp->q_hashlist, &h->qh_list);
+	h->qh_version++;
+	h->qh_nelems++;
 }
 STATIC void
 xfs_qm_dqtest_print(
@@ -1060,9 +1056,7 @@ xfs_qm_internalqcheck_dqget(
 	xfs_dqhash_t	*h;
 
 	h = DQTEST_HASH(mp, id, type);
-	for (d = (xfs_dqtest_t *) h->qh_next; d != NULL;
-	     d = (xfs_dqtest_t *) d->HL_NEXT) {
-		/* DQTEST_LIST_PRINT(h, HL_NEXT, "@@@@@ dqtestlist @@@@@"); */
+	list_for_each_entry(d, &h->qh_list, q_hashlist) {
 		if (d->d_id == id && mp == d->q_mount) {
 			*O_dq = d;
 			return (0);
@@ -1073,6 +1067,7 @@ xfs_qm_internalqcheck_dqget(
 	d->d_id = id;
 	d->q_mount = mp;
 	d->q_hash = h;
+	INIT_LIST_HEAD(&d->q_hashlist);
 	xfs_qm_hashinsert(h, d);
 	*O_dq = d;
 	return (0);
@@ -1179,8 +1174,6 @@ xfs_qm_internalqcheck(
 	xfs_ino_t	lastino;
 	int		done, count;
 	int		i;
-	xfs_dqtest_t	*d, *e;
-	xfs_dqhash_t	*h1;
 	int		error;
 
 	lastino = 0;
@@ -1220,19 +1213,18 @@ xfs_qm_internalqcheck(
 	}
 	cmn_err(CE_DEBUG, "Checking results against system dquots");
 	for (i = 0; i < qmtest_hashmask; i++) {
-		h1 = &qmtest_udqtab[i];
-		for (d = (xfs_dqtest_t *) h1->qh_next; d != NULL; ) {
+		xfs_dqtest_t	*d, *n;
+		xfs_dqhash_t	*h;
+
+		h = &qmtest_udqtab[i];
+		list_for_each_entry_safe(d, n, &h->qh_list, q_hashlist) {
 			xfs_dqtest_cmp(d);
-			e = (xfs_dqtest_t *) d->HL_NEXT;
 			kmem_free(d);
-			d = e;
 		}
-		h1 = &qmtest_gdqtab[i];
-		for (d = (xfs_dqtest_t *) h1->qh_next; d != NULL; ) {
+		h = &qmtest_gdqtab[i];
+		list_for_each_entry_safe(d, n, &h->qh_list, q_hashlist) {
 			xfs_dqtest_cmp(d);
-			e = (xfs_dqtest_t *) d->HL_NEXT;
 			kmem_free(d);
-			d = e;
 		}
 	}
 
diff --git a/fs/xfs/quota/xfs_quota_priv.h b/fs/xfs/quota/xfs_quota_priv.h
index 6f4bbae..3a1b9aa 100644
--- a/fs/xfs/quota/xfs_quota_priv.h
+++ b/fs/xfs/quota/xfs_quota_priv.h
@@ -72,46 +72,13 @@
 	!dqp->q_core.d_rtbcount && \
 	!dqp->q_core.d_icount)
 
-#define HL_PREVP	dq_hashlist.ql_prevp
-#define HL_NEXT		dq_hashlist.ql_next
-
-
-#define _LIST_REMOVE(h, dqp, PVP, NXT)				\
-	{							\
-		 xfs_dquot_t *d;				\
-		 if (((d) = (dqp)->NXT))				\
-			 (d)->PVP = (dqp)->PVP;			\
-		 *((dqp)->PVP) = d;				\
-		 (dqp)->NXT = NULL;				\
-		 (dqp)->PVP = NULL;				\
-		 (h)->qh_version++;				\
-		 (h)->qh_nelems--;				\
-	}
-
-#define _LIST_INSERT(h, dqp, PVP, NXT)				\
-	{							\
-		 xfs_dquot_t *d;				\
-		 if (((d) = (h)->qh_next))			\
-			 (d)->PVP = &((dqp)->NXT);		\
-		 (dqp)->NXT = d;				\
-		 (dqp)->PVP = &((h)->qh_next);			\
-		 (h)->qh_next = dqp;				\
-		 (h)->qh_version++;				\
-		 (h)->qh_nelems++;				\
-	 }
-
 #define FOREACH_DQUOT_IN_FREELIST(dqp, qlist)	\
 for ((dqp) = (qlist)->qh_next; (dqp) != (xfs_dquot_t *)(qlist); \
      (dqp) = (dqp)->dq_flnext)
 
-#define XQM_HASHLIST_INSERT(h, dqp)	\
-	 _LIST_INSERT(h, dqp, HL_PREVP, HL_NEXT)
-
 #define XQM_FREELIST_INSERT(h, dqp)	\
 	 xfs_qm_freelist_append(h, dqp)
 
-#define XQM_HASHLIST_REMOVE(h, dqp)	\
-	 _LIST_REMOVE(h, dqp, HL_PREVP, HL_NEXT)
 #define XQM_FREELIST_REMOVE(dqp)	\
 	 xfs_qm_freelist_unlink(dqp)
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
