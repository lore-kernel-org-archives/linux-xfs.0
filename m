Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A382D83
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925086; cv=none; b=duKSdE3G60r88Kb5dVPwfcTq19wq3lp6+2sTX7hdVYiRZ48d4yXra3hlr+cMM+0FOo6mY5hngHcUcDEzwX1qsJXWktMjHOB1nKuDKQxZIJRbNkOZCAQqJqrlLG+uxm9F2OhvCi6az3OOlu7nHgE3DsSRD3znv8a7SRSWuYwGg6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925086; c=relaxed/simple;
	bh=/Q1OwaAfuVGdlUoqHTbnrKABYbiBYOT+F40/JVBzEGE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W58LNsdJ+g7J9BhScW0lSpSdcZ0xcAFAJZNQ0mgnxPX5C/BezoerhDtCnO9YqQDyTmhLinbHTCu75ZWvOCJuncTn8rUeqhx9sA1Hhg0npScZ6kaJAUtepgLSfb3xHEL6h3uYwsAF+bYQKHGY+gZrhQFeUl4wEuMRMj95TQaFVFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRnDwVLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRnDwVLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7DCC2BD10;
	Thu, 20 Jun 2024 23:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925086;
	bh=/Q1OwaAfuVGdlUoqHTbnrKABYbiBYOT+F40/JVBzEGE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rRnDwVLPmU30SJBMGeqIHFKokQC3f0oC0gvJI81Qljm49XLvsx0kPtokHbUTfvEZ0
	 omAYdXiGvNMyebyWdDePgHA4FY2oOLqwLKEPXuFBUrzck1VdFjcwPr6EMCJLfGfmKt
	 dvA4RVVmy9NY2hoiuoMbG5ZgnsPv98sBsZqN/CTQqODikv5k+mDzZP4rkmAk9qsH7F
	 IQ0dbbx24R5Rj0icWMzPgWuUjEbkbjR7V7cZsJP9bgOKeHp4kASxO5wuwJn1DPC6mH
	 noYhg+Kd339ZyNWT2WZgUHqlkGqf2MT7bGwBquVydOcPeIDpgoFHdsKSWCRbswzG8+
	 wMZwojy/2y9yA==
Date: Thu, 20 Jun 2024 16:11:26 -0700
Subject: [PATCH 08/10] xfs: don't bother calling
 xfs_refcount_finish_one_cleanup in xfs_refcount_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419908.3184748.15491155401473010232.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
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
index c0572bb86cdb8..10a16635d93f2 100644
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
 		nr_ops = rcur->bc_refc.nr_ops;
 		shape_changes = rcur->bc_refc.shape_changes;
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
index 90a019ddcc1f4..4e06cadb924d3 100644
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

