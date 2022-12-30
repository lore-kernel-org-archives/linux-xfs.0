Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA23C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiLaB0q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiLaB0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:26:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058536581
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:26:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5FD4B81DE3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FF5C433EF;
        Sat, 31 Dec 2022 01:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450001;
        bh=cpGiRY+RAtr+nUcVK25njg8DtcsLTZ/5zCvfLLRfpS0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d4uVSw53alklhWMm70OI68SYXzP1AgRmA/v1hVbT/jSvgPvOZG9EJIovjxFo2/RUn
         gyN6G6203NunzzjrM7YD3WURMaeYU6eVg+/AnEtoJFhB09INBRMKuCkOLMMfxMFTFY
         FfhdWtcxs8JQUoN7iMbTNGgHNznNm9xlFvNx6p8bcpCETPw5cxViTlf/5OWEEDVbUq
         uECPSX3Uo+OPGoe20MHqw8LYEtoqEu5KKRce8LtmvpVFq/TkNbBTl0mLgEcxgr9yJC
         hQ/AkBFzlXsoVNFXjxVBbE3rpi7BbYHyD6U/Kdm4Dy+Q6viy+SMXsgDBe0dVF9Cx4l
         EYULf/9KAnSGQ==
Subject: [PATCH 8/8] xfs: use accessor functions for summary info words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:45 -0800
Message-ID: <167243866591.712132.12893233664728372558.stgit@magnolia>
In-Reply-To: <167243866468.712132.9606813674941614562.stgit@magnolia>
References: <167243866468.712132.9606813674941614562.stgit@magnolia>
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
index 14da972f5508..946870eb492c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index be5c793da46c..b74261abd238 100644
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
index a66357cf002b..749c8e3ec4cb 100644
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
index e51c3d10e501..ca9153e646c9 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -89,9 +89,10 @@ static inline int
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
 
@@ -99,9 +100,10 @@ static inline int
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
 
@@ -109,10 +111,10 @@ inline int
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
 
@@ -130,7 +132,7 @@ xchk_rtsum_record_free(
 	xfs_filblks_t			rtlen;
 	xfs_rtsumoff_t			offs;
 	unsigned int			lenlog;
-	xfs_suminfo_t			v = 0;
+	union xfs_suminfo_ondisk	v;
 	int				error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -154,9 +156,9 @@ xchk_rtsum_record_free(
 	if (error)
 		return error;
 
-	v++;
+	xfs_suminfo_add(mp, &v, 1);
 	trace_xchk_rtsum_record_free(mp, rec->ar_startext, rec->ar_extcount,
-			lenlog, offs, v);
+			lenlog, offs, &v);
 
 	return xfsum_store(sc, offs, v);
 }
@@ -191,7 +193,7 @@ xchk_rtsum_compare(
 	int			nmap;
 
 	for (off = 0; off < XFS_B_TO_FSB(mp, mp->m_rsumsize); off++) {
-		xfs_suminfo_t	*ondisk_info;
+		union xfs_suminfo_ondisk *ondisk_info;
 		int		error = 0;
 
 		if (xchk_should_terminate(sc, &error))
diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
index f5fd55992957..aca13556b3a2 100644
--- a/fs/xfs/scrub/rtsummary.h
+++ b/fs/xfs/scrub/rtsummary.h
@@ -9,6 +9,6 @@
 typedef unsigned int xfs_rtsumoff_t;
 
 int xfsum_copyout(struct xfs_scrub *sc, xfs_rtsumoff_t sumoff,
-		xfs_suminfo_t *info, unsigned int nr_words);
+		union xfs_suminfo_ondisk *info, unsigned int nr_words);
 
 #endif /* __XFS_SCRUB_RTSUMMARY_H__ */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 2e36fcc12e40..bb13f0a8e4cf 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -19,6 +19,7 @@
 #include "xfs_da_format.h"
 #include "xfs_btree_mem.h"
 #include "xfs_rmap.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 650a4c88ebc4..749cf4333c8a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1083,7 +1083,7 @@ TRACE_EVENT(xfarray_sort_stats,
 TRACE_EVENT(xchk_rtsum_record_free,
 	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t start,
 		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
-		 xfs_suminfo_t v),
+		 union xfs_suminfo_ondisk *v),
 	TP_ARGS(mp, start, len, log, pos, v),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1101,7 +1101,7 @@ TRACE_EVENT(xchk_rtsum_record_free,
 		__entry->len = len;
 		__entry->log = log;
 		__entry->pos = pos;
-		__entry->v = v;
+		__entry->v = xfs_suminfo_get(mp, v);
 	),
 	TP_printk("dev %d:%d rtdev %d:%d rtx 0x%llx rtxcount 0x%llx log %u rsumpos 0x%llx sumcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 7f20642b073e..f4d700ce185c 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -74,6 +74,7 @@ xfs_check_ondisk_structs(void)
 
 	/* realtime structures */
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_ondisk,		4);
+	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_ondisk,		4);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to

