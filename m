Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29200BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSnJpxlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCF1C433C8;
	Sun, 31 Dec 2023 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054380;
	bh=HieJ7xzZss8tSP5gHeNyQX2/y5IgzJPDlD82h+JEoUA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YSnJpxlKpCRx1B3h8w6lZQLO1/uS3D6qKzf3mmcaX/3y9UFwouqQ5JSNYNviXr7CX
	 T3w6X7f6ZmH7P1xmYxrvSZ555ARKL4yNy5kbsSgW5sogGlB9hQJGHXnyEulI+4S0b3
	 OKBx8R+OCB6SAhpEkO9f0eJMBYcWnovDbJMVFsaRqUgtXeIuN2nNR3DZgcwqeeCndW
	 vqhtiG9vbyWnOTtuz5FlMVPQxT3/dX2gfqq+nznncxX1qQ2iht+AGBzwcGVA3pLsrJ
	 JM7p8DKBZp6goVJP4ndAzZWYR7i7Ufbxr4ZOjdRok27AgktjTIbxn5cMxDtxxfvljx
	 nTa+7m4O4fIfg==
Date: Sun, 31 Dec 2023 12:26:19 -0800
Subject: [PATCH 08/25] xfs: parameterize all the incompat log feature helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833266.1750288.15729093869041824285.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

We're about to define a new XFS_SB_FEAT_INCOMPAT_LOG_ bit, which means
that callers will soon require the ability to toggle on and off
different log incompat feature bits.  Parameterize the
xlog_{use,drop}_incompat_feat and xfs_sb_remove_incompat_log_features
functions so that callers can specify which feature they're trying to
use and so that we can clear individual log incompat bits as needed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    5 +++--
 fs/xfs/xfs_log.c           |   34 +++++++++++++++++++++++++---------
 fs/xfs/xfs_log.h           |    9 ++++++---
 fs/xfs/xfs_log_priv.h      |    2 +-
 fs/xfs/xfs_log_recover.c   |    3 ++-
 fs/xfs/xfs_mount.c         |   11 +++++------
 fs/xfs/xfs_mount.h         |    2 +-
 fs/xfs/xfs_xattr.c         |    6 +++---
 8 files changed, 46 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e6ca188e22712..4baafff619789 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -404,9 +404,10 @@ xfs_sb_has_incompat_log_feature(
 
 static inline void
 xfs_sb_remove_incompat_log_features(
-	struct xfs_sb	*sbp)
+	struct xfs_sb	*sbp,
+	uint32_t	feature)
 {
-	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+	sbp->sb_features_log_incompat &= ~feature;
 }
 
 static inline void
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a9a8311e112c2..f62a6e233689c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1048,7 +1048,7 @@ xfs_log_quiesce(
 	 * failures, though it's not fatal to have a higher log feature
 	 * protection level than the log contents actually require.
 	 */
-	if (xfs_clear_incompat_log_features(mp)) {
+	if (xfs_clear_incompat_log_features(mp, XFS_SB_FEAT_INCOMPAT_LOG_ALL)) {
 		int error;
 
 		error = xfs_sync_sb(mp, false);
@@ -1455,6 +1455,7 @@ xlog_clear_incompat(
 	struct xlog		*log)
 {
 	struct xfs_mount	*mp = log->l_mp;
+	uint32_t		incompat_mask = 0;
 
 	if (!xfs_sb_has_incompat_log_feature(&mp->m_sb,
 				XFS_SB_FEAT_INCOMPAT_LOG_ALL))
@@ -1463,11 +1464,16 @@ xlog_clear_incompat(
 	if (log->l_covered_state != XLOG_STATE_COVER_DONE2)
 		return;
 
-	if (!down_write_trylock(&log->l_incompat_users))
+	if (down_write_trylock(&log->l_incompat_xattrs))
+		incompat_mask |= XFS_SB_FEAT_INCOMPAT_LOG_XATTRS;
+
+	if (!incompat_mask)
 		return;
 
-	xfs_clear_incompat_log_features(mp);
-	up_write(&log->l_incompat_users);
+	xfs_clear_incompat_log_features(mp, incompat_mask);
+
+	if (incompat_mask & XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
+		up_write(&log->l_incompat_xattrs);
 }
 
 /*
@@ -1585,7 +1591,7 @@ xlog_alloc_log(
 	}
 	log->l_sectBBsize = 1 << log2_size;
 
-	init_rwsem(&log->l_incompat_users);
+	init_rwsem(&log->l_incompat_xattrs);
 
 	xlog_get_iclog_buffer_size(mp, log);
 
@@ -3877,15 +3883,25 @@ xfs_log_check_lsn(
  */
 void
 xlog_use_incompat_feat(
-	struct xlog		*log)
+	struct xlog		*log,
+	enum xlog_incompat_feat	what)
 {
-	down_read(&log->l_incompat_users);
+	switch (what) {
+	case XLOG_INCOMPAT_FEAT_XATTRS:
+		down_read(&log->l_incompat_xattrs);
+		break;
+	}
 }
 
 /* Notify the log that we've finished using log incompat features. */
 void
 xlog_drop_incompat_feat(
-	struct xlog		*log)
+	struct xlog		*log,
+	enum xlog_incompat_feat	what)
 {
-	up_read(&log->l_incompat_users);
+	switch (what) {
+	case XLOG_INCOMPAT_FEAT_XATTRS:
+		up_read(&log->l_incompat_xattrs);
+		break;
+	}
 }
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 2728886c29639..d187f64459093 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -159,8 +159,11 @@ bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
 bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
 
-void xlog_use_incompat_feat(struct xlog *log);
-void xlog_drop_incompat_feat(struct xlog *log);
-int xfs_attr_use_log_assist(struct xfs_mount *mp);
+enum xlog_incompat_feat {
+	XLOG_INCOMPAT_FEAT_XATTRS = XFS_SB_FEAT_INCOMPAT_LOG_XATTRS,
+};
+
+void xlog_use_incompat_feat(struct xlog *log, enum xlog_incompat_feat what);
+void xlog_drop_incompat_feat(struct xlog *log, enum xlog_incompat_feat what);
 
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e30c06ec20e33..304aed840f962 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -452,7 +452,7 @@ struct xlog {
 	uint32_t		l_iclog_roundoff;/* padding roundoff */
 
 	/* Users of log incompat features should take a read lock. */
-	struct rw_semaphore	l_incompat_users;
+	struct rw_semaphore	l_incompat_xattrs;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 53ffbb9dfd974..6048f1b08acc0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3479,7 +3479,8 @@ xlog_recover_finish(
 	 * longer anything to protect.  We rely on the AIL push to write out the
 	 * updated superblock after everything else.
 	 */
-	if (xfs_clear_incompat_log_features(log->l_mp)) {
+	if (xfs_clear_incompat_log_features(log->l_mp,
+				XFS_SB_FEAT_INCOMPAT_LOG_ALL)) {
 		error = xfs_sync_sb(log->l_mp, false);
 		if (error < 0) {
 			xfs_alert(log->l_mp,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 469eeab347518..85c7ca0b211b1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1362,13 +1362,13 @@ xfs_add_incompat_log_feature(
  */
 bool
 xfs_clear_incompat_log_features(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	uint32_t		features)
 {
 	bool			ret = false;
 
 	if (!xfs_has_crc(mp) ||
-	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
-				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
+	    !xfs_sb_has_incompat_log_feature(&mp->m_sb, features) ||
 	    xfs_is_shutdown(mp))
 		return false;
 
@@ -1380,9 +1380,8 @@ xfs_clear_incompat_log_features(
 	xfs_buf_lock(mp->m_sb_bp);
 	xfs_buf_hold(mp->m_sb_bp);
 
-	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
-				XFS_SB_FEAT_INCOMPAT_LOG_ALL)) {
-		xfs_sb_remove_incompat_log_features(&mp->m_sb);
+	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, features)) {
+		xfs_sb_remove_incompat_log_features(&mp->m_sb, features);
 		ret = true;
 	}
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 772c913bcd2bd..257bef8019307 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -565,7 +565,7 @@ struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 void xfs_force_summary_recalc(struct xfs_mount *mp);
 int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
-bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
+bool xfs_clear_incompat_log_features(struct xfs_mount *mp, uint32_t feature);
 void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 364104e1b38ae..0e0e25e386f17 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -37,7 +37,7 @@ xfs_attr_grab_log_assist(
 	 * Protect ourselves from an idle log clearing the logged xattrs log
 	 * incompat feature bit.
 	 */
-	xlog_use_incompat_feat(mp->m_log);
+	xlog_use_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
 
 	/*
 	 * If log-assisted xattrs are already enabled, the caller can use the
@@ -68,7 +68,7 @@ xfs_attr_grab_log_assist(
 
 	return 0;
 drop_incompat:
-	xlog_drop_incompat_feat(mp->m_log);
+	xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
 	return error;
 }
 
@@ -76,7 +76,7 @@ static inline void
 xfs_attr_rele_log_assist(
 	struct xfs_mount	*mp)
 {
-	xlog_drop_incompat_feat(mp->m_log);
+	xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
 }
 
 static inline bool

