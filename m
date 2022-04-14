Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B7FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347374AbiDNW5C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbiDNW5C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:57:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C26D165A2
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 521F1B82B9B
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDECC385A1;
        Thu, 14 Apr 2022 22:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976872;
        bh=ceSmxSyXSDS1zHDE7Iav0CXqPd+Q8Q2ebTbThqGUoV0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lKDfqtJpOq9yCKOMUnKQ9+hE+Of0KFqjVj/QqK6gMeUO6nf0YVgldUGG9aDUTNB9i
         jiwHCZO1FJo290BydOxN8GenjAnLe62Y+6nnJwglYPP5NV+P4yUm4XVhkYwqESj1ar
         I/Wn+LTrVSknv3DTm4+UtbW4xd+udMGIlB+DIwzQW3h+p2V+W+VvoT6l9OE2uSM4oU
         beACABL/uWnys9kmxsbGFjF8AIL1u3Y03Pp7tCED1eBQ7H9yeCA2oTcYMnUssr+GmZ
         H0CDwuXPUHkNltzZx9jHPiiszpbKjQSUbNR1HZV0jigWqCjfzrJj8/q6SMjHiiWMbn
         omSKQln+ore1Q==
Subject: [PATCH 1/6] xfs: stop artificially limiting the length of bunmap
 calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:31 -0700
Message-ID: <164997687142.383881.7160925177236303538.stgit@magnolia>
In-Reply-To: <164997686569.383881.8935566398533700022.stgit@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit e1a4e37cc7b6, we clamped the length of bunmapi calls on the
data forks of shared files to avoid two failure scenarios: one where the
extent being unmapped is so sparsely shared that we exceed the
transaction reservation with the sheer number of refcount btree updates
and EFI intent items; and the other where we attach so many deferred
updates to the transaction that we pin the log tail and later the log
head meets the tail, causing the log to livelock.

We avoid triggering the first problem by tracking the number of ops in
the refcount btree cursor and forcing a requeue of the refcount intent
item any time we think that we might be close to overflowing.  This has
been baked into XFS since before the original e1a4 patch.

A recent patchset fixed the second problem by changing the deferred ops
code to finish all the work items created by each round of trying to
complete a refcount intent item, which eliminates the long chains of
deferred items (27dad); and causing long-running transactions to relog
their intent log items when space in the log gets low (74f4d).

Because this clamp affects /any/ unmapping request regardless of the
sharing factors of the component blocks, it degrades the performance of
all large unmapping requests -- whereas with an unshared file we can
unmap millions of blocks in one go, shared files are limited to
unmapping a few thousand blocks at a time, which causes the upper level
code to spin in a bunmapi loop even if it wasn't needed.

This also eliminates one more place where log recovery behavior can
differ from online behavior, because bunmapi operations no longer need
to requeue.

Partial-revert-of: e1a4e37cc7b6 ("xfs: try to avoid blowing out the transaction reservation when bunmaping a shared extent")
Depends: 27dada070d59 ("xfs: change the order in which child and parent defer ops ar finished")
Depends: 74f4d6a1e065 ("xfs: only relog deferred intent items if free space in the log gets low")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |   22 +---------------------
 fs/xfs/libxfs/xfs_refcount.c |    5 ++---
 fs/xfs/libxfs/xfs_refcount.h |    8 ++------
 3 files changed, 5 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 74198dd82b03..432597e425c1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5299,7 +5299,6 @@ __xfs_bunmapi(
 	int			whichfork;	/* data or attribute fork */
 	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
-	xfs_fileoff_t		max_len;
 	xfs_fileoff_t		end;
 	struct xfs_iext_cursor	icur;
 	bool			done = false;
@@ -5318,16 +5317,6 @@ __xfs_bunmapi(
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
 
-	/*
-	 * Guesstimate how many blocks we can unmap without running the risk of
-	 * blowing out the transaction with a mix of EFIs and reflink
-	 * adjustments.
-	 */
-	if (tp && xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK)
-		max_len = min(len, xfs_refcount_max_unmap(tp->t_log_res));
-	else
-		max_len = len;
-
 	error = xfs_iread_extents(tp, ip, whichfork);
 	if (error)
 		return error;
@@ -5366,7 +5355,7 @@ __xfs_bunmapi(
 
 	extno = 0;
 	while (end != (xfs_fileoff_t)-1 && end >= start &&
-	       (nexts == 0 || extno < nexts) && max_len > 0) {
+	       (nexts == 0 || extno < nexts)) {
 		/*
 		 * Is the found extent after a hole in which end lives?
 		 * Just back up to the previous extent, if so.
@@ -5400,14 +5389,6 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
-		/* How much can we safely unmap? */
-		if (max_len < del.br_blockcount) {
-			del.br_startoff += del.br_blockcount - max_len;
-			if (!wasdel)
-				del.br_startblock += del.br_blockcount - max_len;
-			del.br_blockcount = max_len;
-		}
-
 		if (!isrt)
 			goto delete;
 
@@ -5543,7 +5524,6 @@ __xfs_bunmapi(
 		if (error)
 			goto error0;
 
-		max_len -= del.br_blockcount;
 		end = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 327ba25e9e17..a07ebaecba73 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -960,6 +960,7 @@ xfs_refcount_adjust_extents(
 			 * Either cover the hole (increment) or
 			 * delete the range (decrement).
 			 */
+			cur->bc_ag.refc.nr_ops++;
 			if (tmp.rc_refcount) {
 				error = xfs_refcount_insert(cur, &tmp,
 						&found_tmp);
@@ -970,7 +971,6 @@ xfs_refcount_adjust_extents(
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
-				cur->bc_ag.refc.nr_ops++;
 			} else {
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 						cur->bc_ag.pag->pag_agno,
@@ -1001,11 +1001,11 @@ xfs_refcount_adjust_extents(
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, &ext);
+		cur->bc_ag.refc.nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
 				goto out_error;
-			cur->bc_ag.refc.nr_ops++;
 		} else if (ext.rc_refcount == 1) {
 			error = xfs_refcount_delete(cur, &found_rec);
 			if (error)
@@ -1014,7 +1014,6 @@ xfs_refcount_adjust_extents(
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
-			cur->bc_ag.refc.nr_ops++;
 			goto advloop;
 		} else {
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 9eb01edbd89d..6b265f6075b8 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -66,15 +66,11 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
  * reservation and crash the fs.  Each record adds 12 bytes to the
  * log (plus any key updates) so we'll conservatively assume 32 bytes
  * per record.  We must also leave space for btree splits on both ends
- * of the range and space for the CUD and a new CUI.
+ * of the range and space for the CUD and a new CUI.  Each EFI that we
+ * attach to the transaction also consumes ~32 bytes.
  */
 #define XFS_REFCOUNT_ITEM_OVERHEAD	32
 
-static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
-{
-	return (log_res * 3 / 4) / XFS_REFCOUNT_ITEM_OVERHEAD;
-}
-
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
 union xfs_btree_rec;

