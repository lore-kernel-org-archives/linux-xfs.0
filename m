Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308F0652
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816584; cv=none; b=fRmO1Tx6DJMMtay01eibhCcakw0iYI4RuWj+teROJVZ1pHS0Ml6GOcLyDdYKyBr0HCI3jc8Aw2b8UL6CbvCt8HjS+dHY76c28xH1lLTsF2BtG+AmkrRZssYmpj6SdZsVKnkxlQe78Km3oCLzDZrvIyAxtoVLV3lrIuQiZu2NHu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816584; c=relaxed/simple;
	bh=0UhuH06RDNpUN3Y7Z79Gm0Qa7Hzop/ak6pdsChyIPKM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m4v4rrLVcnrOoOHgqa4VtDAz0oFcPlmdJmUy6nz5HTigSdGU/7F8umOgMdVOThlMEhBy0KnfMp4aTAZqA0nkaqN3MP92rDSRXVYb4RQ3nlYNu/cNaPm0qKPxHRTrVQiugzFcfskoQSSVd0oKpfFTEg3S7ziz1w8czC77Mop8CXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=stu4+LC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="stu4+LC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A2BC433C7;
	Thu,  1 Feb 2024 19:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816584;
	bh=0UhuH06RDNpUN3Y7Z79Gm0Qa7Hzop/ak6pdsChyIPKM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=stu4+LC+eheVEgyxIdNcgZV/N2kBCmeerdwLgPZk0qKfekWLwswetNYT52NgplxYJ
	 mkV85L+7IumHv7NOfygIifhVOPJrsTfYHma0R9zrJyn6BxHX7Ak2RytyQIjF3tSF+Y
	 fY0Nw3ePWsy1kN83tTqj5IN0gLxqEbAREAalQg1dwxiMppXLYNDbmzIk7dL5r1hPrp
	 FhoCjiIPVw2UXFWOdtrNpbYo/M4FtvhdzqVnerBL4Dgwus8SLW1W7Bz/hijjhUoGfH
	 hF3X+bRbQCxURLsqXUoX2a4rTebBQcxlMHxIkGFqqsMeUg4wioPgNg97lJduRIelyy
	 3V80JFGULYI0A==
Date: Thu, 01 Feb 2024 11:43:03 -0800
Subject: [PATCH 13/23] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334151.1604831.11088705241046074640.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Convert any place we call xfs_btree_init_block with a buffer to use the
_init_buf function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index afa9d15fe7884..6927bebe66292 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1228,8 +1228,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
-			xfs_buf_daddr(bp), level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
 }
 
 /*

