Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7691ACDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjJSQ2i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjJSQ2h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:28:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10DD115
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:28:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88762C433C8;
        Thu, 19 Oct 2023 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732915;
        bh=HSw8CEdUzmIBVL7hbEO/vCFJSodnPzrarv6eRy8JJiA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=esZhqEhL/BbqBUCOHjQZXrDSOk8kWRjSZdSZiFUYfYX3dbRBW/q2Xhk/vzoXpRaDa
         TpAXimlgRd8IRmt9japsxWOkdW/nIqz1Fl91oIBq99TlAtREP5OxOfuF1EbpLvgkMA
         N5YfIBMhfbXjxhXGlGznd3m9QYMifBFQNV+4GHmv8ojKhctvhkL5UjLa9jqEgnHnRm
         UH0SIquu4jgHZ00Oo7O+UyKYmEomIxZlSzUUuQ/xO/E1+YMlhbFjvxKB5uJx0+oMv6
         xSJYrtBCnlrofxMdQ9D0/UphQO38pX+bQ6oSHIe/zBA/6UEx/Up762aBNCnHQ7BZHD
         3fdewYXFYl8CA==
Date:   Thu, 19 Oct 2023 09:28:35 -0700
Subject: [PATCH 4/4] xfs: use accessor functions for summary info words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773211405.225711.3848287991503109482.stgit@frogsfrogsfrogs>
In-Reply-To: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs>
References: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    8 ++++++++
 fs/xfs/libxfs/xfs_rtbitmap.c |   15 ++++++++-------
 fs/xfs/libxfs/xfs_rtbitmap.h |   28 ++++++++++++++++++++++++++--
 fs/xfs/scrub/rtsummary.c     |   32 ++++++++++++++++++++++----------
 fs/xfs/scrub/trace.c         |    1 +
 fs/xfs/scrub/trace.h         |   10 +++++-----
 fs/xfs/xfs_ondisk.h          |    1 +
 7 files changed, 71 insertions(+), 24 deletions(-)


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
index fb05ea0177ec..4221f539615f 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -451,7 +451,6 @@ xfs_rtmodify_summary_int(
 	int		error;		/* error value */
 	xfs_fileoff_t	sb;		/* summary fsblock */
 	xfs_rtsumoff_t	so;		/* index into the summary file */
-	xfs_suminfo_t	*sp;		/* pointer to returned data */
 	unsigned int	infoword;
 
 	/*
@@ -490,19 +489,21 @@ xfs_rtmodify_summary_int(
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
-	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
-		*sp += delta;
+		xfs_suminfo_t	val = xfs_suminfo_add(bp, infoword, delta);
+
 		if (mp->m_rsum_cache) {
-			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
+			if (val == 0 && log == mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno]++;
-			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
+			if (val != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
 		xfs_trans_log_rtsummary(tp, bp, infoword);
+		if (sum)
+			*sum = val;
+	} else if (sum) {
+		*sum = xfs_suminfo_get(bp, infoword);
 	}
-	if (sum)
-		*sum = *sp;
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index a3e8288bedea..fdfa98e0ee52 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -232,16 +232,40 @@ xfs_rtsumoffs_to_infoword(
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
 
+/* Get the current value of a summary counter. */
+static inline xfs_suminfo_t
+xfs_suminfo_get(
+	struct xfs_buf		*bp,
+	unsigned int		index)
+{
+	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
+
+	return info->old;
+}
+
+/* Add to the current value of a summary counter and return the new value. */
+static inline xfs_suminfo_t
+xfs_suminfo_add(
+	struct xfs_buf		*bp,
+	unsigned int		index,
+	int			delta)
+{
+	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
+
+	info->old += delta;
+	return info->old;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 0971d002d906..e9eac5354f19 100644
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
 
@@ -102,13 +104,22 @@ static inline int
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
 
+static inline xfs_suminfo_t
+xchk_rtsum_inc(
+	struct xfs_mount	*mp,
+	union xfs_suminfo_raw	*v)
+{
+	v->old += 1;
+	return v->old;
+}
+
 /* Update the summary file to reflect the free extent that we've accumulated. */
 STATIC int
 xchk_rtsum_record_free(
@@ -123,7 +134,8 @@ xchk_rtsum_record_free(
 	xfs_filblks_t			rtlen;
 	xfs_rtsumoff_t			offs;
 	unsigned int			lenlog;
-	xfs_suminfo_t			v = 0;
+	union xfs_suminfo_raw		v;
+	xfs_suminfo_t			value;
 	int				error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -147,9 +159,9 @@ xchk_rtsum_record_free(
 	if (error)
 		return error;
 
-	v++;
+	value = xchk_rtsum_inc(sc->mp, &v);
 	trace_xchk_rtsum_record_free(mp, rec->ar_startext, rec->ar_extcount,
-			lenlog, offs, v);
+			lenlog, offs, value);
 
 	return xfsum_store(sc, offs, v);
 }
@@ -184,7 +196,7 @@ xchk_rtsum_compare(
 	int			nmap;
 
 	for (off = 0; off < XFS_B_TO_FSB(mp, mp->m_rsumsize); off++) {
-		xfs_suminfo_t	*ondisk_info;
+		union xfs_suminfo_raw *ondisk_info;
 		int		error = 0;
 
 		if (xchk_should_terminate(sc, &error))
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
index b0cf6757444f..4a8bc6f3c8f2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1038,8 +1038,8 @@ TRACE_EVENT(xfarray_sort_stats,
 TRACE_EVENT(xchk_rtsum_record_free,
 	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t start,
 		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
-		 xfs_suminfo_t v),
-	TP_ARGS(mp, start, len, log, pos, v),
+		 xfs_suminfo_t value),
+	TP_ARGS(mp, start, len, log, pos, value),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(dev_t, rtdev)
@@ -1047,7 +1047,7 @@ TRACE_EVENT(xchk_rtsum_record_free,
 		__field(unsigned long long, len)
 		__field(unsigned int, log)
 		__field(loff_t, pos)
-		__field(xfs_suminfo_t, v)
+		__field(xfs_suminfo_t, value)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
@@ -1056,7 +1056,7 @@ TRACE_EVENT(xchk_rtsum_record_free,
 		__entry->len = len;
 		__entry->log = log;
 		__entry->pos = pos;
-		__entry->v = v;
+		__entry->value = value;
 	),
 	TP_printk("dev %d:%d rtdev %d:%d rtx 0x%llx rtxcount 0x%llx log %u rsumpos 0x%llx sumcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1065,7 +1065,7 @@ TRACE_EVENT(xchk_rtsum_record_free,
 		  __entry->len,
 		  __entry->log,
 		  __entry->pos,
-		  __entry->v)
+		  __entry->value)
 );
 #endif /* CONFIG_XFS_RT */
 
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

