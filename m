Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D200114387F
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924961; cv=none; b=WrrfZ2nDl6/RH8apOc9j63inJx85cia67flcGxoyGY8pEtpooXwUp3+rTpUciyiFHPjKJiDyY4Iour/c8s69Y5SKAWt+gUquGY7mHVNx4Ksr4Kd6GKCmGRyEVCnYXksQGoHeHOQFRp16SGGS+bSncaKbEH2tqcqadaXfx3HyWh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924961; c=relaxed/simple;
	bh=B//99HLyMlmLZ+NyRuPuYcumC/U0t2Oc4moB2y/F8qY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KhN37XctjTGyCkgIcct+NLcpiFIeN/NhpVGCva8r1ZvWRnbmbD+VrTKMSujEZ7xc6apIDHnDhLa5fBd1th4yG1R5GbnKUW2KINPUpl1FY0CvX/XBP4vYGmhkQMB+MKe0Z0ell3L+/FS91IKkRDQAluDBnWtvjZc8LtfsddCjdYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nf/MxxdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nf/MxxdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C53C2BD10;
	Thu, 20 Jun 2024 23:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924961;
	bh=B//99HLyMlmLZ+NyRuPuYcumC/U0t2Oc4moB2y/F8qY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nf/MxxdLoEaGKHWBNnxDWHIpkJhJFf7syBDg/AA3J86yGKLphc7kNY67Rz97cqCDF
	 U4NEmNrXuLElCcBvwr4qn0+8nW4zQGLn6/W4f9c9dS0ZotUEcysm3ejPEuOAqA+kwF
	 04yR1HiBWYrMLWGYzaBY+Pk2KLD0LfcPTfCTRExCOA78xUJlEI47LwyuUU11qpxZVJ
	 AFI+cmeHkaVGr0aE9X9S/aLHGhnXqYIHO2asOivzSiPBgiDsx1VYpteOQ1f6X+ul1i
	 +jkoQtbl8REaCNXOeEJF3UdoTWRsig1Q/FVl2QA5kP4Y0zes9cnNm7OFyFBqFVT452
	 8nyebZ15aWnmA==
Date: Thu, 20 Jun 2024 16:09:21 -0700
Subject: [PATCH 9/9] xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419387.3184396.13324698821553289330.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
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

Move the code that adds the incore xfs_rmap_update_item deferred work
data to a transaction live with the RUI log item code.  This means that
the rmap code no longer has to know about the inner workings of the RUI
log items.

As a consequence, we can get rid of the _{get,put}_group helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |    6 ++----
 fs/xfs/libxfs/xfs_rmap.h |    3 ---
 fs/xfs/xfs_rmap_item.c   |   24 +++++++++++-------------
 fs/xfs/xfs_rmap_item.h   |    4 ++++
 4 files changed, 17 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index a5a0fa6a5b5dc..6ef4687b3aba8 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -24,6 +24,7 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rmap_item.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2656,10 +2657,7 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
-	trace_xfs_rmap_defer(tp->t_mountp, ri);
-
-	xfs_rmap_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
+	xfs_rmap_defer_add(tp, ri);
 }
 
 /* Map an extent into a file. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 9d85dd2a6553c..b783dd4dd95d1 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -176,9 +176,6 @@ struct xfs_rmap_intent {
 	struct xfs_perag			*ri_pag;
 };
 
-void xfs_rmap_update_get_group(struct xfs_mount *mp,
-		struct xfs_rmap_intent *ri);
-
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
 void xfs_rmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, struct xfs_bmbt_irec *imap);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 44a9b77c17639..88b5580e1e19f 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
 #include "xfs_btree.h"
+#include "xfs_trace.h"
 
 struct kmem_cache	*xfs_rui_cache;
 struct kmem_cache	*xfs_rud_cache;
@@ -342,21 +343,18 @@ xfs_rmap_update_create_done(
 	return &rudp->rud_item;
 }
 
-/* Take a passive ref to the AG containing the space we're rmapping. */
+/* Add this deferred RUI to the transaction. */
 void
-xfs_rmap_update_get_group(
-	struct xfs_mount	*mp,
+xfs_rmap_defer_add(
+	struct xfs_trans	*tp,
 	struct xfs_rmap_intent	*ri)
 {
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	trace_xfs_rmap_defer(mp, ri);
+
 	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
-}
-
-/* Release a passive AG ref after finishing rmapping work. */
-static inline void
-xfs_rmap_update_put_group(
-	struct xfs_rmap_intent	*ri)
-{
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
 
 /* Cancel a deferred rmap update. */
@@ -366,7 +364,7 @@ xfs_rmap_update_cancel_item(
 {
 	struct xfs_rmap_intent		*ri = ri_entry(item);
 
-	xfs_rmap_update_put_group(ri);
+	xfs_perag_intent_put(ri->ri_pag);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
@@ -496,7 +494,7 @@ xfs_rui_recover_work(
 	ri->ri_bmap.br_blockcount = map->me_len;
 	ri->ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	xfs_rmap_update_get_group(mp, ri);
+	ri->ri_pag = xfs_perag_intent_get(mp, map->me_startblock);
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 802e5119eacaa..40d331555675b 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -71,4 +71,8 @@ struct xfs_rud_log_item {
 extern struct kmem_cache	*xfs_rui_cache;
 extern struct kmem_cache	*xfs_rud_cache;
 
+struct xfs_rmap_intent;
+
+void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
+
 #endif	/* __XFS_RMAP_ITEM_H__ */

