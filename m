Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CEC139D04
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441678; cv=none; b=fr9+hWMgGfpvO/3HaUuTnU1oQc5W3QOl0TC/fzr18y92ySPu7czj7n4rzoa9KJqcHfb5WBtCmr1On6IDqETDgbCPQWUUFl7wy36b3amveG6zFRff8jMJCHu3gu8Sg6Gcz0Nd3C9WbrUlEovMfh9j12EndU/XXo4NJgxd4a8Bqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441678; c=relaxed/simple;
	bh=4zQZjq9LmkSE3T7IB8bE+5s5/TmE61Lg2rr9fvSOzAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sM0jjhwqlcAGZToaCQ1v1IV0LDhJPxkYVZ+GXgcYnEKezonkeK16fXZB8m/K5PTPCDR5kKiqyoEcZzcgyy72HiaYFnc6hGgvvK3UUqZmiPvOwKz8zlgwntxRg0H/s9YJtOHqNyXgFDPTg08ZUmoDIj4WytTvUQBe/ElEDVrFeWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIdFDuOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIdFDuOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CF6C2BD10;
	Mon,  3 Jun 2024 19:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441678;
	bh=4zQZjq9LmkSE3T7IB8bE+5s5/TmE61Lg2rr9fvSOzAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jIdFDuOpu7Y9mJkdfdTEmEZ61b13pJTacA0rp/jIOFUh0DRFWuwSn7lCkWSCiIRTH
	 AZyeGlzf3PoWc5ce4RTBpxEAreVft7wl0FOJsEcMXTfh74ncwJ7V84Lh07b+/mnjYv
	 lMIwqobGaZaEsDWLm8QinJ5HTAtBsW4cD+/yEWmi/jtiwnC404tX7ozppetSgr2gsc
	 UWvvtNt0uisxaqA8w1uZn0eZFWFMUrgCjDVvPS+SjD8xjMMcMAoufTpoujXHHBXwnQ
	 KBZ7aPI6EI+b1EMMShsujBRwBEpUC1z9+GDvZiUGgXAmDYoccrC75ZyWcGrQpaRg/M
	 HSNa0bx8ehtqQ==
Date: Mon, 03 Jun 2024 12:07:57 -0700
Subject: [PATCH 061/111] xfs: make full use of xfs_btree_stage_ifakeroot in
 xfs_bmbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040290.1443973.9588890200540775146.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 579d7022d1afea8f4475d1750224ec0b652febee

Remove the duplicate cur->bc_nlevels assignment in xfs_bmbt_stage_cursor,
and move the cur->bc_ino.forksize assignment into
xfs_btree_stage_ifakeroot as it is part of setting up the fake btree
root.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap_btree.c    |    2 --
 libxfs/xfs_btree_staging.c |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 611f5ed96..dedc33dc5 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -611,8 +611,6 @@ xfs_bmbt_stage_cursor(
 
 	/* data fork always has larger maxheight */
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
-	cur->bc_nlevels = ifake->if_levels;
-	cur->bc_ino.forksize = ifake->if_fork_size;
 
 	/* Don't let anyone think we're attached to the real fork yet. */
 	cur->bc_ino.whichfork = -1;
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 5a988a8bf..52410fe4f 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -133,6 +133,7 @@ xfs_btree_stage_ifakeroot(
 
 	cur->bc_ino.ifake = ifake;
 	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ino.forksize = ifake->if_fork_size;
 	cur->bc_flags |= XFS_BTREE_STAGING;
 }
 

