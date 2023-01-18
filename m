Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB35C38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjARWs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjARWs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:27 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515CA5356D
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:26 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so56468pjb.4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oLtq/pkkHxJ61NS55A+sOQQ4qC0oC9hGVcJnVKTyry8=;
        b=QsxOjoGIofcFSljZafd0I7w+uZC781lgsRJ1VwIXudd1IKhFTpU6dbi/qGo6smUIHj
         GCZcw0fx9P86LzvCMxYWoLCB5P3piDahvMFGRZNjf/mZ1rLB9J59D13ltP39iLhxE64w
         KZmQWlh6s4Po8tYoz36yB1CqeCDfuKtOfFigX6gXV1Cwkf447pdJTeGKM31gsCGQxnhF
         bRD0SQpxEn682WOaHRkFCgxSdRL6r1LRiTkP1p9Rj6duZTmz2CfRDuZxErIlraGsPkOg
         LvoJ6e3T5YFWeiYsfW7T6Ua2cbd72x8v4yTrjIBh267RpWTeBoZMtz9ZvSWCcjsF738/
         i6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLtq/pkkHxJ61NS55A+sOQQ4qC0oC9hGVcJnVKTyry8=;
        b=W92FnBdTecfKiHuvpviBIipbIdTwUBi69QYcuvQt6S/BQ1JNuXXtbytU31UX0C7p7o
         a81VTkR09pB03zvrssdDUvbtz3JokUT1CgFX00gFUjeh3avNoWfiAIza75bIkl+xT5TW
         WBjqsBLMLw9dZS7ZMeUPJ3jBbbqN5myGxIhudweRaFG3NMPCNIC3jdRqmcbnxZQVDKhT
         kOu/OcMAENKVIM3izowCNHF85fgzP0JHbWWxbBd2avb7Kzw6+l4iPoRGfsDQISsSAunb
         T1q7fA3caBk1KlZfCl8oXehEiSA9s3eOrd5XuOYMtxjqAda69YQYLoGjKlktsSCWjZTJ
         Aqsg==
X-Gm-Message-State: AFqh2kpNZFzDdTtBc9u527XkO+RfJZUMSgptTf6LASvB3B+tlEfzVo4S
        ZqBSExYpgjqeBlfn/raKY1EJDrv3qpWPPp+7
X-Google-Smtp-Source: AMrXdXsfAkc0TLum429J6qSKfNv8wkihUmp8WiIjIXp4D8M8AF0dRbxfSGw/maHK03czAoRa+jPJag==
X-Received: by 2002:a17:902:834c:b0:194:bea4:57d2 with SMTP id z12-20020a170902834c00b00194bea457d2mr2892718pln.46.1674082105656;
        Wed, 18 Jan 2023 14:48:25 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709026e0200b001948d2ef5b4sm7222652plk.75.2023.01.18.14.48.24
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:48:25 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYc-Vy
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:12 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFt-3C
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 42/42] xfs: refactor the filestreams allocator pick functions
Date:   Thu, 19 Jan 2023 09:45:05 +1100
Message-Id: <20230118224505.1964941-43-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
 fs/xfs/xfs_filestream.c | 247 +++++++++++++++++++++-------------------
 fs/xfs/xfs_trace.h      |   9 +-
 2 files changed, 132 insertions(+), 124 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 523a3b8b5754..0a1d316ebdba 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -48,19 +48,19 @@ xfs_fstrm_free_func(
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
@@ -68,8 +68,6 @@ xfs_filestream_pick_ag(
 	xfs_agnumber_t		agno;
 	int			err, trylock;
 
-	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
-
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
@@ -78,7 +76,7 @@ xfs_filestream_pick_ag(
 
 restart:
 	for_each_perag_wrap(mp, start_agno, agno, pag) {
-		trace_xfs_filestream_scan(pag, ip->i_ino);
+		trace_xfs_filestream_scan(pag, pino);
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
@@ -148,9 +146,9 @@ xfs_filestream_pick_ag(
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
@@ -161,44 +159,10 @@ xfs_filestream_pick_ag(
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
@@ -227,29 +191,29 @@ xfs_filestream_get_parent(
 
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
@@ -265,103 +229,148 @@ xfs_filestream_select_ag_mru(
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
-		xfs_fstrm_free_func(mp, mru);
-		return 0;
-	}
 
-out_default_agno:
-	if (xfs_is_inode32(mp)) {
+		agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
+		xfs_fstrm_free_func(mp, mru);
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
+
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
+	xfs_bmap_adjacent(ap);
+
+	if (ap->datatype & XFS_ALLOC_USERDATA)
+		flags |= XFS_PICK_USERDATA;
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
+		flags |= XFS_PICK_LOWSPACE;
+
+	*longest = ap->length;
+	error = xfs_filestream_pick_ag(args, pino, agno, flags, longest);
+	if (error)
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
 	return 0;
 
+out_free_item:
+	xfs_perag_rele(item->pag);
+	kmem_free(item);
+out_put_fstrms:
+	atomic_dec(&args->pag->pagf_fstrms);
+	return 0;
 }
 
 /*
  * Search for an allocation group with a single extent large enough for
- * the request.  If one isn't found, then adjust the minimum allocation
- * size to the largest space found.
+ * the request. First we look for an existing association and use that if it
+ * is found. Otherwise, we create a new association by selecting an AG that fits
+ * the allocation criteria.
+ *
+ * We return with a referenced perag in args->pag to indicate which AG we are
+ * allocating into or an error with no references held.
  */
 int
 xfs_filestream_select_ag(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen)
+	xfs_extlen_t		*longest)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_inode	*pip = NULL;
-	xfs_agnumber_t		agno;
-	int			flags = 0;
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_inode	*pip;
+	xfs_ino_t		ino = 0;
 	int			error = 0;
 
+	*longest = 0;
 	args->total = ap->total;
-	*blen = 0;
-
 	pip = xfs_filestream_get_parent(ap->ip);
-	if (!pip) {
-		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
-		return 0;
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
 	}
 
-	error = xfs_filestream_select_ag_mru(ap, args, pip, &agno, blen);
+	error = xfs_filestream_create_association(ap, args, ino, longest);
 	if (error)
-		goto out_rele;
-	if (*blen >= args->maxlen)
-		goto out_select;
-	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
-		goto out_select;
-
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
-	xfs_bmap_adjacent(ap);
-	*blen = ap->length;
-	if (ap->datatype & XFS_ALLOC_USERDATA)
-		flags |= XFS_PICK_USERDATA;
-	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
-		flags |= XFS_PICK_LOWSPACE;
+		return error;
 
-	error = xfs_filestream_pick_ag(args, pip, agno, flags, blen);
-	if (error)
-		goto out_rele;
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
index b5f7d225d5b4..1d3569c0d2fe 100644
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

