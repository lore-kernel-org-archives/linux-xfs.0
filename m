Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EF4BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLPXi9Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B2EC433C8;
	Sun, 31 Dec 2023 21:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056555;
	bh=F4c3g7WXnLjAEzTOnfA7U0BzPHDiLXzxAZnBGHNhbX0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HLPXi9Zdua3rcWJgrdTixkNiZNtMGCDLxYjxjK7Zu59X8vqiKtT2yr2HLASxQdVET
	 WkMVwxctiRZcqUpxkfwRsD0rqWwliOUZRwc0S6inJMaZUoI+GkvIq6A87D1jQlby3A
	 WRfQRR2synPRUKqcmrNmvUjdmze+ix8csYWGhAlXWph55jymjVMmPevN0XGNnfu7oX
	 hY82ahi3BmqWOWVAomwbksRpm6JWVDaLEjIIqPY/6Jn6Vlj+p9v04ZEerEThFLvUFR
	 61GHIfujLTramUfYv6q73A59EgQ+m3kqoQKt51Oa7LLKPtMk5UiHA+fJMUrQYr+XJJ
	 N291cayD2lkCQ==
Date: Sun, 31 Dec 2023 13:02:34 -0800
Subject: [PATCH 07/21] xfs: use xfs_trans_ichgtime to set times when
 allocating inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844165.1759932.14852858186610852741.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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

Use xfs_trans_ichgtime to set the inode times when allocating an inode,
instead of open-coding them here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 72d2441b65a78..041d1634d7c19 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -693,10 +693,11 @@ xfs_icreate(
 	struct inode		*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inode	*ip;
-	unsigned int		flags;
-	int			error;
-	struct timespec64	tv;
 	struct inode		*inode;
+	unsigned int		flags;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
+					XFS_ICHGTIME_ACCESS;
+	int			error;
 
 	/*
 	 * Protect against obviously corrupt allocation btree records. Later
@@ -759,19 +760,17 @@ xfs_icreate(
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
 
-	tv = inode_set_ctime_current(inode);
-	inode_set_mtime_to_ts(inode, tv);
-	inode_set_atime_to_ts(inode, tv);
-
 	ip->i_extsize = 0;
 	ip->i_diflags = 0;
 
 	if (xfs_has_v3inodes(mp)) {
 		inode_set_iversion(inode, 1);
 		ip->i_cowextsize = 0;
-		ip->i_crtime = tv;
+		times |= XFS_ICHGTIME_CREATE;
 	}
 
+	xfs_trans_ichgtime(tp, ip, times);
+
 	flags = XFS_ILOG_CORE;
 	switch (args->mode & S_IFMT) {
 	case S_IFIFO:

