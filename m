Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67B8729DF5
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 14:04:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 48F7A30405F
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 12:04:30 -0700 (PDT)
Received: from lynxeye.de (ns.lynxeye.de [87.118.118.114]) by cuda.sgi.com
	with ESMTP id 6kEHQrNa91eKdD4F for <xfs@oss.sgi.com>;
	Thu, 27 Aug 2015 12:04:27 -0700 (PDT)
From: Lucas Stach <dev@lynxeye.de>
Subject: [PATCH] xfs: add mssing inode cache attempts counter increment
Date: Thu, 27 Aug 2015 21:04:21 +0200
Message-Id: <1440702261-3018-1-git-send-email-dev@lynxeye.de>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Increasing the inode cache attempt counter was apparently dropped while
refactoring the cache code and so stayed at the initial 0 value. Add the
increment back to make the runtime stats more useful.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
---
 fs/xfs/xfs_icache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 76a9f27..0a326bd 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -412,6 +412,8 @@ xfs_iget(
 	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
 		return -EINVAL;
 
+	XFS_STATS_INC(xs_ig_attempts);
+
 	/* get the perag structure and ensure that it's inode capable */
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
 	agino = XFS_INO_TO_AGINO(mp, ino);
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
