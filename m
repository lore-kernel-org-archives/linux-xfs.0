Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935586AbeF1Qgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FC7F401CE88
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B4AB111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 05/24] xfs: use ->t_dfops for recovery of [b|c]ui log items
Date: Thu, 28 Jun 2018 12:36:17 -0400
Message-Id: <20180628163636.52564-6-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
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
---
 fs/xfs/xfs_bmap_item.c     | 3 +++
 fs/xfs/xfs_refcount_item.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 956ebd583e27..0a1f3e5176f3 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -441,6 +441,7 @@ xfs_bui_recover(
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		return error;
+	tp->t_dfops = dfops;
 	budp = xfs_trans_get_bud(tp, buip);
 
 	/* Grab the inode. */
@@ -487,6 +488,7 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	tp->t_dfops = NULL;
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	IRELE(ip);
@@ -494,6 +496,7 @@ xfs_bui_recover(
 	return error;
 
 err_inode:
+	tp->t_dfops = NULL;
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 472a73e9d331..eeb6ec5e0a64 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -452,6 +452,7 @@ xfs_cui_recover(
 			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+	tp->t_dfops = dfops;
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
@@ -514,11 +515,13 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
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

