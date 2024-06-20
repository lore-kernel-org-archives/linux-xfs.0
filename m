Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6210A13CF82
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925118; cv=none; b=gHBOsXgfP4Vw4XasVyQjJcQjB3ZG6iy/DBuuKllX0KQi6ioFcROlaqIUVH1F672gLC996myMuI4LMmSoVjTwXK86gFPDKK7jeCxt+PaA9hW3BSnldLx5sxLf80SIEs78VIHvZgKizrQXqHBfcRnZRc3LHPnSQUIGqFHfAIO2PX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925118; c=relaxed/simple;
	bh=DNNNGnFqCL+cOB5HVzSLTxtJ7OHMgnpm0ncoi7oxuMI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLY82UQvw0yJKiHizfp5etM/AjPadSXQbApliVVsGTSvb6RcQxKN/jN2SfeO2TsPKcDyWn8reP47JPlBl7FhUuYPZ1W+GXVNskAfSneiYdNHJQ3rYn3+k9/JtG9MiyrQfPwNa7EciC7EnE1yX3GprYJqPQ+sAsY/E9yBwMEYXfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/lWl9uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/lWl9uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E231DC2BD10;
	Thu, 20 Jun 2024 23:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925118;
	bh=DNNNGnFqCL+cOB5HVzSLTxtJ7OHMgnpm0ncoi7oxuMI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U/lWl9uyWKshz6CxEsVYEKQ+IVV17pS24DJbrKpBlnG5ziUEl/+8HTotaYQOhN05i
	 Y5mmMGGEEJogCk1EGlnKFvecXAN69T7sEfOpPKn/lrgD7xOJw+V8YWwa+RImh0OkzM
	 moybzEMRiLdz1rjbgUv9rr5Z0YB2TACvcC+EWJUYiOLvKMEb2+Ep6LySK2IViIzI2L
	 bR2ylica0dqXJ5EMqhlly8XBa3Tai0sbCAYAyhi9aihywqVT0Mu9vM6izk7Jdd3ciV
	 VSXm6axmrjBERhFDjgXIhmp6NFSXGZcuPgKAar+1TA/h/1OeoqV+7fzETx2MS4eroB
	 5y94psdDI8tEA==
Date: Thu, 20 Jun 2024 16:11:57 -0700
Subject: [PATCH 10/10] xfs: move xfs_refcount_update_defer_add to
 xfs_refcount_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419943.3184748.2162208276846925919.stgit@frogsfrogsfrogs>
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

Move the code that adds the incore xfs_refcount_update_item deferred
work data to a transaction live with the CUI log item code.  This means
that the refcount code no longer has to know about the inner workings of
the CUI log items.

As a consequence, we can get rid of the _{get,put}_group helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    6 ++----
 fs/xfs/libxfs/xfs_refcount.h |    3 ---
 fs/xfs/xfs_refcount_item.c   |   24 +++++++++++-------------
 fs/xfs/xfs_refcount_item.h   |    5 +++++
 4 files changed, 18 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 4137a8d1ac13d..198b84117df13 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -24,6 +24,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_refcount_item.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1435,10 +1436,7 @@ __xfs_refcount_add(
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
 
-	trace_xfs_refcount_defer(tp->t_mountp, ri);
-
-	xfs_refcount_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
+	xfs_refcount_defer_add(tp, ri);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index c94b8f71d407b..68acb0b1b4a87 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -74,9 +74,6 @@ xfs_refcount_check_domain(
 	return true;
 }
 
-void xfs_refcount_update_get_group(struct xfs_mount *mp,
-		struct xfs_refcount_intent *ri);
-
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 4e06cadb924d3..27398512b179b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -22,6 +22,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
 #include "xfs_btree.h"
+#include "xfs_trace.h"
 
 struct kmem_cache	*xfs_cui_cache;
 struct kmem_cache	*xfs_cud_cache;
@@ -319,21 +320,18 @@ xfs_refcount_update_create_done(
 	return &cudp->cud_item;
 }
 
-/* Take a passive ref to the AG containing the space we're refcounting. */
+/* Add this deferred CUI to the transaction. */
 void
-xfs_refcount_update_get_group(
-	struct xfs_mount		*mp,
+xfs_refcount_defer_add(
+	struct xfs_trans		*tp,
 	struct xfs_refcount_intent	*ri)
 {
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	trace_xfs_refcount_defer(mp, ri);
+
 	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_startblock);
-}
-
-/* Release a passive AG ref after finishing refcounting work. */
-static inline void
-xfs_refcount_update_put_group(
-	struct xfs_refcount_intent	*ri)
-{
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
 
 /* Cancel a deferred refcount update. */
@@ -343,7 +341,7 @@ xfs_refcount_update_cancel_item(
 {
 	struct xfs_refcount_intent	*ri = ci_entry(item);
 
-	xfs_refcount_update_put_group(ri);
+	xfs_perag_intent_put(ri->ri_pag);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
@@ -433,7 +431,7 @@ xfs_cui_recover_work(
 	ri->ri_type = pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
 	ri->ri_startblock = pmap->pe_startblock;
 	ri->ri_blockcount = pmap->pe_len;
-	xfs_refcount_update_get_group(mp, ri);
+	ri->ri_pag = xfs_perag_intent_get(mp, pmap->pe_startblock);
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index eb0ab13682d0b..bfee8f30c63ce 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -71,4 +71,9 @@ struct xfs_cud_log_item {
 extern struct kmem_cache	*xfs_cui_cache;
 extern struct kmem_cache	*xfs_cud_cache;
 
+struct xfs_refcount_intent;
+
+void xfs_refcount_defer_add(struct xfs_trans *tp,
+		struct xfs_refcount_intent *ri);
+
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */

