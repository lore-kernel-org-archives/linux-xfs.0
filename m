Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCCF8563E
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816615; cv=none; b=fHPtdZTygH0vp2pca0e3yZDmwKi2QsXVxkW3Bw6jPS7S9BSfh3FzAw1Ie6C1DxG+PWEysQo002+RAGOSIcVgZaOPYZF3yL+PBnQ24xp7YuF5CD1pUVyHK8J4YKuBtGS102CbJ8V1NVYTxePS1I6xMfS6ZczFaCLQBFEsPyV/O9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816615; c=relaxed/simple;
	bh=7QKQh0r1BshyifH2s2ySngvOMVnSA3ZC7bXYt7TzqdQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7qLuyEHoM/Ot/JxdGB0qnT1WALQt3U5SEllZrYvR1d5ms3wJwZ1Z3XohQhcY8oZA2gKe1+hFoltzYLtM+o5F3trjbpBPDTTGSXzGOx8Vt9ltjPhUXwQw4k8GyL0DyohvSoj2KcXCh8GZ3bVJLURCq8WgvbuQaeHg9Op3qXJNls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsdOf8EW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsdOf8EW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34963C433F1;
	Thu,  1 Feb 2024 19:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816615;
	bh=7QKQh0r1BshyifH2s2ySngvOMVnSA3ZC7bXYt7TzqdQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LsdOf8EWO2zSvOO5BSWCuypVEs/dKFhdSmqob0cX5F8OOnFpp+W/1qN3TqfGoHE5o
	 8flhrbItDlHSL0bH3KSFopo5I7Qu0C+GtZszVShE7SxLvGYSVDVKnY/yzFkk1MQ9hL
	 v80K2JdTxPc0Ymt3pyUkVtQZnQeZRXGCXKLNMo3r1A1e6WFmpdRpTrXGCTcVlhufh6
	 3zjwMYhspJac2fpJ4ICCLF2wjwLEQOaUf7Rn6QmNszsK6tr+ZtwX5gn2RPN1/jjTSq
	 JTB4yqdEpe6MYYmPt1QIf1wMNG8bel9Rcne1H/obsrUD/n7PQJg92CSJfIDtY/qkYH
	 quoMiB6ngY0KA==
Date: Thu, 01 Feb 2024 11:43:34 -0800
Subject: [PATCH 15/23] xfs: set btree block buffer ops in _init_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334183.1604831.420595875498683666.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Set the btree block buffer ops in xfs_btree_init_buf since we already
have access to that information through the btree ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c  |    1 -
 fs/xfs/libxfs/xfs_btree.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fba89843c578a..d519feea84ec1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -688,7 +688,6 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	xfs_bmbt_init_block(ip, ablock, abp, 0, 0);
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index cb2ba43b9b0c2..a42d293e91bfd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1219,6 +1219,7 @@ xfs_btree_init_buf(
 {
 	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
+	bp->b_ops = ops->buf_ops;
 }
 
 void

