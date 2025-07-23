Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AA7523A
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 05:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753248950; cv=none; b=s4mHXRmgm8SxXYLkEtMTnM6nRLNhhjt+xZ+ICE+CVBwzE3h3+njnTDuBTmyiVPouv8CC+LS/c2HaJ5KXXO1ecf8PcyA/PVyTxRzuIYJdg1D7mXWYaUO/7rx21tAIpaLESSYQKWpi6M8HnTv1nU1JOh3bKdgmm4o5/om30lvD1sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753248950; c=relaxed/simple;
	bh=Cr9alx4INMDSKTP3WsR4coleXccQcaLmL3wooIOG8NM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iOi82xgGZJ/bNG62mgP4DfDj8A6Le99nUH/VAIvXDts/HlYqvwPYgHC9mw3P/H+rYBFeVYxs6xx02I02U4AXMYw/Q4aLGvKFO/UTvNM8JCuPZHfxoJ4MVIhBqx0xo7kXA1sZCwwgx2uZRy7aIzlbs4OOhkPzgNkp9yNRzWAZsfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hwtumVLB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hwtumVLB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1TM+/t8c1Kqz9+I3wMgiJ/B6zWyFmeh7AEVjdxTGwtw=; b=hwtumVLBRf6rmC0TQKaP/qZL75
	l1xAxJ5HSbeKE3UlaJwxrP3X23eZSrgBYcOyqakvclotulc2FD2BUvx62OqUmh9a3gfVXw6bZJZd5
	N+A5/IAWeaDfM1h2USiwk3Barp/NPIYPXxVyXOJ1mp2b0vBo+LiXEZpa5vyS0oszFqXy6jTo9HpQK
	kk+nhKMHO1TYmsgbgRzApbTyWl7AQsQM0zPefkVJVXhUnkwjeCx/zsmR9JPxnY1QHhAByT5158d4E
	furDCDNCdoUoNMizGeQVXk1smespvTF1bcX5ldwJVSxECWAwlx5ykATANujiC0THKE02tnqbS7C31
	gv4QgcYg==;
Received: from [2001:67c:1232:144:a1d2:d12d:cb2d:5181] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueS8o-000000044GG-2a1b;
	Wed, 23 Jul 2025 05:35:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: split xfs_zone_record_blocks
Date: Wed, 23 Jul 2025 07:35:44 +0200
Message-ID: <20250723053544.3069555-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_zone_record_blocks not only records successfully written blocks that
now back file data, but is also used for blocks speculatively written by
garbage collection that were never linked to an inode and instantly
become invalid.

Split the latter functionality out to be easier to understand.  This also
make it clear that we don't need to attach the rmap inode to a
transaction for the skipped blocks case as we never dirty any peristent
data structure.

Also make the argument order to xfs_zone_record_blocks a bit more
natural.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trace.h      |  1 +
 fs/xfs/xfs_zone_alloc.c | 42 ++++++++++++++++++++++++++++-------------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 10d4fd671dcf..178b204dee3b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -455,6 +455,7 @@ DEFINE_EVENT(xfs_zone_alloc_class, name,			\
 		 xfs_extlen_t len),				\
 	TP_ARGS(oz, rgbno, len))
 DEFINE_ZONE_ALLOC_EVENT(xfs_zone_record_blocks);
+DEFINE_ZONE_ALLOC_EVENT(xfs_zone_skip_blocks);
 DEFINE_ZONE_ALLOC_EVENT(xfs_zone_alloc_blocks);
 
 TRACE_EVENT(xfs_zone_gc_select_victim,
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 33f7eee521a8..f8bd6d741755 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -166,10 +166,9 @@ xfs_open_zone_mark_full(
 static void
 xfs_zone_record_blocks(
 	struct xfs_trans	*tp,
-	xfs_fsblock_t		fsbno,
-	xfs_filblks_t		len,
 	struct xfs_open_zone	*oz,
-	bool			used)
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		len)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_rtgroup	*rtg = oz->oz_rtg;
@@ -179,18 +178,37 @@ xfs_zone_record_blocks(
 
 	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
 	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
-	if (used) {
-		rmapip->i_used_blocks += len;
-		ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
-	} else {
-		xfs_add_frextents(mp, len);
-	}
+	rmapip->i_used_blocks += len;
+	ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
 	oz->oz_written += len;
 	if (oz->oz_written == rtg_blocks(rtg))
 		xfs_open_zone_mark_full(oz);
 	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
 }
 
+/*
+ * Called for blocks that have been written to disk, but not actually linked to
+ * an inode, which can happen when garbage collection races with user data
+ * writes to a file.
+ */
+static void
+xfs_zone_skip_blocks(
+	struct xfs_open_zone	*oz,
+	xfs_filblks_t		len)
+{
+	struct xfs_rtgroup	*rtg = oz->oz_rtg;
+
+	trace_xfs_zone_skip_blocks(oz, 0, len);
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	oz->oz_written += len;
+	if (oz->oz_written == rtg_blocks(rtg))
+		xfs_open_zone_mark_full(oz);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+
+	xfs_add_frextents(rtg_mount(rtg), len);
+}
+
 static int
 xfs_zoned_map_extent(
 	struct xfs_trans	*tp,
@@ -250,8 +268,7 @@ xfs_zoned_map_extent(
 		}
 	}
 
-	xfs_zone_record_blocks(tp, new->br_startblock, new->br_blockcount, oz,
-			true);
+	xfs_zone_record_blocks(tp, oz, new->br_startblock, new->br_blockcount);
 
 	/* Map the new blocks into the data fork. */
 	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, new);
@@ -259,8 +276,7 @@ xfs_zoned_map_extent(
 
 skip:
 	trace_xfs_reflink_cow_remap_skip(ip, new);
-	xfs_zone_record_blocks(tp, new->br_startblock, new->br_blockcount, oz,
-			false);
+	xfs_zone_skip_blocks(oz, new->br_blockcount);
 	return 0;
 }
 
-- 
2.47.2

