Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9D257F86
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C69EAC001
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WmFMfMRwZgDXD3zQ for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxZ-0006Ol-Tq
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxZ-0002FP-T8
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/32] xfs: ensure we copy buffer type in da btree root splits
Date: Mon, 30 Sep 2013 13:15:17 +1000
Message-Id: <1380510944-8571-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

When splitting the root of the da btree, we shuffled data between
buffers and the structures that track them. At one point, we copy
data and state from one buffer to another, including the ops
associated with the buffer. When we do this, we also need to copy
the buffer type associated with the buf log item so that the buffer
is logged correctly. If we don't do that, log recovery won't
recognise it and hence it won't recalculate the CRC on the buffer
after recovery. This leads to a directory block that can't be read
after recovery has run.

Found by inspection after finding the same problem with remote
symlink buffers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_da_btree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index b7b6705..f106e06 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -612,6 +612,7 @@ xfs_da3_root_split(
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
 
 	bp->b_ops = blk1->bp->b_ops;
+	xfs_trans_buf_copy_type(bp, blk1->bp);
 	blk1->bp = bp;
 	blk1->blkno = blkno;
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
