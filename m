Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533E81E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192032; cv=none; b=ZD2JyTp/sGBKvSSwih6J5PLweDwiULliFgTm42Z+pudZ4V5WKo9Mcl+x9gIFsVHizI2elO6u8bcci/3usP8z5km0tTmDqCHH2NPl7tvehSz3X+fDsuA0XnFKmbmnZHTZax4QgTY+gkBCrvPUz0XM3sIUb/3iA50huAAsKgiqbuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192032; c=relaxed/simple;
	bh=ugdZLp8NfxKQy/0klcxbfwdvj+NjGEDvTOY+1bc34iM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=spC+yG7ddROFG6NvFy1xynNqOmj65ZxTvgCMMrSvgiY6snnjKwhW8uNgpdR3CDYrPduLu+8AGix66UPT/ndpzvDL9qJ1bN3RPCyHt7fGERBJid14RPa15RPmDDSCbIjOMFVwF63KVMIPqGjKKHwMbAdg3rn6mCaGPtZNHjpCxKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dgsAGRWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dgsAGRWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E07FC4CEC3;
	Thu, 17 Oct 2024 19:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192032;
	bh=ugdZLp8NfxKQy/0klcxbfwdvj+NjGEDvTOY+1bc34iM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dgsAGRWaMtCRkMQg/LVEYIPuyC1K8468CpRMPe8B28JrOHdQhaz9eWfQk7va4mpr3
	 59jnccG/tK9SweJS8cNfs2UPdL40yGjhhU+eyw5JZAGCxl9epDz8tUC6b/km34vhSN
	 Ia1FMrgAulIv1bay5c1eE12XBscVhAcSYAvq6PV/5vEyXr3zgfkQbQsur+qjPaUwYh
	 N1q+3aPNdtTGrO+T5NF1tA8glTff3e22aq+sPMOngSjbWXUTNcFGRQ3DKtRkMytYqs
	 AKk4djlotauPh9KaZRoCdS7qO99AeBPqBCZaRI5AjWnrwSUcd7Vn+mjnqKrxY7h0jk
	 DdCrsqx8HqBxg==
Date: Thu, 17 Oct 2024 12:07:11 -0700
Subject: [PATCH 19/34] xfs: use realtime EFI to free extents when rtgroups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071996.3453179.4291910414964467609.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 482b4c0cd6b193..b15a43c18b0a57 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5383,9 +5383,11 @@ xfs_bmap_del_extent_real(
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
@@ -5394,6 +5396,19 @@ xfs_bmap_del_extent_real(
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

