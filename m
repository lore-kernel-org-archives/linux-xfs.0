Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D0415279E
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924774; cv=none; b=tv7504zBTaCE9tuuMuK2tTR8n6fK92SPURDejOOnr4ZF3aUrYJdJAnpIO4/nrguLbDUqO2VLPdJQvIDoo1sNoXWsZVDPfNBcXvcxvZzexmN9tHgRCR9c+YqhgSVZmyx2fBggoOemeCOtIfA3rFhHjs2O8G/y5LVvNre+eWJ5MIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924774; c=relaxed/simple;
	bh=mJuaYl8WJmCPTKGCD/unmlzgKlMCXhKP7/dJ00+V3gs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUEbgaKPJH6m5IcDmWDlUvZ6EUtYILRJzdh0pXyF02XSPjOKwQ62YHe2RvU/IUkNXV/JW9MuwMRfpzDdZVUb7rPm943K6YecgCKoJgS3mgrpPQ6BpjPkNBz1X17VbP+02uBaYk3xkn7gDIN+rx6BaCB1VLSveSlMnTeKQM8PSo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kx11wU4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kx11wU4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3869C2BD10;
	Thu, 20 Jun 2024 23:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924773;
	bh=mJuaYl8WJmCPTKGCD/unmlzgKlMCXhKP7/dJ00+V3gs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kx11wU4esgEKBkGLCwfZmyGDOIoZ716tEXGNs/V4F8dNY49iTRNA1YXbnhXxaokJX
	 0qp+K6jpvJhz51rDyRD+wWBxN8iOT/6F/A0maHT1mcARZjSMQOHNAeiLAl9oG3Sriq
	 jW3zhHIJUa1N91s4IzusAFXDBSOg4fwR/fmGGLTXUXXA0WABEK7gKdlAtglusnsYXZ
	 8y3tmyuhl87JQ0cJLwd5lopLHDy0R5oCk5bAWlQ4T1Feh+prNPhjGhw+Rfsarc5BY9
	 kvXzVOUKZsFXlFSUV63lNjH/XEo8ob2VGnRNNLTDcQDyhWnsbx5vcOzoaOcuALB6HA
	 HCazVqd7fOPtg==
Date: Thu, 20 Jun 2024 16:06:13 -0700
Subject: [PATCH 6/9] xfs: factor out a xfs_efd_add_extent helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418800.3183906.2236284130046116354.stgit@frogsfrogsfrogs>
In-Reply-To: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
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
index 71eaec38dc79b..c1b6e12decdab 100644
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

