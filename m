Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A55C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiLaCwz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:52:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C03E18387
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:52:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA8DE61BC8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475D3C433D2;
        Sat, 31 Dec 2022 02:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455172;
        bh=mbDqidvA+NpFWYp62pHk7eo4jwU1qN0AxYnlF31zVoc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=puw2imvzAq8KmpVunGUIBsVP0WVBdjVoDrDHpX0ZVhFB1I4r8hTjzNR+y+nC0O2zJ
         fgo5cqeVGMBD0aTFXpkJE98lUkQQdWPtWCyMcGlWMSiqVoao5JLcJYGYqkuRmN0z1Z
         MglhJ3oHJdoOvcuzUDsDbFscj9IiUheiZLtLpwwxtQhNRkHtukJZ2tJG94ypEFo4/8
         fu8YUEQvLyyFbskAYlPxlK4jkdxKvdy24J7X2aBD18KINeIHexI8Z0gOi+PBPGWy29
         vT0pWh9p0jfcLLccg1frFx2xCo8KKwd6bSmSX4VF2UjmznlvEDCRSf+qxBwr09BX+p
         2c9hv5OKGiNHg==
Subject: [PATCH 40/41] xfs_scrub: retest metadata across scrub groups after a
 repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:01 -0800
Message-ID: <167243880122.732820.7337094835824044775.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Certain types of metadata have dependencies that cross scrub groups.
For example, after a repair the part of realtime bitmap corresponding to
a realtime group, we potentially need to rebuild the realtime summary to
reflect the new bitmap contents.  The rtsummary is a separate scrub group
(metafiles) from the rgbitmap (rtgroup), which means that the rtsummary
repairs must be tracked by a separate scrub_item.

Create the necessary dependency table and code to make these kinds of
cross-group validations possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase4.c |   43 ++++++++++++++++++++
 scrub/repair.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/repair.h |    5 ++
 3 files changed, 171 insertions(+)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 74fcc55b379..2d0a448e268 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -42,6 +42,47 @@ struct repair_list_schedule {
 	bool				made_progress;
 };
 
+/*
+ * After a successful repair, schedule any additional revalidations needed in
+ * other scrub groups.
+ */
+static int
+revalidate_across_groups(
+	struct scrub_ctx		*ctx,
+	const struct action_item	*old_aitem,
+	struct repair_list_schedule	*rls)
+{
+	struct action_list		alist;
+	int				error;
+
+	action_list_init(&alist);
+
+	error = action_item_schedule_revalidation(ctx, old_aitem, &alist);
+	if (error) {
+		rls->aborted = true;
+		return error;
+	}
+
+	if (action_list_empty(&alist))
+		return 0;
+
+	pthread_mutex_unlock(&rls->lock);
+	error = action_list_revalidate(ctx, &alist);
+	pthread_mutex_lock(&rls->lock);
+
+	if (error)
+		rls->aborted = true;
+	else
+		rls->made_progress = true;
+
+	/*
+	 * Merge the action items into the scrub context for freeing, even if
+	 * there was an error.
+	 */
+	action_list_merge(&rls->requeue_list, &alist);
+	return error;
+}
+
 /* Try to repair as many things on our list as we can. */
 static void
 repair_list_worker(
@@ -89,6 +130,8 @@ repair_list_worker(
 			action_list_add(&rls->requeue_list, aitem);
 			break;
 		case TR_REPAIRED:
+			revalidate_across_groups(ctx, aitem, rls);
+
 			/* Item is clean.  Free it. */
 			free(aitem);
 			break;
diff --git a/scrub/repair.c b/scrub/repair.c
index 79a15f907a1..3e00db7a2fd 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -42,6 +42,15 @@ static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
 					  DEP(XFS_SCRUB_TYPE_PQUOTA),
 	[XFS_SCRUB_TYPE_RTSUM]		= DEP(XFS_SCRUB_TYPE_RTBITMAP),
 };
+
+/*
+ * Data dependencies that cross scrub groups.  When we repair a metadata object
+ * of the given type (e.g. rtgroup bitmaps), we want to trigger a revalidation
+ * of the specified objects (e.g. rt summary file).
+ */
+static const unsigned int cross_group_recheck[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_RGBITMAP]	= DEP(XFS_SCRUB_TYPE_RTSUM),
+};
 #undef DEP
 
 /*
@@ -781,3 +790,117 @@ repair_item_to_action_item(
 	*aitemp = aitem;
 	return 0;
 }
+
+static int
+schedule_cross_group_recheck(
+	struct scrub_ctx	*ctx,
+	unsigned int		recheck_mask,
+	struct action_list	*new_items)
+{
+	unsigned int		scrub_type;
+
+	foreach_scrub_type(scrub_type) {
+		struct action_item	*aitem;
+
+		if (!(recheck_mask & (1U << scrub_type)))
+			continue;
+
+		switch (xfrog_scrubbers[scrub_type].group) {
+		case XFROG_SCRUB_GROUP_METAFILES:
+			/*
+			 * XXX gcc fortify gets confused on the memset in
+			 * scrub_item_init_fs if we hoist this allocation to a
+			 * helper function.
+			 */
+			aitem = malloc(sizeof(struct action_item));
+			if (!aitem) {
+				int	error = errno;
+
+				str_liberror(ctx, error,
+						_("creating repair revalidation action item"));
+				return error;
+			}
+
+			INIT_LIST_HEAD(&aitem->list);
+			aitem->sri.sri_revalidate = true;
+
+			scrub_item_init_fs(&aitem->sri);
+			scrub_item_schedule(&aitem->sri, scrub_type);
+			action_list_add(new_items, aitem);
+			break;
+		default:
+			/* We don't support any other groups yet. */
+			assert(false);
+			continue;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * After a successful repair, schedule revalidation of metadata outside of this
+ * scrub item's group.
+ */
+int
+action_item_schedule_revalidation(
+	struct scrub_ctx		*ctx,
+	const struct action_item	*old_aitem,
+	struct action_list		*new_items)
+{
+	struct action_item		*aitem, *n;
+	unsigned int			scrub_type;
+	int				error = 0;
+
+	foreach_scrub_type(scrub_type) {
+		unsigned int		mask;
+
+		if (!(old_aitem->sri.sri_selected & (1U << scrub_type)))
+			continue;
+		mask = cross_group_recheck[scrub_type];
+		if (!mask)
+			continue;
+
+		error = schedule_cross_group_recheck(ctx, mask, new_items);
+		if (error)
+			goto bad;
+	}
+
+	return 0;
+bad:
+	list_for_each_entry_safe(aitem, n, &new_items->list, list) {
+		list_del(&aitem->list);
+		free(aitem);
+	}
+	return error;
+}
+
+/*
+ * Revalidate all items scheduled for a recheck, and drop the ones that are
+ * clean.
+ */
+int
+action_list_revalidate(
+	struct scrub_ctx	*ctx,
+	struct action_list	*alist)
+{
+	struct action_item	*aitem, *n;
+	int			error;
+
+	list_for_each_entry_safe(aitem, n, &alist->list, list) {
+		error = scrub_item_check(ctx, &aitem->sri);
+		if (error)
+			return error;
+
+		if (repair_item_count_needsrepair(&aitem->sri) > 0) {
+			aitem->sri.sri_revalidate = false;
+			continue;
+		}
+
+		/* Metadata are clean, delete from list. */
+		list_del(&aitem->list);
+		free(aitem);
+	}
+
+	return 0;
+}
diff --git a/scrub/repair.h b/scrub/repair.h
index c4b9b5799e2..f90ac16b13f 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -50,6 +50,11 @@ enum tryrepair_outcome {
 int action_item_try_repair(struct scrub_ctx *ctx, struct action_item *aitem,
 		enum tryrepair_outcome *outcome);
 
+int action_item_schedule_revalidation(struct scrub_ctx *ctx,
+		const struct action_item *old_aitem,
+		struct action_list *new_items);
+int action_list_revalidate(struct scrub_ctx *sc, struct action_list *alist);
+
 void repair_item_mustfix(struct scrub_item *sri, struct scrub_item *fix_now);
 
 /* Primary metadata is corrupt */

