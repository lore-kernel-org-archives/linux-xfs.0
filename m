Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3rbI6184529 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:53:37 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 454E1105D4B7
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:56:00 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GhP1Z6K1uTdktI4S for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:56:00 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PiIxh-0008FC-Kf
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:55:57 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PiIvE-0004T1-Pd
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:53:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: fix log ticket leak on forced shutdown.
Date: Thu, 27 Jan 2011 14:53:14 +1100
Message-Id: <1296100401-17135-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1296100401-17135-1-git-send-email-david@fromorbit.com>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The kmemleak detector shows this after test 139:

unreferenced object 0xffff880079b88bb0 (size 264):
  comm "xfs_io", pid 4904, jiffies 4294909382 (age 276.824s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 48 7b c9 82 ff ff ff ff  ........H{......
  backtrace:
    [<ffffffff81afb04d>] kmemleak_alloc+0x2d/0x60
    [<ffffffff8115c6cf>] kmem_cache_alloc+0x13f/0x2b0
    [<ffffffff814aaa97>] kmem_zone_alloc+0x77/0xf0
    [<ffffffff814aab2e>] kmem_zone_zalloc+0x1e/0x50
    [<ffffffff8148f394>] xlog_ticket_alloc+0x34/0x170
    [<ffffffff81494444>] xlog_cil_push+0xa4/0x3f0
    [<ffffffff81494eca>] xlog_cil_force_lsn+0x15a/0x160
    [<ffffffff814933a5>] _xfs_log_force_lsn+0x75/0x2d0
    [<ffffffff814a264d>] _xfs_trans_commit+0x2bd/0x2f0
    [<ffffffff8148bfdd>] xfs_iomap_write_allocate+0x1ad/0x350
    [<ffffffff814ac17f>] xfs_map_blocks+0x21f/0x370
    [<ffffffff814ad1b7>] xfs_vm_writepage+0x1c7/0x550
    [<ffffffff8112200a>] __writepage+0x1a/0x50
    [<ffffffff81122df2>] write_cache_pages+0x1c2/0x4c0
    [<ffffffff81123117>] generic_writepages+0x27/0x30
    [<ffffffff814aba5d>] xfs_vm_writepages+0x5d/0x80

By inspection, the leak occurs when xlog_write() returns and error
and we jump to the abort path without dropping the reference on the
active ticket.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_log_cil.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9dc8125..c7eac5a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -543,7 +543,7 @@ xlog_cil_push(
 
 	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0);
 	if (error)
-		goto out_abort;
+		goto out_abort_free_ticket;
 
 	/*
 	 * now that we've written the checkpoint into the log, strictly
@@ -569,8 +569,9 @@ restart:
 	}
 	spin_unlock(&cil->xc_cil_lock);
 
+	/* xfs_log_done always frees the ticket on error. */
 	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, 0);
-	if (error || commit_lsn == -1)
+	if (commit_lsn == -1)
 		goto out_abort;
 
 	/* attach all the transactions w/ busy extents to iclog */
@@ -600,6 +601,8 @@ out_free_ticket:
 	kmem_free(new_ctx);
 	return 0;
 
+out_abort_free_ticket:
+	xfs_log_ticket_put(tic);
 out_abort:
 	xlog_cil_committed(ctx, XFS_LI_ABORTED);
 	return XFS_ERROR(EIO);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
