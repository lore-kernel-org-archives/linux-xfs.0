Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A975228
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608798; cv=none; b=byxBQ+y8NYZZJlXkzi9l9P2i+J51MH+bTbikXhLiIlgU8knpUWHBC+iT86T+rk14KGSfazU3BmkTZHoNgA3TtP433I78267YmtYlW6psumFldkVnhoHg72c/LbfKgSe6SzHUAp+weDZaYIW/aZLc+4wuICPUrNsyuXCx+o9sg2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608798; c=relaxed/simple;
	bh=1aRdlvhQ6ZhIIqd8Ni+jpV/PQ3EH3/AfO01oiIgS9QA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TixATxjvr+VIj3zvtOafCh1gUtrQLyAsIwlWVt0fbplYKRJureHyo3t6oyGpXmYNkZdBdiEOCcvPkI2gOxnF9z/tiLzhv3bLz54Ds1xE1uYZYz/qaiCH74cx2LNbuK87LfeM4Qf9ENCxaaBM/GKuXqiLtYsdkgEd3u/lHFSaBEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vz9UeJ20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vz9UeJ20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6916EC4CEC5;
	Fri, 11 Oct 2024 01:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608798;
	bh=1aRdlvhQ6ZhIIqd8Ni+jpV/PQ3EH3/AfO01oiIgS9QA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vz9UeJ20rAWFI+b+k2lEkLCewY581TELrnb9R5WGZ0oMvDGKiVf9vf2qxLyxJAXsa
	 lRJntlP7Ol5xmQvk1tWWAgt7iF1SBGvvxkRfE5YXutCZTI6+J8u4lqLIaAT86hlGfH
	 PtuRDAMTqYhL4NDYUgwpiMQ4VICJ00Sefnq7iVBpk/a8olhZ6VvqFJ9fk5rI74EVtz
	 5Hr/qDb8Xt1+WNnizE4QvEnL+leff501xVLZxc1xCrpONiVYCSvq5HF2BxgNrZ56HC
	 QlixXBNHsavB7CM4iz98XYMzTaBeGZXdV/mewMPK8hoe/zIs5BlFcjhOg5iCLsRpi0
	 QWP4H9rAbuJ9w==
Date: Thu, 10 Oct 2024 18:06:37 -0700
Subject: [PATCH 19/36] xfs: use realtime EFI to free extents when rtgroups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644569.4178701.4048525239197605099.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de6e90939d93b4..14eba7ae601622 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5435,9 +5435,11 @@ xfs_bmap_del_extent_real(
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
@@ -5446,6 +5448,19 @@ xfs_bmap_del_extent_real(
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

