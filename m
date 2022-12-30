Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC28CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiLaCZl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiLaCZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:25:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6189919C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:25:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED1D061CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FF1C433EF;
        Sat, 31 Dec 2022 02:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453538;
        bh=4Qp617zrANHrRn0rm1vEOtucpbyLaeJFfCMUlBKA4yg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JLyDAzrr661hxCXe1Kq9O8ISEnPodo9wheWuhYEp1MqtHx6awUACNEcY6i31/DUaW
         pT79xc9AawYejlp70o/BfOGiCf7FwaZUeNLbAgpOhnCciTlNbeVsu6Dfb7ZjKEO6Zs
         Mg46Ur/Q9H/Gls/Yf8F2nLMSMiBKozWPvCEsYB2O8RnOS/OZ5Gzogi3JVAhQaEHO1+
         rLOrWFkxfF2jZfg8wawToYjLJBznhK8/tOY0XxLMUgXiRJQnPkX6bRg3NZ0VWccRlz
         8g2Umz2dprsWQ0ltIc3K6OqDMvj84iLodN29b9TX7hNalN2GJwiRlls5jl+45fy71u
         2FbobmqE1SHNQ==
Subject: [PATCH 5/9] xfs: create helpers for rtbitmap block/wordcount
 computations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:32 -0800
Message-ID: <167243877295.727982.18027474219615629039.stgit@magnolia>
In-Reply-To: <167243877226.727982.8292582053571487702.stgit@magnolia>
References: <167243877226.727982.8292582053571487702.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create helper functions that compute the number of blocks or words
necessary to store the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_rtbitmap.c    |   27 +++++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h    |   12 ++++++++++++
 libxfs/xfs_trans_resv.c  |    9 +++++----
 repair/rt.c              |   10 +++++-----
 5 files changed, 51 insertions(+), 9 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 494172b213b..818406b0415 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -227,6 +227,8 @@
 #define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
+#define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
+
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index e17af3b9d28..116afec2a75 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1140,3 +1140,30 @@ xfs_rtalloc_extent_is_free(
 	*is_free = matches;
 	return 0;
 }
+
+/*
+ * Compute the number of rtbitmap blocks needed to track the given number of rt
+ * extents.
+ */
+xfs_filblks_t
+xfs_rtbitmap_blockcount(
+	struct xfs_mount	*mp,
+	xfs_rtbxlen_t		rtextents)
+{
+	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
+}
+
+/*
+ * Compute the number of rtbitmap words needed to populate every block of a
+ * bitmap that is large enough to track the given number of rt extents.
+ */
+unsigned long long
+xfs_rtbitmap_wordcount(
+	struct xfs_mount	*mp,
+	xfs_rtbxlen_t		rtextents)
+{
+	xfs_filblks_t		blocks;
+
+	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
+	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
+}
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index f616956b289..308ce814a90 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -261,6 +261,11 @@ xfs_rtfree_extent(
 /* Same as above, but in units of rt blocks. */
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
+
+xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
+		rtextents);
+unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
+		xfs_rtbxlen_t rtextents);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -268,6 +273,13 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+static inline xfs_filblks_t
+xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
+{
+	/* shut up gcc */
+	return 0;
+}
+# define xfs_rtbitmap_wordcount(mp, r)			(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index be486ed42c3..36db7d709fe 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -217,11 +217,12 @@ xfs_rtalloc_block_count(
 	struct xfs_mount	*mp,
 	unsigned int		num_ops)
 {
-	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
-	unsigned int		rtbmp_bytes;
+	unsigned int		rtbmp_blocks;
+	xfs_rtxlen_t		rtxlen;
 
-	rtbmp_bytes = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN) / NBBY;
-	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
+	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
+	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, rtxlen);
+	return (rtbmp_blocks + 1) * num_ops;
 }
 
 /*
diff --git a/repair/rt.c b/repair/rt.c
index 8f3b9082a9b..244b59f04ce 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -19,6 +19,8 @@
 void
 rtinit(xfs_mount_t *mp)
 {
+	unsigned long long	wordcnt;
+
 	if (mp->m_sb.sb_rblocks == 0)
 		return;
 
@@ -26,11 +28,9 @@ rtinit(xfs_mount_t *mp)
 	 * realtime init -- blockmap initialization is
 	 * handled by incore_init()
 	 */
-	/*
-	sumfile = calloc(mp->m_rsumsize, 1);
-	*/
-	if ((btmcompute = calloc(mp->m_sb.sb_rbmblocks *
-			mp->m_sb.sb_blocksize, 1)) == NULL)
+	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
+	btmcompute = calloc(wordcnt, sizeof(xfs_rtword_t));
+	if (!btmcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
 

