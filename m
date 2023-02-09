Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49469C6379F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBIWSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjBIWSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:37 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B36F68135
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:32 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id x31so2533582pgl.6
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmJiGMf59zKUSiFmeMNKxzfafXoD4IT96SkwJkulaso=;
        b=bQyvYcph2vqGNUSyR02z9/cHEKyLBbLBnsY7PUCp9c2oNh8vNwW6pzf/vJilDdgmap
         Eq9kfVaKt6hcIUAUtUnGfFxKnS01dUymwflgSzZ5laZVkxvIiCtiL+ya00TAdXBU98Pk
         ZR4VwI4lu8oFq+LUtnqHclIRLvHur3p44OuNGsmNrmNp2HjkMXG5NBix4IotFXSv5Mpd
         h7HjDPRKT/HzSvErSND61VE844jNhO0i+NGtV9hrF9jxg3BrBIb9bE2aHuxB2HiXHJm8
         jvb16ZntZAMVZEqYbfwvkGWrU+JnliEUI8WDTJPef4Tcg0ISLCq2VCT3vu8Xh1ye8EO7
         rkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cmJiGMf59zKUSiFmeMNKxzfafXoD4IT96SkwJkulaso=;
        b=fc/zcRxcXChGf8zvoO4thVzQg7gP1dKAK63YjzJrrN0sRmUw8yPvUT3ZHhcVRKKxgi
         u1eL/oizRfUv8jO9hRBpcJHNRdZLv5r6liL9LfgsEmJo1M+9/2E51EMn26uhVfK509Yv
         3+nvJal2emqwfIC8YKWJk+1++h5Pmo+w9Ug9nLQdnrHBwoILrNvXlxXCP2Oojt3nI7Pp
         yqAcf05QDm8KD9GpEbTKSQPLJKihKYXk8hwsz4ryfKeuaX9pPIGNKXiH0/DT92/T1hn8
         ipdZvNqmJGjd707EMZ8Sp1wd7QngZnb4uWOHgHFgjF1mJSsKYCwvvAtEzqmxVByfxXbR
         F0JQ==
X-Gm-Message-State: AO0yUKWBHysFmU7UNW+9Py8mMYeBJbiiocrEXEokMtISKrrEhPQ/OMPP
        Jwdz17e0FA6oV+NNNdckHkSonbqe63jahUjx
X-Google-Smtp-Source: AK7set8fZjFPN3WdRn9RDstVZybd4v1JiPKKxvZl4m9+RSNApy3+1qFl29v8hol5fTWzGTriWkqZbg==
X-Received: by 2002:a62:4ed1:0:b0:577:272f:fdb with SMTP id c200-20020a624ed1000000b00577272f0fdbmr10253612pfb.29.1675981111677;
        Thu, 09 Feb 2023 14:18:31 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id z20-20020aa791d4000000b0058e08796e98sm1901923pfa.196.2023.02.09.14.18.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:30 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOV5-2n
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcMd-0F
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/42] xfs: convert xfs_imap() to take a perag
Date:   Fri, 10 Feb 2023 09:17:52 +1100
Message-Id: <20230209221825.3722244-10-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Callers have referenced perags but they don't pass it into
xfs_imap() so it takes it's own reference. Fix that so we can change
inode allocation over to using active references.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c | 45 ++++++++++++++------------------------
 fs/xfs/libxfs/xfs_ialloc.h |  3 ++-
 fs/xfs/scrub/common.c      | 13 +++++++----
 fs/xfs/xfs_icache.c        |  2 +-
 4 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e8068422aa21..f120a48813cc 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2217,15 +2217,15 @@ xfs_difree(
 
 STATIC int
 xfs_imap_lookup(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	xfs_agino_t		agino,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		*chunk_agbno,
 	xfs_agblock_t		*offset_agbno,
 	int			flags)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
@@ -2280,12 +2280,13 @@ xfs_imap_lookup(
  */
 int
 xfs_imap(
-	struct xfs_mount	 *mp,	/* file system mount structure */
-	struct xfs_trans	 *tp,	/* transaction pointer */
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	xfs_ino_t		ino,	/* inode to locate */
 	struct xfs_imap		*imap,	/* location map structure */
 	uint			flags)	/* flags for inode btree lookup */
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	xfs_agblock_t		agbno;	/* block number of inode in the alloc group */
 	xfs_agino_t		agino;	/* inode number within alloc group */
 	xfs_agblock_t		chunk_agbno;	/* first block in inode chunk */
@@ -2293,17 +2294,15 @@ xfs_imap(
 	int			error;	/* error code */
 	int			offset;	/* index of inode in its buffer */
 	xfs_agblock_t		offset_agbno;	/* blks from chunk start to inode */
-	struct xfs_perag	*pag;
 
 	ASSERT(ino != NULLFSINO);
 
 	/*
 	 * Split up the inode number into its parts.
 	 */
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (!pag || agbno >= mp->m_sb.sb_agblocks ||
+	if (agbno >= mp->m_sb.sb_agblocks ||
 	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 		error = -EINVAL;
 #ifdef DEBUG
@@ -2312,20 +2311,14 @@ xfs_imap(
 		 * as they can be invalid without implying corruption.
 		 */
 		if (flags & XFS_IGET_UNTRUSTED)
-			goto out_drop;
-		if (!pag) {
-			xfs_alert(mp,
-				"%s: agno (%d) >= mp->m_sb.sb_agcount (%d)",
-				__func__, XFS_INO_TO_AGNO(mp, ino),
-				mp->m_sb.sb_agcount);
-		}
+			return error;
 		if (agbno >= mp->m_sb.sb_agblocks) {
 			xfs_alert(mp,
 		"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
 				__func__, (unsigned long long)agbno,
 				(unsigned long)mp->m_sb.sb_agblocks);
 		}
-		if (pag && ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
+		if (ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 			xfs_alert(mp,
 		"%s: ino (0x%llx) != XFS_AGINO_TO_INO() (0x%llx)",
 				__func__, ino,
@@ -2333,7 +2326,7 @@ xfs_imap(
 		}
 		xfs_stack_trace();
 #endif /* DEBUG */
-		goto out_drop;
+		return error;
 	}
 
 	/*
@@ -2344,10 +2337,10 @@ xfs_imap(
 	 * in all cases where an untrusted inode number is passed.
 	 */
 	if (flags & XFS_IGET_UNTRUSTED) {
-		error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
+		error = xfs_imap_lookup(pag, tp, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
-			goto out_drop;
+			return error;
 		goto out_map;
 	}
 
@@ -2363,8 +2356,7 @@ xfs_imap(
 		imap->im_len = XFS_FSB_TO_BB(mp, 1);
 		imap->im_boffset = (unsigned short)(offset <<
 							mp->m_sb.sb_inodelog);
-		error = 0;
-		goto out_drop;
+		return 0;
 	}
 
 	/*
@@ -2376,10 +2368,10 @@ xfs_imap(
 		offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
 	} else {
-		error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
+		error = xfs_imap_lookup(pag, tp, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
-			goto out_drop;
+			return error;
 	}
 
 out_map:
@@ -2407,14 +2399,9 @@ xfs_imap(
 			__func__, (unsigned long long) imap->im_blkno,
 			(unsigned long long) imap->im_len,
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-		error = -EINVAL;
-		goto out_drop;
+		return -EINVAL;
 	}
-	error = 0;
-out_drop:
-	if (pag)
-		xfs_perag_put(pag);
-	return error;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 9bbbca6ac4ed..4cfce2eebe7e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -12,6 +12,7 @@ struct xfs_imap;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_btree_cur;
+struct xfs_perag;
 
 /* Move inodes in clusters of this size */
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
@@ -47,7 +48,7 @@ int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
  */
 int
 xfs_imap(
-	struct xfs_mount *mp,		/* file system mount structure */
+	struct xfs_perag *pag,
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	ino,		/* inode to locate */
 	struct xfs_imap	*imap,		/* location map structure */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 613260b04a3d..033bf6730ece 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -636,6 +636,7 @@ xchk_get_inode(
 {
 	struct xfs_imap		imap;
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag;
 	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->file));
 	struct xfs_inode	*ip = NULL;
 	int			error;
@@ -671,10 +672,14 @@ xchk_get_inode(
 		 * Otherwise, we really couldn't find it so tell userspace
 		 * that it no longer exists.
 		 */
-		error = xfs_imap(sc->mp, sc->tp, sc->sm->sm_ino, &imap,
-				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE);
-		if (error)
-			return -ENOENT;
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, sc->sm->sm_ino));
+		if (pag) {
+			error = xfs_imap(pag, sc->tp, sc->sm->sm_ino, &imap,
+					XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE);
+			xfs_perag_put(pag);
+			if (error)
+				return -ENOENT;
+		}
 		error = -EFSCORRUPTED;
 		fallthrough;
 	default:
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8b2823d85a68..c9a7e270a428 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -586,7 +586,7 @@ xfs_iget_cache_miss(
 	if (!ip)
 		return -ENOMEM;
 
-	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, flags);
+	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, flags);
 	if (error)
 		goto out_destroy;
 
-- 
2.39.0

