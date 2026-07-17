Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01D819ADA4
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293001; cv=none; b=jVx1MBssO6bU9KllMg1TYkZ3++oLmZfzH6Rw1wx1ILGUjDjE8kCEbHXWf9MMQvEFzXZt7HLjxbzf1Ey4Ex8TGsh0wYTSQHkny7ujw9F3Aty1A9UpsV3Fbl2lLjKXdoNskjhirUaHrmSG3xzqo4TyLqr/8e+t/0lBwWYgLsovpOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293001; c=relaxed/simple;
	bh=jiS7YMveOXAkUiqn/OdRj6vopeqqmBcaeII2jBwZe3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=K//3wwzowgDivRut+Wk/9hOqV8Ang6wr9C1baDjtGkIIhKIfRSmbr07jeMinOj3C0bLtccOJ4poNZB5XvzcxST9W/L+gjUy4FNqRL7t6wJG5OHtK5EisDAqujvCF24BmooxwhX+L1pBaZ29vi21fplxkfEnTePdRO2Fx/JD9alo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=j60q0uyb; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="j60q0uyb"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260717125636epoutp04e78cae306134e3c1be524704fb0ab552~DFQbrTIc62800428004epoutp04g
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260717125636epoutp04e78cae306134e3c1be524704fb0ab552~DFQbrTIc62800428004epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784292996;
	bh=Ku97mRPeqDYT/F+KJUaE6g+JC7+HNZ0IrOGbfS0uTAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j60q0uyb4WFFN3EDlrsnihArPtO24gerMTCf1z0URBJm/GzGVl7dtudcunq59JY92
	 Uxy0hngnApR9b8klyTGaB2LzECP7jiKdcmniA4NyntsIp0zXjHrdFD1kuI+sZzWu5F
	 t6QVfxfJ2T2gjxcyZ/Yf62c70dFj8PSEhQQjWJck=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260717125634epcas5p162e36c0fc7882e468d86eec41d010822~DFQZ4VcCw1235712357epcas5p1E;
	Fri, 17 Jul 2026 12:56:34 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h1qfn6cGRz6B9m5; Fri, 17 Jul
	2026 12:56:33 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c~DFQYkpGQc1956419564epcas5p3J;
	Fri, 17 Jul 2026 12:56:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260717125630epsmtip29f1edf29f6d430aedb493fed223b2cee~DFQWFhA9q1293812938epsmtip24;
	Fri, 17 Jul 2026 12:56:30 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj1072538@gmail.com>, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v4 3/6] xfs: implement write-stream management support
Date: Fri, 17 Jul 2026 18:25:35 +0530
Message-Id: <20260717125538.508925-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717125538.508925-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c@epcas5p3.samsung.com>

From: Anuj Gupta <anuj1072538@gmail.com>

Implement FS_IOC_WRITE_STREAM_{GET_MAX,OPEN,SET,GET} handlers.

GET_MAX reports the max write stream ids.
OPEN allocates an fd for the unused write-stream and returns that.
SET binds that fd to an open file.
GET reports the stream-id value set on the file.

To track used write-streams, a per-mount bitmap is kept.
The stream fd's release handler clears the bit when the last reference
drops.

A new i_write_stream field on xfs_inode holds the bound stream id and
is propagated to the iomap during block mapping.

Write streams, filestreams, and write-life-time hints are mutually exclusive;
combining any two of them returns -EINVAL:
  - GET_MAX reports 0 whenever xfs_inode_is_filestream() is true,
    covering both mount-wide filestreams and the per-inode chattr
    flag. Also when the file is on the realtime device.
  - SET refuses to bind a stream to a file that already has a
    write-life-time hint (fcntl F_SET_RW_HINT), is filestream, or is
    on the realtime device.
  - chattr refuses to set the filestream or realtime flag on a file
    that already has a write stream set.

Suggested-by: Christoph Hellwig <hch@lst.de>
Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_icache.c |   1 +
 fs/xfs/xfs_inode.c  | 155 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |   8 +++
 fs/xfs/xfs_ioctl.c  |  69 ++++++++++++++++++++
 fs/xfs/xfs_iomap.c  |   1 +
 fs/xfs/xfs_mount.h  |   3 +
 fs/xfs/xfs_super.c  |  12 ++++
 7 files changed, 249 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9d8dd30bd927..7b9dda74122f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -129,6 +129,7 @@ xfs_inode_alloc(
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
+	ip->i_write_stream = 0;
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 15279d22a894..aafc3ffa6e0a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include <linux/iversion.h>
+#include <linux/anon_inodes.h>
 
 #include "xfs_platform.h"
 #include "xfs_fs.h"
@@ -47,6 +48,160 @@
 
 struct kmem_cache *xfs_inode_cache;
 
+int
+xfs_inode_max_write_streams(
+	struct xfs_inode	*ip)
+{
+	struct block_device	*bdev;
+	bool			is_filestream, is_realtime;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	is_filestream = xfs_inode_is_filestream(ip);
+	is_realtime = XFS_IS_REALTIME_INODE(ip);
+	bdev = xfs_inode_buftarg(ip)->bt_bdev;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!bdev || is_filestream || is_realtime)
+		return 0;
+
+	return bdev_max_write_streams(bdev);
+}
+
+uint16_t
+xfs_inode_get_write_stream(
+	struct xfs_inode	*ip)
+{
+	uint16_t	stream_id;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	stream_id = ip->i_write_stream;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	return stream_id;
+}
+
+struct xfs_write_stream {
+	struct xfs_mount	*mp;
+	uint16_t		stream_id;	/* 1-based */
+};
+
+static int
+xfs_write_stream_release(
+	struct inode		*inode,
+	struct file		*file)
+{
+	struct xfs_write_stream	*ws = file->private_data;
+	struct xfs_mount	*mp = ws->mp;
+
+	spin_lock(&mp->m_streams_lock);
+	clear_bit(ws->stream_id - 1, mp->m_streams_in_use);
+	spin_unlock(&mp->m_streams_lock);
+	kfree(ws);
+	return 0;
+}
+
+static const struct file_operations xfs_write_stream_fops = {
+	.release	= xfs_write_stream_release,
+	.llseek		= noop_llseek,
+};
+
+int
+xfs_inode_write_stream_open(
+	struct xfs_inode	*ip,
+	u32			flags,
+	u32			*stream_idp)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_write_stream	*ws;
+	int			max, slot, fd, ret;
+
+	if (flags & ~FS_WRITE_STREAM_OPEN_EXACT)
+		return -EINVAL;
+
+	max = xfs_inode_max_write_streams(ip);
+	if (!max)
+		return -EOPNOTSUPP;
+	ASSERT(mp->m_streams_in_use);
+
+	ws = kmalloc(sizeof(*ws), GFP_KERNEL);
+	if (!ws)
+		return -ENOMEM;
+
+	spin_lock(&mp->m_streams_lock);
+	if (flags & FS_WRITE_STREAM_OPEN_EXACT) {
+		if (!*stream_idp || *stream_idp > max) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+		slot = *stream_idp - 1;
+		if (test_bit(slot, mp->m_streams_in_use)) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+	} else {
+		slot = find_first_zero_bit(mp->m_streams_in_use, max);
+		if (slot >= max) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+	}
+	set_bit(slot, mp->m_streams_in_use);
+	spin_unlock(&mp->m_streams_lock);
+
+	ws->mp = mp;
+	ws->stream_id = slot + 1;	/* convert to 1-based */
+
+	fd = anon_inode_getfd("[xfs_write_stream]", &xfs_write_stream_fops, ws,
+			      O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		spin_lock(&mp->m_streams_lock);
+		clear_bit(slot, mp->m_streams_in_use);
+		spin_unlock(&mp->m_streams_lock);
+		kfree(ws);
+		return fd;
+	}
+
+	*stream_idp = ws->stream_id;
+	return fd;
+
+out_unlock:
+	spin_unlock(&mp->m_streams_lock);
+	kfree(ws);
+	return ret;
+}
+
+int
+xfs_inode_set_write_stream(
+	struct xfs_inode	*ip,
+	int			stream_fd)
+{
+	CLASS(fd, f)(stream_fd);
+	struct xfs_write_stream	*ws;
+	int			ret = 0;
+
+	if (!fd_file(f))
+		return -EBADF;
+	if (fd_file(f)->f_op != &xfs_write_stream_fops)
+		return -EINVAL;
+
+	ws = fd_file(f)->private_data;
+	if (ws->mp != ip->i_mount)
+		return -EINVAL;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	if (XFS_IS_REALTIME_INODE(ip) || xfs_inode_is_filestream(ip) ||
+	    VFS_I(ip)->i_write_hint != WRITE_LIFE_NOT_SET) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ip->i_write_stream = ws->stream_id;
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return ret;
+}
+
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 34c1038ebfcd..6abf82ffbf82 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -37,6 +37,9 @@ typedef struct xfs_inode {
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_ifork	i_af;		/* attribute fork */
 
+	/* Write stream information */
+	uint16_t		i_write_stream;
+
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	struct rw_semaphore	i_lock;		/* inode lock */
@@ -673,4 +676,9 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
 		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
 		struct xfs_dquot **pdqpp);
 
+int xfs_inode_max_write_streams(struct xfs_inode *ip);
+uint16_t xfs_inode_get_write_stream(struct xfs_inode *ip);
+int xfs_inode_write_stream_open(struct xfs_inode *ip, u32 flags,
+		u32 *stream_idp);
+int xfs_inode_set_write_stream(struct xfs_inode *ip, int stream_fd);
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1b53701bebea..8640e6389768 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -557,6 +557,12 @@ xfs_ioctl_setattr_xflags(
 	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
 	uint64_t		i_flags2;
 
+	if ((fa->fsx_xflags & FS_XFLAG_FILESTREAM) && ip->i_write_stream)
+		return -EINVAL;
+
+	if (rtflag && ip->i_write_stream)
+		return -EINVAL;
+
 	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
 		/* Can't change realtime flag if any extents are allocated. */
 		if (xfs_inode_has_filedata(ip))
@@ -1200,6 +1206,59 @@ xfs_ioctl_fs_counts(
 	return 0;
 }
 
+static int
+xfs_ioc_write_stream_open(
+	struct file		*filp,
+	void __user		*arg)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+	struct fs_write_stream_open wso;
+	int			fd;
+
+	if (copy_from_user(&wso, arg, sizeof(wso)))
+		return -EFAULT;
+
+	fd = xfs_inode_write_stream_open(ip, wso.flags, &wso.stream_id);
+	if (fd < 0)
+		return fd;
+
+	if (copy_to_user(arg, &wso, sizeof(wso)))
+		return -EFAULT;
+	return fd;
+}
+
+static int
+xfs_ioc_write_stream_set(
+	struct file		*filp,
+	unsigned long		arg)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+	return xfs_inode_set_write_stream(ip, (int)arg);
+}
+
+static int
+xfs_ioc_write_stream_get(
+	struct xfs_inode	*ip,
+	void __user		*arg)
+{
+	__u32 stream_id = xfs_inode_get_write_stream(ip);
+
+	return put_user(stream_id, (__u32 __user *)arg);
+}
+
+static int
+xfs_ioc_write_stream_get_max(
+	struct xfs_inode	*ip,
+	void __user		*arg)
+{
+	__u32 nr_streams = xfs_inode_max_write_streams(ip);
+
+	return put_user(nr_streams, (__u32 __user *)arg);
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1465,6 +1524,16 @@ xfs_file_ioctl(
 		return xfs_ioc_health_monitor(filp, arg);
 	case XFS_IOC_VERIFY_MEDIA:
 		return xfs_ioc_verify_media(filp, arg);
+	case FS_IOC_WRITE_STREAM_OPEN:
+		return xfs_ioc_write_stream_open(filp, (void __user *)arg);
+	case FS_IOC_WRITE_STREAM_SET:
+		return xfs_ioc_write_stream_set(filp, p);
+	case FS_IOC_WRITE_STREAM_GET:
+		return xfs_ioc_write_stream_get(XFS_I(file_inode(filp)),
+						(void __user *)arg);
+	case FS_IOC_WRITE_STREAM_GET_MAX:
+		return xfs_ioc_write_stream_get_max(XFS_I(file_inode(filp)),
+						    (void __user *)arg);
 
 	default:
 		return -ENOTTY;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 225c3de88d03..bf423897d916 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -144,6 +144,7 @@ xfs_bmbt_to_iomap(
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
+	iomap->write_stream = ip->i_write_stream;
 	if (mapping_flags & IOMAP_DAX) {
 		iomap->dax_dev = target->bt_daxdev;
 	} else {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 66a02d1b9ad7..1376963fb7e8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -349,6 +349,9 @@ typedef struct xfs_mount {
 
 	/* Index of uuid record in the uuid xarray. */
 	unsigned int		m_uuid_table_index;
+
+	unsigned long		*m_streams_in_use;
+	spinlock_t		m_streams_lock;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8531d526fc44..0e2bf6f7b378 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -805,6 +805,7 @@ xfs_mount_free(
 #ifdef DEBUG
 	kfree(mp->m_errortag);
 #endif
+	bitmap_free(mp->m_streams_in_use);
 	kfree(mp);
 }
 
@@ -1659,6 +1660,7 @@ xfs_fs_fill_super(
 	struct xfs_mount	*mp = sb->s_fs_info;
 	struct inode		*root;
 	int			flags = 0, error;
+	int			nr_streams;
 
 	mp->m_super = sb;
 
@@ -1708,6 +1710,15 @@ xfs_fs_fill_super(
 	if (error)
 		return error;
 
+	nr_streams = bdev_max_write_streams(mp->m_ddev_targp->bt_bdev);
+	if (nr_streams) {
+		mp->m_streams_in_use = bitmap_zalloc(nr_streams, GFP_KERNEL);
+		if (!mp->m_streams_in_use) {
+			error = -ENOMEM;
+			goto out_shutdown_devices;
+		}
+	}
+
 	if (xfs_debugfs) {
 		mp->m_debugfs = xfs_debugfs_mkdir(mp->m_super->s_id,
 						  xfs_debugfs);
@@ -2249,6 +2260,7 @@ xfs_init_fs_context(
 #endif
 
 	spin_lock_init(&mp->m_sb_lock);
+	spin_lock_init(&mp->m_streams_lock);
 	for (i = 0; i < XG_TYPE_MAX; i++)
 		xa_init(&mp->m_groups[i].xa);
 	mutex_init(&mp->m_growlock);
-- 
2.25.1

