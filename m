Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CACF7F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 23:31:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D3998F8033
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 21:31:37 -0800 (PST)
Message-ID: <51230E31.6050103@oracle.com>
Date: Tue, 19 Feb 2013 13:31:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 3/3] xfsprogs:
	s/max_attrset_trans_res_adjust/max_attrsetm_trans_res_adjust/
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
Cc: Mark Tinguely <tinguely@sgi.com>

Rename max_attrset_trans_res_adjust to max_attrsetm_trans_res_adjust to
indicate that we does it at mount time.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 mkfs/maxtrres.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index beb81f8..f12cc70 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -28,7 +28,7 @@
 #include "xfs_mkfs.h"
 
 static void
-max_attrset_trans_res_adjust(
+max_attrsetm_trans_res_adjust(
 	xfs_mount_t			*mp)
 {
 	int				local;
@@ -94,7 +94,7 @@ max_trans_res(
 			(dirversion == 2 ? XFS_SB_VERSION_DIRV2BIT : 0);
 
 	libxfs_mount(&mount, sbp, 0,0,0,0);
-	max_attrset_trans_res_adjust(&mount);
+	max_attrsetm_trans_res_adjust(&mount);
 	maxres = max_trans_res_by_mount(&mount);
 	maxfsb = XFS_B_TO_FSB(&mount, maxres);
 	libxfs_umount(&mount);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
