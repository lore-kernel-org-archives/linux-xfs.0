Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58D35234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346768; cv=none; b=DeuB4bGDdiCuG14bCr5p5N/c4H+ICL/eYQQ/uH9ZO4D/116jKk/mP5/CLhhgSn/yIJ7Fol4IIioVXP3v1rJX08OWORwSEd4IFRWrH73tuwNLy2JPOzZ+bw9gVY5+ONefRvMdSpP3U8GVal2AQNFrb/s5S17oPmvu2GN4+hQF/+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346768; c=relaxed/simple;
	bh=Tsa++AlzTjPdAcRh7kjHXOYdUlbJ+BUIIC0IL0cohfo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6KWienqg1S4An0DEiXXCrlhAqVH/jlt2/VOzrVNcZYKsm8S42k0vgIhzJ4ZQvn8NdRf11zuc7rYQSHgqPVlbpfPpYsyd9o7B1XeLZ75iQDYJE7Fhrt5F/zoSdGRC+Eb0aUzNjVzOrkNx4KcTbnv1m2eB4wEbkQ+tEhmTj+yl/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxVlQj7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxVlQj7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BA8C2BD11;
	Wed, 22 May 2024 02:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346768;
	bh=Tsa++AlzTjPdAcRh7kjHXOYdUlbJ+BUIIC0IL0cohfo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TxVlQj7qBJhuuNqD24xiTlNLiEZxQZS5oRwxyIouFNjmfUdFF1qUucIQ5y6k/Uc63
	 hZBJsIsIiOetqHsKc4omegLof71H1zaX7xnqx7tGf8iB1wSK6CMMg1Ed3T4vyspssl
	 6Ye1k5pdWkO3wk5zr42DDJPwStfiZJrqEvtu9NQp/3+4JmDi2G57hfFk5IJ3zcV13i
	 S5xBUqfW533xCvmr2aAfs0qHbaNjmq7OvnOGWdJpkuf+Vqi1h/i+N0HtpKHXv6UTVd
	 IBuPIX+9P+bpakdsmkATZG8vNAlCFTPfsaAAKD530DuFd7c2xoIzt8fBA8CA0sWBO6
	 D6jgpCpAjHdaQ==
Date: Tue, 21 May 2024 19:59:28 -0700
Subject: [PATCH 041/111] xfs: set btree block buffer ops in _init_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532327.2478931.18293299527362508752.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index a7b6c44f1..b81f3e3da 100644
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
index 2386084a5..95041d626 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1216,6 +1216,7 @@ xfs_btree_init_buf(
 {
 	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
+	bp->b_ops = ops->buf_ops;
 }
 
 void

