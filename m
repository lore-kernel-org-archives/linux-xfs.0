Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2F8tEgg091101 for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 03:55:15 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id xwhstQ3HJg44bmpi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Mar 2012 01:55:12 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH v2] xfs: Fix oops on IO error during
	xlog_recover_process_iunlinks()
Date: Thu, 15 Mar 2012 09:55:05 +0100
Message-Id: <1331801705-1145-1-git-send-email-jack@suse.cz>
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
To: Ben Myers <bpm@sgi.com>
Cc: Jan Kara <jack@suse.cz>, Alex Elder <elder@kernel.org>, stable@kernel.org, xfs@oss.sgi.com

When an IO error happens during inode deletion run from
xlog_recover_process_iunlinks() filesystem gets shutdown. Thus any subsequent
attempt to read buffers fails. Code in xlog_recover_process_iunlinks() does not
count with the fact that read of a buffer which was read a while ago can
really fail which results in the oops on
  agi = XFS_BUF_TO_AGI(agibp);

Fix the problem by cleaning up the buffer handling in
xlog_recover_process_iunlinks() as suggested by Dave Chinner. We release buffer
lock but keep buffer reference to AG buffer. That is enough for buffer stay
pinned in memory and we don't have to call xfs_read_agi() all the time.

CC: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_log_recover.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

  Last time I sent this patch as a reply to Dave's email and apparently the
patch didn't catch the attention. So I'm resending it now.

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0ed9ee7..0827644 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3161,37 +3161,27 @@ xlog_recover_process_iunlinks(
 			 */
 			continue;
 		}
+		/*
+		 * Take an extra reference to the buffer and then release it
+		 * to drop the lock so that it can be acquired in the normal
+		 * course of the transaction to truncate and free each
+		 * inode.  Because we are not racing with anyone else here
+		 * for the AGI buffer, we don't even need to hold it locked
+		 * to read the initial unlinked bucket entries out of the
+		 * buffer.
+		 */
 		agi = XFS_BUF_TO_AGI(agibp);
+		xfs_buf_hold(agibp);
+		xfs_buf_relse(agibp);
 
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
 			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 			while (agino != NULLAGINO) {
-				/*
-				 * Release the agi buffer so that it can
-				 * be acquired in the normal course of the
-				 * transaction to truncate and free the inode.
-				 */
-				xfs_buf_relse(agibp);
-
 				agino = xlog_recover_process_one_iunlink(mp,
 							agno, agino, bucket);
-
-				/*
-				 * Reacquire the agibuffer and continue around
-				 * the loop. This should never fail as we know
-				 * the buffer was good earlier on.
-				 */
-				error = xfs_read_agi(mp, NULL, agno, &agibp);
-				ASSERT(error == 0);
-				agi = XFS_BUF_TO_AGI(agibp);
 			}
 		}
-
-		/*
-		 * Release the buffer for the current agi so we can
-		 * go on to the next one.
-		 */
-		xfs_buf_relse(agibp);
+		xfs_buf_rele(agibp);
 	}
 
 	mp->m_dmevmask = mp_dmevmask;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
