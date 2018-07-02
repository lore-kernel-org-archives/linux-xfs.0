Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752674AbeGBRig (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 13:38:36 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 635F5401EF24
        for <linux-xfs@vger.kernel.org>; Mon,  2 Jul 2018 17:38:36 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DA9F2166B5D
        for <linux-xfs@vger.kernel.org>; Mon,  2 Jul 2018 17:38:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: use ->t_dfops for recovery of [b|c]ui log items
Date: Mon,  2 Jul 2018 13:38:36 -0400
Message-Id: <20180702173836.9533-1-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-6-bfoster@redhat.com>
References: <20180628163636.52564-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Log recovery passes down a central dfops structure to recovery
handlers for bui and cui log items. Each of these handlers allocates
and commits a transaction and defers any remaining operations to be
completed by the main recovery sequence.

Since dfops outlives the transaction in this context, set and clear
->t_dfops appropriately such that the *_finish_item() paths and
below (i.e., xfs_bmapi*()) can expect to find the dfops in the
transaction without it being committed with the dfops attached. This
is required because transaction commit expects that an associated
dfops is finished and in this context the dfops may be populated at
commit time.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

v2:
- Add comments to explain unique ->t_dfops usage in bui/cui log item
  recovery.

 fs/xfs/xfs_bmap_item.c     | 8 ++++++++
 fs/xfs/xfs_refcount_item.c | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 956ebd583e27..478bfc798861 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -441,6 +441,7 @@ xfs_bui_recover(
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		return error;
+	tp->t_dfops = dfops;
 	budp = xfs_trans_get_bud(tp, buip);
 
 	/* Grab the inode. */
@@ -487,6 +488,12 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	/*
+	 * Recovery finishes all deferred ops once intent processing is
+	 * complete. Reset the trans reference because commit expects a finished
+	 * dfops or none at all.
+	 */
+	tp->t_dfops = NULL;
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	IRELE(ip);
@@ -494,6 +501,7 @@ xfs_bui_recover(
 	return error;
 
 err_inode:
+	tp->t_dfops = NULL;
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 472a73e9d331..2064c689bc72 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -452,6 +452,7 @@ xfs_cui_recover(
 			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+	tp->t_dfops = dfops;
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
@@ -514,11 +515,18 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
+	/*
+	 * Recovery finishes all deferred ops once intent processing is
+	 * complete. Reset the trans reference because commit expects a finished
+	 * dfops or none at all.
+	 */
+	tp->t_dfops = NULL;
 	error = xfs_trans_commit(tp);
 	return error;
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
+	tp->t_dfops = NULL;
 	xfs_trans_cancel(tp);
 	return error;
 }
-- 
2.17.1

