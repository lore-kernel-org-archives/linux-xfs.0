Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22E113FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991501; cv=none; b=T1baPs3M3CCm3cxwU6Jr4O7CqE7QlEgHw3F5GJhSbamNIVvcqiKNyL4Qbo9bU5N5NDJ9I9JWFOHbNNE5NwvnvKgrBfWs7bpYcIZ3LInyqmKnbTkPK1jIYaXZMV3ztB0qKDx13gEtCCtmgEGRM584C8VQHnULRVVkp1CxVV8sQeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991501; c=relaxed/simple;
	bh=agiR1WYkMd/lgNtCY1gd8zgVSV2C1Y+V3ieURTUNGT4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUZA+0Hy4UP4ZcnzgCRlRd6nfYRt4+KIU9U2Yrp1sklSUDejN8Irq1Y3iYUzi8v8TO9+uo5v8rrFoCqJFsMD+5qGe3WMzI9Ybg1x32aB+ryFavB+ruZu7tOPkpG4xhmSn/ASoqK7OTys1TmVOZ5FX+CZy0cRtL1yWup1ET2pVxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Omx2i9VE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Omx2i9VE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EA0C4CED3;
	Mon, 23 Dec 2024 22:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991500;
	bh=agiR1WYkMd/lgNtCY1gd8zgVSV2C1Y+V3ieURTUNGT4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Omx2i9VEYaxgiONxgrUXMEaOXsao7NZnnePsO0uLrYQKV2cc0dJ0cins7bbel92nE
	 VkQmSbqorMx9J2j4m1lFzJVNfeJCdigvCf/FENtuD0yI7r+6L359U/mhtoiKT+b6ka
	 dKQC+w/EcWeAr/gbN8Pnf3LxlF6Rlb0D2OhVvxUqCgnxoKihTMDKA6M7z7il0LWY7H
	 xHXGl4c2a8D0DSD3FGjZDapgwp9R5q/lbM1uLpdtxN7TVyD63KEooYj1REMNkcBssT
	 heSEzKXF3Z8hOqGdXnpquTgeSMTFtfcpS9RgCZxnPaCPG369Mxi3iwWQSWxfR272hJ
	 aAodcoD4lWU4Q==
Date: Mon, 23 Dec 2024 14:05:00 -0800
Subject: [PATCH 26/52] xfs: use realtime EFI to free extents when rtgroups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942893.2295836.6013954655878489290.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
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

