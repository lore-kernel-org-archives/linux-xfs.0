Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Nov 2007 08:47:52 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAPGlhXF032142
	for <linux-xfs@oss.sgi.com>; Sun, 25 Nov 2007 08:47:44 -0800
Date: Sun, 25 Nov 2007 16:30:14 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071125163014.GA17922@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114070400.GA25708@puku.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

The current readdir implementation deadlocks on a btree buffers locks
because nfsd calls back into ->lookup from the filldir callback.  The
only short-term fix for this is to revert to the old inefficient
double-buffering scheme.

This patch does exactly that and reverts xfs_file_readdir to what's
basically the 2.6.23 version minus the uio and vnops junk.

I'll try to find something more optimal for 2.6.25 or at least find a
way to use the proper version for local access.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2007-11-25 11:41:20.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2007-11-25 17:14:27.000000000 +0100
@@ -218,6 +218,15 @@
 }
 #endif /* CONFIG_XFS_DMAPI */
 
+/*
+ * Unfortunately we can't just use the clean and simple readdir implementation
+ * below, because nfs might call back into ->lookup from the filldir callback
+ * and that will deadlock the low-level btree code.
+ *
+ * Hopefully we'll find a better workaround that allows to use the optimal
+ * version at least for local readdirs for 2.6.25.
+ */
+#if 0
 STATIC int
 xfs_file_readdir(
 	struct file	*filp,
@@ -249,6 +258,121 @@
 		return -error;
 	return 0;
 }
+#else
+
+struct hack_dirent {
+	int		namlen;
+	loff_t		offset;
+	u64		ino;
+	unsigned int	d_type;
+	char		name[];
+};
+
+struct hack_callback {
+	char		*dirent;
+	size_t		len;
+	size_t		used;
+};
+
+STATIC int
+xfs_hack_filldir(
+	void		*__buf,
+	const char	*name,
+	int		namlen,
+	loff_t		offset,
+	u64		ino,
+	unsigned int	d_type)
+{
+	struct hack_callback *buf = __buf;
+	struct hack_dirent *de = (struct hack_dirent *)(buf->dirent + buf->used);
+
+	if (buf->used + sizeof(struct hack_dirent) + namlen > buf->len)
+		return -EINVAL;
+
+	de->namlen = namlen;
+	de->offset = offset;
+	de->ino = ino;
+	de->d_type = d_type;
+	memcpy(de->name, name, namlen);
+	buf->used += sizeof(struct hack_dirent) + namlen;
+	return 0;
+}
+
+STATIC int
+xfs_file_readdir(
+	struct file	*filp,
+	void		*dirent,
+	filldir_t	filldir)
+{
+	struct inode	*inode = filp->f_path.dentry->d_inode;
+	xfs_inode_t	*ip = XFS_I(inode);
+	struct hack_callback buf;
+	struct hack_dirent *de;
+	int		error;
+	loff_t		size;
+	int		eof = 0;
+	xfs_off_t       start_offset, curr_offset, offset;
+
+	/*
+	 * Try fairly hard to get memory
+	 */
+	buf.len = PAGE_CACHE_SIZE;
+	do {
+		buf.dirent = kmalloc(buf.len, GFP_KERNEL);
+		if (buf.dirent)
+			break;
+		buf.len >>= 1;
+	} while (buf.len >= 1024);
+
+	if (!buf.dirent)
+		return -ENOMEM;
+
+	curr_offset = filp->f_pos;
+	if (curr_offset == 0x7fffffff)
+		offset = 0xffffffff;
+	else
+		offset = filp->f_pos;
+
+	while (!eof) {
+		int reclen;
+		start_offset = offset;
+
+		buf.used = 0;
+		error = -xfs_readdir(ip, &buf, buf.len, &offset,
+				     xfs_hack_filldir);
+		if (error || offset == start_offset) {
+			size = 0;
+			break;
+		}
+
+		size = buf.used;
+		de = (struct hack_dirent *)buf.dirent;
+		while (size > 0) {
+			if (filldir(dirent, de->name, de->namlen,
+					curr_offset & 0x7fffffff,
+					de->ino, de->d_type)) {
+				goto done;
+			}
+
+			reclen = sizeof(struct hack_dirent) + de->namlen;
+			size -= reclen;
+			curr_offset = de->offset /* & 0x7fffffff */;
+			de = (struct hack_dirent *)((char *)de + reclen);
+		}
+	}
+
+ done:
+ 	if (!error) {
+		if (size == 0)
+			filp->f_pos = offset & 0x7fffffff;
+		else if (de)
+			filp->f_pos = curr_offset;
+	}
+
+	kfree(buf.dirent);
+	return error;
+}
+#endif
 
 STATIC int
 xfs_file_mmap(
