Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D860E4D37B1
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349546; cv=none; b=felLjxYoOeUTg3mmdXnc25S4JxXFAL9LfrZbbG59nUJTyJFPBZjcPRZMpWZ2wrMbRW0D/JZxa6Q41CKKZy9sRIm+3X7jaEWaN0DEHRBSSXo4pmO+4Ocmb+eCkJF87BCXgiwlHUmOg1AUre5+d5iAkIMcC/5Cu4Yxf0+12ZWCxBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349546; c=relaxed/simple;
	bh=lycxqMwrwql1jQNIqgQb1cNKl4MRQk69DkJRbRgJ+18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfND8QCvc85O8UlsJ9DGAkJOvVT4wgOhk1gvl7Ik8cJjuzrFM73Zo5dp1GgFGY63JL/F3M4CATuqr1dWTZ+T0YGrKAHnkUrhy7Dl+CAYJKF6GGxXIZ5FjkUE2OELglywuTxsKUVrP9FOmCKDNGWOh+dBGClgDAuB1jh9/igzp00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mMB9fFRv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mMB9fFRv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kx5cagn0OwFm5bbao2Y52Q6Qa7YQhFUQqRJOZuYDy/E=; b=mMB9fFRv8yumMCVNEPqjOv4IIq
	tDF1KC/aj9tKBTi7Xqm81n5ERSeD2PBmFTRTHtScXCbX/Bs7MFCEbwe05CKKVlzvQcxGTYaHy28Ad
	O6Fx+fEzfo5gVxWHJ3Fmlh0/cxHBYuVg7y/aI8UbQRQn3ebhSP3C6IXmsc21wUkxJAbpgw0soaWtY
	D0A5onEtoHCxpQGjgosCVggnXyALVl3DTJliI3UgEFjUxhrzqn5Ql4FHYs4/YN6BJS97d0Iid3mVi
	g0bNNY0nDKDlX9fFcrVeOX7wSqGua8yblbocC7+2SuzKb35k6xXKGDiQnglxGkg7UdeUD2PDhicHw
	MeVmG47w==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7hM-0000000DlHk-2a7x;
	Fri, 25 Sep 2026 15:18:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: move xfs_*_item.h to libxfs
Date: Fri, 25 Sep 2026 17:18:28 +0200
Message-ID: <20260925151841.3385994-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925151841.3385994-1-hch@lst.de>
References: <20260925151841.3385994-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All these files can be used as-is in xfsprogs to replace various shades
of copy and paste.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/{ => libxfs}/xfs_attr_item.h     | 2 --
 fs/xfs/{ => libxfs}/xfs_bmap_item.h     | 2 --
 fs/xfs/{ => libxfs}/xfs_buf_item.h      | 2 --
 fs/xfs/{ => libxfs}/xfs_dquot_item.h    | 0
 fs/xfs/{ => libxfs}/xfs_exchmaps_item.h | 2 --
 fs/xfs/{ => libxfs}/xfs_extfree_item.h  | 2 --
 fs/xfs/{ => libxfs}/xfs_icreate_item.h  | 0
 fs/xfs/{ => libxfs}/xfs_inode_item.h    | 2 --
 fs/xfs/{ => libxfs}/xfs_iunlink_item.h  | 0
 fs/xfs/{ => libxfs}/xfs_refcount_item.h | 2 --
 fs/xfs/{ => libxfs}/xfs_rmap_item.h     | 2 --
 11 files changed, 16 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_attr_item.h (97%)
 rename fs/xfs/{ => libxfs}/xfs_bmap_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_buf_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_dquot_item.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_exchmaps_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_extfree_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_icreate_item.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_inode_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_iunlink_item.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_refcount_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_rmap_item.h (98%)

diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/libxfs/xfs_attr_item.h
similarity index 97%
rename from fs/xfs/xfs_attr_item.h
rename to fs/xfs/libxfs/xfs_attr_item.h
index d108a11b55ae..3bb3d7108a90 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/libxfs/xfs_attr_item.h
@@ -6,8 +6,6 @@
 #ifndef	__XFS_ATTR_ITEM_H__
 #define	__XFS_ATTR_ITEM_H__
 
-/* kernel only ATTRI/ATTRD definitions */
-
 struct xfs_mount;
 struct kmem_zone;
 
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/libxfs/xfs_bmap_item.h
similarity index 98%
rename from fs/xfs/xfs_bmap_item.h
rename to fs/xfs/libxfs/xfs_bmap_item.h
index b42fee06899d..381b8a62b47c 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/libxfs/xfs_bmap_item.h
@@ -22,8 +22,6 @@
  * bmbt metadata updates in the non-first transaction.
  */
 
-/* kernel only BUI/BUD definitions */
-
 struct xfs_mount;
 struct kmem_cache;
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/libxfs/xfs_buf_item.h
similarity index 98%
rename from fs/xfs/xfs_buf_item.h
rename to fs/xfs/libxfs/xfs_buf_item.h
index 28c79989d725..d0a1247d22c6 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/libxfs/xfs_buf_item.h
@@ -6,8 +6,6 @@
 #ifndef	__XFS_BUF_ITEM_H__
 #define	__XFS_BUF_ITEM_H__
 
-/* kernel only definitions */
-
 struct xfs_buf;
 struct xfs_mount;
 
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/libxfs/xfs_dquot_item.h
similarity index 100%
rename from fs/xfs/xfs_dquot_item.h
rename to fs/xfs/libxfs/xfs_dquot_item.h
diff --git a/fs/xfs/xfs_exchmaps_item.h b/fs/xfs/libxfs/xfs_exchmaps_item.h
similarity index 98%
rename from fs/xfs/xfs_exchmaps_item.h
rename to fs/xfs/libxfs/xfs_exchmaps_item.h
index efa368d25d09..4a42f70237fb 100644
--- a/fs/xfs/xfs_exchmaps_item.h
+++ b/fs/xfs/libxfs/xfs_exchmaps_item.h
@@ -22,8 +22,6 @@
  * rest of the mapping exchanges.
  */
 
-/* kernel only XMI/XMD definitions */
-
 struct xfs_mount;
 struct kmem_cache;
 
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/libxfs/xfs_extfree_item.h
similarity index 98%
rename from fs/xfs/xfs_extfree_item.h
rename to fs/xfs/libxfs/xfs_extfree_item.h
index af1b0331f7af..4d8ae7438b84 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/libxfs/xfs_extfree_item.h
@@ -6,8 +6,6 @@
 #ifndef	__XFS_EXTFREE_ITEM_H__
 #define	__XFS_EXTFREE_ITEM_H__
 
-/* kernel only EFI/EFD definitions */
-
 struct xfs_mount;
 struct kmem_cache;
 
diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/libxfs/xfs_icreate_item.h
similarity index 100%
rename from fs/xfs/xfs_icreate_item.h
rename to fs/xfs/libxfs/xfs_icreate_item.h
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/libxfs/xfs_inode_item.h
similarity index 98%
rename from fs/xfs/xfs_inode_item.h
rename to fs/xfs/libxfs/xfs_inode_item.h
index 2ddcca41714f..226c9ec01434 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/libxfs/xfs_inode_item.h
@@ -6,8 +6,6 @@
 #ifndef	__XFS_INODE_ITEM_H__
 #define	__XFS_INODE_ITEM_H__
 
-/* kernel only definitions */
-
 struct xfs_buf;
 struct xfs_bmbt_rec;
 struct xfs_inode;
diff --git a/fs/xfs/xfs_iunlink_item.h b/fs/xfs/libxfs/xfs_iunlink_item.h
similarity index 100%
rename from fs/xfs/xfs_iunlink_item.h
rename to fs/xfs/libxfs/xfs_iunlink_item.h
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/libxfs/xfs_refcount_item.h
similarity index 98%
rename from fs/xfs/xfs_refcount_item.h
rename to fs/xfs/libxfs/xfs_refcount_item.h
index 0fc3f493342b..c94b119624b3 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/libxfs/xfs_refcount_item.h
@@ -22,8 +22,6 @@
  * to replay the refcountbt metadata updates.
  */
 
-/* kernel only CUI/CUD definitions */
-
 struct xfs_mount;
 struct kmem_cache;
 
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/libxfs/xfs_rmap_item.h
similarity index 98%
rename from fs/xfs/xfs_rmap_item.h
rename to fs/xfs/libxfs/xfs_rmap_item.h
index 3a99f0117f2d..8e9a23e89fd1 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/libxfs/xfs_rmap_item.h
@@ -25,8 +25,6 @@
  * (rmapbt/bnobt/cntbt) metadata updates in the non-first transaction.
  */
 
-/* kernel only RUI/RUD definitions */
-
 struct xfs_mount;
 struct kmem_cache;
 
-- 
2.53.0

