Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01F197F3F
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 19:24:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1D50304048
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 17:24:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8Ic4C2qzqznNOB6y for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 17:24:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VFCVB-0000wW-0E
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 10:23:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VFCVA-0004bL-Vr
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 10:23:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: recovery of swap extents operations for CRC
	filesystems
Date: Fri, 30 Aug 2013 10:23:45 +1000
Message-Id: <1377822225-17621-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1377822225-17621-1-git-send-email-david@fromorbit.com>
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

This is the recovery side of the btree block owner change operation
performed by swapext on CRC enabled filesystems. We detect that an
owner change is needed by the flag that has been placed on the inode
log format flag field. Because the inode recovery is being replayed
after the buffers that make up the BMBT in the given checkpoint, we
can walk all the buffers and directly modify them when we see the
flag set on an inode.

Because the inode can be relogged and hence present in multiple
chekpoints with the "change owner" flag set, we could do multiple
passes across the inode to do this change. While this isn't optimal,
we can't directly ignore the flag as there may be multiple
independent swap extent operations being replayed on the same inode
in different checkpoints so we can't ignore them.

Further, because the owner change operation uses ordered buffers, we
might have buffers that are newer on disk than the current
checkpoint and so already have the owner changed in them. Hence we
cannot just peek at a buffer in the tree and check that it has the
correct owner and assume that the change was completed.

So, for the moment just brute force the owner change every time we
see an inode with the flag set. Note that we have to be careful here
because the owner of the buffers may point to either the old owner
or the new owner. Currently the verifier can't verify the owner
directly, so there is no failure case here right now. If we verify
the owner exactly in future, then we'll have to take this into
account.

This was tested in terms of normal operation via xfstests - all of
the fsr tests now pass without failure. however, we really need to
modify xfs/227 to stress v3 inodes correctly to ensure we fully
cover this case for v5 filesystems.

In terms of recovery testing, I used a hacked version of xfs_fsr
that held the temp inode open for a few seconds before exiting so
that the filesystem could be shut down with an open owner change
recovery flags set on at least the temp inode. fsr leaves the temp
inode unlinked and in btree format, so this was necessary for the
owner change to be reliably replayed.

logprint confirmed the tmp inode in the log had the correct flag set:

INO: cnt:3 total:3 a:0x69e9e0 len:56 a:0x69ea20 len:176 a:0x69eae0 len:88
        INODE: #regs:3   ino:0x44  flags:0x209   dsize:88
	                                 ^^^^^

0x200 is set, indicating a data fork owner change needed to be
replayed on inode 0x44.  A printk in the revoery code confirmed that
the inode change was recovered:

XFS (vdc): Mounting Filesystem
XFS (vdc): Starting recovery (logdev: internal)
recovering owner change ino 0x44
XFS (vdc): Version 5 superblock detected. This kernel L support enabled!
Use of these features in this kernel is at your own risk!
XFS (vdc): Ending recovery (logdev: internal)

The script used to test this was:

$ cat ./recovery-fsr.sh
#!/bin/bash

dev=/dev/vdc
mntpt=/mnt/scratch
testfile=$mntpt/testfile

umount $mntpt
mkfs.xfs -f -m crc=1 $dev
mount $dev $mntpt
chmod 777 $mntpt

for i in `seq 10000 -1 0`; do
        xfs_io -f -d -c "pwrite $(($i * 4096)) 4096" $testfile > /dev/null 2>&1
done
xfs_bmap -vp $testfile |head -20

xfs_fsr -d -v $testfile &
sleep 10
/home/dave/src/xfstests-dev/src/godown -f $mntpt
wait
umount $mntpt

xfs_logprint -t $dev |tail -20
time mount $dev $mntpt
xfs_bmap -vp $testfile
umount $mntpt
$

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_btree.c  |  26 +++++++---
 fs/xfs/xfs_bmap_btree.h  |   3 +-
 fs/xfs/xfs_bmap_util.c   |  14 +++---
 fs/xfs/xfs_btree.c       |  32 +++++++-----
 fs/xfs/xfs_btree.h       |   3 +-
 fs/xfs/xfs_icache.c      |   4 +-
 fs/xfs/xfs_icache.h      |   4 ++
 fs/xfs/xfs_inode_buf.c   |   2 +-
 fs/xfs/xfs_inode_buf.h   |  18 +++----
 fs/xfs/xfs_log_format.h  |   9 ++--
 fs/xfs/xfs_log_recover.c | 123 ++++++++++++++++++++++++++++++++++++++---------
 11 files changed, 171 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index aa2eadd..531b020 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -932,30 +932,40 @@ xfs_bmdr_maxrecs(
  * we switch forks between inodes. The operation that the caller is doing will
  * determine whether is needs to change owner before or after the switch.
  *
- * For demand paged modification, the fork switch should be done after reading
- * in all the blocks, modifying them and pinning them in the transaction. For
- * modification when the buffers are already pinned in memory, the fork switch
- * can be done before changing the owner as we won't need to validate the owner
- * until the btree buffers are unpinned and writes can occur again.
+ * For demand paged transactional modification, the fork switch should be done
+ * after reading in all the blocks, modifying them and pinning them in the
+ * transaction. For modification when the buffers are already pinned in memory,
+ * the fork switch can be done before changing the owner as we won't need to
+ * validate the owner until the btree buffers are unpinned and writes can occur
+ * again.
+ *
+ * For recovery based ownership change, there is no transactional context and
+ * so a buffer list must be supplied so that we can record the buffers that we
+ * modified for the caller to issue IO on.
  */
 int
 xfs_bmbt_change_owner(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			whichfork,
-	xfs_ino_t		new_owner)
+	xfs_ino_t		new_owner,
+	struct list_head	*buffer_list)
 {
 	struct xfs_btree_cur	*cur;
 	int			error;
 
+	ASSERT(tp || buffer_list);
+	ASSERT(!(tp && buffer_list));
 	if (whichfork == XFS_DATA_FORK)
 		ASSERT(ip->i_d.di_format = XFS_DINODE_FMT_BTREE);
 	else
 		ASSERT(ip->i_d.di_aformat = XFS_DINODE_FMT_BTREE);
 
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
-	error = xfs_btree_change_owner(cur, new_owner);
+	if (!cur)
+		return ENOMEM;
+
+	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	return error;
 }
-
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index bceac7a..e367461 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -237,7 +237,8 @@ extern int xfs_bmdr_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 
 extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
-				 int whichfork, xfs_ino_t new_owner);
+				 int whichfork, xfs_ino_t new_owner,
+				 struct list_head *buffer_list);
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ad8a91d..c6dc551 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1932,16 +1932,18 @@ xfs_swap_extents(
 	target_log_flags = XFS_ILOG_CORE;
 	if (ip->i_d.di_version == 3 &&
 	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		target_log_flags |= XFS_ILOG_OWNER;
-		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK, tip->i_ino);
+		target_log_flags |= XFS_ILOG_DOWNER;
+		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK,
+					      tip->i_ino, NULL);
 		if (error)
 			goto out_trans_cancel;
 	}
 
 	if (tip->i_d.di_version == 3 &&
 	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		src_log_flags |= XFS_ILOG_OWNER;
-		error = xfs_bmbt_change_owner(tp, tip, XFS_DATA_FORK, ip->i_ino);
+		src_log_flags |= XFS_ILOG_DOWNER;
+		error = xfs_bmbt_change_owner(tp, tip, XFS_DATA_FORK,
+					      ip->i_ino, NULL);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -1997,7 +1999,7 @@ xfs_swap_extents(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		ASSERT(ip->i_d.di_version < 3 ||
-		       (src_log_flags & XFS_ILOG_OWNER));
+		       (src_log_flags & XFS_ILOG_DOWNER));
 		src_log_flags |= XFS_ILOG_DBROOT;
 		break;
 	}
@@ -2017,7 +2019,7 @@ xfs_swap_extents(
 	case XFS_DINODE_FMT_BTREE:
 		target_log_flags |= XFS_ILOG_DBROOT;
 		ASSERT(tip->i_d.di_version < 3 ||
-		       (target_log_flags & XFS_ILOG_OWNER));
+		       (target_log_flags & XFS_ILOG_DOWNER));
 		break;
 	}
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 047573f..5690e10 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -3907,13 +3907,16 @@ xfs_btree_get_rec(
  * buffer as an ordered buffer and log it appropriately. We need to ensure that
  * we mark the region we change dirty so that if the buffer is relogged in
  * a subsequent transaction the changes we make here as an ordered buffer are
- * correctly relogged in that transaction.
+ * correctly relogged in that transaction.  If we are in recovery context, then
+ * just queue the modified buffer as delayed write buffer so the transaction
+ * recovery completion writes the changes to disk.
  */
 static int
 xfs_btree_block_change_owner(
 	struct xfs_btree_cur	*cur,
 	int			level,
-	__uint64_t		new_owner)
+	__uint64_t		new_owner,
+	struct list_head	*buffer_list)
 {
 	struct xfs_btree_block	*block;
 	struct xfs_buf		*bp;
@@ -3930,16 +3933,19 @@ xfs_btree_block_change_owner(
 		block->bb_u.s.bb_owner = cpu_to_be32(new_owner);
 
 	/*
-	 * Log owner change as an ordered buffer. If the block is a root block
-	 * hosted in an inode, we might not have a buffer pointer here and we
-	 * shouldn't attempt to log the change as the information is already
-	 * held in the inode and discarded when the root block is formatted into
-	 * the on-disk inode fork. We still change it, though, so everything is
-	 * consistent in memory.
+	 * If the block is a root block hosted in an inode, we might not have a
+	 * buffer pointer here and we shouldn't attempt to log the change as the
+	 * information is already held in the inode and discarded when the root
+	 * block is formatted into the on-disk inode fork. We still change it,
+	 * though, so everything is consistent in memory.
 	 */
 	if (bp) {
-		xfs_trans_ordered_buf(cur->bc_tp, bp);
-		xfs_btree_log_block(cur, bp, XFS_BB_OWNER);
+		if (cur->bc_tp) {
+			xfs_trans_ordered_buf(cur->bc_tp, bp);
+			xfs_btree_log_block(cur, bp, XFS_BB_OWNER);
+		} else {
+			xfs_buf_delwri_queue(bp, buffer_list);
+		}
 	} else {
 		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
 		ASSERT(level == cur->bc_nlevels - 1);
@@ -3956,7 +3962,8 @@ xfs_btree_block_change_owner(
 int
 xfs_btree_change_owner(
 	struct xfs_btree_cur	*cur,
-	__uint64_t		new_owner)
+	__uint64_t		new_owner,
+	struct list_head	*buffer_list)
 {
 	union xfs_btree_ptr     lptr;
 	int			level;
@@ -3986,7 +3993,8 @@ xfs_btree_change_owner(
 		/* for each buffer in the level */
 		do {
 			error = xfs_btree_block_change_owner(cur, level,
-							     new_owner);
+							     new_owner,
+							     buffer_list);
 		} while (!error);
 
 		if (error != ENOENT)
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 544b209..06729b6 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -445,7 +445,8 @@ int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
-int xfs_btree_change_owner(struct xfs_btree_cur *cur, __uint64_t new_owner);
+int xfs_btree_change_owner(struct xfs_btree_cur *cur, __uint64_t new_owner,
+			   struct list_head *buffer_list);
 
 /*
  * btree block CRC helpers
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 16219b9..7942432 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -48,7 +48,7 @@ STATIC void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp,
 /*
  * Allocate and initialise an xfs_inode.
  */
-STATIC struct xfs_inode *
+struct xfs_inode *
 xfs_inode_alloc(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
@@ -98,7 +98,7 @@ xfs_inode_free_callback(
 	kmem_zone_free(xfs_inode_zone, ip);
 }
 
-STATIC void
+void
 xfs_inode_free(
 	struct xfs_inode	*ip)
 {
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 8a89f7d..458e6bc 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -42,6 +42,10 @@ struct xfs_eofblocks {
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
 
+/* recovery needs direct inode allocation capability */
+struct xfs_inode * xfs_inode_alloc(struct xfs_mount *mp, xfs_ino_t ino);
+void xfs_inode_free(struct xfs_inode *ip);
+
 void xfs_reclaim_worker(struct work_struct *work);
 
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index e011d59..3d25c9a 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -196,7 +196,7 @@ xfs_imap_to_bp(
 	return 0;
 }
 
-STATIC void
+void
 xfs_dinode_from_disk(
 	xfs_icdinode_t		*to,
 	xfs_dinode_t		*from)
diff --git a/fs/xfs/xfs_inode_buf.h b/fs/xfs/xfs_inode_buf.h
index 599e6c0..abba0ae 100644
--- a/fs/xfs/xfs_inode_buf.h
+++ b/fs/xfs/xfs_inode_buf.h
@@ -32,17 +32,17 @@ struct xfs_imap {
 	ushort		im_boffset;	/* inode offset in block in bytes */
 };
 
-int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
-			       struct xfs_imap *, struct xfs_dinode **,
-			       struct xfs_buf **, uint, uint);
-int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
-			  struct xfs_inode *, uint);
-void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
-void		xfs_dinode_to_disk(struct xfs_dinode *,
-				   struct xfs_icdinode *);
+int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
+		       struct xfs_imap *, struct xfs_dinode **,
+		       struct xfs_buf **, uint, uint);
+int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
+		  struct xfs_inode *, uint);
+void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
+void	xfs_dinode_to_disk(struct xfs_dinode *to, struct xfs_icdinode *from);
+void	xfs_dinode_from_disk(struct xfs_icdinode *to, struct xfs_dinode *from);
 
 #if defined(DEBUG)
-void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
+void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index 1902c1d..5b7ba98 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -474,7 +474,8 @@ typedef struct xfs_inode_log_format_64 {
 #define	XFS_ILOG_ADATA	0x040	/* log i_af.if_data */
 #define	XFS_ILOG_AEXT	0x080	/* log i_af.if_extents */
 #define	XFS_ILOG_ABROOT	0x100	/* log i_af.i_broot */
-#define XFS_ILOG_OWNER	0x200	/* change the extent tree owner on replay */
+#define XFS_ILOG_DOWNER	0x200	/* change the data fork owner on replay */
+#define XFS_ILOG_AOWNER	0x400	/* change the attr fork owner on replay */
 
 
 /*
@@ -488,7 +489,8 @@ typedef struct xfs_inode_log_format_64 {
 #define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
 				 XFS_ILOG_UUID | XFS_ILOG_ADATA | \
-				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT)
+				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT | \
+				 XFS_ILOG_DOWNER | XFS_ILOG_AOWNER)
 
 #define	XFS_ILOG_DFORK		(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT)
@@ -500,7 +502,8 @@ typedef struct xfs_inode_log_format_64 {
 				 XFS_ILOG_DEXT | XFS_ILOG_DBROOT | \
 				 XFS_ILOG_DEV | XFS_ILOG_UUID | \
 				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
-				 XFS_ILOG_ABROOT | XFS_ILOG_TIMESTAMP)
+				 XFS_ILOG_ABROOT | XFS_ILOG_TIMESTAMP | \
+				 XFS_ILOG_DOWNER | XFS_ILOG_AOWNER)
 
 static inline int xfs_ilog_fbroot(int w)
 {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7c0c1fd..8984ec4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2629,6 +2629,82 @@ out_release:
 	return error;
 }
 
+/*
+ * Inode fork owner changes
+ *
+ * If we have been told that we have to reparent the inode fork, it's because an
+ * extent swap operation on a CRC enabled filesystem has been done and we are
+ * replaying it. We need to walk the BMBT of the appropriate fork and change the
+ * owners of it.
+ *
+ * The complexity here is that we don't have an inode context to work with, so
+ * after we've replayed the inode we need to instantiate one.  This is where the
+ * fun begins.
+ *
+ * We are in the middle of log recovery, so we can't run transactions. That
+ * means we cannot use cache coherent inode instantiation via xfs_iget(), as
+ * that will result in the corresponding iput() running the inode through
+ * xfs_inactive(). If we've just replayed an inode core that changes the link
+ * count to zero (i.e. it's been unlinked), then xfs_inactive() will run
+ * transactions (bad!).
+ *
+ * So, to avoid this, we instantiate an inode directly from the inode core we've
+ * just recovered. We have the buffer still locked, and all we really need to
+ * instantiate is the inode core and the forks being modified. We can do this
+ * manually, then run the inode btree owner change, and then tear down the
+ * xfs_inode without having to run any transactions at all.
+ *
+ * Also, because we don't have a transaction context available here but need to
+ * gather all the buffers we modify for writeback so we pass the buffer_list
+ * instead for the operation to use.
+ */
+
+STATIC int
+xfs_recover_inode_owner_change(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip,
+	struct xfs_inode_log_format *in_f,
+	struct list_head	*buffer_list)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	ASSERT(in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER));
+
+	ip = xfs_inode_alloc(mp, in_f->ilf_ino);
+	if (!ip)
+		return ENOMEM;
+
+	/* instantiate the inode */
+	xfs_dinode_from_disk(&ip->i_d, dip);
+	ASSERT(ip->i_d.di_version >= 3);
+
+	error = xfs_iformat_fork(ip, dip);
+	if (error)
+		goto out_free_ip;
+
+
+	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
+		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
+		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
+					      ip->i_ino, buffer_list);
+		if (error)
+			goto out_free_ip;
+	}
+
+	if (in_f->ilf_fields & XFS_ILOG_AOWNER) {
+		ASSERT(in_f->ilf_fields & XFS_ILOG_ABROOT);
+		error = xfs_bmbt_change_owner(NULL, ip, XFS_ATTR_FORK,
+					      ip->i_ino, buffer_list);
+		if (error)
+			goto out_free_ip;
+	}
+
+out_free_ip:
+	xfs_inode_free(ip);
+	return error;
+}
+
 STATIC int
 xlog_recover_inode_pass2(
 	struct xlog			*log,
@@ -2681,8 +2757,7 @@ xlog_recover_inode_pass2(
 	error = bp->b_error;
 	if (error) {
 		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#2)");
-		xfs_buf_relse(bp);
-		goto error;
+		goto out_release;
 	}
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, in_f->ilf_boffset);
@@ -2692,30 +2767,31 @@ xlog_recover_inode_pass2(
 	 * like an inode!
 	 */
 	if (unlikely(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))) {
-		xfs_buf_relse(bp);
 		xfs_alert(mp,
 	"%s: Bad inode magic number, dip = 0x%p, dino bp = 0x%p, ino = %Ld",
 			__func__, dip, bp, in_f->ilf_ino);
 		XFS_ERROR_REPORT("xlog_recover_inode_pass2(1)",
 				 XFS_ERRLEVEL_LOW, mp);
 		error = EFSCORRUPTED;
-		goto error;
+		goto out_release;
 	}
 	dicp = item->ri_buf[1].i_addr;
 	if (unlikely(dicp->di_magic != XFS_DINODE_MAGIC)) {
-		xfs_buf_relse(bp);
 		xfs_alert(mp,
 			"%s: Bad inode log record, rec ptr 0x%p, ino %Ld",
 			__func__, item, in_f->ilf_ino);
 		XFS_ERROR_REPORT("xlog_recover_inode_pass2(2)",
 				 XFS_ERRLEVEL_LOW, mp);
 		error = EFSCORRUPTED;
-		goto error;
+		goto out_release;
 	}
 
 	/*
 	 * If the inode has an LSN in it, recover the inode only if it's less
-	 * than the lsn of the transaction we are replaying.
+	 * than the lsn of the transaction we are replaying. Note: we still
+	 * need to replay an owner change even though the inode is more recent
+	 * than the transaction as there is no guarantee that all the btree
+	 * blocks are more recent than this transaction, too.
 	 */
 	if (dip->di_version >= 3) {
 		xfs_lsn_t	lsn = be64_to_cpu(dip->di_lsn);
@@ -2723,7 +2799,7 @@ xlog_recover_inode_pass2(
 		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
 			trace_xfs_log_recover_inode_skip(log, in_f);
 			error = 0;
-			goto out_release;
+			goto out_owner_change;
 		}
 	}
 
@@ -2745,10 +2821,9 @@ xlog_recover_inode_pass2(
 		    dicp->di_flushiter < (DI_MAX_FLUSH >> 1)) {
 			/* do nothing */
 		} else {
-			xfs_buf_relse(bp);
 			trace_xfs_log_recover_inode_skip(log, in_f);
 			error = 0;
-			goto error;
+			goto out_release;
 		}
 	}
 
@@ -2760,13 +2835,12 @@ xlog_recover_inode_pass2(
 		    (dicp->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
 					 XFS_ERRLEVEL_LOW, mp, dicp);
-			xfs_buf_relse(bp);
 			xfs_alert(mp,
 		"%s: Bad regular inode log record, rec ptr 0x%p, "
 		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
 				__func__, item, dip, bp, in_f->ilf_ino);
 			error = EFSCORRUPTED;
-			goto error;
+			goto out_release;
 		}
 	} else if (unlikely(S_ISDIR(dicp->di_mode))) {
 		if ((dicp->di_format != XFS_DINODE_FMT_EXTENTS) &&
@@ -2774,19 +2848,17 @@ xlog_recover_inode_pass2(
 		    (dicp->di_format != XFS_DINODE_FMT_LOCAL)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
 					     XFS_ERRLEVEL_LOW, mp, dicp);
-			xfs_buf_relse(bp);
 			xfs_alert(mp,
 		"%s: Bad dir inode log record, rec ptr 0x%p, "
 		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
 				__func__, item, dip, bp, in_f->ilf_ino);
 			error = EFSCORRUPTED;
-			goto error;
+			goto out_release;
 		}
 	}
 	if (unlikely(dicp->di_nextents + dicp->di_anextents > dicp->di_nblocks)){
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
-		xfs_buf_relse(bp);
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, "
 	"dino bp 0x%p, ino %Ld, total extents = %d, nblocks = %Ld",
@@ -2794,29 +2866,27 @@ xlog_recover_inode_pass2(
 			dicp->di_nextents + dicp->di_anextents,
 			dicp->di_nblocks);
 		error = EFSCORRUPTED;
-		goto error;
+		goto out_release;
 	}
 	if (unlikely(dicp->di_forkoff > mp->m_sb.sb_inodesize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
-		xfs_buf_relse(bp);
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, "
 	"dino bp 0x%p, ino %Ld, forkoff 0x%x", __func__,
 			item, dip, bp, in_f->ilf_ino, dicp->di_forkoff);
 		error = EFSCORRUPTED;
-		goto error;
+		goto out_release;
 	}
 	isize = xfs_icdinode_size(dicp->di_version);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
-		xfs_buf_relse(bp);
 		xfs_alert(mp,
 			"%s: Bad inode log record length %d, rec ptr 0x%p",
 			__func__, item->ri_buf[1].i_len, item);
 		error = EFSCORRUPTED;
-		goto error;
+		goto out_release;
 	}
 
 	/* The core is in in-core format */
@@ -2842,7 +2912,7 @@ xlog_recover_inode_pass2(
 	}
 
 	if (in_f->ilf_size == 2)
-		goto write_inode_buffer;
+		goto out_owner_change;
 	len = item->ri_buf[2].i_len;
 	src = item->ri_buf[2].i_addr;
 	ASSERT(in_f->ilf_size <= 4);
@@ -2903,13 +2973,15 @@ xlog_recover_inode_pass2(
 		default:
 			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
 			ASSERT(0);
-			xfs_buf_relse(bp);
 			error = EIO;
-			goto error;
+			goto out_release;
 		}
 	}
 
-write_inode_buffer:
+out_owner_change:
+	if (in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER))
+		error = xfs_recover_inode_owner_change(mp, dip, in_f,
+						       buffer_list);
 	/* re-generate the checksum. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
 
@@ -2923,6 +2995,9 @@ error:
 	if (need_free)
 		kmem_free(in_f);
 	return XFS_ERROR(error);
+
+	xfs_buf_relse(bp);
+	goto error;
 }
 
 /*
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
