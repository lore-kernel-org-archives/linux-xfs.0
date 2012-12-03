Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NefNt067622 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:41 -0600
Message-Id: <20121203144309.729176306@sgi.com>
Date: Mon, 03 Dec 2012 17:42:18 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 10/36] xfs: Account log unmount transaction
	correctly
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=063
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 3948659e30808fbaa7673bbe89de2ae9769e20a7

There have been a few reports of this warning appearing recently:

XFS (dm-4): xlog_space_left: head behind tail
 tail_cycle = 129, tail_bytes = 20163072
 GH   cycle = 129, GH   bytes = 20162880

The common cause appears to be lots of freeze and unfreeze cycles,
and the output from the warnings indicates that we are leaking
around 8 bytes of log space per freeze/unfreeze cycle.

When we freeze the filesystem, we write an unmount record and that
uses xlog_write directly - a special type of transaction,
effectively. What it doesn't do, however, is correctly account for
the log space it uses. The unmount record writes an 8 byte structure
with a special magic number into the log, and the space this
consumes is not accounted for in the log ticket tracking the
operation. Hence we leak 8 bytes every unmount record that is
written.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -531,8 +531,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 				.lv_iovecp = &reg,
 			};
 
-			/* remove inited flag */
+			/* remove inited flag, and account for space used */
 			tic->t_flags = 0;
+			tic->t_curr_res -= sizeof(magic);
 			error = xlog_write(log, &vec, tic, &lsn,
 					   NULL, XLOG_UNMOUNT_TRANS);
 			/*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
