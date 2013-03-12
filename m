Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 641CC7FCD
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:43:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 509AC304059
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:43:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VkFQ183LAkWUj0zf for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:43:32 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UFOYF-0001Vm-9b
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:43:31 +1100
Date: Tue, 12 Mar 2013 23:43:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/21] xfs: Fix magic number assert in xfs_dir3_leaf_log_bests
Message-ID: <20130312124331.GP21651@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com


From: Dave Chinner <dchinner@redhat.com>

Make sure we set the magic number correctly when converting
from node to leaf form.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

This should probably be folded into patch 14/21. I missed this hunk
when bringing it forward to 3.9-rc2 and folding all the bugs fixes
I had in debug patches back into their original patches.

 fs/xfs/xfs_dir2_leaf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 015c078..43a5c8543c4 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -2199,7 +2199,7 @@ xfs_dir2_node_to_leaf(
 	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAF1_BUF);
 	leafhdr.magic = (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
 					? XFS_DIR2_LEAF1_MAGIC
-					: XFS_DIR3_LEAFN_MAGIC;
+					: XFS_DIR3_LEAF1_MAGIC;
 
 	/*
 	 * Set up the leaf tail from the freespace block.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
