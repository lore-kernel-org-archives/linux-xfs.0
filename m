Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595744;
	b=sWbuPyHnjCNQLnXvZs42xZTYv6JW+OzH2ZwIbplf8E0Iro2fWjqRNiPgVQ2T+iyxDTWx
	 njACTz8ZWSc/FpwRjhYaic2t2kS/5X9wInZmZrCWDQ3m04v4WjV7iXbHMMQH0NMh0N8eG
	 mNKR5+Vz8JhvZthYHiWoFAP+Z5cprgsTAT8ENkPvG/8OV9PlSusMBbofP94JY1J+h3Zb9
	 aBCcnlgIJ1vAfN6Vc3zX7ruXAErp6FTgdgQ0KW9rKORrHWRXcUP4PZIom/IeZ/92cLUMy
	 YY/6zR8a6HErQIPSizCUAwtj47AI7ej121CQqBGNYrS3vZQU4uD/rhKL8HZIWGDZquw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595744;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=PhHbrgP88BDoYkvE8o+J3fzap+xsy9oidgREXyEeWNo=;
	b=G2oF+sJE83C9Yss8Xw5Y+6/hawC8bdv5IgwzT1mk2imz0EgU3MzOn+hz6tVVWi+MWAd5
	 Qp0AOWUx2v/bGUXy3bWuf0edKroYfFE60BfbhkoGH8cunitfI+ff1hf3jYzRPiOtxC3u4
	 hyZsbt735tbS1sB1bssF1h6Z6Zj2ofMYpmL04zanQE4pOppRKkYJh3DXlLkkhgpw/mItV
	 0ABNy+GrOhX5AJCHmQJbJ8wMQH4yMPMPxxkgW4e483MmscIcGHMi4ZbWLp/D/wgI3yFnq
	 +QmqKi7EqRiEvjGi9PHaqRZHn67kW9RnOXPrt8l1alpXGHhtUy51EPlzzAiYSm79q0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EO+q+Wny;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041C4606A338
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 041C4606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EO+q+Wny
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261125083541epoutp03b904088ad93327216c35273e8794796e~rPNBEldxa1704417044epoutp034
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261125083541epoutp03b904088ad93327216c35273e8794796e~rPNBEldxa1704417044epoutp034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595741;
	bh=PhHbrgP88BDoYkvE8o+J3fzap+xsy9oidgREXyEeWNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EO+q+Wnyf3fhtm7e5e/gTOyoxhbdT7ubOlinFo9CnHLkOJXijyDaCltdRdLwZAR6b
	 80Ijp5q7GEFu5kmg7fldEgeJ4YpsRgcKnP0ryv/u9C9Ak3vYOWwdCfn6tJx550f2Qn
	 0Mbzyb9gn83ZoYwI91VfC8SiQppSV3yfYIGvTwcQ=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261125083541epcas5p289e72578305f9688894ae04306fcf29d~rPNAn3XcG3005330053epcas5p2R;
	Wed, 25 Nov 2026 08:35:41 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jZCgJ2kDSz6B9mb; Wed, 25 Nov
	2026 08:35:40 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261125083539epcas5p25cb8fafef91a915a07b89007d9fecf1c~rPM-fw97u2774027740epcas5p2g;
	Wed, 25 Nov 2026 08:35:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083538epsmtip17bc2dae6e6ce8589cd90714b055c8bd4~rPM9-rF1G0486504865epsmtip1M;
	Wed, 25 Nov 2026 08:35:38 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 4/9] fs: handle the write-stream ioctls in common code
Date: Wed, 25 Nov 2026 14:03:08 +0530
Message-Id: <20261125083313.106334-5-joshi.k@samsung.com>
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
X-CMS-MailID: 20261125083539epcas5p25cb8fafef91a915a07b89007d9fecf1c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083539epcas5p25cb8fafef91a915a07b89007d9fecf1c
References: <20261125083313.106334-1-joshi.k@samsung.com>
	<CGME20261125083539epcas5p25cb8fafef91a915a07b89007d9fecf1c@epcas5p2.samsung.com>

FS_IOC_WRITE_STREAM_* ioctls involve common handling, such as argument
validation, permission and uapi semantics checks etc.
Centralize the common handling so that each filesystem does not have to
reimplement.

Suggested-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/write_streams.c            | 115 ++++++++++++++++++++++++++++++++++
 include/linux/write_streams.h |   6 ++
 2 files changed, 121 insertions(+)

diff --git a/fs/write_streams.c b/fs/write_streams.c
index 50b0b0769c38..da9d4a62d63b 100644
--- a/fs/write_streams.c
+++ b/fs/write_streams.c
@@ -2,11 +2,13 @@
 /* Generic write-stream fd management. */
 #include <linux/anon_inodes.h>
 #include <linux/bitmap.h>
+#include <linux/capability.h>
 #include <linux/err.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 #include <linux/write_streams.h>
 
 #include "internal.h"
@@ -162,3 +164,116 @@ int inode_set_write_stream(struct inode *inode, u16 id)
 	spin_unlock(&inode->i_lock);
 	return 0;
 }
+
+static int ioctl_write_stream_get_max(struct file *file, __u32 __user *argp,
+				      write_stream_pool_fn pool_fn)
+{
+	struct write_stream_pool *pool = pool_fn(file_inode(file));
+	__u32 max = 0;
+
+	if (pool)
+		max = write_stream_pool_count(pool);
+	return put_user(max, argp);
+}
+
+static int ioctl_write_stream_alloc(struct file *file,
+				    write_stream_pool_fn pool_fn)
+{
+	struct write_stream_pool *pool;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	pool = pool_fn(file_inode(file));
+	if (!pool)
+		return -EOPNOTSUPP;
+	return write_stream_alloc_fd(pool, file);
+}
+
+static int ioctl_write_stream_attach(struct inode *inode, int stream_fd,
+				     write_stream_pool_fn pool_fn)
+{
+	CLASS(fd, f)(stream_fd);
+	struct write_stream_pool *pool;
+	int id, error;
+
+	if (fd_empty(f))
+		return -EBADF;
+
+	/*
+	 * Serialize against vfs_fileattr_set(), which takes the same lock to
+	 * change the flags that select the pool.
+	 */
+	inode_lock(inode);
+	pool = pool_fn(inode);
+	if (!pool) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+	id = write_stream_get_id(fd_file(f), pool);
+	if (id < 0) {
+		error = id;
+		goto out_unlock;
+	}
+	error = inode_set_write_stream(inode, id);
+out_unlock:
+	inode_unlock(inode);
+	return error;
+}
+
+static int ioctl_write_stream_set(struct file *file,
+				  struct fs_write_stream_set __user *argp,
+				  write_stream_pool_fn pool_fn)
+{
+	struct inode *inode = file_inode(file);
+	struct fs_write_stream_set set;
+
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+	if (copy_from_user(&set, argp, sizeof(set)))
+		return -EFAULT;
+	if (set.flags & ~FS_WRITE_STREAM_SET_CLEAR)
+		return -EINVAL;
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+	if (IS_IMMUTABLE(inode))
+		return -EPERM;
+	if (!inode_owner_or_capable(file_mnt_idmap(file), inode))
+		return -EPERM;
+
+	if (!(set.flags & FS_WRITE_STREAM_SET_CLEAR))
+		return ioctl_write_stream_attach(inode, set.stream_fd, pool_fn);
+	if (set.stream_fd != -1)
+		return -EINVAL;
+
+	inode_lock(inode);
+	inode_set_write_stream(inode, WRITE_STREAM_NOT_SET);
+	inode_unlock(inode);
+	return 0;
+}
+
+/**
+ * write_stream_ioctl - handle the FS_IOC_WRITE_STREAM_* ioctls
+ * @file: file the ioctl is issued on
+ * @cmd: ioctl command
+ * @argp: ioctl argument
+ * @pool_fn: callback that returns the pool serving an inode, or
+ *	NULL if that inode cannot use write streams; may sleep, and is
+ *	called with the inode lock held for FS_IOC_WRITE_STREAM_SET
+ *
+ * Called by a filesystem from its ioctl handler.  GET_MAX and ALLOC work on
+ * any file the filesystem passes in, SET on regular files only.
+ */
+long write_stream_ioctl(struct file *file, unsigned int cmd,
+			void __user *argp, write_stream_pool_fn pool_fn)
+{
+	switch (cmd) {
+	case FS_IOC_WRITE_STREAM_GET_MAX:
+		return ioctl_write_stream_get_max(file, argp, pool_fn);
+	case FS_IOC_WRITE_STREAM_ALLOC:
+		return ioctl_write_stream_alloc(file, pool_fn);
+	case FS_IOC_WRITE_STREAM_SET:
+		return ioctl_write_stream_set(file, argp, pool_fn);
+	}
+	return -ENOTTY;
+}
+EXPORT_SYMBOL_GPL(write_stream_ioctl);
diff --git a/include/linux/write_streams.h b/include/linux/write_streams.h
index de561540548a..c5a63422a534 100644
--- a/include/linux/write_streams.h
+++ b/include/linux/write_streams.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 
 struct file;
+struct inode;
 
 /* i_write_stream value of an inode that has no write stream */
 #define WRITE_STREAM_NOT_SET	0
@@ -29,4 +30,9 @@ write_stream_pool_count(const struct write_stream_pool *pool)
 int  write_stream_pool_init(struct write_stream_pool *pool, unsigned int nr);
 void write_stream_pool_destroy(struct write_stream_pool *pool);
 
+typedef struct write_stream_pool *(*write_stream_pool_fn)(struct inode *inode);
+
+long write_stream_ioctl(struct file *file, unsigned int cmd,
+			void __user *argp, write_stream_pool_fn pool_fn);
+
 #endif /* _LINUX_WRITE_STREAMS_H */
-- 
2.25.1

