Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FIiJt2218284 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:44:19 -0500
From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH 6/8] xfs: fix unsigned underflow
Date: Thu, 15 Jul 2010 22:46:45 +0400
Message-Id: <1279219605-12631-1-git-send-email-segooon@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: kernel-janitors@vger.kernel.org
Cc: Alex Elder <aelder@sgi.com>, Felix Blyakher <felixb@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>

map_len is unsigned. Checking map_len <= 0 is buggy when it should be
below zero. So, check exact expression instead of map_len.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/xfs/xfs_vnodeops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 65e0879..66d585c 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -591,9 +591,9 @@ xfs_free_eofblocks(
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)ip->i_size));
 	last_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
-	map_len = last_fsb - end_fsb;
-	if (map_len <= 0)
+	if (last_fsb <= end_fsb)
 		return 0;
+	map_len = last_fsb - end_fsb;
 
 	nimaps = 1;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
