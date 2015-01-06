Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C41F27F72
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:29:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 999778F8054
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 08:29:54 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id t6Mtn0IwmWVSwBiB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 08:29:52 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/18] xfs: implement pnfs export operations
Date: Tue,  6 Jan 2015 17:28:40 +0100
Message-Id: <1420561721-9150-18-git-send-email-hch@lst.de>
In-Reply-To: <1420561721-9150-1-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

Add operations to export pNFS block layouts from an XFS filesystem.  See
the previous commit adding the operations for an explanation of them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile     |   1 +
 fs/xfs/xfs_export.c |   6 ++
 fs/xfs/xfs_fsops.c  |   2 +
 fs/xfs/xfs_iops.c   |   2 +-
 fs/xfs/xfs_iops.h   |   1 +
 fs/xfs/xfs_mount.h  |   2 +
 fs/xfs/xfs_pnfs.c   | 270 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_pnfs.h   |  11 +++
 8 files changed, 294 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_pnfs.c
 create mode 100644 fs/xfs/xfs_pnfs.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d617999..df68285 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -121,3 +121,4 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_PROC_FS)		+= xfs_stats.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
+xfs-$(CONFIG_NFSD_PNFS)		+= xfs_pnfs.o
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 5eb4a14..b97359b 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -30,6 +30,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_pnfs.h"
 
 /*
  * Note that we only accept fileids which are long enough rather than allow
@@ -245,4 +246,9 @@ const struct export_operations xfs_export_operations = {
 	.fh_to_parent		= xfs_fs_fh_to_parent,
 	.get_parent		= xfs_fs_get_parent,
 	.commit_metadata	= xfs_fs_nfs_commit_metadata,
+#ifdef CONFIG_NFSD_PNFS
+	.get_uuid		= xfs_fs_get_uuid,
+	.map_blocks		= xfs_fs_map_blocks,
+	.commit_blocks		= xfs_fs_commit_blocks,
+#endif
 };
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index fdc6422..2b86be8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -601,6 +601,8 @@ xfs_growfs_data(
 	if (!mutex_trylock(&mp->m_growlock))
 		return -EWOULDBLOCK;
 	error = xfs_growfs_data_private(mp, in);
+	if (!error)
+		mp->m_generation++;
 	mutex_unlock(&mp->m_growlock);
 	return error;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c50311c..6ff84e8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -496,7 +496,7 @@ xfs_setattr_mode(
 	inode->i_mode |= mode & ~S_IFMT;
 }
 
-static void
+void
 xfs_setattr_time(
 	struct xfs_inode	*ip,
 	struct iattr		*iattr)
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 1c34e43..ea7a98e 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -32,6 +32,7 @@ extern void xfs_setup_inode(struct xfs_inode *);
  */
 #define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
 
+extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);
 extern int xfs_setattr_size(struct xfs_inode *ip, struct iattr *vap);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 22ccf69..aba26c8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -175,6 +175,8 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct	*m_log_workqueue;
 	struct workqueue_struct *m_eofblocks_workqueue;
+
+	__uint32_t		m_generation;	/* incremented on each growfs */
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
new file mode 100644
index 0000000..d95f596
--- /dev/null
+++ b/fs/xfs/xfs_pnfs.c
@@ -0,0 +1,270 @@
+/*
+ * Copyright (c) 2014 Christoph Hellwig.
+ */
+#include "xfs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_log.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_error.h"
+#include "xfs_iomap.h"
+#include "xfs_shared.h"
+#include "xfs_pnfs.h"
+
+int
+xfs_fs_get_uuid(
+	struct super_block	*sb,
+	u8			*buf,
+	u32			*len,
+	u64			*offset)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (*len < sizeof(uuid_t))
+		return -EINVAL;
+
+	memcpy(buf, &mp->m_sb.sb_uuid, sizeof(uuid_t));
+	*len = sizeof(uuid_t);
+	*offset = offsetof(struct xfs_dsb, sb_uuid);
+	return 0;
+}
+
+static void
+xfs_map_iomap(
+	struct xfs_inode	*ip,
+	struct iomap		*iomap,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t	offset)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	iomap->blkno = -1;
+	if (imap->br_startblock == HOLESTARTBLOCK)
+		iomap->type = IOMAP_HOLE;
+	else if (imap->br_startblock == DELAYSTARTBLOCK)
+		iomap->type = IOMAP_DELALLOC;
+	else {
+		/*
+		 * the block number in the iomap must match the start offset we
+		 * place in the iomap.
+		 */
+		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
+		ASSERT(iomap->blkno || XFS_IS_REALTIME_INODE(ip));
+		if (imap->br_state == XFS_EXT_UNWRITTEN)
+			iomap->type = IOMAP_UNWRITTEN;
+		else
+			iomap->type = IOMAP_MAPPED;
+	}
+	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
+}
+
+static int
+xfs_fs_update_flags(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	/*
+	 * Update the mode, and prealloc flag bits.
+	 */
+	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_writeid, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	ip->i_d.di_mode &= ~S_ISUID;
+	if (ip->i_d.di_mode & S_IXGRP)
+		ip->i_d.di_mode &= ~S_ISGID;
+
+	ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return xfs_trans_commit(tp, 0);
+}
+
+/*
+ * Get a layout for the pNFS client.
+ *
+ * Note that in the allocation case we do force out the transaction here.
+ * There is no metadata update that is required to be stable for NFS
+ * semantics, and layouts are not valid over a server crash.  Instead
+ * we'll have to be careful in the commit routine as it might pass us
+ * blocks for an allocation that never made it to disk in the recovery
+ * case.
+ */
+int
+xfs_fs_map_blocks(
+	struct inode		*inode,
+	loff_t			offset,
+	u64			length,
+	struct iomap		*iomap,
+	bool			write,
+	u32			*device_generation)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	imap;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	loff_t			limit;
+	int			bmapi_flags = XFS_BMAPI_ENTIRE;
+	int			nimaps = 1;
+	uint			lock_flags;
+	int			error = 0;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return -ENXIO;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	if (!write) {
+		limit = max(round_up(i_size_read(inode),
+				     inode->i_sb->s_blocksize),
+			    mp->m_super->s_maxbytes);
+	} else {
+		limit = mp->m_super->s_maxbytes;
+	}
+
+	error = -EINVAL;
+	if (offset > limit)
+		goto out_unlock;
+	if (offset + length > mp->m_super->s_maxbytes)
+		length = limit - offset;
+
+	/*
+	 * Flush data and truncate the pagecache.  pNFS block clients just
+	 * like direct I/O access the disk directly.
+	 */
+	error = filemap_write_and_wait(inode->i_mapping);
+	if (error)
+		goto out_unlock;
+	invalidate_inode_pages2(inode->i_mapping);
+
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+
+	lock_flags = xfs_ilock_data_map_shared(ip);
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				&imap, &nimaps, bmapi_flags);
+	xfs_iunlock(ip, lock_flags);
+
+	if (error)
+		goto out_unlock;
+
+	if (write) {
+		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
+			error = xfs_iomap_write_direct(ip, offset, length,
+						       &imap, nimaps);
+			if (error)
+				goto out_unlock;
+		}
+
+		error = xfs_fs_update_flags(ip);
+		if (error)
+			goto out_unlock;
+	}
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+
+	xfs_map_iomap(ip, iomap, &imap, offset);
+	*device_generation = mp->m_generation;
+	return error;
+out_unlock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+}
+
+/*
+ * Make sure the blocks described by maps are stable on disk.  This includes
+ * converting any unwritten extents, flushing the disk cache and updating the
+ * time stamps.
+ *
+ * Note that we rely on the caller to always send us a timestamp update so that
+ * we always commit a transaction here.  If that stops being true we will have
+ * to manually flush the cache here similar to what the fsync code path does
+ * for datasyncs on files that have no dirty metadata.
+ *
+ * In the reclaim case we might get called for blocks that were only allocated
+ * in memory and not on disk.  We rely on the fact that unwritten extent
+ * conversions handle this properly.
+ */
+int
+xfs_fs_commit_blocks(
+	struct inode		*inode,
+	struct iomap		*maps,
+	int			nr_maps,
+	struct iattr		*iattr)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error, i;
+	loff_t			size;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	size = i_size_read(inode);
+	if ((iattr->ia_valid & ATTR_SIZE) && iattr->ia_size > size)
+		size = iattr->ia_size;
+
+	for (i = 0; i < nr_maps; i++) {
+		u64 start, length, end;
+
+		start = maps[i].offset;
+		if (start > size)
+			continue;
+
+		end = start + maps[i].length;
+		if (end > size)
+			end = size;
+
+		length = end - start;
+		if (!length)
+			continue;
+
+		error = xfs_iomap_write_unwritten(ip, start, length);
+		if (error)
+			goto out_drop_iolock;
+	}
+
+	/*
+	 * Make sure reads through the pagecache see the new data.
+	 */
+	invalidate_inode_pages2(inode->i_mapping);
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+	if (error)
+		goto out_drop_iolock;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	xfs_setattr_time(ip, iattr);
+	if (iattr->ia_valid & ATTR_SIZE) {
+		if (iattr->ia_size > i_size_read(inode)) {
+			i_size_write(inode, iattr->ia_size);
+			ip->i_d.di_size = iattr->ia_size;
+		}
+	}
+
+	xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp, 0);
+
+out_drop_iolock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+}
diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
new file mode 100644
index 0000000..0d91255
--- /dev/null
+++ b/fs/xfs/xfs_pnfs.h
@@ -0,0 +1,11 @@
+#ifndef _XFS_PNFS_H
+#define _XFS_PNFS_H 1
+
+#ifdef CONFIG_NFSD_PNFS
+int xfs_fs_get_uuid(struct super_block *sb, u8 *buf, u32 *len, u64 *offset);
+int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
+		struct iomap *iomap, bool write, u32 *device_generation);
+int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
+		struct iattr *iattr);
+#endif /* CONFIG_NFSD_PNFS */
+#endif /* _XFS_PNFS_H */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
