Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8203BE652
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376283; cv=none; b=R6ARJlXc087fpEdHdiBCdEEr6qTCe9x3n7dtcc8SEQHd0jIn1X0BCKyKXHEPS7G8IbP+0pS+f0yl/lxYY9KyV7H4cL5LV4YDzTJqIXWOh/i3USoC2uGeYcEO503Flk9FOO1DHQw21bcNK9sbktfuwteGslDPX2R1hVCrJ50Xhu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376283; c=relaxed/simple;
	bh=wMaQrjMi37gkelXCn471CysAcu0fVpFtkhku/fNkOvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhyykKNPp+o/phlwaRia24Rz37zy863n+fECdDC66JaYDmKceVm2HjSXFWaWkNgJJuX761+Hry70bRVLh1Z/mN5pIDtHbaskKXH/5aVw6775jmLus4XxF6n1ap9Wj5I5Xoy4f87CKjiRFk4sS558umEr6Ki1t5xDgjxmF+sKKGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qtdZZ7LD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qtdZZ7LD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AJg7Un5duu6d9a48kdbRL0LCi/sDWpyMvg9ZEfnQjvA=; b=qtdZZ7LDiV5wbYCkzMlK+tioQa
	fR91N4XvJOd/tzM9JzQd6PO/yYdC9DXOg13FMa/b5rHpNMWh8Zi7mzhdmeVr8L37dOPCuD/ZK2IWn
	+g+q3ZinUdn0ZDO1zc8tR8+4h21B8M1hjuhNTJjyEfoctk/v6p9RSJom/8Mmj+wzw/WcrewINx0ZW
	BE9uSn0GwsWvKmSnFR+uzezdzVl0h8vBarMzMXWAHSmfj1c44oQbHSmMTkBunYRZuFhmJEIqQxDgo
	1XvV4ndBm71fERSUpwj/MoxanYRrbNvt1BwaClckxGUKmyrEHk7F2M3W6FRncp+sO6D+YcHCCJNTL
	7FwxtwHw==;
Received: from [12.156.71.108] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtS4e-0000000CHoh-3OuF;
	Mon, 10 Aug 2026 15:38:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: fix racy open zone caching
Date: Mon, 10 Aug 2026 08:37:43 -0700
Message-ID: <20260810153759.466417-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260810153759.466417-1-hch@lst.de>
References: <20260810153759.466417-1-hch@lst.de>
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
 fs/xfs/xfs_zone_alloc.c | 56 +++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7d13fa7ab30a..dee21f65f7b7 100644
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
 
+	if (oz && !atomic_inc_not_zero(&oz->oz_ref))
+		oz = NULL;
+out_unlock:
+	rcu_read_unlock();
 	return oz;
 }
 
@@ -819,17 +837,30 @@ xfs_get_cached_zone(
  * lookup.  Because the open_zone is clearly marked as full when all data
  * in the underlying RTG was written, the caching is always safe.
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
+	 * instead of the inode we just selected.  This can happen when multiple
+	 * threads race to perform zone selection for an inode.  io_uring worker
+	 * threads seem to be good at triggering this.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	old_oz = VFS_I(ip)->i_private;
+	if (old_oz && old_oz->oz_allocated < rtg_blocks(old_oz->oz_rtg))
+		swap(oz, old_oz);
 	atomic_inc(&oz->oz_ref);
-	old_oz = xchg(&VFS_I(ip)->i_private, oz);
+	VFS_I(ip)->i_private = oz;
+	spin_unlock(&ip->i_flags_lock);
+
 	if (old_oz)
 		xfs_open_zone_put(old_oz);
+	return oz;
 }
 
 static void
@@ -873,14 +904,13 @@ xfs_zone_alloc_and_submit(
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

