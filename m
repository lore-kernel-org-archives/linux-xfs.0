Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47818 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755467AbdGSP4G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 11:56:06 -0400
Date: Wed, 19 Jul 2017 08:55:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: propagate transaction block reservations
Message-ID: <20170719155555.GO4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

Certain parts of the libxfs preemptively refuse to run if the
transaction block reservation has fallen to zero.  We leave t_blk_res at
its default of zero, which means that these code paths always fail even
if the transaction was allocated with a non-zero block reservation.  Set
t_blk_res and maintain it through transaction rolls, even though we
don't do much enforcement the transaction block limits.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index fe22cb9..035248f 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -106,6 +106,7 @@ libxfs_trans_roll(
 	struct xfs_mount	*mp;
 	struct xfs_trans	*trans;
 	struct xfs_trans_res	tres;
+	unsigned int		old_blk_res;
 	int			error;
 
 	/*
@@ -121,6 +122,7 @@ libxfs_trans_roll(
 	mp = trans->t_mountp;
 	tres.tr_logres = trans->t_log_res;
 	tres.tr_logcount = trans->t_log_count;
+	old_blk_res = trans->t_blk_res;
 
 	/*
 	 * Commit the current transaction.
@@ -145,6 +147,8 @@ libxfs_trans_roll(
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	error = libxfs_trans_alloc(mp, &tres, 0, 0, 0, tpp);
 	trans = *tpp;
+	trans->t_blk_res = old_blk_res;
+
 	/*
 	 *  Ensure that the inode is in the new transaction and locked.
 	 */
@@ -185,6 +189,7 @@ libxfs_trans_alloc(
 		exit(1);
 	}
 	ptr->t_mountp = mp;
+	ptr->t_blk_res = blocks;
 	INIT_LIST_HEAD(&ptr->t_items);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "allocated new transaction %p\n", ptr);
@@ -750,7 +755,7 @@ trans_committed(
         list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
 		struct xfs_log_item *lip = lidp->lid_item;
 
-                xfs_trans_del_item(lip);
+		xfs_trans_del_item(lip);
 
 		if (lip->li_type == XFS_LI_BUF)
 			buf_item_done((xfs_buf_log_item_t *)lip);
