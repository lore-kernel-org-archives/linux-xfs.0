Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67EA87F7D
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DBE7BAC009
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:25 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id vDB6jFtVMUZSI9tC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:24 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/20] exportfs: add methods for block layout exports
Date: Thu, 22 Jan 2015 12:10:00 +0100
Message-Id: <1421925006-24231-15-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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

Add three methods to allow exporting pnfs block layout volumes:

 - get_uuid: get a filesystem unique signature exposed to clients
 - map_blocks: map and if nessecary allocate blocks for a layout
 - commit_blocks: commit blocks in a layout once the client is done with them

For now we stick the external pnfs block layout interfaces into s_export_op to
avoid mixing them up with the internal interface between the NFS server and
the layout drivers.  Once we've fully internalized the latter interface we
can redecide if these methods should stay in s_export_ops.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/exportfs.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 41b223a..ff46bf7 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 
 struct dentry;
+struct iattr;
 struct inode;
 struct super_block;
 struct vfsmount;
@@ -180,6 +181,19 @@ struct fid {
  *    get_name is not (which is possibly inconsistent)
  */
 
+/* types of block ranges for multipage write mappings. */
+#define IOMAP_HOLE	0x01	/* no blocks allocated, need allocation */
+#define IOMAP_DELALLOC	0x02	/* delayed allocation blocks */
+#define IOMAP_MAPPED	0x03	/* blocks allocated @blkno */
+#define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
+
+struct iomap {
+	sector_t	blkno;	/* first sector of mapping */
+	loff_t		offset;	/* file offset of mapping, bytes */
+	u64		length;	/* length of mapping, bytes */
+	int		type;	/* type of mapping */
+};
+
 struct export_operations {
 	int (*encode_fh)(struct inode *inode, __u32 *fh, int *max_len,
 			struct inode *parent);
@@ -191,6 +205,13 @@ struct export_operations {
 			struct dentry *child);
 	struct dentry * (*get_parent)(struct dentry *child);
 	int (*commit_metadata)(struct inode *inode);
+
+	int (*get_uuid)(struct super_block *sb, u8 *buf, u32 *len, u64 *offset);
+	int (*map_blocks)(struct inode *inode, loff_t offset,
+			  u64 len, struct iomap *iomap,
+			  bool write, u32 *device_generation);
+	int (*commit_blocks)(struct inode *inode, struct iomap *iomaps,
+			     int nr_iomaps, struct iattr *iattr);
 };
 
 extern int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
