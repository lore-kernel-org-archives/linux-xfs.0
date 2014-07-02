Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C75097F56
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 09:52:19 -0500 (CDT)
Received: from eagdhcp-232-174.americas.sgi.com
	(eagdhcp-232-174.americas.sgi.com [128.162.232.174])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B9CA304062
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 07:52:19 -0700 (PDT)
Received: from eagdhcp-232-174.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-174.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s62EqFgF005641
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2014 09:52:15 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-174.americas.sgi.com)
Message-Id: <20140702144139.978978390@sgi.com>
Date: Wed, 02 Jul 2014 09:32:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 5/5] xfs: fix cil push sequence after log recovery
References: <20140702143206.438456679@sgi.com>
Content-Disposition: inline; filename=xfs-fix-cil-push-seq-after-recovery.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The CIL pushes are marked complete with transaction
tickets and should be in the the correct sequence order.
The back end of the cil push code uses the ctx->commit_lsn
to make sure all previous pushes are complete before adding
the commit ticket for the current cil push. Because
xlog_cil_init_post_recovery sets the ctx->commit_lsn,
the later pushes can incorrectly think that the first
sequence push is complete and allow out of order cil
completion records to be written to the log. If the
system crashes, the log will be replayed in the
wrong order.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log_cil.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/fs/xfs/xfs_log_cil.c
===================================================================
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -78,8 +78,6 @@ xlog_cil_init_post_recovery(
 {
 	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
 	log->l_cilp->xc_ctx->sequence = 1;
-	log->l_cilp->xc_ctx->commit_lsn = xlog_assign_lsn(log->l_curr_cycle,
-								log->l_curr_block);
 }
 
 /*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
