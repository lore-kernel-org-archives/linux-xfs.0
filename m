Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACC8C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 21:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F22611AC
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 21:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhECVfn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 17:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhECVfn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 May 2021 17:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57DF2611AD;
        Mon,  3 May 2021 21:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620077689;
        bh=Cr2dHaG1MgH1I7FimyecIuisZhHUqfQELJ+TewKOMbA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o2UCVxzlNaLY8CyqKPe81GGT5f/dvwojdIHbwvQiNgAL55AVOJGPH9CxCjEKRHOCC
         ciPrekvAAwrUP4pAYy2NSe2JhwS7wAPGVhvMvEJCoz/e51Q72fXTXRWulLrR59SvgX
         6ePoEftdPAaTIhn0KlZ8jgnfhn2Fmbdb9/Mvb6KRRq8NGhnvUNlHIFa3Mu6/Wj/irC
         dbkM3ZWYqxrO2vWoj6ALk888N2LgTcDW/UPV8n3a35NnVhdbQp5fu7tBluY+9zEt5o
         HBW9i/elodgFD3ZtAISawasq12WFFWo4Zb5lRTyRL40dvBtAm8GULo2EWc0cpMqZu1
         t1MNc8/Yq0WqQ==
Subject: [PATCH 1/2] xfs: adjust rt allocation minlen when extszhint >
 rtextsize
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 03 May 2021 14:34:49 -0700
Message-ID: <162007768898.836421.2999725068692265955.stgit@magnolia>
In-Reply-To: <162007768318.836421.15582644026342097489.stgit@magnolia>
References: <162007768318.836421.15582644026342097489.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs_bmap_rtalloc doesn't handle realtime extent files with extent size
hints larger than the rt volume's extent size properly, because
xfs_bmap_extsize_align can adjust the offset/length parameters to try to
fit the extent size hint.

Under these conditions, minlen has to be large enough so that any
allocation returned by xfs_rtallocate_extent will be large enough to
cover at least one of the blocks that the caller asked for.  If the
allocation is too short, bmapi_write will return no mapping for the
requested range, which causes ENOSPC errors in other parts of the
filesystem.

Therefore, adjust minlen upwards to fix this.  This can be found by
running generic/263 (g/127 or g/522) with a realtime extent size hint
that's larger than the rt volume extent size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   81 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a5e9d7d34023..c9381bf4f04b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -71,18 +71,23 @@ xfs_zero_extent(
 #ifdef CONFIG_XFS_RT
 int
 xfs_bmap_rtalloc(
-	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)
 {
-	int		error;		/* error return value */
-	xfs_mount_t	*mp;		/* mount point structure */
-	xfs_extlen_t	prod = 0;	/* product factor for allocators */
-	xfs_extlen_t	mod = 0;	/* product factor for allocators */
-	xfs_extlen_t	ralen = 0;	/* realtime allocation length */
-	xfs_extlen_t	align;		/* minimum allocation alignment */
-	xfs_rtblock_t	rtb;
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	xfs_fileoff_t		orig_offset = ap->offset;
+	xfs_rtblock_t		rtb;
+	xfs_extlen_t		prod = 0;  /* product factor for allocators */
+	xfs_extlen_t		mod = 0;   /* product factor for allocators */
+	xfs_extlen_t		ralen = 0; /* realtime allocation length */
+	xfs_extlen_t		align;     /* minimum allocation alignment */
+	xfs_extlen_t		orig_length = ap->length;
+	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
+	xfs_extlen_t		raminlen;
+	bool			rtlocked = false;
+	int			error;
 
-	mp = ap->ip->i_mount;
 	align = xfs_get_extsz_hint(ap->ip);
+retry:
 	prod = align / mp->m_sb.sb_rextsize;
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
@@ -92,6 +97,15 @@ xfs_bmap_rtalloc(
 	ASSERT(ap->length);
 	ASSERT(ap->length % mp->m_sb.sb_rextsize == 0);
 
+	/*
+	 * If we shifted the file offset downward to satisfy an extent size
+	 * hint, increase minlen by that amount so that the allocator won't
+	 * give us an allocation that's too short to cover at least one of the
+	 * blocks that the caller asked for.
+	 */
+	if (ap->offset != orig_offset)
+		minlen += orig_offset - ap->offset;
+
 	/*
 	 * If the offset & length are not perfectly aligned
 	 * then kill prod, it will just get us in trouble.
@@ -116,10 +130,13 @@ xfs_bmap_rtalloc(
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
 	 */
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
-	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
-	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
-	xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+	if (!rtlocked) {
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
+		xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
+		xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+		rtlocked = true;
+	}
 
 	/*
 	 * If it's an allocation to an empty file at offset 0,
@@ -144,30 +161,44 @@ xfs_bmap_rtalloc(
 	do_div(ap->blkno, mp->m_sb.sb_rextsize);
 	rtb = ap->blkno;
 	ap->length = ralen;
-	error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
-				&ralen, ap->wasdel, prod, &rtb);
+	raminlen = max_t(xfs_extlen_t, 1, minlen / mp->m_sb.sb_rextsize);
+	error = xfs_rtallocate_extent(ap->tp, ap->blkno, raminlen, ap->length,
+			&ralen, ap->wasdel, prod, &rtb);
 	if (error)
 		return error;
 
-	ap->blkno = rtb;
-	if (ap->blkno != NULLFSBLOCK) {
-		ap->blkno *= mp->m_sb.sb_rextsize;
-		ralen *= mp->m_sb.sb_rextsize;
-		ap->length = ralen;
-		ap->ip->i_nblocks += ralen;
+	if (rtb != NULLRTBLOCK) {
+		ap->blkno = rtb * mp->m_sb.sb_rextsize;
+		ap->length = ralen * mp->m_sb.sb_rextsize;
+		ap->ip->i_nblocks += ap->length;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
-			ap->ip->i_delayed_blks -= ralen;
+			ap->ip->i_delayed_blks -= ap->length;
 		/*
 		 * Adjust the disk quota also. This was reserved
 		 * earlier.
 		 */
 		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
-					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
-	} else {
-		ap->length = 0;
+					XFS_TRANS_DQ_RTBCOUNT, ap->length);
+		return 0;
 	}
+
+	if (align > mp->m_sb.sb_rextsize) {
+		/*
+		 * We previously enlarged the request length to try to satisfy
+		 * an extent size hint.  The allocator didn't return anything,
+		 * so reset the parameters to the original values and try again
+		 * without alignment criteria.
+		 */
+		ap->offset = orig_offset;
+		ap->length = orig_length;
+		minlen = align = mp->m_sb.sb_rextsize;
+		goto retry;
+	}
+
+	ap->blkno = NULLFSBLOCK;
+	ap->length = 0;
 	return 0;
 }
 #endif /* CONFIG_XFS_RT */

