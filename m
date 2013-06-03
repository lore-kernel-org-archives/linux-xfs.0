Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D566129E16
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 00:29:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9AD8304043
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 22:29:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zJnYy0vHOcIKcrIj for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 22:29:23 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: fix remote attribute invalidation for a leaf
Date: Mon,  3 Jun 2013 15:28:49 +1000
Message-Id: <1370237332-24757-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370237332-24757-1-git-send-email-david@fromorbit.com>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

When invalidating an attribute leaf block block, there might be
remote attributes that it points to. With the recent rework of the
remote attribute format, we have to make sure we calculate the
length of the attribute correctly. We aren't doing that in
xfs_attr3_leaf_inactive(), so fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index d788302..31d3cd1 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -3258,7 +3258,7 @@ xfs_attr3_leaf_inactive(
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
 			if (name_rmt->valueblk) {
 				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
-				lp->valuelen = XFS_B_TO_FSB(dp->i_mount,
+				lp->valuelen = xfs_attr3_rmt_blocks(dp->i_mount,
 						    be32_to_cpu(name_rmt->valuelen));
 				lp++;
 			}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
