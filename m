Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF82D1442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801671; cv=none; b=GJ3XasjveDyUnScsOYzyapYPHMfnwQQvUTROit8XyZtC3WshaU1T4GlbOn/kD9VSlW1QMiZNzn9YibGCq+acxYGVBs2oQcUCp6GU38XBz+z0fToXj5jeNfdRvlAwtNyORlCMNuRANLIXdFl59YhDAEjWo4U+aMpWphKFdTO9ccI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801671; c=relaxed/simple;
	bh=iazVZBhREmLNsr48OUa4DZt3CBXsribPprHDkhcZ4/0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F68c7W/l5ym9aujx7xPG4mocShOpbT8ILCwNAjAseNXW+w7FUpypDkpJiuw5tnUDN99YiTyUFycuNkJNoqmWNPShxybSkpwTaBlOjPN0F7s1cCMdF2s/W2JpBRlOAvxgJqKPpLmUY/tDqeYx+6cXxoT0fkuOh0971WseDHQpjes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PN+ToycV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PN+ToycV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25F8C55DED;
	Tue, 27 Aug 2024 23:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801670;
	bh=iazVZBhREmLNsr48OUa4DZt3CBXsribPprHDkhcZ4/0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PN+ToycVkQBYN+3ExKhDN0TkTufsgbxyvc7FXrAXkjPKwfvZMpRRhJO8FMIJsorHR
	 olLt9qB7aLE5/qs0OCM7jUkQzAcHCCrSnmW28w56IGPuoAzTPpfNNMdLICZh0Ms0V6
	 r6v6AbOnz+dIwVBU/j8prXfnTRITIjU6H/s52j60/7jNoj14fLe7GmoXt98UPX0HVa
	 kq/O1l6eC54C1+8qZmXgV1GOeVs1X/3i9Pz0119ydUkig84EbUUdAmmWc0dPbLlD+6
	 9xxTVNC5IqvclgT+Xq9q3Ln+ElR9QqwI0j6mlLSvHUWdnLoz26RW5EWj40N6XYwqCu
	 WYxUrwBLP4UMA==
Date: Tue, 27 Aug 2024 16:34:30 -0700
Subject: [PATCH 03/10] xfs: fix a sloppy memory handling bug in
 xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172480131555.2291268.18437550031190966427.stgit@frogsfrogsfrogs>
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_inode_fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9d11ae0159091..6223823009049 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -463,15 +463,15 @@ xfs_iroot_realloc(
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

