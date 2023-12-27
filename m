Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2D5CA46
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnM07aJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5656FC433C7;
	Mon,  1 Jan 2024 00:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067330;
	bh=vO2GUB0nsjFF7OF/CsVwsF2rHSpjUwC5GwF4SHP2rYg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AnM07aJBUTnUN6rNefIv4DSHlMiPLSOxzqFrYoBZLakj7N0hGWvmAXBGQWeeFGKPR
	 3v1PEYYEl8m8twwVKvVR36Pw92pfeXPrhCgz5qO74IAm9z9eN8yGByg8sr596NS61X
	 EVmi5Rz10gmO/v9X+N1IwWjwmoWQOsFC6LkG2enOe04CS8vTeLumjo/G61lyxkjM07
	 ZejU36zpN+Vtwl+45LHqU1H3ueuqFNLRtHTeSE4iVf+zedFQ/jScscaSdfc4W2qvUz
	 Gf7CKB6h47pB9ZfZmF/JJVDxw/6EHBAHTjMl/p6rgaI/cMm688qLUpkDCmKLY3tzSH
	 EO/V6vIpVbSpA==
Date: Sun, 31 Dec 2023 16:02:09 +9900
Subject: [PATCH 04/14] xfs: fix a sloppy memory handling bug in
 xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013255.1812545.1192872913964641674.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
References: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_inode_fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 05f7ada0ae3..765e174999d 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -478,15 +478,15 @@ xfs_iroot_realloc(
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

