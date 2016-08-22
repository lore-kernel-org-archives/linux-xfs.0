Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C68A7CA2
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 00:39:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 218DD304043
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 22:39:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tnh0s3G3W7XQIcK3 for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 22:39:36 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix superblock inprogress check
Date: Mon, 22 Aug 2016 15:39:27 +1000
Message-Id: <1471844367-9679-1-git-send-email-david@fromorbit.com>
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

>From inspection, the superblock sb_inprogress check is done in the
verifier and triggered only for the primary superblock via a
"bp->b_bn == XFS_SB_DADDR" check.

Unfortunately, the primary superblock is an uncached buffer, and
hence it is configured by xfs_buf_read_uncached() with:

	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */

And so this check never triggers. Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 0e3d4f5..4aecc5f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -583,7 +583,8 @@ xfs_sb_verify(
 	 * Only check the in progress field for the primary superblock as
 	 * mkfs.xfs doesn't clear it from secondary superblocks.
 	 */
-	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR,
+	return xfs_mount_validate_sb(mp, &sb,
+				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
 				     check_version);
 }
 
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
