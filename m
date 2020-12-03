Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B9CC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A77207A9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgLCQNN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:13:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728605AbgLCQNN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 11:13:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607011906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=rV11VsE1m0UBE9TrAynYMIvdgOzAACar4YQIU5mZkHM=;
        b=BRohluQ9dfaB/2/l+XHqg6zH7w7p5v7Zn9Dt5pBLGBTMJ9RSb3jxOoYrjpiYUUUeELI9us
        AYezPbVSu09BnQQXkc/K4607u4Zj3Bg9yMFiKaU1m8irqbbP+vPhY+z2ODDCjyo/RqGbDN
        ORM29fWaG0Gd9TevTQ003TCcX5qXmcE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-8eZhP8W6P6aVCmiHEYfmcA-1; Thu, 03 Dec 2020 11:11:44 -0500
X-MC-Unique: 8eZhP8W6P6aVCmiHEYfmcA-1
Received: by mail-pl1-f200.google.com with SMTP id x11so1457041plv.7
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 08:11:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rV11VsE1m0UBE9TrAynYMIvdgOzAACar4YQIU5mZkHM=;
        b=mr82Qy93NmlwHzS1yBB98vBppIaolqxo6YhGUEjmER3ynU3h9DEMFvA3uThdruDAdP
         Ie8BK2iKeU7LAekvZ1mqIm8s/l0NKN8474r5aew102i5l6MbSShbvVpq0BswjjPNKriC
         XjSTk23oREbrkp7v8e81R5VwPFiksILgpiQ4mW2BwhuDUfGi0pV/RWb2qTX5Q+1Ce6gs
         Htap/0m8JDdbWq9yswo9x7CbzWawbb/y4TTT2lN5Yb2HeTDcKZzzXGcYDiLKDYik+qRp
         zArO4WbuSdvGZ0/B/ihIE9b+TuTtGXHgULy5j9273kv7wYDUi781zhPhz5yM33I01dSs
         O9ug==
X-Gm-Message-State: AOAM5305bj+IslwGyxeqZuqal67g2lpzuepQ5PvgsoslzYCkHJUQtLHT
        vRNmCyrtLOJ58VBFLLyBFCzFEaIVbGh0K+L+6ZBCrt2VFC/kqM6umoKBcVSgj/JCS0Cbe2Lt5gB
        JPQ1YIOjeWgtOvQfMkwdEMnjWIGJRPTDmC3xq3dkXvRvHFdkXiePbqHNy9rs8k3oBiMCzMlUBiQ
        ==
X-Received: by 2002:a63:a70d:: with SMTP id d13mr3649356pgf.15.1607011903252;
        Thu, 03 Dec 2020 08:11:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTsQPXxQiGuMFO7oxJ0Bl9CufjDV7lmQFLiOlSyr/yKq45+32vcGkB2s0GCnPoJYA8cZdd2Q==
X-Received: by 2002:a63:a70d:: with SMTP id d13mr3649330pgf.15.1607011902895;
        Thu, 03 Dec 2020 08:11:42 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm1738798pgg.4.2020.12.03.08.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:11:42 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 5/6] xfs: spilt xfs_dialloc() into 2 functions
Date:   Fri,  4 Dec 2020 00:10:27 +0800
Message-Id: <20201203161028.1900929-6-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201203161028.1900929-1-hsiangkao@redhat.com>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This patch explicitly separates free inode chunk allocation and
inode allocation into two individual high level operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 59 +++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_ialloc.h | 20 +++++++++----
 fs/xfs/xfs_inode.c         | 19 ++++++++----
 3 files changed, 55 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d2d7378abf49..597629353d4d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1570,7 +1570,7 @@ xfs_dialloc_ag_update_inobt(
  * The caller selected an AG for us, and made sure that free inodes are
  * available.
  */
-STATIC int
+int
 xfs_dialloc_ag(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
@@ -1728,21 +1728,22 @@ xfs_dialloc_roll(
 }
 
 /*
- * Allocate an inode on disk.
+ * Select and prepare an AG for inode allocation.
  *
- * Mode is used to tell whether the new inode will need space, and whether it
- * is a directory.
+ * Mode is used to tell whether the new inode is a directory and hence where to
+ * locate it.
  *
- * Once we successfully pick an inode its number is returned and the on-disk
- * data structures are updated.  The inode itself is not read in, since doing so
- * would break ordering constraints with xfs_reclaim.
+ * This function will ensure that the selected AG has free inodes available to
+ * allocate from. The selected AGI will be returned locked to the caller, and it
+ * will allocate more free inodes if required. If no free inodes are found or
+ * can be allocated, no AGI will be returned.
  */
 int
-xfs_dialloc(
+xfs_dialloc_select_ag(
 	struct xfs_trans	**tpp,
 	xfs_ino_t		parent,
 	umode_t			mode,
-	xfs_ino_t		*inop)
+	struct xfs_buf		**IO_agbp)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
 	struct xfs_buf		*agbp;
@@ -1755,15 +1756,15 @@ xfs_dialloc(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			okalloc = true;
 
+	*IO_agbp = NULL;
+
 	/*
 	 * We do not have an agbp, so select an initial allocation
 	 * group for inode allocation.
 	 */
 	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
-	if (start_agno == NULLAGNUMBER) {
-		*inop = NULLFSINO;
+	if (start_agno == NULLAGNUMBER)
 		return 0;
-	}
 
 	/*
 	 * If we have already hit the ceiling of inode blocks then clear
@@ -1796,7 +1797,7 @@ xfs_dialloc(
 		if (!pag->pagi_init) {
 			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
 			if (error)
-				goto out_error;
+				break;
 		}
 
 		/*
@@ -1811,11 +1812,12 @@ xfs_dialloc(
 		 */
 		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
 		if (error)
-			goto out_error;
+			break;
 
 		if (pag->pagi_freecount) {
 			xfs_perag_put(pag);
-			goto out_alloc;
+			*IO_agbp = agbp;
+			return 0;
 		}
 
 		if (!okalloc)
@@ -1826,19 +1828,17 @@ xfs_dialloc(
 		if (error) {
 			xfs_trans_brelse(*tpp, agbp);
 
-			if (error != -ENOSPC)
-				goto out_error;
-
-			xfs_perag_put(pag);
-			*inop = NULLFSINO;
-			return 0;
+			if (error == -ENOSPC)
+				error = 0;
+			break;
 		}
 
 		if (ialloced) {
 			/*
-			 * We successfully allocated some inodes, roll the
-			 * transaction so they can allocate one of the free
-			 * inodes we just prepared for them.
+			 * We successfully allocated some inodes, so roll the
+			 * transaction and return the locked AGI buffer to the
+			 * caller so they can allocate one of the free inodes we
+			 * just prepared for them.
 			 */
 			ASSERT(pag->pagi_freecount > 0);
 			xfs_perag_put(pag);
@@ -1847,8 +1847,8 @@ xfs_dialloc(
 			if (error)
 				return error;
 
-			*inop = NULLFSINO;
-			goto out_alloc;
+			*IO_agbp = agbp;
+			return 0;
 		}
 
 nextag_relse_buffer:
@@ -1857,15 +1857,10 @@ xfs_dialloc(
 		xfs_perag_put(pag);
 		if (++agno == mp->m_sb.sb_agcount)
 			agno = 0;
-		if (agno == start_agno) {
-			*inop = NULLFSINO;
+		if (agno == start_agno)
 			return noroom ? -ENOSPC : 0;
-		}
 	}
 
-out_alloc:
-	return xfs_dialloc_ag(*tpp, agbp, parent, inop);
-out_error:
 	xfs_perag_put(pag);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 13810ffe4af9..3511086a7ae1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -37,16 +37,26 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
  * Mode is used to tell whether the new inode will need space, and whether
  * it is a directory.
  *
- * Once we successfully pick an inode its number is returned and the
- * on-disk data structures are updated.  The inode itself is not read
- * in, since doing so would break ordering constraints with xfs_reclaim.
+ * There are two phases to inode allocation: selecting an AG and ensuring
+ * that it contains free inodes, followed by allocating one of the free
+ * inodes. xfs_dialloc_select_ag() does the former and returns a locked AGI
+ * to the caller, ensuring that followup call to xfs_dialloc_ag() will
+ * have free inodes to allocate from. xfs_dialloc_ag() will return the inode
+ * number of the free inode we allocated.
  */
 int					/* error */
-xfs_dialloc(
+xfs_dialloc_select_ag(
 	struct xfs_trans **tpp,		/* double pointer of transaction */
 	xfs_ino_t	parent,		/* parent inode (directory) */
 	umode_t		mode,		/* mode bits for new inode */
-	xfs_ino_t	*inop);		/* inode number allocated */
+	struct xfs_buf	**IO_agbp);
+
+int
+xfs_dialloc_ag(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_ino_t		parent,
+	xfs_ino_t		*inop);
 
 /*
  * Free disk inode.  Carefully avoids touching the incore inode, all
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c039fc56b396..d0ae0d6ee892 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -908,10 +908,11 @@ xfs_dir_ialloc(
 	xfs_inode_t	**ipp)		/* pointer to inode; it will be
 					   locked. */
 {
-	xfs_inode_t	*ip;
-	xfs_ino_t	pino = dp ? dp->i_ino : 0;
-	xfs_ino_t	ino;
-	int		error;
+	struct xfs_buf		*agibp;
+	struct xfs_inode	*ip;
+	xfs_ino_t		pino = dp ? dp->i_ino : 0;
+	xfs_ino_t		ino;
+	int			error;
 
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 	*ipp = NULL;
@@ -927,13 +928,19 @@ xfs_dir_ialloc(
 	 * commit so that no other process can steal the inode(s) that we've
 	 * just allocated.
 	 */
-	error = xfs_dialloc(tpp, pino, mode, &ino);
+	error = xfs_dialloc_select_ag(tpp, pino, mode, &agibp);
 	if (error)
 		return error;
 
-	if (ino == NULLFSINO)
+	if (!agibp)
 		return -ENOSPC;
 
+	/* Allocate an inode from the selected AG */
+	error = xfs_dialloc_ag(*tpp, agibp, pino, &ino);
+	if (error)
+		return error;
+	ASSERT(ino != NULLFSINO);
+
 	/* Initialise the newly allocated inode. */
 	ip = xfs_ialloc(*tpp, dp, ino, mode, nlink, rdev, prid);
 	if (IS_ERR(ip))
-- 
2.18.4

