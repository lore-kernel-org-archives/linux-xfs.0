Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3G5EnMx171537 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 00:14:49 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	miBCknlOkqUGrXE2 for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 22:14:48 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SJeGU-0000mB-7Q
	for xfs@oss.sgi.com; Mon, 16 Apr 2012 15:14:14 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SJeGU-0005N9-4g
	for xfs@oss.sgi.com; Mon, 16 Apr 2012 15:14:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] xfs: move xfs_fsb_to_db to xfs_bmap.h
Date: Mon, 16 Apr 2012 15:14:08 +1000
Message-Id: <1334553251-20571-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1334553251-20571-1-git-send-email-david@fromorbit.com>
References: <1334553251-20571-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

This is the only remaining useful function in xfs_rw.h, so move it
to a header file responsible for block mapping functions that the
callers already include. Soon we can get rid of xfs_rw.h.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c |   13 +++++++++++++
 fs/xfs/xfs_bmap.h |    3 +++
 fs/xfs/xfs_rw.h   |   14 --------------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 85e7e32..1e58bc3 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6157,3 +6157,16 @@ next_block:
 
 	return error;
 }
+
+/*
+ * Convert the given file system block to a disk block.  We have to treat it
+ * differently based on whether the file is a real time file or not, because the
+ * bmap code does.
+ */
+xfs_daddr_t
+xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
+{
+	return (XFS_IS_REALTIME_INODE(ip) ? \
+		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
+		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
+}
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 89ee672..803b56d 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -211,6 +211,9 @@ int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, int *count);
 int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
+
+xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_rw.h b/fs/xfs/xfs_rw.h
index 967b3a4..13f6317 100644
--- a/fs/xfs/xfs_rw.h
+++ b/fs/xfs/xfs_rw.h
@@ -23,20 +23,6 @@ struct xfs_inode;
 struct xfs_mount;
 
 /*
- * Convert the given file system block to a disk block.
- * We have to treat it differently based on whether the
- * file is a real time file or not, because the bmap code
- * does.
- */
-static inline xfs_daddr_t
-xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
-{
-	return (XFS_IS_REALTIME_INODE(ip) ? \
-		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
-		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
-}
-
-/*
  * Prototypes for functions in xfs_rw.c.
  */
 extern xfs_extlen_t xfs_get_extsz_hint(struct xfs_inode *ip);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
