Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7XGxC203857 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:33:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23A35B75E0
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id g0HtolVwZjvZCxPD for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:33 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwx-00036V-8e
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:03 +0000
Message-Id: <20090126073203.169959000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/17] xfs: remove the unused XFS_QMOPT_DQLOCK flag
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_QMOPT_DQLOCK
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

The XFS_QMOPT_DQLOCK flag introduces major complexity in the quota subsystem
but isn't actually used anywhere.  So remove it and all the hazzles it
introduces.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2009-01-21 21:03:27.835294745 +0100
+++ xfs/fs/xfs/quota/xfs_qm.c	2009-01-24 18:56:04.215429212 +0100
@@ -632,7 +632,6 @@ xfs_qm_dqattach_one(
 	xfs_dqid_t	id,
 	uint		type,
 	uint		doalloc,
-	uint		dolock,
 	xfs_dquot_t	*udqhint, /* hint */
 	xfs_dquot_t	**IO_idqpp)
 {
@@ -641,16 +640,16 @@ xfs_qm_dqattach_one(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
+
 	/*
 	 * See if we already have it in the inode itself. IO_idqpp is
 	 * &i_udquot or &i_gdquot. This made the code look weird, but
 	 * made the logic a lot simpler.
 	 */
-	if ((dqp = *IO_idqpp)) {
-		if (dolock)
-			xfs_dqlock(dqp);
+	dqp = *IO_idqpp;
+	if (dqp) {
 		xfs_dqtrace_entry(dqp, "DQATTACH: found in ip");
-		goto done;
+		return 0;
 	}
 
 	/*
@@ -659,38 +658,38 @@ xfs_qm_dqattach_one(
 	 * lookup by dqid (xfs_qm_dqget) by caching a group dquot inside
 	 * the user dquot.
 	 */
-	ASSERT(!udqhint || type == XFS_DQ_GROUP || type == XFS_DQ_PROJ);
-	if (udqhint && !dolock)
+	if (udqhint) {
+		ASSERT(type == XFS_DQ_GROUP || type == XFS_DQ_PROJ);
 		xfs_dqlock(udqhint);
 
-	/*
-	 * No need to take dqlock to look at the id.
-	 * The ID can't change until it gets reclaimed, and it won't
-	 * be reclaimed as long as we have a ref from inode and we hold
-	 * the ilock.
-	 */
-	if (udqhint &&
-	    (dqp = udqhint->q_gdquot) &&
-	    (be32_to_cpu(dqp->q_core.d_id) == id)) {
-		ASSERT(XFS_DQ_IS_LOCKED(udqhint));
-		xfs_dqlock(dqp);
-		XFS_DQHOLD(dqp);
-		ASSERT(*IO_idqpp == NULL);
-		*IO_idqpp = dqp;
-		if (!dolock) {
+		/*
+		 * No need to take dqlock to look at the id.
+		 *
+		 * The ID can't change until it gets reclaimed, and it won't
+		 * be reclaimed as long as we have a ref from inode and we
+		 * hold the ilock.
+		 */
+		dqp = udqhint->q_gdquot;
+		if (dqp && be32_to_cpu(dqp->q_core.d_id) == id) {
+			xfs_dqlock(dqp);
+			XFS_DQHOLD(dqp);
+			ASSERT(*IO_idqpp == NULL);
+			*IO_idqpp = dqp;
+
 			xfs_dqunlock(dqp);
 			xfs_dqunlock(udqhint);
+			return 0;
 		}
-		goto done;
-	}
-	/*
-	 * We can't hold a dquot lock when we call the dqget code.
-	 * We'll deadlock in no time, because of (not conforming to)
-	 * lock ordering - the inodelock comes before any dquot lock,
-	 * and we may drop and reacquire the ilock in xfs_qm_dqget().
-	 */
-	if (udqhint)
+
+		/*
+		 * We can't hold a dquot lock when we call the dqget code.
+		 * We'll deadlock in no time, because of (not conforming to)
+		 * lock ordering - the inodelock comes before any dquot lock,
+		 * and we may drop and reacquire the ilock in xfs_qm_dqget().
+		 */
 		xfs_dqunlock(udqhint);
+	}
+
 	/*
 	 * Find the dquot from somewhere. This bumps the
 	 * reference count of dquot and returns it locked.
@@ -698,48 +697,19 @@ xfs_qm_dqattach_one(
 	 * disk and we didn't ask it to allocate;
 	 * ESRCH if quotas got turned off suddenly.
 	 */
-	if ((error = xfs_qm_dqget(ip->i_mount, ip, id, type,
-				 doalloc|XFS_QMOPT_DOWARN, &dqp))) {
-		if (udqhint && dolock)
-			xfs_dqlock(udqhint);
-		goto done;
-	}
+	error = xfs_qm_dqget(ip->i_mount, ip, id, type, XFS_QMOPT_DOWARN, &dqp);
+	if (error)
+		return error;
 
 	xfs_dqtrace_entry(dqp, "DQATTACH: found by dqget");
+
 	/*
 	 * dqget may have dropped and re-acquired the ilock, but it guarantees
 	 * that the dquot returned is the one that should go in the inode.
 	 */
 	*IO_idqpp = dqp;
-	ASSERT(dqp);
-	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	if (! dolock) {
-		xfs_dqunlock(dqp);
-		goto done;
-	}
-	if (! udqhint)
-		goto done;
-
-	ASSERT(udqhint);
-	ASSERT(dolock);
-	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	if (! xfs_qm_dqlock_nowait(udqhint)) {
-		xfs_dqunlock(dqp);
-		xfs_dqlock(udqhint);
-		xfs_dqlock(dqp);
-	}
-      done:
-#ifdef QUOTADEBUG
-	if (udqhint) {
-		if (dolock)
-			ASSERT(XFS_DQ_IS_LOCKED(udqhint));
-	}
-	if (! error) {
-		if (dolock)
-			ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	}
-#endif
-	return error;
+	xfs_dqunlock(dqp);
+	return 0;
 }
 
 
@@ -754,24 +724,15 @@ xfs_qm_dqattach_one(
 STATIC void
 xfs_qm_dqattach_grouphint(
 	xfs_dquot_t	*udq,
-	xfs_dquot_t	*gdq,
-	uint		locked)
+	xfs_dquot_t	*gdq)
 {
 	xfs_dquot_t	*tmp;
 
-#ifdef QUOTADEBUG
-	if (locked) {
-		ASSERT(XFS_DQ_IS_LOCKED(udq));
-		ASSERT(XFS_DQ_IS_LOCKED(gdq));
-	}
-#endif
-	if (! locked)
-		xfs_dqlock(udq);
+	xfs_dqlock(udq);
 
 	if ((tmp = udq->q_gdquot)) {
 		if (tmp == gdq) {
-			if (! locked)
-				xfs_dqunlock(udq);
+			xfs_dqunlock(udq);
 			return;
 		}
 
@@ -781,8 +742,6 @@ xfs_qm_dqattach_grouphint(
 		 * because the freelist lock comes before dqlocks.
 		 */
 		xfs_dqunlock(udq);
-		if (locked)
-			xfs_dqunlock(gdq);
 		/*
 		 * we took a hard reference once upon a time in dqget,
 		 * so give it back when the udquot no longer points at it
@@ -795,9 +754,7 @@ xfs_qm_dqattach_grouphint(
 
 	} else {
 		ASSERT(XFS_DQ_IS_LOCKED(udq));
-		if (! locked) {
-			xfs_dqlock(gdq);
-		}
+		xfs_dqlock(gdq);
 	}
 
 	ASSERT(XFS_DQ_IS_LOCKED(udq));
@@ -810,10 +767,9 @@ xfs_qm_dqattach_grouphint(
 		XFS_DQHOLD(gdq);
 		udq->q_gdquot = gdq;
 	}
-	if (! locked) {
-		xfs_dqunlock(gdq);
-		xfs_dqunlock(udq);
-	}
+
+	xfs_dqunlock(gdq);
+	xfs_dqunlock(udq);
 }
 
 
@@ -821,8 +777,6 @@ xfs_qm_dqattach_grouphint(
  * Given a locked inode, attach dquot(s) to it, taking U/G/P-QUOTAON
  * into account.
  * If XFS_QMOPT_DQALLOC, the dquot(s) will be allocated if needed.
- * If XFS_QMOPT_DQLOCK, the dquot(s) will be returned locked. This option pretty
- * much made this code a complete mess, but it has been pretty useful.
  * If XFS_QMOPT_ILOCKED, then inode sent is already locked EXCL.
  * Inode may get unlocked and relocked in here, and the caller must deal with
  * the consequences.
@@ -851,7 +805,6 @@ xfs_qm_dqattach(
 	if (XFS_IS_UQUOTA_ON(mp)) {
 		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
 						flags & XFS_QMOPT_DQALLOC,
-						flags & XFS_QMOPT_DQLOCK,
 						NULL, &ip->i_udquot);
 		if (error)
 			goto done;
@@ -863,11 +816,9 @@ xfs_qm_dqattach(
 		error = XFS_IS_GQUOTA_ON(mp) ?
 			xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
 						flags & XFS_QMOPT_DQALLOC,
-						flags & XFS_QMOPT_DQLOCK,
 						ip->i_udquot, &ip->i_gdquot) :
 			xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
 						flags & XFS_QMOPT_DQALLOC,
-						flags & XFS_QMOPT_DQLOCK,
 						ip->i_udquot, &ip->i_gdquot);
 		/*
 		 * Don't worry about the udquot that we may have
@@ -898,22 +849,13 @@ xfs_qm_dqattach(
 		/*
 		 * Attach i_gdquot to the gdquot hint inside the i_udquot.
 		 */
-		xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot,
-					 flags & XFS_QMOPT_DQLOCK);
+		xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
 	}
 
       done:
 
 #ifdef QUOTADEBUG
 	if (! error) {
-		if (ip->i_udquot) {
-			if (flags & XFS_QMOPT_DQLOCK)
-				ASSERT(XFS_DQ_IS_LOCKED(ip->i_udquot));
-		}
-		if (ip->i_gdquot) {
-			if (flags & XFS_QMOPT_DQLOCK)
-				ASSERT(XFS_DQ_IS_LOCKED(ip->i_gdquot));
-		}
 		if (XFS_IS_UQUOTA_ON(mp))
 			ASSERT(ip->i_udquot);
 		if (XFS_IS_OQUOTA_ON(mp))
Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2009-01-21 21:03:27.837294860 +0100
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2009-01-24 18:56:04.216429130 +0100
@@ -624,10 +624,9 @@ xfs_trans_dqresv(
 	xfs_qcnt_t	*resbcountp;
 	xfs_quotainfo_t	*q = mp->m_quotainfo;
 
-	if (! (flags & XFS_QMOPT_DQLOCK)) {
-		xfs_dqlock(dqp);
-	}
-	ASSERT(XFS_DQ_IS_LOCKED(dqp));
+
+	xfs_dqlock(dqp);
+
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
 		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
 		if (!hardlimit)
@@ -740,10 +739,8 @@ xfs_trans_dqresv(
 	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
 
 error_return:
-	if (! (flags & XFS_QMOPT_DQLOCK)) {
-		xfs_dqunlock(dqp);
-	}
-	return (error);
+	xfs_dqunlock(dqp);
+	return error;
 }
 
 
@@ -753,8 +750,7 @@ error_return:
  * grp/prj quotas is important, because this follows a both-or-nothing
  * approach.
  *
- * flags = XFS_QMOPT_DQLOCK indicate if dquot(s) need to be locked.
- *	   XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
+ * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
  *	   XFS_QMOPT_ENOSPC returns ENOSPC not EDQUOT.  Used by pquota.
  *	   XFS_TRANS_DQ_RES_BLKS reserves regular disk blocks
  *	   XFS_TRANS_DQ_RES_RTBLKS reserves realtime disk blocks
Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2009-01-24 18:52:52.211583834 +0100
+++ xfs/fs/xfs/xfs_quota.h	2009-01-24 18:56:04.217428839 +0100
@@ -187,7 +187,6 @@ typedef struct xfs_qoff_logformat {
  * to a single function. None of these XFS_QMOPT_* flags are meant to have
  * persistent values (ie. their values can and will change between versions)
  */
-#define XFS_QMOPT_DQLOCK	0x0000001 /* dqlock */
 #define XFS_QMOPT_DQALLOC	0x0000002 /* alloc dquot ondisk if needed */
 #define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
 #define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
