Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B016C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiLaC0M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236229AbiLaC0L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:26:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BFFE63
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD5C61CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8E1C433D2;
        Sat, 31 Dec 2022 02:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453569;
        bh=n60NgXF4/A8N/VliSZ0uns44tYKcPu4pCnPeG/D/4tU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F0ryvhwymp3A0VuLtG3ZTNBOetmjpwLs4w2PMJAfwHrzBfzGEhTIwmmpW5HX9vyNP
         MCOc27cUIITgFrmDILMOcwr+/ORNNL6+cKuRu1uITH5+tOuB0zTJOPlB/NSVvXZpMI
         73w1ehoxnRdZfMjYmkQ48c8juRQziwu3wtnbvqrSog7bXkXJQ4szb54mWhM9LfgIyA
         RS6sQrLGv/SrfRXMs2ouGTr8vKxliVXBpmhMopp2t7Mv5VUSN81wxEZhFJw9iLwV6d
         RWyDl0U2K6q+IsTDhxcgX9rWcaYW9UUekDwEG+6htUdH6KwoTx3/rfLC7C6tXtfCJU
         45e1f55iAvU8Q==
Subject: [PATCH 7/9] xfs: create helpers for rtsummary block/wordcount
 computations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:33 -0800
Message-ID: <167243877322.727982.4827915333308150040.stgit@magnolia>
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
necessary to store the rt summary file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c               |    8 ++++++--
 libxfs/init.c            |    8 ++++----
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_rtbitmap.c    |   29 +++++++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h    |    7 +++++++
 repair/rt.c              |    5 ++++-
 6 files changed, 52 insertions(+), 7 deletions(-)


diff --git a/db/check.c b/db/check.c
index a10eb74ae81..81ba4732790 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1944,10 +1944,14 @@ init(
 		inodata[c] = xcalloc(inodata_hash_size, sizeof(**inodata));
 	}
 	if (rt) {
+		unsigned long long	words;
+
 		dbmap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**dbmap));
 		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
-		sumfile = xcalloc(mp->m_rsumsize, 1);
-		sumcompute = xcalloc(mp->m_rsumsize, 1);
+		words = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
+				mp->m_sb.sb_rbmblocks);
+		sumfile = xcalloc(words, sizeof(xfs_suminfo_t));
+		sumcompute = xcalloc(words, sizeof(xfs_suminfo_t));
 	}
 	nflag = sflag = tflag = verbose = optind = 0;
 	while ((c = getopt(argc, argv, "b:i:npstv")) != EOF) {
diff --git a/libxfs/init.c b/libxfs/init.c
index 787f7c108db..a440943cbdb 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -440,6 +440,7 @@ rtmount_init(
 {
 	struct xfs_buf	*bp;	/* buffer for last block of subvolume */
 	xfs_daddr_t	d;	/* address of last block of subvolume */
+	unsigned int	rsumblocks;
 	int		error;
 
 	if (mp->m_sb.sb_rblocks == 0)
@@ -465,10 +466,9 @@ rtmount_init(
 		return -1;
 	}
 	mp->m_rsumlevels = mp->m_sb.sb_rextslog + 1;
-	mp->m_rsumsize =
-		(uint)sizeof(xfs_suminfo_t) * mp->m_rsumlevels *
-		mp->m_sb.sb_rbmblocks;
-	mp->m_rsumsize = roundup(mp->m_rsumsize, mp->m_sb.sb_blocksize);
+	rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
+			mp->m_sb.sb_rbmblocks);
+	mp->m_rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
 	mp->m_rbmip = mp->m_rsumip = NULL;
 
 	/*
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 23b4365cc6e..38162b2fb2c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -231,6 +231,8 @@
 #define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
 
+#define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
+
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 9cfefccb36c..2c84a5a0b14 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1203,3 +1203,32 @@ xfs_rtbitmap_wordcount(
 	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
 	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
 }
+
+/* Compute the number of rtsummary blocks needed to track the given rt space. */
+xfs_filblks_t
+xfs_rtsummary_blockcount(
+	struct xfs_mount	*mp,
+	unsigned int		rsumlevels,
+	xfs_extlen_t		rbmblocks)
+{
+	unsigned long long	rsumwords;
+
+	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
+}
+
+/*
+ * Compute the number of rtsummary info words needed to populate every block of
+ * a summary file that is large enough to track the given rt space.
+ */
+unsigned long long
+xfs_rtsummary_wordcount(
+	struct xfs_mount	*mp,
+	unsigned int		rsumlevels,
+	xfs_extlen_t		rbmblocks)
+{
+	xfs_filblks_t		blocks;
+
+	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
+	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
+}
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 0a3c6299af8..a66357cf002 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -270,6 +270,11 @@ xfs_rtword_t xfs_rtbitmap_getword(struct xfs_mount *mp,
 		union xfs_rtword_ondisk *wordptr);
 void xfs_rtbitmap_setword(struct xfs_mount *mp,
 		union xfs_rtword_ondisk *wordptr, xfs_rtword_t incore);
+
+xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
+		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
+		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -284,6 +289,8 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	return 0;
 }
 # define xfs_rtbitmap_wordcount(mp, r)			(0)
+# define xfs_rtsummary_blockcount(mp, l, b)		(0)
+# define xfs_rtsummary_wordcount(mp, l, b)		(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/repair/rt.c b/repair/rt.c
index c6df8819cc7..ded9e02367d 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -34,7 +34,10 @@ rtinit(xfs_mount_t *mp)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
 
-	if ((sumcompute = calloc(mp->m_rsumsize, 1)) == NULL)
+	wordcnt = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
+			mp->m_sb.sb_rbmblocks);
+	sumcompute = calloc(wordcnt, sizeof(xfs_suminfo_t));
+	if (!sumcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime summary info.\n"));
 }

