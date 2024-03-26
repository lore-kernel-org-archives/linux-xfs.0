Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E11121353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425209; cv=none; b=H+r13xf10JWQpry/kR6NcccZxBesIH/pY1uVUHXHM1l6nc252/96C0jiEotFDPVl8I6+GNPwY2iBTpoIxUKiIveftYbGXvhMZZQ2C8Uc1mPWFL60O2a9EywDCCic3IYMSZBu1M5R7DnWjmXzlK8lVY4uAX8p96mrf1744a0m7g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425209; c=relaxed/simple;
	bh=npfC+4EK/6S+Z68UMijsQU8j+jKzMGR6R3Kzyy8zafA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KPaKM3uq+Lt3s+zMRumeV+DKfQqwAfrNkrE8A4aXrJLA45qjdi8r8bhG5Br+KDZ/mPzjWpbk/fWn4u9IBF9CIPDTvGidmFKs8gTjf4isGDI2tBOeiPa7ojoqgCl4yvMe+v6WqiF/mhqEBnkR4iKarkpehMNIsb67xx7inq1SODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQv4Fpg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQv4Fpg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2DEC433C7;
	Tue, 26 Mar 2024 03:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425208;
	bh=npfC+4EK/6S+Z68UMijsQU8j+jKzMGR6R3Kzyy8zafA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JQv4Fpg5eoyvR8HJUvmfFEngh84SMzjA6/ZKm567+0ktbFTD9Arv6WCG5PWdlSU2G
	 FKKmYy+JBDdiBlNuRHxsxBrxVQs+Av1I4Z1yZNalo27KU9fOPDK9zyAUxauvctfdCk
	 euaEUtZQ/q5hL8z3H+k9/QVBYJkLZ8dpXRcOMwXtikvBiZ1xlcRFQKUUmOcexqvmtN
	 +e/lLqyRFP5QkOaPbVjdr7r+HkT6c6Gx3ne+5LxAaZWJZAfu1C+ggn2kTDDbknY/wh
	 UuXLPbVCP6iQfd5OufSAB2DlLZXOR+tYzar6onGEzpWSXzWWNMkyyPx7zRDcSvtksX
	 gCYwr/ygW6nhg==
Date: Mon, 25 Mar 2024 20:53:28 -0700
Subject: [PATCH 096/110] xfs: create a helper to decide if a file mapping
 targets the rt volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132762.2215168.5364491574786242023.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5049ff4d140c8f6545464811409302cab017321a

Create a helper so that we can stop open-coding this decision
everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c       |    6 +++---
 libxfs/xfs_inode_fork.c |    9 +++++++++
 libxfs/xfs_inode_fork.h |    1 +
 3 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4790efd3de28..85f1deac2807 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4907,7 +4907,7 @@ xfs_bmap_del_extent_delay(
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got->br_startoff + got->br_blockcount;
 	da_old = startblockval(got->br_startblock);
@@ -5143,7 +5143,7 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	*logflagsp = XFS_ILOG_CORE;
-	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
+	if (xfs_ifork_is_realtime(ip, whichfork)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
@@ -5390,7 +5390,7 @@ __xfs_bunmapi(
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	end = start + len;
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 53ff8267803b..052748814841 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -811,3 +811,12 @@ xfs_iext_count_upgrade(
 
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
index 96303249d28a..bd53eb951b65 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -260,6 +260,7 @@ int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
+bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)

