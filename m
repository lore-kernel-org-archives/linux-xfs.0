Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B00D217F50;
	Tue,  4 Feb 2025 18:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695129; cv=none; b=MDodRQKAOeNEch7z9sPiLNETV9STRHVeXJe1TzNb2/ZDWtNFxbrgxrgXigrVq+ZU9bpe8XslyjfIbXqF/3/WYIThPB0HETN/o2X9N9Xn/RzYjs7pSEuh5p9z5ttZQtC8jyYU4VvtaejldiQ3m/bSSFbVnwAGDEvwfHDCCDpcqQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695129; c=relaxed/simple;
	bh=enLWGWRmnIV3v9ajCgFZqalKUKvqjBdAYa3VTuB2HVU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5q6Up5MUVwsu/NFUluZtvKNIJ4s/x2yqLXRiQWRGLWQ6H62u4ffE85+3TlNexHvNCdJmHxE5I2RkHx4/cvCW0MbHP5mB+7mYV6UPNPpdo9HXd75vKmg7JqzFdSuRxJY30kGqknQPw8a0cB60AzqAdfVE/mJcOXUkC1pO2zh9NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQjKMdv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQjKMdv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50B4C4CEDF;
	Tue,  4 Feb 2025 18:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695128;
	bh=enLWGWRmnIV3v9ajCgFZqalKUKvqjBdAYa3VTuB2HVU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WQjKMdv4lf0sEUH/Mpy0+ZftrBJi+Wtg+r3XV4aN3Hlka/w0+U6F5Tbuzk3uEjA2Z
	 IBDUSOGGXIoml2NgUSHPg4LWHpLtbF7ftjpbp7d4ymPleCKSJD4DKGkpGoZKa/LbOG
	 P4jK2szuvXTfQ1CINSjBnNL1XxA3BgFfgokanAxUFFyGoGe9ATSOAJvxc5bsi5yX1U
	 hiAj90M1T8/ps0SvpGfBYGeuZpVfCx2XVWKllPHaDCbGtqK7BUm05odS+b4ZJJCGHt
	 NlVYCTAIAr7cxz9t3IUqMCXZldS2wb+Q8In5FvvKlhtxsYC1IjifFjz+YaNYG+CgJ4
	 Y6FwjwZr5DnxA==
Date: Tue, 04 Feb 2025 10:52:08 -0800
Subject: [PATCH 04/10] xfs: separate dquot buffer reads from xfs_dqflush
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: hch@lst.de, stable@vger.kernel.org
Message-ID: <173869499406.410229.14198008987899788163.stgit@frogsfrogsfrogs>
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit a40fe30868ba433ac08376e30132400bec067583 upstream

The first step towards holding the dquot buffer in the li_buf instead of
reading it in the AIL is to separate the part that reads the buffer from
the actual flush code.  There should be no functional changes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c      |   57 +++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_dquot.h      |    4 ++-
 fs/xfs/xfs_dquot_item.c |   20 +++++++++++++---
 fs/xfs/xfs_qm.c         |   37 +++++++++++++++++++++++++------
 4 files changed, 86 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c1b211c260a9d5..5c4ede3e0fc70d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1232,6 +1232,42 @@ xfs_qm_dqflush_check(
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
@@ -1243,11 +1279,10 @@ xfs_qm_dqflush_check(
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
@@ -1257,28 +1292,12 @@ xfs_qm_dqflush(
 
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
@@ -1328,14 +1347,12 @@ xfs_qm_dqflush(
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
index 677bb2dc9ac913..fb9995d2f2331a 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -204,7 +204,9 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
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
index 7e2307921deb2f..4f50d8ce125f57 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -146,17 +146,28 @@ xfs_qm_dqpurge(
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
@@ -462,7 +473,17 @@ xfs_qm_dquot_isolate(
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
 
@@ -1287,11 +1308,13 @@ xfs_qm_flush_one(
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

