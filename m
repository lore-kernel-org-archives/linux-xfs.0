Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF158230
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798433; cv=none; b=bFB/Xr+fGuNfj5qaZeyVJJsEuV2G+QgbyOfH4Tdyp/IKlOwItG50+auS/br0NDpqMsv949WJWu5NpAuDukB+gvJAlRCGKW1yuVdzZ7sslyw44xpcg/5NLL3wc85ZlmRq3Uwg8pmH2waM4EJEYDjv8dfXQh7EKQo5IfX8cLeBRzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798433; c=relaxed/simple;
	bh=HtGsHvHODlyxlH0A1H40rr5QrQF1Jgx/pgziKVAMxFw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QtchS5OV8Zg1dXIko9zIcAPqMKbcxwnHDQzBjKNY8d49xnRZyXFq0gSPpTtnKcWv0tfbkGr5/hUXxUuH5kFMAB9M6hOXaxnK1KYfgKh7PDp2wZ2ypyrCs8mmCdkR7SPVJZ4/1ik0tGbR1KPnVUUdaSgutup2LF/FWY4hzit3Xpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhS1sPcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhS1sPcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEB2C433C7;
	Mon, 18 Mar 2024 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798433;
	bh=HtGsHvHODlyxlH0A1H40rr5QrQF1Jgx/pgziKVAMxFw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QhS1sPcGgmikW7FLcIYSmEFKezTsFuTKSaDB0KOG8ik3fyv7WEp/4YOaviumzkZmi
	 gI+HbUOmme6i9BPbn5cfTCF6Hu2HsJXJyfFBX31FL5vD1aErG1ZENrt6FMHZluUe0Z
	 27MkUFnqu4c82tIUViNN7J8LTKXclFchbMuaHJz7mIRCcG/CFGupysJErzbH3HfdeY
	 y6COHZdFO0xej7kDm+nfqLLKg7eHBwljLogSGlOmOQSbWCz+a86oUHr7gC9pCb4ygG
	 1omRJfTfos+Kco8Ux7yPZRRaiIsC+8keCTS7giPoG73VJ7mWc9X/J8N697kDsNv0Rt
	 Oi8dFffonxsUA==
Date: Mon, 18 Mar 2024 14:47:12 -0700
Subject: [PATCH 20/23] xfs: only clear some log incompat bits at unmount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802200.3806377.14890726292816496590.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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

Create a mask for log incompat feature bits that we don't want to clear
at unmount time.  This will be used in the next patch to make the
LOG_XATTRS feature bit sticky when parent pointers are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     |    5 +++--
 fs/xfs/scrub/agheader.c        |    7 ++++++-
 fs/xfs/scrub/agheader_repair.c |    4 +++-
 fs/xfs/xfs_mount.c             |   10 +++++-----
 fs/xfs/xfs_mount.h             |    3 +++
 5 files changed, 20 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 859062ab6c306..b695403f98632 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -417,9 +417,10 @@ xfs_sb_has_incompat_log_feature(
 
 static inline void
 xfs_sb_remove_incompat_log_features(
-	struct xfs_sb	*sbp)
+	struct xfs_sb	*sbp,
+	unsigned int	features)
 {
-	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+	sbp->sb_features_log_incompat &= ~features;
 }
 
 static inline void
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 1528f14bd9251..6c2581faa73d5 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -329,8 +329,13 @@ xchk_superblock(
 		 * log incompat features protect newer log record types from
 		 * older log recovery code.  Log recovery doesn't check the
 		 * secondary supers, so we can clear these if needed.
+		 *
+		 * Note that mkfs sets the "permanent" bits in the secondary
+		 * supers, so we don't flag the field if those are the only
+		 * bits set.
 		 */
-		if (sb->sb_features_log_incompat)
+		if (sb->sb_features_log_incompat !=
+				cpu_to_be32(mp->m_perm_log_incompat))
 			xchk_block_set_preen(sc, bp);
 
 		/* Don't care about sb_crc */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 0dbc484b182f9..7c55338b0cdd7 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -66,13 +66,15 @@ xrep_superblock(
 	/*
 	 * Don't write out a secondary super with NEEDSREPAIR or log incompat
 	 * features set, since both are ignored when set on a secondary.
+	 * Always set the permanent log incompat features, just like mkfs.
 	 */
 	if (xfs_has_crc(mp)) {
 		struct xfs_dsb		*sb = bp->b_addr;
 
 		sb->sb_features_incompat &=
 				~cpu_to_be32(XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
-		sb->sb_features_log_incompat = 0;
+		sb->sb_features_log_incompat =
+				cpu_to_be32(mp->m_perm_log_incompat);
 	}
 
 	/* Write this to disk. */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6fd4ceeab0e26..49d6c6de7b33b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1388,11 +1388,12 @@ bool
 xfs_clear_incompat_log_features(
 	struct xfs_mount	*mp)
 {
+	unsigned int		to_clear = XFS_SB_FEAT_INCOMPAT_LOG_ALL &
+						~mp->m_perm_log_incompat;
 	bool			ret = false;
 
 	if (!xfs_has_crc(mp) ||
-	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
-				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
+	    !xfs_sb_has_incompat_log_feature(&mp->m_sb, to_clear) ||
 	    xfs_is_shutdown(mp) ||
 	    !xfs_is_done_with_log_incompat(mp))
 		return false;
@@ -1405,9 +1406,8 @@ xfs_clear_incompat_log_features(
 	xfs_buf_lock(mp->m_sb_bp);
 	xfs_buf_hold(mp->m_sb_bp);
 
-	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
-				XFS_SB_FEAT_INCOMPAT_LOG_ALL)) {
-		xfs_sb_remove_incompat_log_features(&mp->m_sb);
+	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, to_clear)) {
+		xfs_sb_remove_incompat_log_features(&mp->m_sb, to_clear);
 		ret = true;
 	}
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a567a1ac24134..0d9f66ac50af2 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -163,6 +163,9 @@ typedef struct xfs_mount {
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	bool			m_update_sb;	/* sb needs update in mount */
 
+	/* never clear these log incompat feature bits */
+	unsigned int		m_perm_log_incompat;
+
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
 	 * Callers must hold m_sb_lock to access these two fields.

