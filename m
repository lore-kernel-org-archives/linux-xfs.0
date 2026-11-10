Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.154.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306960;
	b=zsAiIpfsS1nRzIbEbSBRmCSIcnQWrqfA/mVU77sOxgWF9yxdngDhQ2EuA0djceKzmNZW
	 f7J2j2sB53v8EeQkOqN0b5D/vMVu7sxuWsumD+0rqM6xhR9xEj+sqOhV5qgnzD+oObR7y
	 uPdljUX9y/FDWNOQ5SV13Z/ikzOY76I/FJO8JKjJozux5d8sBjALP016jkFEa7tRXO83x
	 ptBOwWEnXR08sjgmkCMDKZUqCYiAllj3yxcqj/Sgt5XgKoWvijVW8zW7fND/llyxAmT4u
	 Jusq1AzueYbo7wrH5TALX5cQOW2O+lflH9PcD4t6ps7dp+0B7Bw8J80ebotral8Ypdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306960;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MHhWqLUMEmJVtyNWP7QjgiAj4P/zp+rHpR0xYJNCdwE=;
	b=GARbPicNOV5gXFcjTSEwmy9CQeagCTjea/cc6aDKwLAkXXXWuL3JCpc1WqpmXc7t7qJI
	 qGF0QPgaKX4CDiwyeUHb9XQ4DNiAnFRCWy43jdNAlHyZK43VtIY5+foJrCwWHvIoNmQxP
	 arlUWmo8g3KEvdDdryGVejGKVlRkpPoCo2/jAjITJK7SWtl1Q8fW4oLfjpqn9MCYPV92r
	 dpfvr/pA/nMpiZwIsvwg3GmDCrFZF4V7HapnrwgD9YMZZmgFAdxGS8BoSZC19+A3S1HB7
	 YlE0MD6TF7eMXJGhsuxmY0ZBiVWui3s0grxCO3LKxl3pcpiflIsi/iRPuegfnr7KKYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=REHqk2EX;
	arc=none smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC5606A32A;
	Tue, 10 Nov 2026 10:35:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8DC5606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=REHqk2EX
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794306959; x=1825842959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZsvpxIJKKKnasa1WJL6aO4Y7U4EQ2BvqN0DZg6fz6zU=;
  b=REHqk2EXJQE+2QdmAQYGn8wXW2zUj0OPJ9RgkDU/9tYNvfAmmWSsOGEq
   cluc89Wq8T+GADfd0lE9NY+3k+Tk9JgSyCIgnenbznPpMWzXAZ9YOWeDM
   ceQjlYRLr3aL6SDdqsCVeKIVrtK+mNUFv/QvB3v7z7pF0B5iAgEfRL3Ug
   0+FIOpqWZIe8uwhj0EaHtu/wgp46W3Qn12IKAjn+SthHrIaX50Wj9yccr
   XTk//q6BOGUViK/0SPXdI+za3Uoyf/zMB4QXed9Dgqy/pn/GQsjiwXw6Z
   z81773+R0vZJms72/3zAXZdGxnplRIBG2QwNguE0p0BXX+yrespXZy1HQ
   A==;
X-CSE-ConnectionGUID: VWGMQqSBRPWLAvnz5M+j9w==
X-CSE-MsgGUID: YBreUmypQF+Vd3De8RLAMw==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="158891394"
Received: from h199-255-45-14.hgst.com (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2026 18:35:59 +0800
X-CSE-ConnectionGUID: noOONBcCQF6cGt0ioBdbIA==
X-CSE-MsgGUID: Eq5WQ4yVToKZvixtcWmxGw==
IronPort-SDR: 6af2f38f_o4ufc6eYId0XULcgvKQUK+/R2agG6Qjws5RogYmpSFqPKF0
 TbLVWgDNcIKGwXaBFfdG6TSbfvpZqBAq+cZTsMg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 02:35:59 -0800
X-CSE-ConnectionGUID: wkFI7fp5RK2egAC7hQp6rA==
X-CSE-MsgGUID: n2rhVuW1RY+fM6QKNbGw2g==
WDCIronportException: Internal
Received: from unknown (HELO gcv.wireless.wdc) ([10.224.5.251])
  by uls-op-esai1-o.wdc.com with ESMTP; 10 Nov 2026 02:35:56 -0800
From: Hans Holmberg <hans.holmberg@wdc.com>
To: brauner@kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	dgc@kernel.org,
	cem@kernel.org,
	jack@suse.cz,
	axboe@kernel.dk,
	kbusch@kernel.org
Cc: dlemoal@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [RFC 1/4] xfs: report write streams for zoned realtime inodes
Date: Tue, 10 Nov 2026 11:35:37 +0100
Message-ID: <20261110103540.46876-2-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110103540.46876-1-hans.holmberg@wdc.com>
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
 <20261110103540.46876-1-hans.holmberg@wdc.com>
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

Zoned file systems place user data in open zones, so the number of
write streams that can be kept apart is the number of zones that can
be open for user writes: max_open_zones minus the zones reserved for
garbage collection.

Track the write stream slots for zoned realtime inodes in the zone
info instead of the buftarg, as the buftarg is shared with the data
device for internal RT devices, and its pool is sized for AG based
placement.  Add xfs_inode_write_stream_pool to pick the pool backing
an inode, and use it for the write stream get max, alloc and set
ioctls.

Zoned stream ids name open zone slots and not hardware streams, so
don't pass them on to the device.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_inode.c      | 25 +++++++++++++++----------
 fs/xfs/xfs_inode.h      |  2 ++
 fs/xfs/xfs_ioctl.c      |  6 +++---
 fs/xfs/xfs_iomap.c      |  8 ++++++--
 fs/xfs/xfs_zone_alloc.c | 13 +++++++++++++
 fs/xfs/xfs_zone_alloc.h |  7 +++++++
 fs/xfs/xfs_zone_priv.h  |  7 +++++++
 7 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b5f0f80b2967..ab71f3bc5c03 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -45,9 +45,20 @@
 #include "xfs_xattr.h"
 #include "xfs_inode_util.h"
 #include "xfs_metafile.h"
+#include "xfs_zone_alloc.h"
 
 struct kmem_cache *xfs_inode_cache;
 
+/* Write stream pool that backs data placement for @ip. */
+struct write_stream_pool *
+xfs_inode_write_stream_pool(
+	struct xfs_inode	*ip)
+{
+	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_zoned(ip->i_mount))
+		return xfs_zoned_write_stream_pool(ip->i_mount);
+	return &xfs_inode_buftarg(ip)->bt_stream_pool;
+}
+
 /* Number of write streams available to this inode. */
 int
 xfs_inode_max_write_streams(
@@ -57,9 +68,7 @@ xfs_inode_max_write_streams(
 
 	if (xfs_inode_is_filestream(ip))
 		return 0;
-	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_zoned(ip->i_mount))
-		return 0;
-	return write_stream_pool_count(&xfs_inode_buftarg(ip)->bt_stream_pool);
+	return write_stream_pool_count(xfs_inode_write_stream_pool(ip));
 }
 
 /* Bind the write stream named by @stream_fd to @ip */
@@ -69,19 +78,15 @@ xfs_inode_set_write_stream(
 	int			stream_fd)
 {
 	CLASS(fd, f)(stream_fd);
-	struct xfs_buftarg	*target;
+	struct write_stream_pool *pool;
 	int			id, error = 0;
 
 	if (!fd_file(f))
 		return -EBADF;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_zoned(ip->i_mount)) {
-		error = -EINVAL;
-		goto out_unlock;
-	}
 
-	target = xfs_inode_buftarg(ip);
-	id = write_stream_get_id(fd_file(f), &target->bt_stream_pool);
+	pool = xfs_inode_write_stream_pool(ip);
+	id = write_stream_get_id(fd_file(f), pool);
 	if (id < 0) {
 		error = id;
 		goto out_unlock;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c053f105d2fa..51f8cdd0b39f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -21,6 +21,7 @@ struct xfs_inode_log_item;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot;
+struct write_stream_pool;
 
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
@@ -672,6 +673,7 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
 		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
 		struct xfs_dquot **pdqpp);
 
+struct write_stream_pool *xfs_inode_write_stream_pool(struct xfs_inode *ip);
 int xfs_inode_max_write_streams(struct xfs_inode *ip);
 int xfs_inode_set_write_stream(struct xfs_inode *ip, int stream_fd);
 void xfs_inode_clear_write_stream(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4c0aff34e3c3..1f105f3cf221 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1226,7 +1226,7 @@ xfs_ioc_write_stream_alloc(
 	struct file		*filp)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(filp));
-	struct xfs_buftarg	*target;
+	struct write_stream_pool *pool;
 	int			max;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1234,12 +1234,12 @@ xfs_ioc_write_stream_alloc(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	max = xfs_inode_max_write_streams(ip);
-	target = xfs_inode_buftarg(ip);
+	pool = xfs_inode_write_stream_pool(ip);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (!max)
 		return -EOPNOTSUPP;
-	return write_stream_alloc_fd(&target->bt_stream_pool, filp);
+	return write_stream_alloc_fd(pool, filp);
 }
 
 static int
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2801880a1c31..4dd0014c5bc8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -144,8 +144,12 @@ xfs_bmbt_to_iomap(
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
-	/* software stream ids must not reach a device without streams */
-	if (bdev_max_write_streams(target->bt_bdev))
+	/*
+	 * Only hardware stream ids may reach the device; zoned stream ids
+	 * name open zone slots.
+	 */
+	if (bdev_max_write_streams(target->bt_bdev) &&
+	    !(XFS_IS_REALTIME_INODE(ip) && xfs_has_zoned(mp)))
 		iomap->write_stream = READ_ONCE(VFS_I(ip)->i_write_stream);
 	else
 		iomap->write_stream = WRITE_STREAM_NOT_SET;
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 5ba1628e787f..887f7f6d3307 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1308,6 +1308,7 @@ xfs_free_zone_info(
 	int			i;
 
 	xfs_free_open_zones(zi);
+	write_stream_pool_destroy(&zi->zi_write_streams);
 	for (i = 0; i < XFS_ZONE_USED_BUCKETS; i++)
 		kvfree(zi->zi_used_bucket_bitmap[i]);
 	kfree(zi);
@@ -1444,6 +1445,11 @@ xfs_mount_zones(
 	if (!mp->m_zone_info)
 		return -ENOMEM;
 
+	error = write_stream_pool_init(&mp->m_zone_info->zi_write_streams,
+			min(mp->m_max_open_zones - XFS_OPEN_GC_ZONES, U16_MAX));
+	if (error)
+		goto out_free_zone_info;
+
 	error = xfs_report_zones(mp, &iz);
 	if (error)
 		goto out_free_zone_info;
@@ -1507,6 +1513,13 @@ xfs_mount_zones(
 	return error;
 }
 
+struct write_stream_pool *
+xfs_zoned_write_stream_pool(
+	struct xfs_mount	*mp)
+{
+	return &mp->m_zone_info->zi_write_streams;
+}
+
 void
 xfs_unmount_zones(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
index abf8358bb266..8de578cd040a 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -4,6 +4,7 @@
 
 struct iomap_ioend;
 struct xfs_open_zone;
+struct write_stream_pool;
 
 struct xfs_zone_alloc_ctx {
 	struct xfs_open_zone	*open_zone;
@@ -53,11 +54,17 @@ void xfs_unmount_zones(struct xfs_mount *mp);
 void xfs_zone_gc_start(struct xfs_mount *mp);
 void xfs_zone_gc_stop(struct xfs_mount *mp);
 void xfs_zone_gc_wakeup(struct xfs_mount *mp);
+struct write_stream_pool *xfs_zoned_write_stream_pool(struct xfs_mount *mp);
 #else
 static inline int xfs_mount_zones(struct xfs_mount *mp)
 {
 	return -EIO;
 }
+static inline struct write_stream_pool *
+xfs_zoned_write_stream_pool(struct xfs_mount *mp)
+{
+	return NULL;
+}
 static inline void xfs_unmount_zones(struct xfs_mount *mp)
 {
 }
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index fcb57506d8e6..75518eaca05f 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -2,6 +2,8 @@
 #ifndef _XFS_ZONE_PRIV_H
 #define _XFS_ZONE_PRIV_H
 
+#include <linux/write_streams.h>
+
 struct xfs_open_zone {
 	/*
 	 * Entry in the open zone list and refcount.  Protected by
@@ -52,6 +54,11 @@ struct xfs_open_zone {
 #define XFS_ZONE_USED_BUCKETS		10u
 
 struct xfs_zone_info {
+	/*
+	 * Write stream slots, one per user-open zone:
+	 */
+	struct write_stream_pool	zi_write_streams;
+
 	/*
 	 * List of pending space reservations:
 	 */
-- 
2.43.0

