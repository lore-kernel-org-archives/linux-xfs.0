Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CA8489FDF
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983160; cv=none; b=nz88rwbjshB0HUFHBM7ko2sypgOCtAaCSK8BwRqc3HVye7WeAbWpMT2muaMyHo3T8AJkWOQE8EqW6kQhrAP3w8QGr3Fdgw8OeSWIiFpVdGS+fndIb63HergmT2AAEqN7SGWlh16J1sXcIQLPoKXGBwukbVMBOJj1qkHYSYU1hXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983160; c=relaxed/simple;
	bh=SO040S5abNNf+QktAzzXhAVKPN0em6nbua/CUKGWpbU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bR78152YDuLRDYzHjG1FAeLhT332Z8cTjdj/ypWjPiix/hAz9xQqTgKqlU/DqdafW/V/xb2E+EJdI/qlDvghrC5FBD7LlCVG9i+yqSncWbAYtCHfsG+oPFyBnuX43WOrA6pHiH4H82HRNrSrX15mh6qXTe3e4RZ2NLiKCcfqVNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GW1KXkm1; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GW1KXkm1"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260921093235epoutp023ad4a4af93231fa50b3ac07a5777f1bc~XTDJL-RTy1015410154epoutp02u
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260921093235epoutp023ad4a4af93231fa50b3ac07a5777f1bc~XTDJL-RTy1015410154epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789983155;
	bh=M5affipYNhXZN6/hZLok/j/POBBuNGHKpdyzd3A6p/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GW1KXkm1oor4eeAjkztS+UCIz/+ssVhKNtre6a1A3Hoz7aa2BZytEJvF+4Y7lrR/H
	 jv3YaQtpd3uoJYVZPEuX0cEl72M62JJU5C4tJgLrAPbgFKBZYIMYgVYR0EP4sfO74M
	 EWU/c9KAj08yIH9qiYnEhMRfD6HyNA+SiXDOGpjA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260921093234epcas5p3a07edd67541867e4836c4604475dceee~XTDIbNSpS0218502185epcas5p3F;
	Mon, 21 Sep 2026 09:32:34 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hpJ0y1w6xz6B9m7; Mon, 21 Sep
	2026 09:32:34 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260921093233epcas5p422eef7d763c4ddcc8fb641eb582b5e48~XTDHVYVXq2875428754epcas5p4X;
	Mon, 21 Sep 2026 09:32:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260921093231epsmtip14a542a9cac5b3008457450fa2f67c53e~XTDFoXsOo0536305363epsmtip1G;
	Mon, 21 Sep 2026 09:32:31 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v5 2/8] fs: add generic write-stream management
Date: Mon, 21 Sep 2026 15:01:41 +0530
Message-Id: <20260921093147.59935-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921093147.59935-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260921093233epcas5p422eef7d763c4ddcc8fb641eb582b5e48
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921093233epcas5p422eef7d763c4ddcc8fb641eb582b5e48
References: <20260921093147.59935-1-joshi.k@samsung.com>
	<CGME20260921093233epcas5p422eef7d763c4ddcc8fb641eb582b5e48@epcas5p4.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Add a bitmap-based stream pool and anonymous fds for reserved streams.
Helpers initialize and destroy a pool, reserve a stream as an fd, and
resolve a stream fd back to its id.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/Makefile                   |   2 +-
 fs/write_streams.c            | 138 ++++++++++++++++++++++++++++++++++
 include/linux/write_streams.h |  33 ++++++++
 3 files changed, 172 insertions(+), 1 deletion(-)
 create mode 100644 fs/write_streams.c
 create mode 100644 include/linux/write_streams.h

diff --git a/fs/Makefile b/fs/Makefile
index 055dfc23d82b..494da034cef2 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -23,7 +23,7 @@ obj-$(CONFIG_PROC_FS)		+= proc_namespace.o
 obj-$(CONFIG_LEGACY_DIRECT_IO)	+= direct-io.o
 obj-y				+= notify/
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
-obj-y				+= anon_inodes.o
+obj-y				+= anon_inodes.o write_streams.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
diff --git a/fs/write_streams.c b/fs/write_streams.c
new file mode 100644
index 000000000000..b7f6ca6cf725
--- /dev/null
+++ b/fs/write_streams.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Generic write-stream fd management. */
+#include <linux/anon_inodes.h>
+#include <linux/bitmap.h>
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/slab.h>
+#include <linux/write_streams.h>
+
+struct write_stream {
+	struct write_stream_pool	*pool;
+	struct vfsmount			*mnt;	/* pins the mount */
+	u16				id;	/* 1-based slot number */
+};
+
+static int write_stream_release(struct inode *inode, struct file *file)
+{
+	struct write_stream *ws = file->private_data;
+
+	spin_lock(&ws->pool->lock);
+	__clear_bit(ws->id - 1, ws->pool->streams_in_use);
+	spin_unlock(&ws->pool->lock);
+	mntput(ws->mnt);
+	kfree(ws);
+	return 0;
+}
+
+static const struct file_operations write_stream_fops = {
+	.release	= write_stream_release,
+	.llseek		= noop_llseek,
+};
+
+/**
+ * write_stream_pool_init - size a write stream pool
+ * @pool: pool to initialise
+ * @nr: number of slots, may be zero
+ *
+ * Returns 0, or -ENOMEM if the bitmap cannot be allocated.
+ */
+int write_stream_pool_init(struct write_stream_pool *pool, unsigned int nr)
+{
+	spin_lock_init(&pool->lock);
+	pool->streams_in_use = NULL;
+	pool->nr_streams = 0;
+
+	if (!nr)
+		return 0;
+
+	pool->streams_in_use = bitmap_zalloc(nr, GFP_KERNEL);
+	if (!pool->streams_in_use)
+		return -ENOMEM;
+	pool->nr_streams = nr;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(write_stream_pool_init);
+
+/**
+ * write_stream_pool_destroy - free a write stream pool
+ * @pool: pool to release
+ */
+void write_stream_pool_destroy(struct write_stream_pool *pool)
+{
+	bitmap_free(pool->streams_in_use);
+	pool->streams_in_use = NULL;
+	pool->nr_streams = 0;
+}
+EXPORT_SYMBOL_GPL(write_stream_pool_destroy);
+
+/**
+ * write_stream_alloc_fd - reserve a slot and return an fd naming it
+ * @pool: pool to reserve from
+ * @file: file whose mount is pinned for the life of the stream
+ *
+ * Returns an O_RDONLY | O_CLOEXEC fd, -EOPNOTSUPP if the pool has no slots,
+ * or -EBUSY if they are all taken.
+ */
+int write_stream_alloc_fd(struct write_stream_pool *pool, struct file *file)
+{
+	struct write_stream *ws;
+	unsigned int slot;
+	int fd;
+
+	if (!pool->nr_streams)
+		return -EOPNOTSUPP;
+
+	ws = kzalloc_obj(*ws, GFP_KERNEL);
+	if (!ws)
+		return -ENOMEM;
+
+	spin_lock(&pool->lock);
+	slot = find_first_zero_bit(pool->streams_in_use, pool->nr_streams);
+	if (slot >= pool->nr_streams) {
+		spin_unlock(&pool->lock);
+		kfree(ws);
+		return -EBUSY;
+	}
+	__set_bit(slot, pool->streams_in_use);
+	spin_unlock(&pool->lock);
+
+	ws->pool = pool;
+	ws->mnt = mntget(file->f_path.mnt);
+	ws->id = slot + 1;
+
+	fd = anon_inode_getfd("[write_stream]", &write_stream_fops, ws,
+			      O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		spin_lock(&pool->lock);
+		__clear_bit(slot, pool->streams_in_use);
+		spin_unlock(&pool->lock);
+		mntput(ws->mnt);
+		kfree(ws);
+	}
+	return fd;
+}
+EXPORT_SYMBOL_GPL(write_stream_alloc_fd);
+
+/**
+ * write_stream_get_id - the id a stream file names
+ * @file: candidate stream file
+ * @pool: pool the stream must belong to, or NULL to accept any
+ *
+ * Returns the 1-based id, or -EINVAL if @file is not a stream file, or is
+ * a stream of a different pool.
+ */
+int write_stream_get_id(struct file *file, const struct write_stream_pool *pool)
+{
+	struct write_stream *ws;
+
+	if (file->f_op != &write_stream_fops)
+		return -EINVAL;
+	ws = file->private_data;
+	if (pool && ws->pool != pool)
+		return -EINVAL;
+	return ws->id;
+}
+EXPORT_SYMBOL_GPL(write_stream_get_id);
diff --git a/include/linux/write_streams.h b/include/linux/write_streams.h
new file mode 100644
index 000000000000..d27f42df5984
--- /dev/null
+++ b/include/linux/write_streams.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_WRITE_STREAMS_H
+#define _LINUX_WRITE_STREAMS_H
+
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+struct file;
+
+/*
+ * Write stream slot pool, embedded in whatever filesystem object scopes
+ * an id space.
+ */
+struct write_stream_pool {
+	unsigned int		nr_streams;
+	unsigned long		*streams_in_use;
+	spinlock_t		lock;
+};
+
+static inline unsigned int
+write_stream_pool_count(const struct write_stream_pool *pool)
+{
+	return pool->nr_streams;
+}
+
+int  write_stream_pool_init(struct write_stream_pool *pool, unsigned int nr);
+void write_stream_pool_destroy(struct write_stream_pool *pool);
+
+int  write_stream_alloc_fd(struct write_stream_pool *pool, struct file *file);
+int  write_stream_get_id(struct file *file,
+			 const struct write_stream_pool *pool);
+
+#endif /* _LINUX_WRITE_STREAMS_H */
-- 
2.25.1

