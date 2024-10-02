Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534C18F40
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831989; cv=none; b=DW0DViNz4RXG03I37jCrllUpE52RbEB+UyNRy4o9EyftpvwoI8XZQbnq8XW4UkRMuzBvLnM89/IuxZ9xqUpm+D7MdQCEBkWi+PMKzutuhBj9gFY0lMGHzxQxIK2mgfud7Y/w8K1jF2nEHB2ugzVtVBSUfMrf8lkoCAV9fNnia4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831989; c=relaxed/simple;
	bh=hecqyEKWMT/SzzsOpiT1rgBn+p1CXeMqOxr1TPR9Uog=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mn+XSLdYKsrKvpFHdbCr6soMxpageN3ItSb3ALFIM/R8v5wqq+8ybDSwu1lLFjfcpV+ny0X2TpMDOnXNpJkLTcJkWQ1pim4PW6Tb7S94zVu80UR0I8+TuIZad5tDyS7kFOP2A9MzSb1r9bQpralE8GoxVUJ2ikBh1Nsqzy5vscw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=of1mTws9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="of1mTws9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD0BC4CEC6;
	Wed,  2 Oct 2024 01:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831988;
	bh=hecqyEKWMT/SzzsOpiT1rgBn+p1CXeMqOxr1TPR9Uog=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=of1mTws93HvCw48Bta49K14GWoLpmOLxk3+qi8iUH6c6Depgjx4KSAQGPo9Hm+Emm
	 T4wy9J9cTrfm4gsW81ANMJc0gsKnXAp8nWLvIr8Gb0PH9VE7PavX7qaGUoPqZmmZhw
	 NDOQc+SxOqcw+OWdcf2YbmHz3KfvUfInn35Hl+w3brartaTwZ6eRq2Y+DwG/uB3UZx
	 hmtQ343PpLlaTbrZZsNkKUACB3g74BR2rv9DmBCsrl3KdBlZuQXBC/+1tN9yPmVN7X
	 IvEVp7zHbjFD2722Sve45r7TuY0pWdTk7jFcuLPIp1ZHysbyZVMkzHvnRZ07w5veVX
	 WxKqyf4WObC2A==
Date: Tue, 01 Oct 2024 18:19:48 -0700
Subject: [PATCH 46/64] xfs: don't bother calling xfs_rmap_finish_one_cleanup
 in xfs_rmap_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102475.4036371.8155569102523546322.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8363b4361997044ecb99880a1a9bfdebf9145eed

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
 libxfs/defer_item.c |   17 +++++++++++++++++
 libxfs/xfs_rmap.c   |   19 +------------------
 libxfs/xfs_rmap.h   |    2 --
 3 files changed, 18 insertions(+), 20 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index f8b27c55c..7721267e4 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -288,6 +288,23 @@ xfs_rmap_update_finish_item(
 	return error;
 }
 
+/* Clean up after calling xfs_rmap_finish_one. */
+STATIC void
+xfs_rmap_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	struct xfs_buf		*agbp = NULL;
+
+	if (rcur == NULL)
+		return;
+	agbp = rcur->bc_ag.agbp;
+	xfs_btree_del_cursor(rcur, error);
+	if (error && agbp)
+		xfs_trans_brelse(tp, agbp);
+}
+
 /* Abort all pending RUIs. */
 STATIC void
 xfs_rmap_update_abort_intent(
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 57c0d9418..1b5004b9c 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2522,23 +2522,6 @@ xfs_rmap_query_all(
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
@@ -2603,7 +2586,7 @@ xfs_rmap_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
-		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
+		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 731c97137..9d85dd2a6 100644
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

