Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9A2C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5983601FD
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhHLA7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhHLA7G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 20:59:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FDC360FE6;
        Thu, 12 Aug 2021 00:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628729922;
        bh=YsTB2Hi3lSS3es40RypSASsux+2NID07CaHfMk5NVRI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DO1YsdKNQ0N9gRT4U5CnMmLJCHeJJfPrLEqvLCDnPnNX7yqnIgRXXyk8/mrbhKAvQ
         CqFXQsES7cnhkRfLJBHb+gIPnvLSvyemMbzDDu80Dj5RPqnzwMPPEN6w+mUiRm1BDB
         UKeuzC0B7dn3okoTnN1XpapteiqAXZ8sdo7TpyUiHd0OlHKJsOPMwVkSCXOhjePFa/
         CdkyTJITovpy8ZRQlUvi0ZRhBQsrQMUt77bKUPc1sOWBBfL2fQdGt8gcUZMGNY73zD
         8c+XBJ/8iyuUiu/+U/H2SBcScq3yHV6U58TABrpYxZ0Ono7xNe+PkgeGp9cg0Mm6bH
         OenaO8NoHenaw==
Subject: [PATCH 1/3] xfs: make xfs_rtalloc_query_range input parameters const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 11 Aug 2021 17:58:42 -0700
Message-ID: <162872992222.1220643.2988115020171417694.stgit@magnolia>
In-Reply-To: <162872991654.1220643.136984377220187940.stgit@magnolia>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 8ad560d2565e, we changed xfs_rtalloc_query_range to constrain
the range of bits in the realtime bitmap file that would actually be
searched.  In commit a3a374bf1889, we changed the range again
(incorrectly), leading to the fix in commit d88850bd5516, which finally
corrected the range check code.  Unfortunately, the author never noticed
that the function modifies its input parameters, which is a totaly no-no
since none of the other range query functions change their input
parameters.

So, fix this function yet again to stash the upper end of the query
range (i.e. the high key) in a local variable and hope this is the last
time I have to fix my own function.  While we're at it, mark the key
inputs const so nobody makes this mistake again. :(

Fixes: 8ad560d2565e ("xfs: strengthen rtalloc query range checks")
Not-fixed-by: a3a374bf1889 ("xfs: fix off-by-one error in xfs_rtalloc_query_range")
Not-fixed-by: d88850bd5516 ("xfs: fix high key handling in the rt allocator's query_range function")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   14 +++++++-------
 fs/xfs/xfs_rtalloc.h         |    7 +++----
 2 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 483375c6a735..5740ba664867 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1009,8 +1009,8 @@ xfs_rtfree_extent(
 int
 xfs_rtalloc_query_range(
 	struct xfs_trans		*tp,
-	struct xfs_rtalloc_rec		*low_rec,
-	struct xfs_rtalloc_rec		*high_rec,
+	const struct xfs_rtalloc_rec	*low_rec,
+	const struct xfs_rtalloc_rec	*high_rec,
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
 {
@@ -1018,6 +1018,7 @@ xfs_rtalloc_query_range(
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			rtstart;
 	xfs_rtblock_t			rtend;
+	xfs_rtblock_t			high_key;
 	int				is_free;
 	int				error = 0;
 
@@ -1026,12 +1027,12 @@ xfs_rtalloc_query_range(
 	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
 	    low_rec->ar_startext == high_rec->ar_startext)
 		return 0;
-	high_rec->ar_startext = min(high_rec->ar_startext,
-			mp->m_sb.sb_rextents - 1);
+
+	high_key = min(high_rec->ar_startext, mp->m_sb.sb_rextents - 1);
 
 	/* Iterate the bitmap, looking for discrepancies. */
 	rtstart = low_rec->ar_startext;
-	while (rtstart <= high_rec->ar_startext) {
+	while (rtstart <= high_key) {
 		/* Is the first block free? */
 		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
 				&is_free);
@@ -1039,8 +1040,7 @@ xfs_rtalloc_query_range(
 			break;
 
 		/* How long does the extent go for? */
-		error = xfs_rtfind_forw(mp, tp, rtstart,
-				high_rec->ar_startext, &rtend);
+		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtend);
 		if (error)
 			break;
 
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index ed885620589c..51097cb24311 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -124,10 +124,9 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_trans *tp,
-			    struct xfs_rtalloc_rec *low_rec,
-			    struct xfs_rtalloc_rec *high_rec,
-			    xfs_rtalloc_query_range_fn fn,
-			    void *priv);
+		const struct xfs_rtalloc_rec *low_rec,
+		const struct xfs_rtalloc_rec *high_rec,
+		xfs_rtalloc_query_range_fn fn, void *priv);
 int xfs_rtalloc_query_all(struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);

