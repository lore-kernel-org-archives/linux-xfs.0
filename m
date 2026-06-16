Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523AA47A0DE
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633578; cv=none; b=sDspzplwNPKO0sx+x1239uxo36bbwIwHLk6ApqUOnxMqQYWKN0rD/JmvWjAGGzhnt9jR5JBNgzSNmmjGuRULYwLSLuQsNfJRO/besbLfR6HfWf40eg73KDdc4e9zaYdqUj4C6Aq0MnNKzmNSvhbKw7BKOqwZPm6Vqb0JgNKo/PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633578; c=relaxed/simple;
	bh=VV4l/CbJgQioq/C7LDOzOKd46L3M58em1zGzlHHw3Tk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=AUMPZMfaeYgNqYlRn4VuRsAdMKVaKePRE6g3g+KdLvncQXL/WnZ5jHiqBwzmA6ztkkcVLKqP9IArlLTzq51D/sq+e6sKKXkPsvf+JkkpiFdSSB3NobecD84phmmU9nBUf0WxKJM6A8N7tkHtfpkoPuGgzzSQ+INF5sZ0pK+9A5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dFQWksTo; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dFQWksTo"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260616181248epoutp0418c9cbd46ea088df27ec61429aac6544~5okqEu2Wc0134801348epoutp04p
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260616181248epoutp0418c9cbd46ea088df27ec61429aac6544~5okqEu2Wc0134801348epoutp04p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781633568;
	bh=F5uqpFzgn7LzWqo2LfNtYU9Z1Rqfg7mMlr/Q24rdpHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFQWksToSZNh1hxmH9O/+FEo3kw6NraKHRRXoDvpiv/kdiMmhl2DSnLSZjapz2keo
	 og/TJlP0thIhfjNWvJr3rYzAlaNkR+ktpZv/dQI0GF3H92pW9xT+h7ovwrb61DHwRH
	 rHV7fd6qYXzMChcyHzA1RyTFErempu3n8clnh1gs=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260616181247epcas5p44e695a5b44fe0d5a0f7b78b2c94642a2~5okphDxmN0964009640epcas5p4a;
	Tue, 16 Jun 2026 18:12:47 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gfw7z07vyz6B9m5; Tue, 16 Jun
	2026 18:12:47 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260616181246epcas5p30fc85b12b67452b5af39525e4ea966a9~5okoSN0dL1246912469epcas5p3H;
	Tue, 16 Jun 2026 18:12:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260616181244epsmtip1aa94fa64239ad96a8723ea5f21492732~5okmdy02N1049410494epsmtip1T;
	Tue, 16 Jun 2026 18:12:44 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 3/6] xfs: implement write-stream management support
Date: Tue, 16 Jun 2026 23:35:52 +0530
Message-Id: <20260616180555.33338-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260616180555.33338-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260616181246epcas5p30fc85b12b67452b5af39525e4ea966a9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260616181246epcas5p30fc85b12b67452b5af39525e4ea966a9
References: <20260616180555.33338-1-joshi.k@samsung.com>
	<CGME20260616181246epcas5p30fc85b12b67452b5af39525e4ea966a9@epcas5p3.samsung.com>

Implement support for FS_IOC_WRITE_STREAM ioctl.

For FS_WRITE_STREAM_OP_GET_MAX, available write streams are reported
based on the capability of the underlying block device.
For FS_WRITE_STREAM_OP_{SET/GET}, add a new i_write_stream field in xfs
inode. This value is propagated to the iomap during block mapping.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_icache.c |  1 +
 fs/xfs/xfs_inode.c  | 46 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |  6 ++++++
 fs/xfs/xfs_ioctl.c  | 38 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c  |  1 +
 5 files changed, 92 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2040a9292ee6..d5f880f5b810 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -130,6 +130,7 @@ xfs_inode_alloc(
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
+	ip->i_write_stream = 0;
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index beaa26ec62da..2e7c61d71b48 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -47,6 +47,52 @@
 
 struct kmem_cache *xfs_inode_cache;
 
+int
+xfs_inode_max_write_streams(
+	struct xfs_inode	*ip)
+{
+	struct block_device	*bdev;
+
+	bdev = xfs_inode_buftarg(ip)->bt_bdev;
+	if (!bdev)
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
+int
+xfs_inode_set_write_stream(
+	struct xfs_inode	*ip,
+	uint16_t		stream_id)
+{
+	int ret = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	if (stream_id > xfs_inode_max_write_streams(ip)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	ip->i_write_stream =  stream_id;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return ret;
+}
+
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d33557194..768c4195306c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -38,6 +38,9 @@ typedef struct xfs_inode {
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_ifork	i_af;		/* attribute fork */
 
+	/* Write stream information */
+	uint16_t		i_write_stream;
+
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	struct rw_semaphore	i_lock;		/* inode lock */
@@ -676,4 +679,7 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
 		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
 		struct xfs_dquot **pdqpp);
 
+int xfs_inode_max_write_streams(struct xfs_inode *ip);
+uint16_t xfs_inode_get_write_stream(struct xfs_inode *ip);
+int xfs_inode_set_write_stream(struct xfs_inode *ip, uint16_t stream_id);
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 46e234863644..3f82a4884b81 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1179,6 +1179,42 @@ xfs_ioctl_fs_counts(
 	return 0;
 }
 
+static int
+xfs_ioc_write_stream(
+	struct file		*filp,
+	void __user		*arg)
+{
+	struct inode		*inode = file_inode(filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct fs_write_stream	ws = { };
+
+	if (copy_from_user(&ws, arg, sizeof(ws)))
+		return -EFAULT;
+	if (ws.rsvd != 0)
+		return -EINVAL;
+
+	switch (ws.op_flags) {
+	case FS_WRITE_STREAM_OP_GET_MAX:
+		ws.max_streams = xfs_inode_max_write_streams(ip);
+		goto copy_out;
+	case FS_WRITE_STREAM_OP_GET:
+		ws.stream_id = xfs_inode_get_write_stream(ip);
+		goto copy_out;
+	case FS_WRITE_STREAM_OP_SET:
+		if (!(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+		return xfs_inode_set_write_stream(ip, ws.stream_id);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+
+copy_out:
+	if (copy_to_user(arg, &ws, sizeof(ws)))
+		return -EFAULT;
+	return 0;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1444,6 +1480,8 @@ xfs_file_ioctl(
 		return xfs_ioc_health_monitor(filp, arg);
 	case XFS_IOC_VERIFY_MEDIA:
 		return xfs_ioc_verify_media(filp, arg);
+	case FS_IOC_WRITE_STREAM:
+		return xfs_ioc_write_stream(filp, arg);
 
 	default:
 		return -ENOTTY;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f20a02f49ed9..ccbf7dcf1ad5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -144,6 +144,7 @@ xfs_bmbt_to_iomap(
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomap->flags = iomap_flags;
+	iomap->write_stream = ip->i_write_stream;
 	if (mapping_flags & IOMAP_DAX) {
 		iomap->dax_dev = target->bt_daxdev;
 	} else {
-- 
2.25.1

