Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8541759F
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832161; cv=none; b=iPOUWil1A2WHJIdSYYdqQRL2djVbODh2BfEeeaYhxTPSFRNYm3k25qtDNPf6VIVSfDeotTemxSWfM035y3ipZQsOdsUIv7emrmQDr67Tmla74HReQDa4hiZL31kBVG3JPnPXhpcDR3qnsiBnI5Ryfcer3HIKUYUODMT+KHFv9Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832161; c=relaxed/simple;
	bh=J2vY/i9lgZ3wrlth3p8y+as9Yfs7InKdUqlxQKjpA4Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuzJdiVRjRr1CyQwyQQFaANdUNYCvI7TGPq9Ok0gcTEqTgCTWtg05XOl70q9LRl3pZevRQPlZ8MnvDhl7gZN6q2lCQxG1ath9/Iq4jua8szypvm5xNnxyX0ZEW/BVJnq1zFRLCzObfBCR0ws6VTS0UmRLj1kKh4OxyzvmHIhIPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pa1or2gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pa1or2gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E597C4CEC6;
	Wed,  2 Oct 2024 01:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832160;
	bh=J2vY/i9lgZ3wrlth3p8y+as9Yfs7InKdUqlxQKjpA4Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pa1or2gdMiDFMcGNCsguVw776Kbqou12EvCr02KVB/gcLFrGXLJZOiMRv0hQyno2m
	 Lv2DEs64ma67v5LjxMJXMLgul1vExEhZu+gzNGeNuXUbvsmcGd0JjEGRVL7G7Gc4kp
	 86nkKq+Ph7j6Omms104nSfDRkOvf/Fb2/azNuhxUBZ0s1j2HUsLfoAd3f3umucUUwi
	 r+hFP42m5WgRU9pBByn7Z83X2q3gRbLilPkC/Ew5lbjsekuLY8QXATfY+q4y+a1EKR
	 27t9nqJsfk3I8J5UDA7Rdev0CAPDYP8b0E5C+iIf4aItcQy5Af1TH1yv/jxgjAqC0i
	 x+xqym7IpSQUw==
Date: Tue, 01 Oct 2024 18:22:40 -0700
Subject: [PATCH 57/64] xfs: move xfs_refcount_update_defer_add to
 xfs_refcount_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102640.4036371.7044258013932049664.stgit@frogsfrogsfrogs>
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

Source kernel commit: 783e8a7c9cab6744ebc5dfe75081248ac39181b2

Move the code that adds the incore xfs_refcount_update_item deferred
work data to a transaction live with the CUI log item code.  This means
that the refcount code no longer has to know about the inner workings of
the CUI log items.

As a consequence, we can get rid of the _{get,put}_group helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c   |   21 +++++++++------------
 libxfs/defer_item.h   |    5 +++++
 libxfs/xfs_refcount.c |    6 ++----
 libxfs/xfs_refcount.h |    3 ---
 4 files changed, 16 insertions(+), 19 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index f6560a6b3..98a291c7b 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -364,21 +364,18 @@ xfs_refcount_update_create_done(
 	return NULL;
 }
 
-/* Take an active ref to the AG containing the space we're refcounting. */
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
-/* Release an active AG ref after finishing refcounting work. */
-static inline void
-xfs_refcount_update_put_group(
-	struct xfs_refcount_intent	*ri)
-{
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
 
 /* Cancel a deferred refcount update. */
@@ -388,7 +385,7 @@ xfs_refcount_update_cancel_item(
 {
 	struct xfs_refcount_intent	*ri = ci_entry(item);
 
-	xfs_refcount_update_put_group(ri);
+	xfs_perag_intent_put(ri->ri_pag);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index be354785b..93cf1eed5 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -34,4 +34,9 @@ struct xfs_rmap_intent;
 
 void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
 
+struct xfs_refcount_intent;
+
+void xfs_refcount_defer_add(struct xfs_trans *tp,
+		struct xfs_refcount_intent *ri);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index d0a057f5c..22f8afb27 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -23,6 +23,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "defer_item.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1434,10 +1435,7 @@ __xfs_refcount_add(
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
 
-	trace_xfs_refcount_defer(tp->t_mountp, ri);
-
-	xfs_refcount_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
+	xfs_refcount_defer_add(tp, ri);
 }
 
 /*
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index c94b8f71d..68acb0b1b 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -74,9 +74,6 @@ xfs_refcount_check_domain(
 	return true;
 }
 
-void xfs_refcount_update_get_group(struct xfs_mount *mp,
-		struct xfs_refcount_intent *ri);
-
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,

