Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FCBC2C6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584564; cv=none; b=cLy1qv6NJeJAmY2PbzcphRDwzEJDp4BW0G9g/Kg87REnHwdrqvINVUeWJrfZy0wVTeY0v4KMQ3pBiPYQ6n4GTOEIB0iIjkwfC8+HM2MMnN+kYQoCwfx/g4r5kTRhuTpGSRxvXx7mJHsmOjVzSF+9xPBj6p2WpbzzZrwXx2+aRQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584564; c=relaxed/simple;
	bh=OEpbbLhd9xGpUqvgxIdzfNl8VMCax2QtZGTLNzrrYGI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cNnI/TWc8ENxW+mo6bhtXBK4xHphvS/S5zJbppvJmdSgsj+JOvsuoUxr3GjFwc2wu4AWgJ/NB+2BtZQZUgpt7CxBQPMpR08/Tk8vclgCf9NoU31DPaH34uzPNm1XPg+hwQ3sUpUSzbahLkJo84lPMJHl9k8gwHQMLWyz9C1sWFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kacscxk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kacscxk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA549C4CECE;
	Tue, 26 Nov 2024 01:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584564;
	bh=OEpbbLhd9xGpUqvgxIdzfNl8VMCax2QtZGTLNzrrYGI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kacscxk7bxK76nUcQHEwT7S3rSYYXPV1bGzsl7Sf4sOBN+8JWZnwysvGzkjZU9DEY
	 SZx7+7U+1psUgRf9nopYxHzS2VA0/mnHrdB9hiSQch4ZFRk2UOpsebHNdTvyuxJ1wK
	 Z/irpNi3zAUtGsqIaZWFDXiiJCyE3+sehOsyWxbpP/dT09KFSWKE6MvXBeHg6M2p7b
	 aCE8D2mQMCFIo8617/4+Ja8rCLRwMMHeQIL05miTMYGiBP0VRVOT3dSjlTOzabS5LH
	 orr+OS0NLwTnESMmcYuJiPQD5ALmstgT9+PhI9J4iwuujxU7nyhdG1UB8AjYfKtjCz
	 ja4N/QD8MPHkA==
Date: Mon, 25 Nov 2024 17:29:24 -0800
Subject: [PATCH 18/21] xfs: separate dquot buffer reads from xfs_dqflush
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173258398108.4032920.1511154808709795549.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The first step towards holding the dquot buffer in the li_buf instead of
reading it in the AIL is to separate the part that reads the buffer from
the actual flush code.  There should be no functional changes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c      |   57 +++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_dquot.h      |    4 ++-
 fs/xfs/xfs_dquot_item.c |   20 +++++++++++++---
 fs/xfs/xfs_qm.c         |   37 +++++++++++++++++++++++++------
 4 files changed, 86 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ff982d983989b0..6ec4087e38dfc8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1238,6 +1238,42 @@ xfs_qm_dqflush_check(
 	return NULL;
 }
 
+/*
+ * Get the buffer containing the on-disk dquot.
+ *
+ * Requires dquot flush lock, will clear the dirty flag, delete the quota log
+ * item from the AIL, and shut down the system if something goes wrong.
+ */
+int
+xfs_dquot_read_buf(
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_buf		*bp = NULL;
+	int			error;
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
+				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   &bp, &xfs_dquot_buf_ops);
+	if (error == -EAGAIN)
+		return error;
+	if (xfs_metadata_is_sick(error))
+		xfs_dquot_mark_sick(dqp);
+	if (error)
+		goto out_abort;
+
+	*bpp = bp;
+	return 0;
+
+out_abort:
+	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
+	xfs_trans_ail_delete(&dqp->q_logitem.qli_item, 0);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return error;
+}
+
 /*
  * Write a modified dquot to disk.
  * The dquot must be locked and the flush lock too taken by caller.
@@ -1249,11 +1285,10 @@ xfs_qm_dqflush_check(
 int
 xfs_qm_dqflush(
 	struct xfs_dquot	*dqp,
-	struct xfs_buf		**bpp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
-	struct xfs_buf		*bp;
 	struct xfs_dqblk	*dqblk;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -1263,28 +1298,12 @@ xfs_qm_dqflush(
 
 	trace_xfs_dqflush(dqp);
 
-	*bpp = NULL;
-
 	xfs_qm_dqunpin_wait(dqp);
 
-	/*
-	 * Get the buffer containing the on-disk dquot
-	 */
-	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
-				   &bp, &xfs_dquot_buf_ops);
-	if (error == -EAGAIN)
-		goto out_unlock;
-	if (xfs_metadata_is_sick(error))
-		xfs_dquot_mark_sick(dqp);
-	if (error)
-		goto out_abort;
-
 	fa = xfs_qm_dqflush_check(dqp);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
 				dqp->q_id, fa);
-		xfs_buf_relse(bp);
 		xfs_dquot_mark_sick(dqp);
 		error = -EFSCORRUPTED;
 		goto out_abort;
@@ -1334,14 +1353,12 @@ xfs_qm_dqflush(
 	}
 
 	trace_xfs_dqflush_done(dqp);
-	*bpp = bp;
 	return 0;
 
 out_abort:
 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 	xfs_trans_ail_delete(lip, 0);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-out_unlock:
 	xfs_dqfunlock(dqp);
 	return error;
 }
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index d73d179df00958..50f8404c41176c 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -214,7 +214,9 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
 
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
-int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
+int		xfs_dquot_read_buf(struct xfs_trans *tp, struct xfs_dquot *dqp,
+				struct xfs_buf **bpp);
+int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
 void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 7d19091215b080..56ecc5ed01934d 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -155,14 +155,26 @@ xfs_qm_dquot_logitem_push(
 
 	spin_unlock(&lip->li_ailp->ail_lock);
 
-	error = xfs_qm_dqflush(dqp, &bp);
+	error = xfs_dquot_read_buf(NULL, dqp, &bp);
+	if (error) {
+		if (error == -EAGAIN)
+			rval = XFS_ITEM_LOCKED;
+		xfs_dqfunlock(dqp);
+		goto out_relock_ail;
+	}
+
+	/*
+	 * dqflush completes dqflock on error, and the delwri ioend does it on
+	 * success.
+	 */
+	error = xfs_qm_dqflush(dqp, bp);
 	if (!error) {
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
-		xfs_buf_relse(bp);
-	} else if (error == -EAGAIN)
-		rval = XFS_ITEM_LOCKED;
+	}
+	xfs_buf_relse(bp);
 
+out_relock_ail:
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
 	xfs_dqunlock(dqp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a4fa21dfd6b4ad..341fe4821c2d77 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -148,17 +148,28 @@ xfs_qm_dqpurge(
 		 * We don't care about getting disk errors here. We need
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
-		error = xfs_qm_dqflush(dqp, &bp);
+		error = xfs_dquot_read_buf(NULL, dqp, &bp);
+		if (error == -EAGAIN) {
+			xfs_dqfunlock(dqp);
+			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
+			goto out_unlock;
+		}
+		if (error)
+			goto out_funlock;
+
+		/*
+		 * dqflush completes dqflock on error, and the bwrite ioend
+		 * does it on success.
+		 */
+		error = xfs_qm_dqflush(dqp, bp);
 		if (!error) {
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
-		} else if (error == -EAGAIN) {
-			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
-			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
 	}
 
+out_funlock:
 	ASSERT(atomic_read(&dqp->q_pincount) == 0);
 	ASSERT(xlog_is_shutdown(dqp->q_logitem.qli_item.li_log) ||
 		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
@@ -495,7 +506,17 @@ xfs_qm_dquot_isolate(
 		/* we have to drop the LRU lock to flush the dquot */
 		spin_unlock(lru_lock);
 
-		error = xfs_qm_dqflush(dqp, &bp);
+		error = xfs_dquot_read_buf(NULL, dqp, &bp);
+		if (error) {
+			xfs_dqfunlock(dqp);
+			goto out_unlock_dirty;
+		}
+
+		/*
+		 * dqflush completes dqflock on error, and the delwri ioend
+		 * does it on success.
+		 */
+		error = xfs_qm_dqflush(dqp, bp);
 		if (error)
 			goto out_unlock_dirty;
 
@@ -1491,11 +1512,13 @@ xfs_qm_flush_one(
 		goto out_unlock;
 	}
 
-	error = xfs_qm_dqflush(dqp, &bp);
+	error = xfs_dquot_read_buf(NULL, dqp, &bp);
 	if (error)
 		goto out_unlock;
 
-	xfs_buf_delwri_queue(bp, buffer_list);
+	error = xfs_qm_dqflush(dqp, bp);
+	if (!error)
+		xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
 out_unlock:
 	xfs_dqunlock(dqp);

