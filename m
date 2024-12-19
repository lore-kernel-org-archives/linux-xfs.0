Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FED71990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636673; cv=none; b=OrCmkQF9PbhaIVtWl5CpnWaZK4ol+InbKwIOryzsqH3BaDFDQrGzsUP9mfd2tzGs6u3IkX1LSeZ09OegoblfuBgVMUjeOBl9bTVp7Qkr8fW9gWgNkM23vSFGEH3HOXLnjXWCWrVl2N+ANFvEkkD3gBigiyXWDWfU5w5JkkU1rHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636673; c=relaxed/simple;
	bh=i9v6r6h1Z3rSUWMqp2zIyXDwPmOp83BaFynhKJJWcvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zo9EfO9S95JHzuktpDWytLPPW0aS3C1EK+x8dSVOBDD4LMpfc1QOzE9l9XIa/Vpns9yWeireKOWVQVJpoWql+xqDiYZNaD3JDmk98L/h0FlAZUH4cGcqlt3uhkVsL0mENwyYQLB6ig01V/KzaSPHKTSBWbrxTr6LjfyqwdkC0dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sz+VFTuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sz+VFTuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F4FC4CECE;
	Thu, 19 Dec 2024 19:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636673;
	bh=i9v6r6h1Z3rSUWMqp2zIyXDwPmOp83BaFynhKJJWcvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sz+VFTuYbD/8qSxYQdBJgaqPcbsuXZFJ6dSHPKtFiYMS092bLUQ3Rx6BZIIaYNXY3
	 zRmHF3jK70Whc/6WOEQGKLCR3d0OpLaElVHGWqC/SH6I9yp6IeIB66c1N5OJYQmxHT
	 CWfGmeRU6C4RjmCEK+jz1gQPTV1A0H3olVEv5Mkld/EJ7AE5tdX+NsERf05Lm4KSxJ
	 qfnAK+rweIX2gSZA5iu1ulQgKDSnbH1upyiYI3IPpw0YWhiCwz5TiSPXXuapdtqYUj
	 MbmArTMJ9ZU4wFIg9zyJ6YarrwBI7m10D9S8si6uG6Ol0kO6EtuzUYc6COQQqk12um
	 E/H/uE8sKmwKg==
Date: Thu, 19 Dec 2024 11:31:12 -0800
Subject: [PATCH 30/37] xfs: online repair of realtime bitmaps for a realtime
 group
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580271.1571512.9769636989023732054.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For a given rt group, regenerate the bitmap contents from the group's
realtime rmap btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h    |    9 +
 fs/xfs/scrub/common.h           |    6 +
 fs/xfs/scrub/repair.c           |    2 
 fs/xfs/scrub/repair.h           |    1 
 fs/xfs/scrub/rtbitmap.c         |    5 
 fs/xfs/scrub/rtbitmap.h         |   50 +++++
 fs/xfs/scrub/rtbitmap_repair.c  |  429 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/rtsummary_repair.c |    3 
 fs/xfs/scrub/tempexch.h         |    2 
 fs/xfs/scrub/tempfile.c         |   20 +-
 fs/xfs/scrub/trace.c            |    1 
 fs/xfs/scrub/trace.h            |  150 ++++++++++++++
 12 files changed, 659 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 16563a44bd138a..22e5d9cd95f47c 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -135,6 +135,15 @@ xfs_rtb_to_rtx(
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Return the offset of a rtgroup block number within an rt extent. */
+static inline xfs_extlen_t
+xfs_rgbno_to_rtxoff(
+	struct xfs_mount	*mp,
+	xfs_rgblock_t		rgbno)
+{
+	return rgbno % mp->m_sb.sb_rextsize;
+}
+
 /* Return the offset of an rt block number within an rt extent. */
 static inline xfs_extlen_t
 xfs_rtb_to_rtxoff(
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 1576467f724431..e5891609af2740 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -264,6 +264,12 @@ int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 			(sc)->mp->m_super->s_id, \
 			(sc)->ip ? (sc)->ip->i_ino : (sc)->sm->sm_ino, \
 			##__VA_ARGS__)
+#define xchk_xfile_rtgroup_descr(sc, fmt, ...) \
+	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): rtgroup 0x%x " fmt, \
+			(sc)->mp->m_super->s_id, \
+			(sc)->sa.pag ? \
+				rtg_rgno((sc)->sr.rtg) : (sc)->sm->sm_agno, \
+			##__VA_ARGS__)
 
 /*
  * Setting up a hook to wait for intents to drain is costly -- we have to take
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 18946dd46fa745..82fe01d78cb08d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -959,7 +959,7 @@ xrep_ag_init(
 
 #ifdef CONFIG_XFS_RT
 /* Initialize all the btree cursors for a RT repair. */
-static void
+void
 xrep_rtgroup_btcur_init(
 	struct xfs_scrub	*sc,
 	struct xchk_rt		*sr)
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 584135042d9aa9..7f493752ea78e6 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -110,6 +110,7 @@ int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
 #ifdef CONFIG_XFS_RT
 int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
+void xrep_rtgroup_btcur_init(struct xfs_scrub *sc, struct xchk_rt *sr);
 int xrep_require_rtext_inuse(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
 		xfs_filblks_t len);
 #else
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 675f4fdd1e675f..28c90a31f4c32b 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -20,9 +20,11 @@
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_exchmaps.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
+#include "scrub/tempexch.h"
 #include "scrub/rtbitmap.h"
 #include "scrub/btree.h"
 
@@ -38,7 +40,8 @@ xchk_setup_rtbitmap(
 	if (xchk_need_intent_drain(sc))
 		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
 
-	rtb = kzalloc(sizeof(struct xchk_rtbitmap), XCHK_GFP_FLAGS);
+	rtb = kzalloc(struct_size(rtb, words, xchk_rtbitmap_wordcnt(sc)),
+			XCHK_GFP_FLAGS);
 	if (!rtb)
 		return -ENOMEM;
 	sc->buf = rtb;
diff --git a/fs/xfs/scrub/rtbitmap.h b/fs/xfs/scrub/rtbitmap.h
index dd5b394d9697d2..fe52b877253d35 100644
--- a/fs/xfs/scrub/rtbitmap.h
+++ b/fs/xfs/scrub/rtbitmap.h
@@ -6,6 +6,20 @@
 #ifndef __XFS_SCRUB_RTBITMAP_H__
 #define __XFS_SCRUB_RTBITMAP_H__
 
+/*
+ * We use an xfile to construct new bitmap blocks for the portion of the
+ * rtbitmap file that we're replacing.  Whereas the ondisk bitmap must be
+ * accessed through the buffer cache, the xfile bitmap supports direct
+ * word-level accesses.  Therefore, we create a small abstraction for linear
+ * access.
+ */
+typedef unsigned long long xrep_wordoff_t;
+typedef unsigned int xrep_wordcnt_t;
+
+/* Mask to round an rtx down to the nearest bitmap word. */
+#define XREP_RTBMP_WORDMASK	((1ULL << XFS_NBWORDLOG) - 1)
+
+
 struct xchk_rtbitmap {
 	struct xfs_scrub	*sc;
 
@@ -16,12 +30,48 @@ struct xchk_rtbitmap {
 
 	/* The next free rt group block number that we expect to see. */
 	xfs_rgblock_t		next_free_rgbno;
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	/* stuff for staging a new bitmap */
+	struct xfs_rtalloc_args	args;
+	struct xrep_tempexch	tempexch;
+#endif
+
+	/* The next rtgroup block we expect to see during our rtrmapbt walk. */
+	xfs_rgblock_t		next_rgbno;
+
+	/* rtgroup lock flags */
+	unsigned int		rtglock_flags;
+
+	/* rtword position of xfile as we write buffers to disk. */
+	xrep_wordoff_t		prep_wordoff;
+
+	/* In-Memory rtbitmap for repair. */
+	union xfs_rtword_raw	words[];
 };
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 int xrep_setup_rtbitmap(struct xfs_scrub *sc, struct xchk_rtbitmap *rtb);
+
+/*
+ * How big should the words[] buffer be?
+ *
+ * For repairs, we want a full fsblock worth of space so that we can memcpy a
+ * buffer full of 1s into the xfile bitmap.  The xfile bitmap doesn't have
+ * rtbitmap block headers, so we don't use blockwsize.  Scrub doesn't use the
+ * words buffer at all.
+ */
+static inline unsigned int
+xchk_rtbitmap_wordcnt(
+	struct xfs_scrub	*sc)
+{
+	if (xchk_could_repair(sc))
+		return sc->mp->m_sb.sb_blocksize >> XFS_WORDLOG;
+	return 0;
+}
 #else
 # define xrep_setup_rtbitmap(sc, rtb)	(0)
+# define xchk_rtbitmap_wordcnt(sc)	(0)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
 #endif /* __XFS_SCRUB_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 0fef98e9f83409..c6e33834c5ae98 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -12,32 +12,65 @@
 #include "xfs_btree.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
+#include "xfs_rtalloc.h"
 #include "xfs_inode.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_exchmaps.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
+#include "xfs_extent_busy.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/xfile.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempexch.h"
+#include "scrub/reap.h"
 #include "scrub/rtbitmap.h"
 
-/* Set up to repair the realtime bitmap file metadata. */
+/* rt bitmap content repairs */
+
+/* Set up to repair the realtime bitmap for this group. */
 int
 xrep_setup_rtbitmap(
 	struct xfs_scrub	*sc,
 	struct xchk_rtbitmap	*rtb)
 {
 	struct xfs_mount	*mp = sc->mp;
-	unsigned long long	blocks = 0;
+	char			*descr;
+	unsigned long long	blocks = mp->m_sb.sb_rbmblocks;
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFREG);
+	if (error)
+		return error;
+
+	/* Create an xfile to hold our reconstructed bitmap. */
+	descr = xchk_xfile_rtgroup_descr(sc, "bitmap file");
+	error = xfile_create(descr, blocks * mp->m_sb.sb_blocksize, &sc->xfile);
+	kfree(descr);
+	if (error)
+		return error;
 
 	/*
-	 * Reserve enough blocks to write out a completely new bmbt for a
-	 * maximally fragmented bitmap file.  We do not hold the rtbitmap
-	 * ILOCK yet, so this is entirely speculative.
+	 * Reserve enough blocks to write out a completely new bitmap file,
+	 * plus twice as many blocks as we would need if we can only allocate
+	 * one block per data fork mapping.  This should cover the
+	 * preallocation of the temporary file and exchanging the extent
+	 * mappings.
+	 *
+	 * We cannot use xfs_exchmaps_estimate because we have not yet
+	 * constructed the replacement bitmap and therefore do not know how
+	 * many extents it will use.  By the time we do, we will have a dirty
+	 * transaction (which we cannot drop because we cannot drop the
+	 * rtbitmap ILOCK) and cannot ask for more reservation.
 	 */
-	blocks = xfs_bmbt_calc_size(mp, mp->m_sb.sb_rbmblocks);
+	blocks += xfs_bmbt_calc_size(mp, blocks) * 2;
 	if (blocks > UINT_MAX)
 		return -EOPNOTSUPP;
 
@@ -45,6 +78,304 @@ xrep_setup_rtbitmap(
 	return 0;
 }
 
+static inline xrep_wordoff_t
+rtx_to_wordoff(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return rtx >> XFS_NBWORDLOG;
+}
+
+static inline xrep_wordcnt_t
+rtxlen_to_wordcnt(
+	xfs_rtxlen_t	rtxlen)
+{
+	return rtxlen >> XFS_NBWORDLOG;
+}
+
+/* Helper functions to record rtwords in an xfile. */
+
+static inline int
+xfbmp_load(
+	struct xchk_rtbitmap	*rtb,
+	xrep_wordoff_t		wordoff,
+	xfs_rtword_t		*word)
+{
+	union xfs_rtword_raw	urk;
+	int			error;
+
+	ASSERT(xfs_has_rtgroups(rtb->sc->mp));
+
+	error = xfile_load(rtb->sc->xfile, &urk,
+			sizeof(union xfs_rtword_raw),
+			wordoff << XFS_WORDLOG);
+	if (error)
+		return error;
+
+	*word = be32_to_cpu(urk.rtg);
+	return 0;
+}
+
+static inline int
+xfbmp_store(
+	struct xchk_rtbitmap	*rtb,
+	xrep_wordoff_t		wordoff,
+	const xfs_rtword_t	word)
+{
+	union xfs_rtword_raw	urk;
+
+	ASSERT(xfs_has_rtgroups(rtb->sc->mp));
+
+	urk.rtg = cpu_to_be32(word);
+	return xfile_store(rtb->sc->xfile, &urk,
+			sizeof(union xfs_rtword_raw),
+			wordoff << XFS_WORDLOG);
+}
+
+static inline int
+xfbmp_copyin(
+	struct xchk_rtbitmap	*rtb,
+	xrep_wordoff_t		wordoff,
+	const union xfs_rtword_raw	*word,
+	xrep_wordcnt_t		nr_words)
+{
+	return xfile_store(rtb->sc->xfile, word, nr_words << XFS_WORDLOG,
+			wordoff << XFS_WORDLOG);
+}
+
+static inline int
+xfbmp_copyout(
+	struct xchk_rtbitmap	*rtb,
+	xrep_wordoff_t		wordoff,
+	union xfs_rtword_raw	*word,
+	xrep_wordcnt_t		nr_words)
+{
+	return xfile_load(rtb->sc->xfile, word, nr_words << XFS_WORDLOG,
+			wordoff << XFS_WORDLOG);
+}
+
+/* Perform a logical OR operation on an rtword in the incore bitmap. */
+static int
+xrep_rtbitmap_or(
+	struct xchk_rtbitmap	*rtb,
+	xrep_wordoff_t		wordoff,
+	xfs_rtword_t		mask)
+{
+	xfs_rtword_t		word;
+	int			error;
+
+	error = xfbmp_load(rtb, wordoff, &word);
+	if (error)
+		return error;
+
+	trace_xrep_rtbitmap_or(rtb->sc->mp, wordoff, mask, word);
+
+	return xfbmp_store(rtb, wordoff, word | mask);
+}
+
+/*
+ * Mark as free every rt extent between the next rt block we expected to see
+ * in the rtrmap records and the given rt block.
+ */
+STATIC int
+xrep_rtbitmap_mark_free(
+	struct xchk_rtbitmap	*rtb,
+	xfs_rgblock_t		rgbno)
+{
+	struct xfs_mount	*mp = rtb->sc->mp;
+	struct xfs_rtgroup	*rtg = rtb->sc->sr.rtg;
+	xfs_rtxnum_t		startrtx;
+	xfs_rtxnum_t		nextrtx;
+	xrep_wordoff_t		wordoff, nextwordoff;
+	unsigned int		bit;
+	unsigned int		bufwsize;
+	xfs_extlen_t		mod;
+	xfs_rtword_t		mask;
+	int			error;
+
+	if (!xfs_verify_rgbext(rtg, rtb->next_rgbno, rgbno - rtb->next_rgbno))
+		return -EFSCORRUPTED;
+
+	/*
+	 * Convert rt blocks to rt extents  The block range we find must be
+	 * aligned to an rtextent boundary on both ends.
+	 */
+	startrtx = xfs_rgbno_to_rtx(mp, rtb->next_rgbno);
+	mod = xfs_rgbno_to_rtxoff(mp, rtb->next_rgbno);
+	if (mod)
+		return -EFSCORRUPTED;
+
+	nextrtx = xfs_rgbno_to_rtx(mp, rgbno - 1) + 1;
+	mod = xfs_rgbno_to_rtxoff(mp, rgbno - 1);
+	if (mod != mp->m_sb.sb_rextsize - 1)
+		return -EFSCORRUPTED;
+
+	trace_xrep_rtbitmap_record_free(mp, startrtx, nextrtx - 1);
+
+	/* Set bits as needed to round startrtx up to the nearest word. */
+	bit = startrtx & XREP_RTBMP_WORDMASK;
+	if (bit) {
+		xfs_rtblock_t	len = nextrtx - startrtx;
+		unsigned int	lastbit;
+
+		lastbit = min(bit + len, XFS_NBWORD);
+		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
+
+		error = xrep_rtbitmap_or(rtb, rtx_to_wordoff(mp, startrtx),
+				mask);
+		if (error || lastbit - bit == len)
+			return error;
+		startrtx += XFS_NBWORD - bit;
+	}
+
+	/* Set bits as needed to round nextrtx down to the nearest word. */
+	bit = nextrtx & XREP_RTBMP_WORDMASK;
+	if (bit) {
+		mask = ((xfs_rtword_t)1 << bit) - 1;
+
+		error = xrep_rtbitmap_or(rtb, rtx_to_wordoff(mp, nextrtx),
+				mask);
+		if (error || startrtx + bit == nextrtx)
+			return error;
+		nextrtx -= bit;
+	}
+
+	trace_xrep_rtbitmap_record_free_bulk(mp, startrtx, nextrtx - 1);
+
+	/* Set all the words in between, up to a whole fs block at once. */
+	wordoff = rtx_to_wordoff(mp, startrtx);
+	nextwordoff = rtx_to_wordoff(mp, nextrtx);
+	bufwsize = mp->m_sb.sb_blocksize >> XFS_WORDLOG;
+
+	while (wordoff < nextwordoff) {
+		xrep_wordoff_t	rem;
+		xrep_wordcnt_t	wordcnt;
+
+		wordcnt = min_t(xrep_wordcnt_t, nextwordoff - wordoff,
+				bufwsize);
+
+		/*
+		 * Try to keep us aligned to the rtwords buffer to reduce the
+		 * number of xfile writes.
+		 */
+		rem = wordoff & (bufwsize - 1);
+		if (rem)
+			wordcnt = min_t(xrep_wordcnt_t, wordcnt,
+					bufwsize - rem);
+
+		error = xfbmp_copyin(rtb, wordoff, rtb->words, wordcnt);
+		if (error)
+			return error;
+
+		wordoff += wordcnt;
+	}
+
+	return 0;
+}
+
+/* Set free space in the rtbitmap based on rtrmapbt records. */
+STATIC int
+xrep_rtbitmap_walk_rtrmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xchk_rtbitmap		*rtb = priv;
+	int				error = 0;
+
+	if (xchk_should_terminate(rtb->sc, &error))
+		return error;
+
+	if (rtb->next_rgbno < rec->rm_startblock) {
+		error = xrep_rtbitmap_mark_free(rtb, rec->rm_startblock);
+		if (error)
+			return error;
+	}
+
+	rtb->next_rgbno = max(rtb->next_rgbno,
+			      rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
+/*
+ * Walk the rtrmapbt to find all the gaps between records, and mark the gaps
+ * in the realtime bitmap that we're computing.
+ */
+STATIC int
+xrep_rtbitmap_find_freespace(
+	struct xchk_rtbitmap	*rtb)
+{
+	struct xfs_scrub	*sc = rtb->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	uint64_t		blockcount;
+	int			error;
+
+	/* Prepare a buffer of ones so that we can accelerate bulk setting. */
+	memset(rtb->words, 0xFF, mp->m_sb.sb_blocksize);
+
+	xrep_rtgroup_btcur_init(sc, &sc->sr);
+	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_rtbitmap_walk_rtrmap,
+			rtb);
+	if (error)
+		goto out;
+
+	/*
+	 * Mark as free every possible rt extent from the last one we saw to
+	 * the end of the rt group.
+	 */
+	blockcount = rtg->rtg_extents * mp->m_sb.sb_rextsize;
+	if (rtb->next_rgbno < blockcount) {
+		error = xrep_rtbitmap_mark_free(rtb, blockcount);
+		if (error)
+			goto out;
+	}
+
+out:
+	xchk_rtgroup_btcur_free(&sc->sr);
+	return error;
+}
+
+static int
+xrep_rtbitmap_prep_buf(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp,
+	void			*data)
+{
+	struct xchk_rtbitmap	*rtb = data;
+	struct xfs_mount	*mp = sc->mp;
+	union xfs_rtword_raw	*ondisk;
+	int			error;
+
+	rtb->args.mp = sc->mp;
+	rtb->args.tp = sc->tp;
+	rtb->args.rbmbp = bp;
+	ondisk = xfs_rbmblock_wordptr(&rtb->args, 0);
+	rtb->args.rbmbp = NULL;
+
+	error = xfbmp_copyout(rtb, rtb->prep_wordoff, ondisk,
+			mp->m_blockwsize);
+	if (error)
+		return error;
+
+	if (xfs_has_rtgroups(sc->mp)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+		hdr->rt_owner = cpu_to_be64(sc->ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
+		hdr->rt_lsn = 0;
+		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
+		bp->b_ops = &xfs_rtbitmap_buf_ops;
+	} else {
+		bp->b_ops = &xfs_rtbuf_ops;
+	}
+
+	rtb->prep_wordoff += mp->m_blockwsize;
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTBITMAP_BUF);
+	return 0;
+}
+
 /*
  * Make sure that the given range of the data fork of the realtime file is
  * mapped to written blocks.  The caller must ensure that the inode is joined
@@ -160,9 +491,18 @@ xrep_rtbitmap(
 {
 	struct xchk_rtbitmap	*rtb = sc->buf;
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_group	*xg = rtg_group(sc->sr.rtg);
 	unsigned long long	blocks = 0;
+	unsigned int		busy_gen;
 	int			error;
 
+	/* We require the realtime rmapbt to rebuild anything. */
+	if (!xfs_has_rtrmapbt(sc->mp))
+		return -EOPNOTSUPP;
+	/* We require atomic file exchange range to rebuild anything. */
+	if (!xfs_has_exchange_range(sc->mp))
+		return -EOPNOTSUPP;
+
 	/* Impossibly large rtbitmap means we can't touch the filesystem. */
 	if (rtb->rbmblocks > U32_MAX)
 		return 0;
@@ -195,6 +535,79 @@ xrep_rtbitmap(
 	if (error)
 		return error;
 
-	/* Fix inconsistent bitmap geometry */
-	return xrep_rtbitmap_geometry(sc, rtb);
+	/*
+	 * Fix inconsistent bitmap geometry.  This function returns with a
+	 * clean scrub transaction.
+	 */
+	error = xrep_rtbitmap_geometry(sc, rtb);
+	if (error)
+		return error;
+
+	/*
+	 * Make sure the busy extent list is clear because we can't put extents
+	 * on there twice.
+	 */
+	if (!xfs_extent_busy_list_empty(xg, &busy_gen)) {
+		error = xfs_extent_busy_flush(sc->tp, xg, busy_gen, 0);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Generate the new rtbitmap data.  We don't need the rtbmp information
+	 * once this call is finished.
+	 */
+	error = xrep_rtbitmap_find_freespace(rtb);
+	if (error)
+		return error;
+
+	/*
+	 * Try to take ILOCK_EXCL of the temporary file.  We had better be the
+	 * only ones holding onto this inode, but we can't block while holding
+	 * the rtbitmap file's ILOCK_EXCL.
+	 */
+	while (!xrep_tempfile_ilock_nowait(sc)) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+		delay(1);
+	}
+
+	/*
+	 * Make sure we have space allocated for the part of the bitmap
+	 * file that corresponds to this group.  We already joined sc->ip.
+	 */
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+	error = xrep_tempfile_prealloc(sc, 0, rtb->rbmblocks);
+	if (error)
+		return error;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/* Copy the bitmap file that we generated. */
+	error = xrep_tempfile_copyin(sc, 0, rtb->rbmblocks,
+			xrep_rtbitmap_prep_buf, rtb);
+	if (error)
+		return error;
+	error = xrep_tempfile_set_isize(sc,
+			XFS_FSB_TO_B(sc->mp, sc->mp->m_sb.sb_rbmblocks));
+	if (error)
+		return error;
+
+	/*
+	 * Now exchange the data fork contents.  We're done with the temporary
+	 * buffer, so we can reuse it for the tempfile exchmaps information.
+	 */
+	error = xrep_tempexch_trans_reserve(sc, XFS_DATA_FORK, 0,
+			rtb->rbmblocks, &rtb->tempexch);
+	if (error)
+		return error;
+
+	error = xrep_tempexch_contents(sc, &rtb->tempexch);
+	if (error)
+		return error;
+
+	/* Free the old rtbitmap blocks if they're not in use. */
+	return xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
 }
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index 8198ea84ad70e5..d593977d70df21 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -165,7 +165,8 @@ xrep_rtsummary(
 	 * Now exchange the contents.  Nothing in repair uses the temporary
 	 * buffer, so we can reuse it for the tempfile exchrange information.
 	 */
-	error = xrep_tempexch_trans_reserve(sc, XFS_DATA_FORK, &rts->tempexch);
+	error = xrep_tempexch_trans_reserve(sc, XFS_DATA_FORK, 0,
+			rts->rsumblocks, &rts->tempexch);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/tempexch.h b/fs/xfs/scrub/tempexch.h
index 995ba187c5aa62..eccda720c2ca40 100644
--- a/fs/xfs/scrub/tempexch.h
+++ b/fs/xfs/scrub/tempexch.h
@@ -12,7 +12,7 @@ struct xrep_tempexch {
 };
 
 int xrep_tempexch_trans_reserve(struct xfs_scrub *sc, int whichfork,
-		struct xrep_tempexch *ti);
+		xfs_fileoff_t off, xfs_filblks_t len, struct xrep_tempexch *ti);
 int xrep_tempexch_trans_alloc(struct xfs_scrub *sc, int whichfork,
 		struct xrep_tempexch *ti);
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 4ebb5f8459e8f3..cf99e0ca51b008 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -606,6 +606,8 @@ STATIC int
 xrep_tempexch_prep_request(
 	struct xfs_scrub	*sc,
 	int			whichfork,
+	xfs_fileoff_t		off,
+	xfs_filblks_t		len,
 	struct xrep_tempexch	*tx)
 {
 	struct xfs_exchmaps_req	*req = &tx->req;
@@ -629,18 +631,19 @@ xrep_tempexch_prep_request(
 	/* Exchange all mappings in both forks. */
 	req->ip1 = sc->tempip;
 	req->ip2 = sc->ip;
-	req->startoff1 = 0;
-	req->startoff2 = 0;
+	req->startoff1 = off;
+	req->startoff2 = off;
 	switch (whichfork) {
 	case XFS_ATTR_FORK:
 		req->flags |= XFS_EXCHMAPS_ATTR_FORK;
 		break;
 	case XFS_DATA_FORK:
-		/* Always exchange sizes when exchanging data fork mappings. */
-		req->flags |= XFS_EXCHMAPS_SET_SIZES;
+		/* Exchange sizes when exchanging all data fork mappings. */
+		if (off == 0 && len == XFS_MAX_FILEOFF)
+			req->flags |= XFS_EXCHMAPS_SET_SIZES;
 		break;
 	}
-	req->blockcount = XFS_MAX_FILEOFF;
+	req->blockcount = len;
 
 	return 0;
 }
@@ -796,6 +799,8 @@ int
 xrep_tempexch_trans_reserve(
 	struct xfs_scrub	*sc,
 	int			whichfork,
+	xfs_fileoff_t		off,
+	xfs_filblks_t		len,
 	struct xrep_tempexch	*tx)
 {
 	int			error;
@@ -804,7 +809,7 @@ xrep_tempexch_trans_reserve(
 	xfs_assert_ilocked(sc->ip, XFS_ILOCK_EXCL);
 	xfs_assert_ilocked(sc->tempip, XFS_ILOCK_EXCL);
 
-	error = xrep_tempexch_prep_request(sc, whichfork, tx);
+	error = xrep_tempexch_prep_request(sc, whichfork, off, len, tx);
 	if (error)
 		return error;
 
@@ -842,7 +847,8 @@ xrep_tempexch_trans_alloc(
 	ASSERT(sc->tp == NULL);
 	ASSERT(xfs_has_exchange_range(sc->mp));
 
-	error = xrep_tempexch_prep_request(sc, whichfork, tx);
+	error = xrep_tempexch_prep_request(sc, whichfork, 0, XFS_MAX_FILEOFF,
+			tx);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 98f923ae664d0e..2450e214103fed 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -21,6 +21,7 @@
 #include "xfs_rmap.h"
 #include "xfs_parent.h"
 #include "xfs_metafile.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5afc440f22f56c..3b661e4443453c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -17,6 +17,7 @@
 #include "xfs_bit.h"
 #include "xfs_quota_defs.h"
 
+struct xfs_rtgroup;
 struct xfs_scrub;
 struct xfile;
 struct xfarray;
@@ -3607,6 +3608,155 @@ DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_try_unlink);
 DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_unlink);
 DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_link);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xrep_rtbitmap_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t start, xfs_rtxnum_t end),
+	TP_ARGS(mp, start, end),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_rtxnum_t, start)
+		__field(xfs_rtxnum_t, end)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rtdev = mp->m_rtdev_targp->bt_dev;
+		__entry->start = start;
+		__entry->end = end;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d startrtx 0x%llx endrtx 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->start,
+		  __entry->end)
+);
+#define DEFINE_REPAIR_RGBITMAP_EVENT(name) \
+DEFINE_EVENT(xrep_rtbitmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t start, \
+		 xfs_rtxnum_t end), \
+	TP_ARGS(mp, start, end))
+DEFINE_REPAIR_RGBITMAP_EVENT(xrep_rtbitmap_record_free);
+DEFINE_REPAIR_RGBITMAP_EVENT(xrep_rtbitmap_record_free_bulk);
+
+TRACE_EVENT(xrep_rtbitmap_or,
+	TP_PROTO(struct xfs_mount *mp, unsigned long long wordoff,
+		 xfs_rtword_t mask, xfs_rtword_t word),
+	TP_ARGS(mp, wordoff, mask, word),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(unsigned long long, wordoff)
+		__field(unsigned int, mask)
+		__field(unsigned int, word)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rtdev = mp->m_rtdev_targp->bt_dev;
+		__entry->wordoff = wordoff;
+		__entry->mask = mask;
+		__entry->word = word;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d wordoff 0x%llx mask 0x%x word 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->wordoff,
+		  __entry->mask,
+		  __entry->word)
+);
+
+TRACE_EVENT(xrep_rtbitmap_load,
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_fileoff_t rbmoff,
+		 xfs_rtxnum_t rtx, xfs_rtxnum_t len),
+	TP_ARGS(rtg, rbmoff, rtx, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_fileoff_t, rbmoff)
+		__field(xfs_rtxnum_t, rtx)
+		__field(xfs_rtxnum_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg_mount(rtg)->m_super->s_dev;
+		__entry->rtdev = rtg_mount(rtg)->m_rtdev_targp->bt_dev;
+		__entry->rgno = rtg_rgno(rtg);
+		__entry->rbmoff = rbmoff;
+		__entry->rtx = rtx;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d rgno 0x%x rbmoff 0x%llx rtx 0x%llx rtxcount 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->rgno,
+		  __entry->rbmoff,
+		  __entry->rtx,
+		  __entry->len)
+);
+
+TRACE_EVENT(xrep_rtbitmap_load_words,
+	TP_PROTO(struct xfs_mount *mp, xfs_fileoff_t rbmoff,
+		 unsigned long long wordoff, unsigned int wordcnt),
+	TP_ARGS(mp, rbmoff, wordoff, wordcnt),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_fileoff_t, rbmoff)
+		__field(unsigned long long, wordoff)
+		__field(unsigned int, wordcnt)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rtdev = mp->m_rtdev_targp->bt_dev;
+		__entry->rbmoff = rbmoff;
+		__entry->wordoff = wordoff;
+		__entry->wordcnt = wordcnt;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d rbmoff 0x%llx wordoff 0x%llx wordcnt 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->rbmoff,
+		  __entry->wordoff,
+		  __entry->wordcnt)
+);
+
+TRACE_EVENT(xrep_rtbitmap_load_word,
+	TP_PROTO(struct xfs_mount *mp, unsigned long long wordoff,
+		 unsigned int bit, xfs_rtword_t ondisk_word,
+		 xfs_rtword_t xfile_word, xfs_rtword_t word_mask),
+	TP_ARGS(mp, wordoff, bit, ondisk_word, xfile_word, word_mask),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(unsigned long long, wordoff)
+		__field(unsigned int, bit)
+		__field(xfs_rtword_t, ondisk_word)
+		__field(xfs_rtword_t, xfile_word)
+		__field(xfs_rtword_t, word_mask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rtdev = mp->m_rtdev_targp->bt_dev;
+		__entry->wordoff = wordoff;
+		__entry->bit = bit;
+		__entry->ondisk_word = ondisk_word;
+		__entry->xfile_word = xfile_word;
+		__entry->word_mask = word_mask;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d wordoff 0x%llx bit %u ondisk 0x%x(0x%x) inmem 0x%x(0x%x) result 0x%x mask 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->wordoff,
+		  __entry->bit,
+		  __entry->ondisk_word,
+		  __entry->ondisk_word & __entry->word_mask,
+		  __entry->xfile_word,
+		  __entry->xfile_word & ~__entry->word_mask,
+		  (__entry->xfile_word & ~__entry->word_mask) |
+		  (__entry->ondisk_word & __entry->word_mask),
+		  __entry->word_mask)
+);
+#endif /* CONFIG_XFS_RT */
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

