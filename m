Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1452EB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbjFPBhM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBhK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:37:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFC22948
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9292C61B53
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EF5C433C8;
        Fri, 16 Jun 2023 01:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879427;
        bh=xSXUgYM9N/9LryKOMJLovntgtERKRwRyndINF0sQOC8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s3YLDb3N/KQCYxe6s4IjdC4QEuj4G1s2dE9NXvgLU1LchhR23enU+Mo+/QP4YGaI7
         RzmEazC4mUjpwkIjZGcR0Dk386JAcaVXI+ySAsOT+cI/wrJ6vgfUrT5MuqhJWTyvdQ
         1GO/nTg951a2TZA40abPkhHW59pR5cf6idJlaYOMVOT0W8KZcK5OR6MjPlSEa2XLp7
         giOcPka43VaPb2MUq4h6vDIkb4mjgdtHbLfYlohNpdcL29TbK7sYALMx5u6jQq0kzO
         ADWJViV2Adjy+1tH9kQimS8pu84OsZz8Hu7X6siOfknDcaVfi1E97fww1Yyip+Jw6X
         2MUheSn36ZaQQ==
Subject: [PATCH 2/8] libxfs: port list_cmp_func_t to userspace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:37:07 -0700
Message-ID: <168687942737.831530.10539175194696645464.stgit@frogsfrogsfrogs>
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Synchronize our list_sort ABI to match the kernel's.  This will make it
easier to port the log item precommit sorting code to userspace as-is in
the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/list.h      |    7 ++++---
 libfrog/list_sort.c |   10 +++-------
 libxfs/defer_item.c |   32 ++++++++++++++++----------------
 scrub/repair.c      |   12 ++++++------
 4 files changed, 29 insertions(+), 32 deletions(-)


diff --git a/include/list.h b/include/list.h
index dab4e23b..e59cbd53 100644
--- a/include/list.h
+++ b/include/list.h
@@ -156,9 +156,10 @@ static inline void list_splice_init(struct list_head *list,
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
-void list_sort(void *priv, struct list_head *head,
-	       int (*cmp)(void *priv, struct list_head *a,
-			  struct list_head *b));
+typedef int (*list_cmp_func_t)(void *priv, const struct list_head *a,
+		const struct list_head *b);
+
+void list_sort(void *priv, struct list_head *head, list_cmp_func_t cmp);
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 
diff --git a/libfrog/list_sort.c b/libfrog/list_sort.c
index b77eece5..994a51fe 100644
--- a/libfrog/list_sort.c
+++ b/libfrog/list_sort.c
@@ -12,8 +12,7 @@
  * sentinel head node, "prev" links not maintained.
  */
 static struct list_head *merge(void *priv,
-				int (*cmp)(void *priv, struct list_head *a,
-					struct list_head *b),
+			        list_cmp_func_t cmp,
 				struct list_head *a, struct list_head *b)
 {
 	struct list_head head, *tail = &head;
@@ -41,8 +40,7 @@ static struct list_head *merge(void *priv,
  * throughout.
  */
 static void merge_and_restore_back_links(void *priv,
-				int (*cmp)(void *priv, struct list_head *a,
-					struct list_head *b),
+				list_cmp_func_t cmp,
 				struct list_head *head,
 				struct list_head *a, struct list_head *b)
 {
@@ -96,9 +94,7 @@ static void merge_and_restore_back_links(void *priv,
  * @b. If @a and @b are equivalent, and their original relative
  * ordering is to be preserved, @cmp must return 0.
  */
-void list_sort(void *priv, struct list_head *head,
-		int (*cmp)(void *priv, struct list_head *a,
-			struct list_head *b))
+void list_sort(void *priv, struct list_head *head, list_cmp_func_t cmp)
 {
 	struct list_head *part[MAX_LIST_LENGTH_BITS+1]; /* sorted partial lists
 						-- last slot is a sentinel */
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 6c5c7dd5..3f519252 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -33,11 +33,11 @@
 static int
 xfs_extent_free_diff_items(
 	void				*priv,
-	struct list_head		*a,
-	struct list_head		*b)
+	const struct list_head		*a,
+	const struct list_head		*b)
 {
-	struct xfs_extent_free_item	*ra;
-	struct xfs_extent_free_item	*rb;
+	const struct xfs_extent_free_item *ra;
+	const struct xfs_extent_free_item *rb;
 
 	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
 	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
@@ -197,11 +197,11 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 static int
 xfs_rmap_update_diff_items(
 	void				*priv,
-	struct list_head		*a,
-	struct list_head		*b)
+	const struct list_head		*a,
+	const struct list_head		*b)
 {
-	struct xfs_rmap_intent		*ra;
-	struct xfs_rmap_intent		*rb;
+	const struct xfs_rmap_intent	*ra;
+	const struct xfs_rmap_intent	*rb;
 
 	ra = container_of(a, struct xfs_rmap_intent, ri_list);
 	rb = container_of(b, struct xfs_rmap_intent, ri_list);
@@ -309,11 +309,11 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 static int
 xfs_refcount_update_diff_items(
 	void				*priv,
-	struct list_head		*a,
-	struct list_head		*b)
+	const struct list_head		*a,
+	const struct list_head		*b)
 {
-	struct xfs_refcount_intent	*ra;
-	struct xfs_refcount_intent	*rb;
+	const struct xfs_refcount_intent *ra;
+	const struct xfs_refcount_intent *rb;
 
 	ra = container_of(a, struct xfs_refcount_intent, ri_list);
 	rb = container_of(b, struct xfs_refcount_intent, ri_list);
@@ -427,11 +427,11 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 static int
 xfs_bmap_update_diff_items(
 	void				*priv,
-	struct list_head		*a,
-	struct list_head		*b)
+	const struct list_head		*a,
+	const struct list_head		*b)
 {
-	struct xfs_bmap_intent		*ba;
-	struct xfs_bmap_intent		*bb;
+	const struct xfs_bmap_intent	*ba;
+	const struct xfs_bmap_intent	*bb;
 
 	ba = container_of(a, struct xfs_bmap_intent, bi_list);
 	bb = container_of(b, struct xfs_bmap_intent, bi_list);
diff --git a/scrub/repair.c b/scrub/repair.c
index 67900ea4..5fc5ab83 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -37,7 +37,7 @@
 /* Sort action items in severity order. */
 static int
 PRIO(
-	struct action_item	*aitem,
+	const struct action_item *aitem,
 	int			order)
 {
 	if (aitem->flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -54,7 +54,7 @@ PRIO(
 /* Sort the repair items in dependency order. */
 static int
 xfs_action_item_priority(
-	struct action_item	*aitem)
+	const struct action_item	*aitem)
 {
 	switch (aitem->type) {
 	case XFS_SCRUB_TYPE_SB:
@@ -95,11 +95,11 @@ xfs_action_item_priority(
 static int
 xfs_action_item_compare(
 	void				*priv,
-	struct list_head		*a,
-	struct list_head		*b)
+	const struct list_head		*a,
+	const struct list_head		*b)
 {
-	struct action_item		*ra;
-	struct action_item		*rb;
+	const struct action_item	*ra;
+	const struct action_item	*rb;
 
 	ra = container_of(a, struct action_item, list);
 	rb = container_of(b, struct action_item, list);

