Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70385466B4A;
	Tue, 31 Mar 2026 21:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992569; cv=none; b=fGgH3GJQp3Y39PTCFJr9xrgQtTyHxLrGJER9KVhaBiq01WUI/TdEPAW4vTEVEqLRpw6tXstSaDowOEctJNMtcYINE0KNboWOK6Wc8yKncqvtFmgN/avKYbvteFmjojEjlTyI/sZLcJQUOWjGYaoWNOy6mLb+uJFykP0AGLHcuEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992569; c=relaxed/simple;
	bh=sZh29Mv+klOHY0T8+BZo/78DTaP7x7d1uawWMbN02CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgIFx4FEeQTevU/6eun+htZh1hBMBRQRD39Rzswj+cGd+GBn3NaRsWlxDPp4dBhcUPgQtrzfREaZnE85eG/QVvUSeCplekYJZE7pG4Me85tvbn9g/Hv9DRPfkYxNqQLJMwXwClcSHNNt/zNBTlHkaowyEF8O807ANhsRaqRwXY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZOtpmoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZOtpmoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF85BC2BCB2;
	Tue, 31 Mar 2026 21:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992569;
	bh=sZh29Mv+klOHY0T8+BZo/78DTaP7x7d1uawWMbN02CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZOtpmoDqRNDxTDmpby9R7KzgsjTIfwXMKtfsgM1qINnGIzPslrBL7T1xD3bNFfmd
	 yZ59/xfyD7KdByynhx6drgFcQ3ix9//DNSsairjAlLRzkO1TjrTqPkBfIojozhqEL7
	 eoixKKyLqjT7582zx5lg9QPt7fSdXFxZ5WkD9Nuj1NYoXu1+TfZYeZB+8G8n08QKZW
	 ilxKPp4D3HNwmARlbP9E+172dsbIMbbQyml91Yij6baZG0REvESdjuux84+1IakQFI
	 bYn09fAEOEYIuX5SpDHytTqrtlqQDyO2yL2bQh4OsybPMgjy8NzEch5oRYi5PcQ7cw
	 OFuhWP7ZegZEg==
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
	Andrey Albershteyn <aalbersh@redhat.com>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v6 18/22] xfs: advertise fs-verity being available on filesystem
Date: Tue, 31 Mar 2026 23:28:19 +0200
Message-ID: <20260331212827.2631020-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
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
index d165de607d17..ebf17a0b0722 100644
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

