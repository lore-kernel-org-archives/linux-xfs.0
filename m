Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfGLRDy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 13:03:54 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 082BA81E07
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:03:54 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D564560635
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:03:53 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove flags argument from xfs_getsb
Message-ID: <6a2da6f7-8c5c-7e10-3a5c-01e175f3382d@redhat.com>
Date: Fri, 12 Jul 2019 12:03:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The flags argument is only checked for XBF_TRYLOCK, and no callers have
used this flag for nearly 10 years.

Removing it means that xfs_getsb won't fail, which means that the error
handling by (some) callers can be removed, and the lack of error handling
by other callers no longer matters.  (To be fair, calling with flags == 0
couldn't fail, anyway, but there were still inconsistencies which just go
away now.)

Signed-off-by; Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 77a3a4085de3..240607df354a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -938,7 +938,7 @@ xfs_log_sb(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
+	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
 
 	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
 	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
@@ -1068,7 +1068,7 @@ xfs_sync_sb_buf(
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp, mp, 0);
+	bp = xfs_trans_getsb(tp, mp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
 	xfs_trans_set_sync(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3371d1ff27c4..356a80a22b87 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5693,7 +5693,7 @@ xlog_do_recover(
 	 * Now that we've finished replaying all buffer and inode
 	 * updates, re-read in the superblock and reverify it.
 	 */
-	bp = xfs_getsb(mp, 0);
+	bp = xfs_getsb(mp);
 	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
 	ASSERT(!(bp->b_flags & XBF_WRITE));
 	bp->b_flags |= XBF_READ;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fd63b0b1307c..db5211f0df00 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1381,24 +1381,14 @@ xfs_mod_frextents(
  * xfs_getsb() is called to obtain the buffer for the superblock.
  * The buffer is returned locked and read in from disk.
  * The buffer should be released with a call to xfs_brelse().
- *
- * If the flags parameter is BUF_TRYLOCK, then we'll only return
- * the superblock buffer if it can be locked without sleeping.
- * If it can't then we'll return NULL.
  */
 struct xfs_buf *
 xfs_getsb(
-	struct xfs_mount	*mp,
-	int			flags)
+	struct xfs_mount	*mp)
 {
 	struct xfs_buf		*bp = mp->m_sb_bp;
 
-	if (!xfs_buf_trylock(bp)) {
-		if (flags & XBF_TRYLOCK)
-			return NULL;
-		xfs_buf_lock(bp);
-	}
-
+	xfs_buf_lock(bp);
 	xfs_buf_hold(bp);
 	ASSERT(bp->b_flags & XBF_DONE);
 	return bp;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 110f927cf943..f847bdbb01f5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -438,7 +438,7 @@ extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
 
-extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
+extern struct xfs_buf *xfs_getsb(xfs_mount_t *);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern bool	xfs_fs_writable(struct xfs_mount *mp, int level);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 912b42f5fe4a..0746b329a937 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -452,7 +452,7 @@ xfs_trans_apply_sb_deltas(
 	xfs_buf_t	*bp;
 	int		whole = 0;
 
-	bp = xfs_trans_getsb(tp, tp->t_mountp, 0);
+	bp = xfs_trans_getsb(tp, tp->t_mountp);
 	sbp = XFS_BUF_TO_SBP(bp);
 
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index c6e1c5704a8c..fd35da161a2b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -203,7 +203,7 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
-struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
+struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 7d65ebf1e847..9866f2598e21 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -174,8 +174,7 @@ xfs_trans_get_buf_map(
 xfs_buf_t *
 xfs_trans_getsb(
 	xfs_trans_t		*tp,
-	struct xfs_mount	*mp,
-	int			flags)
+	struct xfs_mount	*mp)
 {
 	xfs_buf_t		*bp;
 	struct xfs_buf_log_item	*bip;
@@ -185,7 +184,7 @@ xfs_trans_getsb(
 	 * if tp is NULL.
 	 */
 	if (tp == NULL)
-		return xfs_getsb(mp, flags);
+		return xfs_getsb(mp);
 
 	/*
 	 * If the superblock buffer already has this transaction
@@ -203,10 +202,7 @@ xfs_trans_getsb(
 		return bp;
 	}
 
-	bp = xfs_getsb(mp, flags);
-	if (bp == NULL)
-		return NULL;
-
+	bp = xfs_getsb(mp);
 	_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_getsb(bp->b_log_item);
 	return bp;
