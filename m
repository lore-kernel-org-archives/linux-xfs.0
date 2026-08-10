Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5443B05BA
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376284; cv=none; b=V9rhryUBxO1CHdEECkatlq6+bZMxuAo4NQfs5URzxmSSDL8BAzpyeXN/+8xTKC9LQaTsRdLW/vK9TQSUrqmfLu4cggeB5IiAAQM1z4qWLAr0v13Iv13cvTnapdpRNVZAxgjF98b3CAA+Qj/hU0YK/Hcdr9YmmDc7lNZk+JTRJiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376284; c=relaxed/simple;
	bh=hFTNn49Lll4LoqVimpLPTXVl2fkc1S1g0cDYeTHMbvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvOQwevEe/PA2mew1qaD2mqPDtgyDiZnUfK5pEF0yWy+AzSXTMURWURVnX9VhCYoXUmjG6VLxJJWE/8PsBn7vlcA2o1Jwl7f8+FEz5/VqZv+sD3O4Ro8/817F2/hOPx81PXC6Bw36H4b0golz1H19qChMqvNO8kLMezNZIRafSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P8wkJhza; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P8wkJhza"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C548Wh6jtxleEqfX5WiNgHeAiWWQR+d1eKCZQEoZpvQ=; b=P8wkJhzac1W+QCbVQdF52lul8K
	X1PDaVCH/avsb3kohFgdgHwQMlLyOpjkAoMCKTxiz4keKwnUykbfzrOUo/rV/D5ntYCgK7/P4qrCq
	NYnY5HIQdpwOD6u32KQGxxSWthjVQ2SOyBnMAKG572PQ9/MqZwfsFEn0ha/RvQtm/62hlCqTUijYw
	w14qqRsfKFJf7ifga3fmD2Z5hdQaTtPZUZxZFP3j5KYppnHpZT+IU/qP5ikznqLK2dv+i0Mf/2hpd
	guyTBAPYLPvfDDMIOFWYxPmmG4lJq4WUaFNTfqk2/3RZK3OzpkgKPeTIKran9z7fAjQqRax6G2Fu1
	5oweyNWw==;
Received: from [12.156.71.108] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtS4f-0000000CHou-1Wqe;
	Mon, 10 Aug 2026 15:38:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: factor out a xfs_iomap_set_anon_write helper
Date: Mon, 10 Aug 2026 08:37:45 -0700
Message-ID: <20260810153759.466417-5-hch@lst.de>
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

De-duplicate the iomap setup for zoned writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  |  8 ++------
 fs/xfs/xfs_iomap.c |  6 +-----
 fs/xfs/xfs_iomap.h | 14 ++++++++++++++
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9506cd8d15e6..d46b089f006a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -633,12 +633,8 @@ xfs_zoned_map_blocks(
 			XFS_BMAPI_REMAP);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
-	wpc->iomap.type = IOMAP_MAPPED;
-	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
-	wpc->iomap.offset = offset;
-	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
-	wpc->iomap.flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
-
+	xfs_iomap_set_anon_write(ip, &wpc->iomap, offset,
+			XFS_FSB_TO_B(mp, count_fsb));
 	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
 	return 0;
 }
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9fa9aa33745f..e87c26c3e03b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1080,11 +1080,7 @@ xfs_zoned_direct_write_iomap_begin(
 			return error;
 	}
 
-	iomap->type = IOMAP_MAPPED;
-	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
-	iomap->offset = offset;
-	iomap->length = length;
-	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
+	xfs_iomap_set_anon_write(ip, iomap, offset, length);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ebcce7d49446..f697d7e73ab6 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -29,6 +29,20 @@ int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
 int xfs_truncate_page(struct xfs_inode *ip, loff_t pos,
 		struct xfs_zone_alloc_ctx *ac, bool *did_zero);
 
+static inline void
+xfs_iomap_set_anon_write(
+	struct xfs_inode		*ip,
+	struct iomap			*iomap,
+	loff_t				offset,
+	loff_t				length)
+{
+	iomap->type = IOMAP_MAPPED;
+	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
+	iomap->offset = offset;
+	iomap->length = length;
+	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
+}
+
 static inline xfs_filblks_t
 xfs_aligned_fsb_count(
 	xfs_fileoff_t		offset_fsb,
-- 
2.53.0

