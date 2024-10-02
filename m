Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D8B23AD
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831459; cv=none; b=N68oOf5eRX2kS6OB4s3d4OKF3wTSJ5sCjKDvcibRNkmuHw0VePPxR0jEHVkld0hUe7t226iuh/ON7L9uwSDtVmrXno3tnctREuLlsvfi6Me1uLlvPJweeN6dA4LaiLLl9SMo0IfXPb+7yKznF66pVhmgPDenYpG4yMGQi/lJa4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831459; c=relaxed/simple;
	bh=kNbj90Z13inUhXPa4PSMwrGCZOUkh6VtzpQwsnetYMg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ykwm9NkwRMLEXBKeBtI+3WkwngxcZQ+YQM4bOaScTxXQb9QXq8am5oenBgBn+TxSPRM+iNB4IgDqPcTg4gU5j4SIhQj4bDkXwMAakmvX28p1NCr21ZzO8I8ky4sYuQ3Lv35u5w6uHOjkgJJ4p7E4c2T8M0vkGWuQHFltn4EuNaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spnSmTU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spnSmTU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD95C4CEC6;
	Wed,  2 Oct 2024 01:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831458;
	bh=kNbj90Z13inUhXPa4PSMwrGCZOUkh6VtzpQwsnetYMg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=spnSmTU2Rzi7D4R3ovMlqkPM8mvqJI1dvCEcHXx7B8PA/4kSqKZXn4TOAuf0iRUss
	 CKRw/AyzPz37tCrWMPOZkudPbE7onLfq4J00rzrava57ntJ8MuYahGXIrgByxJaT8g
	 JlREFdXaOQ6QpDVmgN4kp/Xt4/MkYlPtPM9ApuGaTs5VPnAvy4L0mFM3thYE52RfMt
	 xei2EW8jadRH7BW8CX2dUgqsj3GY6kFdZ9HGb3oKJK8Z8dOLvZZThLEVjJXv2+8rjb
	 o6ouivVuH7xKxVbGZaFUVAK94FZa3FWPzTfqLLxq1zCvacPAtrEGBeqWNkMAs8JOv2
	 PyLomYq6Tp7GA==
Date: Tue, 01 Oct 2024 18:10:58 -0700
Subject: [PATCH 12/64] libxfs: rearrange libxfs_trans_ichgtime call when
 creating inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783101962.4036371.5415910489198519953.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Rearrange the libxfs_trans_ichgtime call in libxfs_ialloc so that we
call it once with the flags we want.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 9ccc22adf..b302bbbfd 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -94,6 +94,7 @@ libxfs_icreate(
 	struct inode		*inode;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
 	int			error;
 
 	error = libxfs_iget(mp, tp, ino, XFS_IGET_CREATE, &ip);
@@ -112,7 +113,6 @@ libxfs_icreate(
 	inode->i_uid = GLOBAL_ROOT_UID;
 	inode->i_gid = GLOBAL_ROOT_GID;
 	ip->i_projid = 0;
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
 	if (pip && (dir->i_mode & S_ISGID)) {
 		inode->i_gid = dir->i_gid;
@@ -129,10 +129,12 @@ libxfs_icreate(
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		inode->i_version = 1;
 		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
-		ip->i_crtime = inode_get_mtime(inode); /* struct copy */
 		ip->i_cowextsize = 0;
+		times |= XFS_ICHGTIME_CREATE;
 	}
 
+	xfs_trans_ichgtime(tp, ip, times);
+
 	flags = XFS_ILOG_CORE;
 	switch (args->mode & S_IFMT) {
 	case S_IFIFO:

