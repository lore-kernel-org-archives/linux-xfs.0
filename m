Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002361AB53A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991955; cv=none; b=LOiRkWS6tMfJDOHQ4Nji1487T1p4Y+8vfq26ZFs+S0LzY5+vY+mmbGBDswYypZv07jYskliXznwenlGj4onTpgR7MIkWw3Ib4YbbpiykEKuQa0qjbFoigOu/XXu05JLusFm5zkOnNj40+K6IpRnPqGVlBntvRza6kZIy0BHfTKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991955; c=relaxed/simple;
	bh=XDMvrPt4mzp1iTblZ7hMmHcmCPtynfsKr7a3qK8NmUI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tsAOz0GcTYCF81O4nXO/EHgZ8Vj3/ZqZ46b+WQWAQzaHr99tR5b5cRa/h+mmX+d5HSzhv/odECII5GpV+SnfoKh4D8yA/B4zKWMmmI4QqMGfBtT++ckDWeknrhhYtvBP/7G+wudW65Abv9D73LNzHeM33MpMk7Jx7lhyyf8GFR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6u3QNV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6u3QNV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B49C4CED3;
	Mon, 23 Dec 2024 22:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991953;
	bh=XDMvrPt4mzp1iTblZ7hMmHcmCPtynfsKr7a3qK8NmUI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t6u3QNV+oUzOTYDr94rsN84tmgyqU1+DA7RaxyEvL1cHCHmgZWHAXGSeUcwxt9Dy0
	 EiC+/DahlHDg425vxtZh5/+dPlw6ZVvq0kHQKxcRzLQT1KKAkJojN++93wTJkmDZB1
	 FIX+gOVu9UPTn5JJl3mcLx2rSHbdVj1/HnnAah6dneS+39iBVNND3hL/rcJg4LO/Po
	 D3dBbXZ+UbAsL/7Ce5BlcY8TvDw5g36KYsQupbI5D1eHFua7EIYZ5M5b6xoGQ3KHzg
	 eXFH+/zRTw/v3jlUeajuJeDe+IsRjcx1qRS8Hr89Caqz26tFydO3pWLU5duAJRqf+R
	 wJCyHTbp2omXg==
Date: Mon, 23 Dec 2024 14:12:33 -0800
Subject: [PATCH 03/51] xfs_repair,mkfs: port to
 libxfs_rt{bitmap,summary}_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943849.2297565.313321719499366005.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Replace the open-coded rtbitmap and summary creation routines with the
ones in libxfs so that we share code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/proto.c    |   51 ++++++++++++++++++++++-----------------------------
 repair/phase6.c |    8 ++------
 2 files changed, 24 insertions(+), 35 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 55182bf50fd399..846b1c9a9e8a21 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -948,7 +948,10 @@ static void
 create_sb_metadata_file(
 	struct xfs_rtgroup	*rtg,
 	enum xfs_rtg_inodes	type,
-	void			(*create)(struct xfs_inode *ip))
+	int			(*create)(struct xfs_rtgroup *rtg,
+					  struct xfs_inode *ip,
+					  struct xfs_trans *tp,
+					  bool init))
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_icreate_args	args = {
@@ -972,9 +975,23 @@ create_sb_metadata_file(
 	if (error)
 		goto fail;
 
-	create(ip);
+	error = create(rtg, ip, tp, true);
+	if (error < 0)
+		error = -error;
+	if (error)
+		goto fail;
 
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	switch (type) {
+	case XFS_RTGI_BITMAP:
+		mp->m_sb.sb_rbmino = ip->i_ino;
+		break;
+	case XFS_RTGI_SUMMARY:
+		mp->m_sb.sb_rsumino = ip->i_ino;
+		break;
+	default:
+		error = EFSCORRUPTED;
+		goto fail;
+	}
 	libxfs_log_sb(tp);
 
 	error = -libxfs_trans_commit(tp);
@@ -990,30 +1007,6 @@ create_sb_metadata_file(
 		fail(_("Realtime inode allocation failed"), error);
 }
 
-static void
-rtbitmap_create(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-
-	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-	ip->i_diflags |= XFS_DIFLAG_NEWRTBM;
-	inode_set_atime(VFS_I(ip), 0, 0);
-
-	mp->m_sb.sb_rbmino = ip->i_ino;
-}
-
-static void
-rtsummary_create(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-
-	ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
-
-	mp->m_sb.sb_rsumino = ip->i_ino;
-}
-
 /*
  * Free the whole realtime area using transactions.
  * Do one transaction per bitmap block.
@@ -1078,9 +1071,9 @@ rtinit(
 
 	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 		create_sb_metadata_file(rtg, XFS_RTGI_BITMAP,
-				rtbitmap_create);
+				libxfs_rtbitmap_create);
 		create_sb_metadata_file(rtg, XFS_RTGI_SUMMARY,
-				rtsummary_create);
+				libxfs_rtsummary_create);
 
 		rtfreesp_init(rtg);
 	}
diff --git a/repair/phase6.c b/repair/phase6.c
index 41342d884ce37a..e9feaa5739efa1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -550,14 +550,10 @@ _("couldn't iget realtime %s inode -- error - %d\n"),
 
 	switch (type) {
 	case XFS_RTGI_BITMAP:
-		ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		error = 0;
+		error = -libxfs_rtbitmap_create(rtg, ip, tp, false);
 		break;
 	case XFS_RTGI_SUMMARY:
-		ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
-		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		error = 0;
+		error = -libxfs_rtsummary_create(rtg, ip, tp, false);
 		break;
 	default:
 		error = EINVAL;

