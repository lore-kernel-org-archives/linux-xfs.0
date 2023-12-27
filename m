Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9A37ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVATvFcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB17FC433C8;
	Mon,  1 Jan 2024 00:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068738;
	bh=ueLlzfXFAadRNJc9jd8/4anPR0BS+wXbDVygxXzMqdE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iVATvFcDbYamNA2zBc/ozfTKQXgRzvcqPoscCNFs5kMBRIH575McsT4ZFsfz10xM6
	 PT5X5y72hTU5rldsu5p2jn7Hwvg31rdgh71B6X1L3Tn2RyD9/dpYEjUB8txYBGNNiy
	 Ag+pc6/Ko2Gg7rtyN3BNn3l/17yHRALYxRdIftu1nBeXExUQ3pjucHFIJtuPtu1un4
	 UKYjGzImoq5CfcMNVtDu1o2rBZ+JWlHUaProoHbDsTOoIFcsOk/b9lVjytmF7wZLhh
	 hu5Dofu3F9WbS6Rnnw3Ic96F/y+VMrYAZxisL29MTnaAVIXabHc/4gTPPnp5deUORJ
	 Lk07Fd/rBUl1A==
Date: Sun, 31 Dec 2023 16:25:37 +9900
Subject: [PATCH 7/9] xfs: don't bother calling xfs_refcount_finish_one_cleanup
 in xfs_refcount_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016714.1816837.16218175860775218003.stgit@frogsfrogsfrogs>
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

In xfs_refcount_finish_one we know the cursor is non-zero when calling
xfs_refcount_finish_one_cleanup and we pass a 0 error variable.  This
means xfs_refcount_finish_one_cleanup is just doing a
xfs_btree_del_cursor.

Open code that and move xfs_refcount_finish_one_cleanup to
fs/xfs/xfs_refcount_item.c.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c   |   17 +++++++++++++++++
 libxfs/xfs_refcount.c |   19 +------------------
 libxfs/xfs_refcount.h |    2 --
 3 files changed, 18 insertions(+), 20 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index e056c3b449b..58a18c7876d 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -587,6 +587,23 @@ xfs_refcount_update_abort_intent(
 {
 }
 
+/* Clean up after calling xfs_refcount_finish_one. */
+STATIC void
+xfs_refcount_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	struct xfs_buf		*agbp;
+
+	if (rcur == NULL)
+		return;
+	agbp = rcur->bc_ag.agbp;
+	xfs_btree_del_cursor(rcur, error);
+	if (error)
+		xfs_trans_brelse(tp, agbp);
+}
+
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.name		= "refcount",
 	.create_intent	= xfs_refcount_update_create_intent,
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 3ae68ea22e3..635bbf7f99d 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1299,23 +1299,6 @@ xfs_refcount_adjust(
 	return error;
 }
 
-/* Clean up after calling xfs_refcount_finish_one. */
-void
-xfs_refcount_finish_one_cleanup(
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
 /*
  * Set up a continuation a deferred refcount operation by updating the intent.
  * Checks to make sure we're not going to run off the end of the AG.
@@ -1379,7 +1362,7 @@ xfs_refcount_finish_one(
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		nr_ops = rcur->bc_ag.refc.nr_ops;
 		shape_changes = rcur->bc_ag.refc.shape_changes;
-		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
+		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 01a20621192..c94b8f71d40 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -82,8 +82,6 @@ void xfs_refcount_increase_extent(struct xfs_trans *tp,
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 
-extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
-		struct xfs_btree_cur *rcur, int error);
 extern int xfs_refcount_finish_one(struct xfs_trans *tp,
 		struct xfs_refcount_intent *ri, struct xfs_btree_cur **pcur);
 

