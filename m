Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBBA198A24
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548155; cv=none; b=O9crzvyzEkAr/p/ADcs3rT8Tep2U44JtiUHvGD75DFVXxLDoY1bSgTF/L8tvIc+NaSTc74L5eRoCaPTWGh3V+uffDX6X5pkFoATgR5xEpkCZKpPTHgs9TuCeUDjqz5ALdtEMYbOhpMHo2oCgSVMn3YY2G215tgov+BcMTr8rrpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548155; c=relaxed/simple;
	bh=Rvd9PTX3D8ti/tL+t2nPfT1geOYz0RJd4cjK1H5gnsc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUDkq1FHFwUXPrsqUm9gW4zGFJudx/7OTffCNt989bDBI57HTgVZpYKIIZnx/lm0P2Q6X+0odyp6kcWmigN5qcOrJATi65UFnLY6MH7vlNxzg3T7wbEiT8cNFYmpctnWuGyoUE+D35VrvyowXibLZE3u3dkry+teoSPMRjLQLCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tDqcgWFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tDqcgWFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E0FC4CEC3;
	Mon, 21 Oct 2024 22:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548155;
	bh=Rvd9PTX3D8ti/tL+t2nPfT1geOYz0RJd4cjK1H5gnsc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tDqcgWFi6sgP2eYUfdv9Kx0ra4rf3R46BKEF4srX+ZBoNWEP4aTmVGzsNr6ELZEpJ
	 C9Or4RG7eukFON7NlvyfTrTgPh7fexUe5DLqbszNab7MLKrisC2g0g0/sOwMQtp3UW
	 l5Sem7rEguNDrOgZUUDNOxw24hzrDZKZ/A81xwnxYI5qlEe4u4zjmk1gVnB+K9Six4
	 +ZXavfOUuMStbA8EY8XBUHp2tBjS0vMxf0noaVl5fOqRTBSs8OKlsmJT6mqZyEsVCe
	 gYMCvMkGR3rV/qsWfXrmEGqLZlzOdPPJBV2qlAJdEmiE9taz8ajj7wUoseOS3OHuDS
	 ggyiA8BzZEIKQ==
Date: Mon, 21 Oct 2024 15:02:34 -0700
Subject: [PATCH 14/37] xfs: ensure rtx mask/shift are correct after growfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783683.34558.7324732496611226094.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
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

