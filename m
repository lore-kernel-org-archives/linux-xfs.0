Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060CA219CBE
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191544; cv=none; b=QmS1P1mAe3QP48g0rIlSVJ5yoii4MjLSGXao7ikMvzo3G0dUQXZBjJppx3joHbxIZCqQUTifXxt74eZsYrFMphZqCB3MoAeXT/N35Y9ILZw1B888wd5S7/DC58WnI70jyQnIEhEw4hDfzegpKcAE9NptgQYAQDhkCNGU3QaVBr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191544; c=relaxed/simple;
	bh=0bbihADssPhupXdxZBOd8smd4+M3g2gYH5Pqns9t4lo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1d7GLmwgWDw3/Klfr44y0YBp+lyazffd1YOEpvFoF8hJGa3VobYZMX8hhRNuK1swAZ3Y+/XqyE3q23nMPY2LMFQgA1129j4S1j6Y6ILirCIPnl6P8efrrc3vLleqNab6GVFH+KMekOk90eetcJqK9fjc7pcNXPLAtSGebhLgNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyPetnm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyPetnm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C2EC4CECD;
	Thu, 17 Oct 2024 18:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191543;
	bh=0bbihADssPhupXdxZBOd8smd4+M3g2gYH5Pqns9t4lo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hyPetnm2MXl4zZYgSByTS1+eTs88P2jwfHlSmPsfiG16NJtRDxVapGXMa5fQCfh/G
	 Vnf04TpTNs6v0Trn28mSmrTrA6OMxicY47CoLANGdSPcAunvZeSmulejArIDFN/lDC
	 XJapMCIhueE6fcx/Z9aAO2WQcYvclqGxDo2wqZAGfdd8/ph/GLKM/LRXWxorSsHngM
	 lvxokiLc99XstyMckoIxaNlStGtjdQv28UGAuSu0ucEefuR0WzqyytK4FvpV2VXxxC
	 O+hKsQv31w6lwsdy8bfA88cJxC7UZKbU7+q1NOG77OFM2LTYeVfP0vZ6ybAokimdit
	 wV1ljT9JQk6Ug==
Date: Thu, 17 Oct 2024 11:59:03 -0700
Subject: [PATCH 25/29] xfs: check the metadata directory inumber in
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069881.3451313.17409642461210262227.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When metadata directories are enabled, make sure that the secondary
superblocks point to the metadata directory.  This isn't strictly
required because the secondaries are only used to recover damaged
filesystems, and the metadir root inumber is fixed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index f8e5b67128d25a..cad997f38a424c 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -144,6 +144,11 @@ xchk_superblock(
 	if (sb->sb_rootino != cpu_to_be64(mp->m_sb.sb_rootino))
 		xchk_block_set_preen(sc, bp);
 
+	if (xfs_has_metadir(sc->mp)) {
+		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
+			xchk_block_set_preen(sc, bp);
+	}
+
 	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
 		xchk_block_set_preen(sc, bp);
 

