Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E1FC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A2E661A3C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCZAVp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229951AbhCZAVa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F35B6619F3;
        Fri, 26 Mar 2021 00:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718090;
        bh=i3WPJ2W82O46E+4a3Y+EK8kHO7Brh1wMILD42+EvWnk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OasdCv/8FTEL8xs0jkfcRPHCuWV4QKYXTXVrkDRpy2IGjwRNar4D4uJfH0075m+ud
         Yated+jxdBnX5QPzmsD1b34rLot9e05GhQTKScqzaSf+SpiPYys2i0W4cY8wT+z1Z5
         0+vfe/Z3S9c2T2fUzjxP8mmaaKvg7WDtt+w1CP081bG99QPB0IM545t95g6giPsaFz
         xdrP2byy3rg9iXUu0rKGaIRSlBXqEUIZv/BOzPyRmM4qEPDSDUUjtDayK4phvdnhNf
         pkJ57fCEqBvjCYjmxLWF+ilZUKYJLVkxrf8YpYipDVDM/32BVCoXSDggPa5hQIA0qZ
         aWIA1zXUWfiiA==
Subject: [PATCH 3/6] xfs: remove indirect calls from xfs_inode_walk{,_ag}
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:29 -0700
Message-ID: <161671808966.621936.3793779587892431825.stgit@magnolia>
In-Reply-To: <161671807287.621936.13471099564526590235.stgit@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It turns out that there is a 1:1 mapping between the execute and tag
parameters that are passed to xfs_inode_walk_ag:

	xfs_blockgc_scan_inode <=> XFS_ICI_BLOCKGC_TAG

Since the only user of the inode walk function is the blockgc code, we
don't need the tag parameter or the execute function pointer.  The inode
deferred inactivation changes in the next series will add a second
tag:function pair, so we'll leave the tag parameter for now.

For the price of a forward static declaration, we can eliminate the
indirect function call.  This likely has a negligible impact on
performance (since the execute function runs transactions), but it also
simplifies the function signature.

Radix tree tags are unsigned ints, so fix the type usage for all those
tags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |    2 +
 fs/xfs/libxfs/xfs_sb.h |    4 +-
 fs/xfs/xfs_icache.c    |   77 ++++++++++++++++++++----------------------------
 3 files changed, 35 insertions(+), 48 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 60e6d255e5e2..f72f6d7fef33 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -61,7 +61,7 @@ struct xfs_perag *
 xfs_perag_get_tag(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		first,
-	int			tag)
+	unsigned int		tag)
 {
 	struct xfs_perag	*pag;
 	int			found;
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index f79f9dc632b6..e5f1c2d879eb 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -17,8 +17,8 @@ struct xfs_perag;
  * perag get/put wrappers for ref counting
  */
 extern struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
-extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
-					   int tag);
+struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int tag);
 extern void	xfs_perag_put(struct xfs_perag *pag);
 extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 16392e96be91..f4c4f6e15d77 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,6 +26,9 @@
 
 #include <linux/iversion.h>
 
+/* Forward declarations to reduce indirect calls */
+static int xfs_blockgc_scan_inode(struct xfs_inode *ip, void *args);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -723,13 +726,17 @@ xfs_icache_inode_is_allocated(
  */
 #define XFS_LOOKUP_BATCH	32
 
+/* Don't try to run block gc on an inode that's in any of these states. */
+#define XFS_BLOCKGC_INELIGIBLE_IFLAGS	(XFS_INEW | \
+					 XFS_IRECLAIMABLE | \
+					 XFS_IRECLAIM)
 /*
- * Decide if the given @ip is eligible to be a part of the inode walk, and
- * grab it if so.  Returns true if it's ready to go or false if we should just
- * ignore it.
+ * Decide if the given @ip is eligible for garbage collection of speculative
+ * preallocations, and grab it if so.  Returns true if it's ready to go or
+ * false if we should just ignore it.
  */
 STATIC bool
-xfs_inode_walk_ag_grab(
+xfs_blockgc_grab(
 	struct xfs_inode	*ip)
 {
 	struct inode		*inode = VFS_I(ip);
@@ -741,8 +748,7 @@ xfs_inode_walk_ag_grab(
 	if (!ip->i_ino)
 		goto out_unlock_noent;
 
-	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	if (__xfs_iflags_test(ip, XFS_BLOCKGC_INELIGIBLE_IFLAGS))
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -763,15 +769,14 @@ xfs_inode_walk_ag_grab(
 }
 
 /*
- * For a given per-AG structure @pag, grab, @execute, and rele all incore
- * inodes with the given radix tree @tag.
+ * For a given per-AG structure @pag, grab, execute a tag specific function,
+ * and release all incore inodes with the given radix tree @tag.
  */
 STATIC int
 xfs_inode_walk_ag(
 	struct xfs_perag	*pag,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
+	unsigned int		tag,
+	void			*args)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -780,6 +785,8 @@ xfs_inode_walk_ag(
 	bool			done;
 	int			nr_found;
 
+	ASSERT(tag == XFS_ICI_BLOCKGC_TAG);
+
 restart:
 	done = false;
 	skipped = 0;
@@ -792,16 +799,9 @@ xfs_inode_walk_ag(
 
 		rcu_read_lock();
 
-		if (tag == XFS_ICI_NO_TAG)
-			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH);
-		else
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **) batch, first_index,
-					XFS_LOOKUP_BATCH, tag);
-
+		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+				(void **)batch, first_index, XFS_LOOKUP_BATCH,
+				tag);
 		if (!nr_found) {
 			rcu_read_unlock();
 			break;
@@ -814,7 +814,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_inode_walk_ag_grab(ip))
+			if (done || !xfs_blockgc_grab(ip))
 				batch[i] = NULL;
 
 			/*
@@ -842,7 +842,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = execute(batch[i], args);
+			error = xfs_blockgc_scan_inode(batch[i], args);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
@@ -867,38 +867,27 @@ xfs_inode_walk_ag(
 	return last_error;
 }
 
-/* Fetch the next (possibly tagged) per-AG structure. */
-static inline struct xfs_perag *
-xfs_inode_walk_get_perag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	int			tag)
-{
-	if (tag == XFS_ICI_NO_TAG)
-		return xfs_perag_get(mp, agno);
-	return xfs_perag_get_tag(mp, agno, tag);
-}
-
 /*
- * Call the @execute function on all incore inodes matching the radix tree
+ * Call a tag-specific function on all incore inodes matching the radix tree
  * @tag.
  */
 static int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
+	unsigned int		tag,
+	void			*args)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
 	int			last_error = 0;
 	xfs_agnumber_t		ag;
 
+	ASSERT(tag == XFS_ICI_BLOCKGC_TAG);
+
 	ag = 0;
-	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
+	while ((pag = xfs_perag_get_tag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, execute, args, tag);
+		error = xfs_inode_walk_ag(pag, tag, args);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -1610,8 +1599,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk_ag(pag, xfs_blockgc_scan_inode, NULL,
-			XFS_ICI_BLOCKGC_TAG);
+	error = xfs_inode_walk_ag(pag, XFS_ICI_BLOCKGC_TAG, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
@@ -1629,8 +1617,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, xfs_blockgc_scan_inode, eofb,
-			XFS_ICI_BLOCKGC_TAG);
+	return xfs_inode_walk(mp, XFS_ICI_BLOCKGC_TAG, eofb);
 }
 
 /*

