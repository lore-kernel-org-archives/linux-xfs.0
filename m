Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E901EB1AA
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179567; cv=none; b=Q4hbGWWQmMhZuQmKju7D6GO1mx2QR6m2Oy1BCmAJMh18Chdh10nljbKCExhr3/u2yZlcg+ySOvwNQWLiUzeSPN04vJoU3npw7phNtmZIHpvsITnrI8rj1X7QFPxMpdJvCDt1WekEYmX5H0Hbc9OwnEDk4a3LjuXqjg4rp5JeF10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179567; c=relaxed/simple;
	bh=mrMDiC5fN8PY5ygGxShSTmj8xH8ABxHqvlX94/pQQ5I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EKLnl1qygKUtpPHvFC+tdDaxhRGInjuD18OsjqVuNCRFE2EUaJwVOinmS1Zzgj+d7MDV7od4CyyOsJX4uVCPAKxAndS2+SpC4cdkjM2cloiunwuu04iuCbxXxk/phj+15HEQjkidNedWZXLrehO4kHtPzmRz2M2x/kp3OCwxQJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGlLqSFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGlLqSFw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 68D421F000C4;
	Fri, 16 Oct 2026 19:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179565;
	bh=wXM/3BpRLFULUOu10glkf9XROv+AGHNAYTCbZ1lmK28=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=dGlLqSFwbvpQThLk9rIlb3ZJOedr2Vd1x4Z5BWI2sNE/ea0lr0KKOCt/RGQiBOcQM
	 SmjApoJXyvPL0f1fHCgYHtvHOOO21AY0EKtC+4ElzxAcuyf4cHNfutKSJ1hFvg6Ds8
	 v4RU8pM/Pa0ppjZLOhkyEGkBughop88YMylwsAhmo+Ym87ZCFuHS+wTgWYOrNPtRSE
	 QPFNDHEaYQq088JxkNgpQ2EBtxvWc/x2atdGZNMiGe3N8TmDiz7cOtekrZxh9E/MU+
	 muQwwzl8zxypQeOF0nabch1bKPnSaNV6BMW9qLpnPyK5eppu5s6Kxm3+39KbbWWB46
	 7uGRMAXWwQtEA==
Date: Fri, 16 Oct 2026 12:39:24 -0700
Subject: [PATCH 06/10] xfs_repair: upgrade filesystems to support rtgroups
 when adding metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942848.717548.11559574043599467319.stgit@frogsfrogsfrogs>
In-Reply-To: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
References: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
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
 repair/phase2.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)


diff --git a/repair/phase2.c b/repair/phase2.c
index 7d245c100b494f..af0daf9670dc0d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -348,6 +348,9 @@ set_metadir(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*new_sb)
 {
+	struct xfs_rtgroup	*rtg;
+	unsigned int		i;
+
 	if (xfs_has_metadir(mp)) {
 		printf(_("Filesystem already supports metadata directory trees.\n"));
 		exit(0);
@@ -359,6 +362,15 @@ set_metadir(
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
@@ -371,12 +383,33 @@ set_metadir(
 	doomed_gquotino = mp->m_sb.sb_gquotino;
 	doomed_pquotino = mp->m_sb.sb_pquotino;
 
-	new_sb->sb_rbmino = new_sb->sb_metadirino + 1;
-	new_sb->sb_rsumino = new_sb->sb_rbmino + 1;
+	new_sb->sb_rbmino = NULLFSINO;
+	new_sb->sb_rsumino = NULLFSINO;
 	new_sb->sb_uquotino = NULLFSINO;
 	new_sb->sb_gquotino = NULLFSINO;
 	new_sb->sb_pquotino = NULLFSINO;
 
+	/* Try to size rtgroup between 1TB and 1 fsblock */
+	for (i = 40; i > new_sb->sb_blocklog; i--) {
+		unsigned int	rgsize = XFS_B_TO_FSBT(mp, 1ULL << i);
+
+		rgsize -= rgsize % new_sb->sb_rextsize;
+		new_sb->sb_rgextents = rgsize;
+		if (new_sb->sb_rgextents >= XFS_MIN_RGEXTENTS &&
+		    new_sb->sb_rgextents <=
+				(XFS_MAX_RGBLOCKS / new_sb->sb_rextsize))
+			break;
+	}
+	if (i < new_sb->sb_blocklog) {
+		printf(
+	_("Cannot determine rtgroup size between 1TB and %llu bytes.\n"),
+				1ULL << i);
+		exit(0);
+	}
+	new_sb->sb_rgcount = 0;
+	new_sb->sb_rgblklog = libxfs_compute_rgblklog(new_sb->sb_rgextents,
+						      new_sb->sb_rextsize);
+
 	/* Indicate that we need a rebuild. */
 	need_metadir_inode = 1;
 	need_rbmino = 1;
@@ -386,6 +419,14 @@ set_metadir(
 	clear_quota_inode(XFS_DQTYPE_PROJ);
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
 

