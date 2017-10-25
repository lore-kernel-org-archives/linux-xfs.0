Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49057 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932286AbdJYS5H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Oct 2017 14:57:07 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A305C059B60
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2017 18:57:07 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F055600CC
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2017 18:57:07 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/3] xfs: fix log block underflow during recovery cycle verification
Date: Wed, 25 Oct 2017 14:57:04 -0400
Message-Id: <20171025185705.64983-3-bfoster@redhat.com>
In-Reply-To: <20171025185705.64983-1-bfoster@redhat.com>
References: <20171025185705.64983-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

It is possible for mkfs to format very small filesystems with too
small of an internal log with respect to the various minimum size
and block count requirements. If this occurs when the log happens to
be smaller than the scan window used for cycle verification and the
scan wraps the end of the log, the start_blk calculation in
xlog_find_head() underflows and leads to an attempt to scan an
invalid range of log blocks. This results in log recovery failure
and a failed mount.

Since there may be filesystems out in the wild with this kind of
geometry, we cannot simply refuse to mount. Instead, cap the scan
window for cycle verification to the size of the physical log. This
ensures that the cycle verification proceeds as expected when the
scan wraps the end of the log.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 54494ab..98350c9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -763,7 +763,7 @@ xlog_find_head(
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

