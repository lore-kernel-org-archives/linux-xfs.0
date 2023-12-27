Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC4384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZeTIwQej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5517C433C8;
	Mon,  1 Jan 2024 00:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068300;
	bh=hhntfNzUbFUyBqWqK09iJlvKVxdacejnlAl5bXgayJA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZeTIwQejZ4GUJVvUzrkpQClsmB0foeYZlknppKTkXCIgVwv8/csCSRuDY/KTO6ZrM
	 8Ts8josLjAQ0QwckW+feZcmyolmzX9J88yDbo1RqD4YQsToMPqrlnyn3+SKTcfYRug
	 YkIWrs5ACMeLVqOjjSz7p14qkLqiPMtBzXE5bU7vz+0+iH0q61jL/KiGm3zWzXT++N
	 iWoNxMYSQQBJiJAPscg0tSUhQ6JtTi73tk3HYU1XXSGJmfAZJK7Hg3KkAcUKlLw2RY
	 AlRHpFfQkLjNp+waY2YBd0nnzvyP4HC9XzETPCmUps0fRVqNh5u61Ele6ESRNGs6kr
	 ozPGZDP+Bicvg==
Date: Sun, 31 Dec 2023 16:18:20 +9900
Subject: [PATCH 30/47] xfs_scrub: retest metadata across scrub groups after a
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015712.1815505.361050132317782703.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
 scrub/phase4.c |   54 +++++++++++++++++++
 scrub/repair.c |  158 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/repair.h |    5 ++
 3 files changed, 216 insertions(+), 1 deletion(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 88cb53aeac9..c58e4aaabda 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -42,6 +42,51 @@ struct repair_list_schedule {
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
+	/*
+	 * Action items attached to @alist after the revalidation are either
+	 * the result of finding new inconsistencies or an incomplete list
+	 * after an operational error.  In the first case we need these new
+	 * items to be processed; in the second case, we're going to exit the
+	 * process.  Either way, pass the items back to the caller.
+	 */
+	action_list_merge(&rls->requeue_list, &alist);
+
+	if (error) {
+		rls->aborted = true;
+		return error;
+	}
+
+	return 0;
+}
+
 /* Try to repair as many things on our list as we can. */
 static void
 repair_list_worker(
@@ -89,9 +134,16 @@ repair_list_worker(
 			action_list_add(&rls->requeue_list, aitem);
 			break;
 		case TR_REPAIRED:
+			ret = revalidate_across_groups(ctx, aitem, rls);
+			if (ret) {
+				free(aitem);
+				break;
+			}
+
 			/*
 			 * All repairs for this item completed.  Free the item,
-			 * and remember that progress was made.
+			 * and remember that progress was made, even if group
+			 * revalidation uncovered more issues.
 			 */
 			rls->made_progress = true;
 			free(aitem);
diff --git a/scrub/repair.c b/scrub/repair.c
index fee03f97701..72533ab5b02 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -43,6 +43,15 @@ static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
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
@@ -631,6 +640,16 @@ action_list_add(
 	list_add_tail(&aitem->list, &alist->list);
 }
 
+/* Move an action item off of a list onto alist. */
+static void
+action_list_move(
+	struct action_list		*alist,
+	struct action_item		*aitem)
+{
+	list_del_init(&aitem->list);
+	action_list_add(alist, aitem);
+}
+
 /*
  * Try to repair a filesystem object and let the caller know what it should do
  * with the action item.  The caller must be able to requeue action items, so
@@ -894,3 +913,142 @@ repair_item_to_action_item(
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
+		case XFROG_SCRUB_GROUP_FS:
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
+	struct action_list		*new_repairs)
+{
+	struct action_list		new_items;
+	struct action_item		*aitem, *n;
+	unsigned int			scrub_type;
+	int				error = 0;
+
+	/* Find new scrub items to revalidate */
+	action_list_init(&new_items);
+	foreach_scrub_type(scrub_type) {
+		unsigned int		mask;
+
+		if (!(old_aitem->sri.sri_selected & (1ULL << scrub_type)))
+			continue;
+		mask = cross_group_recheck[scrub_type];
+		if (!mask)
+			continue;
+
+		error = schedule_cross_group_recheck(ctx, mask, &new_items);
+		if (error)
+			goto bad;
+	}
+	if (action_list_empty(&new_items))
+		return 0;
+
+	/* Scrub them all, and move corrupted items to the caller's list */
+	list_for_each_entry_safe(aitem, n, &new_items.list, list) {
+		unsigned int	bad;
+
+		error = scrub_item_check(ctx, &aitem->sri);
+		if (error)
+			 goto bad;
+
+		bad = repair_item_count_needsrepair(&aitem->sri);
+		if (bad > 0) {
+			/*
+			 * Uhoh, we found something else broken.  Queue it for
+			 * more repairs.
+			 */
+			aitem->sri.sri_revalidate = false;
+			action_list_move(new_repairs, aitem);
+		}
+	}
+
+bad:
+	/* Delete anything that's still on the list. */
+	list_for_each_entry_safe(aitem, n, &new_items.list, list) {
+		list_del(&aitem->list);
+		free(aitem);
+	}
+
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
index ec4aa381a82..96f621f124d 100644
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

