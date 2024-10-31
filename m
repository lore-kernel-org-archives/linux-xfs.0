Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6A51E2007
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416435; cv=none; b=bQ9kU8orbGiD+BrXi5dPSbvh9qpIuUi9ht26vY769Xr019YPDwtqKoByLt7kYl2kxZSFEfLcw3RxhUSGLR9bnPRWnqo8qv54k9lEPpJShLWnEJODM4SQ3K2QQNFKBjw1Va7fna1th7BEhUzLdpy30/imUXkUo/rk4n+AwNHw+cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416435; c=relaxed/simple;
	bh=kgqlXPZJXrEv14UCZxjnwMZSGjAvtIJcgawEhVNUCpU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fq2/NAtF9KF6gPk93/kP6Gaapgqfr4FLp1XfEt5OC3cIn5dJJBHQ78vj16Qte7cxq15/nGUHbxOhKlbWym+fz+yTczqlthHsN7us4yb14qnet6jY3ZYqckVnVgwD9Hp/jqsqRYimUZxBCbIFpzRjQfMhjvSbUorl9hcvIMcBNtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuINVTLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuINVTLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021F6C4CEC3;
	Thu, 31 Oct 2024 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416435;
	bh=kgqlXPZJXrEv14UCZxjnwMZSGjAvtIJcgawEhVNUCpU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KuINVTLoolb2ROr7sdwdJ9SJoLWHWtAIzCcM4Eym39PKg3rm9zAIyWXJguzv7B8EC
	 PHgGXRFq86sjjCryYqSHwZ57jKdj0J0x5EUk6CplX3nd7AshkZ9gP1sDK02V6HBbXB
	 kuo+7bm5hWySgT81f7r8pmABJSoKVgXhhDFQ5RkARuoGJX3RDQSSP5iatbOEVIEO2p
	 AxLuMVpCCJ2jORXo7uCOTZpqjgb9+3xPkatxwWcdN23kZ+ihLVodHRGT/8tqJsu8+N
	 h/atXr4aNt8GBTNutYBNnXjhUQ7SzZluNmRwCk1RfaLF+H8sRip9VuLSHG2dgqzI57
	 pgOp7hqzX7RXQ==
Date: Thu, 31 Oct 2024 16:13:54 -0700
Subject: [PATCH 20/41] xfs: fix a sloppy memory handling bug in
 xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566223.962545.8866628096975435349.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: de55149b6639e903c4d06eb0474ab2c05060e61d

While refactoring code, I noticed that when xfs_iroot_realloc tries to
shrink a bmbt root block, it allocates a smaller new block and then
copies "records" and pointers to the new block.  However, bmbt root
blocks cannot ever be leaves, which means that it's not technically
correct to copy records.  We /should/ be copying keys.

Note that this has never resulted in actual memory corruption because
sizeof(bmbt_rec) == (sizeof(bmbt_key) + sizeof(bmbt_ptr)).  However,
this will no longer be true when we start adding realtime rmap stuff,
so fix this now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index cd5e2e72954292..8f06e5bc72b3ac 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -461,15 +461,15 @@ xfs_iroot_realloc(
 	}
 
 	/*
-	 * Only copy the records and pointers if there are any.
+	 * Only copy the keys and pointers if there are any.
 	 */
 	if (new_max > 0) {
 		/*
-		 * First copy the records.
+		 * First copy the keys.
 		 */
-		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
-		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
+		op = (char *)XFS_BMBT_KEY_ADDR(mp, ifp->if_broot, 1);
+		np = (char *)XFS_BMBT_KEY_ADDR(mp, new_broot, 1);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
 
 		/*
 		 * Then copy the pointers.

