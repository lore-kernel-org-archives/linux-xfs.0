Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560555223
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230591; cv=none; b=E+t6svKnTWp6tlqBqMAsAIEOxMdOXCAzVj6ZbR+490jYZPMI880exOdisKqACYt+x3AYhb4jrLsg/NfF9iGTP95XoCmYPEWcdNZo4lPsE2qJgfT2Rg/EJL2rGuABDAf3fgAfMaClVtcjNz45NGSfkQdkBKOKWikeDaP6HxDLScg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230591; c=relaxed/simple;
	bh=oYb8qvVjosSlyHD5EJE3eTwZopaj7COFqJGXyhZVVkI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DxAc+Lb4dFb4J5pSwQ48Wx0gxMeNd2BTjtx4DoCwSW2LdFLyjhzVveVNIsqQZuff/ArepeOpZd9L+WkR4wpSqtkEInDAf1vLIjliwEYE3gShIzlEplElJ3kT1LsJQiSjuFN8IeWDkXfaSxVM9dXvnaxhpjpNLFO6Zyepscu7dOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVhVH+yL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVhVH+yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0850FC113CC;
	Tue, 16 Apr 2024 01:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230591;
	bh=oYb8qvVjosSlyHD5EJE3eTwZopaj7COFqJGXyhZVVkI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WVhVH+yLi3WWgEesFsPRzpJdskvqeNQAvtC3rZwHofrOrdH5hN4bm9epyW18w3hM/
	 bZj4d9vdgaRRGYjWBP1dxisrdCi4uWQlHLyqHNgzA7DoIVbD/4ZCilt/+mtVBqrd0o
	 sILRdSJ58nuPKRsQkIsx9EBzQj9IJ8ZiShsoMwLnFUcLhLQV0mHaPIM5OQcDnssS71
	 FZ2QQeRmZE891db9amwPL4Iyo8DozHX23EXPqcTLqjZ8t2V1TwJtnBOcNS4juObZyL
	 q9ThbSqVzLi0cMtnz5S/koCkZV4GoJXGDc4xDt46oHPUahal44Yioxqv2aUpOAX16t
	 O55awcJYk2H/w==
Date: Mon, 15 Apr 2024 18:23:10 -0700
Subject: [PATCH 03/14] xfs: use an XFS_OPSTATE_ flag for detecting if logged
 xattrs are available
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027122.251201.13145666207371828320.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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

Per reviewer request, use an OPSTATE flag (+ helpers) to decide if
logged xattrs are enabled, instead of querying the xfs_sb.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    2 +-
 fs/xfs/xfs_mount.c     |   16 ++++++++++++++++
 fs/xfs/xfs_mount.h     |    6 +++++-
 fs/xfs/xfs_xattr.c     |    3 ++-
 4 files changed, 24 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index dfe7039dac989..e5e7ddbc594b9 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -469,7 +469,7 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+	if (!xfs_is_using_logged_xattrs(mp))
 		return false;
 
 	if (attrp->__pad != 0)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d37ba10f5fa33..a8a4b338985af 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -230,6 +230,13 @@ xfs_readsb(
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
 
+	/*
+	 * If logged xattrs are enabled after log recovery finishes, then set
+	 * the opstate so that log recovery will work properly.
+	 */
+	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
+		xfs_set_using_logged_xattrs(mp);
+
 	/* no need to be quiet anymore, so reset the buf ops */
 	bp->b_ops = &xfs_sb_buf_ops;
 
@@ -828,6 +835,15 @@ xfs_mountfs(
 		goto out_inodegc_shrinker;
 	}
 
+	/*
+	 * If logged xattrs are still enabled after log recovery finishes, then
+	 * they'll be available until unmount.  Otherwise, turn them off.
+	 */
+	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
+		xfs_set_using_logged_xattrs(mp);
+	else
+		xfs_clear_using_logged_xattrs(mp);
+
 	/* Enable background inode inactivation workers. */
 	xfs_inodegc_start(mp);
 	xfs_blockgc_start(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b022e5120dc42..ffdf354b72437 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -416,6 +416,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_QUOTACHECK_RUNNING	10
 /* Do we want to clear log incompat flags? */
 #define XFS_OPSTATE_UNSET_LOG_INCOMPAT	11
+/* Filesystem can use logged extended attributes */
+#define XFS_OPSTATE_USE_LARP		12
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -444,6 +446,7 @@ __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
 # define xfs_is_quotacheck_running(mp)	(false)
 #endif
 __XFS_IS_OPSTATE(done_with_log_incompat, UNSET_LOG_INCOMPAT)
+__XFS_IS_OPSTATE(using_logged_xattrs, USE_LARP)
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
@@ -463,7 +466,8 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
 	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }, \
-	{ (1UL << XFS_OPSTATE_UNSET_LOG_INCOMPAT),	"unset_log_incompat" }
+	{ (1UL << XFS_OPSTATE_UNSET_LOG_INCOMPAT),	"unset_log_incompat" }, \
+	{ (1UL << XFS_OPSTATE_USE_LARP),		"logged_xattrs" }
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0cbb93cf2869c..ba56a9e73144b 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -31,7 +31,7 @@ xfs_attr_grab_log_assist(
 	int			error = 0;
 
 	/* xattr update log intent items are already enabled */
-	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
+	if (xfs_is_using_logged_xattrs(mp))
 		return 0;
 
 	/*
@@ -48,6 +48,7 @@ xfs_attr_grab_log_assist(
 			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
 	if (error)
 		return error;
+	xfs_set_using_logged_xattrs(mp);
 
 	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_LARP,
  "EXPERIMENTAL logged extended attributes feature in use. Use at your own risk!");

