Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDD3BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECglR0Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D939C433C8;
	Sun, 31 Dec 2023 21:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057791;
	bh=WtCfC1km0cnIz4MiNPu67DMbOYE9XVwbADf3hGPck6s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ECglR0EuLETTP1zU+PRdty4zXn5TslmpflfC644M6DhbrnRmyODf1OUwG0dcqxTFN
	 4wGXvtJVtWoeGKzaLUwyU1vOtMge5HXtECM89jaPFMWiwq2J08UeHQrKH3uNznamAT
	 88+ggZwqXwZ3HNbhhT+dczZzu+rUtVUWLMDBhucBCwzPTrqyzlAgErAwVwjGOEa750
	 R8qdEkbeMvoTFvq7aU86SXZpE6AJ9+E6PYfDTcvXq96lFk0N6azy+RbV4frlMV3Sb0
	 M5aE+beFZqOHwmkANDLGi7V2GeJakTkJxacDEXbszcNsg6TNSh9nJREIxrJp1ashY3
	 SMLvvc/OEVOAg==
Date: Sun, 31 Dec 2023 13:23:10 -0800
Subject: [PATCH 04/14] xfs: fix a sloppy memory handling bug in
 xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847432.1763835.4565356947263944745.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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
index 9256499589408..08f3d003d5383 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -480,15 +480,15 @@ xfs_iroot_realloc(
 	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
 
 	/*
-	 * Only copy the records and pointers if there are any.
+	 * Only copy the keys and pointers if there are any.
 	 */
 	if (new_max > 0) {
 		/*
-		 * First copy the records.
+		 * First copy the keys.
 		 */
-		op = (char *)xfs_bmbt_rec_addr(mp, ifp->if_broot, 1);
-		np = (char *)xfs_bmbt_rec_addr(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
+		op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
+		np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
 
 		/*
 		 * Then copy the pointers.

