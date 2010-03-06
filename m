Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o261oODn041889 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 19:50:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E894313FE7FD
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 17:51:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	8bxVdGXACo0SVu5A for <xfs@oss.sgi.com>;
	Fri, 05 Mar 2010 17:51:45 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	4462091-1927428
	for <xfs@oss.sgi.com>; Sat, 06 Mar 2010 12:21:40 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NnjB3-0007Rt-Ii
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:37 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NnjAv-0001EP-1j
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/9] xfs: remove stale parameter from ->iop_unpin method
Date: Sat,  6 Mar 2010 12:51:18 +1100
Message-Id: <1267840284-4652-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1267840284-4652-1-git-send-email-david@fromorbit.com>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
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

The staleness of a object being unpinned can be directly derived
from the object itself - there is no need to extract it from the
object then pass it as a parameter into IOP_UNPIN().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_dquot_item.c |   16 +++++--------
 fs/xfs/xfs_buf_item.c         |   50 ++++++++++++++++++-----------------------
 fs/xfs/xfs_extfree_item.c     |    8 +++---
 fs/xfs/xfs_inode_item.c       |    7 ++---
 fs/xfs/xfs_trans.c            |    2 +-
 fs/xfs/xfs_trans.h            |    5 +--
 fs/xfs/xfs_trans_buf.c        |    3 +-
 7 files changed, 39 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
index 639d965..165bbdf 100644
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -107,8 +107,7 @@ xfs_qm_dquot_logitem_pin(
 /* ARGSUSED */
 STATIC void
 xfs_qm_dquot_logitem_unpin(
-	xfs_dq_logitem_t *logitem,
-	int		  stale)
+	xfs_dq_logitem_t *logitem)
 {
 	xfs_dquot_t *dqp = logitem->qli_dquot;
 
@@ -123,7 +122,7 @@ xfs_qm_dquot_logitem_unpin_remove(
 	xfs_dq_logitem_t *logitem,
 	xfs_trans_t	 *tp)
 {
-	xfs_qm_dquot_logitem_unpin(logitem, 0);
+	xfs_qm_dquot_logitem_unpin(logitem);
 }
 
 /*
@@ -329,8 +328,7 @@ static struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_dquot_logitem_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))
-					xfs_qm_dquot_logitem_unpin,
+	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_unpin,
 	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t*))
 					xfs_qm_dquot_logitem_unpin_remove,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))
@@ -425,7 +423,7 @@ xfs_qm_qoff_logitem_pin(xfs_qoff_logitem_t *qf)
  */
 /*ARGSUSED*/
 STATIC void
-xfs_qm_qoff_logitem_unpin(xfs_qoff_logitem_t *qf, int stale)
+xfs_qm_qoff_logitem_unpin(xfs_qoff_logitem_t *qf)
 {
 	return;
 }
@@ -536,8 +534,7 @@ static struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_qoff_logitem_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t* ,int))
-					xfs_qm_qoff_logitem_unpin,
+	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unpin,
 	.iop_unpin_remove = (void(*)(xfs_log_item_t*,xfs_trans_t*))
 					xfs_qm_qoff_logitem_unpin_remove,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_trylock,
@@ -558,8 +555,7 @@ static struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_qoff_logitem_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))
-					xfs_qm_qoff_logitem_unpin,
+	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unpin,
 	.iop_unpin_remove = (void(*)(xfs_log_item_t*,xfs_trans_t*))
 					xfs_qm_qoff_logitem_unpin_remove,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_trylock,
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index aace237..240340a 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -372,12 +372,12 @@ xfs_buf_item_pin(
  */
 STATIC void
 xfs_buf_item_unpin(
-	xfs_buf_log_item_t	*bip,
-	int			stale)
+	xfs_buf_log_item_t	*bip)
 {
 	struct xfs_ail	*ailp;
 	xfs_buf_t	*bp;
 	int		freed;
+	int		stale = bip->bli_flags & XFS_BLI_STALE;
 
 	bp = bip->bli_buf;
 	ASSERT(bp != NULL);
@@ -428,40 +428,34 @@ xfs_buf_item_unpin_remove(
 	xfs_buf_log_item_t	*bip,
 	xfs_trans_t		*tp)
 {
-	xfs_buf_t		*bp;
-	xfs_log_item_desc_t	*lidp;
-	int			stale = 0;
-
-	bp = bip->bli_buf;
-	/*
-	 * will xfs_buf_item_unpin() call xfs_buf_item_relse()?
-	 */
+	/* will xfs_buf_item_unpin() call xfs_buf_item_relse()? */
 	if ((atomic_read(&bip->bli_refcount) == 1) &&
 	    (bip->bli_flags & XFS_BLI_STALE)) {
+		/*
+		 * yes -- We can safely do some work here and then call
+		 * buf_item_unpin to do the rest because we are
+		 * are holding the buffer locked so no one else will be
+		 * able to bump up the refcount. We have to remove the
+		 * log item from the transaction as we are about to release
+		 * our reference to the buffer. If we don't, the unlock that
+		 * occurs later in the xfs_trans_uncommit() will try to
+		 * reference the buffer which we no longer have a hold on.
+		 */
+		struct xfs_log_item_desc *lidp;
+
 		ASSERT(XFS_BUF_VALUSEMA(bip->bli_buf) <= 0);
 		trace_xfs_buf_item_unpin_stale(bip);
 
-		/*
-		 * yes -- clear the xaction descriptor in-use flag
-		 * and free the chunk if required.  We can safely
-		 * do some work here and then call buf_item_unpin
-		 * to do the rest because if the if is true, then
-		 * we are holding the buffer locked so no one else
-		 * will be able to bump up the refcount.
-		 */
-		lidp = xfs_trans_find_item(tp, (xfs_log_item_t *) bip);
-		stale = lidp->lid_flags & XFS_LID_BUF_STALE;
+		lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)bip);
 		xfs_trans_free_item(tp, lidp);
+
 		/*
-		 * Since the transaction no longer refers to the buffer,
-		 * the buffer should no longer refer to the transaction.
+		 * Since the transaction no longer refers to the buffer, the
+		 * buffer should no longer refer to the transaction.
 		 */
-		XFS_BUF_SET_FSPRIVATE2(bp, NULL);
+		XFS_BUF_SET_FSPRIVATE2(bip->bli_buf, NULL);
 	}
-
-	xfs_buf_item_unpin(bip, stale);
-
-	return;
+	xfs_buf_item_unpin(bip);
 }
 
 /*
@@ -675,7 +669,7 @@ static struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_buf_item_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_buf_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_buf_item_unpin,
+	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_buf_item_unpin,
 	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t *))
 					xfs_buf_item_unpin_remove,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_buf_item_trylock,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e461e93..409fe81 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -106,7 +106,7 @@ xfs_efi_item_pin(xfs_efi_log_item_t *efip)
  */
 /*ARGSUSED*/
 STATIC void
-xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
+xfs_efi_item_unpin(xfs_efi_log_item_t *efip)
 {
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 
@@ -224,7 +224,7 @@ static struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_efi_item_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_efi_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_efi_item_unpin,
+	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_efi_item_unpin,
 	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t *))
 					xfs_efi_item_unpin_remove,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_efi_item_trylock,
@@ -425,7 +425,7 @@ xfs_efd_item_pin(xfs_efd_log_item_t *efdp)
  */
 /*ARGSUSED*/
 STATIC void
-xfs_efd_item_unpin(xfs_efd_log_item_t *efdp, int stale)
+xfs_efd_item_unpin(xfs_efd_log_item_t *efdp)
 {
 	return;
 }
@@ -515,7 +515,7 @@ static struct xfs_item_ops xfs_efd_item_ops = {
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_efd_item_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_efd_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_efd_item_unpin,
+	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_efd_item_unpin,
 	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t*))
 					xfs_efd_item_unpin_remove,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_efd_item_trylock,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0347175..cf8249a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -557,8 +557,7 @@ xfs_inode_item_pin(
 /* ARGSUSED */
 STATIC void
 xfs_inode_item_unpin(
-	xfs_inode_log_item_t	*iip,
-	int			stale)
+	xfs_inode_log_item_t	*iip)
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 
@@ -574,7 +573,7 @@ xfs_inode_item_unpin_remove(
 	xfs_inode_log_item_t	*iip,
 	xfs_trans_t		*tp)
 {
-	xfs_inode_item_unpin(iip, 0);
+	xfs_inode_item_unpin(iip);
 }
 
 /*
@@ -840,7 +839,7 @@ static struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_inode_item_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_inode_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_inode_item_unpin,
+	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_inode_item_unpin,
 	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t*))
 					xfs_inode_item_unpin_remove,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_inode_item_trylock,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f73e358..6962f2b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1451,6 +1451,6 @@ xfs_trans_chunk_committed(
 		 * flags, if anyone else stales the buffer we do not
 		 * want to pay any attention to it.
 		 */
-		IOP_UNPIN(lip, lidp->lid_flags & XFS_LID_BUF_STALE);
+		IOP_UNPIN(lip);
 	}
 }
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 79c8bab..82574ef 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -159,7 +159,6 @@ typedef struct xfs_log_item_desc {
 
 #define XFS_LID_DIRTY		0x1
 #define XFS_LID_PINNED		0x2
-#define XFS_LID_BUF_STALE	0x8
 
 /*
  * This structure is used to maintain a chunk list of log_item_desc
@@ -833,7 +832,7 @@ typedef struct xfs_item_ops {
 	uint (*iop_size)(xfs_log_item_t *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
 	void (*iop_pin)(xfs_log_item_t *);
-	void (*iop_unpin)(xfs_log_item_t *, int);
+	void (*iop_unpin)(xfs_log_item_t *);
 	void (*iop_unpin_remove)(xfs_log_item_t *, struct xfs_trans *);
 	uint (*iop_trylock)(xfs_log_item_t *);
 	void (*iop_unlock)(xfs_log_item_t *);
@@ -846,7 +845,7 @@ typedef struct xfs_item_ops {
 #define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
 #define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
 #define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
-#define IOP_UNPIN(ip, flags)	(*(ip)->li_ops->iop_unpin)(ip, flags)
+#define IOP_UNPIN(ip)		(*(ip)->li_ops->iop_unpin)(ip)
 #define IOP_UNPIN_REMOVE(ip,tp) (*(ip)->li_ops->iop_unpin_remove)(ip, tp)
 #define IOP_TRYLOCK(ip)		(*(ip)->li_ops->iop_trylock)(ip)
 #define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index fb58636..4e1b689 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -696,7 +696,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	lidp->lid_flags |= XFS_LID_DIRTY;
-	lidp->lid_flags &= ~XFS_LID_BUF_STALE;
 	bip->bli_flags |= XFS_BLI_LOGGED;
 	xfs_buf_item_log(bip, first, last);
 }
@@ -782,7 +781,7 @@ xfs_trans_binval(
 	bip->bli_format.blf_flags |= XFS_BLI_CANCEL;
 	memset((char *)(bip->bli_format.blf_data_map), 0,
 	      (bip->bli_format.blf_map_size * sizeof(uint)));
-	lidp->lid_flags |= XFS_LID_DIRTY|XFS_LID_BUF_STALE;
+	lidp->lid_flags |= XFS_LID_DIRTY;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
