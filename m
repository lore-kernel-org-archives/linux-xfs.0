Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EE5157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225043; cv=none; b=dvSdOtguliHite3IfhOOiC/ZrUzahAyJ+ycXz1dFtN7uO4XfJAjuKuJkTuH1EsnAIhV5sVW+9u4K/IaqodCgX1SbeSXQw773VEgV50D1mSrv8Lgj/fX+PIJPdfUil3I9oWVNljJNzZL2qVkij5IIDC2STfV9wjXc8rLovaZhPs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225043; c=relaxed/simple;
	bh=0Vrk5NKsY/HEaNzVPcx5fnlZrDl+1YoUz1wbRyXHntM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iofVy9I0iIQdweib/Z0e3+lKvkbONutqu1qOsz0wSSwx1diFPh8O+2zT2Xn3Q+PIiAZeuZ9I0kk1KuZpTrER1B7pv4cEBSCU/RLBQzYgzrbJ/YxF9D60hBu9v+LnBtug7I29OMM1xdf1caniOMTUaaBaogHzG8y7xrVoeJQ5Oq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LpQo3W+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpQo3W+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF6FC113CC;
	Mon, 15 Apr 2024 23:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225042;
	bh=0Vrk5NKsY/HEaNzVPcx5fnlZrDl+1YoUz1wbRyXHntM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LpQo3W+PpA7pflVCfOzmjQ+vWvDd+QNzzdgi7q9aCU1NRJh9O5EbI8rS0iY+yvSOB
	 9i6pwVi7PMm91gHjYp8Pb81zoK1InvBiE52y8QdGycLb4gLMv+IFDfqtnbim5vbvA/
	 AFzi/o1ib6CLPvPtBbCCapZSl7lYKWujSzNxcEoZ8D84Se/UhWMm2PAWIPZUFeiad+
	 cFDSiEOqt5j278kpELA9869wXkZSZMELkAGhdp0yBA25EBE2VZ/TpzgXHVykvqDA45
	 nHCPJwbuXHlZXT9fPZLWdivkmNT7Esvg3wfqw2gjSQf8afmKAyqKZ1TMfwA3NHUo2d
	 3dBBrCFXMoMqQ==
Date: Mon, 15 Apr 2024 16:50:42 -0700
Subject: [PATCH 6/7] xfs: flag empty xattr leaf blocks for optimization
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383182.88776.4989234917228761012.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
References: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
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

Empty xattr leaf blocks at offset zero are a waste of space but
otherwise harmless.  If we encounter one, flag it as an opportunity for
optimization.

If we encounter empty attr leaf blocks anywhere else in the attr fork,
that's corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c    |   11 +++++++++++
 fs/xfs/scrub/dabtree.h |    2 ++
 2 files changed, 13 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index ba06be86ac7d..696971204b87 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -420,6 +420,17 @@ xchk_xattr_block(
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
 
+	/*
+	 * Empty xattr leaf blocks mapped at block 0 are probably a byproduct
+	 * of a race between setxattr and a log shutdown.  Anywhere else in the
+	 * attr fork is a corruption.
+	 */
+	if (leafhdr.count == 0) {
+		if (blk->blkno == 0)
+			xchk_da_set_preen(ds, level);
+		else
+			xchk_da_set_corrupt(ds, level);
+	}
 	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
 		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused > mp->m_attr_geo->blksize)
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index d654c125feb4..de291e3b77dd 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -37,6 +37,8 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
+
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		xchk_da_btree_rec_fn scrub_fn, void *private);

