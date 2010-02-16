Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jbIT132009 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C28013ACA25
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wkjDyDGTkYsU7h44 for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Message-Id: <20100216084651.741574957@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/10] quota: clean up Q_XQUOTASYNC
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=cleanup-Q_XQUOTASYNC
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
To: jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, swhiteho@redhat.com, xfs@oss.sgi.com

Currently Q_XQUOTASYNC calls into the quota_sync method, but XFS does something
entirely different in it than the rest of the filesystems.  xfs_quota which
calls Q_XQUOTASYNC expects an asynchronous data writeout to flush delayed
allocations, while the "VFS" quota support wants to flush changes to the quota
file.

So make Q_XQUOTASYNC call into the writeback code directly and make the
quota_sync method optional as XFS doesn't need in the sense expected by the
rest of the quota code.

GFS2 was using limited XFS-style quota and has a quota_sync method fitting
neither the style used by vfs_quota_sync nor xfs_fs_quota_sync.  I left it
in for now as per discussion with Steve it expects to be called from the
sync path this way.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-16 00:15:27.136003612 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-16 00:16:03.263004031 +0100
@@ -18,6 +18,7 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/types.h>
+#include <linux/writeback.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
@@ -52,7 +53,7 @@ void sync_quota_sb(struct super_block *s
 {
 	int cnt;
 
-	if (!sb->s_qcop->quota_sync)
+	if (!sb->s_qcop || !sb->s_qcop->quota_sync)
 		return;
 
 	sb->s_qcop->quota_sync(sb, type);
@@ -318,9 +319,11 @@ static int do_quotactl(struct super_bloc
 	case Q_XGETQUOTA:
 		return quota_getxquota(sb, type, id, addr);
 	case Q_XQUOTASYNC:
-		if (!sb->s_qcop->quota_sync)
-			return -ENOSYS;
-		return sb->s_qcop->quota_sync(sb, type);
+		/* caller already holds s_umount */
+		if (sb->s_flags & MS_RDONLY)
+			return -EROFS;
+		writeback_inodes_sb(sb);
+		return 0;
 	default:
 		return -EINVAL;
 	}
Index: linux-2.6/fs/xfs/linux-2.6/xfs_quotaops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_quotaops.c	2010-02-16 00:13:44.399004869 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_quotaops.c	2010-02-16 00:15:27.709004380 +0100
@@ -44,20 +44,6 @@ xfs_quota_type(int type)
 }
 
 STATIC int
-xfs_fs_quota_sync(
-	struct super_block	*sb,
-	int			type)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	if (sb->s_flags & MS_RDONLY)
-		return -EROFS;
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
-	return -xfs_sync_data(mp, 0);
-}
-
-STATIC int
 xfs_fs_get_xstate(
 	struct super_block	*sb,
 	struct fs_quota_stat	*fqs)
@@ -151,7 +137,6 @@ xfs_fs_set_xquota(
 }
 
 const struct quotactl_ops xfs_quotactl_operations = {
-	.quota_sync		= xfs_fs_quota_sync,
 	.get_xstate		= xfs_fs_get_xstate,
 	.set_xstate		= xfs_fs_set_xstate,
 	.get_xquota		= xfs_fs_get_xquota,
Index: linux-2.6/include/linux/quotaops.h
===================================================================
--- linux-2.6.orig/include/linux/quotaops.h	2010-02-16 00:16:06.788003612 +0100
+++ linux-2.6/include/linux/quotaops.h	2010-02-16 00:16:15.361004730 +0100
@@ -22,7 +22,7 @@ static inline struct quota_info *sb_dqop
 void sync_quota_sb(struct super_block *sb, int type);
 static inline void writeout_quota_sb(struct super_block *sb, int type)
 {
-	if (sb->s_qcop->quota_sync)
+	if (sb->s_qcop && sb->s_qcop->quota_sync)
 		sb->s_qcop->quota_sync(sb, type);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
