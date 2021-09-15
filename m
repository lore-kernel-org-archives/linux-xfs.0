Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01321C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D99E5610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhIOXLr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232691AbhIOXLo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68BB0610A6;
        Wed, 15 Sep 2021 23:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747424;
        bh=VufB+xR8IkB4mVAbwiji1INcFqfubshpMUKckjslezk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UhPHfekruwhA1Eh7rrGInqbQrormdlwDvjkRyk3WB3IzDbVh83yUjJ7iSZqNtRcU1
         h3+To/gC53dgt5TLItVxeAd6f9hzU96P1At/YvqottslTY5Twcbn5Ls6L4X9zay4Fa
         j29qqxOMHeoXidO+I0Y9OVcdXxrHshEnDI6KVmagaV0d9btLs4+LuwijIeye+xP+eg
         3HAPfxbaMc0eISxOQO2zA6FhzP89+R3MtidPG87YZHIF+LC0//8W/Dfuhexg1uElDg
         i/zK5vJmxkNHyu93jmH7ajmF5TUt6sNAVMKFqvo0MnUSr3LbU9xTqNk2vHRPaF9B+P
         3f8NZtEIkI/Hw==
Subject: [PATCH 42/61] xfs: use perag through unlink processing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:24 -0700
Message-ID: <163174742414.350433.3652497263995199207.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: f40aadb2bb64fe0a3d9b59957e70796d629cdee2

Unlinked lists are held in the perag, and freeing of inodes needs to
be passed a perag, too, so look up the perag early in the unlink
processing and use it throughout.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |   23 ++++++++++-------------
 libxfs/xfs_ialloc.h |   13 ++-----------
 2 files changed, 12 insertions(+), 24 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index a1454908..e24136a4 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2129,35 +2129,33 @@ xfs_difree_finobt(
  */
 int
 xfs_difree(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	xfs_ino_t		inode,		/* inode to be freed */
-	struct xfs_icluster	*xic)	/* cluster info if deleted */
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_ino_t		inode,
+	struct xfs_icluster	*xic)
 {
 	/* REFERENCED */
 	xfs_agblock_t		agbno;	/* block number containing inode */
 	struct xfs_buf		*agbp;	/* buffer for allocation group header */
 	xfs_agino_t		agino;	/* allocation group inode number */
-	xfs_agnumber_t		agno;	/* allocation group number */
 	int			error;	/* error return value */
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inobt_rec_incore rec;/* btree record */
-	struct xfs_perag	*pag;
 
 	/*
 	 * Break up inode number into its components.
 	 */
-	agno = XFS_INO_TO_AGNO(mp, inode);
-	if (agno >= mp->m_sb.sb_agcount) {
-		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
-			__func__, agno, mp->m_sb.sb_agcount);
+	if (pag->pag_agno != XFS_INO_TO_AGNO(mp, inode)) {
+		xfs_warn(mp, "%s: agno != pag->pag_agno (%d != %d).",
+			__func__, XFS_INO_TO_AGNO(mp, inode), pag->pag_agno);
 		ASSERT(0);
 		return -EINVAL;
 	}
 	agino = XFS_INO_TO_AGINO(mp, inode);
-	if (inode != XFS_AGINO_TO_INO(mp, agno, agino))  {
+	if (inode != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino))  {
 		xfs_warn(mp, "%s: inode != XFS_AGINO_TO_INO() (%llu != %llu).",
 			__func__, (unsigned long long)inode,
-			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino));
+			(unsigned long long)XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2171,7 +2169,7 @@ xfs_difree(
 	/*
 	 * Get the allocation group header.
 	 */
-	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_ialloc_read_agi() returned error %d.",
 			__func__, error);
@@ -2181,7 +2179,6 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	pag = agbp->b_pag;
 	error = xfs_difree_inobt(mp, tp, agbp, pag, agino, xic, &rec);
 	if (error)
 		goto error0;
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 886f6748..9df7c804 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -39,17 +39,8 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
 		xfs_ino_t *new_ino);
 
-/*
- * Free disk inode.  Carefully avoids touching the incore inode, all
- * manipulations incore are the caller's responsibility.
- * The on-disk inode is not changed by this operation, only the
- * btree (free inode mask) is changed.
- */
-int					/* error */
-xfs_difree(
-	struct xfs_trans *tp,		/* transaction pointer */
-	xfs_ino_t	inode,		/* inode to be freed */
-	struct xfs_icluster *ifree);	/* cluster info if deleted */
+int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
+		xfs_ino_t ino, struct xfs_icluster *ifree);
 
 /*
  * Return the location of the inode in imap, for mapping it into a buffer.

