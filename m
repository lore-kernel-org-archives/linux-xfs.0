Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400081D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424347; cv=none; b=BQpEQTJ8GvjdYg4Yg2tYUUjGdoShowzUeoLl1TstRI7SpEA90Pt/6c9apnmDWvufjkyXifQ1787f9yAR7JKY8EgZ4Yzv9rKZ65ljI5fZnOztGjRcYo2lmBxtKbkpDpDiu5G/4xAnBp0/Pv/q4iNjhn217YoPmVU8FLCeJ0zPBzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424347; c=relaxed/simple;
	bh=2I+JnUdpDaLzU6VE1cXz7ZpwePMnSGnpwlSBW4HXbVA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVRxoByMnpuGuFVtv4zIGQI1aTjbe+M7Srd9TjXw1ZRNd667slJzAsvdPDO1OeYvloD42zS1P0irWq2BbZBHFqMOrk0PeOhdJZDRzPvPdvS7OWEiPkqg4pavrnsohM9CssTYJlJH4R3gySD74BJzhe1Ln9IWmSoN/G/obfeY3LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCQYQ1en; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCQYQ1en"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F79C433C7;
	Tue, 26 Mar 2024 03:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424347;
	bh=2I+JnUdpDaLzU6VE1cXz7ZpwePMnSGnpwlSBW4HXbVA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GCQYQ1enJGj5MfuRFJJjOKfAqmgRIz9fObl1WCsR0UhpLth6JVWWjHULEdVuNpiJM
	 TjLPdbnEeGpf76698QwZ5zUmk1tv2QOT35fTExClIvQrhU/vC5ULaZJ+Gcf268PZoD
	 VKocZqU0L0KFHKhAqcwfUv6mNI7r12UbfvImlU20eLRSf3Ezl0q21WzGzT9xXU1cku
	 qXWYbcg5kWRH7m1vgeDBuInQR/iyOPneijcKfNCGCeV6HbwXenNUDBfijW+h4+sewX
	 m8NGc4I2Wh2kKoyqBF8Emeh+GrR1HNQqNEjWTqQPsgzBh3dj+/MuIG37EpKxB+UcpM
	 Z6VETv/50XYzA==
Date: Mon, 25 Mar 2024 20:39:06 -0700
Subject: [PATCH 041/110] xfs: set btree block buffer ops in _init_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131975.2215168.11934702539145247962.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: ad065ef0d2fcd787225bd8887b6b75c6eb4da9a1

Set the btree block buffer ops in xfs_btree_init_buf since we already
have access to that information through the btree ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c  |    1 -
 libxfs/xfs_btree.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a7b6c44f1cc5..b81f3e3da049 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -682,7 +682,6 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	xfs_bmbt_init_block(ip, ablock, abp, 0, 0);
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2386084a531d..95041d626c4c 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1216,6 +1216,7 @@ xfs_btree_init_buf(
 {
 	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
+	bp->b_ops = ops->buf_ops;
 }
 
 void

