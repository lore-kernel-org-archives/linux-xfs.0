Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140ACB653
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372768; cv=none; b=H3j+efPnZccauO/7qeYPrjkh3JEPyiZnfylz4hJIyKNPxEocwmD6evzDrtK/6BYwPlqbZmHq8/bo39LAP3NRnEGW24RyyyNrih0BOQL8ctv8OX5q4o7ncq6vQfgSLep3sfr8yVbsohImIBCloq5QNvKGYJeUmA8AsBPzTw9b2pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372768; c=relaxed/simple;
	bh=DwWI+Ysm54Af+2PPpKtC9NkJyZXPnVHlza69Qm+aDWk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IhkQMOeDM3O7oMuFjC4vf4BgVc3WvmVQRSwgs73pSmZFSUFHm4R8jpi9eTJoU65Wau+BNpJT+Y6XBhtdViOJYaUXcLwV5wjnciQ6CxKLOp54gqKYVK/wnTnT7KWS/NPQnOLum9dbbDnQ+c18r9/1eji9IhSTclncsTJ88HXyRwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wewde9yh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wewde9yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E190AC32782;
	Fri, 23 Aug 2024 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372767;
	bh=DwWI+Ysm54Af+2PPpKtC9NkJyZXPnVHlza69Qm+aDWk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Wewde9yhlFW6xzL+XBHni4XHMoeNyu3T8EegwzMBaJgH5s56SgZDsTNKZH3nHozzt
	 kbBelykmwPSTFEp61FDz3RKXcLO9hiRSI27dJE8MtEhmLaS0oLBmRJ16DjiwtgriLh
	 MCwkqAkWXz+tXJltS3wWIBBWEemM+ZX1BzxgDue6GbvCvQGvyYLfrP+mhPlNiyKX2V
	 pOCSLJLrC49eky1TF7w9NnFBrVtOWWU8DOyXYyowYwq/R7q4AyfXwmiOVUodsNFyvY
	 nXH3eqvesECA8GkpLajWBaz4MRrmKQoN6K3VxwVoEDRjGZq43jbq5wgnMARWDwkltl
	 GdCXytnmb+4yA==
Date: Thu, 22 Aug 2024 17:26:07 -0700
Subject: [PATCH 19/26] xfs: use realtime EFI to free extents when rtgroups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088851.60592.2012898665553673543.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

When rmap is enabled, XFS expects a certain order of operations, which
is: 1) remove the file mapping, 2) remove the reverse mapping, and then
3) free the blocks.  When reflink is enabled, XFS replaces (3) with a
deferred refcount decrement operation that can schedule freeing the
blocks if that was the last refcount.

For realtime files, xfs_bmap_del_extent_real tries to do 1 and 3 in the
same transaction, which will break both rmap and reflink unless we
switch it to use realtime EFIs.  Both rmap and reflink depend on the
rtgroups feature, so let's turn on EFIs for all rtgroups filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f1bf8635a8cf3..126a0d253654a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5434,9 +5434,11 @@ xfs_bmap_del_extent_real(
 	 * If we need to, add to list of extents to delete.
 	 */
 	if (!(bflags & XFS_BMAPI_REMAP)) {
+		bool	isrt = xfs_ifork_is_realtime(ip, whichfork);
+
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
-		} else if (xfs_ifork_is_realtime(ip, whichfork)) {
+		} else if (isrt && !xfs_has_rtgroups(mp)) {
 			error = xfs_bmap_free_rtblocks(tp, del);
 		} else {
 			unsigned int	efi_flags = 0;
@@ -5445,6 +5447,19 @@ xfs_bmap_del_extent_real(
 			    del->br_state == XFS_EXT_UNWRITTEN)
 				efi_flags |= XFS_FREE_EXTENT_SKIP_DISCARD;
 
+			/*
+			 * Historically, we did not use EFIs to free realtime
+			 * extents.  However, when reverse mapping is enabled,
+			 * we must maintain the same order of operations as the
+			 * data device, which is: Remove the file mapping,
+			 * remove the reverse mapping, and then free the
+			 * blocks.  Reflink for realtime volumes requires the
+			 * same sort of ordering.  Both features rely on
+			 * rtgroups, so let's gate rt EFI usage on rtgroups.
+			 */
+			if (isrt)
+				efi_flags |= XFS_FREE_EXTENT_REALTIME;
+
 			error = xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					XFS_AG_RESV_NONE, efi_flags);

