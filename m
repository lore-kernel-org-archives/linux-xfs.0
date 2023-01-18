Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA18C46467
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjARWpW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjARWpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:15 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE0C5F395
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k13so625778plg.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5T1bfDsbGdhVMB2lsfgPkUTh9GCy7S6mNQWMFcU6DDs=;
        b=yCvOs/+WVbT3ifvE9WYBwnHPmoXBnQz5DeNQzrhBYy5uY5kt0bqgNDQKM08fbzeNSX
         kJil7TuTW+QNZL0eSjb8AkVBXsvHBoNqvNa3ffkcemVkYOf/2POLg2NiZBq/a4wSq3UV
         l8hVg0itsDQpAovtFcLdxdYdAr3hzpbl+qG6vEx38ifv53fl7N2uLn5HKQQfBiymd3fC
         h7ThPYOrm6vO9MmfwPT6K7LzR9ucpGTPGYk6fLZZKJyX+M1qa4Z/W/uzM/0s/vVxE1Vf
         EC7Heb6EZEBXTISbUaipPgQIBn5TtvJV3Kvvem3qvGU8hEva0FA8u27KZTXN3uMeVfsh
         oxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5T1bfDsbGdhVMB2lsfgPkUTh9GCy7S6mNQWMFcU6DDs=;
        b=Mg3dKsWH1Dp7eQNcQIcBcMQX3fZbrvG8TFLWnnhWyw42UC5i32RIAzyynayLoreDvd
         5y3J+PRguN6QGIqm9GPA8GsoX3iEM6DZ+V5MpPilSVxOPn40dgceeE7yVbnKIrP+X4ro
         Qy8yZTo0kuPRt/ns3ENBLSB4lW6zvbz1pHyiUMk4fD3Sz+ECokebYeNPdcX/S06Rvjld
         hwAo43EQ0AauxDMoBtbHbQcxAgqmqK8QAwfXxuZyBydZvEL9RbKi9EBh47GvPQRnOAbe
         ycQQOYQ2aQvLx1g31WfetnshI1Oso8GaZPbcO9cNFl+35/FQPfDnvpt40/HU5JXke0ug
         xY7A==
X-Gm-Message-State: AFqh2kqItbAuaCdx+/nEbBzHWxx3MqIRgi0JpeOFggcdYvLhezk7iR+B
        tzB1XUssqtBz/NsXpZXMcDkHgW3sCUYY3Hje
X-Google-Smtp-Source: AMrXdXst/sUiPujZc0lU4XBoKNEkstrTOm3kWVFoKSa6vIJ/ZjQ8YdJpQBXqMU+vesY3rK5Izpt6EQ==
X-Received: by 2002:a05:6a20:9585:b0:9d:efbe:52ae with SMTP id iu5-20020a056a20958500b0009defbe52aemr9258340pzb.30.1674081913730;
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id z7-20020a17090a540700b002290be2732fsm1797333pjh.44.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iX1-1X
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FDE-0A
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/42] xfs: convert xfs_imap() to take a perag
Date:   Thu, 19 Jan 2023 09:44:32 +1100
Message-Id: <20230118224505.1964941-10-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
---
 fs/xfs/libxfs/xfs_ialloc.c | 43 +++++++++++++-------------------------
 fs/xfs/libxfs/xfs_ialloc.h |  3 ++-
 fs/xfs/scrub/common.c      | 13 ++++++++----
 fs/xfs/xfs_icache.c        |  2 +-
 4 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e8068422aa21..2b4961ff2e24 100644
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
+	struct xfs_perag	*pag,
 	struct xfs_trans	 *tp,	/* transaction pointer */
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

