Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751198AbdJWOqs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Oct 2017 10:46:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EC6061D20
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 441D682A18
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] xfs: fix log block underflow during recovery cycle verification
Date: Mon, 23 Oct 2017 10:46:44 -0400
Message-Id: <20171023144646.50107-3-bfoster@redhat.com>
In-Reply-To: <20171023144646.50107-1-bfoster@redhat.com>
References: <20171023144646.50107-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Unfortunately it is possible for mkfs to format very small
filesystems with too small of an internal log with respect to the
various minimum size and block count requirements. If this occurs
when the log happens to be smaller than the scan window used for
cycle verification and the scan wraps the end of the log, the
start_blk calculation in xlog_find_head() underflows and leads to an
attempt to scan an invalid range of log blocks. This results in log
recovery failure and a failed mount.

Since there may be filesystems out in the wild with this kind of
geometry, we cannot simply refuse to mount. Instead, cap the scan
window for cycle verification to the size of the physical log. This
ensures that the cycle verification proceeds as expected when the
scan wraps the end of the log.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 80b37a2..019de58 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -760,7 +760,7 @@ xlog_find_head(
 	 * in the in-core log.  The following number can be made tighter if
 	 * we actually look at the block size of the filesystem.
 	 */
-	num_scan_bblks = XLOG_TOTAL_REC_SHIFT(log);
+	num_scan_bblks = min_t(int, log_bbnum, XLOG_TOTAL_REC_SHIFT(log));
 	if (head_blk >= num_scan_bblks) {
 		/*
 		 * We are guaranteed that the entire check can be performed
-- 
2.9.5

