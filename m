Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB57A3um024083 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 01:10:03 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 25328304064
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 23:09:58 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id SAA15599 for <xfs@oss.sgi.com>;
	Fri, 5 Dec 2008 18:09:57 +1100
Message-ID: <4938D3E0.5050501@sgi.com>
Date: Fri, 05 Dec 2008 18:10:24 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [RFC, PATCH] XFS_TRANS_DEBUG fixes
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

XFS_TRANS_DEBUG is not enabled on a debug build and has suffered some bit rot.
Below is a set of fixes to get it working again.  Whether it's of any use I don't
know but if we are going to carry the code we might as well make it work.

Some of the things I had to do to get it to work (and could be done some other
way) are:
- all buffers that are logged need to be mapped into kernel space so the
   debugging code can make a copy of the buffer data and compare it later.
   The easiest way to do that is to make all buffers mapped in xfs_bug_get_flags()
   when XFS_TRANS_DEBUG is set.
- turning XFS_TRANS_DEBUG on does make the system run really slow (even slower
   than a normal debug build) so we might want to keep it optional.
- Some bit setting functions (btst()/bset()/bfset()) appear to be missing so
   I've coded up some trivial versions.  There maybe some linux kernel functions
   that do the same thing.
- the transaction debugging code will detect if we have modified more data in a
   buffer than we have indicated to be logged.  This picked up two places where
   we modify a inode cluster buffer without logging it - firstly when we create
   a new inode cluster we zero the entire buffer but only log the inode fields
   (ie data after the xfs_dicore_t finishes is modified) and secondly the bulkstat
   hack that zeroes the di_mode.  I don't know if not logging these buffer changes
   is actually a bug or not.

Is this debugging code worth hanging onto or should we just ditch the whole lot?

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index cd89c56..4ee182c 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -584,6 +584,10 @@ xfs_buf_get_flags(
  	xfs_buf_t		*bp, *new_bp;
  	int			error = 0, i;

+#ifdef XFS_TRANS_DEBUG
+	flags |= XBF_MAPPED;
+#endif
+
  	new_bp = xfs_buf_allocate(flags);
  	if (unlikely(!new_bp))
  		return NULL;
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index 17254b5..3df4a54 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -38,6 +38,7 @@
  #define XFS_RW_TRACE 1
  #define XFS_BUF_TRACE 1
  #define XFS_INODE_TRACE 1
+#define XFS_TRANS_DEBUG 1
  #define XFS_FILESTREAMS_TRACE 1
  #endif

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d245d04..bb019a0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -35,6 +35,37 @@ kmem_zone_t	*xfs_buf_item_zone;

  #ifdef XFS_TRANS_DEBUG
  /*
+ * Test bit b in bitmap bp
+ */
+int
+btst(char *bp, int b)
+{
+	return (*(bp + (b >> 3)) & (0x80 >> (b & 0x7)));
+}
+
+/*
+ * Set bit b in bitmap bp
+ */
+void
+bset(char *bp, int b)
+{
+	*(bp + (b >> 3)) |= (0x80 >> (b & 0x7));
+}
+
+/*
+ * Set a bit field of length len in bitmap bp starting at b
+ */
+void
+bfset(char *bp, int b, int len)
+{
+	while (len) {
+		bset(bp, b);
+		len--;
+		b++;
+	}
+}
+
+/*
   * This function uses an alternate strategy for tracking the bytes
   * that the user requests to be logged.  This can then be used
   * in conjunction with the bli_orig array in the buf log item to
@@ -126,7 +157,7 @@ xfs_buf_item_log_check(
  	for (x = 0; x < XFS_BUF_COUNT(bp); x++) {
  		if (orig[x] != buffer[x] && !btst(bip->bli_logged, x))
  			cmn_err(CE_PANIC,
-	"xfs_buf_item_log_check bip %x buffer %x orig %x index %d",
+	"xfs_buf_item_log_check bip %p buffer %p orig %p index %d",
  				bip, bp, orig, x);
  	}
  }
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index e6ebbae..681d622 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -353,6 +353,8 @@ xfs_ialloc_ag_alloc(
  		 *      transactions causing a lot of log traffic.
  		 */
  		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
+		xfs_trans_log_buf(tp, fbuf, 0,
+				(ninodes << args.mp->m_sb.sb_inodelog) - 1);
  		for (i = 0; i < ninodes; i++) {
  			int	ioffset = i << args.mp->m_sb.sb_inodelog;
  			uint	isize = sizeof(struct xfs_dinode);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 063da34..9d5df3a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2121,6 +2121,7 @@ xfs_ifree(
  {
  	int			error;
  	int			delete;
+	int			offset;
  	xfs_ino_t		first_ino;
  	xfs_dinode_t    	*dip;
  	xfs_buf_t       	*ibp;
@@ -2179,6 +2180,8 @@ xfs_ifree(
  	* in the future.
  	*/
  	dip->di_mode = 0;
+	offset = ip->i_imap.im_boffset + offsetof(xfs_dinode_t, di_mode);
+	xfs_trans_log_buf(tp, ibp, offset, (offset + sizeof(__be16) - 1));

  	if (delete) {
  		xfs_ifree_cluster(ip, tp, first_ino);
@@ -2598,9 +2601,7 @@ xfs_iflush_fork(
  	char			*cp;
  	xfs_ifork_t		*ifp;
  	xfs_mount_t		*mp;
-#ifdef XFS_TRANS_DEBUG
-	int			first;
-#endif
+
  	static const short	brootflag[2] =
  		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
  	static const short	dataflag[2] =
@@ -3004,9 +3005,6 @@ xfs_iflush_int(
  	xfs_inode_log_item_t	*iip;
  	xfs_dinode_t		*dip;
  	xfs_mount_t		*mp;
-#ifdef XFS_TRANS_DEBUG
-	int			first;
-#endif

  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
  	ASSERT(!completion_done(&ip->i_flush));

--- a/fs/xfs/xfsidbg.c	2008-12-04 14:04:58.000000000 +1100
+++ b/fs/xfs/xfsidbg.c	2008-12-04 13:58:54.000000000 +1100
@@ -3231,7 +3208,7 @@ xfs_buf_item_print(xfs_buf_log_item_t *b
  	kdb_printf("blf flags: ");
  	printflags((uint)blip->bli_format.blf_flags, blf_flags, NULL);
  #ifdef XFS_TRANS_DEBUG
-	kdb_printf("orig 0x%x logged 0x%x",
+	kdb_printf("orig 0x%p logged 0x%p",
  		blip->bli_orig, blip->bli_logged);
  #endif
  	kdb_printf("\n");
@@ -3599,7 +3576,7 @@ xfs_inode_item_print(xfs_inode_log_item_
  		ilip->ili_ilock_recur, ilip->ili_iolock_recur,
  		ilip->ili_extents_buf);
  #ifdef XFS_TRANS_DEBUG
-	kdb_printf("root bytes %d root orig 0x%x\n",
+	kdb_printf("root bytes %d root orig 0x%p\n",
  		ilip->ili_root_size, ilip->ili_orig_root);
  #endif
  	kdb_printf("size %d ", ilip->ili_format.ilf_size);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
