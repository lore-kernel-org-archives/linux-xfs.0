Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819ED85286
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817209; cv=none; b=QSecOggzbDSIC5N2WE2UiSGaUCtD5uL4q8HQL0+aycnUK0ni+UMI0NaDO0US+iWkDhygLwovyX6oW9UxKcnR3ZDK2Er+vp7dYqgpZrSWoGOBqxhJ73ytu+fvAKD8q4IZZbxo1Bb26WjhHsF38r4ou0VRDkVub1E0bZCXQASJ7Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817209; c=relaxed/simple;
	bh=9jEPMiY+UeKRS8yD9N2d+o9VTRmETP3UnDVgf+ApPjs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uB99s3fVBZXGRdPZzd8hsQtwvh8G25kSybtU/1pMuIIx1N7TFrIDU/qFZueA7LCfBrHH4WalnLVybxg3sQh8afZtlcB0JpoTfhljlFsHjZru8u9ZXSWvo2U79PRaIIM0E2zDyNinAYkedj4kcIWIG99A23FzyuEBZLzaEBHO0QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uyx/jnH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uyx/jnH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55189C433F1;
	Thu,  1 Feb 2024 19:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817209;
	bh=9jEPMiY+UeKRS8yD9N2d+o9VTRmETP3UnDVgf+ApPjs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uyx/jnH9op9ly1mXUcrwUIkb6bt8o92vwNe3IZp0ryHslshE7Hxr7ftGIwSyxzwTn
	 FxsuVYzWYaJT0j6pi4xTibJCvkEVQxG2kjTPErnXUMihhWP93I+5t1slwhXg6rZ4PJ
	 KUFfrmGSuE3bS5oneTT4aPe4fGt53V2Jd1j2VYd1LyaNkBWvcRfRLBy96BHTHMC8Ug
	 S//S22Svgst2JY2+XhKO7jcSgfst9lAN11bsLp/WVayVe7eAJM1RmhX4M5RP/RWZus
	 wGP2pnRAaaTgGrKuu94gVqTrvhIsUHXbs46bT++1FV6ipwnaRkR/hnrE/byU9RArle
	 fS7Erv8EO7o/w==
Date: Thu, 01 Feb 2024 11:53:28 -0800
Subject: [PATCH 03/10] xfs: open code xfs_btree_check_lptr in
 xfs_bmap_btree_to_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335661.1606142.6455809928925662313.stgit@frogsfrogsfrogs>
In-Reply-To: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
References: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
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

xfs_bmap_btree_to_extents always passes a level of 1 to
xfs_btree_check_lptr, thus making the level check redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 347801f1ba7b1..5537483c2e539 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -568,7 +568,7 @@ xfs_bmap_btree_to_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
-	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
+	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_verify_fsbno(mp, cbno))) {
 		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}

