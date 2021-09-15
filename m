Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F10EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16C8D610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhIOXLW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXLW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98851600D4;
        Wed, 15 Sep 2021 23:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747402;
        bh=wQlw3merrncjYUf7f00wCpWkJNJJ4mGe+CS/n6iNETw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jrAUJqOQgUZUYDq2b/oJJzJix2TE9Kw3o+cIcdi+if5LJ+bM7pTG5AFNiTxIQjIa5
         Mmc4xFs1DLzSXvS6ZHhkhJp2fPwZ2XGL0+/5WWJqiQqj/DetdmbZgIVa78u6KjaObD
         SVs68z22XXnoQfIbRzmRFJGArgIFNLjssz01ij2hYpxheTTcS32WOOGUBa/jYdBjde
         IIpDo8C8LwoZCeYzi5GgT+qOUw6Ww9uILb7jQy1YHUd5JfoTGhgHxphgZawZ1TWqIR
         gOsFnqWh4XdL3SjKOkW/Y+3+KiYeJYffDTxpsAmuFbpEkgu9Ap+PF+zY8TIQiMw4CB
         B4Aet7XB/oi4w==
Subject: [PATCH 38/61] xfs: collapse AG selection for inode allocation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:02 -0700
Message-ID: <163174740233.350433.16550095400244762904.stgit@magnolia>
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

Source kernel commit: 89b1f55a2951bb89b7ae9f8cb3fd11513ff3f219

xfs_dialloc_select_ag() does a lot of repetitive work. It first
calls xfs_ialloc_ag_select() to select the AG to start allocation
attempts in, which can do up to two entire loops across the perags
that inodes can be allocated in. This is simply checking if there is
spce available to allocate inodes in an AG, and it returns when it
finds the first candidate AG.

xfs_dialloc_select_ag() then does it's own iterative walk across
all the perags locking the AGIs and trying to allocate inodes from
the locked AG. It also doesn't limit the search to mp->m_maxagi,
so it will walk all AGs whether they can allocate inodes or not.

Hence if we are really low on inodes, we could do almost 3 entire
walks across the whole perag range before we find an allocation
group we can allocate inodes in or report ENOSPC.

Because xfs_ialloc_ag_select() returns on the first candidate AG it
finds, we can simply do these checks directly in
xfs_dialloc_select_ag() before we lock and try to allocate inodes.
This reduces the inode allocation pass down to 2 perag sweeps at
most - one for aligned inode cluster allocation and if we can't
allocate full, aligned inode clusters anywhere we'll do another pass
trying to do sparse inode cluster allocation.

This also removes a big chunk of duplicate code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |  225 ++++++++++++++++++---------------------------------
 1 file changed, 78 insertions(+), 147 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 15785417..573a7804 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -894,139 +894,6 @@ xfs_ialloc_ag_alloc(
 	return 0;
 }
 
-STATIC xfs_agnumber_t
-xfs_ialloc_next_ag(
-	xfs_mount_t	*mp)
-{
-	xfs_agnumber_t	agno;
-
-	spin_lock(&mp->m_agirotor_lock);
-	agno = mp->m_agirotor;
-	if (++mp->m_agirotor >= mp->m_maxagi)
-		mp->m_agirotor = 0;
-	spin_unlock(&mp->m_agirotor_lock);
-
-	return agno;
-}
-
-/*
- * Select an allocation group to look for a free inode in, based on the parent
- * inode and the mode.  Return the allocation group buffer.
- */
-STATIC xfs_agnumber_t
-xfs_ialloc_ag_select(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_ino_t	parent,		/* parent directory inode number */
-	umode_t		mode)		/* bits set to indicate file type */
-{
-	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
-	xfs_agnumber_t	agno;		/* current ag number */
-	int		flags;		/* alloc buffer locking flags */
-	xfs_extlen_t	ineed;		/* blocks needed for inode allocation */
-	xfs_extlen_t	longest = 0;	/* longest extent available */
-	xfs_mount_t	*mp;		/* mount point structure */
-	int		needspace;	/* file mode implies space allocated */
-	xfs_perag_t	*pag;		/* per allocation group data */
-	xfs_agnumber_t	pagno;		/* parent (starting) ag number */
-	int		error;
-
-	/*
-	 * Files of these types need at least one block if length > 0
-	 * (and they won't fit in the inode, but that's hard to figure out).
-	 */
-	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
-	mp = tp->t_mountp;
-	agcount = mp->m_maxagi;
-	if (S_ISDIR(mode))
-		pagno = xfs_ialloc_next_ag(mp);
-	else {
-		pagno = XFS_INO_TO_AGNO(mp, parent);
-		if (pagno >= agcount)
-			pagno = 0;
-	}
-
-	ASSERT(pagno < agcount);
-
-	/*
-	 * Loop through allocation groups, looking for one with a little
-	 * free space in it.  Note we don't look for free inodes, exactly.
-	 * Instead, we include whether there is a need to allocate inodes
-	 * to mean that blocks must be allocated for them,
-	 * if none are currently free.
-	 */
-	agno = pagno;
-	flags = XFS_ALLOC_FLAG_TRYLOCK;
-	for (;;) {
-		pag = xfs_perag_get(mp, agno);
-		if (!pag->pagi_inodeok) {
-			xfs_ialloc_next_ag(mp);
-			goto nextag;
-		}
-
-		if (!pag->pagi_init) {
-			error = xfs_ialloc_pagi_init(mp, tp, agno);
-			if (error)
-				goto nextag;
-		}
-
-		if (pag->pagi_freecount) {
-			xfs_perag_put(pag);
-			return agno;
-		}
-
-		if (!pag->pagf_init) {
-			error = xfs_alloc_pagf_init(mp, tp, agno, flags);
-			if (error)
-				goto nextag;
-		}
-
-		/*
-		 * Check that there is enough free space for the file plus a
-		 * chunk of inodes if we need to allocate some. If this is the
-		 * first pass across the AGs, take into account the potential
-		 * space needed for alignment of inode chunks when checking the
-		 * longest contiguous free space in the AG - this prevents us
-		 * from getting ENOSPC because we have free space larger than
-		 * ialloc_blks but alignment constraints prevent us from using
-		 * it.
-		 *
-		 * If we can't find an AG with space for full alignment slack to
-		 * be taken into account, we must be near ENOSPC in all AGs.
-		 * Hence we don't include alignment for the second pass and so
-		 * if we fail allocation due to alignment issues then it is most
-		 * likely a real ENOSPC condition.
-		 */
-		ineed = M_IGEO(mp)->ialloc_min_blks;
-		if (flags && ineed > 1)
-			ineed += M_IGEO(mp)->cluster_align;
-		longest = pag->pagf_longest;
-		if (!longest)
-			longest = pag->pagf_flcount > 0;
-
-		if (pag->pagf_freeblks >= needspace + ineed &&
-		    longest >= ineed) {
-			xfs_perag_put(pag);
-			return agno;
-		}
-nextag:
-		xfs_perag_put(pag);
-		/*
-		 * No point in iterating over the rest, if we're shutting
-		 * down.
-		 */
-		if (XFS_FORCED_SHUTDOWN(mp))
-			return NULLAGNUMBER;
-		agno++;
-		if (agno >= agcount)
-			agno = 0;
-		if (agno == pagno) {
-			if (flags == 0)
-				return NULLAGNUMBER;
-			flags = 0;
-		}
-	}
-}
-
 /*
  * Try to retrieve the next record to the left/right from the current one.
  */
@@ -1703,6 +1570,21 @@ xfs_dialloc_roll(
 	return 0;
 }
 
+STATIC xfs_agnumber_t
+xfs_ialloc_next_ag(
+	xfs_mount_t	*mp)
+{
+	xfs_agnumber_t	agno;
+
+	spin_lock(&mp->m_agirotor_lock);
+	agno = mp->m_agirotor;
+	if (++mp->m_agirotor >= mp->m_maxagi)
+		mp->m_agirotor = 0;
+	spin_unlock(&mp->m_agirotor_lock);
+
+	return agno;
+}
+
 /*
  * Select and prepare an AG for inode allocation.
  *
@@ -1729,16 +1611,24 @@ xfs_dialloc_select_ag(
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			okalloc = true;
+	int			needspace;
+	int			flags;
 
 	*IO_agbp = NULL;
 
 	/*
-	 * We do not have an agbp, so select an initial allocation
-	 * group for inode allocation.
+	 * Directories, symlinks, and regular files frequently allocate at least
+	 * one block, so factor that potential expansion when we examine whether
+	 * an AG has enough space for file creation.
 	 */
-	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
-	if (start_agno == NULLAGNUMBER)
-		return -ENOSPC;
+	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
+	if (S_ISDIR(mode))
+		start_agno = xfs_ialloc_next_ag(mp);
+	else {
+		start_agno = XFS_INO_TO_AGNO(mp, parent);
+		if (start_agno >= mp->m_maxagi)
+			start_agno = 0;
+	}
 
 	/*
 	 * If we have already hit the ceiling of inode blocks then clear
@@ -1760,12 +1650,14 @@ xfs_dialloc_select_ag(
 	 * allocation groups upward, wrapping at the end.
 	 */
 	agno = start_agno;
+	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	for (;;) {
+		xfs_extlen_t	ineed;
+		xfs_extlen_t	longest = 0;
+
 		pag = xfs_perag_get(mp, agno);
-		if (!pag->pagi_inodeok) {
-			xfs_ialloc_next_ag(mp);
+		if (!pag->pagi_inodeok)
 			goto nextag;
-		}
 
 		if (!pag->pagi_init) {
 			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
@@ -1773,12 +1665,44 @@ xfs_dialloc_select_ag(
 				break;
 		}
 
-		/*
-		 * Do a first racy fast path check if this AG is usable.
-		 */
 		if (!pag->pagi_freecount && !okalloc)
 			goto nextag;
 
+		if (!pag->pagf_init) {
+			error = xfs_alloc_pagf_init(mp, *tpp, agno, flags);
+			if (error)
+				goto nextag;
+		}
+
+		/*
+		 * Check that there is enough free space for the file plus a
+		 * chunk of inodes if we need to allocate some. If this is the
+		 * first pass across the AGs, take into account the potential
+		 * space needed for alignment of inode chunks when checking the
+		 * longest contiguous free space in the AG - this prevents us
+		 * from getting ENOSPC because we have free space larger than
+		 * ialloc_blks but alignment constraints prevent us from using
+		 * it.
+		 *
+		 * If we can't find an AG with space for full alignment slack to
+		 * be taken into account, we must be near ENOSPC in all AGs.
+		 * Hence we don't include alignment for the second pass and so
+		 * if we fail allocation due to alignment issues then it is most
+		 * likely a real ENOSPC condition.
+		 */
+		if (!pag->pagi_freecount) {
+			ineed = M_IGEO(mp)->ialloc_min_blks;
+			if (flags && ineed > 1)
+				ineed += M_IGEO(mp)->cluster_align;
+			longest = pag->pagf_longest;
+			if (!longest)
+				longest = pag->pagf_flcount > 0;
+
+			if (pag->pagf_freeblks < needspace + ineed ||
+			    longest < ineed)
+				goto nextag;
+		}
+
 		/*
 		 * Then read in the AGI buffer and recheck with the AGI buffer
 		 * lock held.
@@ -1818,10 +1742,17 @@ xfs_dialloc_select_ag(
 nextag_relse_buffer:
 		xfs_trans_brelse(*tpp, agbp);
 nextag:
-		if (++agno == mp->m_sb.sb_agcount)
-			agno = 0;
-		if (agno == start_agno)
+		if (XFS_FORCED_SHUTDOWN(mp)) {
+			error = -EFSCORRUPTED;
 			break;
+		}
+		if (++agno == mp->m_maxagi)
+			agno = 0;
+		if (agno == start_agno) {
+			if (!flags)
+				break;
+			flags = 0;
+		}
 		xfs_perag_put(pag);
 	}
 

