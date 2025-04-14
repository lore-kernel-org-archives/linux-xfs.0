Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE501862
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609035; cv=none; b=VTBpcpIWBbmDN20kbPATjmHaXMLYZ0u8/4U28lav7IxM7+19TL87SgIehujJC6QAxxsIq3TUE1NxKT5zMe1PpbWvB1qp3lY9eZjetGa9ZGrbj7ttljHUCtzlPlID6xVt/z6BOuGorM5iV8aFKHQ39ANhw+8N7CwLxI9mwb9QxYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609035; c=relaxed/simple;
	bh=Tmdk8rZNbipVreTGNQOKkyMf3m5RzzzBuVMaN/Qpx9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umsWfuRK741FbcnFjKEorw7QxK/YgKtOMayaKWEjwhj3uPuHonLnwidLhK33SYinKE9wvZ4Ned1IK9rt4d6UdAhQQSFz3xtG9uZwn1b18OBhNjlOEL/Xt7LzSvaVN67C5Clu6wGLkd+MwjWomKNVLl7RWdFFiyfiltDX/dtd6K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CoOIts9o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CoOIts9o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oUZWGhvOHl0W6bG7+OC/zqeU7uap43wc1B6JxjENE0A=; b=CoOIts9otPFFkvFnFk/9u6TleI
	prsbyj+9dJJjg7S12hGIn0i69HOja4aI7Rj7FUGmGbmS7OXgeZI8k2nWk7JBT90gnZ4ZJ7vmiDQJ9
	XF48NbhOq7pB499sGVPofQvfIlF1HE2wJF+hRI2g652/IgSrZkIXO5TYGEUj0WA2QNvFaZ9amJcPp
	UiFymF/wir9TDJVgghfbleGCzQEMFze56lufH9PmpqzuJLDGsTZyIR4hnzaDAftStqNp9MKNgJgj/
	NXm5rf5B5DPORCNnaWM8UMDZ0sK3VKEdeJdeSLySfDnAFuLwl7a7nC+qB4zOzHxvTuWZMKwazy4VM
	c/9CZ0rA==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVN-00000000iDh-2iYZ;
	Mon, 14 Apr 2025 05:37:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/43] FIXUP: xfs: allow internal RT devices for zoned mode
Date: Mon, 14 Apr 2025 07:35:56 +0200
Message-ID: <20250414053629.360672-14-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h    |  6 ++++++
 include/xfs_mount.h |  7 +++++++
 libxfs/init.c       | 13 +++++++++----
 libxfs/rdwr.c       |  2 ++
 repair/agheader.c   |  4 +++-
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 82b34b9d81c3..b968a2b88da3 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -293,4 +293,10 @@ static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
 }
 
+static inline bool xfs_sb_version_haszoned(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_ZONED);
+}
+
 #endif	/* __LIBXFS_H__ */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 7856acfb9f8e..bf9ebc25fc79 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -53,6 +53,13 @@ struct xfs_groups {
 	 * rtgroup, so this mask must be 64-bit.
 	 */
 	uint64_t		blkmask;
+
+	/*
+	 * Start of the first group in the device.  This is used to support a
+	 * RT device following the data device on the same block device for
+	 * SMR hard drives.
+	 */
+	xfs_fsblock_t		start_fsb;
 };
 
 /*
diff --git a/libxfs/init.c b/libxfs/init.c
index 5b45ed347276..a186369f3fd8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -560,7 +560,7 @@ libxfs_buftarg_init(
 				progname);
 			exit(1);
 		}
-		if (xi->rt.dev &&
+		if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
 		    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
 		     mp->m_rtdev_targp->bt_mount != mp)) {
 			fprintf(stderr,
@@ -577,7 +577,11 @@ libxfs_buftarg_init(
 	else
 		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
 				lfail);
-	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt, rfail);
+	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
+		mp->m_rtdev_targp = mp->m_ddev_targp;
+	else
+		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
+				rfail);
 }
 
 /* Compute maximum possible height for per-AG btree types for this fs. */
@@ -978,7 +982,7 @@ libxfs_flush_mount(
 			error = err2;
 	}
 
-	if (mp->m_rtdev_targp) {
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
 		err2 = libxfs_flush_buftarg(mp->m_rtdev_targp,
 				_("realtime device"));
 		if (!error)
@@ -1031,7 +1035,8 @@ libxfs_umount(
 	free(mp->m_fsname);
 	mp->m_fsname = NULL;
 
-	libxfs_buftarg_free(mp->m_rtdev_targp);
+	if (mp->m_rtdev_targp != mp->m_ddev_targp)
+		libxfs_buftarg_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		libxfs_buftarg_free(mp->m_logdev_targp);
 	libxfs_buftarg_free(mp->m_ddev_targp);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 35be785c435a..f06763b38bd8 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -175,6 +175,8 @@ libxfs_getrtsb(
 	if (!mp->m_rtdev_targp->bt_bdev)
 		return NULL;
 
+	ASSERT(!mp->m_sb.sb_rtstart);
+
 	error = libxfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
 			XFS_FSB_TO_BB(mp, 1), 0, &bp, &xfs_rtsb_buf_ops);
 	if (error)
diff --git a/repair/agheader.c b/repair/agheader.c
index 327ba041671f..048e6c3143b5 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -485,7 +485,9 @@ secondary_sb_whack(
 	 *
 	 * size is the size of data which is valid for this sb.
 	 */
-	if (xfs_sb_version_hasmetadir(sb))
+	if (xfs_sb_version_haszoned(sb))
+		size = offsetofend(struct xfs_dsb, sb_rtreserved);
+	else if (xfs_sb_version_hasmetadir(sb))
 		size = offsetofend(struct xfs_dsb, sb_pad);
 	else if (xfs_sb_version_hasmetauuid(sb))
 		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
-- 
2.47.2

