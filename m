Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB633CDB473
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbjJKSIW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjJKSIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:08:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3F193
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:08:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E353DC433C7;
        Wed, 11 Oct 2023 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047700;
        bh=+cMqO5feD7msWM50FQQ0V26cD2WqJ8UO1Q9O4UdpiCs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=YnltxS4qXyVAuoBdrR2JcdZ+DY6szib8PXS2XB7NYRSJnPbUUGD3yJR2XTCEHr34E
         gw2U6yfjWTawncEeZ2BXLlyajweRJ3+33cpXgGSLeL2tjw9dRLiVps0EXzTUktIMNK
         0uWWoQldberVtMF/BopHGWSdRjLo4pQOWjMpEkuxRnwcTD8e8dRfPxK0CUgMrx9eYc
         7Pj8/G/fUqaMSUEC5ocD7VsrKfBQ2t08MTU0tvfmkJ2phKRjIa/bw4AuXfX2niOQVz
         fPizBIxKKjWIN13OfJzbvhlVBVacTcaB+A9rgqs0BkavDvjlRRGMoLr+Jtpv579+Rp
         OqmTZix2q8LHw==
Date:   Wed, 11 Oct 2023 11:08:19 -0700
Subject: [PATCH 8/8] xfs: use accessor functions for summary info words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721750.1773834.4264847386675407220.stgit@frogsfrogsfrogs>
In-Reply-To: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_format.h   |    8 ++++++++
 fs/xfs/libxfs/xfs_rtbitmap.c |   27 ++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_rtbitmap.h |   10 +++++++---
 fs/xfs/scrub/rtsummary.c     |   22 ++++++++++++----------
 fs/xfs/scrub/rtsummary.h     |    2 +-
 fs/xfs/scrub/trace.c         |    1 +
 fs/xfs/scrub/trace.h         |    4 ++--
 fs/xfs/xfs_ondisk.h          |    1 +
 8 files changed, 54 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8e880ec217396..a4ef175409ef3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -736,6 +736,14 @@ union xfs_rtword_ondisk {
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index be5c793da46c9..b74261abd2385 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -466,6 +466,23 @@ xfs_rtfind_forw(
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
@@ -490,7 +507,7 @@ xfs_rtmodify_summary_int(
 	int		error;		/* error value */
 	xfs_fileoff_t	sb;		/* summary fsblock */
 	xfs_rtsumoff_t	so;		/* index into the summary file */
-	xfs_suminfo_t	*sp;		/* pointer to returned data */
+	union xfs_suminfo_ondisk *sp;		/* pointer to returned data */
 	unsigned int	infoword;
 
 	/*
@@ -533,17 +550,17 @@ xfs_rtmodify_summary_int(
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
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index a66357cf002be..749c8e3ec4cbb 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 3fcf7de9f685f..e8b0f57b9bb10 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -97,9 +97,10 @@ static inline int
 xfsum_load(
 	struct xfs_scrub	*sc,
 	xfs_rtsumoff_t		sumoff,
-	xfs_suminfo_t		*info)
+	union xfs_suminfo_ondisk *rawinfo)
 {
-	return xfile_obj_load(sc->xfile, info, sizeof(xfs_suminfo_t),
+	return xfile_obj_load(sc->xfile, rawinfo,
+			sizeof(union xfs_suminfo_ondisk),
 			sumoff << XFS_WORDLOG);
 }
 
@@ -107,9 +108,10 @@ static inline int
 xfsum_store(
 	struct xfs_scrub	*sc,
 	xfs_rtsumoff_t		sumoff,
-	const xfs_suminfo_t	info)
+	const union xfs_suminfo_ondisk rawinfo)
 {
-	return xfile_obj_store(sc->xfile, &info, sizeof(xfs_suminfo_t),
+	return xfile_obj_store(sc->xfile, &rawinfo,
+			sizeof(union xfs_suminfo_ondisk),
 			sumoff << XFS_WORDLOG);
 }
 
@@ -117,10 +119,10 @@ inline int
 xfsum_copyout(
 	struct xfs_scrub	*sc,
 	xfs_rtsumoff_t		sumoff,
-	xfs_suminfo_t		*info,
+	union xfs_suminfo_ondisk *rawinfo,
 	unsigned int		nr_words)
 {
-	return xfile_obj_load(sc->xfile, info, nr_words << XFS_WORDLOG,
+	return xfile_obj_load(sc->xfile, rawinfo, nr_words << XFS_WORDLOG,
 			sumoff << XFS_WORDLOG);
 }
 
@@ -138,7 +140,7 @@ xchk_rtsum_record_free(
 	xfs_filblks_t			rtlen;
 	xfs_rtsumoff_t			offs;
 	unsigned int			lenlog;
-	xfs_suminfo_t			v = 0;
+	union xfs_suminfo_ondisk	v;
 	int				error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -162,9 +164,9 @@ xchk_rtsum_record_free(
 	if (error)
 		return error;
 
-	v++;
+	xfs_suminfo_add(mp, &v, 1);
 	trace_xchk_rtsum_record_free(mp, rec->ar_startext, rec->ar_extcount,
-			lenlog, offs, v);
+			lenlog, offs, &v);
 
 	return xfsum_store(sc, offs, v);
 }
@@ -199,7 +201,7 @@ xchk_rtsum_compare(
 	int			nmap;
 
 	for (off = 0; off < XFS_B_TO_FSB(mp, mp->m_rsumsize); off++) {
-		xfs_suminfo_t	*ondisk_info;
+		union xfs_suminfo_ondisk *ondisk_info;
 		int		error = 0;
 
 		if (xchk_should_terminate(sc, &error))
diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
index 7a69474293bf1..f456bf952bc06 100644
--- a/fs/xfs/scrub/rtsummary.h
+++ b/fs/xfs/scrub/rtsummary.h
@@ -9,6 +9,6 @@
 typedef unsigned int xfs_rtsumoff_t;
 
 int xfsum_copyout(struct xfs_scrub *sc, xfs_rtsumoff_t sumoff,
-		xfs_suminfo_t *info, unsigned int nr_words);
+		union xfs_suminfo_ondisk *info, unsigned int nr_words);
 
 #endif /* __XFS_SCRUB_RTSUMMARY_H__ */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index e4da5831c6a3c..0a7408699bc85 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -21,6 +21,7 @@
 #include "xfs_rmap.h"
 #include "xfs_parent.h"
 #include "xfs_imeta.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5fc3e07d85ebd..0326f4138c8ca 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1262,7 +1262,7 @@ TRACE_EVENT(xfarray_sort_stats,
 TRACE_EVENT(xchk_rtsum_record_free,
 	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t start,
 		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
-		 xfs_suminfo_t v),
+		 union xfs_suminfo_ondisk *v),
 	TP_ARGS(mp, start, len, log, pos, v),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1280,7 +1280,7 @@ TRACE_EVENT(xchk_rtsum_record_free,
 		__entry->len = len;
 		__entry->log = log;
 		__entry->pos = pos;
-		__entry->v = v;
+		__entry->v = xfs_suminfo_get(mp, v);
 	),
 	TP_printk("dev %d:%d rtdev %d:%d rtx 0x%llx rtxcount 0x%llx log %u rsumpos 0x%llx sumcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index efdba05f90aed..652b9b71a9052 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -74,6 +74,7 @@ xfs_check_ondisk_structs(void)
 
 	/* realtime structures */
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_ondisk,		4);
+	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_ondisk,		4);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to

