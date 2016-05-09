Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 294E67CA4
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 03:48:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F14F1304039
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 01:48:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6pXSnOPaj5IevtnI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 01:48:02 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/15] fs: iomap based fiemap implementation
Date: Mon,  9 May 2016 10:47:12 +0200
Message-Id: <1462783638-4968-10-git-send-email-hch@lst.de>
In-Reply-To: <1462783638-4968-1-git-send-email-hch@lst.de>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org

Add a simple fiemap implementation based on iomap_ops, partially based
on a previous implementation from Bob Peterson <rpeterso@redhat.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  3 ++
 2 files changed, 93 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index f84c6eb..7e639bf 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -405,3 +405,93 @@ out_unlock:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_page_mkwrite);
+
+struct fiemap_ctx {
+	struct fiemap_extent_info *fi;
+	struct iomap prev;
+};
+
+static int iomap_to_fiemap(struct fiemap_extent_info *fi,
+		struct iomap *iomap, u32 flags)
+{
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+		/* skip holes */
+		return 0;
+	case IOMAP_DELALLOC:
+		flags |= FIEMAP_EXTENT_DELALLOC | FIEMAP_EXTENT_UNKNOWN;
+		break;
+	case IOMAP_UNWRITTEN:
+		flags |= FIEMAP_EXTENT_UNWRITTEN;
+		break;
+	case IOMAP_MAPPED:
+		break;
+	}
+
+	return fiemap_fill_next_extent(fi, iomap->offset,
+			iomap->blkno != IOMAP_NULL_BLOCK ? iomap->blkno << 9: 0,
+			iomap->length, flags | FIEMAP_EXTENT_MERGED);
+
+}
+
+static loff_t
+iomap_fiemap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
+		struct iomap *iomap)
+{
+	struct fiemap_ctx *ctx = data;
+	loff_t ret = length;
+
+	if (iomap->type == IOMAP_HOLE)
+		return length;
+
+	ret = iomap_to_fiemap(ctx->fi, &ctx->prev, 0);
+	ctx->prev = *iomap;
+	switch (ret) {
+	case 0:		/* success */
+		return length;
+	case 1:		/* extent array full */
+		return 0;
+	default:
+		return ret;
+	}
+}
+
+int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
+		loff_t start, loff_t len, struct iomap_ops *ops)
+{
+	struct fiemap_ctx ctx;
+	loff_t ret;
+
+	memset(&ctx, 0, sizeof(ctx));
+	ctx.fi = fi;
+	ctx.prev.type = IOMAP_HOLE;
+
+	ret = fiemap_check_flags(fi, FIEMAP_FLAG_SYNC);
+	if (ret)
+		return ret;
+
+	ret = filemap_write_and_wait(inode->i_mapping);
+	if (ret)
+		return ret;
+
+	while (len > 0) {
+		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
+				iomap_fiemap_actor);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			break;
+
+		start += ret;
+		len -= ret;
+	}
+
+	if (ctx.prev.type != IOMAP_HOLE) {
+		ret = iomap_to_fiemap(fi, &ctx.prev, FIEMAP_EXTENT_LAST);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iomap_fiemap);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 854766f..b3deee1 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 
+struct fiemap_extent_info;
 struct inode;
 struct iov_iter;
 struct kiocb;
@@ -63,5 +64,7 @@ int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		struct iomap_ops *ops);
 int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		struct iomap_ops *ops);
+int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		loff_t start, loff_t len, struct iomap_ops *ops);
 
 #endif /* LINUX_IOMAP_H */
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
