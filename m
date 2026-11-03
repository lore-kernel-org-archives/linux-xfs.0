Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705704;
	b=H0cmy7HXFmVlqX5+MDQShf+vRP49qXrEkUyJi7y3o4pZ1WQ43KBEYhfUPyunhygj7yBy
	 /ZEzmdkmWFBs6msRoYNyFwhb7PwelWeraTZl/k+Ca9krnPpcYwN9uVqsxp3QWtJk1IeMI
	 pEDxVCH+xe85zEN+ac6lxJC7fs7hyoF1mXfRuiq20m2WxPgZilMLdq5UQMdYC8ADlhxiL
	 xryOzxVYiFz4MIEdcdZjTslLNLWZM0Mhv3viWydk+Qr1OPWJoGiZhaBtQqoGEwhQpqaON
	 Tqxv4MsYgzSZkhCpqwqgA78pGObFUCigAkqueYLnwFlf2TNNPA9aRG5xV1O95jQtd7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705704;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=7kvLtEcUFWV27Al6391r2MqyY6+HAB1RORyRQo09H8E=;
	b=AVX4X0INkLE5lolJYpmltqjCwLX764dzOJaCkbWT4xdaRpfnUnmpo60ijfpN4QMgQKAI
	 +/PYT1sG7jLosxcmRV/iNW9lKdOSM47Kd4wV+uKxVyVFyyNCF28P8ki4BHCoRr/zG39Va
	 hYLN6308jbphcFHVS9JjpwOKLF6MSr1QpNjg/VDGeKljCj3UAVMbDynNOEkK+u1w+rAkG
	 MxEGF4CTp1ywYdkIkToM9210dIFv02o1aJ5cx2bBxRXZFXI05GqHcSKqA72p+bepJhlOD
	 DpplJXrnQG9/Y91zlC0fXcXOKzs/4JwxLn5r5kZdJJMlHbQbjU2WalPOjjrK9KDkJNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=vH2iL8GL;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43927606A332
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43927606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=vH2iL8GL
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261103113501epoutp03b087f1970fa89c24bf83d631ed63836b~khdUIZlv62388423884epoutp03Y
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261103113501epoutp03b087f1970fa89c24bf83d631ed63836b~khdUIZlv62388423884epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793705701;
	bh=7kvLtEcUFWV27Al6391r2MqyY6+HAB1RORyRQo09H8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vH2iL8GL8BEd8Lo0eK9q/S68EVO0JGKWRhnyOl9VxYZlaHYFmzw2GZ/l2XC9AKrFU
	 oL9Pxv1ZsqS1oLNpCmg3jz4Uy5bnwaSNA1IxNywTBxxEcsY15dbESbEsEkIJSLBSzu
	 60mYPLNLU96oLbMB/Q1Oq8rd4XnxOIxWhv+aZqEE=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261103113500epcas5p263c45966042ac0beb222925e49a8a183~khdTguhwS2045420454epcas5p2s;
	Tue,  3 Nov 2026 11:35:00 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jJmhN1w97z3hhT3; Tue,  3 Nov
	2026 11:35:00 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111027epcas5p1745017df1726b954a346a78773bc203d~khH3Hvlin1605716057epcas5p1L;
	Tue,  3 Nov 2026 11:10:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111024epsmtip1d2033ae8dece34f2e29cdd726027c54c~khH0xCqZI2454324543epsmtip1N;
	Tue,  3 Nov 2026 11:10:24 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v7 2/8] fs: add generic write-stream management
Date: Tue,  3 Nov 2026 16:36:34 +0530
Message-Id: <20261103110640.1000095-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261103110640.1000095-1-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261103111027epcas5p1745017df1726b954a346a78773bc203d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111027epcas5p1745017df1726b954a346a78773bc203d
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111027epcas5p1745017df1726b954a346a78773bc203d@epcas5p1.samsung.com>

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
index 16f1108b64e1..2a6d5f98cfc9 100644
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

