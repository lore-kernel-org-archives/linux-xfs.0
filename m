Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5672C7F92
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 06:44:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A888304043
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 04:44:09 -0800 (PST)
Received: from lists.s-osg.org (lists.s-osg.org [54.187.51.154]) by
	cuda.sgi.com with ESMTP id xiPFcaEAKHRAjhM4 for
	<xfs@oss.sgi.com>; Thu, 25 Feb 2016 04:44:07 -0800 (PST)
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] xfs: remove impossible condition
Date: Thu, 25 Feb 2016 12:43:57 +0000
Message-Id: <1456404237-18169-1-git-send-email-luisbg@osg.samsung.com>
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
To: linux-kernel@vger.kernel.org
Cc: cmaiolino@redhat.com, darrick.wong@oracle.com, namjae.jeon@samsung.com, bfoster@redhat.com, sandeen@sandeen.net, xfs@oss.sgi.com, Luis de Bethencourt <luisbg@osg.samsung.com>, billodo@redhat.com

bp_release is set to 0 just before the breakpoint of the for loop before
the conditional check (in line 458). The other breakpoint is a goto that
skips the dead code.

Addresses-Coverity-Id: 102338

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

Thanks for reviewing this :)

Luis

 fs/xfs/libxfs/xfs_bmap.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a05166..1171795 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -477,10 +477,7 @@ xfs_bmap_check_leaf_extents(
 		}
 		block = XFS_BUF_TO_BLOCK(bp);
 	}
-	if (bp_release) {
-		bp_release = 0;
-		xfs_trans_brelse(NULL, bp);
-	}
+
 	return;
 
 error0:
-- 
2.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
