Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A7148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529161; cv=none; b=RCVAcqy6IdthP1pie6d3M5smUZi9LnAzoux30B8UX0sWHWf67CmOMKe8qVqkDmbuxz73+l9ISOu3ebeW5ZkLPjAo0TH5yKHlxwkeo42Sz+wuyKRtoGyk2HV8q/LmdGFq6byQyk0dFOV601WHWUB/00JA/fZ2bcU1X3Fx7UUfMz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529161; c=relaxed/simple;
	bh=05orekBSb+am0y8x9sxp0JAsGSsm0+SkLZ6OBSkHi7w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ki7AZ0liS3Q830mbXc11hEW9tYacyXk8fvJgBsDfU42iOo0OJHq9x/xUpPz9fLHiZa+Zf1IDbc2D24dJLo7+oS8LMu+ToN1o6GTlXXbOb+mLW5MRn7blck8u5wUmvBUnIOuRFXOdPaqL6vQ7KlcIa49GHSpXb7ROq/RJiwbSU3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGaB/hBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGaB/hBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C4CC4CED1;
	Fri,  6 Dec 2024 23:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529160;
	bh=05orekBSb+am0y8x9sxp0JAsGSsm0+SkLZ6OBSkHi7w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HGaB/hBoJ+f9OyEcrLenndXij8tHeI5DI+LTs2PARHe8Fd3jZnuuEn2CPlpzWpi0V
	 9myVjf6q0hfWqjfgfEdDjyngeKblLbYPJCFIf39CQB6hmEUxnJ68sfe4YdnepY3r/k
	 rCqS3xLhS0F74JxnRQm6LFX6m45TKsHm6+Z6+BOMr6oaxoVHrL/kAKKWZFmCWTQoip
	 9VklwGKSXJ71cBKaW6nvEJCXYh/LX7POrKcI7bG0HWZRzlunb2rrEZ01T/iL4l7ext
	 4LD+e+viomqGVVqyUg0SFP39Z26meI2VyJ0kKDfuSfToZrkIZt2YhIDhwfDvmqTkv6
	 iFR2/85nqLkbA==
Date: Fri, 06 Dec 2024 15:52:40 -0800
Subject: [PATCH 05/46] xfs: add a xfs_bmap_free_rtblocks helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750071.124560.342274181577888842.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 9c3cfb9c96eee7f1656ef165e1471e1778510f6f

Split the RT extent freeing logic from xfs_bmap_del_extent_real because
it will become more complicated when adding RT group.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 99d53f9383a49a..949546f3eba470 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5110,6 +5110,27 @@ xfs_bmap_del_extent_cow(
 	ip->i_delayed_blks -= del->br_blockcount;
 }
 
+static int
+xfs_bmap_free_rtblocks(
+	struct xfs_trans	*tp,
+	struct xfs_bmbt_irec	*del)
+{
+	int			error;
+
+	/*
+	 * Ensure the bitmap and summary inodes are locked and joined to the
+	 * transaction before modifying them.
+	 */
+	if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
+		tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;
+		xfs_rtbitmap_lock(tp->t_mountp);
+		xfs_rtbitmap_trans_join(tp);
+	}
+
+	error = xfs_rtfree_blocks(tp, del->br_startblock, del->br_blockcount);
+	return error;
+}
+
 /*
  * Called by xfs_bmapi to update file extent records and the btree
  * after removing space.
@@ -5325,17 +5346,7 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else if (xfs_ifork_is_realtime(ip, whichfork)) {
-			/*
-			 * Ensure the bitmap and summary inodes are locked
-			 * and joined to the transaction before modifying them.
-			 */
-			if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
-				tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;
-				xfs_rtbitmap_lock(mp);
-				xfs_rtbitmap_trans_join(tp);
-			}
-			error = xfs_rtfree_blocks(tp, del->br_startblock,
-					del->br_blockcount);
+			error = xfs_bmap_free_rtblocks(tp, del);
 		} else {
 			unsigned int	efi_flags = 0;
 

