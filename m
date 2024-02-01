Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1694E29B0
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817538; cv=none; b=epRyv7sWG3c2iCEzra8EzuCLtmUWRYhiWVFyqRQFryXpm2fVNc8vp31ONguJ1SjkDoqTRkeOx5x/+Ec9Jfs7ljWjdOh8cSyfZzHIUzjDnS4TUrr0Anvur5+HWQYaPzP7cIegopfvPwRL4Y7oTfMQWd9gYcOnQpMaeqbqeHEPMB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817538; c=relaxed/simple;
	bh=CSY2vAOlZqckUDpslLzHA/urZICKaU0jDWk3urwAgdU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WTtHT0fT5vP8lL3hZMH8RomQW1H/7hdosj8H0gXfuPbd2w1mysiog2n4DGSqLrXU+weYkf8TD0FrElpqQLJQ/gC3cOedmw5bIdwP9tFtKrhOZY9foXz0ssgoW9VZ9ML7dlu/WGetu8OozNcQ91gmnJN5uWBaGwzu+byMs4aHCZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5HHNb3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5HHNb3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818ACC433C7;
	Thu,  1 Feb 2024 19:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817537;
	bh=CSY2vAOlZqckUDpslLzHA/urZICKaU0jDWk3urwAgdU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A5HHNb3zRMRyLcvVzDnGOE9DQG+3MHmzroIOVq3rF+rVBgszCpNTLtHlDvIK3R2j6
	 4Ai38qGkdu7VKD/KL20kQ+euccRLWbwtBhiSNf0YUhXAHa8dEES/4T1E6HSyR1XMZd
	 A49XtipeHgOuV3mEqCLZuhXjTWpYRrWNjqvGmPDhFOMvKjQ2IfJdaHIO3JmrA8Mvua
	 CimneUyMQyydf+jkWybP5GDJ2t2X4T5ET+2aGtNHC5Tw1FLdRuRq+RBLmvhqJQHrfS
	 kNyvBkc9ucJGZ+yyF8Wqd3datQfwrnKatdobhKHTjbECQ2Ghuiz6UJlHXXZYQeYWUH
	 jw/XAlNSV+0og==
Date: Thu, 01 Feb 2024 11:58:57 -0800
Subject: [PATCH 1/5] xfs: create a helper to decide if a file mapping targets
 the rt volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337440.1608576.8753789039409739499.stgit@frogsfrogsfrogs>
In-Reply-To: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
References: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       |    6 +++---
 fs/xfs/libxfs/xfs_inode_fork.c |    9 +++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |    1 +
 fs/xfs/scrub/bmap.c            |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b4a2adb42df33..ac44a02db4e61 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4913,7 +4913,7 @@ xfs_bmap_del_extent_delay(
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got->br_startoff + got->br_blockcount;
 	da_old = startblockval(got->br_startblock);
@@ -5149,7 +5149,7 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	*logflagsp = XFS_ILOG_CORE;
-	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
+	if (xfs_ifork_is_realtime(ip, whichfork)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
@@ -5396,7 +5396,7 @@ __xfs_bunmapi(
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	end = start + len;
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 3e63567810e5b..451615e1fdfff 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -810,3 +810,12 @@ xfs_iext_count_upgrade(
 
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 96303249d28ab..bd53eb951b651 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -260,6 +260,7 @@ int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
+bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b169cddde6da4..24a15bf784f11 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -924,7 +924,7 @@ xchk_bmap(
 	if (!ifp)
 		return -ENOENT;
 
-	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
+	info.is_rt = xfs_ifork_is_realtime(ip, whichfork);
 	info.whichfork = whichfork;
 	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
 	info.sc = sc;

