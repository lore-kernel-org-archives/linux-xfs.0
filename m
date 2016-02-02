Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE6267CB9
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 18:39:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0730304048
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 16:39:35 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	F3XuqPt5KzLeudcD for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 16:39:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aQOzw-0007pq-Jm
	for xfs@oss.sgi.com; Tue, 02 Feb 2016 11:39:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aQOzw-0000pg-IU
	for xfs@oss.sgi.com; Tue, 02 Feb 2016 11:39:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: RT bitmap and summary buffers are not typed
Date: Tue,  2 Feb 2016 11:39:09 +1100
Message-Id: <1454373550-3102-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1454373550-3102-1-git-send-email-david@fromorbit.com>
References: <1454373550-3102-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When logging buffers, we attach a type to them that follows the
buffer all the way into the log and is used to identify the buffer
contents in log recovery. Both the realtime summary buffers and the
bitmap buffers do not have types defined or set, so when we try to
log them we see assert failure:

XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 294

Fix this by adding buffer log format types for these buffers, and
add identification support into log recovery for them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 2 ++
 fs/xfs/libxfs/xfs_rtbitmap.c   | 3 +++
 fs/xfs/xfs_log_recover.c       | 5 +++++
 3 files changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 03f90b9..d54a801 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -496,6 +496,8 @@ enum xfs_blft {
 	XFS_BLFT_ATTR_LEAF_BUF,
 	XFS_BLFT_ATTR_RMT_BUF,
 	XFS_BLFT_SB_BUF,
+	XFS_BLFT_RTBITMAP_BUF,
+	XFS_BLFT_RTSUMMARY_BUF,
 	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
 };
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index acc71dd..bfa7b85 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -71,6 +71,9 @@ xfs_rtbuf_get(
 				   mp->m_bsize, 0, &bp, NULL);
 	if (error)
 		return error;
+
+	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
+					     : XFS_BLFT_RTBITMAP_BUF);
 	*bpp = bp;
 	return 0;
 }
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 464c5d4..e2d7533 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2473,6 +2473,11 @@ xlog_recover_validate_buf_type(
 		}
 		bp->b_ops = &xfs_sb_buf_ops;
 		break;
+	case XFS_BLFT_RTBITMAP_BUF:
+	case XFS_BLFT_RTSUMMARY_BUF:
+		/* no verification of RT buffers is done */
+		bp->b_ops = NULL;
+		break;
 	default:
 		xfs_warn(mp, "Unknown buffer type %d!",
 			 xfs_blft_from_flags(buf_f));
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
