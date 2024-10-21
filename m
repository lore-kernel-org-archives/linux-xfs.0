Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CAB2CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548249; cv=none; b=Ba2sNpsmd6SGZGi719Qx0DJwN9xkADDaRFQLLAKdXAYYqcRvqAqVAA6JhMAqXgejdM0mbB1UVsDfITrIFDRRLekS07haRJhJkXzpKh20irwazoFhmOFICe7jyfo+tw2YZiGFe/l2ZReHqlujDJwLXphGxXkRaBGIT5LmuW0TyXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548249; c=relaxed/simple;
	bh=kgqlXPZJXrEv14UCZxjnwMZSGjAvtIJcgawEhVNUCpU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ywn41+upRR2C4iN21NS2G2oxg5rr2RuVndHJW6VFk+emnchrtniG8Jg7+gLqjp/qj6OeFvG7ithvnFKgnmJq6SVd+UoaweqgcP/n0Tp79FirOs5MQIEM54N8r1c44j3Rg+OiGa0k4Oh/1XOXcbfeHIScs94HmkFFLKarFjQTiN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uXSjTXzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uXSjTXzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49517C4CEC3;
	Mon, 21 Oct 2024 22:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548249;
	bh=kgqlXPZJXrEv14UCZxjnwMZSGjAvtIJcgawEhVNUCpU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uXSjTXzbYwGIiuxaCa/dFU0nuqJDnFadqrRqTRkIUEGiFpPsEUKE2TsJ+MPkrUQU3
	 WYv8Yr+nOTbu0Ist5jXzkBqw7BNhp8nyrkg/rj0dApcQUrGW87GmNQK8Jdj0+6EJ2j
	 /878oaapqyvFvpfV0eFFfOghrJUYSqkynCjNnBm40pF1DWKW3W+e0B8C6+GoX8hkVp
	 3AVO6eXikS+1/RTHbWhQw22ZkOMPXGwyS+74xWCwPOjhQUPRBJ/dE/Yv8OgbbBzsxq
	 KiD2SDvGhy42L+USIx2W7agEyCNMOAt+7YLvxvIY3s1UPFzeQTbCLTlxGJDyNwSLKm
	 QkjAXwV+6kHrg==
Date: Mon, 21 Oct 2024 15:04:08 -0700
Subject: [PATCH 20/37] xfs: fix a sloppy memory handling bug in
 xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783773.34558.13134276284969632973.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
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

