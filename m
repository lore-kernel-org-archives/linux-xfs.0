Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AD19CC31
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301998; cv=none; b=SZBg+YYbWrAkDBhfwDQtwnNPNM8kwoD5JxZrzrCGb9bAff0CYLhnKfgGegn5UaweYfgdAFq9QpKwWnfR1v7zxGjbqZkcibIdVY3G96IvhhVDa30JGjgan5lUGMozyJfIFT2Aj76VEQPswD9uwN6kRDzIuqSvJe6P+OKxewqrTgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301998; c=relaxed/simple;
	bh=DCI7kwTH88FpIBoGdduz/HMziG2sNxAu1noSRoXa/bc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZCEgjfrpAdZpAfk4FM4sbmmPFRK/ab8vpy6N2vQsiRUkWHtdFHCHUUcygrV6JaEFgGOWfFfmbdGp8e6rzI8ye4/dAwWoXewLnS3N6WIj7QpT560B59RfXKUAzSh0zzKBuPrng8K1odW5VfSKb6pELNOoFhA8l4WImzK+dlC4nVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsAZ8RKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsAZ8RKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D26C4CEC2;
	Mon,  2 Sep 2024 18:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301998;
	bh=DCI7kwTH88FpIBoGdduz/HMziG2sNxAu1noSRoXa/bc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DsAZ8RKq4PkfpEYRMT20pW1irs7av6Ip7I7aLFN+ek/FHTAm0iwml6yZhDcYMIqr0
	 Bf2MlE2u0oP/AU0lb0yiYpaYzMYIbay+wesjLQj3lSZBcJK1qzeLn7axbc1CvG0d/v
	 3JnKnReVC+cEAxSUqzGemzX17B58Z7IPa8cXy4XoYnhX5vU40OHGGKGWaSlcnT4BIo
	 +bI4vx3oih+kcyYO7dLpPybf+02HQM74gbRXXRWcw2FVho1YbD1GfCJPHpLE82NzVJ
	 5GefY8LqcDEf9i1DxuN+ZHQNH8SnVxpLZqx8bObzzlSONsl6l15cW8Rt5aDu3HNPyH
	 6oL/gJuNXgYnQ==
Date: Mon, 02 Sep 2024 11:33:17 -0700
Subject: [PATCH 3/3] xfs: fix a sloppy memory handling bug in
 xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530107644.3326571.6313363096496638714.stgit@frogsfrogsfrogs>
In-Reply-To: <172530107589.3326571.1610526525006344754.stgit@frogsfrogsfrogs>
References: <172530107589.3326571.1610526525006344754.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9d11ae015909..622382300904 100644
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

