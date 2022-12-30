Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319D8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiLaC02 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiLaC01 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:26:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A22E63
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAD3661CD0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11599C433D2;
        Sat, 31 Dec 2022 02:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453585;
        bh=O5lVXYY/xBjOVPu5QRvPJC8EIrZ6+5zvrS2KAvVW4dk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K/Pq4N9vYWrploJuMgDnkGtIxvtI7BviJl1PbLY4da3aWxnmkYbkAB/IEugujEu+P
         D20NDh/usOHhssouqaCLpHUSHS3gD7XV4sd9L2Bj/PyXzDbCIQ8ZbKf5+BIe/UZUMQ
         BuGrcdCHFKfnxfJ+WcnDQXiAmsgtrPPzFb3+gDwb9ZlZuCm/uGaPVEY8rkThfKLC6m
         cOJQJmAEZR/Q1J5jV485HRI6Un9j+KOEKyyIA/CEItVDGYW6mrNvxt0PEyarz9t7rx
         aYQQtBPseeYsMQVxsTbJEZeEaIvFGr5ssMAGvuEatOkd7wsNmQ0/2wgE8Gq/I5XAbb
         ts8FFP3BSheLQ==
Subject: [PATCH 8/9] xfs: use accessor functions for summary info words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:33 -0800
Message-ID: <167243877335.727982.1522866331649598058.stgit@magnolia>
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

Create get and set functions for rtsummary words so that we can redefine
the ondisk format with a specific endianness.  Note that this requires
the definition of a distinct type for ondisk summary info words so that
the compiler can perform proper typechecking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c               |   35 +++++++++++++++++++++--------------
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_format.h      |    8 ++++++++
 libxfs/xfs_rtbitmap.c    |   27 ++++++++++++++++++++++-----
 libxfs/xfs_rtbitmap.h    |   10 +++++++---
 repair/globals.c         |    2 +-
 repair/globals.h         |    2 +-
 repair/phase6.c          |    6 +++---
 repair/rt.c              |    8 ++++----
 repair/rt.h              |    2 +-
 10 files changed, 70 insertions(+), 32 deletions(-)


diff --git a/db/check.c b/db/check.c
index 81ba4732790..2dcab8e87e6 100644
--- a/db/check.c
+++ b/db/check.c
@@ -132,8 +132,8 @@ static unsigned		sbversion;
 static int		sbver_err;
 static int		serious_error;
 static int		sflag;
-static xfs_suminfo_t	*sumcompute;
-static xfs_suminfo_t	*sumfile;
+static union xfs_suminfo_ondisk *sumcompute;
+static union xfs_suminfo_ondisk *sumfile;
 static const char	*typename[] = {
 	"unknown",
 	"agf",
@@ -1708,8 +1708,8 @@ static void
 check_summary(void)
 {
 	xfs_rfsblock_t	bno;
-	xfs_suminfo_t	*csp;
-	xfs_suminfo_t	*fsp;
+	union xfs_suminfo_ondisk *csp;
+	union xfs_suminfo_ondisk *fsp;
 	int		log;
 
 	csp = sumcompute;
@@ -1718,12 +1718,14 @@ check_summary(void)
 		for (bno = 0;
 		     bno < mp->m_sb.sb_rbmblocks;
 		     bno++, csp++, fsp++) {
-			if (*csp != *fsp) {
+			if (csp->raw != fsp->raw) {
 				if (!sflag)
 					dbprintf(_("rt summary mismatch, size %d "
 						 "block %llu, file: %d, "
 						 "computed: %d\n"),
-						log, bno, *fsp, *csp);
+						log, bno,
+						libxfs_suminfo_get(mp, fsp),
+						libxfs_suminfo_get(mp, csp));
 				error++;
 			}
 		}
@@ -1950,8 +1952,8 @@ init(
 		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
 		words = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
 				mp->m_sb.sb_rbmblocks);
-		sumfile = xcalloc(words, sizeof(xfs_suminfo_t));
-		sumcompute = xcalloc(words, sizeof(xfs_suminfo_t));
+		sumfile = xcalloc(words, sizeof(union xfs_suminfo_ondisk));
+		sumcompute = xcalloc(words, sizeof(union xfs_suminfo_ondisk));
 	}
 	nflag = sflag = tflag = verbose = optind = 0;
 	while ((c = getopt(argc, argv, "b:i:npstv")) != EOF) {
@@ -3681,7 +3683,7 @@ process_rtbitmap(
 					bitsperblock + (bit - start_bit);
 				log = XFS_RTBLOCKLOG(len);
 				offs = xfs_rtsumoffs(mp, log, start_bmbno);
-				sumcompute[offs]++;
+				libxfs_suminfo_add(mp, &sumcompute[offs], 1);
 				prevbit = 0;
 			}
 		}
@@ -3694,7 +3696,7 @@ process_rtbitmap(
 			(bit - start_bit);
 		log = XFS_RTBLOCKLOG(len);
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
-		sumcompute[offs]++;
+		libxfs_suminfo_add(mp, &sumcompute[offs], 1);
 	}
 	free(words);
 }
@@ -3704,12 +3706,14 @@ process_rtsummary(
 	blkmap_t	*blkmap)
 {
 	xfs_fsblock_t	bno;
-	char		*bytes;
+	union xfs_suminfo_ondisk *sfile = sumfile;
 	xfs_fileoff_t	sumbno;
 	int		t;
 
 	sumbno = NULLFILEOFF;
 	while ((sumbno = blkmap_next_off(blkmap, sumbno, &t)) != NULLFILEOFF) {
+		union xfs_suminfo_ondisk	*ondisk;
+
 		bno = blkmap_get(blkmap, sumbno);
 		if (bno == NULLFSBLOCK) {
 			if (!sflag)
@@ -3722,18 +3726,21 @@ process_rtsummary(
 		push_cur();
 		set_cur(&typtab[TYP_RTSUMMARY], XFS_FSB_TO_DADDR(mp, bno),
 			blkbb, DB_RING_IGN, NULL);
-		if ((bytes = iocur_top->data) == NULL) {
+		if (!iocur_top->bp) {
 			if (!sflag)
 				dbprintf(_("can't read block %lld for rtsummary "
 					 "inode\n"),
 					(xfs_fileoff_t)sumbno);
 			error++;
 			pop_cur();
+			sfile += mp->m_blockwsize;
 			continue;
 		}
-		memcpy((char *)sumfile + sumbno * mp->m_sb.sb_blocksize, bytes,
-			mp->m_sb.sb_blocksize);
+
+		ondisk = xfs_rsumblock_infoptr(iocur_top->bp, 0);
+		memcpy(sfile, ondisk, mp->m_sb.sb_blocksize);
 		pop_cur();
+		sfile += mp->m_blockwsize;
 	}
 }
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 38162b2fb2c..ca9144dd949 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -231,6 +231,8 @@
 #define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
 
+#define xfs_suminfo_add			libxfs_suminfo_add
+#define xfs_suminfo_get			libxfs_suminfo_get
 #define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 14da972f550..946870eb492 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -725,6 +725,14 @@ union xfs_rtword_ondisk {
 	__u32		raw;
 };
 
+/*
+ * Realtime summary counts are accessed by the word, which is currently
+ * stored in host-endian format.
+ */
+union xfs_suminfo_ondisk {
+	__u32		raw;
+};
+
 /*
  * XFS Timestamps
  * ==============
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 2c84a5a0b14..dca41254ee0 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -464,6 +464,23 @@ xfs_rtfind_forw(
 	return 0;
 }
 
+inline xfs_suminfo_t
+xfs_suminfo_get(
+	struct xfs_mount	*mp,
+	union xfs_suminfo_ondisk *infoptr)
+{
+	return infoptr->raw;
+}
+
+inline void
+xfs_suminfo_add(
+	struct xfs_mount	*mp,
+	union xfs_suminfo_ondisk *infoptr,
+	int			delta)
+{
+	infoptr->raw += delta;
+}
+
 /*
  * Read and/or modify the summary information for a given extent size,
  * bitmap block combination.
@@ -488,7 +505,7 @@ xfs_rtmodify_summary_int(
 	int		error;		/* error value */
 	xfs_fileoff_t	sb;		/* summary fsblock */
 	xfs_rtsumoff_t	so;		/* index into the summary file */
-	xfs_suminfo_t	*sp;		/* pointer to returned data */
+	union xfs_suminfo_ondisk *sp;		/* pointer to returned data */
 	unsigned int	infoword;
 
 	/*
@@ -531,17 +548,17 @@ xfs_rtmodify_summary_int(
 	if (delta) {
 		uint first = (uint)((char *)sp - (char *)bp->b_addr);
 
-		*sp += delta;
+		xfs_suminfo_add(mp, sp, delta);
 		if (mp->m_rsum_cache) {
-			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
+			if (sp->raw == 0 && log == mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno]++;
-			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
+			if (sp->raw != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
 		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
 	}
 	if (sum)
-		*sum = *sp;
+		*sum = xfs_suminfo_get(mp, sp);
 	return 0;
 }
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index a66357cf002..749c8e3ec4c 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -181,18 +181,18 @@ xfs_rtsumoffs_to_infoword(
 }
 
 /* Return a pointer to a summary info word within a rt summary block buffer. */
-static inline xfs_suminfo_t *
+static inline union xfs_suminfo_ondisk *
 xfs_rsumbuf_infoptr(
 	void			*buf,
 	unsigned int		infoword)
 {
-	xfs_suminfo_t		*infop = buf;
+	union xfs_suminfo_ondisk *infop = buf;
 
 	return &infop[infoword];
 }
 
 /* Return a pointer to a summary info word within a rt summary block. */
-static inline xfs_suminfo_t *
+static inline union xfs_suminfo_ondisk *
 xfs_rsumblock_infoptr(
 	struct xfs_buf		*bp,
 	unsigned int		infoword)
@@ -275,6 +275,10 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+xfs_suminfo_t xfs_suminfo_get(struct xfs_mount *mp,
+		union xfs_suminfo_ondisk *infoptr);
+void xfs_suminfo_add(struct xfs_mount *mp, union xfs_suminfo_ondisk *infoptr,
+		int delta);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
diff --git a/repair/globals.c b/repair/globals.c
index 694a4c39cbd..a7b903e8ff6 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -94,7 +94,7 @@ int64_t		fs_max_file_offset;
 /* realtime info */
 
 union xfs_rtword_ondisk	*btmcompute;
-xfs_suminfo_t	*sumcompute;
+union xfs_suminfo_ondisk	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
 
diff --git a/repair/globals.h b/repair/globals.h
index 51d94ce8224..27895dd39c5 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -135,7 +135,7 @@ extern int64_t		fs_max_file_offset;
 /* realtime info */
 
 extern union xfs_rtword_ondisk		*btmcompute;
-extern xfs_suminfo_t	*sumcompute;
+extern union xfs_suminfo_ondisk	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 27c47032fcb..3be1da033c5 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -850,7 +850,7 @@ fill_rsumino(xfs_mount_t *mp)
 	struct xfs_buf	*bp;
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	xfs_suminfo_t	*smp;
+	union xfs_suminfo_ondisk *smp;
 	int		nmap;
 	int		error;
 	xfs_fileoff_t	bno;
@@ -899,11 +899,11 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 			return(1);
 		}
 
-		memmove(bp->b_addr, smp, mp->m_sb.sb_blocksize);
+		memcpy(xfs_rsumblock_infoptr(bp, 0), smp, mp->m_sb.sb_blocksize);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
-		smp = (xfs_suminfo_t *)((intptr_t)smp + mp->m_sb.sb_blocksize);
+		smp += mp->m_blockwsize;
 		bno++;
 	}
 
diff --git a/repair/rt.c b/repair/rt.c
index ded9e02367d..9333bce8fbb 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -36,7 +36,7 @@ rtinit(xfs_mount_t *mp)
 
 	wordcnt = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
 			mp->m_sb.sb_rbmblocks);
-	sumcompute = calloc(wordcnt, sizeof(xfs_suminfo_t));
+	sumcompute = calloc(wordcnt, sizeof(union xfs_suminfo_ondisk));
 	if (!sumcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime summary info.\n"));
@@ -50,7 +50,7 @@ int
 generate_rtinfo(
 	struct xfs_mount	*mp,
 	union xfs_rtword_ondisk	*words,
-	xfs_suminfo_t		*sumcompute)
+	union xfs_suminfo_ondisk	*sumcompute)
 {
 	xfs_rtxnum_t	extno;
 	xfs_rtxnum_t	start_ext;
@@ -96,7 +96,7 @@ generate_rtinfo(
 				len = (int) (extno - start_ext);
 				log = XFS_RTBLOCKLOG(len);
 				offs = xfs_rtsumoffs(mp, log, start_bmbno);
-				sumcompute[offs]++;
+				libxfs_suminfo_add(mp, &sumcompute[offs], 1);
 				in_extent = 0;
 			}
 
@@ -112,7 +112,7 @@ generate_rtinfo(
 		len = (int) (extno - start_ext);
 		log = XFS_RTBLOCKLOG(len);
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
-		sumcompute[offs]++;
+		libxfs_suminfo_add(mp, &sumcompute[offs], 1);
 	}
 
 	if (mp->m_sb.sb_frextents != sb_frextents) {
diff --git a/repair/rt.h b/repair/rt.h
index 4f944487d63..16b39c21a67 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -12,7 +12,7 @@ void
 rtinit(xfs_mount_t		*mp);
 
 int generate_rtinfo(struct xfs_mount *mp, union xfs_rtword_ondisk *words,
-		xfs_suminfo_t *sumcompute);
+		union xfs_suminfo_ondisk *sumcompute);
 
 void check_rtbitmap(struct xfs_mount *mp);
 void check_rtsummary(struct xfs_mount *mp);

