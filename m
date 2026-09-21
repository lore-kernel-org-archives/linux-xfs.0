Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C18489FDF
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983163; cv=none; b=gYsSIGKN95f5AfDq6oySz9La0B6v6rsTBta7krLjIxaB8Sz1JhXpMBm3XYch4NFRp8DJ3dE0yjueq/fUh9r8nPUtxqdqS66SoshjAlZogkEDkXzWjEKZDo8YAxS3Np/1qr9qr5nEMkZZsaN11LOVaA9xEH8Q/nsFbsg5FpNvGL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983163; c=relaxed/simple;
	bh=MwJjP4sXyPVU5sdpo+CrOIaQ1fBAZTyYwdDQUsMHzmA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qWGqhDgdPpj/jhkzHlHDZmNibNCmtcQ5h+AKJDfkiag3yxqurr6OyTtteHkde6mhSaML5CiC2iqZVWobHRJrctzA73+4jXz7PbHLnCi+8Y+GQBpOkVhEWKEhZFU93ufdb8Q5KDx8x77T20blNsIVKcMwJVf0uF0NAeg2RHYx4Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kGeOyZ95; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kGeOyZ95"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260921093239epoutp0225fd36af87558ef9209028318386cf47~XTDMsEDLF0919509195epoutp02R
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260921093239epoutp0225fd36af87558ef9209028318386cf47~XTDMsEDLF0919509195epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789983159;
	bh=LDCoW+P9Cc5ub2W8j6lbrs1jtn0ETeYVnu4Mjr9FFUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGeOyZ95tQ0foOlgcjoBI8WlYLCn15JI0OS4faJoY2AbFIsSpqVaJAQmMVDgOpCBJ
	 ft2ATJ5favQaYnfMUsqvc8FjFytBHAl9CnshCHmTrVole8nDM0yO6wWeT3aG0jlqpX
	 j9N/02beyGzq32yn8zDyVGhYUDi/aHan5EckSB68=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260921093239epcas5p1cf7c19e2547ba3b2c554f53d124ec6e5~XTDMQFtIx3092430924epcas5p1_;
	Mon, 21 Sep 2026 09:32:39 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.88]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hpJ122hptz6B9mG; Mon, 21 Sep
	2026 09:32:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260921093237epcas5p21b8417ec030f291b39f0d749c01689fe~XTDLLbTjL0113601136epcas5p2v;
	Mon, 21 Sep 2026 09:32:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260921093236epsmtip1e000e51e9b09ae7018fadfd6cb3748ef~XTDJe2D8m0415804158epsmtip1e;
	Mon, 21 Sep 2026 09:32:35 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v5 4/8] xfs: implement software write-stream management
Date: Mon, 21 Sep 2026 15:01:43 +0530
Message-Id: <20260921093147.59935-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921093147.59935-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260921093237epcas5p21b8417ec030f291b39f0d749c01689fe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921093237epcas5p21b8417ec030f291b39f0d749c01689fe
References: <20260921093147.59935-1-joshi.k@samsung.com>
	<CGME20260921093237epcas5p21b8417ec030f291b39f0d749c01689fe@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Implement the FS_IOC_WRITE_STREAM_* handlers.

Keep a stream pool in the data device buftarg, sized from the AG count.
The id is stored in inode->i_write_stream and is not written to disk.

Write streams, filestreams and write life time hints are mutually
exclusive. GET_MAX reports zero for filestream and realtime inodes, SET
rejects those and any inode carrying a hint, and setattr refuses to turn
on filestream or realtime placement while a stream is attached.

ALLOC is restricted to CAP_SYS_ADMIN.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_buf.c   | 30 ++++++++++++++++++
 fs/xfs/xfs_buf.h   |  6 ++++
 fs/xfs/xfs_inode.c | 69 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |  4 +++
 fs/xfs/xfs_ioctl.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c |  5 +++
 6 files changed, 193 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8256c1d13ce2..4e84528b05cb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1647,6 +1647,7 @@ void
 xfs_free_buftarg(
 	struct xfs_buftarg	*btp)
 {
+	write_stream_pool_destroy(&btp->bt_stream_pool);
 	xfs_destroy_buftarg(btp);
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 	/* the main block device is closed by kill_block_super */
@@ -1684,6 +1685,35 @@ xfs_configure_buftarg_atomic_writes(
 	btp->bt_awu_max = max_bytes;
 }
 
+#define XFS_MAX_SW_WRITE_STREAMS	U8_MAX
+
+/* Heuristic to derive software write stream count from a group topology */
+static unsigned int
+xfs_sw_write_stream_count(
+	unsigned int		nr_groups)
+{
+	unsigned int		group_set_size;
+
+	if (nr_groups >= 16)
+		group_set_size = 4;
+	else if (nr_groups >= 8)
+		group_set_size = 2;
+	else
+		group_set_size = 1;
+	return min(nr_groups / group_set_size, XFS_MAX_SW_WRITE_STREAMS);
+}
+
+int
+xfs_buftarg_init_streams(
+	struct xfs_buftarg	*btp,
+	unsigned int		nr_groups)
+{
+	unsigned int		nr_streams;
+
+	nr_streams = xfs_sw_write_stream_count(nr_groups);
+	return write_stream_pool_init(&btp->bt_stream_pool, nr_streams);
+}
+
 /* Configure a buffer target that abstracts a block device. */
 int
 xfs_configure_buftarg(
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a4729253b56f..b5292e5731e3 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -15,6 +15,7 @@
 #include <linux/uio.h>
 #include <linux/list_lru.h>
 #include <linux/lockref.h>
+#include <linux/write_streams.h>
 
 extern struct kmem_cache *xfs_buf_cache;
 
@@ -102,6 +103,9 @@ struct xfs_buftarg {
 	unsigned int		bt_awu_min;
 	unsigned int		bt_awu_max;
 
+	/* slot pool for stream fds on this device */
+	struct write_stream_pool bt_stream_pool;
+
 	struct rhashtable	bt_hash;
 };
 
@@ -360,6 +364,8 @@ extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
 int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
 		xfs_fsblock_t nr_blocks);
+int xfs_buftarg_init_streams(struct xfs_buftarg *btp,
+		unsigned int nr_groups);
 
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 030a7c8f2c12..df0a37c4d68a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include <linux/iversion.h>
+#include <linux/write_streams.h>
 
 #include "xfs_platform.h"
 #include "xfs_fs.h"
@@ -47,6 +48,74 @@
 
 struct kmem_cache *xfs_inode_cache;
 
+/* Number of write streams available to this inode. */
+int
+xfs_inode_max_write_streams(
+	struct xfs_inode	*ip)
+{
+	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
+
+	if (xfs_inode_is_filestream(ip))
+		return 0;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return 0;
+	return write_stream_pool_count(&xfs_inode_buftarg(ip)->bt_stream_pool);
+}
+
+/* Bind the write stream named by @stream_fd to @ip */
+int
+xfs_inode_set_write_stream(
+	struct xfs_inode	*ip,
+	int			stream_fd)
+{
+	CLASS(fd, f)(stream_fd);
+	struct xfs_buftarg	*target;
+	int			id, error = 0;
+
+	if (!fd_file(f))
+		return -EBADF;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	target = xfs_inode_buftarg(ip);
+	id = write_stream_get_id(fd_file(f), &target->bt_stream_pool);
+	if (id < 0) {
+		error = id;
+		goto out_unlock;
+	}
+
+	/* Filestream and write-stream are mutually exclusive */
+	if (xfs_inode_is_filestream(ip)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* keep write stream and write life time hint mutually exclusive */
+	spin_lock(&VFS_I(ip)->i_lock);
+	if (VFS_I(ip)->i_write_hint != WRITE_LIFE_NOT_SET) {
+		spin_unlock(&VFS_I(ip)->i_lock);
+		error = -EBUSY;
+		goto out_unlock;
+	}
+	WRITE_ONCE(VFS_I(ip)->i_write_stream, id);
+	spin_unlock(&VFS_I(ip)->i_lock);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+void
+xfs_inode_clear_write_stream(
+	struct xfs_inode	*ip)
+{
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	WRITE_ONCE(VFS_I(ip)->i_write_stream, 0);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+}
+
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1602027cd0aa..c053f105d2fa 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -672,4 +672,8 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
 		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
 		struct xfs_dquot **pdqpp);
 
+int xfs_inode_max_write_streams(struct xfs_inode *ip);
+int xfs_inode_set_write_stream(struct xfs_inode *ip, int stream_fd);
+void xfs_inode_clear_write_stream(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 96ca3e480cb9..bc6957ad06cb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -557,6 +557,11 @@ xfs_ioctl_setattr_xflags(
 	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
 	uint64_t		i_flags2;
 
+	/* refuse a filestream/realtime flag change while a stream is attached */
+	if (READ_ONCE(VFS_I(ip)->i_write_stream) &&
+	    ((fa->fsx_xflags & FS_XFLAG_FILESTREAM) || rtflag))
+		return -EINVAL;
+
 	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
 		/* Can't change realtime flag if any extents are allocated. */
 		if (xfs_inode_has_filedata(ip))
@@ -1200,6 +1205,73 @@ xfs_ioctl_fs_counts(
 	return 0;
 }
 
+static int
+xfs_ioc_write_stream_get_max(
+	struct file		*filp,
+	void __user		*arg)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+	__u32			max;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	max = xfs_inode_max_write_streams(ip);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	return put_user(max, (__u32 __user *)arg);
+}
+
+static int
+xfs_ioc_write_stream_alloc(
+	struct file		*filp)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+	struct xfs_buftarg	*target;
+	int			max;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	max = xfs_inode_max_write_streams(ip);
+	target = xfs_inode_buftarg(ip);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!max)
+		return -EOPNOTSUPP;
+	return write_stream_alloc_fd(&target->bt_stream_pool, filp);
+}
+
+static int
+xfs_ioc_write_stream_set(
+	struct file		*filp,
+	void __user		*arg)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+	struct fs_write_stream_set set;
+
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+	if (copy_from_user(&set, arg, sizeof(set)))
+		return -EFAULT;
+	if (set.flags & ~FS_WRITE_STREAM_SET_CLEAR)
+		return -EINVAL;
+
+	/* Regular files only. */
+	if (!S_ISREG(VFS_I(ip)->i_mode))
+		return -EINVAL;
+
+	if (!inode_owner_or_capable(file_mnt_idmap(filp), VFS_I(ip)))
+		return -EPERM;
+
+	if (set.flags & FS_WRITE_STREAM_SET_CLEAR) {
+		if (set.stream_fd != -1)
+			return -EINVAL;
+		xfs_inode_clear_write_stream(ip);
+		return 0;
+	}
+	return xfs_inode_set_write_stream(ip, set.stream_fd);
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1466,6 +1538,13 @@ xfs_file_ioctl(
 	case XFS_IOC_VERIFY_MEDIA:
 		return xfs_ioc_verify_media(filp, arg);
 
+	case FS_IOC_WRITE_STREAM_GET_MAX:
+		return xfs_ioc_write_stream_get_max(filp, arg);
+	case FS_IOC_WRITE_STREAM_ALLOC:
+		return xfs_ioc_write_stream_alloc(filp);
+	case FS_IOC_WRITE_STREAM_SET:
+		return xfs_ioc_write_stream_set(filp, (void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b24db75eaedc..443b3d847150 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -608,6 +608,11 @@ xfs_setup_devices(
 	if (error)
 		return error;
 
+	error = xfs_buftarg_init_streams(mp->m_ddev_targp,
+			mp->m_sb.sb_agcount);
+	if (error)
+		return error;
+
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
 		unsigned int	log_sector_size = BBSIZE;
 
-- 
2.25.1

