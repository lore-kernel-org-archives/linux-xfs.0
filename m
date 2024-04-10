Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975AB38B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710270; cv=none; b=dZNB+bnHANnfamcIKa4aKdg7UUnHbckH0zyKF58nXGr/SIvkPJZ+VTxwCWEedk1zEolZ50zny4Z81a+bOQ33+Nvu0zN2or4Opr+UfHBjrqgekvsTsYWfVHI29/EJeQBJur4SASM89xcNDPFceU7Wi1XNbQfDC1aQ4ELGpLBr5fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710270; c=relaxed/simple;
	bh=7nDLppW8YbbjLuXGDuF5Bkv4qHHrBe6FnOo3Beb2YN4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XkR54wvaoX45CMUZulRfnLWKABzVDYR1Ea+2F8w5sOBpnwJEkmdnnHhZzA5EIz6kJuOFy2GbT1WD9Fv7mMVDndXuw3xMXV0cjyz/H0FUbx7B8OxOVzp33xMjLXs85YoAzyDTDHKfqR+/D0K/uoHpFJSK3ANapbInSAm43fTiPN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YN4q+T6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YN4q+T6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF9BC433C7;
	Wed, 10 Apr 2024 00:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710270;
	bh=7nDLppW8YbbjLuXGDuF5Bkv4qHHrBe6FnOo3Beb2YN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YN4q+T6ShVV9mEyyT/lj9twHFJW7RSElyfnWQitptFbUkJcrMKCPGrYqZl3Fpl/+y
	 0tmk4I3i+rZMf46jJFHfQ9gT7jHSIQF8LhUkoGcBMhDdouJYDGlT1Vxg9jTKP/BTgX
	 /vyoyIRZ8UoK3MH8sbhL43lgVAnsfLKOZ9TYw1h2ImQLeOjyDJ/QkrNue8DrhmS6a7
	 uiN3dzm5VHpccyBoV6Ws/G1iVUYE/bmN+8DsCr1sfZaOTS9q9Or4W2do05w8y0wSUE
	 8d1FqFQ22TS7IwpdeiNWySPdh4QyPU4+3IMjOtRlellsY0xMO89UqxF8WsdrOVSV1N
	 kbB04/odCSVGg==
Date: Tue, 09 Apr 2024 17:51:09 -0700
Subject: [PATCH 03/12] xfs: use an XFS_OPSTATE_ flag for detecting if logged
 xattrs are available
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968902.3631545.15407860268151301275.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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
index 9b29973424b45..514179a8d2a7f 100644
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

