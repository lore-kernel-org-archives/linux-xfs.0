Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF1CC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0406A2083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nIajfZNu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgEGMUo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725949AbgEGMUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFC6C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6Jb2ddt5g3eZLEFIQrD5xuyhkEDzmauny+zGDVBj+sk=; b=nIajfZNuOpD2mgU8y1MQvNjh68
        uS/dt8t3Yn5ZPZ4rKrVg8tJyAFzBldL0tV8Yaf61bU3xjfz4JrKbZh04MRagQDT5xBQXJfHP7LoU6
        hqjHvgiqIiZhfCon/gbrqHW6R60cE8bV3SfZpDJqJMwr/3M935Z9bgLtbT1JG/Fu0qoWvyUy0zZeq
        RCGjzBFRK0/lnTlFadPtTJOh+UszpVXpmEV4q1mi/irerBt2A+TjQH40ajc5lRUwNuttmUwctZZ+s
        B3ct7yf6YZnZnOsyZI/nVYY5zrRR9tJRuIC1IIAwUQLHkJEGZoigit0kipEOxtegcn3xH749G8T4f
        9T9W1bIg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfW7-0007je-Kg; Thu, 07 May 2020 12:20:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 45/58] xfs: make the btree ag cursor private union anonymous
Date:   Thu,  7 May 2020 14:18:38 +0200
Message-Id: <20200507121851.304002-46-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: c4aa10d041968f55f00fe8ca768b6f45f4066a69

This is much less widely used than the bc_private union was, so this
is done as a single patch. The named union xfs_btree_cur_private
goes away and is embedded into the struct xfs_btree_cur_ag as an
anonymous union, and the code is modified via this script:

$ sed -i 's/priv\.\([abt|refc]\)/\1/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc.c          | 14 +++++++-------
 libxfs/xfs_alloc_btree.c    |  2 +-
 libxfs/xfs_btree.h          | 25 +++++++++++--------------
 libxfs/xfs_refcount.c       | 24 ++++++++++++------------
 libxfs/xfs_refcount_btree.c |  4 ++--
 5 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 434856ea..841b0305 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -147,7 +147,7 @@ xfs_alloc_lookup_eq(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -167,7 +167,7 @@ xfs_alloc_lookup_ge(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -186,7 +186,7 @@ xfs_alloc_lookup_le(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -194,7 +194,7 @@ static inline bool
 xfs_alloc_cur_active(
 	struct xfs_btree_cur	*cur)
 {
-	return cur && cur->bc_ag.priv.abt.active;
+	return cur && cur->bc_ag.abt.active;
 }
 
 /*
@@ -904,7 +904,7 @@ xfs_alloc_cur_check(
 		deactivate = true;
 out:
 	if (deactivate)
-		cur->bc_ag.priv.abt.active = false;
+		cur->bc_ag.abt.active = false;
 	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
 				  *new);
 	return 0;
@@ -1348,7 +1348,7 @@ xfs_alloc_walk_iter(
 		if (error)
 			return error;
 		if (i == 0)
-			cur->bc_ag.priv.abt.active = false;
+			cur->bc_ag.abt.active = false;
 
 		if (count > 0)
 			count--;
@@ -1463,7 +1463,7 @@ xfs_alloc_ag_vextent_locality(
 		if (error)
 			return error;
 		if (i) {
-			acur->cnt->bc_ag.priv.abt.active = true;
+			acur->cnt->bc_ag.abt.active = true;
 			fbcur = acur->cnt;
 			fbinc = false;
 		}
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index dac354b1..72983927 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -505,7 +505,7 @@ xfs_allocbt_init_cursor(
 
 	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
-	cur->bc_ag.priv.abt.active = false;
+	cur->bc_ag.abt.active = false;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 5e1bae45..6faed214 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -177,22 +177,19 @@ union xfs_btree_irec {
 	struct xfs_refcount_irec	rc;
 };
 
-/* Per-AG btree private information. */
-union xfs_btree_cur_private {
-	struct {
-		unsigned long	nr_ops;		/* # record updates */
-		int		shape_changes;	/* # of extent splits */
-	} refc;
-	struct {
-		bool		active;		/* allocation cursor state */
-	} abt;
-};
-
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	struct xfs_buf			*agbp;
-	xfs_agnumber_t			agno;
-	union xfs_btree_cur_private	priv;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;
+	union {
+		struct {
+			unsigned long nr_ops;	/* # record updates */
+			int	shape_changes;	/* # of extent splits */
+		} refc;
+		struct {
+			bool	active;		/* allocation cursor state */
+		} abt;
+	};
 };
 
 /* Btree-in-inode cursor information */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 4d7f465a..723c903e 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -882,7 +882,7 @@ xfs_refcount_still_have_space(
 {
 	unsigned long			overhead;
 
-	overhead = cur->bc_ag.priv.refc.shape_changes *
+	overhead = cur->bc_ag.refc.shape_changes *
 			xfs_allocfree_log_count(cur->bc_mp, 1);
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
@@ -890,17 +890,17 @@ xfs_refcount_still_have_space(
 	 * Only allow 2 refcount extent updates per transaction if the
 	 * refcount continue update "error" has been injected.
 	 */
-	if (cur->bc_ag.priv.refc.nr_ops > 2 &&
+	if (cur->bc_ag.refc.nr_ops > 2 &&
 	    XFS_TEST_ERROR(false, cur->bc_mp,
 			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
 		return false;
 
-	if (cur->bc_ag.priv.refc.nr_ops == 0)
+	if (cur->bc_ag.refc.nr_ops == 0)
 		return true;
 	else if (overhead > cur->bc_tp->t_log_res)
 		return false;
 	return  cur->bc_tp->t_log_res - overhead >
-		cur->bc_ag.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
+		cur->bc_ag.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
 /*
@@ -967,7 +967,7 @@ xfs_refcount_adjust_extents(
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
-				cur->bc_ag.priv.refc.nr_ops++;
+				cur->bc_ag.refc.nr_ops++;
 			} else {
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 						cur->bc_ag.agno,
@@ -1002,7 +1002,7 @@ xfs_refcount_adjust_extents(
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
 				goto out_error;
-			cur->bc_ag.priv.refc.nr_ops++;
+			cur->bc_ag.refc.nr_ops++;
 		} else if (ext.rc_refcount == 1) {
 			error = xfs_refcount_delete(cur, &found_rec);
 			if (error)
@@ -1011,7 +1011,7 @@ xfs_refcount_adjust_extents(
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
-			cur->bc_ag.priv.refc.nr_ops++;
+			cur->bc_ag.refc.nr_ops++;
 			goto advloop;
 		} else {
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
@@ -1087,7 +1087,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_ag.priv.refc.shape_changes++;
+		cur->bc_ag.refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
@@ -1165,8 +1165,8 @@ xfs_refcount_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.agno != agno) {
-		nr_ops = rcur->bc_ag.priv.refc.nr_ops;
-		shape_changes = rcur->bc_ag.priv.refc.shape_changes;
+		nr_ops = rcur->bc_ag.refc.nr_ops;
+		shape_changes = rcur->bc_ag.refc.shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -1182,8 +1182,8 @@ xfs_refcount_finish_one(
 			error = -ENOMEM;
 			goto out_cur;
 		}
-		rcur->bc_ag.priv.refc.nr_ops = nr_ops;
-		rcur->bc_ag.priv.refc.shape_changes = shape_changes;
+		rcur->bc_ag.refc.nr_ops = nr_ops;
+		rcur->bc_ag.refc.shape_changes = shape_changes;
 	}
 	*pcur = rcur;
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 4d925617..256229e9 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -339,8 +339,8 @@ xfs_refcountbt_init_cursor(
 	cur->bc_ag.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ag.priv.refc.nr_ops = 0;
-	cur->bc_ag.priv.refc.shape_changes = 0;
+	cur->bc_ag.refc.nr_ops = 0;
+	cur->bc_ag.refc.shape_changes = 0;
 
 	return cur;
 }
-- 
2.26.2

