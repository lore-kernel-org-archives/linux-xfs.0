Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 420527F50
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 04:25:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 211908F8040
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 02:25:14 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IbS20vEh2g8wOsCI for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 02:25:11 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1Vr3S7-0001Bn-UU
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 21:25:07 +1100
Date: Thu, 12 Dec 2013 21:25:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/3] xfs: xfs_qm_dqrele mostly doesn't need locking
Message-ID: <20131212102507.GX10988@dastard>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386841258-22183-1-git-send-email-david@fromorbit.com>
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


From: Dave Chinner <dchinner@redhat.com>

Now that we have an atomic variable for the reference count, we
don't need to take the dquot lock if we are not removing the last
reference count. The dquot lock is a mutex, so we can't use
atomic_dec_and_lock(), but we can open code it in xfs_qm_dqrele and
hence avoid the dquot lock for most of the cases where we drop a
reference count.

The result is that concurrent file creates jump from 24,000/s to
28,000/s, and the entire workload is now serialised on the dquot
being locked during transaction commit. Another significant win,
even though it's not the big one...

While there, rename xfs_qm_dqrele to xfs_dqrele - the "qm" part of
the name means nothing and just makes the code harder to read.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c       | 17 +++++++++--------
 fs/xfs/xfs_inode.c       | 12 ++++++------
 fs/xfs/xfs_ioctl.c       | 10 +++++-----
 fs/xfs/xfs_iops.c        | 12 ++++++------
 fs/xfs/xfs_qm.c          | 16 ++++++++--------
 fs/xfs/xfs_qm_syscalls.c |  8 ++++----
 fs/xfs/xfs_quota.h       |  4 ++--
 fs/xfs/xfs_symlink.c     | 12 ++++++------
 8 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 975a46c..f17350d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -861,11 +861,10 @@ xfs_qm_dqput(
 }
 
 /*
- * Release a dquot. Flush it if dirty, then dqput() it.
- * dquot must not be locked.
+ * Release a dquot. The dquot must not be locked.
  */
 void
-xfs_qm_dqrele(
+xfs_dqrele(
 	xfs_dquot_t	*dqp)
 {
 	if (!dqp)
@@ -873,13 +872,15 @@ xfs_qm_dqrele(
 
 	trace_xfs_dqrele(dqp);
 
-	xfs_dqlock(dqp);
 	/*
-	 * We don't care to flush it if the dquot is dirty here.
-	 * That will create stutters that we want to avoid.
-	 * Instead we do a delayed write when we try to reclaim
-	 * a dirty dquot. Also xfs_sync will take part of the burden...
+	 * If this is not the final reference, we don't need to take the dquot
+	 * lock at all. This is effectively a mutex based atomic_dec_and_lock()
+	 * operation.
 	 */
+	if (atomic_add_unless(&dqp->q_nrefs, -1, 1))
+		return;
+
+	xfs_dqlock(dqp);
 	xfs_qm_dqput(dqp);
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 001aa89..2442c57 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1305,9 +1305,9 @@ xfs_create(
 	if (error)
 		goto out_release_inode;
 
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	xfs_qm_dqrele(pdqp);
+	xfs_dqrele(udqp);
+	xfs_dqrele(gdqp);
+	xfs_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -1327,9 +1327,9 @@ xfs_create(
 	if (ip)
 		IRELE(ip);
 
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	xfs_qm_dqrele(pdqp);
+	xfs_dqrele(udqp);
+	xfs_dqrele(gdqp);
+	xfs_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 33ad9a7..13d60b9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1300,15 +1300,15 @@ xfs_ioctl_setattr(
 	/*
 	 * Release any dquot(s) the inode had kept before chown.
 	 */
-	xfs_qm_dqrele(olddquot);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(pdqp);
+	xfs_dqrele(olddquot);
+	xfs_dqrele(udqp);
+	xfs_dqrele(pdqp);
 
 	return code;
 
  error_return:
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(pdqp);
+	xfs_dqrele(udqp);
+	xfs_dqrele(pdqp);
 	xfs_trans_cancel(tp, 0);
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0ce1d75..c5ad890 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -672,10 +672,10 @@ xfs_setattr_nonsize(
 	/*
 	 * Release any dquot(s) the inode had kept before chown.
 	 */
-	xfs_qm_dqrele(olddquot1);
-	xfs_qm_dqrele(olddquot2);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
+	xfs_dqrele(olddquot1);
+	xfs_dqrele(olddquot2);
+	xfs_dqrele(udqp);
+	xfs_dqrele(gdqp);
 
 	if (error)
 		return XFS_ERROR(error);
@@ -699,8 +699,8 @@ out_trans_cancel:
 	xfs_trans_cancel(tp, 0);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_dqrele:
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
+	xfs_dqrele(udqp);
+	xfs_dqrele(gdqp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 31c0f85..843ab07 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -505,15 +505,15 @@ xfs_qm_dqdetach(
 
 	ASSERT(!xfs_is_quota_inode(&ip->i_mount->m_sb, ip->i_ino));
 	if (ip->i_udquot) {
-		xfs_qm_dqrele(ip->i_udquot);
+		xfs_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
 	if (ip->i_gdquot) {
-		xfs_qm_dqrele(ip->i_gdquot);
+		xfs_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
 	if (ip->i_pdquot) {
-		xfs_qm_dqrele(ip->i_pdquot);
+		xfs_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
 }
@@ -1741,22 +1741,22 @@ xfs_qm_vop_dqalloc(
 	if (O_udqpp)
 		*O_udqpp = uq;
 	else if (uq)
-		xfs_qm_dqrele(uq);
+		xfs_dqrele(uq);
 	if (O_gdqpp)
 		*O_gdqpp = gq;
 	else if (gq)
-		xfs_qm_dqrele(gq);
+		xfs_dqrele(gq);
 	if (O_pdqpp)
 		*O_pdqpp = pq;
 	else if (pq)
-		xfs_qm_dqrele(pq);
+		xfs_dqrele(pq);
 	return 0;
 
 error_rele:
 	if (gq)
-		xfs_qm_dqrele(gq);
+		xfs_dqrele(gq);
 	if (uq)
-		xfs_qm_dqrele(uq);
+		xfs_dqrele(uq);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3daf5ea..1e61cd4 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -736,7 +736,7 @@ xfs_qm_scall_setqlim(
 	error = xfs_trans_commit(tp, 0);
 
 out_rele:
-	xfs_qm_dqrele(dqp);
+	xfs_dqrele(dqp);
 out_unlock:
 	mutex_unlock(&q->qi_quotaofflock);
 	return error;
@@ -975,15 +975,15 @@ xfs_dqrele_inode(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
-		xfs_qm_dqrele(ip->i_udquot);
+		xfs_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
 	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
-		xfs_qm_dqrele(ip->i_gdquot);
+		xfs_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
 	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
-		xfs_qm_dqrele(ip->i_pdquot);
+		xfs_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 5376dd4..ae4f41a 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -94,7 +94,7 @@ extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
 extern int xfs_qm_dqattach(struct xfs_inode *, uint);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
-extern void xfs_qm_dqrele(struct xfs_dquot *);
+extern void xfs_dqrele(struct xfs_dquot *);
 extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
 extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
 extern void xfs_qm_mount_quotas(struct xfs_mount *);
@@ -136,7 +136,7 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 #define xfs_qm_dqattach(ip, fl)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
-#define xfs_qm_dqrele(d)
+#define xfs_dqrele(d)
 #define xfs_qm_statvfs(ip, s)
 #define xfs_qm_newmount(mp, a, b)					(0)
 #define xfs_qm_mount_quotas(mp)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 14e58f2..14e38fe 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -395,9 +395,9 @@ xfs_symlink(
 		goto error2;
 	}
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	xfs_qm_dqrele(pdqp);
+	xfs_dqrele(udqp);
+	xfs_dqrele(gdqp);
+	xfs_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -409,9 +409,9 @@ xfs_symlink(
 	cancel_flags |= XFS_TRANS_ABORT;
  error_return:
 	xfs_trans_cancel(tp, cancel_flags);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	xfs_qm_dqrele(pdqp);
+	xfs_dqrele(udqp);
+	xfs_dqrele(gdqp);
+	xfs_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
