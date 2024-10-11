Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB064A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608251; cv=none; b=q0ywGMmj3Zoek+7MOGo8uzO94myOHDS/O1Fic3LSnWdyjjtJi+BMozywQ4JBk7vwHkC0PtYAm7RF/3lxrecW2w+btsA/HIF1eBNaaxmUUldQbFPD7nMIc2dgKvpxMTwpt7AbOy3hI75dBU7QkN8V92RtzfLfoAJrrsJw5ev8kgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608251; c=relaxed/simple;
	bh=V9EFFrJ+ZBnJi2auAmlp5v0bMW006iSp9yahyfJEXM4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FzspLj59N7oIrsnC4X9YmnkNdRqykW9J8VQrQLdVYWWY90qf96o/qDHRdd0ZM2iHFT0cNZHUEvRDGGqXMF+MYtiGXaPqS9Z2GEVqvJtsbsOUVm4zgplrvRctP3v8JdeVmTOWU7tL+HZFb1RrPFS6pJnMVFWGfqvs0xF/loCPOAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajrf7oKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajrf7oKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1A9C4CEC5;
	Fri, 11 Oct 2024 00:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608250;
	bh=V9EFFrJ+ZBnJi2auAmlp5v0bMW006iSp9yahyfJEXM4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ajrf7oKIbYTcsIU5Umpwxxj4rksOhbYH2J/by4WGFF7PEXXk4mU4dU/Gc0Sxjt9TR
	 3W37lopaO2okj8ZIqM/1Me9dRvuJALKTcZdD3jtMPcq3DgyqfVSb2T7AS8uRJgKBa9
	 9E26o2qCYfQ0BhZ4hHpDUQN0oNIr6p9Cotcfow+q3WCxnkdmmBaTK1SlT1Jf1z+9BR
	 bRlbkfmsnKDHpLnbUZ88eJHzk9mUi1kSqJfSePNlJQ+cDJ5DBsZgtCXeCWh3lMnmJn
	 wumWDNj7KeC6Z5FXTYLezZJICa9KjIxXN0X4VAWfYylZzHUyq5MPLJjgYOuWtv3eBn
	 blw9xPlq97wBg==
Date: Thu, 10 Oct 2024 17:57:30 -0700
Subject: [PATCH 07/21] xfs: add a xfs_bmap_free_rtblocks helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643067.4177836.3397010252008603181.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
index 2cd9dc07dd1a06..ca9b0ea115c893 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5168,6 +5168,27 @@ xfs_bmap_del_extent_cow(
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
@@ -5383,17 +5404,7 @@ xfs_bmap_del_extent_real(
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
 

