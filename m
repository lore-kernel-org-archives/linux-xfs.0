Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A17577CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71E918F8059
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AW02kkDTKV2Uyuia for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:05 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ukvj6-0005St-Gu
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ukvj6-00030t-7S
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/12] xfs: fix da node magic number mismatches
Date: Fri,  7 Jun 2013 22:24:50 +1000
Message-Id: <1370607901-11538-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_da_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index a76962d..e83a3ad 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -288,8 +288,8 @@ xfs_da3_node_read(
 		int			type;
 
 		switch (be16_to_cpu(info->magic)) {
-		case XFS_DA3_NODE_MAGIC:
 		case XFS_DA_NODE_MAGIC:
+		case XFS_DA3_NODE_MAGIC:
 			type = XFS_BLFT_DA_NODE_BUF;
 			break;
 		case XFS_ATTR_LEAF_MAGIC:
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
