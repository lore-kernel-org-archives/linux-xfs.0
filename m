Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A559BBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Km4Zh/1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD02C433C8;
	Sun, 31 Dec 2023 21:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058292;
	bh=MGympo2E5bNaiyqdCdJW3IuPNrSs9pR2xDkHBho01bQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Km4Zh/1BKgtQB9uUemT2I0y1KQiUIl56oNjuIxZ8dcXlU8jUqq1Oset2nNJ4meX6y
	 9lWeHREHsDs92B7xiA6nhPXmCIOpgJqcU5NcGZaQEk0xYVM5e3maDwNjJyfTIeItUD
	 F3mnbUV/G9iTtahXZD95533LQzO1go6FZ1JZl0dsrD+ZFNPmmdKIa+AgmnM85VA0FB
	 viuV1Do4KRIPd6G7RBnqgIqXNEGX3ZUVQBlawbpTO6XqFGpLcxcWLZUWhwka6Z0P8J
	 aZnuLkGt3fAhkBvZ14FCAKFtLkAYpxZZhkSAOBfXPBakRkrVimWkCQ6x1K2HOAQ0M+
	 00YuCKEpS8XJg==
Date: Sun, 31 Dec 2023 13:31:31 -0800
Subject: [PATCH 09/10] xfs: simplify usage of the rcur local variable in
 xfs_rmap_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404849378.1764703.1106478667153934520.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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

Only update rcur when we know the final *pcur value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[djwong: don't leave the caller with a dangling ref]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index ba33e51a3f2b8..3830f73607f32 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2561,7 +2561,7 @@ xfs_rmap_finish_one(
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur;
+	struct xfs_btree_cur		*rcur = *pcur;
 	struct xfs_buf			*agbp = NULL;
 	xfs_agblock_t			bno;
 	bool				unwritten;
@@ -2576,7 +2576,6 @@ xfs_rmap_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
@@ -2598,9 +2597,8 @@ xfs_rmap_finish_one(
 			return -EFSCORRUPTED;
 		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+		*pcur = rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
 	}
-	*pcur = rcur;
 
 	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
 			ri->ri_bmap.br_startoff);

