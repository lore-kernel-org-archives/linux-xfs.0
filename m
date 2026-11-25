Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595740;
	b=pbDR3U8V6opecfZMHWZI9lMf0tyxD9HrVdDF9AdAHqYIEsYla+LHN/rYb2XGR+wDaQdA
	 F74y8MurBj6oOWQwbwCgMravfQwQaPGOyu6SWOCBOihlOYHO096wyVAsmI3ulSJyu0GzZ
	 fwVtou6vf/bllvsGpM41c3Eid2CPJB7JrcFmExhHbHLaIadrH5ruOx3uAIEgyZDw1ey7r
	 7f3o4zbJvn7PCnT1c3VYBqzwxmfwrErg/Jo4tCdaXa68qMGh3PRjpy3LZhcMfolBAdsy4
	 Hk+l6JO/f4RjCDKsr4ptNkBj0S6L9zgCAtWxfoY3Mr4i8NVC1wg5zeGNE35by4lDetA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595740;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=hDXB52Q/wAoAsFFGzdGYm08BI7rKpn3ppHDlZprB7hw=;
	b=nvg2danyEuA/9K57Yhn1Wd3k55pIknq3MAvvQ4+zOfzcJqVf/5QX8ANVkmRboESGdbJl
	 jUI4O4JPVpq/c/X75WYiszke8GtD/NgvSyuVLTaKc3lObcswQ3yoes+hoB2Y45/dDxEzB
	 KB2s/JI2vycUg7QEncksirJ9JMJB6LM48r1VJiu9LdEQ/sg+oGYKv5Jx7E1MJStb+Sz+q
	 kLg2RMKhIsFA6Thmzwc3t6X8XjgZ/RXZ24APCvuZgYwBI1trnHhakKXH6nFdDUbmy4TJA
	 XoNjnYJc63/C6Ka+GNiFvlFgrHSSUTcRYpmHPuq/iNCpe3b6nLspEnLmOpl/D9Xy4Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=vdG5k0jL;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29E3606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A29E3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=vdG5k0jL
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261125083537epoutp01d2130eaf237ea1d37a6a21c230ff373b~rPM9q67Gl2181421814epoutp01C
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261125083537epoutp01d2130eaf237ea1d37a6a21c230ff373b~rPM9q67Gl2181421814epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595738;
	bh=hDXB52Q/wAoAsFFGzdGYm08BI7rKpn3ppHDlZprB7hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdG5k0jLw7c0WFe1UXglP1GFN+rDmQvcZ7mKBVrRPZP7bp7nvW+GQirb3LYJtIsOE
	 Px/N32nmhLNTS2ozkU98gwI/dLqahsf2Vg579+vY6cs/4cuncedn9gNVMB2fB9Ka0/
	 DYoqJg+gt70fhRbnDRmAZgoSWvkn2eVxNHkB0DDY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261125083537epcas5p299cfb15ec2b66b9181e3bbde88fc233f~rPM9QhljN2774027740epcas5p2Z;
	Wed, 25 Nov 2026 08:35:37 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jZCgD58dvz6B9mD; Wed, 25 Nov
	2026 08:35:36 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261125083536epcas5p2ad037e16d31d94ae028af92a5f77c356~rPM8CBD6T3005330053epcas5p2B;
	Wed, 25 Nov 2026 08:35:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083534epsmtip18edf324ef4db897046a7e8dc4767c36d~rPM6hL5Ih0450004500epsmtip1b;
	Wed, 25 Nov 2026 08:35:34 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 2/9] fs: add generic write-stream management
Date: Wed, 25 Nov 2026 14:03:06 +0530
Message-Id: <20261125083313.106334-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261125083313.106334-1-joshi.k@samsung.com>
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
X-CMS-MailID: 20261125083536epcas5p2ad037e16d31d94ae028af92a5f77c356
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083536epcas5p2ad037e16d31d94ae028af92a5f77c356
References: <20261125083313.106334-1-joshi.k@samsung.com>
	<CGME20261125083536epcas5p2ad037e16d31d94ae028af92a5f77c356@epcas5p2.samsung.com>

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
 fs/internal.h                 |   8 ++
 fs/write_streams.c            | 142 ++++++++++++++++++++++++++++++++++
 include/linux/write_streams.h |  29 +++++++
 4 files changed, 180 insertions(+), 1 deletion(-)
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
diff --git a/fs/internal.h b/fs/internal.h
index 967c8556c17f..81c5a65a08e0 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -368,3 +368,11 @@ void failfs_get_root(struct path *path);
 void __init failfs_init(void);
 bool failfs_mnt(const struct vfsmount *mnt);
 int failfs_current_chdir(void);
+
+/*
+ * fs/write_streams.c
+ */
+struct write_stream_pool;
+int write_stream_alloc_fd(struct write_stream_pool *pool, struct file *file);
+int write_stream_get_id(struct file *file,
+			const struct write_stream_pool *pool);
diff --git a/fs/write_streams.c b/fs/write_streams.c
new file mode 100644
index 000000000000..d277e12dc890
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
+#include "internal.h"
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
diff --git a/include/linux/write_streams.h b/include/linux/write_streams.h
new file mode 100644
index 000000000000..b7f097164f2f
--- /dev/null
+++ b/include/linux/write_streams.h
@@ -0,0 +1,29 @@
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
+#endif /* _LINUX_WRITE_STREAMS_H */
-- 
2.25.1

