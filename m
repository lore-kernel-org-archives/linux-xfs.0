Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8E026F471
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 10:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366508; cv=none; b=jrb/WCIr9t8Y4EZ40jQxt+qHswbBBlom/Uuqkdxurq/GrsZ8S96koA+C8yyXWihvtfKVg1IVUg6NlA5jAg+7CQcUbv7QR6VsL+GOCbNdCGL17F9DCBBcP7A+der/q6M6cWxjIQDkXw3AC0elieyOx7GdPLbvFp7kd3VenyvZlyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366508; c=relaxed/simple;
	bh=fAPIj3bPo5O0gIuH24wj2TP17nLopSafNgSpdxAP6Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtsYVOmISt4QI/1hiAdXNaORg/dOkzdyX/kpEdEHFcXSstQfVxz2SuzOwsJC6p482ABQpP/NfIaKuh2dDf58t5/2pLoqmIYoEsWs5ro/jTS6l+ExMv/89vlCciXPMl0zoV6ODI/gekBvSNK/Yd8GeB9bseztNunLs27s6WrCpQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MIrxYueT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MIrxYueT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=a79aU6mfxdhFunvPSUEakEhpCJIraUjQVcp7BPyebjs=; b=MIrxYueTleFmVqDwVOtOiQ8kr7
	IrtYd9qjXgYn+c7L59zx6OgcCcKJyKATIo4lmv508AsnGqU2yRXwpA6srGNo1MSyBf6DEXBwRT2yH
	CeSHR0A5X+wrsfMk6ZAdITFTveCu6N+J8CdLxTnoDadlwlbzdgd3aXStqhn25iTrAqhqO/1EeGJpT
	ytGdRC1p/XgxYrPDKb4JeukGsA2JoCh0KeNy+n8pk4Ryj4NbKi6ux8GCiT4E8/q7P2Dla6MX59iGb
	cDal39x4fYimVgLHcw7+BJp3yrwrwoLOdFsrZP7g7oo/3+RPiX56W6csfALzuBmOC8exXnVeoXQ+r
	L8jVSRNQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uWYQr-00000004m1g-1Y0i;
	Tue, 01 Jul 2025 10:41:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: rename the bt_bdev_* buftarg fields
Date: Tue,  1 Jul 2025 12:40:39 +0200
Message-ID: <20250701104125.1681798-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250701104125.1681798-1-hch@lst.de>
References: <20250701104125.1681798-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The extra bdev_ is weird, so drop it.  Also improve the comment to make
it clear these are the hardware limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c   | 4 ++--
 fs/xfs/xfs_buf.h   | 6 +++---
 fs/xfs/xfs_file.c  | 2 +-
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iomap.c | 2 +-
 fs/xfs/xfs_iops.c  | 2 +-
 fs/xfs/xfs_mount.c | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7a05310da895..661f6c70e9d0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1712,8 +1712,8 @@ xfs_configure_buftarg_atomic_writes(
 		max_bytes = 0;
 	}
 
-	btp->bt_bdev_awu_min = min_bytes;
-	btp->bt_bdev_awu_max = max_bytes;
+	btp->bt_awu_min = min_bytes;
+	btp->bt_awu_max = max_bytes;
 }
 
 /* Configure a buffer target that abstracts a block device. */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 73a9686110e8..7987a6d64874 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -112,9 +112,9 @@ struct xfs_buftarg {
 	struct percpu_counter	bt_readahead_count;
 	struct ratelimit_state	bt_ioerror_rl;
 
-	/* Atomic write unit values, bytes */
-	unsigned int		bt_bdev_awu_min;
-	unsigned int		bt_bdev_awu_max;
+	/* Hardware atomic write unit values, bytes */
+	unsigned int		bt_awu_min;
+	unsigned int		bt_awu_max;
 
 	/* built-in cache, if we're not using the perag one */
 	struct xfs_buf_cache	bt_cache[];
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 48254a72071b..377fc9077781 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -752,7 +752,7 @@ xfs_file_dio_write_atomic(
 	 * HW offload should be faster, so try that first if it is already
 	 * known that the write length is not too large.
 	 */
-	if (ocount > xfs_inode_buftarg(ip)->bt_bdev_awu_max)
+	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
 		dops = &xfs_atomic_write_cow_iomap_ops;
 	else
 		dops = &xfs_direct_write_iomap_ops;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index d7e2b902ef5c..07fbdcc4cbf5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -358,7 +358,7 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 
 static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
 {
-	return xfs_inode_buftarg(ip)->bt_bdev_awu_max > 0;
+	return xfs_inode_buftarg(ip)->bt_awu_max > 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ff05e6b1b0bb..ec30b78bf5c4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -827,7 +827,7 @@ xfs_bmap_hw_atomic_write_possible(
 	/*
 	 * The ->iomap_begin caller should ensure this, but check anyway.
 	 */
-	return len <= xfs_inode_buftarg(ip)->bt_bdev_awu_max;
+	return len <= xfs_inode_buftarg(ip)->bt_awu_max;
 }
 
 static int
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8cddbb7c149b..01e597290eb5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -665,7 +665,7 @@ xfs_get_atomic_write_max_opt(
 	 * less than our out of place write limit, but we don't want to exceed
 	 * the awu_max.
 	 */
-	return min(awu_max, xfs_inode_buftarg(ip)->bt_bdev_awu_max);
+	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
 }
 
 static void
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 99fbb22bad4c..0b690bc119d7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -699,7 +699,7 @@ xfs_calc_group_awu_max(
 
 	if (g->blocks == 0)
 		return 0;
-	if (btp && btp->bt_bdev_awu_min > 0)
+	if (btp && btp->bt_awu_min > 0)
 		return max_pow_of_two_factor(g->blocks);
 	return rounddown_pow_of_two(g->blocks);
 }
-- 
2.47.2

