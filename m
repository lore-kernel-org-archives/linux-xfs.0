Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2875229B0
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817522; cv=none; b=Da/XWlzP2lXE3eZOBjvh/NxIrwoQYPK7mHDkMMWtNtaKJlJ1vHlGXyX0wz52LJ9RTEBM2sBqrlqlk2J5lwtSjVc7V8WtKR+OqtRlvIrmy+6USU1mffB51RhI/hlOFLOaTP65VTEMi3Lg8dvqu92eoe5zeSeRkBkmSClRoTld7po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817522; c=relaxed/simple;
	bh=GQkfcRuLQaPH9+DSDu+vwZ6+SjNvUUxnScMwU0aMieI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGd6Wgwipm+e9YioICo7lmt1oJboVPeiaUxGeqWyPSMMjX2ISCZKCtuO/2zZzgCE1U1z8hEgZ0axGoNzx49lqNG1BN548RX7/qQF/UkIAkU9Cj3KUJ2Cz/0uBjSksm4j4u8EwFKAsJCbWZzqK/u9Vg/n0pWipxefPQpCqLkgtnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ujXb0two; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ujXb0two"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6250C433F1;
	Thu,  1 Feb 2024 19:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817522;
	bh=GQkfcRuLQaPH9+DSDu+vwZ6+SjNvUUxnScMwU0aMieI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ujXb0twocyCFghTqqcF9hG6BP7WsKTs0KmMn9iYzZJ0k17W11I4LXC9KqiQmL+vlA
	 4fxvHPZZ8NFYAak69KRCkiC8GPqjNPVj6HHiPo4s8O2XUuUO4hfvoFQGj26OAGiJFx
	 uz7up3PApreOJ8IjvZWYo/pkN2HexLPfARTBpYo9pVBqMVFb5j1Lrul4qlfei/zzOa
	 0iZ7q/mx6PmwmqcP08tIVYVFSY2rfgBy0rWE5jvuTJIgGtiRr/vtEjfnN4DxM2s+Lv
	 glRmjHKFDio8ELIpNMN7Vy53zQlczW7hMQkxmiud2PFsGwkTSojc1V9Qkcz+KF3ewM
	 4QlVA3oIg5k+w==
Date: Thu, 01 Feb 2024 11:58:41 -0800
Subject: [PATCH 5/5] xfs: launder in-memory btree buffers before transaction
 commit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170681337043.1608400.926783069179071619.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
References: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As we've noted in various places, all current users of in-memory btrees
are online fsck.  Online fsck only stages a btree long enough to rebuild
an ondisk data structure, which means that the in-memory btree is
ephemeral.  Furthermore, if we encounter /any/ errors while updating an
in-memory btree, all we do is tear down all the staged data and return
an errno to userspace.  In-memory btrees need not be transactional, so
their buffers should not be committed to the ondisk log, nor should they
be checkpointed by the AIL.  That's just as well since the ephemeral
nature of the btree means that the buftarg and the buffers may disappear
quickly anyway.

Therefore, we need a way to launder the btree buffers that get attached
to the transaction by the generic btree code.  Because the buffers are
directly mapped to backing file pages, there's no need to bwrite them
back to the tmpfs file.  All we need to do is clean enough of the buffer
log item state so that the bli can be detached from the buffer, remove
the bli from the transaction's log item list, and reset the transaction
dirty state as if the laundered items had never been there.

For simplicity, create xfbtree transaction commit and cancel helpers
that launder the in-memory btree buffers for callers.  Once laundered,
call the write verifier on non-stale buffers to avoid integrity issues,
or punch a hole in the backing file for stale buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_mem.c |  119 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree_mem.h |    3 +
 fs/xfs/xfs_buf_mem.c          |   68 +++++++++++++++++++++++
 fs/xfs/xfs_buf_mem.h          |    2 +
 fs/xfs/xfs_trace.h            |    1 
 fs/xfs/xfs_trans.h            |    1 
 fs/xfs/xfs_trans_buf.c        |   42 ++++++++++++++
 7 files changed, 236 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index cb156e9363a5d..036061fe32cc9 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -226,3 +226,122 @@ xfbtree_get_maxrecs(
 
 	return xfbt->maxrecs[level != 0];
 }
+
+/* If this log item is a buffer item that came from the xfbtree, return it. */
+static inline struct xfs_buf *
+xfbtree_buf_match(
+	struct xfbtree			*xfbt,
+	const struct xfs_log_item	*lip)
+{
+	const struct xfs_buf_log_item	*bli;
+	struct xfs_buf			*bp;
+
+	if (lip->li_type != XFS_LI_BUF)
+		return NULL;
+
+	bli = container_of(lip, struct xfs_buf_log_item, bli_item);
+	bp = bli->bli_buf;
+	if (bp->b_target != xfbt->target)
+		return NULL;
+
+	return bp;
+}
+
+/*
+ * Commit changes to the incore btree immediately by writing all dirty xfbtree
+ * buffers to the backing xfile.  This detaches all xfbtree buffers from the
+ * transaction, even on failure.  The buffer locks are dropped between the
+ * delwri queue and submit, so the caller must synchronize btree access.
+ *
+ * Normally we'd let the buffers commit with the transaction and get written to
+ * the xfile via the log, but online repair stages ephemeral btrees in memory
+ * and uses the btree_staging functions to write new btrees to disk atomically.
+ * The in-memory btree (and its backing store) are discarded at the end of the
+ * repair phase, which means that xfbtree buffers cannot commit with the rest
+ * of a transaction.
+ *
+ * In other words, online repair only needs the transaction to collect buffer
+ * pointers and to avoid buffer deadlocks, not to guarantee consistency of
+ * updates.
+ */
+int
+xfbtree_trans_commit(
+	struct xfbtree		*xfbt,
+	struct xfs_trans	*tp)
+{
+	struct xfs_log_item	*lip, *n;
+	bool			tp_dirty = false;
+	int			error = 0;
+
+	/*
+	 * For each xfbtree buffer attached to the transaction, write the dirty
+	 * buffers to the xfile and release them.
+	 */
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		struct xfs_buf	*bp = xfbtree_buf_match(xfbt, lip);
+
+		if (!bp) {
+			if (test_bit(XFS_LI_DIRTY, &lip->li_flags))
+				tp_dirty |= true;
+			continue;
+		}
+
+		trace_xfbtree_trans_commit_buf(xfbt, bp);
+
+		xmbuf_trans_bdetach(tp, bp);
+
+		/*
+		 * If the buffer fails verification, note the failure but
+		 * continue walking the transaction items so that we remove all
+		 * ephemeral btree buffers.
+		 */
+		if (!error)
+			error = xmbuf_finalize(bp);
+
+		xfs_buf_relse(bp);
+	}
+
+	/*
+	 * Reset the transaction's dirty flag to reflect the dirty state of the
+	 * log items that are still attached.
+	 */
+	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
+			(tp_dirty ? XFS_TRANS_DIRTY : 0);
+
+	return error;
+}
+
+/*
+ * Cancel changes to the incore btree by detaching all the xfbtree buffers.
+ * Changes are not undone, so callers must not access the btree ever again.
+ */
+void
+xfbtree_trans_cancel(
+	struct xfbtree		*xfbt,
+	struct xfs_trans	*tp)
+{
+	struct xfs_log_item	*lip, *n;
+	bool			tp_dirty = false;
+
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		struct xfs_buf	*bp = xfbtree_buf_match(xfbt, lip);
+
+		if (!bp) {
+			if (test_bit(XFS_LI_DIRTY, &lip->li_flags))
+				tp_dirty |= true;
+			continue;
+		}
+
+		trace_xfbtree_trans_cancel_buf(xfbt, bp);
+
+		xmbuf_trans_bdetach(tp, bp);
+		xfs_buf_relse(bp);
+	}
+
+	/*
+	 * Reset the transaction's dirty flag to reflect the dirty state of the
+	 * log items that are still attached.
+	 */
+	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
+			(tp_dirty ? XFS_TRANS_DIRTY : 0);
+}
diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
index ecc2ceac3ed4f..1c3825786ec84 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.h
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
@@ -65,6 +65,9 @@ int xfbtree_free_block(struct xfs_btree_cur *cur, struct xfs_buf *bp);
 int xfbtree_init(struct xfs_mount *mp, struct xfbtree *xfbt,
 		struct xfs_buftarg *btp, const struct xfs_btree_ops *ops);
 void xfbtree_destroy(struct xfbtree *xfbt);
+
+int xfbtree_trans_commit(struct xfbtree *xfbt, struct xfs_trans *tp);
+void xfbtree_trans_cancel(struct xfbtree *xfbt, struct xfs_trans *tp);
 #else
 # define xfbtree_verify_bno(...)	(false)
 #endif /* CONFIG_XFS_BTREE_IN_MEM */
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 73caa2ea8b18f..8ad38c64708ec 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -9,6 +9,10 @@
 #include "xfs_buf_mem.h"
 #include "xfs_trace.h"
 #include <linux/shmem_fs.h>
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_error.h"
 
 /*
  * Buffer Cache for In-Memory Files
@@ -200,3 +204,67 @@ xmbuf_verify_daddr(
 
 	return daddr < (inode->i_sb->s_maxbytes >> BBSHIFT);
 }
+
+/* Discard the page backing this buffer. */
+static void
+xmbuf_stale(
+	struct xfs_buf		*bp)
+{
+	struct inode		*inode = file_inode(bp->b_target->bt_file);
+	loff_t			pos;
+
+	ASSERT(xfs_buftarg_is_mem(bp->b_target));
+
+	pos = BBTOB(xfs_buf_daddr(bp));
+	shmem_truncate_range(inode, pos, pos + BBTOB(bp->b_length) - 1);
+}
+
+/*
+ * Finalize a buffer -- discard the backing page if it's stale, or run the
+ * write verifier to detect problems.
+ */
+int
+xmbuf_finalize(
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa;
+	int			error = 0;
+
+	if (bp->b_flags & XBF_STALE) {
+		xmbuf_stale(bp);
+		return 0;
+	}
+
+	/*
+	 * Although this btree is ephemeral, validate the buffer structure so
+	 * that we can detect memory corruption errors and software bugs.
+	 */
+	fa = bp->b_ops->verify_struct(bp);
+	if (fa) {
+		error = -EFSCORRUPTED;
+		xfs_verifier_error(bp, error, fa);
+	}
+
+	return error;
+}
+
+/*
+ * Detach this xmbuf buffer from the transaction by any means necessary.
+ * All buffers are direct-mapped, so they do not need bwrite.
+ */
+void
+xmbuf_trans_bdetach(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bli = bp->b_log_item;
+
+	ASSERT(bli != NULL);
+
+	bli->bli_flags &= ~(XFS_BLI_DIRTY | XFS_BLI_ORDERED |
+			    XFS_BLI_LOGGED | XFS_BLI_STALE);
+	clear_bit(XFS_LI_DIRTY, &bli->bli_item.li_flags);
+
+	while (bp->b_log_item != NULL)
+		xfs_trans_bdetach(tp, bp);
+}
diff --git a/fs/xfs/xfs_buf_mem.h b/fs/xfs/xfs_buf_mem.h
index dfb3029113ff7..eed4a7b63232a 100644
--- a/fs/xfs/xfs_buf_mem.h
+++ b/fs/xfs/xfs_buf_mem.h
@@ -22,6 +22,8 @@ void xmbuf_free(struct xfs_buftarg *btp);
 int xmbuf_map_page(struct xfs_buf *bp);
 void xmbuf_unmap_page(struct xfs_buf *bp);
 bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
+void xmbuf_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
+int xmbuf_finalize(struct xfs_buf *bp);
 #else
 # define xfs_buftarg_is_mem(...)	(false)
 # define xmbuf_map_page(...)		(-ENOMEM)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 17116cc53b0fe..5dabc484ef720 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -642,6 +642,7 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf_recur);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_log_buf);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_brelse);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bdetach);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 08ce757c74545..3f7e3a09a49ff 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -215,6 +215,7 @@ struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
 void		xfs_trans_bhold(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bhold_release(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_binval(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 6549e50d852c0..e28ab74af4f0e 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -392,6 +392,48 @@ xfs_trans_brelse(
 	xfs_buf_relse(bp);
 }
 
+/*
+ * Forcibly detach a buffer previously joined to the transaction.  The caller
+ * will retain its locked reference to the buffer after this function returns.
+ * The buffer must be completely clean and must not be held to the transaction.
+ */
+void
+xfs_trans_bdetach(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	ASSERT(tp != NULL);
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+
+	trace_xfs_trans_bdetach(bip);
+
+	/*
+	 * Erase all recursion count, since we're removing this buffer from the
+	 * transaction.
+	 */
+	bip->bli_recur = 0;
+
+	/*
+	 * The buffer must be completely clean.  Specifically, it had better
+	 * not be dirty, stale, logged, ordered, or held to the transaction.
+	 */
+	ASSERT(!test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY));
+	ASSERT(!(bip->bli_flags & XFS_BLI_HOLD));
+	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
+	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
+
+	/* Unlink the log item from the transaction and drop the log item. */
+	xfs_trans_del_item(&bip->bli_item);
+	xfs_buf_item_put(bip);
+	bp->b_transp = NULL;
+}
+
 /*
  * Mark the buffer as not needing to be unlocked when the buf item's
  * iop_committing() routine is called.  The buffer must already be locked

