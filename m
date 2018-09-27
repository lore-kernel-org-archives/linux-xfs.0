Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbeI0TaN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Sep 2018 15:30:13 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 333368CDC
        for <linux-xfs@vger.kernel.org>; Thu, 27 Sep 2018 13:12:02 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF50B2010DB8
        for <linux-xfs@vger.kernel.org>; Thu, 27 Sep 2018 13:12:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: remove invalid log recovery first/last cycle check
Date: Thu, 27 Sep 2018 09:12:01 -0400
Message-Id: <20180927131201.11076-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

One of the first steps of log recovery is to check for the special
case of a zeroed log. If the first cycle in the log is zero or the
tail portion of the log is zeroed, the head is set to the first
instance of cycle 0. xlog_find_zeroed() includes a sanity check that
enforces that the first cycle in the log must be 1 if the last cycle
is 0. While this is true in most cases, the check is not totally
valid because it doesn't consider the case where the filesystem
crashed after a partial/out of order log buffer completion that
wraps around the end of the physical log.

For example, consider a filesystem that has completed most of the
first cycle of the log, reaches the end of the physical log and
splits the next single log buffer write into two in order to wrap
around the end of the log. If these I/Os are reordered, the second
(wrapped) I/O completes and the first happens to fail, the log is
left in a state where the last cycle of the log is 0 and the first
cycle is 2. This causes the xlog_find_zeroed() sanity check to fail
and prevents the filesystem from mounting. This situation has been
reproduced on particular systems via repeated runs of generic/475.

This is an expected state that log recovery already knows how to
deal with, however. Since the log is still partially zeroed, the
head is detected correctly and points to a valid tail. The
subsequent stale block detection clears blocks beyond the head up to
the tail (within a maximum range), with the express purpose of
clearing such out of order writes. As expected, this removes the out
of order cycle 2 blocks at the physical start of the log.

In other words, the only thing that prevents a clean mount and
recovery of the filesystem in this scenario is the specific (last ==
0 && first != 1) sanity check in xlog_find_zeroed(). Since the log
head/tail are now independently validated via cycle, log record and
CRC checks, this highly specific first cycle check is of dubious
value. Remove it and rely on the higher level validation to
determine whether log content is sane and recoverable.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a21dc61ec09e..1fc9e9042e0e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1570,16 +1570,6 @@ xlog_find_zeroed(
 	if (last_cycle != 0) {		/* log completely written to */
 		xlog_put_bp(bp);
 		return 0;
-	} else if (first_cycle != 1) {
-		/*
-		 * If the cycle of the last block is zero, the cycle of
-		 * the first block must be 1. If it's not, maybe we're
-		 * not looking at a log... Bail out.
-		 */
-		xfs_warn(log->l_mp,
-			"Log inconsistent or not a log (last==0, first!=1)");
-		error = -EINVAL;
-		goto bp_err;
 	}
 
 	/* we have a partially zeroed log */
-- 
2.17.1
