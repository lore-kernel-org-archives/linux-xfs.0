Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C042D738F
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786466993; cv=none; b=pnVhSXW4lAixD4BnuwZoEi/GMNcT73UsGbyY4BTA6wYgqcbTOr0gKSurxip+pMBGhoL8zS8b4e5o4DSkxHzVLnlCASJ2T/il2S5AURFkHkvcEZvpFdwpK8AY0bPPj5yOofDf3O4WYDgKkj2wvDNxux7bUNtFwnH1G9p6rv6QGm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786466993; c=relaxed/simple;
	bh=RFT3XBm17CM//NdSb1eFpULoFzPkzXMkC9ChSN5skdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaZECwi3aqXYimLe/+dRVenC7m3CkAjAHJtCkRDrNBe313801FxmHZdvHOAXpdrJXpd8wZeLw7rJZkHpZb4mgawueah6IIDItcp4z5wXEEJeWCKVMCm+QsIUosTGrtJRGS8hrZ3HBJ1R05xFtW1h3iRyWGhMJcNxYPSXLBZYKhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l3t7ncbp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l3t7ncbp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=G6jf8qwG6cHzXZRYtD146PslaahNnATRMNMhxDJ6S8w=; b=l3t7ncbpJSW7Zt8D2kdApvoTGT
	EcDqlfiLLThDmJDg2q1Uipks4cL1KNnZ2ujtPykbezcYuWDtWi19Gm7woMDVgEwUHDS2DUFxZcvOW
	4oUEiwZe2Db3eBfR4QSkBDk75/6/uHLeFuMdUbWDygLfG8BGRIJ8xGf1f9FlNMPmkeLxSEFsPmh4j
	VIL+3eKaEc06nqyoHU8msGLD6br5+00M+R5465mQkqBNv19DpJv4iRAgCqxKyvn0cawVbMZ8G3tmW
	VgOfogX1N8gqYmVrReEWeWXFAoXbUQUVKDfxAHRcYg0rmJbmP0tFiN6pDF80ALmKgJQz92vU6Tdaz
	HIN6d7JA==;
Received: from [129.253.192.68] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtpfi-0000000EYM1-16Bd;
	Tue, 11 Aug 2026 16:49:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: fix racy open zone caching
Date: Tue, 11 Aug 2026 10:48:38 -0600
Message-ID: <20260811164912.124416-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260811164912.124416-1-hch@lst.de>
References: <20260811164912.124416-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When testing on very fast storage devices, I've observed writers using
io_uring creating many open zones with just a few kiB written to it,
which then don't get used.  I tracked this down to multiple io_uring
helper threads finding a full zone in i_private, and then going on to
select a one, with the final one winning the race and leaving it in
i_private.

Fix this by dropping full zones from i_private as soon we find them,
checking cached for a cached zoned when a single writes needs a new zone,
and by keeping an existing cached zone in xfs_set_cached_zone when it
still has space available, dropping the newly found/allocated one
instead.  This uses i_flags_lock as a low-level spinlock for short
hold times to avoid interactions with the ilock, which is used for
completions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7d13fa7ab30a..bdbb60cc5d5b 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -793,17 +793,35 @@ xfs_get_cached_zone(
 
 	rcu_read_lock();
 	oz = VFS_I(ip)->i_private;
-	if (oz) {
-		/*
-		 * GC only steals open zones at mount time, so no GC zones
-		 * should end up in the cache.
-		 */
-		ASSERT(!oz->oz_is_gc);
-		if (!atomic_inc_not_zero(&oz->oz_ref))
+	if (!oz)
+		goto out_unlock;
+
+	/*
+	 * GC only steals open zones at mount time, so no GC zones should end up
+	 * in the cache.
+	 */
+	ASSERT(!oz->oz_is_gc);
+
+	/*
+	 * Drop the old cached open zone if it is full.
+	 */
+	if (oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
+		spin_lock(&ip->i_flags_lock);
+		oz = VFS_I(ip)->i_private;
+		if (oz && oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
+			VFS_I(ip)->i_private = NULL;
+			spin_unlock(&ip->i_flags_lock);
+			xfs_open_zone_put(oz);
 			oz = NULL;
+			goto out_unlock;
+		}
+		spin_unlock(&ip->i_flags_lock);
 	}
-	rcu_read_unlock();
 
+	if (!atomic_inc_not_zero(&oz->oz_ref))
+		oz = NULL;
+out_unlock:
+	rcu_read_unlock();
 	return oz;
 }
 
@@ -818,18 +836,41 @@ xfs_get_cached_zone(
  * that were every written to, but significantly simplifies the cached zone
  * lookup.  Because the open_zone is clearly marked as full when all data
  * in the underlying RTG was written, the caching is always safe.
+ *
+ * Called with a reference on @oz held.  And returns two references on the
+ * returned zone: one for the caller and one for pinning the zone in
+ * inode->i_private.
  */
-static void
+static struct xfs_open_zone *
 xfs_set_cached_zone(
 	struct xfs_inode	*ip,
 	struct xfs_open_zone	*oz)
 {
 	struct xfs_open_zone	*old_oz;
 
+	/*
+	 * If the open zone cached in the inode still has free space, use that
+	 * instead of the new open zone just selected.  This can happen when
+	 * multiple threads race to perform zone selection for an inode.
+	 * io_uring worker threads seem to be good way to trigger this.
+	 *
+	 * We need to grab an extra reference to this open zone as the caller
+	 * owns a reference in addition to the i_private pointer.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	old_oz = VFS_I(ip)->i_private;
+	if (old_oz && old_oz->oz_allocated < rtg_blocks(old_oz->oz_rtg) &&
+	    atomic_inc_not_zero(&old_oz->oz_ref)) {
+		spin_unlock(&ip->i_flags_lock);
+		xfs_open_zone_put(oz);
+		return old_oz;
+	}
+	VFS_I(ip)->i_private = oz;
 	atomic_inc(&oz->oz_ref);
-	old_oz = xchg(&VFS_I(ip)->i_private, oz);
+	spin_unlock(&ip->i_flags_lock);
 	if (old_oz)
 		xfs_open_zone_put(old_oz);
+	return oz;
 }
 
 static void
@@ -873,14 +914,13 @@ xfs_zone_alloc_and_submit(
 	 * the inode is still associated with a zone and use that if so.
 	 */
 	if (!*oz)
+select_zone:
 		*oz = xfs_get_cached_zone(ip);
-
 	if (!*oz) {
-select_zone:
 		*oz = xfs_select_zone(mp, write_hint, pack_tight);
 		if (!*oz)
 			goto out_error;
-		xfs_set_cached_zone(ip, *oz);
+		*oz = xfs_set_cached_zone(ip, *oz);
 	}
 
 	alloc_len = xfs_zone_alloc_blocks(*oz, XFS_B_TO_FSB(mp, ioend->io_size),
-- 
2.53.0

