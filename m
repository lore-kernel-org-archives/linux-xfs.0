Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803BCBA2B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295799; cv=none; b=fnNoEcJ9i+c07z00mmdT9/O/ao+miUbB/RTPzjmch+yFGFd7khVA31lAmXpitPjbJTwWoFM86vKegJNnysYnKhaCYzlPRG+KZGKxWtuT0CMAzrOUEixfIQBzErS7ac6sVHofU2n/7UCDlRwbh/WECg5dPQGGarwKDDGUBYQE+6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295799; c=relaxed/simple;
	bh=KDc1SAMepebpEGm3nZnp+erxFSFxv8Ale13PfvjAhHw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oiO+7rM48jvAtXypQoxvsnm9oxrBPMAyBRk7+yJ2IbOaKNhC+KQug97x6J8G9TjaXI8ga8R6DFZ8EvjiIngDtw0V9p3diPzDOQyDjF21nQESIsjmoSuG7lxZAGN/tBUDuLpsd7gwUWTimoEot6Zdna5qw71u0dA1aH8sWzkkuBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNzohWvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNzohWvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFFEC433F1;
	Wed, 13 Mar 2024 02:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295799;
	bh=KDc1SAMepebpEGm3nZnp+erxFSFxv8Ale13PfvjAhHw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LNzohWvl+QDEv4GQnrV92SFwAbXLwxHMq3zKj38lIXKT7YLx00j+sGZ40FWKJ/XeM
	 RbV1bqWnBhVvqK79sg8eFJf8JcwEcVT899Jn7jhUyZfVpn7cchgYyGlejQSyp3eytg
	 C4WaYRLd9LiqU7h9nXWPX0G0OSGX57yeXaz5H4BpYOgP2mkkXkpb7LG9M14pFCwqtf
	 PnDXa2IJy6yKyYMkf+oSiRJIi89NErXPxd3tv2yE8a4pwgqCnsyutS2oSNaA8t/1KU
	 My4GlLgxVD/drPe1jxQB4ZmW8ef7qdcFOvNrLNocdtBP/BDiPJNVqVbAE6H7Hqwt4V
	 7jh3Ds8Js6/lA==
Date: Tue, 12 Mar 2024 19:09:58 -0700
Subject: [PATCH 65/67] xfs: fix backwards logic in xfs_bmap_alloc_account
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029432132.2061787.200173404480542852.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: d61b40bf15ce453f3aa71f6b423938e239e7f8f8

We're only allocating from the realtime device if the inode is marked
for realtime and we're /not/ allocating into the attr fork.

Fixes: 58643460546d ("xfs: also use xfs_bmap_btalloc_accounting for RT allocations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5e6a5e1f355b..494994d360e4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3271,7 +3271,7 @@ xfs_bmap_alloc_account(
 	struct xfs_bmalloca	*ap)
 {
 	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
-					(ap->flags & XFS_BMAPI_ATTRFORK);
+					!(ap->flags & XFS_BMAPI_ATTRFORK);
 	uint			fld;
 
 	if (ap->flags & XFS_BMAPI_COWFORK) {

