Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595747;
	b=A0KT4UU7W9JKF0Dswy/vVW9sYZTm4uzxRopgzdrBa0LDawyEPDGmjGx9r4cIWdrEy4LL
	 /7VCHpT8ceCocdy8qxX0pnlX26VrF6bc3FV+j8Y6jRWVjV7aR1BucmpnBJbco0W8k4RAW
	 qci+saToVvE8lXfZNgtIG6XjD+o9QkeFZH7bRkk3T6+bfr8ESuQgDr92odX3gTWAk0zkZ
	 C8fEQIg7zKMQk869VckYTn9n0ShSnvhWWpjWz8WyW93hC20Dfho7g15Lv3bHqk3i9pUS6
	 XrXv4+SPnLVTGk72TphpmGARkUqabBvEKc2AdBxpvnkzLRgIRGkn8id0BcellaxbE5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595747;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=xcDiayKRHKESNARX3RRPptcZ/Wa9tLa+lViMHuVGf5M=;
	b=KNI2xN7cubGVBY0W0VBLPgBgJR0/HApNdBOgfJ+Egl0Kg1PGofOQL4j0UuKfddqAS62R
	 74iIjhEeIjeCYYqJzXhtntcUCe7bvSjug1gEqVJHPsEs7mXi7JFrXWTLdX7DUcqPZEgNb
	 k9KoK92KxRu0Qym7z9fG+yelsd2BWQu5WlRBCDM0K9oOkEsXNkOOWqHrcVTzoHzhTAw/+
	 BKW6zfuweM9t5yY/tpHYt0iKJ7Yzd7vLOEP8Vew41CpeajE3L2vrgsCWluuFuXbfoLkLi
	 Yz7nowUzRmNLaHiMMCRsYTf0xE2qCDURRHjrcOFBt2EQE7e/LzwtoCNwVlaq4JxpZYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=gdO79bJx;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596DC606A336
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 596DC606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=gdO79bJx
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261125083544epoutp043b9c1b31b0aff3ee6e537758e96a86e6~rPND6mXkO1038010380epoutp04b
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261125083544epoutp043b9c1b31b0aff3ee6e537758e96a86e6~rPND6mXkO1038010380epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595744;
	bh=xcDiayKRHKESNARX3RRPptcZ/Wa9tLa+lViMHuVGf5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdO79bJxAOxR5w65ZEMfXEfpDQV0YZrSKL03jUxVdvH+N1Zxf//EdSb5/UA4AkfgH
	 dx36m9eymyxmSUKei5lyX0rgVoKDbFYfVXwISVkQxV/9xPncpdPeZ7Mzhl2djHbffr
	 V/lHfaNPfr4pl5c952kmGclJYz1YAUHkM6AD8uZQ=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261125083543epcas5p30974022e3f57c48764daf3a03f9eaafd~rPNCpDbI31311813118epcas5p3x;
	Wed, 25 Nov 2026 08:35:43 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jZCgL4LWmz3hhT3; Wed, 25 Nov
	2026 08:35:42 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261125083541epcas5p36a4382ecbdb376bd2bc505967de8bf0c~rPNBQ1OmW1756117561epcas5p3c;
	Wed, 25 Nov 2026 08:35:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083540epsmtip1a30b6aead7b4f8201dea121813ee2f24~rPM-vPog30496704967epsmtip1I;
	Wed, 25 Nov 2026 08:35:40 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 5/9] xfs: implement software write-stream management
Date: Wed, 25 Nov 2026 14:03:09 +0530
Message-Id: <20261125083313.106334-6-joshi.k@samsung.com>
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
X-CMS-MailID: 20261125083541epcas5p36a4382ecbdb376bd2bc505967de8bf0c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083541epcas5p36a4382ecbdb376bd2bc505967de8bf0c
References: <20261125083313.106334-1-joshi.k@samsung.com>
	<CGME20261125083541epcas5p36a4382ecbdb376bd2bc505967de8bf0c@epcas5p3.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Give xfs write streams on any block device: keep a stream pool in the
data device buftarg, sized from the AG count, and pass the
FS_IOC_WRITE_STREAM_* ioctls to write_stream_ioctl() with a callback
that returns this pool.

Write streams and filestreams are mutually exclusive: filestream inodes
get no pool, and setattr refuses to turn on filestream placement, or to
change the realtime flag, while a stream is attached. Realtime inodes
get no pool for now.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_buf.c   | 31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h   |  6 ++++++
 fs/xfs/xfs_ioctl.c | 26 ++++++++++++++++++++++++++
 fs/xfs/xfs_super.c |  5 +++++
 4 files changed, 68 insertions(+)

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
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f81b6e52ac40..48195143b812 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -46,6 +46,7 @@
 #include "xfs_verify_media.h"
 #include "xfs_zone_priv.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_filestream.h"
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
@@ -557,6 +558,11 @@ xfs_ioctl_setattr_xflags(
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
@@ -1436,6 +1442,21 @@ xfs_ioc_free_eofblocks(
 	return xfs_blockgc_free_space(mp, &icw);
 }
 
+/* Pool for the data of @inode, or NULL if it cannot use write streams. */
+static struct write_stream_pool *
+xfs_write_stream_pool(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct write_stream_pool *pool = NULL;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (!xfs_inode_is_filestream(ip) && !XFS_IS_REALTIME_INODE(ip))
+		pool = &ip->i_mount->m_ddev_targp->bt_stream_pool;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return pool;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1575,6 +1596,11 @@ xfs_file_ioctl(
 	case XFS_IOC_VERIFY_MEDIA:
 		return xfs_ioc_verify_media(filp, arg);
 
+	case FS_IOC_WRITE_STREAM_GET_MAX:
+	case FS_IOC_WRITE_STREAM_ALLOC:
+	case FS_IOC_WRITE_STREAM_SET:
+		return write_stream_ioctl(filp, cmd, arg, xfs_write_stream_pool);
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

