Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB91C4361B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321AC207A9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgLCQNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:13:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgLCQNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 11:13:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607011902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Mys+GuMFRrDSDQrGANwQvd0NQVIOKbsEJ/00UybyvuU=;
        b=jKqVlIM8idDolf5p1IysNfdsQf4lcf8ZCQknwQ7L7az5lbHJJFDxu/jMOwBwti4YT1rQlz
        4fB6VAVUCfhwBXkZkEhrGWIAOGNcdAwPQNsNup06/+KKv3HofqIPyu/zM1+qo1/86nx3Hy
        +WDJxut12K4xojKAX23JKiBNuDsgbNI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-iSULhOZ4P-uOswzRylnRzw-1; Thu, 03 Dec 2020 11:11:40 -0500
X-MC-Unique: iSULhOZ4P-uOswzRylnRzw-1
Received: by mail-pj1-f71.google.com with SMTP id p20so1622434pjz.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 08:11:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mys+GuMFRrDSDQrGANwQvd0NQVIOKbsEJ/00UybyvuU=;
        b=Z4o2Ihd5jnLnJ40bPw4GMJOAhuZbBc5hQrnf133iCMykwQG8SakVfrXsnYPGyTDViF
         RB/d4DT7Hs4yS2DMx0pWyhS+zgZ9evMEIZ47tnbWEg3EvLNdgGw81oMtAfrmcfHNDJCk
         fXl4BCU/bILcHX78n24XNbJ0c1D982X/vciw5lm+yZuYhy+C5k39IsRpFcFDZq27jP+B
         3lEdMqbqdg8em+4JfUyOJzCSgym0N/64MTzaFj1IBmBR/LPxMb9UsTJimnnnR5nOTyKw
         zOxJ4H5+ncMYMI6az23udpjuXfenNv/XLnXtmXEiJzt0PSh71PwOo2PmKtM+alBn/MXF
         dIbA==
X-Gm-Message-State: AOAM5338XfjKN30nsARUlPXjc4y23ouYaXJHeXYpz9cfky4vBa8UXu2o
        oeaKIEmTSPiBx9NhZQJFJ/BXScffpwNauC83On8AEdS6CFL427YOHoINPnZHwVA6Kzccd6iccam
        XhshPhjzX+9Q4CqLDUwIZCUMQrLx0K1SnDw24UjIHhOguWNA6r/BPlwVH7r8Xubz7OVY9AsNcRQ
        ==
X-Received: by 2002:a17:90b:1894:: with SMTP id mn20mr3712570pjb.100.1607011898728;
        Thu, 03 Dec 2020 08:11:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9BTuSLqNFnGbX6yxMW3gAEZS9+CV6j03OcSvBqM3H1t+Ii9nTpuLiwhzU70lMkMdn2Pn+wg==
X-Received: by 2002:a17:90b:1894:: with SMTP id mn20mr3712528pjb.100.1607011898195;
        Thu, 03 Dec 2020 08:11:38 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm1738798pgg.4.2020.12.03.08.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:11:37 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 4/6] xfs: move xfs_dialloc_roll() into xfs_dialloc()
Date:   Fri,  4 Dec 2020 00:10:26 +0800
Message-Id: <20201203161028.1900929-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201203161028.1900929-1-hsiangkao@redhat.com>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Get rid of the confusing ialloc_context and failure handling around
xfs_dialloc() by moving xfs_dialloc_roll() into xfs_dialloc().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 57 ++++++++++++--------------------------
 fs/xfs/libxfs/xfs_ialloc.h | 22 +--------------
 fs/xfs/xfs_inode.c         | 24 +---------------
 3 files changed, 20 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d5dc3167e2ff..d2d7378abf49 100644
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
@@ -1733,30 +1733,18 @@ xfs_dialloc_roll(
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
@@ -1767,21 +1755,11 @@ xfs_dialloc(
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
@@ -1816,7 +1794,7 @@ xfs_dialloc(
 		}
 
 		if (!pag->pagi_init) {
-			error = xfs_ialloc_pagi_init(mp, tp, agno);
+			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
 			if (error)
 				goto out_error;
 		}
@@ -1831,7 +1809,7 @@ xfs_dialloc(
 		 * Then read in the AGI buffer and recheck with the AGI buffer
 		 * lock held.
 		 */
-		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
 		if (error)
 			goto out_error;
 
@@ -1844,9 +1822,9 @@ xfs_dialloc(
 			goto nextag_relse_buffer;
 
 
-		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
+		error = xfs_ialloc_ag_alloc(*tpp, agbp, &ialloced);
 		if (error) {
-			xfs_trans_brelse(tp, agbp);
+			xfs_trans_brelse(*tpp, agbp);
 
 			if (error != -ENOSPC)
 				goto out_error;
@@ -1858,21 +1836,23 @@ xfs_dialloc(
 
 		if (ialloced) {
 			/*
-			 * We successfully allocated some inodes, return
-			 * the current context to the caller so that it
-			 * can commit the current transaction and call
-			 * us again where we left off.
+			 * We successfully allocated some inodes, roll the
+			 * transaction so they can allocate one of the free
+			 * inodes we just prepared for them.
 			 */
 			ASSERT(pag->pagi_freecount > 0);
 			xfs_perag_put(pag);
 
-			*IO_agbp = agbp;
+			error = xfs_dialloc_roll(tpp, agbp);
+			if (error)
+				return error;
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
@@ -1884,8 +1864,7 @@ xfs_dialloc(
 	}
 
 out_alloc:
-	*IO_agbp = NULL;
-	return xfs_dialloc_ag(tp, agbp, parent, inop);
+	return xfs_dialloc_ag(*tpp, agbp, parent, inop);
 out_error:
 	xfs_perag_put(pag);
 	return error;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index a145e2a72530..13810ffe4af9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -32,40 +32,20 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
 }
 
-/* XXX: will be removed in the following patch */
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
index 34eca1624397..c039fc56b396 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -909,7 +909,6 @@ xfs_dir_ialloc(
 					   locked. */
 {
 	xfs_inode_t	*ip;
-	xfs_buf_t	*ialloc_context = NULL;
 	xfs_ino_t	pino = dp ? dp->i_ino : 0;
 	xfs_ino_t	ino;
 	int		error;
@@ -928,31 +927,10 @@ xfs_dir_ialloc(
 	 * commit so that no other process can steal the inode(s) that we've
 	 * just allocated.
 	 */
-	error = xfs_dialloc(*tpp, pino, mode, ialloc_context, &ino);
+	error = xfs_dialloc(tpp, pino, mode, &ino);
 	if (error)
 		return error;
 
-	/*
-	 * If the AGI buffer is non-NULL, then we were unable to get an
-	 * inode in one operation.  We need to commit the current
-	 * transaction and call xfs_ialloc() then.  It is guaranteed
-	 * to succeed the second time.
-	 */
-	if (ialloc_context) {
-		error = xfs_dialloc_roll(tpp, ialloc_context);
-		if (error)
-			return error;
-		/*
-		 * Call dialloc again. Since we've locked out all other
-		 * allocations in this allocation group, this call should
-		 * always succeed.
-		 */
-		error = xfs_dialloc(*tpp, pino, mode, ialloc_context, &ino);
-		if (error)
-			return error;
-		ASSERT(!ialloc_context);
-	}
-
 	if (ino == NULLFSINO)
 		return -ENOSPC;
 
-- 
2.18.4

