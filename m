Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821D31A00EC
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157053; cv=none; b=pagClN5IRmLiKzh8nhOmXjmaI1sJsZFw4uA0mwY5f71daV3eXMRwdrjSu/XvoWvGFVLe72DyqoKtlWgk6Xv/7aE0h3/3KwbNuh8PnJZAo9+gT2rpwEr2vJ3mymJbtKyRu/SbTn9bgy2OkytzK+QfLKH93D7o9KiI5ppG++n8jfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157053; c=relaxed/simple;
	bh=aBpfz5tV3N52tXg6Vhw+DuJ/wRGNFIIkYmxuaQ5W4fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZw3zBMRStGUdBw+7/WtTUv35YfBRFP+h/9ugZ/HY1LDtTcQdnUmoGckNp4XvHvYAP7Fbw5xm3ZDH4Pv1t2H8hUo3Yok6OuDCcJWYTA8t4haJ792zy1Fy5GtqSNONA6mePuK+QRUfxeMv6U7VFFW0SyY7mWLOBT998ulTHZQvWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hWKf34ml; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hWKf34ml"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RW2GeaWZotApSjEj1SkVkZMT8tne6ryNBLRxXzOpDGc=; b=hWKf34mlCvbq94yxK9lTXWC5JB
	7KuHVNgSnIfGBJWEHCeaoHpJqds9IsGK9O8yRVbM+poHk9YszM7UYOmYHGV4voX0rzcZs+CH47/xb
	NjBGA69gohKAfA23jpNhbGfzNJ09W/qUzIgBqEMKt3PNuu+jVDCbRfh5aNkSPQMxtwAykYMkq87FJ
	ru1RrLocB69HHJTqdfg1P2x8oSlwb/hPOLMBno/g+xN2I4hxGTSH9ybVycyhsTuxwDZFvxzsTJRvJ
	pogD0kZ5yKjs1fgMym8zls7d8wmWVSU1X5oClYgWiodJjakCBeQpVtYlYO1QhDyiU5v0phMKN94P8
	AZ6cKU8g==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjl4-00000000kCZ-1z8l;
	Mon, 06 Jan 2025 09:50:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: mark xfs_dir_isempty static
Date: Mon,  6 Jan 2025 10:50:29 +0100
Message-ID: <20250106095044.847334-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095044.847334-1-hch@lst.de>
References: <20250106095044.847334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

And return bool instead of a boolean condition as int.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.c | 6 +++---
 fs/xfs/libxfs/xfs_dir2.h | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 202468223bf9..81aaef2f495e 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -197,7 +197,7 @@ xfs_da_unmount(
 /*
  * Return 1 if directory contains only "." and "..".
  */
-int
+static bool
 xfs_dir_isempty(
 	xfs_inode_t	*dp)
 {
@@ -205,9 +205,9 @@ xfs_dir_isempty(
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	if (dp->i_disk_size == 0)	/* might happen during shutdown. */
-		return 1;
+		return true;
 	if (dp->i_disk_size > xfs_inode_data_fork_size(dp))
-		return 0;
+		return false;
 	sfp = dp->i_df.if_data;
 	return !sfp->count;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 576068ed81fa..a6594a5a941d 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -58,7 +58,6 @@ extern void xfs_dir_startup(void);
 extern int xfs_da_mount(struct xfs_mount *mp);
 extern void xfs_da_unmount(struct xfs_mount *mp);
 
-extern int xfs_dir_isempty(struct xfs_inode *dp);
 extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
-- 
2.45.2

