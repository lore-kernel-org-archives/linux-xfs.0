Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D9C4119E0
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243901; cv=none; b=rtcQXJcIakdljyratjjlA4Cy3iozW7TF3umPaWwqQG/myZCypaUXT0YS80S86gp1/WOcOTjaVSCgSqV7qbOvtrZU53QIJvwD/Qn6ViR3P6VbOu4YueG0AJ45SDAiFkaiR5J9O2mT7ww1Aw1ucPxGeM6cPpVI8yy0+Fm9P2LIRE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243901; c=relaxed/simple;
	bh=w/+4LTsPA7OLOSSCB5HxMhs7bSJNhnsylc3g2mrd8G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuyLxDMbqPPAB43rgtNJb+gsZkGwLYukMrjqXxHnDAseC36l1RPRvjwJzbbZlin0jlR0KqZbk/viFVk5HlopzTGKvGeZJpq9bXll5xqoHA2jDvvcW604SuH7EhrQUvvv4D8i/H7W6wxOeWgBltwncGQgLLzaRXCZJ8pstKdy7+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YJYU7u6/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YJYU7u6/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hhdkMrADLaQVQfW/4BnBExDSuL06N/IrJTJ61CSHwSs=; b=YJYU7u6/gXP9HlP+fAQH/FsJ6W
	stwtCxomORXf9QjzoTN7hbldsXqA2F1S0HcwGgevfYZyjRxuwHPPwzYXGolcXIILRqbytw/8Bzq3b
	+lG5deufdWIQ0BdaHSW9kKXu/f4iNiqcQo9jDmbNfKvmMhwL/9YEogB7jz5kF+a+/HafiajX8X0HV
	7oHe18/MsFA2bDfB4uxgzqPF+73Z1nTw+PX3g8OvnAKDpL9slMTY+8hBaKzWwY7eBwtwCGGQfzVa5
	6fBYcPVK/FVmbaVGUellCYsjuVMmtkLVwRKYz0MrROwP6ryFRRCX/3IvEelHTT/OCIIiIYp7WM/pf
	Z6H0zX7A==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gDO-0000000AeNR-1Bnn;
	Thu, 24 Sep 2026 09:58:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: split xfs_end_ioend_write
Date: Thu, 24 Sep 2026 11:57:08 +0200
Message-ID: <20260924095740.2732474-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924095740.2732474-1-hch@lst.de>
References: <20260924095740.2732474-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split out a separate helper for the zoned I/O completions as the code
flow is pretty different already and will become even more so soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioend.c | 63 ++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 258c6130bee8..f0e01ac34de8 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -147,11 +147,40 @@ xfs_ioend_submit_read(
 }
 
 static void
-xfs_ioend_put_open_zones(
+xfs_end_ioend_write_zoned(
 	struct iomap_ioend	*ioend)
 {
-	struct iomap_ioend *tmp;
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_open_zone	*oz = ioend->io_private;
+	struct iomap_ioend	*tmp;
+	int			error = -EIO;
+
+	ASSERT(!(ioend->io_flags & IOMAP_IOEND_SHARED));
+
+	if (xfs_is_shutdown(ip->i_mount))
+		goto done;
 
+	/*
+	 * Zoned writes update the in-core open zone accounting before I/O
+	 * submission.  A failed write leaves that state inconsistent, so shut
+	 * down the filesystem instead of letting later writers wait forever for
+	 * open zone space to become available.
+	 */
+	error = blk_status_to_errno(ioend->io_bio.bi_status);
+	if (unlikely(error)) {
+		xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
+		goto done;
+	}
+
+	error = xfs_zoned_end_io(ip, ioend->io_offset, ioend->io_size,
+			ioend->io_sector, oz, NULLFSBLOCK);
+	if (error)
+		goto done;
+
+	if (!(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
+	    xfs_ioend_is_append(ioend))
+		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
+done:
 	/*
 	 * Put the open zone for all ioends merged into this one (if any).
 	 */
@@ -162,8 +191,9 @@ xfs_ioend_put_open_zones(
 	 * The main ioend might not have an open zone if the submission failed
 	 * before xfs_zone_alloc_and_submit got called.
 	 */
-	if (ioend->io_private)
-		xfs_open_zone_put(ioend->io_private);
+	if (oz)
+		xfs_open_zone_put(oz);
+	iomap_finish_ioends(ioend, error);
 }
 
 static void
@@ -172,7 +202,6 @@ xfs_end_ioend_write(
 {
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			is_zoned = xfs_is_zoned_inode(ip);
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 	int			error;
@@ -194,19 +223,7 @@ xfs_end_ioend_write(
 	 */
 	error = blk_status_to_errno(ioend->io_bio.bi_status);
 	if (unlikely(error)) {
-		/*
-		 * Zoned writes update the in-core open zone accounting before
-		 * I/O submission.  A failed write leaves that state
-		 * inconsistent, so shut down the filesystem instead of letting
-		 * later writers wait forever for open zone space to become
-		 * available.
-		 */
-		if (is_zoned) {
-			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-			goto done;
-		}
 		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
-			ASSERT(!is_zoned);
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
 			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
 					offset + size, NULL);
@@ -217,10 +234,7 @@ xfs_end_ioend_write(
 	/*
 	 * Success: commit the COW or unwritten blocks if needed.
 	 */
-	if (is_zoned)
-		error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
-				ioend->io_private, NULLFSBLOCK);
-	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
+	if (ioend->io_flags & IOMAP_IOEND_SHARED)
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
@@ -230,8 +244,6 @@ xfs_end_ioend_write(
 	    xfs_ioend_is_append(ioend))
 		error = xfs_setfilesize(ip, offset, size);
 done:
-	if (is_zoned)
-		xfs_ioend_put_open_zones(ioend);
 	iomap_finish_ioends(ioend, error);
 }
 
@@ -276,7 +288,10 @@ xfs_end_io(
 			io_list))) {
 		list_del_init(&ioend->io_list);
 		iomap_ioend_try_merge(ioend, &tmp);
-		xfs_end_ioend_write(ioend);
+		if (xfs_is_zoned_inode(ip))
+			xfs_end_ioend_write_zoned(ioend);
+		else
+			xfs_end_ioend_write(ioend);
 		cond_resched();
 	}
 	memalloc_nofs_restore(nofs_flag);
-- 
2.53.0

