Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 325967CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 16:27:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F329A8F804B
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 14:27:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	k0d4EHnooiLN8gmm for <xfs@oss.sgi.com>;
	Tue, 28 May 2013 14:27:40 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UhRQS-00047z-Ui
	for xfs@oss.sgi.com; Wed, 29 May 2013 07:27:24 +1000
Date: Wed, 29 May 2013 07:27:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/9] xfs: fix remote attribute invalidation for a leaf
Message-ID: <20130528212724.GB29338@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
