Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6714FC32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjARWpc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjARWpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:18 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485195F3BA
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 20so582669plo.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qKgQDo/9MVsL9yPc8K2YMQ5ETmZey0VVyTWNCZQ+Keo=;
        b=3tFFkINLcMnk+3I365mA761KjQTTW8QVbQAxQ+gZBMzLJ8/WZr7n4Fmtl4MmQxR0Lk
         3mRZ11dkx5fclwoHS8+Jo39xstUPvpHJCmsML+Oe6Ht8zLKzC5kqjHvZQbvxhLWQY3ts
         Aj/NjMTtf2s5ABvqRsQ1ojFPp/0dSAJRjIf2mLMJIL2qfeMLhaGASDvxmw73RDZKs806
         NwnMDaodXfrrswl7lWAcsszyVJXLjOKVp8XT2HkWrWwwrLQ/6cvcoBnr2LGAPOdeR0Fo
         gDuMJUjm0q9bmDIicwK54Fbh5LjL9fRwiFLxz/OjhlVjjhCSWXacKjQQT3X9IejvmbZ6
         qhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKgQDo/9MVsL9yPc8K2YMQ5ETmZey0VVyTWNCZQ+Keo=;
        b=8NZD9Xrc44FO+lXBR2MgwD2VWnD1TYqxnvhBjts1kcQTb8DYm9C0SCZzahWx6K3iFt
         A97uTDLaajbirsyeocQEt8lBWxu5eqC1kQHD2B5H3mijkC8seSCnRXIxRxb1fup6bYN9
         aZdnPTkObCyM7J/J7vNhGM6gQ+Vqqqk2Jiztkk1jndzRJQ8vJadkxQezw6LWLMQeaROp
         IJYo/EyEi1n1Bi58Mm7UzESlRKxXdZKRm+l708OwEBZ1kaFg2CO/gE0EYMfrcgN4jw5C
         NoGp697ub8C67jZc0wvOKy32fRpu5BwwCs1uqjSlkzB2CfI4Z6XLmH9xOSzho1QpDd4s
         cWpA==
X-Gm-Message-State: AFqh2ko5PGXW9HL2jAPHmL6Vf54lQdNi6i56TeDCu5ToW3YANYALvKsF
        q/eSGqE/w0n7hx9f1Vur7q0sc3OqKjDVJzt+
X-Google-Smtp-Source: AMrXdXvO0ufQoMMbI7zYib//fF7fbyrtMBEhBAH45sM2Ro4d05+fgn4kjkryxPAgSHcf2X2WVFpQ1Q==
X-Received: by 2002:a17:90b:3d0c:b0:229:4fc8:54eb with SMTP id pt12-20020a17090b3d0c00b002294fc854ebmr9184609pjb.19.1674081916731;
        Wed, 18 Jan 2023 14:45:16 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id e15-20020a17090a684f00b00223ed94759csm1784175pjm.39.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXG-6A
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FDd-0c
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/42] xfs: introduce xfs_for_each_perag_wrap()
Date:   Thu, 19 Jan 2023 09:44:37 +1100
Message-Id: <20230118224505.1964941-15-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In several places we iterate every AG from a specific start agno and
wrap back to the first AG when we reach the end of the filesystem to
continue searching. We don't have a primitive for this iteration
yet, so add one for conversion of these algorithms to per-ag based
iteration.

The filestream AG select code is a mess, and this initially makes it
worse. The per-ag selection needs to be driven completely into the
filestream code to clean this up and it will be done in a future
patch that makes the filestream allocator use active per-ag
references correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h     | 45 +++++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.c   | 76 ++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_ialloc.c | 32 ++++++++--------
 3 files changed, 104 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 187d30d9bb13..8f43b91d4cf3 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -237,7 +237,6 @@ xfs_perag_next(
 #define for_each_perag_from(mp, agno, pag) \
 	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
-
 #define for_each_perag(mp, agno, pag) \
 	(agno) = 0; \
 	for_each_perag_from((mp), (agno), (pag))
@@ -249,6 +248,50 @@ xfs_perag_next(
 		xfs_perag_rele(pag), \
 		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
 
+static inline struct xfs_perag *
+xfs_perag_next_wrap(
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		*agno,
+	xfs_agnumber_t		stop_agno,
+	xfs_agnumber_t		wrap_agno)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	*agno = pag->pag_agno + 1;
+	xfs_perag_rele(pag);
+	while (*agno != stop_agno) {
+		if (*agno >= wrap_agno)
+			*agno = 0;
+		if (*agno == stop_agno)
+			break;
+
+		pag = xfs_perag_grab(mp, *agno);
+		if (pag)
+			return pag;
+		(*agno)++;
+	}
+	return NULL;
+}
+
+/*
+ * Iterate all AGs from start_agno through wrap_agno, then 0 through
+ * (start_agno - 1).
+ */
+#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
+	for ((agno) = (start_agno), (pag) = xfs_perag_grab((mp), (agno)); \
+		(pag) != NULL; \
+		(pag) = xfs_perag_next_wrap((pag), &(agno), (start_agno), \
+				(wrap_agno)))
+
+/*
+ * Iterate all AGs from start_agno through to the end of the filesystem, then 0
+ * through (start_agno - 1).
+ */
+#define for_each_perag_wrap(mp, start_agno, agno, pag) \
+	for_each_perag_wrap_at((mp), (start_agno), (mp)->m_sb.sb_agcount, \
+				(agno), (pag))
+
+
 struct aghdr_init_data {
 	/* per ag data */
 	xfs_agblock_t		agno;		/* ag to init */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6aad0ea5e606..e5519abbfa0d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3136,17 +3136,14 @@ xfs_bmap_adjacent(
 
 static int
 xfs_bmap_longest_free_extent(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		ag,
 	xfs_extlen_t		*blen,
 	int			*notinit)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
 	xfs_extlen_t		longest;
 	int			error = 0;
 
-	pag = xfs_perag_get(mp, ag);
 	if (!xfs_perag_initialised_agf(pag)) {
 		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_TRYLOCK,
 				NULL);
@@ -3156,19 +3153,17 @@ xfs_bmap_longest_free_extent(
 				*notinit = 1;
 				error = 0;
 			}
-			goto out;
+			return error;
 		}
 	}
 
 	longest = xfs_alloc_longest_free_extent(pag,
-				xfs_alloc_min_freelist(mp, pag),
+				xfs_alloc_min_freelist(pag->pag_mount, pag),
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
 		*blen = longest;
 
-out:
-	xfs_perag_put(pag);
-	return error;
+	return 0;
 }
 
 static void
@@ -3206,9 +3201,10 @@ xfs_bmap_btalloc_select_lengths(
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
-	xfs_agnumber_t		ag, startag;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno, startag;
 	int			notinit = 0;
-	int			error;
+	int			error = 0;
 
 	args->type = XFS_ALLOCTYPE_START_BNO;
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
@@ -3218,21 +3214,21 @@ xfs_bmap_btalloc_select_lengths(
 	}
 
 	args->total = ap->total;
-	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
 	if (startag == NULLAGNUMBER)
-		startag = ag = 0;
+		startag = 0;
 
-	while (*blen < args->maxlen) {
-		error = xfs_bmap_longest_free_extent(args->tp, ag, blen,
+	*blen = 0;
+	for_each_perag_wrap(mp, startag, agno, pag) {
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
 						     &notinit);
 		if (error)
-			return error;
-
-		if (++ag == mp->m_sb.sb_agcount)
-			ag = 0;
-		if (ag == startag)
+			break;
+		if (*blen >= args->maxlen)
 			break;
 	}
+	if (pag)
+		xfs_perag_rele(pag);
 
 	xfs_bmap_select_minlen(ap, args, blen, notinit);
 	return 0;
@@ -3245,7 +3241,8 @@ xfs_bmap_btalloc_filestreams(
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
-	xfs_agnumber_t		ag;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		start_agno;
 	int			notinit = 0;
 	int			error;
 
@@ -3259,33 +3256,50 @@ xfs_bmap_btalloc_filestreams(
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 
-	ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
-	if (ag == NULLAGNUMBER)
-		ag = 0;
+	start_agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	if (start_agno == NULLAGNUMBER)
+		start_agno = 0;
 
-	error = xfs_bmap_longest_free_extent(args->tp, ag, blen, &notinit);
-	if (error)
-		return error;
+	pag = xfs_perag_grab(mp, start_agno);
+	if (pag) {
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
+				&notinit);
+		xfs_perag_rele(pag);
+		if (error)
+			return error;
+	}
 
 	if (*blen < args->maxlen) {
-		error = xfs_filestream_new_ag(ap, &ag);
+		xfs_agnumber_t	agno = start_agno;
+
+		error = xfs_filestream_new_ag(ap, &agno);
 		if (error)
 			return error;
+		if (agno == NULLAGNUMBER)
+			goto out_select;
 
-		error = xfs_bmap_longest_free_extent(args->tp, ag, blen,
-						     &notinit);
+		pag = xfs_perag_grab(mp, agno);
+		if (!pag)
+			goto out_select;
+
+		error = xfs_bmap_longest_free_extent(pag, args->tp,
+				blen, &notinit);
+		xfs_perag_rele(pag);
 		if (error)
 			return error;
 
+		start_agno = agno;
+
 	}
 
+out_select:
 	xfs_bmap_select_minlen(ap, args, blen, notinit);
 
 	/*
 	 * Set the failure fallback case to look in the selected AG as stream
 	 * may have moved.
 	 */
-	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, start_agno, 0);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2a323ffa5ba9..50fef3f5af51 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1725,7 +1725,7 @@ xfs_dialloc(
 	bool			ok_alloc = true;
 	bool			low_space = false;
 	int			flags;
-	xfs_ino_t		ino;
+	xfs_ino_t		ino = NULLFSINO;
 
 	/*
 	 * Directories, symlinks, and regular files frequently allocate at least
@@ -1773,39 +1773,37 @@ xfs_dialloc(
 	 * or in which we can allocate some inodes.  Iterate through the
 	 * allocation groups upward, wrapping at the end.
 	 */
-	agno = start_agno;
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
-	for (;;) {
-		pag = xfs_perag_grab(mp, agno);
+retry:
+	for_each_perag_wrap_at(mp, start_agno, mp->m_maxagi, agno, pag) {
 		if (xfs_dialloc_good_ag(pag, *tpp, mode, flags, ok_alloc)) {
 			error = xfs_dialloc_try_ag(pag, tpp, parent,
 					&ino, ok_alloc);
 			if (error != -EAGAIN)
 				break;
+			error = 0;
 		}
 
 		if (xfs_is_shutdown(mp)) {
 			error = -EFSCORRUPTED;
 			break;
 		}
-		if (++agno == mp->m_maxagi)
-			agno = 0;
-		if (agno == start_agno) {
-			if (!flags) {
-				error = -ENOSPC;
-				break;
-			}
+	}
+	if (pag)
+		xfs_perag_rele(pag);
+	if (error)
+		return error;
+	if (ino == NULLFSINO) {
+		if (flags) {
 			flags = 0;
 			if (low_space)
 				ok_alloc = true;
+			goto retry;
 		}
-		xfs_perag_rele(pag);
+		return -ENOSPC;
 	}
-
-	if (!error)
-		*new_ino = ino;
-	xfs_perag_rele(pag);
-	return error;
+	*new_ino = ino;
+	return 0;
 }
 
 /*
-- 
2.39.0

