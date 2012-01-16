Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9802RJU091316 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 19:02:27 -0500
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/1] xfs: kill the unused XFS_BB_FSB_OFFSET macro
Date: Mon, 16 Jan 2012 17:54:36 +0530
Message-Id: <1326716676-11842-1-git-send-email-amit.sahrawat83@gmail.com>
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
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, Amit Sahrawat <amit.sahrawat83@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Removing the macro, as this is no more needed in the code.
Tried to find the reference when it was last used - but the usage
for this seemed to have been dropped long time ago.

Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_sb.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index cb6ae71..f429d9d 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -529,7 +529,6 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 #define	XFS_BB_TO_FSB(mp,bb)	\
 	(((bb) + (XFS_FSB_TO_BB(mp,1) - 1)) >> (mp)->m_blkbb_log)
 #define	XFS_BB_TO_FSBT(mp,bb)	((bb) >> (mp)->m_blkbb_log)
-#define	XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))
 
 /*
  * File system block to byte conversions.
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
