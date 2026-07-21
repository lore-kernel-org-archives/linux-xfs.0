Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBAB476058;
	Tue, 21 Jul 2026 18:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659495; cv=none; b=opXGi3PUc4fOJI07oVnS8kxHa54m145PtJPXSkebY6scGjglvxFnkmmLeiZCizkCYecHQF7dwAjpXIQWlBAr40Ay3RXVvBug5aGL9DkRCUvqpittpR2VKPrPDNO65hzOumdgLUFfd5xWR3yOD9+pp7Opkwadtu+fy2Muyv3EOeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659495; c=relaxed/simple;
	bh=wRr7eFnl8vfufclDpTftJAd15sF4NfbmiR/cbIBdOiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+zPXLFDxgdp6Zza4QVAX+MQEqCy10IW5aLzogofUsT9EDLTHQOF91CXG9C19wuDr+M8LPYAZJOQskv9tzG6yJpAz5fDl4/irkeMU7ne0Z30DjCYA2IxE49LPADUCsZkQGkzuehcSsCTNSKU10n3KXLt5UvpYgLUKUUemDH55Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mp2Y9HKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mp2Y9HKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96251F00A3D;
	Tue, 21 Jul 2026 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659494;
	bh=gWGHAsVEWDN5q0AsAxjKzOwxRUm3dDFZ1Y+hUuQVafs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mp2Y9HKXfaIoLawcvaDWss/0Ea/co1fENXBJq7kY4QEuRw8JOMj3c19+2Irb7Qi0J
	 ryQ+kzJ9ejM5iAgOiN2ds3cqGB1ZT9z5BXi/CIU5QysXMb98/w5rcCz8bUZX2bja2I
	 8mqWFg6snh8y8zO+izNhcD2JbxuCamFGUY0H7TVlidM9eOkcmuQM0N6xI3gJNwHOsM
	 I/b6qbFBF7V2xZcHXGlXa9TYl81GrM6RGLSD/faHoweZW8QAUq+RQQqz17NB9wtYGx
	 H9ZPeN/IaT1bqtFH8UYb2+5GPmzek5tkTVMw0cNNCS/r9MUliZaReTJKwR61MFlKrU
	 EQ11XQ6AMFRnw==
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
Subject: [PATCH v13 20/23] xfs: advertise fs-verity being available on filesystem
Date: Tue, 21 Jul 2026 20:40:57 +0200
Message-ID: <20260721184346.416657-21-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
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
2.54.0

