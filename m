Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEB3C8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5kDpw7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C93C433C7;
	Sun, 31 Dec 2023 23:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063750;
	bh=aIgL3BzYCG/GH14gpgYKAW0aK9T+sSEx8wi5QTLQOBw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m5kDpw7nlNi/oLsRfTIvXeWm2qVFkeCib1Psa1qMDYcsILkvB3F742DSKIo6tmgKL
	 PoMUS005hbgcv6ksl92HFNKbf3bnZTInGJOc6DWFc+9tS5zwa2mN7MkmUicZWikY6f
	 EjbHUzlDqSTmyVutfMExQ934XBGXaSwXeAKRpMw/2aen2eL1wMdgWTf+j4x/X6SMaS
	 UfsQAeQS5E/R3/8X3PUvC7BZNMYpOYzVjHiazpZ8dN9ypbQk8KY6uNQwwkAJIo1/aK
	 5QmZIHrM9N9Q2SoS33FkxBYxaam4HipmSZAiYwLZpp8TFzqfaxWBG5e5AG/2VKe13P
	 UyTaYzlHqdduw==
Date: Sun, 31 Dec 2023 15:02:30 -0800
Subject: [PATCH 01/11] xfs: allow newer INCOMPAT/RO_COMPAT feature bits to
 protect ATTRI log items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005610.1804370.15326025974579452778.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
References: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_attr.c   |    6 +++++-
 libxfs/xfs_attr.h   |   23 +++++++++++++++++++++++
 libxfs/xfs_format.h |    6 +++++-
 3 files changed, 33 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8f527ac9292..8958434247f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -883,9 +883,13 @@ xfs_attr_defer_add(
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
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index e4f55008552..273e8dff76c 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index ec25010b577..8b952909ce1 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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

