Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553741;
	b=f/sYS85381vxpybMVH04m3fI6oju9+wYkDL3KndTvpckAfGeceQyAA8Aw5Hxf/3oNoN8
	 tNKdZ9w5KmxNv9xPFitmG86k6fL5NuUgCvih78GqkD2R8cLVMYprTuLQY/mnK7GCZquc+
	 KbsRO9fLV4O1KBX3m1CE+Vs9F4xgQpyav1YRvc8KmIOY4rJaJpUD63Pn7MYI2hjQ4zO2x
	 R/MQt9WJdPCJsMruM9J0nOxlAkgSVgIXfcw3QDVhH59FPy/+wfqQ0TjaoPSEHvMtZMMW5
	 asotJHxp7kZE3qc3/sES0PMYFDi8pPWj4IKmZlYvbppYF9m2bbUnsmKqUju1RxdbWMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553741;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SYhdRBfbhOCrZODwMof2LJJutjMOsW3pk0k9wT+4x1s=;
	b=gYiFFHCE4Yn+ncxCvXJoMIltdFFFoATN0k7x9srAhrDmcfBKZDXZPIHOvKKHO3dOFv78
	 g79MgH6K8Mmmiadv9SNg+OGRoKxfg0S4MzWJzDJlaMqyZhn5OrQ3R4pKKhAlmVlIaxW1x
	 PYjimNhEUPZT9LmFizLZ/N5zTa4ebeaQJPf3qjRNifXpbjYwAB9OdummWqfi6SuFOHmjg
	 TeX8jfEP1nei8Hz8hchAUHn76lIJxvVwYMT8a1ERkr1GEVugIfZGfEhWaNMPOncKq//87
	 rbejhA/T6TvAtjeEg/0WA+N9nGMylcRIleP+PI1zNdnX/TpwemhFz7tYlg9moP/D/jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Dp9/6ycq";
	arc=none smtp.remote-ip=91.218.175.57
Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC3760A2612
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 07:09:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DC3760A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Dp9/6ycq
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ePA00gWH1MMaJNHfq4j4NnI+p0p7J/Mr89Hwy2EXwkk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553738; v=1; x=1795158538;
 b=Dp9/6ycq2YWXiQ6b4AiPtsFaJAAG7cErPS8EDzt4qVA6R6GQkKRwJudQmlf7LPL9q5LTxVew
 XcOsQdZ2T2QoIlXmthGFUc4CkwoDua3I53Newym883kisoCTBE/pi44tegesqzL8SvBnD/2rjiO
 W/5O4s3f/zHv7QPdPPW9/80Q=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 60ee62a93959a5fb;
	Fri, 13 Nov 2026 07:08:57 +0000
X-Mizu-Trace-ID: 60ee62a93959a5fb
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj1072538@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	christian.koenig@amd.com,
	Philipp Stanner <phasta@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	asml.silence@gmail.com,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Li Wang <liwang@kylinos.cn>,
	Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: [RFC PATCH v2 8/8] ext4: support dma-buf registered buffers for direct I/O
Date: Fri, 13 Nov 2026 15:06:21 +0800
Message-ID: <20261113070621.273953-9-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

Advertise FMODE_CAN_DMABUF_IO for inodes that can support dma-buf I/O
and implement ->init_dma_buf_io_ctx() by registering the buffer against
the filesystem's block device.  The capability follows
ext4_dio_alignment(), so an inode that can never do direct I/O -
fs-verity, data=journal or inline data - is refused at open, and
encrypted inodes are refused on the inode flag, which is set even
without CONFIG_FS_ENCRYPTION.  The inode is rechecked at registration
because DAX can be enabled after the file was opened.

A dma-buf iterator has no pages to copy from, so it must never reach the
page cache.  ext4_buffered_read_iter() and ext4_buffered_write_iter() are
the single sinks of the buffered fallbacks and refuse it there; a short
direct I/O write still reports its progress, and the DAX write path
refuses at its entry instead of after starting a journal handle.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/ext4/ext4.h | 11 +++++++++++
 fs/ext4/file.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f38fec3167fb..028b2e5ddc8b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4135,6 +4135,17 @@ static inline bool ext4_inode_can_atomic_write(struct inode *inode)
 		EXT4_SB(inode->i_sb)->s_awu_min > 0;
 }
 
+/*
+ * dma-buf I/O needs an inode that supports direct I/O without the page cache.
+ * IS_ENCRYPTED() tests the inode flag, which is set even without
+ * CONFIG_FS_ENCRYPTION.
+ */
+static inline bool ext4_inode_can_dmabuf_io(struct inode *inode)
+{
+	return !IS_DAX(inode) && !IS_ENCRYPTED(inode) &&
+	       ext4_dio_alignment(inode) != 0;
+}
+
 extern int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 				  loff_t pos, unsigned len,
 				  get_block_t *get_block);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 50d3c92709c8..5a8481637da5 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -30,6 +30,7 @@
 #include <linux/uio.h>
 #include <linux/mman.h>
 #include <linux/backing-dev.h>
+#include <linux/blkdev.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -66,6 +67,15 @@ static bool ext4_should_use_dio(struct kiocb *iocb, struct iov_iter *iter)
 	return IS_ALIGNED(iocb->ki_pos | iov_iter_alignment(iter), dio_align);
 }
 
+static ssize_t ext4_buffered_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	/* a dma-buf iterator has no pages for the page cache to copy into */
+	if (iov_iter_is_dmabuf_map(to))
+		return -EOPNOTSUPP;
+
+	return generic_file_read_iter(iocb, to);
+}
+
 static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	ssize_t ret;
@@ -88,7 +98,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		 * taken.
 		 */
 		iocb->ki_flags &= ~IOCB_DIRECT;
-		return generic_file_read_iter(iocb, to);
+		return ext4_buffered_read_iter(iocb, to);
 	}
 
 	ret = iomap_dio_read_simple(iocb, to, ext4_iomap_begin);
@@ -119,7 +129,7 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!IS_DAX(inode)) {
 		inode_unlock_shared(inode);
 		/* Fallback to buffered IO in case we cannot support DAX */
-		return generic_file_read_iter(iocb, to);
+		return ext4_buffered_read_iter(iocb, to);
 	}
 	ret = dax_iomap_rw(iocb, to, &ext4_iomap_ops);
 	inode_unlock_shared(inode);
@@ -146,7 +156,7 @@ static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (iocb->ki_flags & IOCB_DIRECT)
 		return ext4_dio_read_iter(iocb, to);
 
-	return generic_file_read_iter(iocb, to);
+	return ext4_buffered_read_iter(iocb, to);
 }
 
 static ssize_t ext4_file_splice_read(struct file *in, loff_t *ppos,
@@ -354,6 +364,10 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
+	/* a dma-buf iterator cannot be handled by buffered I/O */
+	if (iov_iter_is_dmabuf_map(from))
+		return -EOPNOTSUPP;
+
 	inode_lock(inode);
 
 	/*
@@ -688,6 +702,10 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		ssize_t err;
 		loff_t endbyte;
 
+		/* a dma-buf iterator cannot fall back to buffered I/O */
+		if (iov_iter_is_dmabuf_map(from))
+			return ret;
+
 		/*
 		 * There is no support for atomic writes on buffered-io yet,
 		 * we should never fallback to buffered-io for DIO atomic
@@ -731,6 +749,10 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	bool extend = false;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
+	/* a dma-buf iterator cannot be handled by DAX either */
+	if (iov_iter_is_dmabuf_map(from))
+		return -EOPNOTSUPP;
+
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		if (!inode_trylock(inode))
 			return -EAGAIN;
@@ -1014,6 +1036,8 @@ static int ext4_file_open(struct inode *inode, struct file *filp)
 		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
 
 	filp->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
+	if (ext4_inode_can_dmabuf_io(inode))
+		filp->f_mode |= FMODE_CAN_DMABUF_IO;
 	return dquot_file_open(inode, filp);
 }
 
@@ -1050,10 +1074,24 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	return vfs_setpos(file, offset, maxbytes);
 }
 
+static int ext4_file_init_dma_buf_io_ctx(struct file *file,
+					 struct dma_buf_io_ctx *ctx)
+{
+	struct inode *inode = file_inode(file);
+
+	/* DAX can be enabled after the file was opened */
+	if (!ext4_inode_can_dmabuf_io(inode))
+		return -EOPNOTSUPP;
+
+	/* all file data lives on s_bdev, which never changes for ext4 */
+	return bdev_init_dma_buf_io_ctx(inode->i_sb->s_bdev, ctx);
+}
+
 const struct file_operations ext4_file_operations = {
 	.llseek		= ext4_llseek,
 	.read_iter	= ext4_file_read_iter,
 	.write_iter	= ext4_file_write_iter,
+	.init_dma_buf_io_ctx = ext4_file_init_dma_buf_io_ctx,
 	.iopoll		= iocb_bio_iopoll,
 	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
-- 
2.43.0

