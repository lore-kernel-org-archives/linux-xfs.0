Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A0585286
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817397; cv=none; b=Nau2Yu0czvKId1dofUOdfQnc7bUYhnJdUDtSXo6Jhr0YiLmZmCFBoLXZ+zHtLuiMg2KAI4XxPsYrbnX6VUQV8Ai+gt6QN4mxP59+s+h7zkXQciIbZvKuom5F69wIamiitoACKfa5o7BSbJl/yR2KPYJ28yPxIRnGGcY/IglIcTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817397; c=relaxed/simple;
	bh=rSGP9DsZIMjQQtBEvICGfGuaNGItPsM5RfChZmlFjyg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4CEcIEYag5KXnfp28Z6QMJEk1JNo6HrOAkp1SY+wzMRv8e62+S4DY02JYrxCK6hTxB67txE1OuhSIU7pCxRtHIBqeSm9iJScMh1F/7Vy9MV/JfpXBlkdEs3kGlA5f39HraLR7M6Z1wuSrj9yf9224Vp+jwv2pXQUxM9HVXUFUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHzUwPso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHzUwPso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7178C433C7;
	Thu,  1 Feb 2024 19:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817396;
	bh=rSGP9DsZIMjQQtBEvICGfGuaNGItPsM5RfChZmlFjyg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kHzUwPsoMAOmBoUW+dv/oEQKILfB+V3CTyCevSTnyU2StALYEYBd6GvV/yFaZSwYd
	 eQnDvD9RNaoCDKbcW1bc2qUvBEWRJnE/Z8zOYAKRXjSj6TH+vVRJOQoqpetHw06OLy
	 Bo+sGs16jB6/sJ2bKNmSNwgDJyZGvmWCdkGGeM5vGfMjiJL/GrV3V5K0joJG1d2QGu
	 P+uljlhDGqtY32tmi15ONCPwLuLhKQ2CL+Hf+j+h0Kcwvp1NoiUaNBI6a9ij5xpw6G
	 P3RiiyR4hvKJc5Ce9fddGB3r/kwhcAQKdysEJv2CBYj7H3zs/OWvXEFFA0HIb80xW/
	 Q3QthTb06FXlQ==
Date: Thu, 01 Feb 2024 11:56:36 -0800
Subject: [PATCH 1/4] xfs: make GFP_ usage consistent when allocating buftargs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336549.1608248.12420061312909852988.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
References: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
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

Convert kmem_zalloc to kzalloc, and make it so that both memory
allocation functions in this function use GFP_NOFS.  Also, kzalloc can
at least in theory also fail for small allocations.  Handle that
gracefully.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 79a87fb399064..ebaf630182530 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1969,7 +1969,7 @@ xfs_free_buftarg(
 	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
 		bdev_release(btp->bt_bdev_handle);
 
-	kmem_free(btp);
+	kfree(btp);
 }
 
 int
@@ -2018,8 +2018,9 @@ xfs_alloc_buftarg(
 #if defined(CONFIG_FS_DAX) && defined(CONFIG_MEMORY_FAILURE)
 	ops = &xfs_dax_holder_operations;
 #endif
-	btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
-
+	btp = kzalloc(sizeof(*btp), GFP_NOFS);
+	if (!btp)
+		return NULL;
 	btp->bt_mount = mp;
 	btp->bt_bdev_handle = bdev_handle;
 	btp->bt_dev = bdev_handle->bdev->bd_dev;
@@ -2061,7 +2062,7 @@ xfs_alloc_buftarg(
 error_lru:
 	list_lru_destroy(&btp->bt_lru);
 error_free:
-	kmem_free(btp);
+	kfree(btp);
 	return NULL;
 }
 

