Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2751CDB482
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbjJQPyH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344471AbjJQPyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:54:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619CC130
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:53:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F9CC433C7;
        Tue, 17 Oct 2023 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697558033;
        bh=+3r0PDP0dcEYAaDi8/6qlOi5tWc9wsVITwkkOzyfiPQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Tq0CQrDfEUEr21rRKj8LXp+SYGIAgf4uqv9/tadGEO6e47HB6InlRh5Xn5kXJeLEs
         9whhqWCcOjUdZQxfr1kUfsSZW8Y8YFte+nNpG99a8U1p0YYJMSXkeuAr+9bwpjoVr/
         TMueEkmRfuvHp8mLfSHCKJCfAQjDK0fJgc+q6RrLx6/loVT8oqO/9QZfepI7GHDMu4
         yyIMUEn527g/UmQBkdIbYtL4f8R6vqruXBkZ9TaXmPwDp14XxKxFB3BGgQnKxIemCd
         usuwop49btWst+gf5hyE545LU3eUuNzHKKSPIeOxV6OH+H6U9FEtaGbqgriEFl4U7G
         ebDGRhneRx33Q==
Date:   Tue, 17 Oct 2023 08:53:52 -0700
Subject: [PATCH 8/8] xfs: use accessor functions for summary info words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755742271.3167663.1478367510107691141.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rtbitmap.c |   29 ++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_rtbitmap.h |    8 ++++++--
 fs/xfs/scrub/rtsummary.c     |   20 +++++++++++---------
 fs/xfs/scrub/trace.c         |    1 +
 fs/xfs/scrub/trace.h         |    4 ++--
 fs/xfs/xfs_ondisk.h          |    1 +
 7 files changed, 53 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2af891d5d171..9a88aba1589f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -698,6 +698,14 @@ union xfs_rtword_raw {
 	__u32		old;
 };
 
+/*
+ * Realtime summary counts are accessed by the word, which is currently
+ * stored in host-endian format.
+ */
+union xfs_suminfo_raw {
+	__u32		old;
+};
+
 /*
  * XFS Timestamps
  * ==============
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index cd10e4a7f21e..63a83e728724 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -459,6 +459,23 @@ xfs_rtfind_forw(
 	return 0;
 }
 
+inline xfs_suminfo_t
+xfs_suminfo_get(
+	struct xfs_mount	*mp,
+	union xfs_suminfo_raw	*infoptr)
+{
+	return infoptr->old;
+}
+
+inline void
+xfs_suminfo_add(
+	struct xfs_mount	*mp,
+	union xfs_suminfo_raw	*infoptr,
+	int			delta)
+{
+	infoptr->old += delta;
+}
+
 /*
  * Read and/or modify the summary information for a given extent size,
  * bitmap block combination.
@@ -483,7 +500,7 @@ xfs_rtmodify_summary_int(
 	int		error;		/* error value */
 	xfs_fileoff_t	sb;		/* summary fsblock */
 	xfs_rtsumoff_t	so;		/* index into the summary file */
-	xfs_suminfo_t	*sp;		/* pointer to returned data */
+	union xfs_suminfo_raw *sp;		/* pointer to returned data */
 	unsigned int	infoword;
 
 	/*
@@ -526,17 +543,19 @@ xfs_rtmodify_summary_int(
 	if (delta) {
 		uint first = (uint)((char *)sp - (char *)bp->b_addr);
 
-		*sp += delta;
+		xfs_suminfo_add(mp, sp, delta);
 		if (mp->m_rsum_cache) {
-			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
+			xfs_suminfo_t	val = xfs_suminfo_get(mp, sp);
+
+			if (val == 0 && log == mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno]++;
-			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
+			if (val != 0 && log < mp->m_rsum_cache[bbno])
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
index c4b013929457..6a0d8b8af36d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -209,12 +209,12 @@ xfs_rtsumoffs_to_infoword(
 }
 
 /* Return a pointer to a summary info word within a rt summary block. */
-static inline xfs_suminfo_t *
+static inline union xfs_suminfo_raw *
 xfs_rsumblock_infoptr(
 	struct xfs_buf		*bp,
 	unsigned int		index)
 {
-	xfs_suminfo_t		*info = bp->b_addr;
+	union xfs_suminfo_raw	*info = bp->b_addr;
 
 	return info + index;
 }
@@ -294,6 +294,10 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+xfs_suminfo_t xfs_suminfo_get(struct xfs_mount *mp,
+		union xfs_suminfo_raw *infoptr);
+void xfs_suminfo_add(struct xfs_mount *mp, union xfs_suminfo_raw *infoptr,
+		int delta);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index ae51fb982808..c6fdb65f20e2 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -82,9 +82,10 @@ static inline int
 xfsum_load(
 	struct xfs_scrub	*sc,
 	xfs_rtsumoff_t		sumoff,
-	xfs_suminfo_t		*info)
+	union xfs_suminfo_raw	*rawinfo)
 {
-	return xfile_obj_load(sc->xfile, info, sizeof(xfs_suminfo_t),
+	return xfile_obj_load(sc->xfile, rawinfo,
+			sizeof(union xfs_suminfo_raw),
 			sumoff << XFS_WORDLOG);
 }
 
@@ -92,9 +93,10 @@ static inline int
 xfsum_store(
 	struct xfs_scrub	*sc,
 	xfs_rtsumoff_t		sumoff,
-	const xfs_suminfo_t	info)
+	const union xfs_suminfo_raw rawinfo)
 {
-	return xfile_obj_store(sc->xfile, &info, sizeof(xfs_suminfo_t),
+	return xfile_obj_store(sc->xfile, &rawinfo,
+			sizeof(union xfs_suminfo_raw),
 			sumoff << XFS_WORDLOG);
 }
 
@@ -102,10 +104,10 @@ static inline int
 xfsum_copyout(
 	struct xfs_scrub	*sc,
 	xfs_rtsumoff_t		sumoff,
-	xfs_suminfo_t		*info,
+	union xfs_suminfo_raw	*rawinfo,
 	unsigned int		nr_words)
 {
-	return xfile_obj_load(sc->xfile, info, nr_words << XFS_WORDLOG,
+	return xfile_obj_load(sc->xfile, rawinfo, nr_words << XFS_WORDLOG,
 			sumoff << XFS_WORDLOG);
 }
 
@@ -123,7 +125,7 @@ xchk_rtsum_record_free(
 	xfs_filblks_t			rtlen;
 	xfs_rtsumoff_t			offs;
 	unsigned int			lenlog;
-	xfs_suminfo_t			v = 0;
+	union xfs_suminfo_raw		v;
 	int				error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -147,9 +149,9 @@ xchk_rtsum_record_free(
 	if (error)
 		return error;
 
-	v++;
+	xfs_suminfo_add(mp, &v, 1);
 	trace_xchk_rtsum_record_free(mp, rec->ar_startext, rec->ar_extcount,
-			lenlog, offs, v);
+			lenlog, offs, &v);
 
 	return xfsum_store(sc, offs, v);
 }
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 46249e7b17e0..29afa4851235 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -13,6 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b0cf6757444f..95befb325cc0 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1038,7 +1038,7 @@ TRACE_EVENT(xfarray_sort_stats,
 TRACE_EVENT(xchk_rtsum_record_free,
 	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t start,
 		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
-		 xfs_suminfo_t v),
+		 union xfs_suminfo_raw *v),
 	TP_ARGS(mp, start, len, log, pos, v),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1056,7 +1056,7 @@ TRACE_EVENT(xchk_rtsum_record_free,
 		__entry->len = len;
 		__entry->log = log;
 		__entry->pos = pos;
-		__entry->v = v;
+		__entry->v = xfs_suminfo_get(mp, v);
 	),
 	TP_printk("dev %d:%d rtdev %d:%d rtx 0x%llx rtxcount 0x%llx log %u rsumpos 0x%llx sumcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 14d455f768d3..21a7e350b4c5 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -74,6 +74,7 @@ xfs_check_ondisk_structs(void)
 
 	/* realtime structures */
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
+	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to

