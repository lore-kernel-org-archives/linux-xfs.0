Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705709;
	b=dyUdVWeZiw4vfAeRR9bBLMMHS2SXjox1S+CjF9G/cOU1S0AdhptMaT4T+I5ad57XCRyc
	 PBv4e8SBNDSY7T5DwghY4g58ws4SGaI0B6EN7MDYWCqSHRf99gXRXX086bQpmuYWt10v9
	 9KgifrHLd0HOV1qBf/j9Yo3hAIDHrph2D6dNj6JwEx0LrBZT8kVFzQHuZmiR9S0ylg4PW
	 uFe8AHdsQzvOTifmFJkwDgbuXwLpQ0elyWhKEn3hjiqlioGJXevanSj8eDjCIwSxMIg1A
	 zEMSx7G/LsxLmXJGz5jkaUu8I3BqQ2gDA13WD2c8rijabuCle9Xz3EbbZ31ZQ65AhwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705709;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=qUoTF1GFibUaOrUhwHp4xkivi/UPZyIB5VH8PprULIM=;
	b=Fuj8BN5NvzB7a619y5NQQcEP1p6JK19T0N+t3J/yYlErXoILxfLiwUjU/pGnmMI2yMWG
	 BmoWqdtnkaWgw8LKa3FAV6m8YhAgXCc0g8CpM4HLMt6cJAFNP1AHghV1a/wyAuDma1JiC
	 j09ObecoTNqLcnj5xRwvM+MTTymTSY6UjwiTok+9oYQhJaq0hKx03B2KcDZLfUA0Pd1Qr
	 zd6ZCw99cZXRAQ8DvtYhiOQOXTZJ8kFrw9/LjtOm6O6gHuXxUaS0hMCt9DdHXui14TZBO
	 enwtDGdBXHdFwbkaqHq1HyL1RS1OlGuG8LpzNDFR1FiF+8jgcAeqgV+Zt3xxv8meomA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="rJPakO/B";
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC3606A33C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0AC3606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=rJPakO/B
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261103113506epoutp0133d07e88a2496f83ea66aad9116ec1f4~khdZE_MAI2985029850epoutp01C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261103113506epoutp0133d07e88a2496f83ea66aad9116ec1f4~khdZE_MAI2985029850epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793705706;
	bh=qUoTF1GFibUaOrUhwHp4xkivi/UPZyIB5VH8PprULIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJPakO/BkHzYtMJ0ZZDM+OGisBJBjfM+EPgmkChC/ZP/kpfXKFJxP8dWXPJ0K3dx6
	 sKATKs+BxF4f6Ah1Sv22rxO/BG8ufnzkLp/CgEp3Y6du1NFuT5KYbqx4CxLo3G9gut
	 NL90Su9a4fU9PvZHfWf/ALGlepvVf9xJtKMYmFD0=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261103113505epcas5p3a507f2dcfdde11559669baf8d3d1bec1~khdYNLj8a2877828778epcas5p3q;
	Tue,  3 Nov 2026 11:35:05 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.93]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jJmhT2DjNz2SSKd; Tue,  3 Nov
	2026 11:35:05 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111031epcas5p19a4cdbbf45612ff2c541b2aa0bb6cc30~khH7E7ekb0206702067epcas5p12;
	Tue,  3 Nov 2026 11:10:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111029epsmtip17c6b1e977c017f9df0c60d49ab0ab5a8~khH5UGw5v2910629106epsmtip1L;
	Tue,  3 Nov 2026 11:10:29 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v7 4/8] xfs: implement software write-stream management
Date: Tue,  3 Nov 2026 16:36:36 +0530
Message-Id: <20261103110640.1000095-5-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261103111031epcas5p19a4cdbbf45612ff2c541b2aa0bb6cc30
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111031epcas5p19a4cdbbf45612ff2c541b2aa0bb6cc30
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111031epcas5p19a4cdbbf45612ff2c541b2aa0bb6cc30@epcas5p1.samsung.com>

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
 fs/xfs/xfs_buf.c   | 31 ++++++++++++++++++
 fs/xfs/xfs_buf.h   |  6 ++++
 fs/xfs/xfs_inode.c | 61 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |  4 +++
 fs/xfs/xfs_ioctl.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c |  5 +++
 6 files changed, 186 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6c93b4f5629c..d8ce03a9f49c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1648,6 +1648,7 @@ void
 xfs_free_buftarg(
 	struct xfs_buftarg	*btp)
 {
+	write_stream_pool_destroy(&btp->bt_stream_pool);
 	xfs_destroy_buftarg(btp);
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 	/* the main block device is closed by kill_block_super */
@@ -1685,6 +1686,36 @@ xfs_configure_buftarg_atomic_writes(
 	btp->bt_awu_max = max_bytes;
 }
 
+/* the block layer can tag I/O with at most U8_MAX write streams */
+#define XFS_MAX_WRITE_STREAMS		U8_MAX
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
+	return min(nr_groups / group_set_size, XFS_MAX_WRITE_STREAMS);
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
index 05a14da28031..636f039e8f71 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include <linux/iversion.h>
+#include <linux/write_streams.h>
 
 #include "xfs_platform.h"
 #include "xfs_fs.h"
@@ -47,6 +48,66 @@
 
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
+	error = inode_set_write_stream(VFS_I(ip), id);
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
+	inode_set_write_stream(VFS_I(ip), WRITE_STREAM_NOT_SET);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+}
+
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 75eff68c1e39..15cd735d8fe9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -681,4 +681,8 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
 		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
 		struct xfs_dquot **pdqpp);
 
+int xfs_inode_max_write_streams(struct xfs_inode *ip);
+int xfs_inode_set_write_stream(struct xfs_inode *ip, int stream_fd);
+void xfs_inode_clear_write_stream(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f81b6e52ac40..2490b6ec5f4e 100644
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
@@ -1436,6 +1441,73 @@ xfs_ioc_free_eofblocks(
 	return xfs_blockgc_free_space(mp, &icw);
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
@@ -1575,6 +1647,13 @@ xfs_file_ioctl(
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
index 5a06132aa384..a541e97b580f 100644
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

