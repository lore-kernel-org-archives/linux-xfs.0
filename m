Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7D6BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGe3VyOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C51C433C7;
	Sun, 31 Dec 2023 20:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055522;
	bh=wRRIft9h1EUqRVLNDbstoIORYWUMzsvI70gptkrCf9M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QGe3VyOXyLXYhNXcK/YgHebx4Vr2Gmcu/vT5AWXz00W/NWvpNIbUu6XG1F//5Tgjc
	 pIMQiYhvl9mW/HCFDVhArLh9zzVmtQDYJUhg+E3Vmsw605F28hquYccxPT/l+/1ONS
	 lNkiu54pfJ2MBDZc7UNjCl0YDzcQ1VxHGC2pUaN+Dnm7DECAAs6qiM0XhoVRAQAMcL
	 /KLU1XifHGr7lrp1E+Ydqz1ASh5kcIRAWwkpsTc59BNQOlWo8RcMIWYeF1I9lhNMoZ
	 rhY4vDX5RWAwoCXt/fYTeD2v+FcOdJG1JYQKULcLG6kVmZX8HD7OSCAdUK8RkSrZMQ
	 /jZIXGowvtMAA==
Date: Sun, 31 Dec 2023 12:45:21 -0800
Subject: [PATCH 02/14] xfs: allow newer INCOMPAT/RO_COMPAT feature bits to
 protect ATTRI log items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840436.1756514.8950160514368962094.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
References: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
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

Log recovery (which can include replaying ATTRI intent items) occurs on
rw and ro mounts.  Dirty logs containing these log items must be
protected from being replayed by older kernels.  The log incompat
feature XFS_SB_FEAT_INCOMPAT_LOG_XATTRS provides this protection.

However, adding this flag to the filesystem introduces performance
problems of its own -- each time we do, we must force the log and write
the primary superblock before writing any ATTRI log items.  This was ok
when the only users were developers using the debug knob, but this sucks
for regular users.  We'd like to avoid that.

If a filesystem has ro-compat or incompat feature bits set that weren't
defined at the time that ATTRI log items were defined, then any kernel
that doesn't know about ATTRI items will reject that filesystem.  This
provides the same protection as the log-incompat feature, but at a much
lower cost because most ro-compat and incompat features are set on a
permanent basis.

Avoid the performance hit by detecting these feature bits and skipping
the xfs_add_incompat_log_feature calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c   |    6 +++++-
 fs/xfs/libxfs/xfs_attr.h   |   23 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_format.h |    6 +++++-
 fs/xfs/xfs_attr_item.c     |    3 ++-
 fs/xfs/xfs_xattr.c         |   10 +++++++++-
 5 files changed, 44 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b002ddd5f05a2..2e5550ab1454f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -885,9 +885,13 @@ xfs_attr_defer_add(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags)
 {
-
 	struct xfs_attr_intent	*new;
 
+	/* ATTRI log items must be protected from older kernels */
+	if (args->op_flags & XFS_DA_OP_LOGGED)
+		ASSERT(xfs_attri_can_use_without_log_assistance(args->dp->i_mount) ||
+		       xfs_sb_version_haslogxattrs(&args->dp->i_mount->m_sb));
+
 	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e4f55008552b4..273e8dff76c07 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -620,4 +620,27 @@ void xfs_attr_intent_destroy_cache(void);
 
 int xfs_attr_sf_totsize(struct xfs_inode *dp);
 
+/*
+ * Decide if this filesystem has a new enough permanent feature set to protect
+ * attri log items from being replayed on a kernel that does not have
+ * XFS_SB_FEAT_INCOMPAT_LOG_XATTRS set.
+ */
+static inline bool
+xfs_attri_can_use_without_log_assistance(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				  XFS_SB_FEAT_INCOMPAT_SPINODES |
+				  XFS_SB_FEAT_INCOMPAT_META_UUID |
+				  XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				  XFS_SB_FEAT_INCOMPAT_NREXT64)))
+		return true;
+
+	return false;
+}
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ec25010b57797..8b952909ce1e2 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -390,7 +390,11 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+/*
+ * Log contains ATTRI log intent items which are not otherwise protected by
+ * an INCOMPAT/RO_COMPAT feature flag.
+ */
+#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)
 
 /*
  * Log contains SXI log intent items which are not otherwise protected by
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c023962141556..c95cef827179c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -469,7 +469,8 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb) &&
+	    !xfs_attri_can_use_without_log_assistance(mp))
 		return false;
 
 	if (attrp->__pad != 0)
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 1920ca49b08d6..5246539ad2174 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -33,6 +33,13 @@ xfs_attr_grab_log_assist(
 {
 	int			error = 0;
 
+	/*
+	 * As a performance optimization, skip the log force and super write
+	 * if the filesystem featureset already protects the attri log items.
+	 */
+	if (xfs_attri_can_use_without_log_assistance(mp))
+		return 0;
+
 	/*
 	 * Protect ourselves from an idle log clearing the logged xattrs log
 	 * incompat feature bit.
@@ -76,7 +83,8 @@ static inline void
 xfs_attr_rele_log_assist(
 	struct xfs_mount	*mp)
 {
-	xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
+	if (!xfs_attri_can_use_without_log_assistance(mp))
+		xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
 }
 
 static inline bool

