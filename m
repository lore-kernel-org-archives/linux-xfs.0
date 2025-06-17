Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8037B2192EA
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 10:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157577; cv=none; b=SBkvjLznqHmipjrnIiBDs642/QXVbhULQHVrqMciKdN0Xqau8CZ02iNSQgAc67EketrC8z8jjmMx//nmE+aT8AD66SlZEsjl7NgT1aj6Zda+CW8e86jOgfDl8gYAp3UxE//BjN5u/kmK4cJcOMRNcgXirzhf082Hhl/sGnbx0AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157577; c=relaxed/simple;
	bh=YPOGL19LvYrTXv+Y5kiY6V8W6KdRLVBcWxczGYdvc8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0s0hCvjJUqo/vo5Ky6M4Ems8PLfjX62ZZB/wdks677sDQIHtfXAq5ogBDcrT04/N0/Q0vpM6ZtkOaJ65vYEYdublMsxMUTE9yv98n0PdM3VmaDgAg563GGyD1+Rl0BxM7R6V2Hn7wdkC9vxbW0LgjiC2WEhihLkVfvFOSSCi/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zG6999/R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zG6999/R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JYFRxUBZ/96WTiU9vaJ+oLGGUrx0O2DeBMtchAkWrWQ=; b=zG6999/Ry95HTW28X4ButCQWo2
	njfb3IMbQ9DgIHYfjFOOy/mMHLYU+C/iOiU2ZD/8Ip9x+dYLrv/lm41OLckpc4VzpLrMT/e1vuw/j
	ILr7kweLjv3ZZXZ6IeoHZespQscU3Oqjfd1iPKP1L2UtHsAu3PuXI4kk94n0DfUhqmSAcwWPzuPI4
	/Roc8qSuE8Nc1ysc93hDxzLOi4rZrVyFO2f8UNQXnVh+j7pS+DL/3Nh39V1dE3/6USU9Dw2c/IacL
	We8ngd27pz0NLr+XmHdNLbVcLMstIVkKyFIjHHkNL+DXP952R4Bz4ErPhz+geBKMGJUW1YQFUhGuS
	zVI/qmOA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRTvz-00000006yRL-2ZC0;
	Tue, 17 Jun 2025 10:52:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: rename the bt_bdev_* buftarg fields
Date: Tue, 17 Jun 2025 12:52:03 +0200
Message-ID: <20250617105238.3393499-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617105238.3393499-1-hch@lst.de>
References: <20250617105238.3393499-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The extra bdev_ is weird, so drop it.  The maximum size is based on the
bdev hardware limits, so add a hw_ component instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c   | 4 ++--
 fs/xfs/xfs_buf.h   | 4 ++--
 fs/xfs/xfs_file.c  | 2 +-
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iomap.c | 2 +-
 fs/xfs/xfs_iops.c  | 2 +-
 fs/xfs/xfs_mount.c | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0f15837724e7..abd66665fb8c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1712,8 +1712,8 @@ xfs_configure_buftarg_atomic_writes(
 		max_bytes = 0;
 	}
 
-	btp->bt_bdev_awu_min = min_bytes;
-	btp->bt_bdev_awu_max = max_bytes;
+	btp->bt_awu_min = min_bytes;
+	btp->bt_awu_max_hw = max_bytes;
 }
 
 /* Configure a buffer target that abstracts a block device. */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 294dd9d61dbb..6a96780d841b 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -113,8 +113,8 @@ struct xfs_buftarg {
 	struct ratelimit_state	bt_ioerror_rl;
 
 	/* Atomic write unit values, bytes */
-	unsigned int		bt_bdev_awu_min;
-	unsigned int		bt_bdev_awu_max;
+	unsigned int		bt_awu_min;
+	unsigned int		bt_awu_max_hw;
 
 	/* built-in cache, if we're not using the perag one */
 	struct xfs_buf_cache	bt_cache[];
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 48254a72071b..6c1ccb5a2c82 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -752,7 +752,7 @@ xfs_file_dio_write_atomic(
 	 * HW offload should be faster, so try that first if it is already
 	 * known that the write length is not too large.
 	 */
-	if (ocount > xfs_inode_buftarg(ip)->bt_bdev_awu_max)
+	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max_hw)
 		dops = &xfs_atomic_write_cow_iomap_ops;
 	else
 		dops = &xfs_direct_write_iomap_ops;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index d7e2b902ef5c..39660d7aa3bb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -358,7 +358,7 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 
 static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
 {
-	return xfs_inode_buftarg(ip)->bt_bdev_awu_max > 0;
+	return xfs_inode_buftarg(ip)->bt_awu_max_hw > 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ff05e6b1b0bb..a2387d5918a9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -827,7 +827,7 @@ xfs_bmap_hw_atomic_write_possible(
 	/*
 	 * The ->iomap_begin caller should ensure this, but check anyway.
 	 */
-	return len <= xfs_inode_buftarg(ip)->bt_bdev_awu_max;
+	return len <= xfs_inode_buftarg(ip)->bt_awu_max_hw;
 }
 
 static int
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8cddbb7c149b..dc14c853475e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -665,7 +665,7 @@ xfs_get_atomic_write_max_opt(
 	 * less than our out of place write limit, but we don't want to exceed
 	 * the awu_max.
 	 */
-	return min(awu_max, xfs_inode_buftarg(ip)->bt_bdev_awu_max);
+	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max_hw);
 }
 
 static void
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 929b1f3349dc..70554f90c210 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -700,7 +700,7 @@ xfs_calc_group_awu_max(
 
 	if (g->blocks == 0)
 		return 0;
-	if (btp && btp->bt_bdev_awu_min > 0)
+	if (btp && btp->bt_awu_min > 0)
 		return max_pow_of_two_factor(g->blocks);
 	return rounddown_pow_of_two(g->blocks);
 }
-- 
2.47.2

