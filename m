Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402498528B
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816928; cv=none; b=UQtjBlBaG5IGzKdg1manKLJn6Zcuc+Nrwb1f03yfXptTa6OHI+yKEYclaY9X8/urSHmZc1g+v7TjCLHYrB4Vgu7shFdy6fThTu8sv4nQKUmf/lYJzjFmmsyy/g/TTNY4dUB5dwEAd5iD3uKOkFjbpcYIZgrrqy9V9TkQE23vw/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816928; c=relaxed/simple;
	bh=44JCoXg51x0YLanAOuPz39xz0+1YnGP+srgvxWNliZA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+dyjks5c50cMtpIjZ20Fm90sAmnjlCDbbH6F0I5nrDq7bF8NcqzCPuP2fmYFSShBb0/Ufs5IvM7pNcMkFFdnB9lCNzX46MUp2C8zzr0NnRi46w/QqH6kO98sUoU9xdWVlz5kzN2fRQq0HjyOAtVCBnKWnZpiBVgwIwTaZ2Wamc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlFgzxFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlFgzxFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1B8C433F1;
	Thu,  1 Feb 2024 19:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816928;
	bh=44JCoXg51x0YLanAOuPz39xz0+1YnGP+srgvxWNliZA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OlFgzxFpsgMGlnUr7FXd1uqQBXw9G0g8rs7/H39td5bA/LKqxZAqi2y6QH33ug6sv
	 jFrWAtfpv9imwBXDKMx7SUQ8QEdI5DKIOM6JTlu3tYhie0Dt7zmNKlZMx74E4PlXHc
	 tolc+Qwa/YYWZEW76P0W4kx8VV5E2+AevR+I6nxrQeMggevN2ge+rDWZOujWqdk55L
	 zSVlNuPUyQ1jJrXn0pUR81vHItTKTDYhEkMN68zpVyTi0I4pz8akGBQWI+H7BMkNND
	 aAaNzOktFlFlZb7GgdChViNyaLrWEUPJlHY+QLVZnYiS8rdebS4JAyITeKA6PXxkUT
	 2Sq5PdOg43cFg==
Date: Thu, 01 Feb 2024 11:48:47 -0800
Subject: [PATCH 12/27] xfs: make full use of xfs_btree_stage_ifakeroot in
 xfs_bmbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334980.1605438.13581766684654450693.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Remove the duplicate cur->bc_nlevels assignment in xfs_bmbt_stage_cursor,
and move the cur->bc_ino.forksize assignment into
xfs_btree_stage_ifakeroot as it is part of setting up the fake btree
root.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c    |    2 --
 fs/xfs/libxfs/xfs_btree_staging.c |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index ec0b970157ae1..3b6f14196c8cd 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -612,8 +612,6 @@ xfs_bmbt_stage_cursor(
 
 	/* data fork always has larger maxheight */
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
-	cur->bc_nlevels = ifake->if_levels;
-	cur->bc_ino.forksize = ifake->if_fork_size;
 
 	/* Don't let anyone think we're attached to the real fork yet. */
 	cur->bc_ino.whichfork = -1;
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 6337a5b928bd5..32568ac053b13 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -133,6 +133,7 @@ xfs_btree_stage_ifakeroot(
 
 	cur->bc_ino.ifake = ifake;
 	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ino.forksize = ifake->if_fork_size;
 	cur->bc_flags |= XFS_BTREE_STAGING;
 }
 

