Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167EAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28B76108E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhJNUTY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231708AbhJNUTW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AB7C6105A;
        Thu, 14 Oct 2021 20:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242637;
        bh=NKoWYhGgZ7I7MXKnkjZaiF3+7hue06OMvYBfpyh+eWg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Lo08GSvsvdzwkLVH0F4te9wPRauLGZW86GnJHE6f7B1l/TBQJzXs5rEh7J3Wsrgav
         T2AwXTuLymokgexNZR2isUCZt+IMUqKHrTDV0CxuxgVLPTglk8QXfXPPwenIcCM1yC
         eUfvO4bjsxFI8D4KLBAmIxpgkPSyj8H6C2qXBS1uaIGZUUm/AupGm6mzvcRcjTJeAn
         +7H8UehKIw+Ks3MElW1Te5MEIVG/WcvzL2Db3N7T5EfZQ4S1mieJ58e/b9pFOT7mgl
         1sKsQymeMZLk5rPxJuYObjQNXMYmzhv300/dJwPb9UCq1KY7yHTyE1rYQYU2SBtmoa
         kHrr3Okk0DRXw==
Subject: [PATCH 04/17] xfs: don't track firstrec/firstkey separately in
 xchk_btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:17 -0700
Message-ID: <163424263699.756780.408883477457816376.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The btree scrubbing code checks that the records (or keys) that it finds
in a btree block are all in order by calling the btree cursor's
->recs_inorder function.  This of course makes no sense for the first
item in the block, so we switch that off with a separate variable in
struct xchk_btree.

Christoph helped me figure out that the variable is unnecessary, since
we just accessed bc_ptrs[level] and can compare that against zero.  Use
that, and save ourselves some memory space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/btree.c |   11 +++--------
 fs/xfs/scrub/btree.h |    2 --
 2 files changed, 3 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 26dcb4691e31..d5e1ca521fc4 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -141,9 +141,9 @@ xchk_btree_rec(
 	trace_xchk_btree_rec(bs->sc, cur, 0);
 
 	/* If this isn't the first record, are they in order? */
-	if (!bs->firstrec && !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
+	if (cur->bc_ptrs[0] > 1 &&
+	    !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
 		xchk_btree_set_corrupt(bs->sc, cur, 0);
-	bs->firstrec = false;
 	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
 
 	if (cur->bc_nlevels == 1)
@@ -188,10 +188,9 @@ xchk_btree_key(
 	trace_xchk_btree_key(bs->sc, cur, level);
 
 	/* If this isn't the first key, are they in order? */
-	if (!bs->firstkey[level] &&
+	if (cur->bc_ptrs[level] > 1 &&
 	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key))
 		xchk_btree_set_corrupt(bs->sc, cur, level);
-	bs->firstkey[level] = false;
 	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
 
 	if (level + 1 >= cur->bc_nlevels)
@@ -636,7 +635,6 @@ xchk_btree(
 	struct xfs_buf			*bp;
 	struct check_owner		*co;
 	struct check_owner		*n;
-	int				i;
 	int				error = 0;
 
 	/*
@@ -649,13 +647,10 @@ xchk_btree(
 	bs->cur = cur;
 	bs->scrub_rec = scrub_fn;
 	bs->oinfo = oinfo;
-	bs->firstrec = true;
 	bs->private = private;
 	bs->sc = sc;
 
 	/* Initialize scrub state */
-	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
-		bs->firstkey[i] = true;
 	INIT_LIST_HEAD(&bs->to_check);
 
 	/* Don't try to check a tree with a height we can't handle. */
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index b7d2fc01fbf9..7671108f9f85 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -39,9 +39,7 @@ struct xchk_btree {
 
 	/* internal scrub state */
 	union xfs_btree_rec		lastrec;
-	bool				firstrec;
 	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
-	bool				firstkey[XFS_BTREE_MAXLEVELS];
 	struct list_head		to_check;
 };
 int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,

