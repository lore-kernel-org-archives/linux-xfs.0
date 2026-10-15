Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F46F48124D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046076; cv=none; b=R5WcVoT/TkNq8VBu18K3hEbafMAvmzYt2m05xoVBnkTAbTbaai/NnmhpCXB4ttdeAHwJKsWt2hLgDmMrKhYoW64KWHU3SOP6I/RFlBIVN9KRujB/rVP/dthBl4hyNOjJJKO7qJcPPvwB2NS+hTguli6rIvB2bXY0b7DBYTSANVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046076; c=relaxed/simple;
	bh=hDZ/F+LVAYPeaxh24LhMOer4xyioi/Z2jQGEZWfVnfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ZwdWriJT0ajR8937745DsYoDv/cNEBjIhWVbQFDezx5AOuH7kSdTxK8FC6TWhhbv3JEyqL4Y5mN2GIRS6TRZtg+BKAC/3E9xD8Qv6F96+oNUvvwZ8h63b4Q+UulXQGH0+EG2cqGYMtuyFfqJpLjYtc7E+dZoAHpep1Ao2h7ik2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bW4s97Bc; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bW4s97Bc"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261015063432epoutp012d7a4570fbca1b5da9e45cfd4474f237~eoGhv4cfO1749717497epoutp01f
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261015063432epoutp012d7a4570fbca1b5da9e45cfd4474f237~eoGhv4cfO1749717497epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792046072;
	bh=TFTRJ4JcimUp7cEjjK6sjHgfgqKruxFPE3og5WVlUAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bW4s97BckYRnZ35faOP3u8Wzu7QuADqcl5bDs43kupym0v4Gdlsi7ZSe6ZyvfE+qZ
	 99e1faHiMUtHBk609cLoYfzMm+jzHI9/8uCvN0nHneBnStL6MGgc3YgXCsa44arcwE
	 LCd8WN3js9d2Ey1eYRBk1jbhOWZ1ufJVsRsSJA/o=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261015063431epcas5p4bde32446fe610eaf4f8015507d285dfd~eoGhB7y_71914419144epcas5p4C;
	Thu, 15 Oct 2026 06:34:31 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4j4ywQ4xFfz2SSKh; Thu, 15 Oct
	2026 06:34:30 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261015063430epcas5p2876b800e417ebb4da19484d7a1d32170~eoGf7acp_2023420234epcas5p29;
	Thu, 15 Oct 2026 06:34:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015063428epsmtip13de02cc7aed9d9534e8cc69819997794~eoGeB00hH1270712707epsmtip1u;
	Thu, 15 Oct 2026 06:34:28 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v6 2/8] fs: add generic write-stream management
Date: Thu, 15 Oct 2026 12:02:40 +0530
Message-Id: <20261015063246.103433-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261015063246.103433-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015063430epcas5p2876b800e417ebb4da19484d7a1d32170
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063430epcas5p2876b800e417ebb4da19484d7a1d32170
References: <20261015063246.103433-1-joshi.k@samsung.com>
	<CGME20261015063430epcas5p2876b800e417ebb4da19484d7a1d32170@epcas5p2.samsung.com>

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
 fs/write_streams.c            | 142 ++++++++++++++++++++++++++++++++++
 include/linux/write_streams.h |  33 ++++++++
 3 files changed, 176 insertions(+), 1 deletion(-)
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
index 000000000000..4c7ad3198bb9
--- /dev/null
+++ b/fs/write_streams.c
@@ -0,0 +1,142 @@
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
+	/* ws->mnt keeps the pool alive until the mntput() below */
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
+ * @nr: number of slots, may be zero, at most U16_MAX
+ *
+ * Return: 0, -EINVAL if @nr is too large, or -ENOMEM if the bitmap cannot be
+ * allocated.
+ */
+int write_stream_pool_init(struct write_stream_pool *pool, unsigned int nr)
+{
+	spin_lock_init(&pool->lock);
+	pool->streams_in_use = NULL;
+	pool->nr_streams = 0;
+
+	if (nr > U16_MAX)
+		return -EINVAL;
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
+ * @pool: pool to reserve from; must live as long as the mount of @file
+ * @file: file whose mount is pinned for the life of the stream
+ *
+ * Return: an O_RDONLY | O_CLOEXEC fd, -EOPNOTSUPP if the pool has no slots,
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
+ * Return: the 1-based id, or -EINVAL if @file is not a stream file, or is
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

