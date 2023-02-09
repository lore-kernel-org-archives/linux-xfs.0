Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAAFC636D6
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjBIW0f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjBIW0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479A5677A2
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:27 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d2so3418667pjd.5
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHVrecg69QP6Yc0EHhHW2NpPX0Efa7YL9KNp7FKx7IE=;
        b=4mTbHD1AkANFDfP8UOIIxGOJUAg+it+uAth+YvAZj7Oxx3pjTRehtrtwk+GiojFndN
         n4dQqZEJEnVFRecZXkJHlGaqf/AdkczJHAdsp0h82ftBTLb2O3E1vSMZdcSjfX49kkzT
         FHcup4c5mAWDWbg9Bc108OmBpBg+O2n6yxY6td8/b+vJcJEtnVGVY1ks4hvUOSG1QeoP
         H8MGSScnQVSuilXPL0P58h4kHu8bdktVDbB9XhkZTgTjV39nvs98VJe5oIA4bAPKNTr7
         mmpaSGSxjdCdplHNhdlvwAr55dt1+bwK62z3fEJmqXSteCgNB3eq4qHqyH2lykLZBvO5
         rXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHVrecg69QP6Yc0EHhHW2NpPX0Efa7YL9KNp7FKx7IE=;
        b=W3pVch+ixaTmGagiW1DrD0JbP87+BWQOSdmnNJfPQFyDEosK7k7rVWjCKtv3RsTOr7
         DwVhKWpTvR9R3jh33w39iw6I+jngsHbiJiH8QhaHBDlOaoXTzhfpGcNT8dxPZ6FHTJVc
         9DDJpg0HJcsME486v8np3t5VHGaajIk0K/mPHn6nvbzgsj/veWtUnzlo6ygzLJV46CFe
         HfRCJwkdgRC97TWzxOuzeDjLJhEjPynUDyEs+s+Fv0YKajbQLkfGKLowrFCe2wj1sj+2
         isOZ3jFzrORz5SOgqylKxYClFaYiyT733dr0547Gi1TQM0JKSrNw4b2SoTvWv75ZKLwP
         lCWA==
X-Gm-Message-State: AO0yUKUftxWekyFvCoT1dneFlTk90liv4WgWafHpyWtx/Qocc9wPDx0o
        N/jIoLQuqAzi4vMFCQ5dpfVj4vMh/2lLqefm
X-Google-Smtp-Source: AK7set8NieDaRQBkD0zFfuzPWiNn1nSt6f8oigmmSz/BdspzF012h+PDvUD4GDl/FrFtfK2uskco3Q==
X-Received: by 2002:a17:902:f202:b0:199:11b3:c693 with SMTP id m2-20020a170902f20200b0019911b3c693mr9567294plc.20.1675981586687;
        Thu, 09 Feb 2023 14:26:26 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b0019141c79b1dsm1993843plb.254.2023.02.09.14.26.26
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:26 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOV6-3h
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcMi-0L
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/42] xfs: use active perag references for inode allocation
Date:   Fri, 10 Feb 2023 09:17:53 +1100
Message-Id: <20230209221825.3722244-11-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Convert the inode allocation routines to use active perag references
or references held by callers rather than grab their own. Also drive
the perag further inwards to replace xfs_mounts when doing
operations on a specific AG.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c     |  3 +-
 fs/xfs/libxfs/xfs_ialloc.c | 63 +++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_ialloc.h |  2 +-
 3 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 7cff61875340..a3bdcde95845 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -925,8 +925,7 @@ xfs_ag_shrink_space(
 	 * Make sure that the last inode cluster cannot overlap with the new
 	 * end of the AG, even if it's sparse.
 	 */
-	error = xfs_ialloc_check_shrink(*tpp, pag->pag_agno, agibp,
-			aglen - delta);
+	error = xfs_ialloc_check_shrink(pag, *tpp, agibp, aglen - delta);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f120a48813cc..53d6b7766609 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -169,14 +169,14 @@ xfs_inobt_insert_rec(
  */
 STATIC int
 xfs_inobt_insert(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag,
 	xfs_agino_t		newino,
 	xfs_agino_t		newlen,
 	xfs_btnum_t		btnum)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 	xfs_agino_t		thisino;
 	int			i;
@@ -514,14 +514,14 @@ __xfs_inobt_rec_merge(
  */
 STATIC int
 xfs_inobt_insert_sprec(
-	struct xfs_mount		*mp,
+	struct xfs_perag		*pag,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	struct xfs_perag		*pag,
 	int				btnum,
 	struct xfs_inobt_rec_incore	*nrec,	/* in/out: new/merged rec. */
 	bool				merge)	/* merge or replace */
 {
+	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_btree_cur		*cur;
 	int				error;
 	int				i;
@@ -609,9 +609,9 @@ xfs_inobt_insert_sprec(
  */
 STATIC int
 xfs_ialloc_ag_alloc(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag)
+	struct xfs_buf		*agbp)
 {
 	struct xfs_agi		*agi;
 	struct xfs_alloc_arg	args;
@@ -831,7 +831,7 @@ xfs_ialloc_ag_alloc(
 		 * if necessary. If a merge does occur, rec is updated to the
 		 * merged record.
 		 */
-		error = xfs_inobt_insert_sprec(args.mp, tp, agbp, pag,
+		error = xfs_inobt_insert_sprec(pag, tp, agbp,
 				XFS_BTNUM_INO, &rec, true);
 		if (error == -EFSCORRUPTED) {
 			xfs_alert(args.mp,
@@ -856,20 +856,20 @@ xfs_ialloc_ag_alloc(
 		 * existing record with this one.
 		 */
 		if (xfs_has_finobt(args.mp)) {
-			error = xfs_inobt_insert_sprec(args.mp, tp, agbp, pag,
+			error = xfs_inobt_insert_sprec(pag, tp, agbp,
 				       XFS_BTNUM_FINO, &rec, false);
 			if (error)
 				return error;
 		}
 	} else {
 		/* full chunk - insert new records to both btrees */
-		error = xfs_inobt_insert(args.mp, tp, agbp, pag, newino, newlen,
+		error = xfs_inobt_insert(pag, tp, agbp, newino, newlen,
 					 XFS_BTNUM_INO);
 		if (error)
 			return error;
 
 		if (xfs_has_finobt(args.mp)) {
-			error = xfs_inobt_insert(args.mp, tp, agbp, pag, newino,
+			error = xfs_inobt_insert(pag, tp, agbp, newino,
 						 newlen, XFS_BTNUM_FINO);
 			if (error)
 				return error;
@@ -981,9 +981,9 @@ xfs_inobt_first_free_inode(
  */
 STATIC int
 xfs_dialloc_ag_inobt(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag,
 	xfs_ino_t		parent,
 	xfs_ino_t		*inop)
 {
@@ -1429,9 +1429,9 @@ xfs_dialloc_ag_update_inobt(
  */
 static int
 xfs_dialloc_ag(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag,
 	xfs_ino_t		parent,
 	xfs_ino_t		*inop)
 {
@@ -1448,7 +1448,7 @@ xfs_dialloc_ag(
 	int				i;
 
 	if (!xfs_has_finobt(mp))
-		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
+		return xfs_dialloc_ag_inobt(pag, tp, agbp, parent, inop);
 
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
@@ -1594,8 +1594,8 @@ xfs_ialloc_next_ag(
 
 static bool
 xfs_dialloc_good_ag(
-	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	umode_t			mode,
 	int			flags,
 	bool			ok_alloc)
@@ -1606,6 +1606,8 @@ xfs_dialloc_good_ag(
 	int			needspace;
 	int			error;
 
+	if (!pag)
+		return false;
 	if (!pag->pagi_inodeok)
 		return false;
 
@@ -1665,8 +1667,8 @@ xfs_dialloc_good_ag(
 
 static int
 xfs_dialloc_try_ag(
-	struct xfs_trans	**tpp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	**tpp,
 	xfs_ino_t		parent,
 	xfs_ino_t		*new_ino,
 	bool			ok_alloc)
@@ -1689,7 +1691,7 @@ xfs_dialloc_try_ag(
 			goto out_release;
 		}
 
-		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
+		error = xfs_ialloc_ag_alloc(pag, *tpp, agbp);
 		if (error < 0)
 			goto out_release;
 
@@ -1705,7 +1707,7 @@ xfs_dialloc_try_ag(
 	}
 
 	/* Allocate an inode in the found AG */
-	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
+	error = xfs_dialloc_ag(pag, *tpp, agbp, parent, &ino);
 	if (!error)
 		*new_ino = ino;
 	return error;
@@ -1790,9 +1792,9 @@ xfs_dialloc(
 	agno = start_agno;
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	for (;;) {
-		pag = xfs_perag_get(mp, agno);
-		if (xfs_dialloc_good_ag(*tpp, pag, mode, flags, ok_alloc)) {
-			error = xfs_dialloc_try_ag(tpp, pag, parent,
+		pag = xfs_perag_grab(mp, agno);
+		if (xfs_dialloc_good_ag(pag, *tpp, mode, flags, ok_alloc)) {
+			error = xfs_dialloc_try_ag(pag, tpp, parent,
 					&ino, ok_alloc);
 			if (error != -EAGAIN)
 				break;
@@ -1813,12 +1815,12 @@ xfs_dialloc(
 			if (low_space)
 				ok_alloc = true;
 		}
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	}
 
 	if (!error)
 		*new_ino = ino;
-	xfs_perag_put(pag);
+	xfs_perag_rele(pag);
 	return error;
 }
 
@@ -1902,14 +1904,14 @@ xfs_difree_inode_chunk(
 
 STATIC int
 xfs_difree_inobt(
-	struct xfs_mount		*mp,
+	struct xfs_perag		*pag,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	struct xfs_perag		*pag,
 	xfs_agino_t			agino,
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
+	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_agi			*agi = agbp->b_addr;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
@@ -2036,13 +2038,13 @@ xfs_difree_inobt(
  */
 STATIC int
 xfs_difree_finobt(
-	struct xfs_mount		*mp,
+	struct xfs_perag		*pag,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	struct xfs_perag		*pag,
 	xfs_agino_t			agino,
 	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
 {
+	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				offset = agino - ibtrec->ir_startino;
@@ -2196,7 +2198,7 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	error = xfs_difree_inobt(mp, tp, agbp, pag, agino, xic, &rec);
+	error = xfs_difree_inobt(pag, tp, agbp, agino, xic, &rec);
 	if (error)
 		goto error0;
 
@@ -2204,7 +2206,7 @@ xfs_difree(
 	 * Fix up the free inode btree.
 	 */
 	if (xfs_has_finobt(mp)) {
-		error = xfs_difree_finobt(mp, tp, agbp, pag, agino, &rec);
+		error = xfs_difree_finobt(pag, tp, agbp, agino, &rec);
 		if (error)
 			goto error0;
 	}
@@ -2928,15 +2930,14 @@ xfs_ialloc_calc_rootino(
  */
 int
 xfs_ialloc_check_shrink(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
 	struct xfs_buf		*agibp,
 	xfs_agblock_t		new_length)
 {
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
 	xfs_agino_t		agino = XFS_AGB_TO_AGINO(mp, new_length);
 	int			has;
 	int			error;
@@ -2944,7 +2945,6 @@ xfs_ialloc_check_shrink(
 	if (!xfs_has_sparseinodes(mp))
 		return 0;
 
-	pag = xfs_perag_get(mp, agno);
 	cur = xfs_inobt_init_cursor(mp, tp, agibp, pag, XFS_BTNUM_INO);
 
 	/* Look up the inobt record that would correspond to the new EOFS. */
@@ -2968,6 +2968,5 @@ xfs_ialloc_check_shrink(
 	}
 out:
 	xfs_btree_del_cursor(cur, error);
-	xfs_perag_put(pag);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 4cfce2eebe7e..ab8c30b4ec22 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -107,7 +107,7 @@ int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
 xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
-int xfs_ialloc_check_shrink(struct xfs_trans *tp, xfs_agnumber_t agno,
+int xfs_ialloc_check_shrink(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agibp, xfs_agblock_t new_length);
 
 #endif	/* __XFS_IALLOC_H__ */
-- 
2.39.0

