Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0906C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72A0A64E4D
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239978AbhBBTjh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:39:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239977AbhBBTjO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 14:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6123A64E08;
        Tue,  2 Feb 2021 19:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612294713;
        bh=rQIy6Dxri5AUTf3N4VegWhpHt9fwrtLhwK1/fyysohg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=epHMh2keihasK4OmUg4hWT4cae+nAMku9q56e28m9tG7MfUWM0fSqj+yMf1A/15Bw
         hT0oGnclKqAeXDQcMxX90vvZ6d98PRbLR36qBSjvsSWwnQdHP89I57Yd/VAY56wU7f
         FmS2gDUyuQRLGdke6EbE09BfPUnpoDgtgoaKY/blAtNTKwU1SGmp9pV96d0khHWb9k
         ryDFV3F6GJ/X4aKqu6/X8S85Jbe88IetMrK2878D+iMbZXN3v1RqaBViDdJfwsGVQ+
         4UPkPhEOo4vLwsHFeYA7lZxiUY5UMMoPsuoChP0w4gd8zSKaIYM6PdEsnVtw5ZxmCG
         E6eJOrz2aVTOA==
Date:   Tue, 2 Feb 2021 11:38:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Subject: [PATCH v6.1 01/16] xfs: fix chown leaking delalloc quota blocks when
 fssetxattr fails
Message-ID: <20210202193832.GO7193@magnolia>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223140369.491593.14536007914189520446.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161223140369.491593.14536007914189520446.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While refactoring the quota code to create a function to allocate inode
change transactions, I noticed that xfs_qm_vop_chown_reserve does more
than just make reservations: it also *modifies* the incore counts
directly to handle the owner id change for the delalloc blocks.

I then observed that the fssetxattr code continues validating input
arguments after making the quota reservation but before dirtying the
transaction.  If the routine decides to error out, it fails to undo the
accounting switch!  This leads to incorrect quota reservation and
failure down the line.

We can fix this by making the reservation function do only that -- for
the new dquot, it reserves ondisk and delalloc blocks to the
transaction, and the old dquot hangs on to its incore reservation for
now.  Once we actually switch the dquots, we can then update the incore
reservations because we've dirtied the transaction and it's too late to
turn back now.

No fixes tag because this has been broken since the start of git.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v6.1: I added an debugging assert to make sure we're not totally fouling
up the incore reservations when we chown
---
 fs/xfs/xfs_qm.c |   92 +++++++++++++++++++++----------------------------------
 1 file changed, 35 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c134eb4aeaa8..c2e4d3a27469 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1785,6 +1785,29 @@ xfs_qm_vop_chown(
 	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
 	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
+	/*
+	 * Back when we made quota reservations for the chown, we reserved the
+	 * ondisk blocks + delalloc blocks with the new dquot.  Now that we've
+	 * switched the dquots, decrease the new dquot's block reservation
+	 * (having already bumped up the real counter) so that we don't have
+	 * any reservation to give back when we commit.
+	 */
+	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
+			-ip->i_delayed_blks);
+
+	/*
+	 * Give the incore reservation for delalloc blocks back to the old
+	 * dquot.  We don't normally handle delalloc quota reservations
+	 * transactionally, so just lock the dquot and subtract from the
+	 * reservation.  Dirty the transaction because it's too late to turn
+	 * back now.
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	xfs_dqlock(prevdq);
+	ASSERT(prevdq->q_blk.reserved >= ip->i_delayed_blks);
+	prevdq->q_blk.reserved -= ip->i_delayed_blks;
+	xfs_dqunlock(prevdq);
+
 	/*
 	 * Take an extra reference, because the inode is going to keep
 	 * this dquot pointer even after the trans_commit.
@@ -1807,84 +1830,39 @@ xfs_qm_vop_chown_reserve(
 	uint			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		delblks;
 	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
-	struct xfs_dquot	*gdq_unres = NULL;
-	struct xfs_dquot	*pdq_unres = NULL;
 	struct xfs_dquot	*udq_delblks = NULL;
 	struct xfs_dquot	*gdq_delblks = NULL;
 	struct xfs_dquot	*pdq_delblks = NULL;
-	int			error;
-
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	delblks = ip->i_delayed_blks;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
+	    i_uid_read(VFS_I(ip)) != udqp->q_id)
 		udq_delblks = udqp;
-		/*
-		 * If there are delayed allocation blocks, then we have to
-		 * unreserve those from the old dquot, and add them to the
-		 * new dquot.
-		 */
-		if (delblks) {
-			ASSERT(ip->i_udquot);
-			udq_unres = ip->i_udquot;
-		}
-	}
+
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
+	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
 		gdq_delblks = gdqp;
-		if (delblks) {
-			ASSERT(ip->i_gdquot);
-			gdq_unres = ip->i_gdquot;
-		}
-	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != pdqp->q_id) {
+	    ip->i_d.di_projid != pdqp->q_id)
 		pdq_delblks = pdqp;
-		if (delblks) {
-			ASSERT(ip->i_pdquot);
-			pdq_unres = ip->i_pdquot;
-		}
-	}
-
-	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1, flags | blkflags);
-	if (error)
-		return error;
 
 	/*
-	 * Do the delayed blks reservations/unreservations now. Since, these
-	 * are done without the help of a transaction, if a reservation fails
-	 * its previous reservations won't be automatically undone by trans
-	 * code. So, we have to do it manually here.
+	 * Reserve enough quota to handle blocks on disk and reserved for a
+	 * delayed allocation.  We'll actually transfer the delalloc
+	 * reservation between dquots at chown time, even though that part is
+	 * only semi-transactional.
 	 */
-	if (delblks) {
-		/*
-		 * Do the reservations first. Unreservation can't fail.
-		 */
-		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
-		ASSERT(udq_unres || gdq_unres || pdq_unres);
-		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
-		if (error)
-			return error;
-		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				udq_unres, gdq_unres, pdq_unres,
-				-((xfs_qcnt_t)delblks), 0, blkflags);
-	}
-
-	return 0;
+	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
+			gdq_delblks, pdq_delblks,
+			ip->i_d.di_nblocks + ip->i_delayed_blks,
+			1, blkflags | flags);
 }
 
 int
