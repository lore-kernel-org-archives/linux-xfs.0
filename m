Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D1FC4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9819123B23
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgLILbG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 06:31:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38007 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729260AbgLILbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 06:31:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607513378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TRdMHyIHJCNXWPPhu6We2FinOTnf1YC7crLImE4NSQw=;
        b=NNRsaL+z/B2YMn/05wfXSIXDbfqmdlDchHbYU/1AdhqEh6gFrD1qABqBZBbQDali+SbIEK
        9GJGtTa5XBNvb+JpIXfK/70pCBDreYCQu6vEsJNpXXnSfy9o76r8dhWY3rP03NfE91vfnA
        vpqkh5+YVneOLRcgO0eSQgeOqLZQqkc=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-cO9wsHfjOVSHsCQASvL4VQ-1; Wed, 09 Dec 2020 06:29:37 -0500
X-MC-Unique: cO9wsHfjOVSHsCQASvL4VQ-1
Received: by mail-pf1-f197.google.com with SMTP id q22so872174pfj.20
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 03:29:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TRdMHyIHJCNXWPPhu6We2FinOTnf1YC7crLImE4NSQw=;
        b=Xe66cAxXAzK2vKxVcXi4A1UtQOE+nPQJKMdoIovp8XyXVaum/xCluwkDFElxO7+H6T
         F51wcsgAA3blGSPndwKjMs3jiYssZceFqEmHPOByZ5IU2np9OMJXMRh0/9BMNR7TO2Qp
         MI3h1ZhXIy06fRaIcyyctGhyAPo/3BbyEo/PCgMnjUt69jZE1SkHpTKkJS5GVT86NDhp
         z0dmAVtfvQ0EOp99Oaa0KHKWbX88M8djP3kS/RGBM+jPmcXg15kEm6TO6XqC3dNkI6lU
         M9OaXJPAEAAejgBTr8URgJ/TkUbcODcKEeQYfm8IHafuLGyq5ithjPaGVG7vY+VXXnQt
         l0AA==
X-Gm-Message-State: AOAM533j/ONAzGE2EDG23wXzq784vVHcC7tTq9rnwzDdVdetcbt9+L6F
        RFLgNwKQ+9ZPqPWKlV9Eu7DxJH5hFofw/4f4KUXu9w+sTyI1NWwrvk5TKKAGwhHt9rAflrReimo
        jXe6MzaZGmgPa9gruh74aGmef4Q1qjjSLd6CAHY6bkoCN9emW53vjUv+zjwlRvWmcl5xBjIsC/Q
        ==
X-Received: by 2002:a62:6844:0:b029:198:4f13:e9b2 with SMTP id d65-20020a6268440000b02901984f13e9b2mr1958733pfc.29.1607513376247;
        Wed, 09 Dec 2020 03:29:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzL5VS0iACBAypiRVmR2EdgEaDhoU872BeVzeYI7/AXtfw4Yz18wJgssmUbkP6ij4mqc7vLwg==
X-Received: by 2002:a62:6844:0:b029:198:4f13:e9b2 with SMTP id d65-20020a6268440000b02901984f13e9b2mr1958691pfc.29.1607513375764;
        Wed, 09 Dec 2020 03:29:35 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y5sm2231280pfp.45.2020.12.09.03.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:29:35 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 4/6] xfs: move xfs_dialloc_roll() into xfs_dialloc()
Date:   Wed,  9 Dec 2020 19:28:18 +0800
Message-Id: <20201209112820.114863-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201209112820.114863-1-hsiangkao@redhat.com>
References: <20201209112820.114863-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Get rid of the confusing ialloc_context and failure handling around
xfs_dialloc() by moving xfs_dialloc_roll() into xfs_dialloc().

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 59 +++++++++++++-------------------------
 fs/xfs/libxfs/xfs_ialloc.h | 21 +-------------
 fs/xfs/xfs_inode.c         | 38 ++----------------------
 3 files changed, 24 insertions(+), 94 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 23e94d43acb2..074c2d83de77 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1682,7 +1682,7 @@ xfs_dialloc_ag(
 	return error;
 }
 
-int
+static int
 xfs_dialloc_roll(
 	struct xfs_trans	**tpp,
 	struct xfs_buf		*agibp)
@@ -1731,30 +1731,18 @@ xfs_dialloc_roll(
  * Mode is used to tell whether the new inode will need space, and whether it
  * is a directory.
  *
- * This function is designed to be called twice if it has to do an allocation
- * to make more free inodes.  On the first call, *IO_agbp should be set to NULL.
- * If an inode is available without having to performn an allocation, an inode
- * number is returned.  In this case, *IO_agbp is set to NULL.  If an allocation
- * needs to be done, xfs_dialloc returns the current AGI buffer in *IO_agbp.
- * The caller should then commit the current transaction, allocate a
- * new transaction, and call xfs_dialloc() again, passing in the previous value
- * of *IO_agbp.  IO_agbp should be held across the transactions. Since the AGI
- * buffer is locked across the two calls, the second call is guaranteed to have
- * a free inode available.
- *
  * Once we successfully pick an inode its number is returned and the on-disk
  * data structures are updated.  The inode itself is not read in, since doing so
  * would break ordering constraints with xfs_reclaim.
  */
 int
 xfs_dialloc(
-	struct xfs_trans	*tp,
+	struct xfs_trans	**tpp,
 	xfs_ino_t		parent,
 	umode_t			mode,
-	struct xfs_buf		**IO_agbp,
 	xfs_ino_t		*inop)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_mount	*mp = (*tpp)->t_mountp;
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
@@ -1765,21 +1753,11 @@ xfs_dialloc(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			okalloc = true;
 
-	if (*IO_agbp) {
-		/*
-		 * If the caller passes in a pointer to the AGI buffer,
-		 * continue where we left off before.  In this case, we
-		 * know that the allocation group has free inodes.
-		 */
-		agbp = *IO_agbp;
-		goto out_alloc;
-	}
-
 	/*
 	 * We do not have an agbp, so select an initial allocation
 	 * group for inode allocation.
 	 */
-	start_agno = xfs_ialloc_ag_select(tp, parent, mode);
+	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
 	if (start_agno == NULLAGNUMBER) {
 		*inop = NULLFSINO;
 		return 0;
@@ -1814,7 +1792,7 @@ xfs_dialloc(
 		}
 
 		if (!pag->pagi_init) {
-			error = xfs_ialloc_pagi_init(mp, tp, agno);
+			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
 			if (error)
 				goto out_error;
 		}
@@ -1829,7 +1807,7 @@ xfs_dialloc(
 		 * Then read in the AGI buffer and recheck with the AGI buffer
 		 * lock held.
 		 */
-		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
 		if (error)
 			goto out_error;
 
@@ -1842,9 +1820,9 @@ xfs_dialloc(
 			goto nextag_relse_buffer;
 
 
-		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
+		error = xfs_ialloc_ag_alloc(*tpp, agbp, &ialloced);
 		if (error) {
-			xfs_trans_brelse(tp, agbp);
+			xfs_trans_brelse(*tpp, agbp);
 
 			if (error != -ENOSPC)
 				goto out_error;
@@ -1856,21 +1834,25 @@ xfs_dialloc(
 
 		if (ialloced) {
 			/*
-			 * We successfully allocated some inodes, return
-			 * the current context to the caller so that it
-			 * can commit the current transaction and call
-			 * us again where we left off.
+			 * We successfully allocated space for an inode cluster
+			 * in this AG.  Roll the transaction so that we can
+			 * allocate one of the new inodes.
 			 */
 			ASSERT(pag->pagi_freecount > 0);
 			xfs_perag_put(pag);
 
-			*IO_agbp = agbp;
+			error = xfs_dialloc_roll(tpp, agbp);
+			if (error) {
+				xfs_buf_relse(agbp);
+				return error;
+			}
+
 			*inop = NULLFSINO;
-			return 0;
+			goto out_alloc;
 		}
 
 nextag_relse_buffer:
-		xfs_trans_brelse(tp, agbp);
+		xfs_trans_brelse(*tpp, agbp);
 nextag:
 		xfs_perag_put(pag);
 		if (++agno == mp->m_sb.sb_agcount)
@@ -1882,8 +1864,7 @@ xfs_dialloc(
 	}
 
 out_alloc:
-	*IO_agbp = NULL;
-	return xfs_dialloc_ag(tp, agbp, parent, inop);
+	return xfs_dialloc_ag(*tpp, agbp, parent, inop);
 out_error:
 	xfs_perag_put(pag);
 	return error;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index bd6e0db9e23c..13810ffe4af9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -32,39 +32,20 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
 }
 
-int
-xfs_dialloc_roll(
-	struct xfs_trans	**tpp,
-	struct xfs_buf		*agibp);
-
 /*
  * Allocate an inode on disk.
  * Mode is used to tell whether the new inode will need space, and whether
  * it is a directory.
  *
- * To work within the constraint of one allocation per transaction,
- * xfs_dialloc() is designed to be called twice if it has to do an
- * allocation to make more free inodes.  If an inode is
- * available without an allocation, agbp would be set to the current
- * agbp and alloc_done set to false.
- * If an allocation needed to be done, agbp would be set to the
- * inode header of the allocation group and alloc_done set to true.
- * The caller should then commit the current transaction and allocate a new
- * transaction.  xfs_dialloc() should then be called again with
- * the agbp value returned from the previous call.
- *
  * Once we successfully pick an inode its number is returned and the
  * on-disk data structures are updated.  The inode itself is not read
  * in, since doing so would break ordering constraints with xfs_reclaim.
- *
- * *agbp should be set to NULL on the first call, *alloc_done set to FALSE.
  */
 int					/* error */
 xfs_dialloc(
-	struct xfs_trans *tp,		/* transaction pointer */
+	struct xfs_trans **tpp,		/* double pointer of transaction */
 	xfs_ino_t	parent,		/* parent inode (directory) */
 	umode_t		mode,		/* mode bits for new inode */
-	struct xfs_buf	**agbp,		/* buf for a.g. inode header */
 	xfs_ino_t	*inop);		/* inode number allocated */
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 07d692020da3..860979fe18c3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -907,7 +907,6 @@ xfs_dir_ialloc(
 	prid_t		prid)		/* project id */
 {
 	xfs_inode_t	*ip;
-	xfs_buf_t	*ialloc_context = NULL;
 	xfs_ino_t	parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t	ino;
 	int		error;
@@ -916,43 +915,12 @@ xfs_dir_ialloc(
 
 	/*
 	 * Call the space management code to pick the on-disk inode to be
-	 * allocated and replenish the freelist.  Since we can only do one
-	 * allocation per transaction without deadlocks, we will need to
-	 * commit the current transaction and start a new one.
-	 * If xfs_dialloc did an allocation to replenish the freelist, it
-	 * returns the bp containing the head of the freelist as
-	 * ialloc_context. We will hold a lock on it across the transaction
-	 * commit so that no other process can steal the inode(s) that we've
-	 * just allocated.
-	 */
-	error = xfs_dialloc(*tpp, parent_ino, mode, &ialloc_context, &ino);
+	 * allocated.
+	 */
+	error = xfs_dialloc(tpp, parent_ino, mode, &ino);
 	if (error)
 		return ERR_PTR(error);
 
-	/*
-	 * If the AGI buffer is non-NULL, then we were unable to get an
-	 * inode in one operation.  We need to commit the current
-	 * transaction and call xfs_dialloc() again.  It is guaranteed
-	 * to succeed the second time.
-	 */
-	if (ialloc_context) {
-		error = xfs_dialloc_roll(tpp, ialloc_context);
-		if (error) {
-			xfs_buf_relse(ialloc_context);
-			return ERR_PTR(error);
-		}
-		/*
-		 * Call dialloc again. Since we've locked out all other
-		 * allocations in this allocation group, this call should
-		 * always succeed.
-		 */
-		error = xfs_dialloc(*tpp, parent_ino, mode,
-				    &ialloc_context, &ino);
-		if (error)
-			return ERR_PTR(error);
-		ASSERT(!ialloc_context);
-	}
-
 	if (ino == NULLFSINO)
 		return ERR_PTR(-ENOSPC);
 
-- 
2.27.0

