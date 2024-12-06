Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4157148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529489; cv=none; b=fxVGlI2t6NutkF8GjFM4VJu+9M/4eNnuT8LNcw/Pl9yGV9zThMY1EECWCn6ecs5icnLC0dtWBha9898k6yZeZ3KJGxGETxm9t6w1E1ule0h5rPv0M06Ie7Zbg7KeFGMu7Z+56ewTZRcdhsRbIGzXIrMY96ghtyYbGG2cm25PJy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529489; c=relaxed/simple;
	bh=agiR1WYkMd/lgNtCY1gd8zgVSV2C1Y+V3ieURTUNGT4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E0625yUrdFQDDgyG4cuyQwrHj5VNh9F4ixJbqxpVYf2LueCA/DS7UOFmasjGIdWxK4CxvuigBNFWxvPlPxFE4dCvycozyNhnLQLJf80qfJy0bNgDGX8Ys7cmykykAwl90kA1yth4KLCI2t+po+gys54V3CNBrgdGvou69QRSRBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdMNZ3GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdMNZ3GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7854BC4CED1;
	Fri,  6 Dec 2024 23:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529488;
	bh=agiR1WYkMd/lgNtCY1gd8zgVSV2C1Y+V3ieURTUNGT4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BdMNZ3GEffTH0wI9YmxHp7P68mIkTpZKVuGH74TjJDqCigERxwhDOXs//HvXe9HXI
	 KyM+grinT0xcJ0Rm+MO5aIGxzN/5skRiPPm6lJtJwF9Vd8h8v0dntp75cq4ok13Ir2
	 OEJ1xHBWTsdmX8Mf0LALhRUQnFAlZh7atNJkNpPt+xHhNpdaQ9b5kXrtXtOoNmZQyQ
	 axgpmXoXg/eoYKdbc12ZnvzbXX8L53bq5UKVfmcR0xQePSISZgrjg/jC+z2VJL8h77
	 pTTHw9m4U6il+F+n0APd6q8P7cwIxRMp+Nb8CL75MEX2xMg0moWEsjTzNFF32lR97o
	 tV5X1hjgBtoJQ==
Date: Fri, 06 Dec 2024 15:58:08 -0800
Subject: [PATCH 26/46] xfs: use realtime EFI to free extents when rtgroups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750392.124560.13954744032184665483.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 44e69c9af159e61d4f765ff4805dd5b55f241597

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d7769f0e70005d..bdede0e683ae91 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5377,9 +5377,11 @@ xfs_bmap_del_extent_real(
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
@@ -5388,6 +5390,19 @@ xfs_bmap_del_extent_real(
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

