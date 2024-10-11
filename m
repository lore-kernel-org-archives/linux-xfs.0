Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B952DDBE
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609594; cv=none; b=t2hXB+jRtu5BRWtG+zQVMHn2M312rpjGj9OUcno0k8KFp4LJA+dEMDXgNeGEoqqtALLqqZA7sdt/4JcgR8D/ACK5CM613nzTf1a6Cr5bb20snZ51YP5ApjGQW43dmUEWb+rOifKKsNFAELRtk5NTBFQok38rvFCqDsjtSot7SNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609594; c=relaxed/simple;
	bh=hhcXxyaJx+bH2hhbg6QCxBewRW12k0a1gatM+1uvvUU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvmBwZ8Q0LAEL5CzULgxIJw4HK4UfmYBrVmwIJPzYG4v0lg8Xd5MlwZF0Um3n4OqlhnDZVCaIMC/4l/7oPzk/F1GR2PORM5+MFzUh3Tz2muaDi4a0ujoSABrhqqejpxk10dicDKPRkrJThtt1Y7cRm0n9dvVRsBipNdOs40RW0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iibHsuOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iibHsuOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB3EC4CEC5;
	Fri, 11 Oct 2024 01:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609594;
	bh=hhcXxyaJx+bH2hhbg6QCxBewRW12k0a1gatM+1uvvUU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iibHsuOyyVtg8G7Gaf9R2Sk9Bp3DDf1xPJR4NQwxWHaoL51gu/7Hniw9i1lz345fT
	 dPAy/cDyZDU2aTaHxJIMOMhHanG02ZnmlBdQKzysKQFDNjYyvQV82GToYffv9VTpRG
	 Tod5xM/XwjNk9qx0Gum7XYuJIMLESELOjYfq+adKBBrbm3jVnOGlMFBtBU8WQ9Zu89
	 hwllh/37cQg6JWWm83q4HfWS9uuxSlfdkTX37tf2l1P9pWH0WzCvWE13Z6OX7mDKdO
	 LpMc1ZsL2z0EtJiVUvpKPBXGcFxrS8bPmsiEppjquNNx1HoT3wT+25o4k2qZhi+TWY
	 QuO2/UM+7xKJw==
Date: Thu, 10 Oct 2024 18:19:53 -0700
Subject: [PATCH 22/38] xfs_repair: refactor grabbing realtime metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654313.4183231.12520181687042722649.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Create a helper function to grab a realtime metadata inode.  When
metadir arrives, the bitmap and summary inodes can float, so we'll
turn this function into a "load or allocate" function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   51 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 17 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index ae83d69fe12cd3..e15d728ddc0469 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -474,6 +474,24 @@ reset_sbroot_ino(
 	libxfs_inode_init(tp, &args, ip);
 }
 
+/* Load a realtime freespace metadata inode from disk and reset it. */
+static int
+ensure_rtino(
+	struct xfs_trans		*tp,
+	xfs_ino_t			ino,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	int				error;
+
+	error = -libxfs_iget(mp, tp, ino, 0, ipp);
+	if (error)
+		return error;
+
+	reset_sbroot_ino(tp, S_IFREG, *ipp);
+	return 0;
+}
+
 static void
 mk_rbmino(
 	struct xfs_mount	*mp)
@@ -486,15 +504,14 @@ mk_rbmino(
 	if (error)
 		res_failed(error);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime bitmap inode -- error - %d\n"),
-			error);
-	}
-
 	/* Reset the realtime bitmap inode. */
-	reset_sbroot_ino(tp, S_IFREG, ip);
+	error = ensure_rtino(tp, mp->m_sb.sb_rbmino, &ip);
+	if (error) {
+		do_error(
+		_("couldn't iget realtime bitmap inode -- error - %d\n"),
+			error);
+	}
+
 	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
@@ -560,7 +577,8 @@ _("couldn't re-initialize realtime summary inode, error %d\n"), error);
 }
 
 static void
-mk_rsumino(xfs_mount_t *mp)
+mk_rsumino(
+	struct xfs_mount	*mp)
 {
 	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
@@ -570,15 +588,14 @@ mk_rsumino(xfs_mount_t *mp)
 	if (error)
 		res_failed(error);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime summary inode -- error - %d\n"),
-			error);
-	}
-
 	/* Reset the rt summary inode. */
-	reset_sbroot_ino(tp, S_IFREG, ip);
+	error = ensure_rtino(tp, mp->m_sb.sb_rsumino, &ip);
+	if (error) {
+		do_error(
+		_("couldn't iget realtime summary inode -- error - %d\n"),
+			error);
+	}
+
 	ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);

