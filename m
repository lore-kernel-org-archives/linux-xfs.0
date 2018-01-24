Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965103AbeAXSoU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 13:44:20 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A51B58BD20
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:20 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67F82600CC
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFCv2 8/9] xfs: add a runtime stat for extra transaction log regrants
Date: Wed, 24 Jan 2018 13:44:17 -0500
Message-Id: <20180124184418.40403-9-bfoster@redhat.com>
In-Reply-To: <20180124184418.40403-1-bfoster@redhat.com>
References: <20180124184418.40403-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add a runtime stat to track the number of regrants that occur that
were not satisfied by the initial transaction reservation (i.e.,
->tr_logcount), regardless of whether blocking for reservation was
required. The purpose of this stat is to help shed some light on how
certain transaction changes may affect runtime behavior. For example,
deferring AGFL block frees can cause an additional transaction rolls
in cases where it is enabled. The regrant stat helps track how this
behavior affects workloads and to consider whether to update
transaction reservation counts.

Update the tail pushing section of the stats structure with the new
field since it already includes a couple other logspace-related
stats. Add the new stat at the end to minimize compatibility issues
with any stats-parsing scripts, etc. that may exist out in the wild.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c   | 1 +
 fs/xfs/xfs_stats.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c1f266c34af7..0efe2af7e4fe 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -399,6 +399,7 @@ xfs_log_regrant(
 		return 0;
 
 	trace_xfs_log_regrant(log, tic);
+	XFS_STATS_INC(mp, xs_regrant_logspace);
 
 	error = xlog_grant_head_check(log, &log->l_write_head, tic,
 				      &need_bytes);
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index f64d0ae345c4..76c6c099b65e 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -99,7 +99,7 @@ struct __xfsstats {
 	uint32_t		xs_log_noiclogs;
 	uint32_t		xs_log_force;
 	uint32_t		xs_log_force_sleep;
-# define XFSSTAT_END_TAIL_PUSHING	(XFSSTAT_END_LOG_OPS+10)
+# define XFSSTAT_END_TAIL_PUSHING	(XFSSTAT_END_LOG_OPS+11)
 	uint32_t		xs_try_logspace;
 	uint32_t		xs_sleep_logspace;
 	uint32_t		xs_push_ail;
@@ -110,6 +110,7 @@ struct __xfsstats {
 	uint32_t		xs_push_ail_flushing;
 	uint32_t		xs_push_ail_restarts;
 	uint32_t		xs_push_ail_flush;
+	uint32_t		xs_regrant_logspace;
 # define XFSSTAT_END_WRITE_CONVERT	(XFSSTAT_END_TAIL_PUSHING+2)
 	uint32_t		xs_xstrat_quick;
 	uint32_t		xs_xstrat_split;
-- 
2.13.6

