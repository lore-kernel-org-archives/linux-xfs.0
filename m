Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 52D8D7CBF
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 23:13:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 319B88F8066
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 21:13:18 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FVqb038MwkYchzTv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 21:13:14 -0700 (PDT)
Message-ID: <514A88C3.2030204@oracle.com>
Date: Thu, 21 Mar 2013 12:12:51 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: get new buffer for secondary superblocks from the first
	new AG
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

In growfs operation, the unused parts of superblocks in the latest old AG are
zero filled, hence we can safely read the secondary superblock buffer of it
rather than getting a new buffer for it again.

This is a small refinement for commits 1375cb65.

Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_fsops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 94eaeed..7d435dd 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -449,7 +449,7 @@ xfs_growfs_data_private(
 		 * disk as the contents of the new area we are growing into is
 		 * completely unknown.
 		 */
-		if (agno < oagcount) {
+		if (agno <= oagcount) {
 			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 				  XFS_FSS_TO_BB(mp, 1), 0, &bp,
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
