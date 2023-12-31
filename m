Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3334CBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZmlY9+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B84CC433C7;
	Sun, 31 Dec 2023 21:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057102;
	bh=DQSmFf8LxChuiPwDfuaxtLNvDibuF43fRI6nnXiskak=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FZmlY9+pEuLfBoJd3/9AEdPR5zBr/P9Keq5yZGIf50Bbo30m6S5KYnA9YIWSZ1xzt
	 YxWEWrQ53U/ywW7Z9CwTzTuc4TSN93T5mW3oiBwYK5uMdfqld4hFFpL23UqUjqHAIG
	 5iizYqv9EpGPsXA2NwMzSls3Oo2pTWJSzdaGLalDwtrKw6h38AjLJopXA0e8fgwRBe
	 fZiGRf343EkD0RzeaX4PUgcUQW1CXCvOm8P7SMysCFDrO7QRWQX+EwH58SXXxAMniO
	 cCWaH3WQqrNvidJ6RS7cmrE0BMmo1xhDAClAQbC0XalIKI0YCLRk/vccqpmnaZkeFV
	 BdZPgV7XLxFIg==
Date: Sun, 31 Dec 2023 13:11:42 -0800
Subject: [PATCH 21/32] xfs: adjust xfs_bmap_add_attrfork for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845204.1760491.3587754503411110991.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Online repair might use the xfs_bmap_add_attrfork to repair a file in
the metadata directory tree if (say) the metadata file lacks the correct
parent pointers.  In that case, it is not correct to check that the file
is dqattached -- metadata files must be not have /any/ dquot attached at
all.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    5 ++++-
 fs/xfs/libxfs/xfs_bmap.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9cefaeca8f854..9cf3e31b98f89 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -946,7 +946,10 @@ xfs_attr_add_fork(
 	unsigned int		blks;		/* space reservation */
 	int			error;		/* error return value */
 
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip->i_mount, ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dd0229963ad97..6d4e4861b4f5c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1024,7 +1024,10 @@ xfs_bmap_add_attrfork(
 	int			error;		/* error return value */
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip->i_mount, ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 	ASSERT(!xfs_inode_has_attr_fork(ip));
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

