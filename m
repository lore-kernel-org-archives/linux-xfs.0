Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75822BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928183; cv=none; b=JYZRg44Ku54gLJ1hw9bIkIvB1yvOq5eeifQYYINqpf/2aeCGMrplkFT32qgom1iNZrsOrbbdztk/QXhOgEAHQMJARNWLnZ+GXmgKDglZoHN2dGK7+dyGMf/GYuTvNsgOCHOO/TPDC7DzxxbS4FDlKKmZaFIgi3z4Saes1le/ADY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928183; c=relaxed/simple;
	bh=yCSw1XKoz4YampMrk/L/blUWodrLnoK+22p9hXpSIjw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gB5C5o5kT3YVs9AjgUSnoUSi0uumljHgzDVv12gVebwB8CH+QXFjDC1tWw/ChpHQUKuS19vXuqagfVbDjk8jUxFFXiKQwt9qr2t5Gq9QFu6xQ7y3DWJbCNfkjIK50rgRARNOl+bCfb8BkSI065uTF0nBACdZSBxidZPzkpyrufI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAJe7wbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAJe7wbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA7CC116B1;
	Wed, 24 Apr 2024 03:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928183;
	bh=yCSw1XKoz4YampMrk/L/blUWodrLnoK+22p9hXpSIjw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TAJe7wbxMgtTv7RwMZs2j3stWOjYE0XQ1LghOkmcuNpqmQ8iw7q6YbWiTBmU41VX0
	 zAebkdUBnmCOz9ONu6Xm2d2xbodSSIGBZ6+jm0VcI/uJWsyEHi+Mcy00Agw/hCSzbd
	 ihXhmFbl5i4YeEWPGztwCfJJ+aA2WOxo3hnA2EONUyl6XE5O95KBmVmNerb3x51e/k
	 TFFuOyCukSK9XaAQ9+xysWVHKPCDslEnurGHaE6xv8Ca62tu/vMp0RNmsANVcmhUAi
	 NAFoVob7Cpx85j+VBQ1arEntFMwq2GT7kJyDhUJI5l0yjne0TXYK4PhWdDj6FhZdM7
	 f9LwcobR0t0tA==
Date: Tue, 23 Apr 2024 20:09:42 -0700
Subject: [PATCH 03/14] xfs: use an XFS_OPSTATE_ flag for detecting if logged
 xattrs are available
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782623.1904599.14923341489093242321.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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
index dfe7039dac98..e5e7ddbc594b 100644
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
index b2e5653b5200..09eef1721ef4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -231,6 +231,13 @@ xfs_readsb(
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
 
@@ -829,6 +836,15 @@ xfs_mountfs(
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
index ca6f105990a2..d0567dfbc036 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -444,6 +444,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_QUOTACHECK_RUNNING	10
 /* Do we want to clear log incompat flags? */
 #define XFS_OPSTATE_UNSET_LOG_INCOMPAT	11
+/* Filesystem can use logged extended attributes */
+#define XFS_OPSTATE_USE_LARP		12
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -472,6 +474,7 @@ __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
 # define xfs_is_quotacheck_running(mp)	(false)
 #endif
 __XFS_IS_OPSTATE(done_with_log_incompat, UNSET_LOG_INCOMPAT)
+__XFS_IS_OPSTATE(using_logged_xattrs, USE_LARP)
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
@@ -491,7 +494,8 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
 	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }, \
-	{ (1UL << XFS_OPSTATE_UNSET_LOG_INCOMPAT),	"unset_log_incompat" }
+	{ (1UL << XFS_OPSTATE_UNSET_LOG_INCOMPAT),	"unset_log_incompat" }, \
+	{ (1UL << XFS_OPSTATE_USE_LARP),		"logged_xattrs" }
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0cbb93cf2869..ba56a9e73144 100644
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

