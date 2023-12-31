Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968CFC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAMbwn4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE0FC433C7;
	Sun, 31 Dec 2023 22:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061045;
	bh=GuIy+9sJFnTyn6To9gcJSuyQ0fFFT6EfyuWd0g0WBzU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PAMbwn4R5MlOiELkFJukODfvhJpS6pxxUZbEFlbQKR450Hi6UDOySZOMZKJ5XhXX5
	 UXh76MsqU7UtsmJxSBx1sKezHLedF8wUFpZPNx2c+Edv1fRTuulCmhwaIPhLRMdgX8
	 PfZ/WUdNfMxaQ+lfU2vlHSskW5OO94ZTaOpjqRTdS9s88lVSMrEK2uNySoMlHUjj6Z
	 PdmnR6ZmWQ2h/GWT1oQbLkKpK+y5Nxp5r0WnY0SbmMIvZTBxOyEKvhPt0V1KeBRz4M
	 sXz913ftSNqioDHeTXy01mYARUQV+iqClxLfuWMZEUca2tKaVuTz2ihTphVlxqodDF
	 bCz3M7Z3eQpPg==
Date: Sun, 31 Dec 2023 14:17:25 -0800
Subject: [PATCH 1/4] xfs: create a helper to decide if a file mapping targets
 the rt volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993256.1794784.17420662105533921270.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993240.1794784.3257777351086453063.stgit@frogsfrogsfrogs>
References: <170404993240.1794784.3257777351086453063.stgit@frogsfrogsfrogs>
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

Create a helper so that we can stop open-coding this decision
everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c       |    6 +++---
 libxfs/xfs_inode_fork.c |    9 +++++++++
 libxfs/xfs_inode_fork.h |    1 +
 3 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 51bb4972f03..b764b7f79c4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4883,7 +4883,7 @@ xfs_bmap_del_extent_delay(
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got->br_startoff + got->br_blockcount;
 	da_old = startblockval(got->br_startblock);
@@ -5119,7 +5119,7 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	*logflagsp = XFS_ILOG_CORE;
-	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
+	if (xfs_ifork_is_realtime(ip, whichfork)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
@@ -5366,7 +5366,7 @@ __xfs_bunmapi(
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	end = start + len;
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d6478af46d6..5f45a1f1240 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -818,3 +818,12 @@ xfs_iext_count_upgrade(
 
 	return 0;
 }
+
+/* Decide if a file mapping is on the realtime device or not. */
+bool
+xfs_ifork_is_realtime(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	return XFS_IS_REALTIME_INODE(ip) && whichfork != XFS_ATTR_FORK;
+}
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 535be5c0368..ebeb925be09 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -262,6 +262,7 @@ int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
+bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)

