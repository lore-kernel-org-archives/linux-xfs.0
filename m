Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E30CEDC
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371955; cv=none; b=czYQMl/kM91xztzz0glTfrr/RNr++Jamn3CfZJ7zQgW61e5ATIrSm904gCoKo8+a5XYCYLEY6T7wnbx7A3e+VsRUujjvsE2bokFEj8k0mRVlhKSKtLfJ9wGjQMuwfM2G3CsSRRflDqUMhg9t2R9SaevLlGIbfMkwacpWluFBy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371955; c=relaxed/simple;
	bh=OTu7e1RisXV9SsGI1PK+TGEc4eUH7EBDfdPYGHrF8sQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GBQML8Gj1TWJ+mnMe61K9+MquxyzLRscL+RUF2g4UQuVDJ8LnDtrSb1MqLTRlBLRbK/NypGojIakYHhru5fCONQ+bYwbmJBQDMov0ow9FapwpErUWKBLLfDHYhKEH57JjL+XpumloyVFjqgwNAs+QgTgv8CqnaNTru3Y078CKZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnjZlXU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnjZlXU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B0EC32782;
	Fri, 23 Aug 2024 00:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371955;
	bh=OTu7e1RisXV9SsGI1PK+TGEc4eUH7EBDfdPYGHrF8sQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RnjZlXU54hNbo8ZR7XN2go/kA6OuDPksoxg4j8V+ktUG5Cb2tBr93WGRLZTSF8CVu
	 E4iPdo6UAL4NIxAeTPysEl9+ZI5qbjUaZZHkdcjTO37j8JnSLjhRU+tJ0WzWnZY4Ps
	 XM7/m+Sh8p7tx3Fq/XLq3MFYJ9vKtmFhcOtkJd5SruZ+OzTUFA2SfuRUqKJ4qiztkh
	 EkycwUhoMlTlH47TB2358qi9VBwZozxGCGXm78tV7Q4DLKCLWU7TB1tHNCn9BFO+As
	 DMU3ISEjMbFXd3x6jgf3aICR5EWXPKnXxTDoWbDphkrtZuubj3NXjMkO5D+LdLudGe
	 Cu6Gl6J5VUM4A==
Date: Thu, 22 Aug 2024 17:12:34 -0700
Subject: [PATCH 02/10] xfs: ensure rtx mask/shift are correct after growfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086651.59070.1117758034575341097.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

When growfs sets an extent size, it doesn't updated the m_rtxblklog and
m_rtxblkmask values, which could lead to incorrect usage of them if they
were set before and can't be used for the new extent size.

Add a xfs_mount_sb_set_rextsize helper that updates the two fields, and
also use it when calculating the new RT geometry instead of disabling
the optimization there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |   12 ++++++++++--
 fs/xfs/libxfs/xfs_sb.h |    2 ++
 fs/xfs/xfs_rtalloc.c   |    5 +++--
 3 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a4221afb012b6..b83ce29640511 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -975,6 +975,15 @@ const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
 	.verify_write = xfs_sb_write_verify,
 };
 
+void
+xfs_mount_sb_set_rextsize(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
+	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+}
+
 /*
  * xfs_mount_common
  *
@@ -999,8 +1008,7 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
-	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
-	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+	xfs_mount_sb_set_rextsize(mp, sbp);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 796f02191dfd2..885c837559914 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -17,6 +17,8 @@ extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
+void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
+			struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1f31b08c95a06..ffa417a3e8a76 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -721,8 +721,8 @@ xfs_growfs_rt_bmblock(
 	/*
 	 * Calculate new sb and mount fields for this round.
 	 */
-	nmp->m_rtxblklog = -1; /* don't use shift or masking */
 	nmp->m_sb.sb_rextsize = rextsize;
+	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
 	nmp->m_sb.sb_rbmblocks = bmbno + 1;
 	nmp->m_sb.sb_rblocks = min(nrblocks, nrblocks_step);
 	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
@@ -809,10 +809,11 @@ xfs_growfs_rt_bmblock(
 	xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
 
 	/*
-	 * Update mp values into the real mp structure.
+	 * Update the calculated values in the real mount structure.
 	 */
 	mp->m_rsumlevels = nmp->m_rsumlevels;
 	mp->m_rsumsize = nmp->m_rsumsize;
+	xfs_mount_sb_set_rextsize(mp, &mp->m_sb);
 
 	/*
 	 * Recompute the growfsrt reservation from the new rsumsize.

