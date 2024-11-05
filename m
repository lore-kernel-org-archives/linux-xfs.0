Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C76B2141D0
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845545; cv=none; b=n6CF/xTnlODyOY+bxKN/y5a0oSPDQXLvF929GtvBEDzMrrxOY9dUZWFPfmUKSrMRyvp7w6DxVZbU37xylPpmFXh4zPv1fLI0hTParr9liZzTgnfG74bQihsSIzgPsos+oc/3gvRdBvBBaxJML0rnfjSXH2hzOdrU7/FhwgeCSCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845545; c=relaxed/simple;
	bh=2W1iLkIlOj/0fe8zPN/f4+U0UFKEBrj5KgP5ofJWPeo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VMMb4Cv/c2vF+MUq9f3ge019unZ8w7BnW+26WJv8ryAAdZHj2FB9aZ+cHOZ0DuQ6LuNHdzIqmRzTnZS3tX40kxNhvjd5VN+ZCwidTFLctJ1Pbkp1J21VuahBtIiFWXcsuVjFg69HHzWZJPIAcHa1jL5zzrVBToCdKRRMhZ3/BKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jrkw1naC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jrkw1naC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14266C4CECF;
	Tue,  5 Nov 2024 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845545;
	bh=2W1iLkIlOj/0fe8zPN/f4+U0UFKEBrj5KgP5ofJWPeo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Jrkw1naCJCYBlpNEw8tEm51+vj7ibRYIM6WLgEellsTIC+QjF+oO/gP7hgpN6xttu
	 4zusNRG3oLkvVDKu8Y8nFP54OsFkWdSTbZKLCF8y2VSYgGkAXOoFmrHR+vPSI4rY0B
	 Y/8poWnp5GlqIiI0Kz+FyQFtdO7OjSZXrlEtkq6q2HPW/EACgBhz0bVfiVbvIVgRPe
	 M/Q4vBkZlzjhe48W4hVwAst+qGYHIE40S5hWjdIY2CxUfVpbwM5hOUS7VQfYP3Me7b
	 ECJ2sTfWiFC37XGaAcW6XPn8VIdcW4Kw19kkisr4RUpCLRsLL6T7CFo/fJf7llfebd
	 CDC8boPkiHjcA==
Date: Tue, 05 Nov 2024 14:25:44 -0800
Subject: [PATCH 07/21] xfs: add a xfs_bmap_free_rtblocks helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397059.1871025.5729070229823060933.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Split the RT extent freeing logic from xfs_bmap_del_extent_real because
it will become more complicated when adding RT group.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7805a36e98c491..4d9930ef42d9ae 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5116,6 +5116,27 @@ xfs_bmap_del_extent_cow(
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
@@ -5331,17 +5352,7 @@ xfs_bmap_del_extent_real(
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
 

