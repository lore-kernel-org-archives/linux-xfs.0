Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61183BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZbodacp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4606C433C8;
	Sun, 31 Dec 2023 21:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058072;
	bh=ygi/eQdVo9B8BclWm4x8gvybxVeDqDnSvV2ChTK/dR0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JZbodacpNo9oDekeM+INIsOYqTYVVgyJ0fZuuHtOvywesjYMLBmeaA7x1ZlqDoPy+
	 QAeSEhkyMsu7IdjKC1l753u9Gn6VUgSUTDfMu3wJM+UbdVIqlQ3vLsiyy5+vNYEbU8
	 yu+IVh31Oxi6QGf8ccTgSYDYvwj+KVLkG4y6LnSyehYFnJqcx0J7eStLqxJiXeWLe4
	 o41+c7Ba0yqrXXXCUiiQIfzx0O2N5s+FWqiRkaKOlHyK71OmSCQWwJel4vbLv0934R
	 oPhnQHIay2Y5g8JpNBTL/oiJmSfpB3uCvG5xLW9seN2p3ObzyC/T88I9Eqw4RlCAS1
	 h3zJsNcUHwPAw==
Date: Sun, 31 Dec 2023 13:27:52 -0800
Subject: [PATCH 6/9] xfs: factor out a xfs_efd_add_extent helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848433.1764329.14224111487773657261.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
References: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
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

Factor out a helper to add an extent to and EFD instead of duplicating
the logic in two places.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 9d141b9876572..be932390bd1f7 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -336,6 +336,22 @@ xfs_efd_from_efi(
 	efdp->efd_next_extent = efip->efi_format.efi_nextents;
 }
 
+static void
+xfs_efd_add_extent(
+	struct xfs_efd_log_item		*efdp,
+	struct xfs_extent_free_item	*xefi)
+{
+	struct xfs_extent		*extp;
+
+	ASSERT(efdp->efd_next_extent < efdp->efd_format.efd_nextents);
+
+	extp = &efdp->efd_format.efd_extents[efdp->efd_next_extent];
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
+
+	efdp->efd_next_extent++;
+}
+
 /* Sort bmap items by AG. */
 static int
 xfs_extent_free_diff_items(
@@ -460,8 +476,6 @@ xfs_extent_free_finish_item(
 	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent		*extp;
-	uint				next_extent;
 	xfs_agblock_t			agbno;
 	int				error = 0;
 
@@ -490,14 +504,7 @@ xfs_extent_free_finish_item(
 		return error;
 	}
 
-	/* Add the work we finished to the EFD, even though nobody uses that */
-	next_extent = efdp->efd_next_extent;
-	ASSERT(next_extent < efdp->efd_format.efd_nextents);
-	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = xefi->xefi_startblock;
-	extp->ext_len = xefi->xefi_blockcount;
-	efdp->efd_next_extent++;
-
+	xfs_efd_add_extent(efdp, xefi);
 	xfs_extent_free_cancel_item(item);
 	return error;
 }
@@ -525,11 +532,9 @@ xfs_agfl_free_finish_item(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
 	struct xfs_extent_free_item	*xefi = xefi_entry(item);
-	struct xfs_extent		*extp;
 	struct xfs_buf			*agbp;
 	int				error;
 	xfs_agblock_t			agbno;
-	uint				next_extent;
 
 	ASSERT(xefi->xefi_blockcount == 1);
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
@@ -542,13 +547,7 @@ xfs_agfl_free_finish_item(
 		error = xfs_free_agfl_block(tp, xefi->xefi_pag->pag_agno,
 				agbno, agbp, &oinfo);
 
-	next_extent = efdp->efd_next_extent;
-	ASSERT(next_extent < efdp->efd_format.efd_nextents);
-	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = xefi->xefi_startblock;
-	extp->ext_len = xefi->xefi_blockcount;
-	efdp->efd_next_extent++;
-
+	xfs_efd_add_extent(efdp, xefi);
 	xfs_extent_free_cancel_item(&xefi->xefi_list);
 	return error;
 }

