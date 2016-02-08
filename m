Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E76477CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:33:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD3BF8F8033
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 15:33:54 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	uBzTebMpZKglB7Rm for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 15:33:52 -0800 (PST)
Date: Tue, 9 Feb 2016 10:33:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: log recovery needs to be aware of CONFIG_XFS_RT now
Message-ID: <20160208233350.GO27429@dastard>
References: <20160208060751.GA27429@dastard>
	<20160208153720.GG19597@bfoster.bfoster>
	<20160208195253.GI27429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208195253.GI27429@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

As it uses buffer verifiers that only exist when CONFIG_XFS_RT=y.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
Note: I will fold this back into the original patch that caused
this build regression and rebuild the for-next tree.

 fs/xfs/xfs_log_recover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 23ad143..1dc0e14 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2472,11 +2472,13 @@ xlog_recover_validate_buf_type(
 		}
 		bp->b_ops = &xfs_sb_buf_ops;
 		break;
+#ifdef CONFIG_XFS_RT
 	case XFS_BLFT_RTBITMAP_BUF:
 	case XFS_BLFT_RTSUMMARY_BUF:
 		/* no magic numbers for verification of RT buffers */
 		bp->b_ops = &xfs_rtbuf_ops;
 		break;
+#endif /* CONFIG_XFS_RT */
 	default:
 		xfs_warn(mp, "Unknown buffer type %d!",
 			 xfs_blft_from_flags(buf_f));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
