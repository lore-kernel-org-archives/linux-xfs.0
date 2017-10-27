Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8307 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbdJ0KWt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 06:22:49 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A386480460
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2017 10:22:49 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 887CF5D727
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2017 10:22:49 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix unused variable warning in xfs_buf_set_ref()
Date: Fri, 27 Oct 2017 06:22:48 -0400
Message-Id: <20171027102248.61771-1-bfoster@redhat.com>
In-Reply-To: <201710271527.DFIgRssJ%fengguang.wu@intel.com>
References: <201710271527.DFIgRssJ%fengguang.wu@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Fix an unused variable warning on non-DEBUG builds introduced by
commit 7561d27e90 ("xfs: buffer lru reference count error injection
tag").

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Sigh, sorry for the noise..

Brian

 fs/xfs/xfs_buf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d481dd2..db786bc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2133,14 +2133,13 @@ xfs_buf_terminate(void)
 
 void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-
 	/*
 	 * Set the lru reference count to 0 based on the error injection tag.
 	 * This allows userspace to disrupt buffer caching for debug/testing
 	 * purposes.
 	 */
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_LRU_REF))
+	if (XFS_TEST_ERROR(false, bp->b_target->bt_mount,
+			   XFS_ERRTAG_BUF_LRU_REF))
 		lru_ref = 0;
 
 	atomic_set(&bp->b_lru_ref, lru_ref);
-- 
2.9.5

