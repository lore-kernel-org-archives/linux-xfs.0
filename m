Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C675A7EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9q1zeaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984DCC433C7;
	Mon,  1 Jan 2024 00:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068753;
	bh=s+V1zOTwA0bWE3ugeKtBxta3Efg786Qq8zZj/X9MHuQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q9q1zeaLh1yYaVLwzzFf8Gt7fETjDBqCsb5qKwHeNdj4RmNISZA9qutfKl41vpd/5
	 JSAOY0ATo0gBhmR2uyeRWKassS9rlf0dqiepxKxZIG/Slon30gmnZJl9KWxwv1Jf2B
	 I4gHtpMJld85ZlT+ZoGlh/opYOr2U+fKp9VOk0kycrSdB9Fxa4DQMvX0sqzzMi6mIb
	 lq4rqeIy9K1lxdVMszGCQIcQWG52F2uN2gfud7ZlAGlrY09uduZCRmyPd4raAg/u1q
	 oTcaOqPUp8n+hbpzYOVrVPiVCh3xLCuRp5YgngtjPjmooUs739/PFAXKcKpuDmg/H4
	 JuwNaLuUz5rLQ==
Date: Sun, 31 Dec 2023 16:25:53 +9900
Subject: [PATCH 8/9] xfs: simplify usage of the rcur local variable in
 xfs_refcount_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016727.1816837.12198095586835417075.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
References: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_refcount.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 635bbf7f99d..5cd279786ce 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1340,7 +1340,7 @@ xfs_refcount_finish_one(
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur;
+	struct xfs_btree_cur		*rcur = *pcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
 	xfs_agblock_t			bno;
@@ -1358,7 +1358,6 @@ xfs_refcount_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		nr_ops = rcur->bc_ag.refc.nr_ops;
 		shape_changes = rcur->bc_ag.refc.shape_changes;
@@ -1372,11 +1371,11 @@ xfs_refcount_finish_one(
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

