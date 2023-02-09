Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5911C636D6
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBIWSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjBIWSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:38 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442616BA9A
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:36 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id pj3so3441997pjb.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wSUMj+sTbQjMkxLxQgiFmg3RdnrmoekLCZOWZZbfbVU=;
        b=rSbaI1C+OqU56c8S3m3zEuVO6UVbPuMCoJsGI4qaGpYYgMClw2y0nRclJVAglQ1jQv
         jBKuocMOWU4oRECzHFui0+ydgX8obed7v1JnVbZnO1fgxfQzIbmO8SUbh5cQv8yzkD8p
         uNcVpbg8k4ac0LRtvEIIofxXN7gAkcwjccBfAOGIOPQmPqfaFsu1YiY0ETTd27Xs0WPV
         Fmstml9NRe3bjXL8VJUuf6mG+NLbbUn2Ipr8Ah+30ZZvj/EyIoZzB93JKE1ibUiWNhs2
         q1SLpC68mW4cv34dP4Rzh4YyRob7uUiHgbaRsufKTlINNFMkWjCzdrUjbB6v2QM82EBk
         FJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSUMj+sTbQjMkxLxQgiFmg3RdnrmoekLCZOWZZbfbVU=;
        b=bX+jfHfYJR6aETaOXmYJiHy57XCCsSlacJrBx67kyNHk1rs4hVzEL2hugAmloWAf52
         2Cy2QklAnILbWjqAtmyHucJNKWgiXKBuyt+US2TKrgl2NO1eKAIhbAonGjjpV7vNhsvo
         Q2YG2oQseKUjbWMyesplBmQTkU0/44+17ATPfW6t6tJIVCEFF60XpiFmmD1m1NCioR4a
         JinLgExmUMarWOufUNuLbxOa5rQye9duHnP0zY2RAa65JspuKIXUYhlgIQsJ+Vh79DRN
         2+5bNmqWVs4v3BCgbTKdFIbLNgDKu1PN2tYtDhUk73WLlILEopmOjnqWphjhf54IP7F/
         5S1w==
X-Gm-Message-State: AO0yUKUtctlRr305NpEfK/rSuBExoYH0QyCn9ohA+rxEu/ONXnB/HgMm
        0F9U0qBokmoJO/sEK2o2WMFMBGR7zj2Pgqvb
X-Google-Smtp-Source: AK7set8yrC0HW+H3md52ufplVelw+BSm/6q9Vb3Tn+jCqRLxJqmAusQaFiteII18fRNloxGywshE+w==
X-Received: by 2002:a17:903:4091:b0:19a:688c:6ad5 with SMTP id z17-20020a170903409100b0019a688c6ad5mr1857805plc.29.1675981115646;
        Thu, 09 Feb 2023 14:18:35 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id 1-20020a170902ee4100b0019896d29197sm2011602plo.46.2023.02.09.14.18.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:32 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFN-00DOWe-1P
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:29 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFN-00FcPI-06
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 42/42] xfs: refactor the filestreams allocator pick functions
Date:   Fri, 10 Feb 2023 09:18:25 +1100
Message-Id: <20230209221825.3722244-43-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the filestreams allocator is largely rewritten,
restructure the main entry point and pick function to seperate out
the different operations cleanly. The MRU lookup function should not
handle the start AG selection on MRU lookup failure, and nor should
the pick function handle building the association that is inserted
into the MRU.

This leaves the filestreams allocator fairly clean and easy to
understand, returning to the caller with an active perag reference
and a target block to allocate at.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 290 +++++++++++++++++++++-------------------
 fs/xfs/xfs_trace.h      |   9 +-
 2 files changed, 156 insertions(+), 143 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 523a3b8b5754..22c13933c8f8 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -48,37 +48,33 @@ xfs_fstrm_free_func(
 }
 
 /*
- * Scan the AGs starting at startag looking for an AG that isn't in use and has
- * at least minlen blocks free.
+ * Scan the AGs starting at start_agno looking for an AG that isn't in use and
+ * has at least minlen blocks free. If no AG is found to match the allocation
+ * requirements, pick the AG with the most free space in it.
  */
 static int
 xfs_filestream_pick_ag(
 	struct xfs_alloc_arg	*args,
-	struct xfs_inode	*ip,
+	xfs_ino_t		pino,
 	xfs_agnumber_t		start_agno,
 	int			flags,
 	xfs_extlen_t		*longest)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_fstrm_item	*item;
+	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
 	xfs_extlen_t		free = 0, minfree, maxfree = 0;
 	xfs_agnumber_t		agno;
-	int			err, trylock;
-
-	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
+	bool			first_pass = true;
+	int			err;
 
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
-	/* For the first pass, don't sleep trying to init the per-AG. */
-	trylock = XFS_ALLOC_FLAG_TRYLOCK;
-
 restart:
 	for_each_perag_wrap(mp, start_agno, agno, pag) {
-		trace_xfs_filestream_scan(pag, ip->i_ino);
+		trace_xfs_filestream_scan(pag, pino);
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
@@ -129,13 +125,20 @@ xfs_filestream_pick_ag(
 	}
 
 	if (!pag) {
-		/* Allow sleeping in xfs_alloc_read_agf() on the 2nd pass. */
-		if (trylock) {
-			trylock = 0;
+		/*
+		 * Allow a second pass to give xfs_bmap_longest_free_extent()
+		 * another attempt at locking AGFs that it might have skipped
+		 * over before we fail.
+		 */
+		if (first_pass) {
+			first_pass = false;
 			goto restart;
 		}
 
-		/* Finally, if lowspace wasn't set, set it for the 3rd pass. */
+		/*
+		 * We must be low on data space, so run a final lowspace
+		 * optimised selection pass if we haven't already.
+		 */
 		if (!(flags & XFS_PICK_LOWSPACE)) {
 			flags |= XFS_PICK_LOWSPACE;
 			goto restart;
@@ -148,9 +151,9 @@ xfs_filestream_pick_ag(
 		 * grab.
 		 */
 		if (!max_pag) {
-			for_each_perag_wrap(mp, start_agno, agno, pag)
+			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
 				break;
-			atomic_inc(&pag->pagf_fstrms);
+			atomic_inc(&args->pag->pagf_fstrms);
 			*longest = 0;
 		} else {
 			pag = max_pag;
@@ -161,44 +164,10 @@ xfs_filestream_pick_ag(
 		xfs_perag_rele(max_pag);
 	}
 
-	trace_xfs_filestream_pick(ip, pag, free);
-
-	err = -ENOMEM;
-	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
-	if (!item)
-		goto out_put_ag;
-
-
-	/*
-	 * We are going to use this perag now, so take another ref to it for the
-	 * allocation context returned to the caller. If we raced to create and
-	 * insert the filestreams item into the MRU (-EEXIST), then we still
-	 * keep this reference but free the item reference we gained above. On
-	 * any other failure, we have to drop both.
-	 */
-	atomic_inc(&pag->pag_active_ref);
-	item->pag = pag;
+	trace_xfs_filestream_pick(pag, pino, free);
 	args->pag = pag;
-
-	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
-	if (err) {
-		if (err == -EEXIST) {
-			err = 0;
-		} else {
-			xfs_perag_rele(args->pag);
-			args->pag = NULL;
-		}
-		goto out_free_item;
-	}
-
 	return 0;
 
-out_free_item:
-	kmem_free(item);
-out_put_ag:
-	atomic_dec(&pag->pagf_fstrms);
-	xfs_perag_rele(pag);
-	return err;
 }
 
 static struct xfs_inode *
@@ -227,29 +196,29 @@ xfs_filestream_get_parent(
 
 /*
  * Lookup the mru cache for an existing association. If one exists and we can
- * use it, return with the agno and blen indicating that the allocation will
- * proceed with that association.
+ * use it, return with an active perag reference indicating that the allocation
+ * will proceed with that association.
  *
  * If we have no association, or we cannot use the current one and have to
- * destroy it, return with blen = 0 and agno pointing at the next agno to try.
+ * destroy it, return with longest = 0 to tell the caller to create a new
+ * association.
  */
-int
-xfs_filestream_select_ag_mru(
+static int
+xfs_filestream_lookup_association(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
-	struct xfs_inode	*pip,
-	xfs_agnumber_t		*agno,
-	xfs_extlen_t		*blen)
+	xfs_ino_t		pino,
+	xfs_extlen_t		*longest)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	struct xfs_mru_cache_elem *mru;
-	int			error;
+	int			error = 0;
 
-	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	*longest = 0;
+	mru = xfs_mru_cache_lookup(mp->m_filestream, pino);
 	if (!mru)
-		goto out_default_agno;
-
+		return 0;
 	/*
 	 * Grab the pag and take an extra active reference for the caller whilst
 	 * the mru item cannot go away. This means we'll pin the perag with
@@ -265,103 +234,148 @@ xfs_filestream_select_ag_mru(
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
 	xfs_bmap_adjacent(ap);
 
-	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-	if (error) {
-		/* We aren't going to use this perag */
-		xfs_perag_rele(pag);
-		if (error != -EAGAIN)
-			return error;
-		*blen = 0;
-	}
-
 	/*
-	 * We are done if there's still enough contiguous free space to succeed.
 	 * If there is very little free space before we start a filestreams
-	 * allocation, we're almost guaranteed to fail to find a better AG with
-	 * larger free space available so we don't even try.
+	 * allocation, we're almost guaranteed to fail to find a large enough
+	 * free space available so just use the cached AG.
 	 */
-	*agno = pag->pag_agno;
-	if (*blen >= args->maxlen || (ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
-		args->pag = pag;
-		return 0;
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
+		*longest = 1;
+		goto out_done;
 	}
 
+	error = xfs_bmap_longest_free_extent(pag, args->tp, longest);
+	if (error == -EAGAIN)
+		error = 0;
+	if (error || *longest < args->maxlen) {
+		/* We aren't going to use this perag */
+		*longest = 0;
+		xfs_perag_rele(pag);
+		return error;
+	}
+
+out_done:
+	args->pag = pag;
+	return 0;
+}
+
+static int
+xfs_filestream_create_association(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_ino_t		pino,
+	xfs_extlen_t		*longest)
+{
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_mru_cache_elem *mru;
+	struct xfs_fstrm_item	*item;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, pino);
+	int			flags = 0;
+	int			error;
+
 	/* Changing parent AG association now, so remove the existing one. */
-	xfs_perag_rele(pag);
-	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
+	mru = xfs_mru_cache_remove(mp->m_filestream, pino);
 	if (mru) {
 		struct xfs_fstrm_item *item =
 			container_of(mru, struct xfs_fstrm_item, mru);
-		*agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
+
+		agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
 		xfs_fstrm_free_func(mp, mru);
-		return 0;
-	}
-
-out_default_agno:
-	if (xfs_is_inode32(mp)) {
+	} else if (xfs_is_inode32(mp)) {
 		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
-		*agno = (mp->m_agfrotor / rotorstep) %
-				mp->m_sb.sb_agcount;
+
+		agno = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
 				 (mp->m_sb.sb_agcount * rotorstep);
-		return 0;
 	}
-	*agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
-	return 0;
-
-}
-
-/*
- * Search for an allocation group with a single extent large enough for
- * the request.  If one isn't found, then adjust the minimum allocation
- * size to the largest space found.
- */
-int
-xfs_filestream_select_ag(
-	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen)
-{
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_inode	*pip = NULL;
-	xfs_agnumber_t		agno;
-	int			flags = 0;
-	int			error = 0;
-
-	args->total = ap->total;
-	*blen = 0;
-
-	pip = xfs_filestream_get_parent(ap->ip);
-	if (!pip) {
-		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
-		return 0;
-	}
-
-	error = xfs_filestream_select_ag_mru(ap, args, pip, &agno, blen);
-	if (error)
-		goto out_rele;
-	if (*blen >= args->maxlen)
-		goto out_select;
-	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
-		goto out_select;
 
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
 	xfs_bmap_adjacent(ap);
-	*blen = ap->length;
+
 	if (ap->datatype & XFS_ALLOC_USERDATA)
 		flags |= XFS_PICK_USERDATA;
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
 		flags |= XFS_PICK_LOWSPACE;
 
-	error = xfs_filestream_pick_ag(args, pip, agno, flags, blen);
+	*longest = ap->length;
+	error = xfs_filestream_pick_ag(args, pino, agno, flags, longest);
 	if (error)
-		goto out_rele;
+		return error;
+
+	/*
+	 * We are going to use this perag now, so create an assoication for it.
+	 * xfs_filestream_pick_ag() has already bumped the perag fstrms counter
+	 * for us, so all we need to do here is take another active reference to
+	 * the perag for the cached association.
+	 *
+	 * If we fail to store the association, we need to drop the fstrms
+	 * counter as well as drop the perag reference we take here for the
+	 * item. We do not need to return an error for this failure - as long as
+	 * we return a referenced AG, the allocation can still go ahead just
+	 * fine.
+	 */
+	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
+	if (!item)
+		goto out_put_fstrms;
+
+	atomic_inc(&args->pag->pag_active_ref);
+	item->pag = args->pag;
+	error = xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
+	if (error)
+		goto out_free_item;
+	return 0;
+
+out_free_item:
+	xfs_perag_rele(item->pag);
+	kmem_free(item);
+out_put_fstrms:
+	atomic_dec(&args->pag->pagf_fstrms);
+	return 0;
+}
+
+/*
+ * Search for an allocation group with a single extent large enough for
+ * the request. First we look for an existing association and use that if it
+ * is found. Otherwise, we create a new association by selecting an AG that fits
+ * the allocation criteria.
+ *
+ * We return with a referenced perag in args->pag to indicate which AG we are
+ * allocating into or an error with no references held.
+ */
+int
+xfs_filestream_select_ag(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*longest)
+{
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_inode	*pip;
+	xfs_ino_t		ino = 0;
+	int			error = 0;
+
+	*longest = 0;
+	args->total = ap->total;
+	pip = xfs_filestream_get_parent(ap->ip);
+	if (pip) {
+		ino = pip->i_ino;
+		error = xfs_filestream_lookup_association(ap, args, ino,
+				longest);
+		xfs_irele(pip);
+		if (error)
+			return error;
+		if (*longest >= args->maxlen)
+			goto out_select;
+		if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
+			goto out_select;
+	}
+
+	error = xfs_filestream_create_association(ap, args, ino, longest);
+	if (error)
+		return error;
+
 out_select:
 	ap->blkno = XFS_AGB_TO_FSB(mp, args->pag->pag_agno, 0);
-out_rele:
-	xfs_irele(pip);
-	return error;
-
+	return 0;
 }
 
 void
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 107bc8692f23..7dc0fd6a6504 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -668,9 +668,8 @@ DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
 
 TRACE_EVENT(xfs_filestream_pick,
-	TP_PROTO(struct xfs_inode *ip, struct xfs_perag *pag,
-		 xfs_extlen_t free),
-	TP_ARGS(ip, pag, free),
+	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino, xfs_extlen_t free),
+	TP_ARGS(pag, ino, free),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -679,8 +678,8 @@ TRACE_EVENT(xfs_filestream_pick,
 		__field(xfs_extlen_t, free)
 	),
 	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->ino = ino;
 		if (pag) {
 			__entry->agno = pag->pag_agno;
 			__entry->streams = atomic_read(&pag->pagf_fstrms);
-- 
2.39.0

