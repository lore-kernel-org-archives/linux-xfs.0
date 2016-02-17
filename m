Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41D437CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3243B8F8033
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:18 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pOX24DCBEyx8MbH4 for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004lx-Oq
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014D-O4
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/15] xfs: RT bitmap and summary buffers are not typed
Date: Wed, 17 Feb 2016 18:20:43 +1100
Message-Id: <1455693652-3899-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

Source kernel commit f67ca6eca89cddd355c83639a90109e245f9d5a7

When logging buffers, we attach a type to them that follows the
buffer all the way into the log and is used to identify the buffer
contents in log recovery. Both the realtime summary buffers and the
bitmap buffers do not have types defined or set, so when we try to
log them we see assert failure:

XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 294

Fix this by adding buffer log format types for these buffers, and
add identification support into log recovery for them. Only build the log
recovery support if CONFIG_XFS_RT=y - we can't get into log recovery for real
time filesystems if support is not built into the kernel, and this avoids
potential build problems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_log_format.h | 2 ++
 libxfs/xfs_rtbitmap.c   | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index db8ceeb..c860345 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -495,6 +495,8 @@ enum xfs_blft {
 	XFS_BLFT_ATTR_LEAF_BUF,
 	XFS_BLFT_ATTR_RMT_BUF,
 	XFS_BLFT_SB_BUF,
+	XFS_BLFT_RTBITMAP_BUF,
+	XFS_BLFT_RTSUMMARY_BUF,
 	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
 };
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 5648ea5..3e61eb2 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -66,6 +66,9 @@ xfs_rtbuf_get(
 				   mp->m_bsize, 0, &bp, NULL);
 	if (error)
 		return error;
+
+	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
+					     : XFS_BLFT_RTBITMAP_BUF);
 	*bpp = bp;
 	return 0;
 }
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
