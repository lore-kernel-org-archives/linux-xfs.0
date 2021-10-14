Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B72AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023CC610D2
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJNUUM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNUUL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1E6861027;
        Thu, 14 Oct 2021 20:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242686;
        bh=uW6D7WVIMwtj4icj6s9kJfNgbYDdftx6KJ/r/X0XKYg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y4lVCRNEfQFyh/XzuvpUuNKMH8CaXBzeqj4/MjHoi6a1tj3TVRMFyZgGaAiqZRIbP
         sehwLl7JcCS+rwedSyeoNptpmJwqoRf1mAyBbdoTy4aUGgHNec9JdTnyc+ecBC30nm
         diHBH3aHXWGQZHIvQjvcafHrD5Dpez0DyrPbkh6OvbWa5JNvY5xys2uF6A1IyufmSY
         ZwcNl75zRokxYRqo+tco9DzRASxxA/h2jtu2aIPRo+iGbv1NFNvrWSAZDL/W8ffeMQ
         +ZWIaXmRjb8PD4zy2LgYHzEnSjUbYQSQnnhoTENaybG9UenJ862EOQ+tQ5UgyoRQM8
         931LWAK6kQVqg==
Subject: [PATCH 13/17] xfs: clean up xfs_btree_{calc_size,compute_maxlevels}
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:18:06 -0700
Message-ID: <163424268640.756780.16867563565459554272.stgit@magnolia>
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

During review of the next patch, Dave remarked that he found these two
btree geometry calculation functions lacking in documentation and that
they performed more work than was really necessary.

These functions take the same parameters and have nearly the same logic;
the only real difference is in the return values.  Reword the function
comment to make it clearer what each function does, and move them to be
adjacent to reinforce their relation.

Clean up both of them to stop opencoding the howmany functions, stop
using the uint typedefs, and make them both support computations for
more than 2^32 leaf records, since we're going to need all of the above
for files with large data forks and large rmap btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   67 ++++++++++++++++++++++-----------------------
 fs/xfs/libxfs/xfs_btree.h |    6 +++-
 2 files changed, 37 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6ced8f028d47..4d95a3bb05cd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4514,21 +4514,43 @@ xfs_btree_sblock_verify(
 }
 
 /*
- * Calculate the number of btree levels needed to store a given number of
- * records in a short-format btree.
+ * For the given limits on leaf and keyptr records per block, calculate the
+ * height of the tree needed to index the number of leaf records.
  */
-uint
+unsigned int
 xfs_btree_compute_maxlevels(
-	uint			*limits,
-	unsigned long		len)
+	const unsigned int	*limits,
+	unsigned long long	records)
 {
-	uint			level;
-	unsigned long		maxblocks;
+	unsigned long long	level_blocks = howmany_64(records, limits[0]);
+	unsigned int		height = 1;
 
-	maxblocks = (len + limits[0] - 1) / limits[0];
-	for (level = 1; maxblocks > 1; level++)
-		maxblocks = (maxblocks + limits[1] - 1) / limits[1];
-	return level;
+	while (level_blocks > 1) {
+		level_blocks = howmany_64(level_blocks, limits[1]);
+		height++;
+	}
+
+	return height;
+}
+
+/*
+ * For the given limits on leaf and keyptr records per block, calculate the
+ * number of blocks needed to index the given number of leaf records.
+ */
+unsigned long long
+xfs_btree_calc_size(
+	const unsigned int	*limits,
+	unsigned long long	records)
+{
+	unsigned long long	level_blocks = howmany_64(records, limits[0]);
+	unsigned long long	blocks = level_blocks;
+
+	while (level_blocks > 1) {
+		level_blocks = howmany_64(level_blocks, limits[1]);
+		blocks += level_blocks;
+	}
+
+	return blocks;
 }
 
 /*
@@ -4822,29 +4844,6 @@ xfs_btree_query_all(
 	return xfs_btree_simple_query_range(cur, &low_key, &high_key, fn, priv);
 }
 
-/*
- * Calculate the number of blocks needed to store a given number of records
- * in a short-format (per-AG metadata) btree.
- */
-unsigned long long
-xfs_btree_calc_size(
-	uint			*limits,
-	unsigned long long	len)
-{
-	int			level;
-	int			maxrecs;
-	unsigned long long	rval;
-
-	maxrecs = limits[0];
-	for (level = 0, rval = 0; len > 1; level++) {
-		len += maxrecs - 1;
-		do_div(len, maxrecs);
-		maxrecs = limits[1];
-		rval += len;
-	}
-	return rval;
-}
-
 static int
 xfs_btree_count_blocks_helper(
 	struct xfs_btree_cur	*cur,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b46cd98309fa..3bd69fe425a7 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -487,8 +487,10 @@ xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp,
 xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
 
-uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
-unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
+unsigned int xfs_btree_compute_maxlevels(const unsigned int *limits,
+		unsigned long long records);
+unsigned long long xfs_btree_calc_size(const unsigned int *limits,
+		unsigned long long records);
 
 /*
  * Return codes for the query range iterator function are 0 to continue

