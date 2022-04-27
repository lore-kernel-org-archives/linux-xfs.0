Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5164C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356540AbiD0AzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356529AbiD0AzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA69E13EBC
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:52:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0EDDB82452
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6765DC385A4;
        Wed, 27 Apr 2022 00:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020718;
        bh=3bJtYCzRWx9eWSGjNIeVayXHliKM5WbyeqKhBZvj9ek=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hG850jgwfpaDTzqWgfV9vGc25RE5dAwT2RswqjUNQ9DXu3Rg4KNmr78BkyKWY89TV
         yQWcsfp5dXg2pbHQzN8JR54UywMQJiaOfdSB8Rre07wlDxXqbtNZ9WDtJw/Tk7RzdK
         k7FDZxwt1esdphZc0IDT2QHBlzkOwICJQNVfTqT/KmD7KmFmpTn2R/giwz65Xb7ZC0
         Kz4saowNP4pIynuejX/bR9Vw8INhEKe8ubmVdTPoFzQ0jVfR33OiulIZ23gICFxCuz
         zDn3mgHpshtzRdgI+jh+QE2miFr0eZnRK9sEDmxnB9bIYRhhx1twwApOOXOByy36rO
         7Zs3k6WjHkqSg==
Subject: [PATCH 1/9] xfs: count EFIs when deciding to ask for a continuation
 of a refcount update
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:51:58 -0700
Message-ID: <165102071799.3922658.11838016511226658958.stgit@magnolia>
In-Reply-To: <165102071223.3922658.5241787533081256670.stgit@magnolia>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A long time ago, I added to XFS the ability to use deferred reference
count operations as part of a transaction chain.  This enabled us to
avoid blowing out the transaction reservation when the blocks in a
physical extent all had different reference counts because we could ask
the deferred operation manager for a continuation, which would get us a
clean transaction.

The refcount code asks for a continuation when the number of refcount
record updates reaches the point where we think that the transaction has
logged enough full btree blocks due to refcount (and free space) btree
shape changes and refcount record updates that we're in danger of
overflowing the transaction.

We did not previously count the EFIs logged to the refcount update
transaction because the clamps on the length of a bunmap operation were
sufficient to avoid overflowing the transaction reservation even in the
worst case situation where every other block of the unmapped extent is
shared.

Unfortunately, the restrictions on bunmap length avoid failure in the
worst case by imposing a maximum unmap length of ~3000 blocks, even for
non-pathological cases.  This seriously limits performance when freeing
large extents.

Therefore, track EFIs with the same counter as refcount record updates,
and use that information as input into when we should ask for a
continuation.  This enables the next patch to drop the clumsy bunmap
limitation.

Depends: 27dada070d59 ("xfs: change the order in which child and parent defer ops ar finished")
Depends: 74f4d6a1e065 ("xfs: only relog deferred intent items if free space in the log gets low")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |    5 ++---
 fs/xfs/libxfs/xfs_refcount.h |   13 ++++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)


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
index 9eb01edbd89d..e8b322de7f3d 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -67,14 +67,17 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
  * log (plus any key updates) so we'll conservatively assume 32 bytes
  * per record.  We must also leave space for btree splits on both ends
  * of the range and space for the CUD and a new CUI.
+ *
+ * Each EFI that we attach to the transaction is assumed to consume ~32 bytes.
+ * This is a low estimate for an EFI tracking a single extent (16 bytes for the
+ * EFI header, 16 for the extent, and 12 for the xlog op header), but the
+ * estimate is acceptable if there's more than one extent being freed.
+ * In the worst case of freeing every other block during a refcount decrease
+ * operation, we amortize the space used for one EFI log item across 16
+ * extents.
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

