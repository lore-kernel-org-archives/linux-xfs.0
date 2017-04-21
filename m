Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51096 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425803AbdDUUAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 16:00:48 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3LK0ljD028270
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2017 20:00:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v3LK0kBx003350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2017 20:00:46 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v3LK0iLm001273
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2017 20:00:45 GMT
Date: Fri, 21 Apr 2017 13:00:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: strengthen log intent item refcount checking
Message-ID: <20170421200043.GL23371@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Use ASSERTs on the log intent item refcounts so that we fail noisily if
anyone tries to double-free the item.  This will help us diagnose
potential problems with the deferred-ops mechanism via generic/388.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |    1 +
 fs/xfs/xfs_extfree_item.c  |    1 +
 fs/xfs/xfs_refcount_item.c |    1 +
 fs/xfs/xfs_rmap_item.c     |    1 +
 4 files changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 055ab8f..41262dc 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -217,6 +217,7 @@ void
 xfs_bui_release(
 	struct xfs_bui_log_item	*buip)
 {
+	ASSERT(atomic_read(&buip->bui_refcount) > 0);
 	if (atomic_dec_and_test(&buip->bui_refcount)) {
 		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_bui_item_free(buip);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d7bc149..44f8c54 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -290,6 +290,7 @@ void
 xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
+	ASSERT(atomic_read(&efip->efi_refcount) > 0);
 	if (atomic_dec_and_test(&efip->efi_refcount)) {
 		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 6e4c744..96fe209 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -221,6 +221,7 @@ void
 xfs_cui_release(
 	struct xfs_cui_log_item	*cuip)
 {
+	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
 	if (atomic_dec_and_test(&cuip->cui_refcount)) {
 		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_cui_item_free(cuip);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 73c8278..f3b139c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -243,6 +243,7 @@ void
 xfs_rui_release(
 	struct xfs_rui_log_item	*ruip)
 {
+	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
 	if (atomic_dec_and_test(&ruip->rui_refcount)) {
 		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_rui_item_free(ruip);
