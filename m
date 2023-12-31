Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033CBC2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfHh+A0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804DDC433C7;
	Sun, 31 Dec 2023 23:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065688;
	bh=Q7yDz277FkeY2usHqxP+V4UC3ap0PLDgNChcD/xMX/8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GfHh+A0eYVepReEPyqLRtlTIheD91icUhn9YbQBLuxr2UOvqfNcQ7Lh/7oydySyR8
	 CjqLj9qrqOpWjJKcrbMt62XI6DJlPCDaTYmRxMzM2lxT+1C457yCZs3bhlbjWKuJym
	 9RM3N0am2CmkEuJTKSYDf7d0g8tRghDz/u5nb4JTRo5h/VwK45moYyeXD3vq0/X8bm
	 OghP0JcXiZKSo3Rk7ciGp5KGueF3jwCiYp/iMLvSWxSFkXXu73U53E6RxFsmZTeqXF
	 oaTR6c/+F5A1sRe1T8fNLMgczoZxawBBZXJ1l57k6TUCzd/Dczmc+0X5nmabquMJ6Z
	 IisRyhbMD26Qw==
Date: Sun, 31 Dec 2023 15:34:47 -0800
Subject: [PATCH 20/58] xfs: adjust xfs_bmap_add_attrfork for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010214.1809361.8608139201414860751.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_attr.c |    5 ++++-
 libxfs/xfs_bmap.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5da0ac9f706..aa391f4bae5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -944,7 +944,10 @@ xfs_attr_add_fork(
 	unsigned int		blks;		/* space reservation */
 	int			error;		/* error return value */
 
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip->i_mount, ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ed50bb90e6a..0dfb37073a7 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1018,7 +1018,10 @@ xfs_bmap_add_attrfork(
 	int			error;		/* error return value */
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip->i_mount, ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 	ASSERT(!xfs_inode_has_attr_fork(ip));
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

