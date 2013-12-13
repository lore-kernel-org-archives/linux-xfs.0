Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F0767F3F
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 10:30:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1EFDC304064
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 08:30:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id FJDwsAlj8taC7hVS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 08:30:11 -0800 (PST)
Date: Fri, 13 Dec 2013 08:30:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/3] xfs: return unlocked dquots from xfs_qm_dqqet
Message-ID: <20131213163009.GA20803@infradead.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

We generally don't need the dquot structure locked for the fast path
operations, and we don't need the lock during lookup either.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f17350d..7da4097 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -689,8 +689,9 @@ error0:
 }
 
 /*
- * Given the file system, inode OR id, and type (UDQUOT/GDQUOT), return a
- * a locked dquot, doing an allocation (if requested) as needed.
+ * Given the file system, id, type and optionally inode, return a an unlocked
+ * dquot, doing an allocation if requested and needed.
+ *
  * When both an inode and an id are given, the inode's id takes precedence.
  * That is, if the id changes while we don't hold the ilock inside this
  * function, the new dquot is returned, not necessarily the one requested
@@ -739,9 +740,7 @@ restart:
 	mutex_lock(&qi->qi_tree_lock);
 	dqp = radix_tree_lookup(tree, id);
 	if (dqp) {
-		xfs_dqlock(dqp);
 		if (dqp->dq_flags & XFS_DQ_FREEING) {
-			xfs_dqunlock(dqp);
 			mutex_unlock(&qi->qi_tree_lock);
 			trace_xfs_dqget_freeing(dqp);
 			delay(1);
@@ -824,7 +823,6 @@ restart:
 	/*
 	 * We return a locked, referenced dquot to the caller.
 	 */
-	xfs_dqlock(dqp);
 	qi->qi_dquots++;
 	mutex_unlock(&qi->qi_tree_lock);
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 843ab07..985b583 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -395,7 +395,6 @@ xfs_qm_dqattach_one(
 	 * that the dquot returned is the one that should go in the inode.
 	 */
 	*IO_idqpp = dqp;
-	xfs_dqunlock(dqp);
 	return 0;
 }
 
@@ -1142,6 +1141,8 @@ xfs_qm_quotacheck_dqadjust(
 
 	trace_xfs_dqadjust(dqp);
 
+	xfs_dqlock(dqp);
+
 	/*
 	 * Adjust the inode count and the block count to reflect this inode's
 	 * resource usage.
@@ -1679,10 +1680,6 @@ xfs_qm_vop_dqalloc(
 				ASSERT(error != ENOENT);
 				return error;
 			}
-			/*
-			 * Get the ilock in the right order.
-			 */
-			xfs_dqunlock(uq);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
@@ -1706,7 +1703,6 @@ xfs_qm_vop_dqalloc(
 				ASSERT(error != ENOENT);
 				goto error_rele;
 			}
-			xfs_dqunlock(gq);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
@@ -1726,7 +1722,6 @@ xfs_qm_vop_dqalloc(
 				ASSERT(error != ENOENT);
 				goto error_rele;
 			}
-			xfs_dqunlock(pq);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index e9be63a..c8fda48 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -75,6 +75,7 @@ xfs_qm_statvfs(
 	xfs_dquot_t		*dqp;
 
 	if (!xfs_qm_dqget(mp, NULL, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
+		xfs_dqlock(dqp);
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1e61cd4..94dadbe 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -617,7 +617,6 @@ xfs_qm_scall_setqlim(
 		ASSERT(error != ENOENT);
 		goto out_unlock;
 	}
-	xfs_dqunlock(dqp);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_setqlim, 0, 0);
@@ -844,6 +843,8 @@ xfs_qm_scall_getquota(
 	if (error)
 		return error;
 
+	xfs_dqlock(dqp);
+
 	/*
 	 * If everything's NULL, this dquot doesn't quite exist as far as
 	 * our utility programs are concerned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
