Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A703389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPF19ukd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB4FC433C8;
	Mon,  1 Jan 2024 00:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067800;
	bh=UsjfBHgyUYEe/jdja//W3C3UGL0XDewdg4yjonKyVs8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZPF19ukdSnGwd2jxMWnOn9XpvV4eljIkDseDrLNO2wu70/eBO2j3NAJGImRYrX+kJ
	 NDDv7TjycjHvzb4ifu4LgcJDGcJaNWbNT/Oz0GZMnGFfCF4es1Rg8UJnYa8iTFmBVl
	 EsW7ZEzctKqDXGs5PhHWClTDbSk3iiTMFDn5hgU4tHnHt8M92cTuIOJsMnL68D2RZp
	 zj5Y8Xzz0UNHHwhPk5h1hnNQv6WqEYAalaFhe+kNj2Qfgxd5EpAWioYcT0XYNQxpLi
	 n/Npo2iPJmSUIA3iUdAti3ak6babynCMkbCdwXVBIAiobAW3aqjHxIP3zXlKLhheAb
	 jZg4witCdFNUg==
Date: Sun, 31 Dec 2023 16:09:59 +9900
Subject: [PATCH 7/9] xfs: don't bother calling xfs_rmap_finish_one_cleanup in
 xfs_rmap_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014910.1815232.12389006596438249563.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
References: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
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

In xfs_rmap_finish_one we known the cursor is non-zero when calling
xfs_rmap_finish_one_cleanup and we pass a 0 error variable.  This means
xfs_rmap_finish_one_cleanup is just doing a xfs_btree_del_cursor.

Open code that and move xfs_rmap_finish_one_cleanup to
fs/xfs/xfs_rmap_item.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor porting changes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c |   19 +------------------
 libxfs/xfs_rmap.h |    2 --
 2 files changed, 1 insertion(+), 20 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 3c00b05d8d0..a1a9f4927bd 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2513,23 +2513,6 @@ xfs_rmap_query_all(
 	return xfs_btree_query_all(cur, xfs_rmap_query_range_helper, &query);
 }
 
-/* Clean up after calling xfs_rmap_finish_one. */
-void
-xfs_rmap_finish_one_cleanup(
-	struct xfs_trans	*tp,
-	struct xfs_btree_cur	*rcur,
-	int			error)
-{
-	struct xfs_buf		*agbp;
-
-	if (rcur == NULL)
-		return;
-	agbp = rcur->bc_ag.agbp;
-	xfs_btree_del_cursor(rcur, error);
-	if (error)
-		xfs_trans_brelse(tp, agbp);
-}
-
 /* Commit an rmap operation into the ondisk tree. */
 int
 __xfs_rmap_finish_intent(
@@ -2594,7 +2577,7 @@ xfs_rmap_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
-		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
+		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index f16b07d851d..2513ee36aa2 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -192,8 +192,6 @@ void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
 void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
 		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
 
-void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
-		struct xfs_btree_cur *rcur, int error);
 int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
 		struct xfs_btree_cur **pcur);
 int __xfs_rmap_finish_intent(struct xfs_btree_cur *rcur,

