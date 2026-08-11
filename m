Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789534519A8
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786467024; cv=none; b=VYXhCB9fjwgvMnhw7S+iW6k/9dEAIEPyLo1EyBlg/sNCe4XVRECmnQMf5R1uOq6QWOr0QmpzcFeviO61MbppzG2odFzdcReYYswEsaoYpu29j0l1506zMlz082KX3JNr9KqgxhHrCqZY+KF0/qToD6vEi+FaRn3ngYXYr0lT2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786467024; c=relaxed/simple;
	bh=BiMsmyPa4DZHs4X3A1a2fMZXvWCb39AjrdC0ryoSZJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePvC2PNId1i1d0ZMqPh1ge9u/bx06HIBTPPt7ItoCe045bK0QrB/JHMv/kkFl4L6R6c3kDSpbe1rwz2Aej4CEz38f18GG8OPe7lIc6PSmzQxV+PDHB+rGB0p8WTVyjmbQeZZtQ8WwoZZH5eGePFiBa0hXFvmxaNe+1zTYR3mILQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o0j6S/kr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o0j6S/kr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FH2eyox5F/qYbVGc4MLQInPJfCkOjsZ5OUpqFTybIgM=; b=o0j6S/kr1MYekNLgLzuz0JjNBs
	Ahmy5g1gbnhUC6vHs/KlnK//EW4pO23/3RAhRXkVr3x0Ks00AvMxWk2xKgx5Thej1/GzEu5cUVh4i
	35pbSpab9zT4pChGFzY3Qd06kmoarrE8g/7fCjVpxl3X3C2ca01Xyy88yZxsQBlWUVaJVpGd/JHzc
	tJhjxEOpcuAcgy5KS6TnrWEHFSbpl86WLfSwLVP9PNTUVc0B/D6KVTmtHNNNHRpKnNwe8RoPrSMib
	fTdrXny8ZH9XPCS7DCodRUHiMctWyIUX9zZqPNwqE5JXXAB5XkPw+FHwrQlREXDU6VhS3K7Y3qVLg
	LSPQ1HRA==;
Received: from [129.253.192.68] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtpgC-0000000EYQN-3Qk9;
	Tue, 11 Aug 2026 16:50:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: factor out a xfs_iomap_set_anon_write helper
Date: Tue, 11 Aug 2026 10:48:40 -0600
Message-ID: <20260811164912.124416-5-hch@lst.de>
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

De-duplicate the iomap setup for zoned writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

