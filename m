Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0hvXu124866 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:43:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F300256222
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	FUxR8AKVTHIe5fJM for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:17 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52231955-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:16 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohC-0000UW-7x
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogu-0002GC-PE
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/12] xfs: convert xfs_cmn_err to xfs_alert_tag
Date: Wed, 12 Jan 2011 11:35:46 +1100
Message-Id: <1294792553-8378-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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

Continue the conversion of the old cmn_err interface be converting
all the conditional panic tag errors to xfs_alert_tag() and then
removing xfs_cmn_err().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/support/debug.c |   28 ----------------------------
 fs/xfs/support/debug.h |    2 --
 fs/xfs/xfs_bmap.c      |    2 +-
 fs/xfs/xfs_error.c     |    5 ++---
 fs/xfs/xfs_error.h     |    6 ++----
 fs/xfs/xfs_inode.c     |   40 ++++++++++++++++++++--------------------
 fs/xfs/xfs_iomap.c     |    2 +-
 fs/xfs/xfs_rw.c        |   23 +++++++++--------------
 fs/xfs/xfs_trans_ail.c |    2 +-
 9 files changed, 36 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index 262b099..b93b75d 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -64,34 +64,6 @@ xfs_fs_cmn_err(
 	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
 }
 
-/* All callers to xfs_cmn_err use CE_ALERT, so don't bother testing lvl */
-void
-xfs_cmn_err(
-	int			panic_tag,
-	const char		*lvl,
-	struct xfs_mount	*mp,
-	const char		*fmt,
-	...)
-{
-	struct va_format	vaf;
-	va_list			args;
-	int			panic = 0;
-
-	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
-		printk(KERN_ALERT "XFS: Transforming an alert into a BUG.");
-		panic = 1;
-	}
-
-	va_start(args, fmt);
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	printk(KERN_ALERT "Filesystem %s: %pV", mp->m_fsname, &vaf);
-	va_end(args);
-
-	BUG_ON(panic);
-}
-
 void
 assfail(char *expr, char *file, int line)
 {
diff --git a/fs/xfs/support/debug.h b/fs/xfs/support/debug.h
index 05699f6..eaeaa17 100644
--- a/fs/xfs/support/debug.h
+++ b/fs/xfs/support/debug.h
@@ -33,8 +33,6 @@ void cmn_err(const char *lvl, const char *fmt, ...)
 		__attribute__ ((format (printf, 2, 3)));
 void xfs_fs_cmn_err( const char *lvl, struct xfs_mount *mp,
 		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
-void xfs_cmn_err( int panic_tag, const char *lvl, struct xfs_mount *mp,
-		const char *fmt, ...) __attribute__ ((format (printf, 4, 5)));
 
 extern void assfail(char *expr, char *f, int l);
 
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4111cd3..500c5c7 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3500,7 +3500,7 @@ xfs_bmap_search_extents(
 
 	if (unlikely(!(gotp->br_startblock) && (*lastxp != NULLEXTNUM) &&
 		     !(XFS_IS_REALTIME_INODE(ip) && fork == XFS_DATA_FORK))) {
-		xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, ip->i_mount,
+		xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
 				"Access to block zero in inode %llu "
 				"start_block: %llx start_off: %llx "
 				"blkcnt: %llx extent-state: %x lastx: %x\n",
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 4c7db74..34f0e2d 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -162,9 +162,8 @@ xfs_error_report(
 	inst_t			*ra)
 {
 	if (level <= xfs_error_level) {
-		xfs_cmn_err(XFS_PTAG_ERROR_REPORT,
-			    CE_ALERT, mp,
-		"XFS internal error %s at line %d of file %s.  Caller 0x%p\n",
+		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
+		"Internal error %s at line %d of file %s.  Caller 0x%p\n",
 			    tag, linenum, filename, ra);
 
 		xfs_stack_trace();
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 10dce54..e1ba2d2 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -145,10 +145,8 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp, int loud);
 #endif /* DEBUG */
 
 /*
- * XFS panic tags -- allow a call to xfs_cmn_err() be turned into
- *			a panic by setting xfs_panic_mask in a
- *			sysctl.  update xfs_max[XFS_PARAM] if
- *			more are added.
+ * XFS panic tags -- allow a call to xfs_alert_tag() be turned into
+ *			a panic by setting xfs_panic_mask in a sysctl.
  */
 #define		XFS_NO_PTAG			0
 #define		XFS_PTAG_IFLUSH			0x00000001
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index be7cf62..a035fa8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2939,16 +2939,16 @@ xfs_iflush_int(
 
 	if (XFS_TEST_ERROR(be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC,
 			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
-		xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
-		    "xfs_iflush: Bad inode %Lu magic number 0x%x, ptr 0x%p",
-			ip->i_ino, be16_to_cpu(dip->di_magic), dip);
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: Bad inode %Lu magic number 0x%x, ptr 0x%p",
+			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_magic != XFS_DINODE_MAGIC,
 				mp, XFS_ERRTAG_IFLUSH_2, XFS_RANDOM_IFLUSH_2)) {
-		xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
-			"xfs_iflush: Bad inode %Lu, ptr 0x%p, magic number 0x%x",
-			ip->i_ino, ip, ip->i_d.di_magic);
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: Bad inode %Lu, ptr 0x%p, magic number 0x%x",
+			__func__, ip->i_ino, ip, ip->i_d.di_magic);
 		goto corrupt_out;
 	}
 	if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
@@ -2956,9 +2956,9 @@ xfs_iflush_int(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
 		    mp, XFS_ERRTAG_IFLUSH_3, XFS_RANDOM_IFLUSH_3)) {
-			xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
-				"xfs_iflush: Bad regular inode %Lu, ptr 0x%p",
-				ip->i_ino, ip);
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad regular inode %Lu, ptr 0x%p",
+				__func__, ip->i_ino, ip);
 			goto corrupt_out;
 		}
 	} else if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
@@ -2967,28 +2967,28 @@ xfs_iflush_int(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
 		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
 		    mp, XFS_ERRTAG_IFLUSH_4, XFS_RANDOM_IFLUSH_4)) {
-			xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
-				"xfs_iflush: Bad directory inode %Lu, ptr 0x%p",
-				ip->i_ino, ip);
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad directory inode %Lu, ptr 0x%p",
+				__func__, ip->i_ino, ip);
 			goto corrupt_out;
 		}
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
 				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5,
 				XFS_RANDOM_IFLUSH_5)) {
-		xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
-			"xfs_iflush: detected corrupt incore inode %Lu, total extents = %d, nblocks = %Ld, ptr 0x%p",
-			ip->i_ino,
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: detected corrupt incore inode %Lu, "
+			"total extents = %d, nblocks = %Ld, ptr 0x%p",
+			__func__, ip->i_ino,
 			ip->i_d.di_nextents + ip->i_d.di_anextents,
-			ip->i_d.di_nblocks,
-			ip);
+			ip->i_d.di_nblocks, ip);
 		goto corrupt_out;
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
 				mp, XFS_ERRTAG_IFLUSH_6, XFS_RANDOM_IFLUSH_6)) {
-		xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
-			"xfs_iflush: bad inode %Lu, forkoff 0x%x, ptr 0x%p",
-			ip->i_ino, ip->i_d.di_forkoff, ip);
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: bad inode %Lu, forkoff 0x%x, ptr 0x%p",
+			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
 		goto corrupt_out;
 	}
 	/*
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 55582bd..4a19da0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -105,7 +105,7 @@ xfs_cmn_err_fsblock_zero(
 	xfs_inode_t	*ip,
 	xfs_bmbt_irec_t	*imap)
 {
-	xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, ip->i_mount,
+	xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
 			"Access to block zero in inode %llu "
 			"start_block: %llx start_off: %llx "
 			"blkcnt: %llx extent-state: %x\n",
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 56861d5..c3ef00d 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -69,25 +69,20 @@ xfs_do_force_shutdown(
 		return;
 
 	if (flags & SHUTDOWN_CORRUPT_INCORE) {
-		xfs_cmn_err(XFS_PTAG_SHUTDOWN_CORRUPT, CE_ALERT, mp,
-    "Corruption of in-memory data detected.  Shutting down filesystem: %s",
-			mp->m_fsname);
-		if (XFS_ERRLEVEL_HIGH <= xfs_error_level) {
+		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
+    "Corruption of in-memory data detected.  Shutting down filesystem");
+		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
 			xfs_stack_trace();
-		}
 	} else if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
 		if (logerror) {
-			xfs_cmn_err(XFS_PTAG_SHUTDOWN_LOGERROR, CE_ALERT, mp,
-		"Log I/O Error Detected.  Shutting down filesystem: %s",
-				mp->m_fsname);
+			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
+		"Log I/O Error Detected.  Shutting down filesystem");
 		} else if (flags & SHUTDOWN_DEVICE_REQ) {
-			xfs_cmn_err(XFS_PTAG_SHUTDOWN_IOERROR, CE_ALERT, mp,
-		"All device paths lost.  Shutting down filesystem: %s",
-				mp->m_fsname);
+			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
+		"All device paths lost.  Shutting down filesystem");
 		} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
-			xfs_cmn_err(XFS_PTAG_SHUTDOWN_IOERROR, CE_ALERT, mp,
-		"I/O Error Detected.  Shutting down filesystem: %s",
-				mp->m_fsname);
+			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
+		"I/O Error Detected. Shutting down filesystem");
 		}
 	}
 	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index c5bbbc4..12aff95 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -563,7 +563,7 @@ xfs_trans_ail_delete_bulk(
 
 			spin_unlock(&ailp->xa_lock);
 			if (!XFS_FORCED_SHUTDOWN(mp)) {
-				xfs_cmn_err(XFS_PTAG_AILDELETE, CE_ALERT, mp,
+				xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 		"%s: attempting to delete a log item that is not in the AIL",
 						__func__);
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
