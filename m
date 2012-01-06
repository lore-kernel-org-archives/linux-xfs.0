Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q06B0qjI014463 for <xfs@oss.sgi.com>; Fri, 6 Jan 2012 05:00:52 -0600
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 2/2] xfs: cleanup XFS_BB_FSB_OFFSET
Date: Fri,  6 Jan 2012 16:42:18 +0530
Message-Id: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
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
To: Alex Elder <aelder@sgi.com>, Ben Myers <bpm@sgi.com>, xfs masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>, linux kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Amit Sahrawat <amit.sahrawat83@gmail.com>

Removing the macro, as this is no more needed in the code. 
Tried to find the reference when it was last used - but the usage 
for this seemed to have been dropped long time ago.

Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
