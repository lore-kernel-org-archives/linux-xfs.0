Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 826AD7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D2D6304043
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:17 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	keUCNAJhdTw23r3A for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006HZ-MB
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006z4-LR
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/13] libxfs: skip pointless CRC updates after verifier
	failures
Date: Tue,  4 Mar 2014 19:51:50 +1100
Message-Id: <1393923117-9559-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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

[userspace port]

Most write verifiers don't update CRCs after the verifier
has failed and the buffer has been marked in error.  These
two didn't, but should.

Add returns to the verifier failure block, since the buffer
won't be written anyway.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_alloc_btree.c  | 1 +
 libxfs/xfs_ialloc_btree.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 282a320..5b38c24 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -355,6 +355,7 @@ xfs_allocbt_write_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 27a5dd9..d9589b7 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -242,6 +242,7 @@ xfs_inobt_write_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
