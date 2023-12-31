Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6048BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDhpAk45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7628CC433C7;
	Sun, 31 Dec 2023 21:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059043;
	bh=hv0LB4Dw9TNhfrZUDli+WYezsmY+B5BsvNMM6xEK/W0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PDhpAk45QI0qzxfn10RWVBzYEtBbE7X3/lAjS32el1tQ3fD9OSlLFvNfD477y27bu
	 +UbO1qIBCVMQLk+bWwa+qiXvDTqfh7WNJnoFGK1L6icSIN/VyP0p8esIgnrBsaOzNR
	 m45YkxjwOEZw/agsDe10Jsz9NvkL8NfvQaetQT21n/T3LY3f7+DOOsqpUtHPdGWxDa
	 x7kz8Nuhzqr61lTFdjL5LXc7dPUczKGjsaqZFbv2Jsv2PZ5hDnE4Nud2rkUcHkKhJu
	 PxmH2MLxL4A15lNSuAamqmUPD1M5k7NzovRHegREFKQU61P90iWfiUHknzIHoj1Xfm
	 EQ3SO+t2oYS4Q==
Date: Sun, 31 Dec 2023 13:44:03 -0800
Subject: [PATCH 08/10] xfs: don't bother calling
 xfs_refcount_finish_one_cleanup in xfs_refcount_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851021.1765989.6940314249300266343.stgit@frogsfrogsfrogs>
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

In xfs_refcount_finish_one we know the cursor is non-zero when calling
xfs_refcount_finish_one_cleanup and we pass a 0 error variable.  This
means xfs_refcount_finish_one_cleanup is just doing a
xfs_btree_del_cursor.

Open code that and move xfs_refcount_finish_one_cleanup to
fs/xfs/xfs_refcount_item.c.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   19 +------------------
 fs/xfs/libxfs/xfs_refcount.h |    2 --
 fs/xfs/xfs_refcount_item.c   |   18 ++++++++++++++++++
 3 files changed, 19 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ad0ad30a12c29..0d1b17a4df6a1 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1300,23 +1300,6 @@ xfs_refcount_adjust(
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
@@ -1380,7 +1363,7 @@ xfs_refcount_finish_one(
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		nr_ops = rcur->bc_ag.refc.nr_ops;
 		shape_changes = rcur->bc_ag.refc.shape_changes;
-		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
+		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 01a20621192ed..c94b8f71d407b 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -82,8 +82,6 @@ void xfs_refcount_increase_extent(struct xfs_trans *tp,
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 
-extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
-		struct xfs_btree_cur *rcur, int error);
 extern int xfs_refcount_finish_one(struct xfs_trans *tp,
 		struct xfs_refcount_intent *ri, struct xfs_btree_cur **pcur);
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 4113100dd1e5b..b36d8433098c8 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -21,6 +21,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
+#include "xfs_btree.h"
 
 struct kmem_cache	*xfs_cui_cache;
 struct kmem_cache	*xfs_cud_cache;
@@ -369,6 +370,23 @@ xfs_refcount_update_finish_item(
 	return error;
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
 /* Abort all pending CUIs. */
 STATIC void
 xfs_refcount_update_abort_intent(

