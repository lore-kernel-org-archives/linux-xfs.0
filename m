Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 416A929DF6
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 07:21:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30106304043
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 05:21:08 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id HC82dJnMq3xOoGlf (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 05:21:07 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/6] xfsprogs: use "unsigned short" instead of ushort
Date: Sun, 26 Jul 2015 08:20:54 -0400
Message-Id: <1437913255-7524-6-git-send-email-tytso@mit.edu>
In-Reply-To: <1437913255-7524-1-git-send-email-tytso@mit.edu>
References: <1437913255-7524-1-git-send-email-tytso@mit.edu>
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
To: xfs@oss.sgi.com
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org

Android's bionic libc doesn't define ushort.  There isn't a real
benefit (other than perhaps conciseness) to use ushort over "unsigned
short", and it's only used in a handful of files in xfsprogs.  So
change over to using unsigned short everywhere.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 include/xfs_inode_buf.h   | 4 ++--
 include/xfs_log_format.h  | 4 ++--
 include/xfs_log_recover.h | 2 +-
 libxfs/logitem.c          | 2 +-
 libxfs/xfs_ialloc.c       | 4 ++--
 logprint/log_misc.c       | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/xfs_inode_buf.h b/include/xfs_inode_buf.h
index 9308c47..d2ebbe6 100644
--- a/include/xfs_inode_buf.h
+++ b/include/xfs_inode_buf.h
@@ -28,8 +28,8 @@ struct xfs_icdinode;
  */
 struct xfs_imap {
 	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
-	ushort		im_len;		/* length in BBs of inode chunk */
-	ushort		im_boffset;	/* inode offset in block in bytes */
+	unsigned short	im_len;		/* length in BBs of inode chunk */
+	unsigned short	im_boffset;	/* inode offset in block in bytes */
 };
 
 int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index f0969c7..af212fb 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -456,8 +456,8 @@ static inline uint xfs_icdinode_size(int version)
 typedef struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
 	unsigned short	blf_size;	/* size of this item */
-	ushort		blf_flags;	/* misc state */
-	ushort		blf_len;	/* number of blocks in this buf */
+	unsigned short	blf_flags;	/* misc state */
+	unsigned short	blf_len;	/* number of blocks in this buf */
 	__int64_t	blf_blkno;	/* starting blkno of this buf */
 	unsigned int	blf_map_size;	/* used size of data bitmap in words */
 	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
diff --git a/include/xfs_log_recover.h b/include/xfs_log_recover.h
index 1c55ccb..2fea63d 100644
--- a/include/xfs_log_recover.h
+++ b/include/xfs_log_recover.h
@@ -52,7 +52,7 @@ typedef struct xlog_recover {
 	struct list_head	r_itemq;	/* q for items */
 } xlog_recover_t;
 
-#define ITEM_TYPE(i)	(*(ushort *)(i)->ri_buf[0].i_addr)
+#define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].i_addr)
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 73d5a9e..2cc29b6 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -112,7 +112,7 @@ xfs_buf_item_init(
 	bip->bli_buf = bp;
 	bip->bli_format.blf_type = XFS_LI_BUF;
 	bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
-	bip->bli_format.blf_len = (ushort)BTOBB(XFS_BUF_COUNT(bp));
+	bip->bli_format.blf_len = (unsigned short)BTOBB(XFS_BUF_COUNT(bp));
 	XFS_BUF_SET_FSPRIVATE(bp, bip);
 }
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b20a9ec..89a57f5 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1784,7 +1784,7 @@ xfs_imap(
 
 		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 		imap->im_len = XFS_FSB_TO_BB(mp, 1);
-		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
+		imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 		return 0;
 	}
 
@@ -1812,7 +1812,7 @@ out_map:
 
 	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
-	imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
+	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 
 	/*
 	 * If the inode number maps to a block outside the bounds
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index c0a5c97..e0aee1c 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -252,7 +252,7 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr, int len, int *i, int num_ops)
     xfs_buf_log_format_t lbuf;
     int			 size, blen, map_size, struct_size;
     __be64		 x, y;
-    ushort		 flags;
+    unsigned short	 flags;
 
     /*
      * memmove to ensure 8-byte alignment for the long longs in
-- 
2.3.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
