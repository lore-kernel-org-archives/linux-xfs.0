Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A426BC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjEZAnE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbjEZAnC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:43:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2FE19C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:43:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2385D61B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86659C4339B;
        Fri, 26 May 2023 00:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061779;
        bh=sOdcbonl9bGWuv3on5P1NJgcZ4JTOs93JtmqhTD1700=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=HEKiQryDxRLSW5NqDBB3azrUBuQmkeG54O2BMWkfsSe9tcwJ33kPOKovsUru1wgsa
         VwkfvCxotTje/yxRc/z9leEova0VnJ9bhGKPrhGDKgA/Tyb1nMOFOQrx3dI1S996co
         ecgWKGmK0+DRROpHh6kf7drWJV/7ffaPuhMG37ztlI92ZpHuXkrQRDZlLf8ifPkqnj
         HKTFILbpT9OxeGdyo2FoCmZGf2ufrIBlXo3TjAlMa4ZFzfidoNrq4HsAr691GCHB6y
         oXMg5QvVotwYa+4bB+TTMp6wWDYUg/wXC6dr5nxZ3cJaLNh11NxqiuV49OLhlE9bKW
         dvn9jFFpYgraw==
Date:   Thu, 25 May 2023 17:42:59 -0700
Subject: [PATCH 7/7] xfs: fix xfs_btree_query_range callers to initialize
 btree rec fully
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055297.3727958.15981456378635751082.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
References: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use struct initializers to ensure that the xfs_btree_irecs passed into
the query_range function are completely initialized.  No functional
changes, just closing some sloppy hygiene.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c    |   10 +++-------
 fs/xfs/libxfs/xfs_refcount.c |   13 +++++++------
 fs/xfs/libxfs/xfs_rmap.c     |   10 +++-------
 3 files changed, 13 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fdfa08cbf4db..fe096f20f4c2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3717,15 +3717,11 @@ xfs_alloc_query_range(
 	xfs_alloc_query_range_fn		fn,
 	void					*priv)
 {
-	union xfs_btree_irec			low_brec;
-	union xfs_btree_irec			high_brec;
-	struct xfs_alloc_query_range_info	query;
+	union xfs_btree_irec			low_brec = { .a = *low_rec };
+	union xfs_btree_irec			high_brec = { .a = *high_rec };
+	struct xfs_alloc_query_range_info	query = { .priv = priv, .fn = fn };
 
 	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
-	low_brec.a = *low_rec;
-	high_brec.a = *high_rec;
-	query.priv = priv;
-	query.fn = fn;
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_alloc_query_range_helper, &query);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index c1c65774dcc2..cd21cb1c9058 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1915,8 +1915,13 @@ xfs_refcount_recover_cow_leftovers(
 	struct xfs_buf			*agbp;
 	struct xfs_refcount_recovery	*rr, *n;
 	struct list_head		debris;
-	union xfs_btree_irec		low;
-	union xfs_btree_irec		high;
+	union xfs_btree_irec		low = {
+		.rc.rc_domain		= XFS_REFC_DOMAIN_COW,
+	};
+	union xfs_btree_irec		high = {
+		.rc.rc_domain		= XFS_REFC_DOMAIN_COW,
+		.rc.rc_startblock	= -1U,
+	};
 	xfs_fsblock_t			fsb;
 	int				error;
 
@@ -1947,10 +1952,6 @@ xfs_refcount_recover_cow_leftovers(
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
 
 	/* Find all the leftover CoW staging extents. */
-	memset(&low, 0, sizeof(low));
-	memset(&high, 0, sizeof(high));
-	low.rc.rc_domain = high.rc.rc_domain = XFS_REFC_DOMAIN_COW;
-	high.rc.rc_startblock = -1U;
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
 	xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index f4dc23b3b837..fbb0b2637463 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2389,14 +2389,10 @@ xfs_rmap_query_range(
 	xfs_rmap_query_range_fn			fn,
 	void					*priv)
 {
-	union xfs_btree_irec			low_brec;
-	union xfs_btree_irec			high_brec;
-	struct xfs_rmap_query_range_info	query;
+	union xfs_btree_irec			low_brec = { .r = *low_rec };
+	union xfs_btree_irec			high_brec = { .r = *high_rec };
+	struct xfs_rmap_query_range_info	query = { .priv = priv, .fn = fn };
 
-	low_brec.r = *low_rec;
-	high_brec.r = *high_rec;
-	query.priv = priv;
-	query.fn = fn;
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_rmap_query_range_helper, &query);
 }

