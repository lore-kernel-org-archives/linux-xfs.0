Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8B0C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udZvxskA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE65C433C7;
	Sun, 31 Dec 2023 23:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065063;
	bh=YU2kJGeyZKb6yCYYCupPoZbLWurZnj1RPBVnzPULisE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=udZvxskAqeR2mbbQQMEkWfuXg9Ynptbm287+oSiDdZIUg5thSlfiiN8wexiwa9hrq
	 G+EIOVNEQIWc4Hli4ju2hf0WvOH5l31SjiWPj3jtSLdQtyccDaW9CFMLpB13stLocG
	 U4/qG1WM/vHYfitjdnWTnk7xk8I0MHJ0guO/stLtk975cBmCsyqwlJXpTL9B5DS4Gc
	 jTpnAunivyo2hTOxHR0NIS0p6zkDo7qxczK06jQOulfzog4bBYvR/gd6dDGAvGDwOP
	 GlUgjKoXPmU9fAHd590KND+yQhp9wouMbVtAnOwVUp2j94DgvbpBtF7/kEGAxHX8lj
	 UzJXOOGCOd3Ag==
Date: Sun, 31 Dec 2023 15:24:23 -0800
Subject: [PATCH 08/28] libxfs: rearrange libxfs_trans_ichgtime call when
 creating inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009283.1808635.1561211133359804844.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
index 433755a18ba..8a2f7dfff4d 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -91,6 +91,7 @@ libxfs_icreate(
 	struct xfs_inode	*pip = args->pip;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
 	int			error;
 
 	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);
@@ -102,7 +103,6 @@ libxfs_icreate(
 	set_nlink(VFS_I(ip), args->nlink);
 	VFS_I(ip)->i_uid = args->uid;
 	ip->i_projid = args->prid;
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
 	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
 		if (!(args->flags & XFS_ICREATE_ARGS_FORCE_GID))
@@ -120,10 +120,12 @@ libxfs_icreate(
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
-		ip->i_crtime = VFS_I(ip)->__i_mtime;
 		ip->i_cowextsize = 0;
+		times |= XFS_ICHGTIME_CREATE;
 	}
 
+	xfs_trans_ichgtime(tp, ip, times);
+
 	flags = XFS_ILOG_CORE;
 	switch (args->mode & S_IFMT) {
 	case S_IFIFO:

