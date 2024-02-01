Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A85012FB04
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816662; cv=none; b=JhzGjH3xitHM3Fmz/2OfJsR6/vQKsKVLR/6f08Zgf2wd9WSpQ0wo0sOcByLxbzamI/lQiEcfGiJib04nxtI30VTUJ659D1cUO5udwESnT+sdks0qe0jj6ZawUbFqFNf8pV/bwqcGoCrxf+hpZ9ImQdkD1MIzLESZaTw3KLIIE5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816662; c=relaxed/simple;
	bh=fV6Lu8kKusoJWJwVEdxLL+eswIgKd8aVXFQraz8SnAE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkKC4iwOYxWkmDDMuAJTg8TXTY8NZeD5uMQXAwCIypEAYjUPeHUW+Z+KQ5dCfKwohgIUfmb2pUDoufIxOtXbMFf0SKGbRwx2C0UNbGfQmYS7Q/Av7IgXN7oi9pD2uom9XzY9qAPz36JYNcO0k1mURicgqBTy/VcdV9Asex5Ve8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMOn3E39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMOn3E39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D69C433C7;
	Thu,  1 Feb 2024 19:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816662;
	bh=fV6Lu8kKusoJWJwVEdxLL+eswIgKd8aVXFQraz8SnAE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eMOn3E39FkISloWkr4G6vkJGMFfQ70tM2SQUwG0Ewz8bczAwlJT4SF3EQtpE+yjgH
	 2SyEr6vE1BRL4ZaSI+Oh8jZbYNcTFGqJ05ahcwJlC3cmpz2dNcoZqeeHKTqcb/8Dcc
	 aZ0wFWPm8k/pqV1aYF8QhIvAoEqHeVnF245sG6PX/YIJv5t33IKNbV6CKLzMfKCvN4
	 ueq2KoClIMMby+mYDiEjN+t3eFjFDS/a8j8ryNUA6yPKc/ee88jPFzUo84BJQDDZoC
	 GX+RFgDKX/nYneRhrGFTMvcgHGZ2kutsKP2OEgOt4nYbjCi8C0hdysca0YVDeXKbJj
	 wUyjUPRhQySIw==
Date: Thu, 01 Feb 2024 11:44:21 -0800
Subject: [PATCH 18/23] xfs: factor out a xfs_btree_owner helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334233.1604831.8829185491535935692.stgit@frogsfrogsfrogs>
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

Split out a helper to calculate the owner for a given btree instead of
duplicating the logic in two places.  While we're at it, make the
bc_ag/bc_ino switch logic depend on the correct geometry flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: break this up into two patches for the owner check]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8777047725b92..95d9bd436e342 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1222,6 +1222,15 @@ xfs_btree_init_buf(
 	bp->b_ops = ops->buf_ops;
 }
 
+static inline __u64
+xfs_btree_owner(
+	struct xfs_btree_cur    *cur)
+{
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		return cur->bc_ino.ip->i_ino;
+	return cur->bc_ag.pag->pag_agno;
+}
+
 void
 xfs_btree_init_block_cur(
 	struct xfs_btree_cur	*cur,
@@ -1229,20 +1238,8 @@ xfs_btree_init_block_cur(
 	int			level,
 	int			numrecs)
 {
-	__u64			owner;
-
-	/*
-	 * we can pull the owner from the cursor right now as the different
-	 * owners align directly with the pointer size of the btree. This may
-	 * change in future, but is safe for current users of the generic btree
-	 * code.
-	 */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
-		owner = cur->bc_ino.ip->i_ino;
-	else
-		owner = cur->bc_ag.pag->pag_agno;
-
-	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs,
+			xfs_btree_owner(cur));
 }
 
 /*

