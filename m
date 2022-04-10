Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BD6C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Apr 2022 18:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbiDJSXQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 14:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiDJSXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 14:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E26622531
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 11:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19B96B80E51
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4016C385A4;
        Sun, 10 Apr 2022 18:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649614860;
        bh=85ICI0r3JUv4k8vmFJZvrvuR/ZZx4S9xEM7OJbVMFac=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KNrz1HR7H6g/s2goJYHsAbP0XadXnqiZh+ZtsPMnMQnTT6lFnKPGLJFN8uZ69L/a7
         1U8VwMOunyP2oHMv1f9Rvk/MSzB/ZPu9AU4jNdYhRFyspalcDrMupA8X650evJ3Mtg
         gFFx2j67joQXdTUZSWeW5NQt4PHyo084BWi/EupauD9W4RP60eg+OiVQWQPl9MvCtp
         56zRmN8+dAp4XWIKLFaHHIUaqyUhmiAz3HQEV8AqUswt4dVgmPMX5Fsm8NAe0MZRyg
         VO8nRy5PtHbeqTHz2gGm0vnTz1UkJNJjn8c/Y/D+Y5XW7LWHIglQfFwxFY6htCD7eu
         OkpRzcz/hMpfw==
Subject: [PATCH 1/3] xfs: pass explicit mount pointer to rtalloc query
 functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 10 Apr 2022 11:21:00 -0700
Message-ID: <164961486038.70555.14613665424255377303.stgit@magnolia>
In-Reply-To: <164961485474.70555.18228016043917319266.stgit@magnolia>
References: <164961485474.70555.18228016043917319266.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass an explicit xfs_mount pointer to the rtalloc query functions so
that they can support transactionless queries.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 +++++----
 fs/xfs/scrub/rtbitmap.c      |    9 +++++----
 fs/xfs/xfs_fsmap.c           |    6 +++---
 fs/xfs/xfs_rtalloc.h         |    7 ++++---
 4 files changed, 17 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 5740ba664867..fa180ab66b73 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1008,6 +1008,7 @@ xfs_rtfree_extent(
 /* Find all the free records within a given range. */
 int
 xfs_rtalloc_query_range(
+	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*low_rec,
 	const struct xfs_rtalloc_rec	*high_rec,
@@ -1015,7 +1016,6 @@ xfs_rtalloc_query_range(
 	void				*priv)
 {
 	struct xfs_rtalloc_rec		rec;
-	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			rtstart;
 	xfs_rtblock_t			rtend;
 	xfs_rtblock_t			high_key;
@@ -1048,7 +1048,7 @@ xfs_rtalloc_query_range(
 			rec.ar_startext = rtstart;
 			rec.ar_extcount = rtend - rtstart + 1;
 
-			error = fn(tp, &rec, priv);
+			error = fn(mp, tp, &rec, priv);
 			if (error)
 				break;
 		}
@@ -1062,6 +1062,7 @@ xfs_rtalloc_query_range(
 /* Find all the free records. */
 int
 xfs_rtalloc_query_all(
+	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
@@ -1069,10 +1070,10 @@ xfs_rtalloc_query_all(
 	struct xfs_rtalloc_rec		keys[2];
 
 	keys[0].ar_startext = 0;
-	keys[1].ar_startext = tp->t_mountp->m_sb.sb_rextents - 1;
+	keys[1].ar_startext = mp->m_sb.sb_rextents - 1;
 	keys[0].ar_extcount = keys[1].ar_extcount = 0;
 
-	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);
+	return xfs_rtalloc_query_range(mp, tp, &keys[0], &keys[1], fn, priv);
 }
 
 /* Is the given extent all free? */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 8fa012057405..0a3bde64c675 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -40,6 +40,7 @@ xchk_setup_rt(
 /* Scrub a free extent record from the realtime bitmap. */
 STATIC int
 xchk_rtbitmap_rec(
+	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	const struct xfs_rtalloc_rec *rec,
 	void			*priv)
@@ -48,10 +49,10 @@ xchk_rtbitmap_rec(
 	xfs_rtblock_t		startblock;
 	xfs_rtblock_t		blockcount;
 
-	startblock = rec->ar_startext * tp->t_mountp->m_sb.sb_rextsize;
-	blockcount = rec->ar_extcount * tp->t_mountp->m_sb.sb_rextsize;
+	startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
+	blockcount = rec->ar_extcount * mp->m_sb.sb_rextsize;
 
-	if (!xfs_verify_rtext(sc->mp, startblock, blockcount))
+	if (!xfs_verify_rtext(mp, startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	return 0;
 }
@@ -114,7 +115,7 @@ xchk_rtbitmap(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
-	error = xfs_rtalloc_query_all(sc->tp, xchk_rtbitmap_rec, sc);
+	error = xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtbitmap_rec, sc);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 10e1cb71439e..e6677c690c1a 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -450,11 +450,11 @@ xfs_getfsmap_logdev(
 /* Transform a rtbitmap "record" into a fsmap */
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap_helper(
+	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv)
 {
-	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_getfsmap_info	*info = priv;
 	struct xfs_rmap_irec		irec;
 	xfs_daddr_t			rec_daddr;
@@ -535,7 +535,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
 	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
 		ahigh.ar_startext++;
-	error = xfs_rtalloc_query_range(tp, &alow, &ahigh,
+	error = xfs_rtalloc_query_range(tp->t_mountp, tp, &alow, &ahigh,
 			xfs_getfsmap_rtdev_rtbitmap_helper, info);
 	if (error)
 		goto err;
@@ -547,7 +547,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	info->last = true;
 	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
 
-	error = xfs_getfsmap_rtdev_rtbitmap_helper(tp, &ahigh, info);
+	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
 	if (error)
 		goto err;
 err:
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 91b00289509b..539d134f4f25 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -22,6 +22,7 @@ struct xfs_rtalloc_rec {
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(
+	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv);
@@ -123,11 +124,11 @@ int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
-int xfs_rtalloc_query_range(struct xfs_trans *tp,
+int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
 		xfs_rtalloc_query_range_fn fn, void *priv);
-int xfs_rtalloc_query_all(struct xfs_trans *tp,
+int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
@@ -140,7 +141,7 @@ int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-# define xfs_rtalloc_query_all(t,f,p)                   (ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)                 (ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
 # define xfs_verify_rtbno(m, r)			(false)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)

