Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EEEA7F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:15:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5B49AC002
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 03:15:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FjiybuFFcyUsMcFW for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 03:15:50 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UdHhR-0008KQ-GP
	for xfs@oss.sgi.com; Fri, 17 May 2013 20:15:45 +1000
Date: Fri, 17 May 2013 20:15:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/5] xfs: xfs_da3_node_read_verify() doesn't handle
	XFS_ATTR3_LEAF_MAGIC
Message-ID: <20130517101545.GR24635@dastard>
References: <1368753029-9977-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368753029-9977-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 41ea7e1..0b8b2a1 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -270,6 +270,7 @@ xfs_da3_node_read_verify(
 				break;
 			return;
 		case XFS_ATTR_LEAF_MAGIC:
+		case XFS_ATTR3_LEAF_MAGIC:
 			bp->b_ops = &xfs_attr3_leaf_buf_ops;
 			bp->b_ops->verify_read(bp);
 			return;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
