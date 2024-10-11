Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78E18F54
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608549; cv=none; b=FtUM975PXZLei1yLhqu8lq76sDmYtAoGeSsgg9RUSxX6DBV2u1Ev7btZoLotxIU8Eb8ykWyIsduciORnKNGOX+k4QYUid0/1hLdSZyowjLpB8lVaf9VsaAWXzNTDzYBKo/9I5bdLKc0VHtA60QPRpplL57IDzk/mhkvZG2KlAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608549; c=relaxed/simple;
	bh=qXGNVy/7Sc7Z4Xo1fOtiqhBIaxmzlhHVleDDCW7a4A0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j5V3JdhNsqedlVc4RzKQSnP2iz2tnkJrQJLH2z/5oF2w5Ch7F42qQWeR23Xwv1MPPGZVBAd75f7EJDH/me3FAzerBoyRRignJMMm91hshOzeYmWwxK7R0a05Z9slBn9YB67E/yEB9WbfTN/o1aVw10zqi5BmfrOMwVhdOfw1rpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=McKkFuGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McKkFuGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60FAC4CEC5;
	Fri, 11 Oct 2024 01:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608548;
	bh=qXGNVy/7Sc7Z4Xo1fOtiqhBIaxmzlhHVleDDCW7a4A0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=McKkFuGDLC+0D3lgLbd1HrFdC9cUclB7wJzAWg8aLGqKM9it93cZAJKXArFsCRlsM
	 Kp0d2RPi82vGe65hnA3RGnuwkE6B/0o2d08i3vrP/xc87Nx/KaCgGhkaBsy7zHC4fP
	 uHv2CvoBjUPy3cNS0tyQZzKe1oLXdBSvkszb+FeSVxe0HStB3SY37WdNAAWn6C3Icb
	 xaDjoYD/MoQAHc3RXT6DULZlK0M3A5Ph272swdxM6oLlXDiXfJpmehGkmtbTPtNDll
	 0k0/0zNzyuX4Z4ErcGuUp0V75nGeCtfni8Robfxnw/8ZmMaEq/JMFXMrmSB0f4cbe+
	 WHSUk5yrobGJw==
Date: Thu, 10 Oct 2024 18:02:28 -0700
Subject: [PATCH 03/36] xfs: update realtime super every time we update the
 primary fs super
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644290.4178701.5315771510939279200.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Every time we update parts of the primary filesystem superblock that are
echoed in the rt superblock, we must update the rt super.  Avoid
changing the log to support logging to the rt device by using ordered
buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c   |   60 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h   |    7 +++++
 fs/xfs/libxfs/xfs_sb.c        |   14 +++++++++-
 fs/xfs/libxfs/xfs_sb.h        |    2 +
 fs/xfs/xfs_buf_item_recover.c |   18 ++++++++++++
 fs/xfs/xfs_ioctl.c            |    4 ++-
 fs/xfs/xfs_trans.c            |    1 +
 fs/xfs/xfs_trans.h            |    1 +
 fs/xfs/xfs_trans_buf.c        |   25 ++++++++++++++---
 9 files changed, 124 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 2fdaba2e945400..191a4fcbecdab1 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -542,3 +542,63 @@ const struct xfs_buf_ops xfs_rtsb_buf_ops = {
 	.verify_write	= xfs_rtsb_write_verify,
 	.verify_struct	= xfs_rtsb_verify_all,
 };
+
+/* Update a realtime superblock from the primary fs super */
+void
+xfs_update_rtsb(
+	struct xfs_buf		*rtsb_bp,
+	const struct xfs_buf	*sb_bp)
+{
+	const struct xfs_dsb	*dsb = sb_bp->b_addr;
+	struct xfs_rtsb		*rsb = rtsb_bp->b_addr;
+	const uuid_t		*meta_uuid;
+
+	rsb->rsb_magicnum = cpu_to_be32(XFS_RTSB_MAGIC);
+
+	rsb->rsb_pad = 0;
+	memcpy(&rsb->rsb_fname, &dsb->sb_fname, XFSLABEL_MAX);
+
+	memcpy(&rsb->rsb_uuid, &dsb->sb_uuid, sizeof(rsb->rsb_uuid));
+
+	/*
+	 * The metadata uuid is the fs uuid if the metauuid feature is not
+	 * enabled.
+	 */
+	if (dsb->sb_features_incompat &
+				cpu_to_be32(XFS_SB_FEAT_INCOMPAT_META_UUID))
+		meta_uuid = &dsb->sb_meta_uuid;
+	else
+		meta_uuid = &dsb->sb_uuid;
+	memcpy(&rsb->rsb_meta_uuid, meta_uuid, sizeof(rsb->rsb_meta_uuid));
+}
+
+/*
+ * Update the realtime superblock from a filesystem superblock and log it to
+ * the given transaction.
+ */
+struct xfs_buf *
+xfs_log_rtsb(
+	struct xfs_trans	*tp,
+	const struct xfs_buf	*sb_bp)
+{
+	struct xfs_buf		*rtsb_bp;
+
+	if (!xfs_has_rtsb(tp->t_mountp))
+		return NULL;
+
+	rtsb_bp = xfs_trans_getrtsb(tp);
+	if (!rtsb_bp) {
+		/*
+		 * It's possible for the rtgroups feature to be enabled but
+		 * there is no incore rt superblock buffer if the rt geometry
+		 * was specified at mkfs time but the rt section has not yet
+		 * been attached.  In this case, rblocks must be zero.
+		 */
+		ASSERT(tp->t_mountp->m_sb.sb_rblocks == 0);
+		return NULL;
+	}
+
+	xfs_update_rtsb(rtsb_bp, sb_bp);
+	xfs_trans_ordered_buf(tp, rtsb_bp);
+	return rtsb_bp;
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index c89f8fdfb44317..f277da148722b4 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -243,6 +243,11 @@ static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
 {
 	return kasprintf(GFP_KERNEL, "%u.%s", rgno, xfs_rtginode_name(type));
 }
+
+void xfs_update_rtsb(struct xfs_buf *rtsb_bp,
+		const struct xfs_buf *sb_bp);
+struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
+		const struct xfs_buf *sb_bp);
 #else
 static inline void xfs_free_rtgroups(struct xfs_mount *mp,
 		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
@@ -260,6 +265,8 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_lock(rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
+# define xfs_update_rtsb(bp, sb_bp)	((void)0)
+# define xfs_log_rtsb(tp, sb_bp)	(NULL)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 697e6ec5b6ddb9..2b0284d78028fa 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -27,6 +27,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_exchrange.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1273,10 +1274,12 @@ xfs_update_secondary_sbs(
  */
 int
 xfs_sync_sb_buf(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	bool			update_rtsb)
 {
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
@@ -1286,6 +1289,11 @@ xfs_sync_sb_buf(
 	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
+	if (update_rtsb) {
+		rtsb_bp = xfs_log_rtsb(tp, bp);
+		if (rtsb_bp)
+			xfs_trans_bhold(tp, rtsb_bp);
+	}
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -1294,7 +1302,11 @@ xfs_sync_sb_buf(
 	 * write out the sb buffer to get the changes to disk
 	 */
 	error = xfs_bwrite(bp);
+	if (!error && rtsb_bp)
+		error = xfs_bwrite(rtsb_bp);
 out:
+	if (rtsb_bp)
+		xfs_buf_relse(rtsb_bp);
 	xfs_buf_relse(bp);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 885c837559914d..999dcfccdaf960 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -15,7 +15,7 @@ struct xfs_perag;
 
 extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
-extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
+extern int	xfs_sync_sb_buf(struct xfs_mount *mp, bool update_rtsb);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
 			struct xfs_sb *sbp);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 09e893cf563cb9..51cb239d7924c7 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -22,6 +22,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
+#include "xfs_rtgroup.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -995,6 +996,23 @@ xlog_recover_buf_commit_pass2(
 		ASSERT(bp->b_mount == mp);
 		bp->b_flags |= _XBF_LOGRECOVERY;
 		xfs_buf_delwri_queue(bp, buffer_list);
+
+		/*
+		 * Update the rt super if we just recovered the primary fs
+		 * super.
+		 */
+		if (xfs_has_rtsb(mp) && bp->b_ops == &xfs_sb_buf_ops) {
+			struct xfs_buf	*rtsb_bp = mp->m_rtsb_bp;
+
+			if (rtsb_bp) {
+				xfs_buf_lock(rtsb_bp);
+				xfs_buf_hold(rtsb_bp);
+				xfs_update_rtsb(rtsb_bp, bp);
+				rtsb_bp->b_flags |= _XBF_LOGRECOVERY;
+				xfs_buf_delwri_queue(rtsb_bp, buffer_list);
+				xfs_buf_relse(rtsb_bp);
+			}
+		}
 	}
 
 out_release:
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ce4851e2800a3f..4d5df6593af5fd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1028,7 +1028,7 @@ xfs_ioc_setlabel(
 	 * buffered reads from userspace (i.e. from blkid) are invalidated,
 	 * and userspace will see the newly-written label.
 	 */
-	error = xfs_sync_sb_buf(mp);
+	error = xfs_sync_sb_buf(mp, true);
 	if (error)
 		goto out;
 	/*
@@ -1039,6 +1039,8 @@ xfs_ioc_setlabel(
 	mutex_unlock(&mp->m_growlock);
 
 	invalidate_bdev(mp->m_ddev_targp->bt_bdev);
+	if (xfs_has_rtsb(mp) && mp->m_rtdev_targp)
+		invalidate_bdev(mp->m_rtdev_targp->bt_bdev);
 
 out:
 	mnt_drop_write_file(filp);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index cee7f0564409bd..118d31e11127be 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -25,6 +25,7 @@
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f06cc0f41665ad..f97e5c416efad1 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -214,6 +214,7 @@ xfs_trans_read_buf(
 }
 
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
+struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index e28ab74af4f0e1..8e886ecfd69a3b 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -168,12 +168,11 @@ xfs_trans_get_buf_map(
 /*
  * Get and lock the superblock buffer for the given transaction.
  */
-struct xfs_buf *
-xfs_trans_getsb(
-	struct xfs_trans	*tp)
+static struct xfs_buf *
+__xfs_trans_getsb(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*bp = tp->t_mountp->m_sb_bp;
-
 	/*
 	 * Just increment the lock recursion count if the buffer is already
 	 * attached to this transaction.
@@ -197,6 +196,22 @@ xfs_trans_getsb(
 	return bp;
 }
 
+struct xfs_buf *
+xfs_trans_getsb(
+	struct xfs_trans	*tp)
+{
+	return __xfs_trans_getsb(tp, tp->t_mountp->m_sb_bp);
+}
+
+struct xfs_buf *
+xfs_trans_getrtsb(
+	struct xfs_trans	*tp)
+{
+	if (!tp->t_mountp->m_rtsb_bp)
+		return NULL;
+	return __xfs_trans_getsb(tp, tp->t_mountp->m_rtsb_bp);
+}
+
 /*
  * Get and lock the buffer for the caller if it is not already
  * locked within the given transaction.  If it has not yet been

