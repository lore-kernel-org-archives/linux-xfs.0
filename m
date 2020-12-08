Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7B9C4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F0623AC8
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgLHMX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729480AbgLHMXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 07:23:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607430118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=4wap+Uy7r4snX0QOhvjD1HhGIzMLLvg2kThPx2dr5uc=;
        b=K2vXQferlY0vHNGZ9LiUeRpU+myIakfemnL12mt0fTynyBb+GOetSCLcMnI+5io/JTIHIs
        13dKlM105QMkWZ+bpeoQsejUdtYGB9FQp0gw5TUCLyoozMNQ98/ijyGXq+byuhIQEiIhXd
        aDkGFKaVxDaYR/rfRJTKftZo8oJlhdc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-xhhHA0_lN_OhHwhIdoibjQ-1; Tue, 08 Dec 2020 07:21:57 -0500
X-MC-Unique: xhhHA0_lN_OhHwhIdoibjQ-1
Received: by mail-pl1-f200.google.com with SMTP id m9so3502181plt.5
        for <linux-xfs@vger.kernel.org>; Tue, 08 Dec 2020 04:21:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4wap+Uy7r4snX0QOhvjD1HhGIzMLLvg2kThPx2dr5uc=;
        b=JJD5RkqFVL5YSlMZswobcyKe/Hfr5s1QNUi4yFPmK+qqwTCLNq3P8geUmcbYrzGkz1
         FXDXZhUaoKaUKHqN4eYhaKPSev7UWqWfB+/eiaLD5zewQepboj3BbwaVMIHpuhZHLpTj
         xqv15zPpfTR6W+Z0cIGvfWCh3fDtabnare9ovsV9GpzuKLjI0zQvU6ISRHfhI5NZw7hA
         wVW0zIm1vUnu4eLl9SAl3oqIaHpI/c1PtY+NK1dCXp1wkS748kA+lIrbg7buMKk5eWzo
         ifYUMAC3TW58JAGPwmSP9aSkN8e8bIqeGBQHRIaNPgQfdLRJYCGI1PaIcDymjLK5JO7K
         cZAQ==
X-Gm-Message-State: AOAM5338o/ozGPuYq4s59HGcwOQJf/JVaf+Jz4TJHo+Ur/7cooZ6Ce2M
        vdtm4smBXRIvMF9wmis/cF/WJLoVBA3mLhYlGLaaQEtcWYKd5AY2fPRLLoY4Rvpx63sQxOIC9S4
        lqUkPhbh6icVFzlIlqFgkohW801PTgSGQD7Y+hc5L7h22CGOq08vzdym5zuLOd62onJ+G9SE9Hg
        ==
X-Received: by 2002:a63:f94f:: with SMTP id q15mr21080704pgk.402.1607430115630;
        Tue, 08 Dec 2020 04:21:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyd9wTNq2nPLiVLyI8Wf6g1wqp3+3Qj19tn8Js6J4zuzBmlX4oAftCy1gnT7ui1hF2d2DSNJA==
X-Received: by 2002:a63:f94f:: with SMTP id q15mr21080670pgk.402.1607430115159;
        Tue, 08 Dec 2020 04:21:55 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a29sm1156926pfr.73.2020.12.08.04.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 04:21:54 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 5/6] xfs: spilt xfs_dialloc() into 2 functions
Date:   Tue,  8 Dec 2020 20:20:02 +0800
Message-Id: <20201208122003.3158922-6-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201208122003.3158922-1-hsiangkao@redhat.com>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This patch explicitly separates free inode chunk allocation and
inode allocation into two individual high level operations.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 54 +++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_ialloc.h | 20 ++++++++++----
 fs/xfs/xfs_inode.c         | 18 ++++++++-----
 3 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 074c2d83de77..dcb076d5c390 100644
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
@@ -1726,21 +1726,22 @@ xfs_dialloc_roll(
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
@@ -1753,15 +1754,15 @@ xfs_dialloc(
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
@@ -1794,7 +1795,7 @@ xfs_dialloc(
 		if (!pag->pagi_init) {
 			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
 			if (error)
-				goto out_error;
+				break;
 		}
 
 		/*
@@ -1809,11 +1810,11 @@ xfs_dialloc(
 		 */
 		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
 		if (error)
-			goto out_error;
+			break;
 
 		if (pag->pagi_freecount) {
 			xfs_perag_put(pag);
-			goto out_alloc;
+			goto found_ag;
 		}
 
 		if (!okalloc)
@@ -1824,12 +1825,9 @@ xfs_dialloc(
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
@@ -1846,9 +1844,7 @@ xfs_dialloc(
 				xfs_buf_relse(agbp);
 				return error;
 			}
-
-			*inop = NULLFSINO;
-			goto out_alloc;
+			goto found_ag;
 		}
 
 nextag_relse_buffer:
@@ -1857,17 +1853,15 @@ xfs_dialloc(
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
+found_ag:
+	*IO_agbp = agbp;
+	return 0;
 }
 
 /*
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
index ec8433ea6985..09e934b8332d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -906,10 +906,10 @@ xfs_dir_ialloc(
 	dev_t		rdev,
 	prid_t		prid)		/* project id */
 {
-	xfs_inode_t	*ip;
-	xfs_ino_t	parent_ino = dp ? dp->i_ino : 0;
-	xfs_ino_t	ino;
-	int		error;
+	struct xfs_buf		*agibp;
+	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
+	xfs_ino_t		ino;
+	int			error;
 
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
@@ -917,13 +917,19 @@ xfs_dir_ialloc(
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
 	 */
-	error = xfs_dialloc(tpp, parent_ino, mode, &ino);
+	error = xfs_dialloc_select_ag(tpp, parent_ino, mode, &agibp);
 	if (error)
 		return ERR_PTR(error);
 
-	if (ino == NULLFSINO)
+	if (!agibp)
 		return ERR_PTR(-ENOSPC);
 
+	/* Allocate an inode from the selected AG */
+	error = xfs_dialloc_ag(*tpp, agibp, parent_ino, &ino);
+	if (error)
+		return ERR_PTR(error);
+	ASSERT(ino != NULLFSINO);
+
 	/* Initialise the newly allocated inode. */
 	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid);
 }
-- 
2.18.4

