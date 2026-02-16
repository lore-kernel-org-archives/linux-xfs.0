Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBA0221FBD
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 05:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771219843; cv=none; b=fmxcc4cevRPoaCzHtYJ5vYNKgw/llN2wiEdw0gwDXrzpgCZLpP3crE+ej37L6t2MVrl8DVXpYS3Vhgip3ILyDqOhwFoirYnIXO9k+oEqGFYuEKpw4BGLHVAHdkhMoRUvj3TrGHRPsLAQYLTY3i7G5yueo/T1DR1eDUnOSTcr2zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771219843; c=relaxed/simple;
	bh=SJiKwxymJGjCI9qDNvCQ4ZR3L5NeVvhadFp/18rjHIs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=obC9BJ+DtmIh1No5w2e3wyN8bVas7kyHHkXaubQHNmeh9Z9mjHYdT1++Dm2a4uxHsg9iUPOeD0U4ypURXpKrzAi1EJpxQXRzaW367d3mu9900F3+cHz2vy0pVHTGMK3G8fvTzzXaUFzBgJ9piEmB08m9kETPw0TSs+hMTxS7eYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=amlL+Rlj; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="amlL+Rlj"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260216053039epoutp0191aa343170a00cd1ac7d39df96f2a3e2~Uow9AVXAe2499824998epoutp01w
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 05:30:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260216053039epoutp0191aa343170a00cd1ac7d39df96f2a3e2~Uow9AVXAe2499824998epoutp01w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771219839;
	bh=Pb+P0rLgEdovCO13BIPXUJybqmHX3PaFxXKcvG+y1qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amlL+RljZAs6yrHVXKl3AO7tce2WSIzckubi8ABEDEt1d+KpxEhoPNF0H+OE/8JF8
	 wWh3Wanls6zGTpMLOEw6AkDP3o4Wn0mqcBre8LxFNHeq+E/IAd1Uyfo+iaNwNmcqJx
	 I5c5yoaCOlmoM89t6bNLeCwbm3e+gVV0C/tvCMNo=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260216053038epcas5p34fca45a91ff20e0ecb6d0b403d2b42a6~Uow8i1w0n1545915459epcas5p3J;
	Mon, 16 Feb 2026 05:30:38 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4fDrvy1KCWz2SSKX; Mon, 16 Feb
	2026 05:30:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260216053037epcas5p4db5c80cedd64a70a275c3371e4084122~Uow7iSDtq2439324393epcas5p4s;
	Mon, 16 Feb 2026 05:30:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260216053036epsmtip18aedcc0c50ab49207aad44b39d755f5b~Uow6Fc6iA1594915949epsmtip1T;
	Mon, 16 Feb 2026 05:30:36 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: hch@lst.de, brauner@kernel.org, jack@suse.cz, djwong@kernel.org,
	axboe@kernel.dk, kbusch@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH 4/4] xfs: enable userspace write stream support
Date: Mon, 16 Feb 2026 10:55:40 +0530
Message-Id: <20260216052540.217920-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260216052540.217920-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260216053037epcas5p4db5c80cedd64a70a275c3371e4084122
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260216053037epcas5p4db5c80cedd64a70a275c3371e4084122
References: <20260216052540.217920-1-joshi.k@samsung.com>
	<CGME20260216053037epcas5p4db5c80cedd64a70a275c3371e4084122@epcas5p4.samsung.com>

Implement support for userspace controlled write-streams.

Add a new i_write_stream field in xfs inode (note: existing hole is
used), and use that to implement write stream management file operations.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_file.c   | 54 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c |  1 +
 fs/xfs/xfs_inode.h  |  3 +++
 fs/xfs/xfs_iomap.c  |  1 +
 4 files changed, 59 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 43d088a3bceb..f3b137407a60 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -2021,6 +2021,57 @@ xfs_file_mmap_prepare(
 	return 0;
 }
 
+static struct block_device *
+xfs_file_get_bdev(
+	struct inode		*inode)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct xfs_mount *mp = ip->i_mount;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		return mp->m_rtdev_targp->bt_bdev;
+
+	return mp->m_ddev_targp->bt_bdev;
+}
+
+static int
+xfs_file_get_max_write_streams(
+	struct file		*file)
+{
+	struct block_device *bdev = xfs_file_get_bdev(file_inode(file));
+
+	if (bdev)
+		return bdev_max_write_streams(bdev);
+
+	return 0;
+}
+
+static int
+xfs_file_get_write_stream(
+	struct file		*file)
+{
+	struct xfs_inode *ip = XFS_I(file_inode(file));
+
+	return READ_ONCE(ip->i_write_stream);
+}
+
+static int
+xfs_file_set_write_stream(
+	struct file		*file,
+	unsigned long		stream)
+{
+	struct xfs_inode *ip = XFS_I(file_inode(file));
+	int max_streams = xfs_file_get_max_write_streams(file);
+
+	if (stream > max_streams)
+		return -EINVAL;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	WRITE_ONCE(ip->i_write_stream, stream);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return 0;
+}
+
 const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read_iter	= xfs_file_read_iter,
@@ -2040,6 +2091,9 @@ const struct file_operations xfs_file_operations = {
 	.fallocate	= xfs_file_fallocate,
 	.fadvise	= xfs_file_fadvise,
 	.remap_file_range = xfs_file_remap_range,
+	.get_max_write_streams	= xfs_file_get_max_write_streams,
+	.get_write_stream = xfs_file_get_write_stream,
+	.set_write_stream = xfs_file_set_write_stream,
 	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
 			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
 			  FOP_DONTCACHE,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dbaab4ae709f..fc9c6794b7db 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -130,6 +130,7 @@ xfs_inode_alloc(
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
+	ip->i_write_stream = 0;
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d33557194..be3580fec318 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -38,6 +38,9 @@ typedef struct xfs_inode {
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_ifork	i_af;		/* attribute fork */
 
+	/* Write stream information */
+	uint8_t			i_write_stream;	/* for placement, 0 = none */
+
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	struct rw_semaphore	i_lock;		/* inode lock */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index be86d43044df..7988c9e16635 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -148,6 +148,7 @@ xfs_bmbt_to_iomap(
 	else
 		iomap->bdev = target->bt_bdev;
 	iomap->flags = iomap_flags;
+	iomap->write_stream = ip->i_write_stream;
 
 	/*
 	 * If the inode is dirty for datasync purposes, let iomap know so it
-- 
2.25.1

