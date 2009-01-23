Return-Path: <xfs-bounces@oss.sgi.com>
Received: from penguin4.americas.sgi.com (penguin4.americas.sgi.com
	[128.162.240.140])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0N6FE2s168297 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 00:15:15 -0600
From: Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] [XFS] Warn on transaction in flight on read-only remount
Date: Fri, 23 Jan 2009 00:14:30 -0600
Message-Id: <1232691270-3826-1-git-send-email-felixb@sgi.com>
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
To: xfs@oss.sgi.com

Till VFS can correctly support read-only remount without racing,
use WARN_ON instead of BUG_ON on detecting transaction in flight
after quiescing filesystem.

Signed-off-by: Felix Blyakher <felixb@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 2ed0353..a608e72 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -371,7 +371,11 @@ xfs_quiesce_attr(
 	/* flush inodes and push all remaining buffers out to disk */
 	xfs_quiesce_fs(mp);
 
-	ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
+	/*
+	 * Just warn here till VFS can correctly support
+	 * read-only remount without racing.
+	 */
+	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
 
 	/* Push the superblock and write an unmount record */
 	error = xfs_log_sbcount(mp, 1);
-- 
1.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
