Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C31A48
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529942; cv=none; b=GwMhJ5M/9zeXt4+6hgz8iGqXxFsVQ5HcYofSebwNQ5dv/EYs+OOFZ3+BFcRdixUr/XwQOJtWRQmV1Orqy6eq+QHibdLgPTIE2vdoguerrd111xN2s91uSoFyI9KwE4B0qSRrL2pu87Ckliikupco6gASSMXJZ1i1SlnW1ED0irE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529942; c=relaxed/simple;
	bh=3dgb28Utw0/FWT/oDuYycHjtljQ9GH+jOuv79VhUL1A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vGu/rGWQ1i+ONMx+62lXWECFvFPCU2aQix0fIyz5HgWitXB3KMdNup2DjoKjoK9sQy9ujefCshAO8dJEn2O/+FA4bh1xPVuZGR5R+G8gyZjVM/jG9yad8HbCuCvol3VGNN9w7+lzOlHQlzaTfal17fIuIatGODpC5AhLtLH9TDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P86oMNKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P86oMNKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFB8C4CED1;
	Sat,  7 Dec 2024 00:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529942;
	bh=3dgb28Utw0/FWT/oDuYycHjtljQ9GH+jOuv79VhUL1A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P86oMNKq7aNpiLhn+6psFWsEWwWmkc6JsEdIJdrVDIAXCKHcAHdb+jnF8TwrWjGLL
	 4MfzeJlcdAkVEsryKsBucflJ0JmePhSgev0PzcAG6TiUVmaoVtxqsZh9epMWjhBD7K
	 dZ78T3s5bGhWZiZOAiO3j6gOJhvZLRxMwHa/DVn9ZukQHJq9WtEbxJfg2RNQ3aOqL2
	 BULHi3QA7Qq5K7jJnA9mAFutlwWavhW0vMnxt8FLRIzThmg5fFIGGWeNyu3+yxqGQX
	 B3cry8ewisipdMwBEWRCj8wuBbeoc2tKpVmsYVPB1amPk4FL6SHc+upldMrMya69p/
	 /BlEt3BPVC0nQ==
Date: Fri, 06 Dec 2024 16:05:42 -0800
Subject: [PATCH 03/50] xfs_repair,mkfs: port to
 libxfs_rt{bitmap,summary}_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352751992.126362.5121798366403344201.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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
index d7a88133eb78e9..99019e94bab285 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -552,14 +552,10 @@ _("couldn't iget realtime %s inode -- error - %d\n"),
 
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

