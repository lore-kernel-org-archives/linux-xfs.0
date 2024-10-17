Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBB921D2C3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191660; cv=none; b=uHGXOltFxWAjdk1kGqdSxGZDpenCj0o38w1iPwVmHRI9PhJANK8ah2bGgB1krHRfbtmVoByj7SasQ6QR5J727luI8OMRgE+BcJd61pgwMJJYLQkprzLHlnknV7+1xlVhNEQoVfo7dT4cHq7wlmx8XJMM3Z4hdOnv8nAtilXuPCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191660; c=relaxed/simple;
	bh=2W1iLkIlOj/0fe8zPN/f4+U0UFKEBrj5KgP5ofJWPeo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ODHuq42OUASF+/upG7md5SKDh3gDRfp4X1gMqlpaLU03YdJ78oKwzpFs8Uz1H4qEupqWCDwVIXT7fEmQkjJEAwdsGsOwdFAH/GM/2eOC8wJT1cAjqA13mIlHSr5pOw+pi5NEeJVfhvbdI8weTIba1gchD9MLneXyFLEINxHnAdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcFKQ45Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcFKQ45Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3917EC4CECE;
	Thu, 17 Oct 2024 19:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191660;
	bh=2W1iLkIlOj/0fe8zPN/f4+U0UFKEBrj5KgP5ofJWPeo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UcFKQ45ZMeMECf+WDJMCUy9ha2OGAA4yAr+13gkx7vKxWxLLM4thR9PAKPOOL/+Cc
	 ZMKBbYA1Sopft56nEBKPio+U0ZK/EqYCDhCvxJbMcal7U/B+vwk4y0R45CwtrJNrcA
	 tGPNXOhhVcJlnk1n9f7ybLkDb1FbFa0ar1upm4Gz0KtTsJqU6hVBDOS689qJrwyDIc
	 dMMUOlWD5+FbwS4tkUZkpIRqOq6V8UFaQk6bL30/k2Ld5RpNs6s/Xd+gZglGY1eiAT
	 dR/TY7tGRak1dKoq752iLgvnipJAGJkyH61mUlEURkf96rT81OdaZ0HXGXa7YLFVHs
	 Kcf1DwLhzNgQA==
Date: Thu, 17 Oct 2024 12:00:59 -0700
Subject: [PATCH 07/21] xfs: add a xfs_bmap_free_rtblocks helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070517.3452315.7168581408977096667.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
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
 

