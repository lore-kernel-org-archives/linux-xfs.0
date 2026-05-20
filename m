Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF13E3170;
	Wed, 20 May 2026 12:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280696; cv=none; b=uMIHnQfqWGyDtbk/Fzs2P+oRY062JYXFASazszj5T/fZNnqT/mMYhNxFmS1AmgUhnrYk6WPxecO39I52mZDswi2WZMvZIfKSMx6AVJsXq/BsdXNM58LCsnYsZGAG+Ufo5/AmDvZj9PuAsN4n13Gmi/g6VMCzJz139rI2SnsNVRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280696; c=relaxed/simple;
	bh=RpmGdpK19RQWoIgTFdViqQtD9XKbSGy/qb0W7trms+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mk9EwUakCCta3KxkOvf+dPHY5Awy+kHgQkMz/gxr8J360WNAE3935lYAfpAD+bOFQ0nytD1Yp2/IxY/THCWvVKD1U7oMJULe16wF59ooa75yoPELd7GPOX0daRW7CsF5LhZR9dTvTVmKlOLXj7+IglhxMNuqYHDaIcOxfbu07xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A21DPI5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A21DPI5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013EF1F000E9;
	Wed, 20 May 2026 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280695;
	bh=mfyAjF/CmUTJWYFj5Klp/BtXlNLH5opRVJLFuVtT+eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A21DPI5YQPBuVhDAVnIzMTuK4VVJioBQZQbdzkFplNnvjXl1IdzDB+o9R1PPQlBNz
	 7g8/lFEIBkRh1a6xvzMb5IGIOhi+khVCZ3ybEow1bA5QnNjV6dUJqO3Q/mBdFM82oh
	 ApC90tVdO/St9SPZTWxaAfaOilZG958BjvdOYD68Z+reXkNRx0IjE62B2Gu4FZpZhb
	 RdWUPdO8jU/f5ispiHdf1hRYzHsBYDv1zw/wlHtCxzwbQYag/XZbnYFpwKGWdT7Srg
	 UKTJ8gnR9Y2C+kK4uhPNWounxXavpMnYDhityc3XFreEujy7pnyGcY4OaWx7wSuBFc
	 TM7pIboETB3eg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v10 19/22] xfs: advertise fs-verity being available on filesystem
Date: Wed, 20 May 2026 14:37:17 +0200
Message-ID: <20260520123722.405752-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 185f09f327c0..c80133784419 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a15510ebd2f1..222bbe5559df 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1590,6 +1590,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.51.2

