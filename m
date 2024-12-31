Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F29729415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689285; cv=none; b=eMB0Qh37CsB4iWeq0lgyPv1eyV/d9kJFFA1LHQr3K+9cNJ91pAVOpmuHSceYbB9Zj31q3FkCL/gRgGWxtIGRJHUfpEazFgDIplaTmo5lXHQzPmcItnt7NgxZxH4oTRaLw28SneNzi9frEOQViquipLHATX6Zl6BIH3IGpV38ixc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689285; c=relaxed/simple;
	bh=zagRP1YqMtS5/TO+furciXYwNbtsyuUT/1tAN175e7c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Av4NBL4WwdrYiI69m/cQUeKWIx/R5D/9U4sFQON61FPrAKNYqZiPHfuz5EXQfxe8PFqjKDqeJ8z62wltY6LEvCpEi/TVB6+XZwPvU6bLwKNSZ/GC67W+1BAh6NdIyKMt7rys1WsJ63YE102ymOV75OYIAQfP3OFCen8/CFFHmKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApXEJ7bH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApXEJ7bH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E896C4CED2;
	Tue, 31 Dec 2024 23:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689285;
	bh=zagRP1YqMtS5/TO+furciXYwNbtsyuUT/1tAN175e7c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ApXEJ7bHrUWH0c7geEsTEjO4H0oHxdc6xKBxf0yVIc0oSefovRXlWqi2Fmneo1nHR
	 9Jd9D6WalOAwAZKQ486UkDA4XqadO/8MNmp4QJqSCFalWicZkqMnMf3NcABqQ69o8k
	 54OdXiuC4VBLsRzPhCaSv4ijwDPcYfRojTcNGq8TS33wSqiyY/MoeYy70vVpE+RseB
	 Ff+CyKwd37CDHb+tVUUQ5dZEAnG/epE4UYFkCayyTxyYbdSZ4AygxT3oBfdLcoUqEu
	 uwE8VPAnJo39yT94tjYs/NhTc4WnWfFGcpKxT7wGj5GdoshSJ6nRz7E6jKBot8Vwjs
	 /pq/TT8M4rHTQ==
Date: Tue, 31 Dec 2024 15:54:44 -0800
Subject: [PATCH 06/10] xfs_repair: upgrade filesystems to support rtgroups
 when adding metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779226.2710949.17487947341302189597.stgit@frogsfrogsfrogs>
In-Reply-To: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
References: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Amend the metadir upgrade code to initialize the rtgroups related fields
in the superblock.  This obviously means that we can't upgrade metadir
to a filesystem with an existing rt section.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase2.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)


diff --git a/repair/phase2.c b/repair/phase2.c
index 35f4c19de0555c..fa6ea91711557c 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -341,6 +341,9 @@ set_metadir(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*new_sb)
 {
+	struct xfs_rtgroup	*rtg;
+	unsigned int		rgsize;
+
 	if (xfs_has_metadir(mp)) {
 		printf(_("Filesystem already supports metadata directory trees.\n"));
 		exit(0);
@@ -352,6 +355,15 @@ set_metadir(
 		exit(0);
 	}
 
+	if (xfs_has_realtime(mp)) {
+		printf(
+	_("Realtime groups cannot be added to an existing realtime section.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_exchange_range(mp))
+		set_exchrange(mp, new_sb);
+
 	printf(_("Adding metadata directory trees to filesystem.\n"));
 	new_sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_METADIR |
 					 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
@@ -364,21 +376,35 @@ set_metadir(
 	doomed_gquotino = mp->m_sb.sb_gquotino;
 	doomed_pquotino = mp->m_sb.sb_pquotino;
 
-	new_sb->sb_rbmino = new_sb->sb_metadirino + 1;
-	new_sb->sb_rsumino = new_sb->sb_rbmino + 1;
+	new_sb->sb_rbmino = NULLFSINO;
+	new_sb->sb_rsumino = NULLFSINO;
 	new_sb->sb_uquotino = NULLFSINO;
 	new_sb->sb_gquotino = NULLFSINO;
 	new_sb->sb_pquotino = NULLFSINO;
+	rgsize = XFS_B_TO_FSBT(mp, 1ULL << 40); /* 1TB */
+	rgsize -= rgsize % new_sb->sb_rextsize;
+	new_sb->sb_rgextents = rgsize;
+	new_sb->sb_rgcount = 0;
+	new_sb->sb_rgblklog = libxfs_compute_rgblklog(new_sb->sb_rgextents,
+						      new_sb->sb_rextsize);
 
 	/* Indicate that we need a rebuild. */
 	need_metadir_inode = 1;
 	need_rbmino = 1;
 	need_rsumino = 1;
-	have_uquotino = 0;
-	have_gquotino = 0;
-	have_pquotino = 0;
+	clear_quota_inode(XFS_DQTYPE_USER);
+	clear_quota_inode(XFS_DQTYPE_GROUP);
+	clear_quota_inode(XFS_DQTYPE_PROJ);
 	quotacheck_skip();
 
+	/* Dump incore rt freespace inodes. */
+	rtg = libxfs_rtgroup_grab(mp, 0);
+	if (rtg) {
+		libxfs_rtginode_irele(&rtg->rtg_inodes[XFS_RTGI_BITMAP]);
+		libxfs_rtginode_irele(&rtg->rtg_inodes[XFS_RTGI_SUMMARY]);
+		libxfs_rtgroup_rele(rtg);
+	}
+
 	return true;
 }
 

