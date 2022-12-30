Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB801C4708E
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbiL3X1G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbiL3X0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:26:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41878659F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:26:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3176B81DAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FA5C433EF;
        Fri, 30 Dec 2022 23:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442808;
        bh=QvcqUzw+QJ0yItEoeuyTWqxs+JsO/JnmBy0deOMUtgo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dBu5o+eySvLdUmjwErRoDbwdtjNx4wbVRSYk/OyU73zdA/cTGPDCf4UTJuBiDkqPY
         47qsJjVXQE1TwkvhYzSK8jTaMidS8j0Bv2x9fuiX4UNHd4JBT8gx5leFFS5qoEEOIg
         /hsLp/m7gY4RpGjVcoXTIYLLvpxmcYaqIbLoi3xPq9Ibot690miBNE7skKJgf1eUGy
         l8s38VCGwo/wxcEtJInf7+/F6VnN/NKK9u1wuoS/Hq9gn40E//nRda8Pmfhq4L5nAw
         u3zN1TWpzVJWG8u0cP71aBvuVtJpXKfTtMHnUvdUtFQ/U6JAgzSe+pjxdnqwFioT25
         RZnlNRgNZHxfw==
Subject: [PATCH 4/4] xfs: implement online scrubbing of rtsummary info
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:39 -0800
Message-ID: <167243835935.692714.4350326567176746203.stgit@magnolia>
In-Reply-To: <167243835873.692714.18058284706535171995.stgit@magnolia>
References: <167243835873.692714.18058284706535171995.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Finish the realtime summary scrubber by adding the functions we need to
compute a fresh copy of the rtsummary info and comparing it to the copy
on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.h    |   10 +-
 fs/xfs/scrub/rtbitmap.c  |    4 -
 fs/xfs/scrub/rtsummary.c |  252 ++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/scrub.c     |    9 +-
 fs/xfs/scrub/scrub.h     |    4 +
 fs/xfs/scrub/trace.h     |   34 ++++++
 fs/xfs/xfs_trace.h       |    3 +
 7 files changed, 288 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index d755ff734c9e..4b2590540be4 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -88,10 +88,16 @@ int xchk_setup_xattr(struct xfs_scrub *sc);
 int xchk_setup_symlink(struct xfs_scrub *sc);
 int xchk_setup_parent(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
-int xchk_setup_rt(struct xfs_scrub *sc);
+int xchk_setup_rtbitmap(struct xfs_scrub *sc);
+int xchk_setup_rtsummary(struct xfs_scrub *sc);
 #else
 static inline int
-xchk_setup_rt(struct xfs_scrub *sc)
+xchk_setup_rtbitmap(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
+static inline int
+xchk_setup_rtsummary(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 0ac7e7c2fbf9..851039588fe3 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -19,12 +19,12 @@
 
 /* Set us up with the realtime metadata locked. */
 int
-xchk_setup_rt(
+xchk_setup_rtbitmap(
 	struct xfs_scrub	*sc)
 {
 	int			error;
 
-	error = xchk_setup_fs(sc);
+	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index e12554e7f6f9..6e71e39e197e 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -14,41 +14,249 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/xfile.h"
+
+/*
+ * Realtime Summary
+ * ================
+ *
+ * We check the realtime summary by scanning the realtime bitmap file to create
+ * a new summary file incore, and then we compare the computed version against
+ * the ondisk version.  We use the 'xfile' functionality to store this
+ * (potentially large) amount of data in pageable memory.
+ */
+
+/* Set us up to check the rtsummary file. */
+int
+xchk_setup_rtsummary(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	/*
+	 * Create an xfile to construct a new rtsummary file.  The xfile allows
+	 * us to avoid pinning kernel memory for this purpose.
+	 */
+	error = xfile_create(mp, "realtime summary file", mp->m_rsumsize,
+			&sc->xfile);
+	if (error)
+		return error;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	/* Allocate a memory buffer for the summary comparison. */
+	sc->buf = kvmalloc(mp->m_sb.sb_blocksize, XCHK_GFP_FLAGS);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	error = xchk_install_live_inode(sc, mp->m_rsumip);
+	if (error)
+		return error;
+
+	/*
+	 * Locking order requires us to take the rtbitmap first.  We must be
+	 * careful to unlock it ourselves when we are done with the rtbitmap
+	 * file since the scrub infrastructure won't do that for us.  Only
+	 * then we can lock the rtsummary inode.
+	 */
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	return 0;
+}
+
+/* Helper functions to record suminfo words in an xfile. */
+
+typedef unsigned int xchk_rtsumoff_t;
+
+static inline int
+xfsum_load(
+	struct xfs_scrub	*sc,
+	xchk_rtsumoff_t		sumoff,
+	xfs_suminfo_t		*info)
+{
+	return xfile_obj_load(sc->xfile, info, sizeof(xfs_suminfo_t),
+			sumoff << XFS_WORDLOG);
+}
+
+static inline int
+xfsum_store(
+	struct xfs_scrub	*sc,
+	xchk_rtsumoff_t		sumoff,
+	const xfs_suminfo_t	info)
+{
+	return xfile_obj_store(sc->xfile, &info, sizeof(xfs_suminfo_t),
+			sumoff << XFS_WORDLOG);
+}
+
+static inline int
+xfsum_copyout(
+	struct xfs_scrub	*sc,
+	xchk_rtsumoff_t		sumoff,
+	xfs_suminfo_t		*info,
+	unsigned int		nr_words)
+{
+	return xfile_obj_load(sc->xfile, info, nr_words << XFS_WORDLOG,
+			sumoff << XFS_WORDLOG);
+}
+
+/* Update the summary file to reflect the free extent that we've accumulated. */
+STATIC int
+xchk_rtsum_record_free(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xfs_scrub		*sc = priv;
+	xfs_fileoff_t			rbmoff;
+	xfs_rtblock_t			rtbno;
+	xfs_filblks_t			rtlen;
+	xchk_rtsumoff_t			offs;
+	unsigned int			lenlog;
+	xfs_suminfo_t			v = 0;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/* Compute the relevant location in the rtsum file. */
+	rbmoff = XFS_BITTOBLOCK(mp, rec->ar_startext);
+	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
+	offs = XFS_SUMOFFS(mp, lenlog, rbmoff);
+
+	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
+	rtlen = rec->ar_extcount * mp->m_sb.sb_rextsize;
+
+	if (!xfs_verify_rtext(mp, rtbno, rtlen)) {
+		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
+		return -EFSCORRUPTED;
+	}
+
+	/* Bump the summary count. */
+	error = xfsum_load(sc, offs, &v);
+	if (error)
+		return error;
+
+	v++;
+	trace_xchk_rtsum_record_free(mp, rec->ar_startext, rec->ar_extcount,
+			lenlog, offs, v);
+
+	return xfsum_store(sc, offs, v);
+}
+
+/* Compute the realtime summary from the realtime bitmap. */
+STATIC int
+xchk_rtsum_compute(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	rtbmp_bytes;
+
+	/* If the bitmap size doesn't match the computed size, bail. */
+	rtbmp_bytes = howmany_64(mp->m_sb.sb_rextents, NBBY);
+	if (roundup_64(rtbmp_bytes, mp->m_sb.sb_blocksize) !=
+			mp->m_rbmip->i_disk_size)
+		return -EFSCORRUPTED;
+
+	return xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtsum_record_free,
+			sc);
+}
+
+/* Compare the rtsummary file against the one we computed. */
+STATIC int
+xchk_rtsum_compare(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*bp;
+	struct xfs_bmbt_irec	map;
+	xfs_fileoff_t		off;
+	xchk_rtsumoff_t		sumoff = 0;
+	int			nmap;
+
+	for (off = 0; off < XFS_B_TO_FSB(mp, mp->m_rsumsize); off++) {
+		int		error = 0;
+
+		if (xchk_should_terminate(sc, &error))
+			return error;
+		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			return 0;
+
+		/* Make sure we have a written extent. */
+		nmap = 1;
+		error = xfs_bmapi_read(mp->m_rsumip, off, 1, &map, &nmap,
+				XFS_DATA_FORK);
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
+			return error;
+
+		if (nmap != 1 || !xfs_bmap_is_written_extent(&map)) {
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
+			return 0;
+		}
+
+		/* Read a block's worth of ondisk rtsummary file. */
+		error = xfs_rtbuf_get(mp, sc->tp, off, 1, &bp);
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
+			return error;
+
+		/* Read a block's worth of computed rtsummary file. */
+		error = xfsum_copyout(sc, sumoff, sc->buf, mp->m_blockwsize);
+		if (error) {
+			xfs_trans_brelse(sc->tp, bp);
+			return error;
+		}
+
+		if (memcmp(bp->b_addr, sc->buf,
+					mp->m_blockwsize << XFS_WORDLOG) != 0)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
+
+		xfs_trans_brelse(sc->tp, bp);
+		sumoff += mp->m_blockwsize;
+	}
+
+	return 0;
+}
 
 /* Scrub the realtime summary. */
 int
 xchk_rtsummary(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_inode	*rsumip = sc->mp->m_rsumip;
-	struct xfs_inode	*old_ip = sc->ip;
-	uint			old_ilock_flags = sc->ilock_flags;
+	struct xfs_mount	*mp = sc->mp;
 	int			error = 0;
 
-	/*
-	 * We ILOCK'd the rt bitmap ip in the setup routine, now lock the
-	 * rt summary ip in compliance with the rt inode locking rules.
-	 *
-	 * Since we switch sc->ip to rsumip we have to save the old ilock
-	 * flags so that we don't mix up the inode state that @sc tracks.
-	 */
-	sc->ip = rsumip;
-	sc->ilock_flags = 0;
-	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-
 	/* Invoke the fork scrubber. */
 	error = xchk_metadata_inode_forks(sc);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
-		goto out;
+		goto out_rbm;
 
-	/* XXX: implement this some day */
-	xchk_set_incomplete(sc);
-out:
-	/* Switch back to the rtbitmap inode and lock flags. */
-	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-	sc->ilock_flags = old_ilock_flags;
-	sc->ip = old_ip;
+	/* Construct the new summary file from the rtbitmap. */
+	error = xchk_rtsum_compute(sc);
+	if (error == -EFSCORRUPTED) {
+		/*
+		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
+		 * error since we're checking the summary file.
+		 */
+		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
+		error = 0;
+		goto out_rbm;
+	}
+	if (error)
+		goto out_rbm;
+
+	/* Does the computed summary file match the actual rtsummary file? */
+	error = xchk_rtsum_compare(sc);
+
+out_rbm:
+	/* Unlock the rtbitmap since we're done with it. */
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 189a56f93279..fe5faec4d1d2 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -24,6 +24,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/health.h"
+#include "scrub/xfile.h"
 
 /*
  * Online Scrub and Repair
@@ -186,6 +187,10 @@ xchk_teardown(
 		mnt_drop_write_file(sc->file);
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
+	if (sc->xfile) {
+		xfile_destroy(sc->xfile);
+		sc->xfile = NULL;
+	}
 	if (sc->buf) {
 		if (sc->buf_cleanup)
 			sc->buf_cleanup(sc->buf);
@@ -320,14 +325,14 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 	},
 	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
 		.type	= ST_FS,
-		.setup	= xchk_setup_rt,
+		.setup	= xchk_setup_rtbitmap,
 		.scrub	= xchk_rtbitmap,
 		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,
-		.setup	= xchk_setup_rt,
+		.setup	= xchk_setup_rtsummary,
 		.scrub	= xchk_rtsummary,
 		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 5d6e9a9527c3..83ad1662d802 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -88,6 +88,10 @@ struct xfs_scrub {
 	 */
 	void				(*buf_cleanup)(void *buf);
 
+	/* xfile used by the scrubbers; freed at teardown. */
+	struct xfile			*xfile;
+
+	/* Lock flags for @ip. */
 	uint				ilock_flags;
 
 	/* See the XCHK/XREP state flags below. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 2431083b9f91..8d9a5e8c59e2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -988,6 +988,40 @@ TRACE_EVENT(xfarray_sort_stats,
 		  __entry->error)
 );
 
+#ifdef CONFIG_XFS_RT
+TRACE_EVENT(xchk_rtsum_record_free,
+	TP_PROTO(struct xfs_mount *mp, xfs_rtblock_t start,
+		 uint64_t len, unsigned int log, loff_t pos, xfs_suminfo_t v),
+	TP_ARGS(mp, start, len, log, pos, v),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_rtblock_t, start)
+		__field(unsigned long long, len)
+		__field(unsigned int, log)
+		__field(loff_t, pos)
+		__field(xfs_suminfo_t, v)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rtdev = mp->m_rtdev_targp->bt_dev;
+		__entry->start = start;
+		__entry->len = len;
+		__entry->log = log;
+		__entry->pos = pos;
+		__entry->v = v;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d rtx 0x%llx rtxcount 0x%llx log %u rsumpos 0x%llx sumcount %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->start,
+		  __entry->len,
+		  __entry->log,
+		  __entry->pos,
+		  __entry->v)
+);
+#endif /* CONFIG_XFS_RT */
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6941deb80244..dfb1d47ee3c3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -22,6 +22,9 @@
  * daddr: physical block number in 512b blocks
  * bbcount: number of blocks in a physical extent, in 512b blocks
  *
+ * rtx: physical rt extent number for extent mappings
+ * rtxcount: number of rt extents in an extent mapping
+ *
  * owner: reverse-mapping owner, usually inodes
  *
  * fileoff: file offset, in fs blocks

