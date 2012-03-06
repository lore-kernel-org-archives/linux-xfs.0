Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q26B0P6G119393 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 05:00:26 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id imr6fWjL1uyv530O (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 03:00:24 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Fix oops on IO error during
	xlog_recover_process_iunlinks()
Date: Tue,  6 Mar 2012 12:00:16 +0100
Message-Id: <1331031616-31692-1-git-send-email-jack@suse.cz>
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
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>

When an IO error happens during inode deletion run from
xlog_recover_process_iunlinks() filesystem gets shutdown. Thus any subsequent
attempt to read buffers fails. Code in xlog_recover_process_iunlinks() does not
count with the fact that read of a buffer which was read a while ago can
really fail which results in the oops on
  agi = XFS_BUF_TO_AGI(agibp);

Fix the problem by handling error from xfs_read_agi() in all cases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_log_recover.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0ed9ee7..3899264 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3178,11 +3178,17 @@ xlog_recover_process_iunlinks(
 
 				/*
 				 * Reacquire the agibuffer and continue around
-				 * the loop. This should never fail as we know
-				 * the buffer was good earlier on.
+				 * the loop.
 				 */
 				error = xfs_read_agi(mp, NULL, agno, &agibp);
-				ASSERT(error == 0);
+				/*
+				 * We failed to read a buffer we succeeded
+				 * reading just a while ago. Likely because the
+				 * filesystem is shutdown now. Just try the
+				 * next AG.
+				 */
+				if (error)
+					goto next_ag;
 				agi = XFS_BUF_TO_AGI(agibp);
 			}
 		}
@@ -3192,6 +3198,9 @@ xlog_recover_process_iunlinks(
 		 * go on to the next one.
 		 */
 		xfs_buf_relse(agibp);
+next_ag:
+		/* Hrm... C9x seems to require this */
+		;
 	}
 
 	mp->m_dmevmask = mp_dmevmask;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
