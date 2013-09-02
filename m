Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16AE229DFB
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 19:32:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9F778F8049
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 17:32:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	J9GssHD3ZmnOPmjF for <xfs@oss.sgi.com>;
	Sun, 01 Sep 2013 17:32:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGI3p-00088o-A5
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 10:32:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGI3p-0004qK-9K
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 10:32:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: ensure we copy buffer type in da btree root splits
Date: Mon,  2 Sep 2013 10:32:01 +1000
Message-Id: <1378081921-18570-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378081921-18570-1-git-send-email-david@fromorbit.com>
References: <1378081921-18570-1-git-send-email-david@fromorbit.com>
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
aasociated with the buffer. When we do this, we also need to copy
the buffer type associated with the buf log item so that the buffer
is logged correctly. If we don't do that, log recovery won't
recognise it and hence it won't recalculate the CRC on the buffer
after recovery. This leads to a directory block that can't be read
after recovery has run.

Found by inspection after finding the same problem with remote
symlink buffers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index d4e59a4..069537c 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -635,6 +635,7 @@ xfs_da3_root_split(
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
