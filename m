Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34431F3D48
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528786; cv=none; b=j3a1LiWSCkxBbxq1aN/8Mk/tyfyFYwnfpMg2dR5OpoVnWemOihj+zIcB1JWnx4hkPgL1Ng9i3fRP66FSdpgnUety5uoPErXmcPUtiX4+jPyHad8HoKnVC1RbFIG+jEzMqCWrRkgvUX4V1cQlV/wXyaUR6emCwFNZmmwGjNMBV3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528786; c=relaxed/simple;
	bh=PsP+yOD/fuARNWiG7RYcQ5V1UKoebq1FURCWFS/3oBc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qa74c5IpEaj5izRoBdB47irFaZ59O4NzSxlpA0bngZ1FRlYFCV1wvlhuo8hFYQ7qUPt9LdAnkCkhDYxAS6mMXceHgLSMyhSWsTOncpySpdURJvEb4yL/FD0uBqoXlk4o6DqwCfay/lgUd7dyjxclLFa7rc5Odtb1Id162iX+eTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYkLerz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYkLerz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB31C4CED1;
	Fri,  6 Dec 2024 23:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528785;
	bh=PsP+yOD/fuARNWiG7RYcQ5V1UKoebq1FURCWFS/3oBc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QYkLerz/7rG8c2tML6aJKwk2e2BoSOKqx9usGNY8TP3YFuyLEd/nq3MTTvfrhlDeR
	 2/dacI5e/gGH5Y55Y4/Rm2I0EWk3L+/uySmfc35kWRmiv8fGS9ovVst7Wj1gM67PaR
	 zYgV3V936jnmgZ2wOtOgoYKMKIlJqh6SrW+VuUxu6updo9wkju3qlPxcF5IldlKRVm
	 pSX+1rL2vBk5N9pq3BZ35pcxw+XNu9BVLVaR9cajCRuECGQ7g923/mfwz3UwkWNb8i
	 VBIp6i2uYpcsAQuvlf09L8YJkUnnr1s1gwPboFjeyee3gVh7pMDsQAsTxfzjZOcbzJ
	 zQNh5ZUsOVfgA==
Date: Fri, 06 Dec 2024 15:46:25 -0800
Subject: [PATCH 26/41] xfs_repair: refactor grabbing realtime metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748634.122992.15126227280100846699.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

