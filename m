Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633501422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991172; cv=none; b=GAkyreeWVlMEX89Nei9SVP0jyIXKUJWyOT5Cn+qXeu+7F8HGxDeIL5W4FSVDsJ4wItP68H1uuhKUD+bhbHI9GuuZmLSoVsvB/L6sq7PdZCxwYacLFHLQOZH7MRYZC7Fyg32GRALXZ5Ui8+YTiyudHDPBemr0eAw4cu8q0/rOzlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991172; c=relaxed/simple;
	bh=7Mq0g2KQK7UC5NH9QUNQiq8mh0X30asQLPmwbui2hcI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WF5KmBmvohW9uMBRuhPFiA1M4ycYi6DGYl3JBnwAHwtWU/wVxukItznYlow/NdHU8nTy6qRLNu+AOLG7s6ItJGXIwbUsbgesBS2RMRn+0r5rjg845xfEGFcA4IFJw33u9Ddl4HtqwZHFmiEaoSJDdf0hEIA5lhWWvxbgdTFMD/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaIm6lBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaIm6lBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C05C4CED3;
	Mon, 23 Dec 2024 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991171;
	bh=7Mq0g2KQK7UC5NH9QUNQiq8mh0X30asQLPmwbui2hcI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FaIm6lBOU3wZqFdeMh/MkutXC5erzESRwo2OJjkTwIkd9MBr1IYu7zY0jmToC8Fte
	 PQ2jUXJG+uuHJPloKGXgSnK4fEEqRvXCUiYTaR7aqhfKr3GIj8P1mzw2QS+r9lb6Dj
	 dqJ5kSOFICiwxOLFSiqwMXJHPY319BbzgkYIqs30vKUIwJ4tY679kRz+xQgWIyJ74g
	 5jvjRoOSheh7Hp5paY4+LAeYVkMtJ8NQCSppcYPPdd70vsnpIZ8fB6lZD99D7R6o21
	 FdM7jCQRs7iiZORIdUywJv5oVk/aQMXqqG3h6/S1A/aftRhS7ZztDbKY8ZdqoWgVSw
	 Ineem5Qat3F0Q==
Date: Mon, 23 Dec 2024 13:59:31 -0800
Subject: [PATCH 05/52] xfs: add a xfs_bmap_free_rtblocks helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942571.2295836.4230798236214437185.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 9c3cfb9c96eee7f1656ef165e1471e1778510f6f

Split the RT extent freeing logic from xfs_bmap_del_extent_real because
it will become more complicated when adding RT group.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

