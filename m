Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D0FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344834AbiATASQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344962AbiATASP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21410C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9FCEB81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897CCC004E1;
        Thu, 20 Jan 2022 00:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637892;
        bh=cOtgoZt2p8QFriir7ODzL0L4RFIa7uB8hGR+5waqL/k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ig2eIYSgb57g80obcjsJzI/ckbjQWMOE7eIH+vTsHW0DsRvIQEf7qH9d/16+VAXX+
         TAvs8nLXGg9rGMxPvkux9fYgJantFcPWbrwrLNHyAShTuFtF7vIUxJPV8lv3G7ExZa
         BkI3z5N/n0UYMYSBjRTEFb2+g8ENS3k/4mcUCSF+038A29FFMXf3sJG75qvaVN1A1T
         uqP7dTa5CXcDFPwZzSQNrSieB4iSt48eH5G+HOKOhaKjFpeP6rCjZuUxg9QyspRP82
         4feaQbUhtnW/YX5H9ebPcVNtqyJmOnKCpXpP4vRCsdKZHhYuFRLwHmD08VfZxbFPgg
         F8TVDiTe94Ogg==
Subject: [PATCH 09/45] xfs: make xfs_rtalloc_query_range input parameters
 const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:12 -0800
Message-ID: <164263789222.860211.17077294228532604196.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
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
index 15bae1ff..0214919c 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -602,9 +602,9 @@ struct xfs_rtalloc_rec {
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
@@ -698,8 +698,8 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
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
 

