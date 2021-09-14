Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6492DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4999F610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhINCmA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235956AbhINCmA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04294610D1;
        Tue, 14 Sep 2021 02:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587244;
        bh=jpfcyie9bkmFuskhDBl3ijD3CdsjM40haGnXRYw95Bk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FeUlCnkS6uCf43A41+tXjZHVBN5EEW+GrM8/Jaa8G6FhpryRulwdLyJbBca/goKky
         HE/IwBKbsE4HF0gad8aadCIzWINyo/pleykuJ3rFiNo4x1RKQ5Tez1nfj0fNh5l/t+
         pLea0ZDKndsy61suZPCFysWJHU0gJGC5CEDJ7oc0W+eHMUxT6Os94/3PjjMuhOp9/j
         8Qfjh7KUK0nif0rEFZF7KzmI+6ibXPl5rMtyEwaqMSJIqLc68Wxpmpuzyd42wrk21i
         l5AvWkYV1yqp+i5Mqr/ET30NM8Zf1oCYHIovBmz311gZV1EaRSFHk8iKIDR9XXqepC
         ofku1jF3PbLdQ==
Subject: [PATCH 08/43] xfs: make xfs_rtalloc_query_range input parameters
 const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:40:43 -0700
Message-ID: <163158724376.1604118.15383914226937184991.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c02f6529864a4f5f91d216d324bac4ba75415d19

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h  |   10 +++++-----
 libxfs/xfs_rtbitmap.c |   14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index b9cb302a..07fc2942 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -603,9 +603,9 @@ struct xfs_rtalloc_rec {
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(
-	struct xfs_trans	*tp,
-	struct xfs_rtalloc_rec	*rec,
-	void			*priv);
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv);
 
 int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
                         xfs_off_t count_fsb);
@@ -699,8 +699,8 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_trans *tp,
-			    struct xfs_rtalloc_rec *low_rec,
-			    struct xfs_rtalloc_rec *high_rec,
+			    const struct xfs_rtalloc_rec *low_rec,
+			    const struct xfs_rtalloc_rec *high_rec,
 			    xfs_rtalloc_query_range_fn fn,
 			    void *priv);
 int xfs_rtalloc_query_all(struct xfs_trans *tp,
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index f08efb7c..15da0496 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1007,8 +1007,8 @@ xfs_rtfree_extent(
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
@@ -1016,6 +1016,7 @@ xfs_rtalloc_query_range(
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			rtstart;
 	xfs_rtblock_t			rtend;
+	xfs_rtblock_t			high_key;
 	int				is_free;
 	int				error = 0;
 
@@ -1024,12 +1025,12 @@ xfs_rtalloc_query_range(
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
@@ -1037,8 +1038,7 @@ xfs_rtalloc_query_range(
 			break;
 
 		/* How long does the extent go for? */
-		error = xfs_rtfind_forw(mp, tp, rtstart,
-				high_rec->ar_startext, &rtend);
+		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtend);
 		if (error)
 			break;
 

