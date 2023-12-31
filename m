Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21550BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/IP8dPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4F8C433C8;
	Sun, 31 Dec 2023 21:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058840;
	bh=doGXoTJgJSJDtlNOlCgbG0xS4+EzPXbIRtDvD36gvzc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h/IP8dPfiMCE+d79yHVjUDFVMwmyWTPU64vyG76jPmhbcfezqMackYHfBbhgKZhLW
	 mFqF2OM3CM4TNLbkFTZxLoClRCbYUsb0ZV4DS+0WpRDEDacM6UMlq2Jg7PsjPoLo7h
	 /6PP44LXvgaNOjlaqvEidU0UCMGeZWI99qR7EV6HeQkWikjGGN66ffcMWpi64mbqzM
	 HUccbSzx50B0jGkd+lj5YaPXznq0hgG6Z1zDr2LZ8788ALyA1uRvzT3rBq0DQiirSn
	 9fZQPfalNNRDZ1O7I3Lu+tywaZLbQJexMWk4I6o6Uv+9h/JYqSfFf8RJWZgFedgbUi
	 ieCyIexXFWyMQ==
Date: Sun, 31 Dec 2023 13:40:39 -0800
Subject: [PATCH 34/39] xfs: online repair of realtime bitmaps for a realtime
 group
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850446.1764998.15564224276753988976.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.h           |    5 
 fs/xfs/scrub/repair.c           |    2 
 fs/xfs/scrub/repair.h           |    4 
 fs/xfs/scrub/rtbitmap.c         |   19 +
 fs/xfs/scrub/rtbitmap.h         |   56 +++
 fs/xfs/scrub/rtbitmap_repair.c  |  676 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtsummary_repair.c |    3 
 fs/xfs/scrub/scrub.c            |    2 
 fs/xfs/scrub/tempfile.c         |   15 +
 fs/xfs/scrub/tempswap.h         |    2 
 fs/xfs/scrub/trace.c            |    1 
 fs/xfs/scrub/trace.h            |  149 +++++++++
 12 files changed, 922 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index c0b2c62d4bd82..5dc481f69d160 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -274,6 +274,11 @@ int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 			(sc)->mp->m_super->s_id, \
 			(sc)->ip ? (sc)->ip->i_ino : (sc)->sm->sm_ino, \
 			##__VA_ARGS__)
+#define xchk_xfile_rtgroup_descr(sc, fmt, ...) \
+	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): rtgroup 0x%x " fmt, \
+			(sc)->mp->m_super->s_id, \
+			(sc)->sa.pag ? (sc)->sr.rtg->rtg_rgno : (sc)->sm->sm_agno, \
+			##__VA_ARGS__)
 
 /*
  * Setting up a hook to wait for intents to drain is costly -- we have to take
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 5af1a8871de55..4789014be4a36 100644
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
index e7fe4c5d8de5d..b66e0b5331394 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -109,6 +109,7 @@ int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
 #ifdef CONFIG_XFS_RT
 int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
+void xrep_rtgroup_btcur_init(struct xfs_scrub *sc, struct xchk_rt *sr);
 int xrep_require_rtext_inuse(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
 		xfs_filblks_t len);
 #else
@@ -151,10 +152,12 @@ int xrep_metapath(struct xfs_scrub *sc);
 int xrep_rtbitmap(struct xfs_scrub *sc);
 int xrep_rtsummary(struct xfs_scrub *sc);
 int xrep_rgsuperblock(struct xfs_scrub *sc);
+int xrep_rgbitmap(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
 # define xrep_rtsummary			xrep_notsupported
 # define xrep_rgsuperblock		xrep_notsupported
+# define xrep_rgbitmap			xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -260,6 +263,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_dirtree			xrep_notsupported
 #define xrep_metapath			xrep_notsupported
 #define xrep_rgsuperblock		xrep_notsupported
+#define xrep_rgbitmap			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 0d823eadbdba0..47463ef336eed 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -19,9 +19,11 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_swapext.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
+#include "scrub/tempswap.h"
 #include "scrub/rtbitmap.h"
 #include "scrub/btree.h"
 
@@ -45,15 +47,26 @@ xchk_setup_rgbitmap(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xchk_rgbitmap	*rgb;
+	unsigned int		wordcnt = xchk_rgbitmap_wordcnt(sc);
 	int			error;
 
-	rgb = kzalloc(sizeof(struct xchk_rgbitmap), XCHK_GFP_FLAGS);
+	if (xchk_need_intent_drain(sc))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
+
+	rgb = kzalloc(struct_size(rgb, words, wordcnt), XCHK_GFP_FLAGS);
 	if (!rgb)
 		return -ENOMEM;
 	rgb->sc = sc;
 	sc->buf = rgb;
+	rgb->rtglock_flags = XCHK_RTGLOCK_ALL;
 
-	error = xchk_trans_alloc(sc, 0);
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_rgbitmap(sc, rgb);
+		if (error)
+			return error;
+	}
+
+	error = xchk_trans_alloc(sc, rgb->rtb.resblks);
 	if (error)
 		return error;
 
@@ -66,7 +79,7 @@ xchk_setup_rgbitmap(
 		return error;
 
 	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr,
-			XCHK_RTGLOCK_ALL);
+			rgb->rtglock_flags);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtbitmap.h b/fs/xfs/scrub/rtbitmap.h
index 42d50fa48a0ec..6ff897f0871f8 100644
--- a/fs/xfs/scrub/rtbitmap.h
+++ b/fs/xfs/scrub/rtbitmap.h
@@ -13,19 +13,75 @@ struct xchk_rtbitmap {
 	unsigned int		resblks;
 };
 
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
 struct xchk_rgbitmap {
 	struct xfs_scrub	*sc;
 
 	struct xchk_rtbitmap	rtb;
 
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	struct xfs_rtalloc_args	args;
+	struct xrep_tempswap	tempswap;
+#endif
+
 	/* The next free rt block that we expect to see. */
 	xfs_rtblock_t		next_free_rtblock;
+
+	/* file offset inside the rtbitmap where we start swapping */
+	xfs_fileoff_t		group_rbmoff;
+
+	/* number of rtbitmap blocks for this group */
+	xfs_filblks_t		group_rbmlen;
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
+	/* Memory buffer full of 1s for rgbitmap repair. */
+	union xfs_rtword_raw	words[];
 };
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 int xrep_setup_rtbitmap(struct xfs_scrub *sc, struct xchk_rtbitmap *rtb);
+int xrep_setup_rgbitmap(struct xfs_scrub *sc, struct xchk_rgbitmap *rgb);
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
+xchk_rgbitmap_wordcnt(
+	struct xfs_scrub	*sc)
+{
+	if (xchk_could_repair(sc))
+		return sc->mp->m_sb.sb_blocksize >> XFS_WORDLOG;
+	return 0;
+}
 #else
 # define xrep_setup_rtbitmap(sc, rtb)	(0)
+# define xrep_setup_rgbitmap(sc, rgb)	(0)
+# define xchk_rgbitmap_wordcnt(sc)	(0)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
 #endif /* __XFS_SCRUB_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 46f5d5f605c91..db87ce51c35fc 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -12,17 +12,693 @@
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
+#include "xfs_swapext.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/xfile.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempswap.h"
+#include "scrub/reap.h"
 #include "scrub/rtbitmap.h"
 
+/* rt bitmap content repairs */
+
+/* Set up to repair the realtime bitmap for this group. */
+int
+xrep_setup_rgbitmap(
+	struct xfs_scrub	*sc,
+	struct xchk_rgbitmap	*rgb)
+{
+	struct xfs_mount	*mp = sc->mp;
+	char			*descr;
+	unsigned long long	blocks = 0;
+	unsigned long long	rtbmp_words;
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFREG);
+	if (error)
+		return error;
+
+	/* Create an xfile to hold our reconstructed bitmap. */
+	rtbmp_words = xfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
+	descr = xchk_xfile_rtgroup_descr(sc, "bitmap file");
+	error = xfile_create(descr, rtbmp_words << XFS_WORDLOG, &sc->xfile);
+	kfree(descr);
+	if (error)
+		return error;
+
+	/*
+	 * Reserve enough blocks to write out a completely new bitmap file,
+	 * plus twice as many blocks as we would need if we can only allocate
+	 * one block per data fork mapping.  This should cover the
+	 * preallocation of the temporary file and swapping the extent
+	 * mappings.
+	 *
+	 * We cannot use xfs_swapext_estimate because we have not yet
+	 * constructed the replacement bitmap and therefore do not know how
+	 * many extents it will use.  By the time we do, we will have a dirty
+	 * transaction (which we cannot drop because we cannot drop the
+	 * rtbitmap ILOCK) and cannot ask for more reservation.
+	 */
+	blocks = mp->m_sb.sb_rbmblocks;
+	blocks += xfs_bmbt_calc_size(mp, blocks) * 2;
+	if (blocks > UINT_MAX)
+		return -EOPNOTSUPP;
+
+	rgb->rtb.resblks += blocks;
+
+	/*
+	 * Grab support for atomic extent swapping before we allocate any
+	 * transactions or grab ILOCKs.
+	 */
+	error = xrep_tempswap_grab_log_assist(sc);
+	if (error)
+		return error;
+
+	/*
+	 * We must hold rbmip with ILOCK_EXCL to use the extent swap at the end
+	 * of the repair function.  Change the desired rtglock flags.
+	 */
+	rgb->rtglock_flags &= ~XFS_RTGLOCK_BITMAP_SHARED;
+	rgb->rtglock_flags |= XFS_RTGLOCK_BITMAP;
+	return 0;
+}
+
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
+	struct xchk_rgbitmap	*rgb,
+	xrep_wordoff_t		wordoff,
+	xfs_rtword_t		*word)
+{
+	union xfs_rtword_raw	urk;
+	int			error;
+
+	ASSERT(xfs_has_rtgroups(rgb->sc->mp));
+
+	error = xfile_obj_load(rgb->sc->xfile, &urk,
+			sizeof(union xfs_rtword_raw),
+			wordoff << XFS_WORDLOG);
+	if (error)
+		return error;
+
+	*word = le32_to_cpu(urk.rtg);
+	return 0;
+}
+
+static inline int
+xfbmp_store(
+	struct xchk_rgbitmap	*rgb,
+	xrep_wordoff_t		wordoff,
+	const xfs_rtword_t	word)
+{
+	union xfs_rtword_raw	urk;
+
+	ASSERT(xfs_has_rtgroups(rgb->sc->mp));
+
+	urk.rtg = cpu_to_le32(word);
+	return xfile_obj_store(rgb->sc->xfile, &urk,
+			sizeof(union xfs_rtword_raw),
+			wordoff << XFS_WORDLOG);
+}
+
+static inline int
+xfbmp_copyin(
+	struct xchk_rgbitmap	*rgb,
+	xrep_wordoff_t		wordoff,
+	const union xfs_rtword_raw	*word,
+	xrep_wordcnt_t		nr_words)
+{
+	return xfile_obj_store(rgb->sc->xfile, word, nr_words << XFS_WORDLOG,
+			wordoff << XFS_WORDLOG);
+}
+
+static inline int
+xfbmp_copyout(
+	struct xchk_rgbitmap	*rgb,
+	xrep_wordoff_t		wordoff,
+	union xfs_rtword_raw	*word,
+	xrep_wordcnt_t		nr_words)
+{
+	return xfile_obj_load(rgb->sc->xfile, word, nr_words << XFS_WORDLOG,
+			wordoff << XFS_WORDLOG);
+}
+
+/*
+ * Preserve the portions of the rtbitmap block for the start of this rtgroup
+ * that map to the previous rtgroup.
+ */
+STATIC int
+xrep_rgbitmap_load_before(
+	struct xchk_rgbitmap	*rgb)
+{
+	struct xfs_scrub	*sc = rgb->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	xrep_wordoff_t		wordoff;
+	xfs_rtblock_t		group_rtbno;
+	xfs_rtxnum_t		group_rtx, rbmoff_rtx;
+	xfs_rtword_t		ondisk_word;
+	xfs_rtword_t		xfile_word;
+	xfs_rtword_t		mask;
+	xrep_wordcnt_t		wordcnt;
+	int			bit;
+	int			error;
+
+	/*
+	 * Compute the file offset within the rtbitmap block that corresponds
+	 * to the start of this group, and decide if we need to read blocks
+	 * from the group before this one.
+	 */
+	group_rtbno = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, 0);
+	group_rtx = xfs_rtb_to_rtx(mp, group_rtbno);
+
+	rgb->group_rbmoff = xfs_rtx_to_rbmblock(mp, group_rtx);
+	rbmoff_rtx = xfs_rbmblock_to_rtx(mp, rgb->group_rbmoff);
+	rgb->prep_wordoff = rtx_to_wordoff(mp, rbmoff_rtx);
+
+	trace_xrep_rgbitmap_load(rtg, rgb->group_rbmoff, rbmoff_rtx,
+			group_rtx - 1);
+
+	if (rbmoff_rtx == group_rtx)
+		return 0;
+
+	rgb->args.mp = sc->mp;
+	rgb->args.tp = sc->tp;
+	error = xfs_rtbitmap_read_buf(&rgb->args, rgb->group_rbmoff);
+	if (error) {
+		/*
+		 * Reading the existing rbmblock failed, and we must deal with
+		 * the part of the rtbitmap block that corresponds to the
+		 * previous group.  The most conservative option is to fill
+		 * that part of the bitmap with zeroes so that it won't get
+		 * allocated.  The xfile contains zeroes already, so we can
+		 * return.
+		 */
+		return 0;
+	}
+
+	/*
+	 * Copy full rtbitmap words into memory from the beginning of the
+	 * ondisk block until we get to the word that corresponds to the start
+	 * of this group.
+	 */
+	wordoff = rtx_to_wordoff(mp, rbmoff_rtx);
+	wordcnt = rtxlen_to_wordcnt(group_rtx - rbmoff_rtx);
+	if (wordcnt > 0) {
+		union xfs_rtword_raw	*p;
+
+		p = xfs_rbmblock_wordptr(&rgb->args, 0);
+		error = xfbmp_copyin(rgb, wordoff, p, wordcnt);
+		if (error)
+			goto out_rele;
+
+		trace_xrep_rgbitmap_load_words(mp, rgb->group_rbmoff, wordoff,
+				wordcnt);
+		wordoff += wordcnt;
+	}
+
+	/*
+	 * Compute the bit position of the first rtextent of this group.  If
+	 * the bit position is zero, we don't have to RMW a partial word and
+	 * move to the next step.
+	 */
+	bit = group_rtx & XREP_RTBMP_WORDMASK;
+	if (bit == 0)
+		goto out_rele;
+
+	/*
+	 * Create a mask of the bits that we want to load from disk.  These
+	 * bits track space in a different rtgroup, which is why we must
+	 * preserve them even as we replace parts of the bitmap.
+	 */
+	mask = ~((((xfs_rtword_t)1 << (XFS_NBWORD - bit)) - 1) << bit);
+
+	error = xfbmp_load(rgb, wordoff, &xfile_word);
+	if (error)
+		goto out_rele;
+	ondisk_word = xfs_rtbitmap_getword(&rgb->args, wordcnt);
+
+	trace_xrep_rgbitmap_load_word(mp, wordoff, bit, ondisk_word,
+			xfile_word, mask);
+
+	xfile_word &= ~mask;
+	xfile_word |= (ondisk_word & mask);
+
+	error = xfbmp_store(rgb, wordoff, xfile_word);
+	if (error)
+		goto out_rele;
+
+out_rele:
+	xfs_rtbuf_cache_relse(&rgb->args);
+	return error;
+}
+
+/*
+ * Preserve the portions of the rtbitmap block for the end of this rtgroup
+ * that map to the next rtgroup.
+ */
+STATIC int
+xrep_rgbitmap_load_after(
+	struct xchk_rgbitmap	*rgb)
+{
+	struct xfs_scrub	*sc = rgb->sc;
+	struct xfs_mount	*mp = rgb->sc->mp;
+	struct xfs_rtgroup	*rtg = rgb->sc->sr.rtg;
+	xrep_wordoff_t		wordoff;
+	xfs_rtblock_t		last_rtbno;
+	xfs_rtxnum_t		last_group_rtx, last_rbmblock_rtx;
+	xfs_fileoff_t		last_group_rbmoff;
+	xfs_rtword_t		ondisk_word;
+	xfs_rtword_t		xfile_word;
+	xfs_rtword_t		mask;
+	xrep_wordcnt_t		wordcnt;
+	unsigned int		last_group_word;
+	int			bit;
+	int			error;
+
+	last_rtbno = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno,
+					rtg->rtg_blockcount - 1);
+	last_group_rtx = xfs_rtb_to_rtx(mp, last_rtbno);
+
+	last_group_rbmoff = xfs_rtx_to_rbmblock(mp, last_group_rtx);
+	rgb->group_rbmlen = last_group_rbmoff - rgb->group_rbmoff + 1;
+	last_rbmblock_rtx = xfs_rbmblock_to_rtx(mp, last_group_rbmoff + 1) - 1;
+
+	trace_xrep_rgbitmap_load(rtg, last_group_rbmoff, last_group_rtx + 1,
+			last_rbmblock_rtx);
+
+	if (last_rbmblock_rtx == last_group_rtx ||
+	    rtg->rtg_rgno == mp->m_sb.sb_rgcount - 1)
+		return 0;
+
+	rgb->args.mp = sc->mp;
+	rgb->args.tp = sc->tp;
+	error = xfs_rtbitmap_read_buf(&rgb->args, last_group_rbmoff);
+	if (error) {
+		/*
+		 * Reading the existing rbmblock failed, and we must deal with
+		 * the part of the rtbitmap block that corresponds to the
+		 * previous group.  The most conservative option is to fill
+		 * that part of the bitmap with zeroes so that it won't get
+		 * allocated.  The xfile contains zeroes already, so we can
+		 * return.
+		 */
+		return 0;
+	}
+
+	/*
+	 * Compute the bit position of the first rtextent of the next group.
+	 * If the bit position is zero, we don't have to RMW a partial word
+	 * and move to the next step.
+	 */
+	wordoff = rtx_to_wordoff(mp, last_group_rtx);
+	bit = (last_group_rtx + 1) & XREP_RTBMP_WORDMASK;
+	if (bit == 0)
+		goto copy_words;
+
+	/*
+	 * Create a mask of the bits that we want to load from disk.  These
+	 * bits track space in a different rtgroup, which is why we must
+	 * preserve them even as we replace parts of the bitmap.
+	 */
+	mask = (((xfs_rtword_t)1 << (XFS_NBWORD - bit)) - 1) << bit;
+
+	error = xfbmp_load(rgb, wordoff, &xfile_word);
+	if (error)
+		goto out_rele;
+	last_group_word = xfs_rtx_to_rbmword(mp, last_group_rtx);
+	ondisk_word = xfs_rtbitmap_getword(&rgb->args, last_group_word);
+
+	trace_xrep_rgbitmap_load_word(mp, wordoff, bit, ondisk_word,
+			xfile_word, mask);
+
+	xfile_word &= ~mask;
+	xfile_word |= (ondisk_word & mask);
+
+	error = xfbmp_store(rgb, wordoff, xfile_word);
+	if (error)
+		goto out_rele;
+
+copy_words:
+	/* Copy as many full words as we can. */
+	wordoff++;
+	wordcnt = rtxlen_to_wordcnt(last_rbmblock_rtx - last_group_rtx);
+	if (wordcnt > 0) {
+		union xfs_rtword_raw	*p;
+
+		p = xfs_rbmblock_wordptr(&rgb->args,
+				mp->m_blockwsize - wordcnt);
+		error = xfbmp_copyin(rgb, wordoff, p, wordcnt);
+		if (error)
+			goto out_rele;
+
+		trace_xrep_rgbitmap_load_words(mp, last_group_rbmoff, wordoff,
+				wordcnt);
+	}
+
+out_rele:
+	xfs_rtbuf_cache_relse(&rgb->args);
+	return error;
+}
+
+/* Perform a logical OR operation on an rtword in the incore bitmap. */
+static int
+xrep_rgbitmap_or(
+	struct xchk_rgbitmap	*rgb,
+	xrep_wordoff_t		wordoff,
+	xfs_rtword_t		mask)
+{
+	xfs_rtword_t		word;
+	int			error;
+
+	error = xfbmp_load(rgb, wordoff, &word);
+	if (error)
+		return error;
+
+	trace_xrep_rgbitmap_or(rgb->sc->mp, wordoff, mask, word);
+
+	return xfbmp_store(rgb, wordoff, word | mask);
+}
+
+/*
+ * Mark as free every rt extent between the next rt block we expected to see
+ * in the rtrmap records and the given rt block.
+ */
+STATIC int
+xrep_rgbitmap_mark_free(
+	struct xchk_rgbitmap	*rgb,
+	xfs_rgblock_t		rgbno)
+{
+	struct xfs_mount	*mp = rgb->sc->mp;
+	struct xfs_rtgroup	*rtg = rgb->sc->sr.rtg;
+	xfs_rtblock_t		rtbno;
+	xfs_rtxnum_t		startrtx;
+	xfs_rtxnum_t		nextrtx;
+	xrep_wordoff_t		wordoff, nextwordoff;
+	unsigned int		bit;
+	unsigned int		bufwsize;
+	xfs_extlen_t		mod;
+	xfs_rtword_t		mask;
+	int			error;
+
+	if (!xfs_verify_rgbext(rtg, rgb->next_rgbno, rgbno - rgb->next_rgbno))
+		return -EFSCORRUPTED;
+
+	/*
+	 * Convert rt blocks to rt extents  The block range we find must be
+	 * aligned to an rtextent boundary on both ends.
+	 */
+	rtbno = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, rgb->next_rgbno);
+	startrtx = xfs_rtb_to_rtxrem(mp, rtbno, &mod);
+	if (mod)
+		return -EFSCORRUPTED;
+
+	rtbno = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, rgbno - 1);
+	nextrtx = xfs_rtb_to_rtxrem(mp, rtbno, &mod) + 1;
+	if (mod != mp->m_sb.sb_rextsize - 1)
+		return -EFSCORRUPTED;
+
+	trace_xrep_rgbitmap_record_free(mp, startrtx, nextrtx - 1);
+
+	/* Set bits as needed to round startrtx up to the nearest word. */
+	bit = startrtx & XREP_RTBMP_WORDMASK;
+	if (bit) {
+		xfs_rtblock_t	len = nextrtx - startrtx;
+		unsigned int	lastbit;
+
+		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
+
+		error = xrep_rgbitmap_or(rgb, rtx_to_wordoff(mp, startrtx),
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
+		error = xrep_rgbitmap_or(rgb, rtx_to_wordoff(mp, nextrtx),
+				mask);
+		if (error || startrtx + bit == nextrtx)
+			return error;
+		nextrtx -= bit;
+	}
+
+	trace_xrep_rgbitmap_record_free_bulk(mp, startrtx, nextrtx - 1);
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
+		error = xfbmp_copyin(rgb, wordoff, rgb->words, wordcnt);
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
+xrep_rgbitmap_walk_rtrmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xchk_rgbitmap		*rgb = priv;
+	int				error = 0;
+
+	if (xchk_should_terminate(rgb->sc, &error))
+		return error;
+
+	if (rgb->next_rgbno < rec->rm_startblock) {
+		error = xrep_rgbitmap_mark_free(rgb, rec->rm_startblock);
+		if (error)
+			return error;
+	}
+
+	rgb->next_rgbno = max(rgb->next_rgbno,
+			      rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
+/*
+ * Walk the rtrmapbt to find all the gaps between records, and mark the gaps
+ * in the realtime bitmap that we're computing.
+ */
+STATIC int
+xrep_rgbitmap_find_freespace(
+	struct xchk_rgbitmap	*rgb)
+{
+	struct xfs_scrub	*sc = rgb->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	int			error;
+
+	/* Prepare a buffer of ones so that we can accelerate bulk setting. */
+	memset(rgb->words, 0xFF, mp->m_sb.sb_blocksize);
+
+	xrep_rtgroup_btcur_init(sc, &sc->sr);
+	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_rgbitmap_walk_rtrmap,
+			rgb);
+	if (error)
+		goto out;
+
+	/*
+	 * Mark as free every possible rt extent from the last one we saw to
+	 * the end of the rt group.
+	 */
+	if (rgb->next_rgbno < rtg->rtg_blockcount) {
+		error = xrep_rgbitmap_mark_free(rgb, rtg->rtg_blockcount);
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
+xrep_rgbitmap_prep_buf(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp,
+	void			*data)
+{
+	struct xchk_rgbitmap	*rgb = data;
+	struct xfs_mount	*mp = sc->mp;
+	union xfs_rtword_raw	*ondisk;
+	int			error;
+
+	rgb->args.mp = sc->mp;
+	rgb->args.tp = sc->tp;
+	rgb->args.rbmbp = bp;
+	ondisk = xfs_rbmblock_wordptr(&rgb->args, 0);
+	rgb->args.rbmbp = NULL;
+
+	error = xfbmp_copyout(rgb, rgb->prep_wordoff, ondisk,
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
+	rgb->prep_wordoff += mp->m_blockwsize;
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTBITMAP_BUF);
+	return 0;
+}
+
+/* Repair the realtime bitmap for this rt group. */
+int
+xrep_rgbitmap(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_rgbitmap	*rgb = sc->buf;
+	int			error;
+
+	/*
+	 * We require the realtime rmapbt (and atomic file updates) to rebuild
+	 * anything.
+	 */
+	if (!xfs_has_rtrmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	/*
+	 * If the start or end of this rt group happens to be in the middle of
+	 * an rtbitmap block, try to read in the parts of the bitmap that are
+	 * from some other group.
+	 */
+	error = xrep_rgbitmap_load_before(rgb);
+	if (error)
+		return error;
+	error = xrep_rgbitmap_load_after(rgb);
+	if (error)
+		return error;
+
+	/*
+	 * Generate the new rtbitmap data.  We don't need the rtbmp information
+	 * once this call is finished.
+	 */
+	error = xrep_rgbitmap_find_freespace(rgb);
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
+	 * file that corresponds to this group.
+	 */
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+	error = xrep_tempfile_prealloc(sc, rgb->group_rbmoff, rgb->group_rbmlen);
+	if (error)
+		return error;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/* Copy the bitmap file that we generated. */
+	error = xrep_tempfile_copyin(sc, rgb->group_rbmoff, rgb->group_rbmlen,
+			xrep_rgbitmap_prep_buf, rgb);
+	if (error)
+		return error;
+	error = xrep_tempfile_set_isize(sc,
+			XFS_FSB_TO_B(sc->mp, sc->mp->m_sb.sb_rbmblocks));
+	if (error)
+		return error;
+
+	/*
+	 * Now swap the extents.  We're done with the temporary buffer, so
+	 * we can reuse it for the tempfile swapext information.
+	 */
+	error = xrep_tempswap_trans_reserve(sc, XFS_DATA_FORK,
+			rgb->group_rbmoff, rgb->group_rbmlen, &rgb->tempswap);
+	if (error)
+		return error;
+
+	error = xrep_tempswap_contents(sc, &rgb->tempswap);
+	if (error)
+		return error;
+
+	/* Free the old bitmap blocks if they are free. */
+	return xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
+}
+
+/* rt bitmap file repairs */
+
 /* Set up to repair the realtime bitmap file metadata. */
 int
 xrep_setup_rtbitmap(
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index c66373eec436d..390c6403e8908 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -168,7 +168,8 @@ xrep_rtsummary(
 	 * Now swap the extents.  Nothing in repair uses the temporary buffer,
 	 * so we can reuse it for the tempfile swapext information.
 	 */
-	error = xrep_tempswap_trans_reserve(sc, XFS_DATA_FORK, &rts->tempswap);
+	error = xrep_tempswap_trans_reserve(sc, XFS_DATA_FORK, 0, rsumblocks,
+			&rts->tempswap);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 428624d4f0c45..435003e5a1e92 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -472,7 +472,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rgbitmap,
 		.scrub	= xchk_rgbitmap,
 		.has	= xfs_has_rtgroups,
-		.repair = xrep_notsupported,
+		.repair = xrep_rgbitmap,
 	},
 	[XFS_SCRUB_TYPE_RTRMAPBT] = {	/* realtime group rmapbt */
 		.type	= ST_RTGROUP,
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 1dd7c4c5cff0f..e4d1c703c3195 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -608,6 +608,8 @@ STATIC int
 xrep_tempswap_prep_request(
 	struct xfs_scrub	*sc,
 	int			whichfork,
+	xfs_fileoff_t		off,
+	xfs_filblks_t		len,
 	struct xrep_tempswap	*tx)
 {
 	struct xfs_swapext_req	*req = &tx->req;
@@ -631,10 +633,10 @@ xrep_tempswap_prep_request(
 	/* Swap all mappings in both forks. */
 	req->ip1 = sc->tempip;
 	req->ip2 = sc->ip;
-	req->startoff1 = 0;
-	req->startoff2 = 0;
+	req->startoff1 = off;
+	req->startoff2 = off;
 	req->whichfork = whichfork;
-	req->blockcount = XFS_MAX_FILEOFF;
+	req->blockcount = len;
 	req->req_flags = XFS_SWAP_REQ_LOGGED;
 
 	/* Always swap sizes when we're swapping data fork mappings. */
@@ -801,6 +803,8 @@ int
 xrep_tempswap_trans_reserve(
 	struct xfs_scrub	*sc,
 	int			whichfork,
+	xfs_fileoff_t		off,
+	xfs_filblks_t		len,
 	struct xrep_tempswap	*tx)
 {
 	int			error;
@@ -809,7 +813,7 @@ xrep_tempswap_trans_reserve(
 	ASSERT(xfs_isilocked(sc->ip, XFS_ILOCK_EXCL));
 	ASSERT(xfs_isilocked(sc->tempip, XFS_ILOCK_EXCL));
 
-	error = xrep_tempswap_prep_request(sc, whichfork, tx);
+	error = xrep_tempswap_prep_request(sc, whichfork, off, len, tx);
 	if (error)
 		return error;
 
@@ -846,7 +850,8 @@ xrep_tempswap_trans_alloc(
 
 	ASSERT(sc->tp == NULL);
 
-	error = xrep_tempswap_prep_request(sc, whichfork, tx);
+	error = xrep_tempswap_prep_request(sc, whichfork, 0, XFS_MAX_FILEOFF,
+			tx);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/tempswap.h b/fs/xfs/scrub/tempswap.h
index 83900eef8cfc5..0be14f5f6382e 100644
--- a/fs/xfs/scrub/tempswap.h
+++ b/fs/xfs/scrub/tempswap.h
@@ -13,7 +13,7 @@ struct xrep_tempswap {
 
 int xrep_tempswap_grab_log_assist(struct xfs_scrub *sc);
 int xrep_tempswap_trans_reserve(struct xfs_scrub *sc, int whichfork,
-		struct xrep_tempswap *ti);
+		xfs_fileoff_t off, xfs_filblks_t len, struct xrep_tempswap *ti);
 int xrep_tempswap_trans_alloc(struct xfs_scrub *sc, int whichfork,
 		struct xrep_tempswap *ti);
 
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 06f7b89920e94..4d0a6dceaa6c6 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -22,6 +22,7 @@
 #include "xfs_rmap.h"
 #include "xfs_parent.h"
 #include "xfs_imeta.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f02914f129605..c90324ca86579 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3752,6 +3752,155 @@ DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_try_unlink);
 DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_unlink);
 DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_link);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xrep_rgbitmap_class,
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
+DEFINE_EVENT(xrep_rgbitmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t start, \
+		 xfs_rtxnum_t end), \
+	TP_ARGS(mp, start, end))
+DEFINE_REPAIR_RGBITMAP_EVENT(xrep_rgbitmap_record_free);
+DEFINE_REPAIR_RGBITMAP_EVENT(xrep_rgbitmap_record_free_bulk);
+
+TRACE_EVENT(xrep_rgbitmap_or,
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
+TRACE_EVENT(xrep_rgbitmap_load,
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
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rtdev = rtg->rtg_mount->m_rtdev_targp->bt_dev;
+		__entry->rgno = rtg->rtg_rgno;
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
+TRACE_EVENT(xrep_rgbitmap_load_words,
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
+TRACE_EVENT(xrep_rgbitmap_load_word,
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
 
 

