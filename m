Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BE0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiLaAbn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiLaAbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:31:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F2213F7A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:31:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1497A61D4B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F882C433EF;
        Sat, 31 Dec 2022 00:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446700;
        bh=TNjVKEEz3nQDR1NYzmG3zbidAWFFhIQND8gR8iVKAL4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UjHMyE5h20qy1HDN5dy+DlB/wIrW3tEfa+F9/4k69sUCVL2zICx0mdYhioH7WqL3f
         9OJj99txOwhznGVZtzC7wTTJc8RXx1i/D7Mh64PN5hoqgwLTHa3Wx9dWRszhoxcvNO
         aPzILBIG3u4sZbqrKHB0/CGyPVb2cTzMhGsd2xjG5EBLu5n1VJI81W+8hoCmQ6u+Tm
         NtmipmgHgpMxHmarTT1Tpc/IIml9OLUxj350PAHnJ5FK2r/cLLZ7IUyDUFdmrjyyKL
         6Qf5wAYmKkyPe7j5279UxpqgcQhT0xoVomtsB0BFWS8j/dUOLEaM5WS2ZlQ/uawK2G
         SuOSsol2C2L9A==
Subject: [PATCH 3/4] xfs_scrub: recheck entire metadata objects after
 corruption repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870469.716640.555577616360473994.stgit@magnolia>
In-Reply-To: <167243870430.716640.15368107413813691968.stgit@magnolia>
References: <167243870430.716640.15368107413813691968.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we've finished making repairs to some domain of filesystem metadata
(file, AG, etc.) to correct an inconsistency, we should recheck all the
other metadata types within that domain to make sure that we neither
made things worse nor introduced more cross-referencing problems.  If we
did, requeue the item to make the repairs.  If the only changes we made
were optimizations, don't bother.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c        |   37 +++++++++++++++++++++++++++++++++++++
 scrub/scrub.c         |    5 +++--
 scrub/scrub.h         |   10 ++++++++++
 scrub/scrub_private.h |    2 ++
 4 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index dd608629f2a..cf17bbd8d0e 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -476,8 +476,10 @@ action_item_try_repair(
 {
 	struct scrub_item	*sri = &aitem->sri;
 	unsigned int		before, after;
+	unsigned int		scrub_type;
 	int			ret;
 
+	BUILD_BUG_ON(sizeof(sri->sri_selected) * NBBY < XFS_SCRUB_TYPE_NR);
 	before = repair_item_count_needsrepair(sri);
 
 	ret = repair_item(ctx, sri, 0);
@@ -498,6 +500,41 @@ action_item_try_repair(
 		return 0;
 	}
 
+	/*
+	 * Nothing in this fs object was marked inconsistent.  This means we
+	 * were merely optimizing metadata and there is no revalidation work to
+	 * be done.
+	 */
+	if (!sri->sri_inconsistent) {
+		*outcome = TR_REPAIRED;
+		return 0;
+	}
+
+	/*
+	 * We fixed inconsistent metadata, so reschedule the entire object for
+	 * immediate revalidation to see if anything else went wrong.
+	 */
+	foreach_scrub_type(scrub_type)
+		if (sri->sri_selected & (1U << scrub_type))
+			sri->sri_state[scrub_type] = SCRUB_ITEM_NEEDSCHECK;
+	sri->sri_inconsistent = false;
+	sri->sri_revalidate = true;
+
+	ret = scrub_item_check(ctx, sri);
+	if (ret)
+		return ret;
+
+	after = repair_item_count_needsrepair(sri);
+	if (after > 0) {
+		/*
+		 * Uhoh, we found something else broken.  Tell the caller that
+		 * this item needs to be queued for more repairs.
+		 */
+		sri->sri_revalidate = false;
+		*outcome = TR_REQUEUE;
+		return 0;
+	}
+
 	/* Repairs complete. */
 	*outcome = TR_REPAIRED;
 	return 0;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 6f9f182c629..c245e46afa7 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -117,11 +117,12 @@ xfs_check_metadata(
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 
 	error = -xfrog_scrub_metadata(xfdp, &meta);
-	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
-		meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
+		if (!sri->sri_revalidate &&
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+			meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index e1ce6ed2f59..53354099c81 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -59,11 +59,20 @@ struct scrub_item {
 	__u32			sri_gen;
 	__u32			sri_agno;
 
+	/* Bitmask of scrub types that were scheduled here. */
+	__u32			sri_selected;
+
 	/* Scrub item state flags, one for each XFS_SCRUB_TYPE. */
 	__u8			sri_state[XFS_SCRUB_TYPE_NR];
 
 	/* Track scrub and repair call retries for each scrub type. */
 	__u8			sri_tries[XFS_SCRUB_TYPE_NR];
+
+	/* Were there any corruption repairs needed? */
+	bool			sri_inconsistent:1;
+
+	/* Are we revalidating after repairs? */
+	bool			sri_revalidate:1;
 };
 
 #define foreach_scrub_type(loopvar) \
@@ -103,6 +112,7 @@ static inline void
 scrub_item_schedule(struct scrub_item *sri, unsigned int scrub_type)
 {
 	sri->sri_state[scrub_type] = SCRUB_ITEM_NEEDSCHECK;
+	sri->sri_selected |= (1U << scrub_type);
 }
 
 void scrub_item_schedule_group(struct scrub_item *sri,
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 6380779c90b..c60ea555885 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -71,6 +71,8 @@ scrub_item_save_state(
 	unsigned  int			scrub_flags)
 {
 	sri->sri_state[scrub_type] = scrub_flags & SCRUB_ITEM_REPAIR_ANY;
+	if (scrub_flags & SCRUB_ITEM_NEEDSREPAIR)
+		sri->sri_inconsistent = true;
 }
 
 static inline void

