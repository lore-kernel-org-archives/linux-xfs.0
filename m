Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A33C8FB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924430; cv=none; b=l5D7y8dZqghmxw/rUXwGkdHSilNzRQe7RrlsXM6E+lM+QRd5ZDO3xBr3RTQVEiXeDUjevYP6qbi34uwg3jvJskgX+ChWmJOf2TJzxrvGqkAYoLTWOTo6KDhBrt+WsU6gIQp9hRUaQI1gPha6VK+eDuaPL3Wva5cQvAMd6TPGj/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924430; c=relaxed/simple;
	bh=N+DAYZ8RIKcGav+5p76aEYvIvWY84mv+kv4o9V7SAp4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dZcLMnQAMBM2exqwu1A5RplWgjd5wnfCW9YC2nfeLXiwRUueRmnNi1r26tOVZ73zaxz687ItTgiMS6wiJvlB69eVxlhSLSG0OkdkNV6n9eDRYec+Nxxoot+QcIjp8qCF6WOdc9ETYxAjzJ02pNcBD1z/lFdleZIjSCXmvwv514o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvKvD/Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvKvD/Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF7DC2BD10;
	Thu, 20 Jun 2024 23:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924429;
	bh=N+DAYZ8RIKcGav+5p76aEYvIvWY84mv+kv4o9V7SAp4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dvKvD/ZiAZCXwq7bfUyc/tWpMeuPRk8Sn23xiK52kgdPM4fFqSgCudQtydsgdEItm
	 03bZenAnqgEECZL0CuE3YhhJctFujJDaeXtFlelCx2lYCHeIYRv0bkYg5QxacImdhz
	 scfDDqdEsbPqD8KW765jHNt9GWT8bzkEDdBUj2dtbcOyqsElR39419duUqANGTF/0G
	 i1lfV0MffxlidnP6btlERDhuwXlEl7cJQb1oWfwh2aBy2Oyz4cNflPt1JBzG2uNKZ2
	 hznOFbcX1hDr7hLE/gmEVJ2//q6bH3cPwjsb8HakdObaXzXpgchM6xreGflnaOJGTd
	 ZQj8IzyE7hpVQ==
Date: Thu, 20 Jun 2024 16:00:29 -0700
Subject: [PATCH 08/24] xfs: use xfs_trans_ichgtime to set times when
 allocating inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418033.3183075.12663415998312646212.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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
index 4ceefe32b5854..44ce7d8307cb6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -672,10 +672,11 @@ xfs_icreate(
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
@@ -743,19 +744,17 @@ xfs_icreate(
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

