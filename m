Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFDEBE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a76LyxLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13014C433C7;
	Sun, 31 Dec 2023 21:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059059;
	bh=6KRe6XnEAtY5yLLr8+ngA1i0vYhj/t6UsWAwP8Gx9jk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a76LyxLhp1Nc5Y5+CbuC57HCJqnizwjIbgalQK5r9SWeMjbzudYyWz4Sq0LBcrAEc
	 BCWDPbZdZuOSnZ66WSP+ofDQCdItqWxGrWavixMCcmyiySPr/NjqFNAN7DAxpvZ+sn
	 F2OWA7+Ma/EHuz57bms2bmMCjJ4KbR147aV3N9U2WOgEHZibyXm8UiHE3O6M47Sy4A
	 J6+eBE6wifW/7cEOTN/YyOxy+23MMYD9gClt0HYBE6yygGDWYM4/5In3yTOHVMf1Ng
	 N05vQ8tXVywQkCmFPn2GKaFHJmWgtLsgnEJSyI72OFLJvfiBtPh600AUxicx24gRfF
	 tAAElsOF54srA==
Date: Sun, 31 Dec 2023 13:44:18 -0800
Subject: [PATCH 09/10] xfs: simplify usage of the rcur local variable in
 xfs_refcount_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851037.1765989.5240045203461279649.stgit@frogsfrogsfrogs>
In-Reply-To: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
References: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
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

Only update rcur when we know the final *pcur value.

Inspired-by: Christoph Hellwig <hch@lst.de>
[djwong: don't leave the caller with a dangling ref]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 0d1b17a4df6a1..ccb2a1fa5f589 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1341,7 +1341,7 @@ xfs_refcount_finish_one(
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur;
+	struct xfs_btree_cur		*rcur = *pcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
 	xfs_agblock_t			bno;
@@ -1359,7 +1359,6 @@ xfs_refcount_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		nr_ops = rcur->bc_ag.refc.nr_ops;
 		shape_changes = rcur->bc_ag.refc.shape_changes;
@@ -1373,11 +1372,11 @@ xfs_refcount_finish_one(
 		if (error)
 			return error;
 
-		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+		*pcur = rcur = xfs_refcountbt_init_cursor(mp, tp, agbp,
+							  ri->ri_pag);
 		rcur->bc_ag.refc.nr_ops = nr_ops;
 		rcur->bc_ag.refc.shape_changes = shape_changes;
 	}
-	*pcur = rcur;
 
 	switch (ri->ri_type) {
 	case XFS_REFCOUNT_INCREASE:

