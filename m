Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9B31D0F7E
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416341; cv=none; b=HUKDval9JnW0EQ1NrE148U/rxM2VNvJhDhrcjIP1EGP9rlaUkN7xFrcuyB6ts8OcU5GAscgVrBokT9xKYBzRMtVgR+AphLhUsfRtmDZkoNwfbNh0yNZVJBI959lfgMUQqI5E5Pen+fyC2wQaFDK8NZ6jiPPEKGS60uYfy1Bv++w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416341; c=relaxed/simple;
	bh=Rvd9PTX3D8ti/tL+t2nPfT1geOYz0RJd4cjK1H5gnsc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAcDE0BFppkUdLPIa2PT8UahBafpaYZrViMSmu/vDxSgHWYODU2vOTp6jmaV9nE1fNHynW/Y3RC/ypVx52omhYrxM0m7OgZ5mAVWQnSj95whutZ/hi58d09dvxIVWOooXzLHuXIkXhcKnJWB4ekAI9yU+usa2wedxiN3TJD9wf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4blBJBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4blBJBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30525C4CEC3;
	Thu, 31 Oct 2024 23:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416341;
	bh=Rvd9PTX3D8ti/tL+t2nPfT1geOYz0RJd4cjK1H5gnsc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l4blBJBsxyXnFhoMfEiV+dCQD3M8bUH0Db+198unTG4+Z4VVgzMcZpnfcdY9BBEvW
	 Xmwq+aCPIKGoELY0Cg/k3ggCJg8MwairrJrJRS7XT6hzO5htscNQW5SwJBQUKUSDO7
	 C5PG/EWu+mUwnH5qChKRjBTOqG7eYWPZUny6noEBsLaD3Cl7flThuNMumJc+HDA/Zt
	 STW0U6DlkAiCtjYdoJ6vGgWw1SFUP3onPQyfRZQ5sgQAUGQlT9cwvqLB/+mEI1+Ram
	 V/0gMJB34A+iL1EpbE3UiJGO+E6MTvI56BGinBz4ikK+qgqzbEwcXJfw7atCcwKhbP
	 ZjfQSGZFfr81g==
Date: Thu, 31 Oct 2024 16:12:20 -0700
Subject: [PATCH 14/41] xfs: ensure rtx mask/shift are correct after growfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566133.962545.4618811593843103724.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 86a0264ef26e90214a5bd74c72fb6e3455403bcf

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
 libxfs/xfs_sb.c |   12 ++++++++++--
 libxfs/xfs_sb.h |    2 ++
 2 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index c3185a4daeb4aa..5f7ff4fa4e49b1 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -962,6 +962,15 @@ const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
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
@@ -986,8 +995,7 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
-	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
-	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+	xfs_mount_sb_set_rextsize(mp, sbp);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 796f02191dfd2e..885c837559914d 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -17,6 +17,8 @@ extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
+void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
+			struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);

