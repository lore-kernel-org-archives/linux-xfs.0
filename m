Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbeJaXAG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 19:00:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1603E8CCB
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 14:01:56 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66A2267656
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 14:01:56 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: add writepage map error tag
Date: Wed, 31 Oct 2018 10:01:54 -0400
Message-Id: <20181031140155.17996-2-bfoster@redhat.com>
In-Reply-To: <20181031140155.17996-1-bfoster@redhat.com>
References: <20181031140155.17996-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add an error tag to inject errors in the writeback block mapping
codepath. This facilitates testing of the error path responsible for
discarding delalloc blocks that could not be converted to real
blocks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_aops.c            | 6 ++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 66077a105cbb..97c9eaa72dee 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -54,7 +54,8 @@
 #define XFS_ERRTAG_BUF_LRU_REF				31
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
-#define XFS_ERRTAG_MAX					34
+#define XFS_ERRTAG_WRITEPAGE_MAP			34
+#define XFS_ERRTAG_MAX					35
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -93,5 +94,6 @@
 #define XFS_RANDOM_BUF_LRU_REF				2
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
+#define XFS_RANDOM_WRITEPAGE_MAP			2
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 49f5f5896a43..3feae3691467 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -21,6 +21,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_errortag.h"
 #include <linux/writeback.h>
 
 /*
@@ -718,6 +719,11 @@ xfs_writepage_map(
 		if (iop && !test_bit(i, iop->uptodate))
 			continue;
 
+		if (XFS_TEST_ERROR(false, XFS_I(inode)->i_mount,
+				   XFS_ERRTAG_WRITEPAGE_MAP)) {
+			error = -EIO;
+			break;
+		}
 		error = xfs_map_blocks(wpc, inode, file_offset);
 		if (error)
 			break;
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9866f542e77b..e15ac398b1da 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -51,6 +51,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BUF_LRU_REF,
 	XFS_RANDOM_FORCE_SCRUB_REPAIR,
 	XFS_RANDOM_FORCE_SUMMARY_RECALC,
+	XFS_RANDOM_WRITEPAGE_MAP,
 };
 
 struct xfs_errortag_attr {
@@ -159,6 +160,7 @@ XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
 XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
+XFS_ERRORTAG_ATTR_RW(writepage_map,	XFS_ERRTAG_WRITEPAGE_MAP);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -195,6 +197,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
 	XFS_ERRORTAG_ATTR_LIST(force_repair),
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
+	XFS_ERRORTAG_ATTR_LIST(writepage_map),
 	NULL,
 };
 
-- 
2.17.2
