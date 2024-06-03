Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8B613B5BD
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442225; cv=none; b=qTmWJY+PUeIWl4NXpHiJPNRq4zHEWZlDSuBYw8w5qPEqzOVy2j2XNy/ALvMWr183ZynmlPgHbNQO87p7BBcznp5d3wtulYdK5dohPjTNg5OrauWRpDXd1Vu3WDIqUczZoHXXThG1MtbuGPe2ApKbK2RmvM6nckfwRiYJy8bJjVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442225; c=relaxed/simple;
	bh=o8Pr5mN3smuWadSJeqcGPiMwHgpo+pPAhp/gVn2AaoI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jiz974x5FduD7pG0O5Mn4uVsdj0XSfH60AlXOVImuzBZyup3s8w3cdMlOb7BancDII3Yna+/HzwPjzHptEEL6qE1i86sa539FufJohfFIL9kz92WYG/r6uJNAvMNfrAbn61rXeGxZAQkY5+Nzwje+8d1u1xOYox4qM4KzsQF+E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAkdSaYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAkdSaYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC2FC2BD10;
	Mon,  3 Jun 2024 19:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442225;
	bh=o8Pr5mN3smuWadSJeqcGPiMwHgpo+pPAhp/gVn2AaoI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iAkdSaYc8R3JIwwc6kpPHKhHvP8jeerhWjEa18UfIH/CRWoCW9Cbf+uo+gUVZ3Bha
	 5m4c9Dp2Tb6Edu5AiCmnj4zJolqYAHrbPhctT+uXubJARbA0BePFy473iyZyZ+ECc3
	 KXfkpAVszlXo+WuDVDZ4A7lsFRBNWiIPNLPHuQJRmEpSTowbRwFN/4hskl9PseDsts
	 RtKHRcKM0nUVNhF7XfmPIaBk3MYyIhvIlCX23PJX8yMZOh2Ps/L20IJNYaUaFXNGuH
	 e4ZOKYhrA+Zx+RrpW/CET4dN+5T5AOtT6yPyk5AfglUuUYcbLdA2qg+99mjsXn312q
	 PaBUyy6KrejZw==
Date: Mon, 03 Jun 2024 12:17:04 -0700
Subject: [PATCH 096/111] xfs: create a helper to decide if a file mapping
 targets the rt volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040808.1443973.13723608880614277982.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap.c       |    6 +++---
 libxfs/xfs_inode_fork.c |    9 +++++++++
 libxfs/xfs_inode_fork.h |    1 +
 3 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4790efd3d..85f1deac2 100644
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
index 53ff82678..052748814 100644
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
index 96303249d..bd53eb951 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -260,6 +260,7 @@ int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
+bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)

