Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbeECRyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 13:54:08 -0400
Date: Thu, 3 May 2018 10:53:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0.1/13] xfs: release new dquot buffer on defer_finish error
Message-ID: <20180503175343.GF4127@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152506698177.21553.13500862866416804148.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit efa092f3d4c6 "[XFS] Fixes a bug in the quota code when
allocating a new dquot record", we allocate a new dquot block, grab a
buffer to initialize it, and return the locked initialized dquot buffer
to the caller for further in-core dquot initialization.  Unfortunately,
if the _bmap_finish errored out, _qm_dqalloc would also error out
without bothering to free the (locked) buffer.  Leaking a locked buffer
caused hangs in generic/388 when quotas are enabled.

Furthermore, the _bmap_finish -> _defer_finish conversion in
310a75a3c6c747 ("xfs: change xfs_bmap_{finish,cancel,init,free} ->
xfs_defer_*") failed to observe that the buffer was held going into
_defer_finish and therefore failed to notice that the buffer lock is
/not/ maintained afterwards.  Now that we can bjoin a buffer to a
defer_ops, use this mechanism to ensure that the buffer stays locked
across the _defer_finish.  Release the holds and locks on the buffer as
appropriate if we have to error out.

There is a subtlety here for the caller in that the buffer emerges
locked and held to the transaction, so if the _trans_commit fails we
have to release the buffer explicitly.  This fixes the unmount hang
in generic/388 when quotas are enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a7daef9e16bf..4c39d8632230 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -362,33 +362,39 @@ xfs_qm_dqalloc(
 			      dqp->dq_flags & XFS_DQ_ALLTYPES, bp);
 
 	/*
-	 * xfs_defer_finish() may commit the current transaction and
-	 * start a second transaction if the freelist is not empty.
+	 * Hold the buffer and join it to the dfops so that we'll still own
+	 * the buffer when we return to the caller.  The buffer disposal on
+	 * error must be paid attention to very carefully, as it has been
+	 * broken since commit efa092f3d4c6 "[XFS] Fixes a bug in the quota
+	 * code when allocating a new dquot record" in 2005, and the later
+	 * conversion to xfs_defer_ops in commit 310a75a3c6c747 failed to keep
+	 * the buffer locked across the _defer_finish call.  We can now do
+	 * this correctly with xfs_defer_bjoin.
 	 *
-	 * Since we still want to modify this buffer, we need to
-	 * ensure that the buffer is not released on commit of
-	 * the first transaction and ensure the buffer is added to the
-	 * second transaction.
+	 * Above, we allocated a disk block for the dquot information and
+	 * used get_buf to initialize the dquot.  If the _defer_bjoin fails,
+	 * the buffer is still locked to *tpp, so we must _bhold_release and
+	 * then _trans_brelse the buffer.  If the _defer_finish fails, the old
+	 * transaction is gone but the new buffer is not joined or held to any
+	 * transaction, so we must _buf_relse it.
 	 *
-	 * If there is only one transaction then don't stop the buffer
-	 * from being released when it commits later on.
+	 * If everything succeeds, the caller of this function is returned a
+	 * buffer that is locked, held, and joined to the transaction.  If the
+	 * transaction commit fails (in the caller) the caller must unlock the
+	 * buffer manually.
 	 */
-
-	xfs_trans_bhold(tp, bp);
-
+	xfs_trans_bhold(*tpp, bp);
+	error = xfs_defer_bjoin(&dfops, bp);
+	if (error) {
+		xfs_trans_bhold_release(*tpp, bp);
+		xfs_trans_brelse(*tpp, bp);
+		goto error1;
+	}
 	error = xfs_defer_finish(tpp, &dfops);
-	if (error)
+	if (error) {
+		xfs_buf_relse(bp);
 		goto error1;
-
-	/* Transaction was committed? */
-	if (*tpp != tp) {
-		tp = *tpp;
-		xfs_trans_bjoin(tp, bp);
-	} else {
-		xfs_trans_bhold_release(tp, bp);
 	}
-
-	*O_bpp = bp;
 	return 0;
 
 error1:
