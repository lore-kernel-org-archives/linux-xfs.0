Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5FD39EF37;
	Mon, 20 Apr 2026 11:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685712; cv=none; b=JZprEy+gA71mfElde1KODk7Djz2wKQOIvSsWsy7Wm/8TNlv2BNL/0LxfQQUWQq0BYv1QSh4M+AJfnfNvMLgNvoUxKJVUlraWSqsJ4AIP4mDD9/6dcpwZ/nK6KEexEV4H9sEbq6Kz4oaZiiyUaOHgxj/aRilcJgEJgqZuld3Ert4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685712; c=relaxed/simple;
	bh=sZh29Mv+klOHY0T8+BZo/78DTaP7x7d1uawWMbN02CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQr9fPirkkvm+DmB/2Om7ZFXZUVLl2ph1EUfq4hyF9KtA2CUsMOlqyHDC1JERsmz2DSjHfSXmG+KZoNpnornl3Veg9rut6Ug2VlYjynLsp/BikoFMeOrFyvKHGOBwa4cl2A0jdj4lAPwtXDTUktv10fuWMBI2DrzdwECGEjNd/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtkkhAMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtkkhAMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BDCC19425;
	Mon, 20 Apr 2026 11:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685712;
	bh=sZh29Mv+klOHY0T8+BZo/78DTaP7x7d1uawWMbN02CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtkkhAMDLiMlWuj5jl72c/Gn67OApq9YL6Vfmcep4Coh4SJZqSLoi5h60iA6xlrQk
	 0JeB/mI4I+vGuygGwQaOOnX4iM1kjyCfUh535vXX+RKBzCsO3bazhp7YCHNij3DzlT
	 1v6vgDC2dTczIPJNF57N/8QT8cb6EL6Xe0kPvcocRjkutsip1xDUtvI3uow37IikJW
	 Ia3FKmDcIvL0Apupbya6ZWTHCWBzgrxv01NV2Qk6mlAhJsdpytPs4c1vZjm9csBd86
	 WqMkssoBbfkf8QraA1b2hh/F6wKjvchOpjmq7L3/FJ3ufWgdCO9i3zNbbFlILPHs0n
	 B+p6WUSw84m9g==
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
Subject: [PATCH v8 19/22] xfs: advertise fs-verity being available on filesystem
Date: Mon, 20 Apr 2026 13:47:06 +0200
Message-ID: <20260420114714.1621982-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
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

