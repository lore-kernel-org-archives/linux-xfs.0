Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A192376E6
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882218; cv=none; b=h4juig2vrZqBs7gVk7Yni/ubC0BCBRyeZk8KJVo5updACfhfAftEvs3apsBd/NFSNipH9s69tfJ6P7HrwI8TIU/KtvyuGXkJddajstTJ4lu3l0L/GC9zDwe2ysERGVlTpjV0PMWWD7usyAQczkDq2lxky3h3wD0o/dpPwwE1uLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882218; c=relaxed/simple;
	bh=nr368d2LlXF6J+WpbWGejMyA+xXMjHVr97WlfNgm4ow=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nEIZqhuf8oNtpzKfd5m0SSCi1f0LfZkFgYAANLv3MmzLDA/y/UHxu8PxOPxWCsZ5zgmXfdS/octyDfo9E83un9YqXQngJ4nQIQTjGwKqSkk5taLp58NEcj9UaY0aa2KE0ePXeYCkIuj/K7358bj8YSQd4s7pfieZGlYGFup1tX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnvm3WXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnvm3WXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04D9C4CEDD;
	Thu,  6 Feb 2025 22:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882215;
	bh=nr368d2LlXF6J+WpbWGejMyA+xXMjHVr97WlfNgm4ow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cnvm3WXoy+GmzfrOIjvpHS8SGLp7pbZNeGPetvwJKDK5afnwiiEwZ6D4x2xpvBnAh
	 2OOyT16DhEYek4R3bOTtB+dbon3Ipm3sOF2iUdyirZiRJ+NF9urQEs9ZYSL/uk3V/V
	 54En8+toajVUGs/Vtp3NDa8FSz2rGn8wowNg3B8SQKjIL9x0w0ZOk2k7f4pgwFdWfG
	 OM5NzJUleLTzjoG8hDWGpnmG/w+cyU8kZn66Ai2kHz2ofvfRO7lqx4pVZNonXk1Tet
	 bycopMJKenBeOGz7sV6LMPpVDToYwTvgrwDlhKJ71giwEJeT/ns1fl51P6btehAhTV
	 PJYFnX5DgO1Qg==
Date: Thu, 06 Feb 2025 14:50:15 -0800
Subject: [PATCH 02/27] libxfs: add a realtime flag to the rmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088127.2741033.14339847563200590694.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Extend the rmap update (RUI) log items with a new realtime flag that
indicates that the updates apply against the realtime rmapbt.  We'll
wire up the actual rmap code later.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/defer_item.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 9db0e471cba69c..1ca9ce15ecfe3d 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -29,6 +29,7 @@
 #include "xfs_exchmaps.h"
 #include "defer_item.h"
 #include "xfs_group.h"
+#include "xfs_rtgroup.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -289,9 +290,18 @@ xfs_rmap_defer_add(
 
 	trace_xfs_rmap_defer(mp, ri);
 
+	/*
+	 * Deferred rmap updates for the realtime and data sections must use
+	 * separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
 	ri->ri_group = xfs_group_intent_get(mp, ri->ri_bmap.br_startblock,
-			XG_TYPE_AG);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
+			ri->ri_realtime ? XG_TYPE_RTG : XG_TYPE_AG);
+	xfs_defer_add(tp, &ri->ri_list, ri->ri_realtime ?
+			&xfs_rtrmap_update_defer_type :
+			&xfs_rmap_update_defer_type);
 }
 
 /* Cancel a deferred rmap update. */
@@ -356,6 +366,27 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
 
+/* Clean up after calling xfs_rtrmap_finish_one. */
+STATIC void
+xfs_rtrmap_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	if (rcur)
+		xfs_btree_del_cursor(rcur, error);
+}
+
+const struct xfs_defer_op_type xfs_rtrmap_update_defer_type = {
+	.name		= "rtrmap",
+	.create_intent	= xfs_rmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rmap_update_finish_item,
+	.finish_cleanup = xfs_rtrmap_finish_one_cleanup,
+	.cancel_item	= xfs_rmap_update_cancel_item,
+};
+
 /* Reference Counting */
 
 static inline struct xfs_refcount_intent *ci_entry(const struct list_head *e)

