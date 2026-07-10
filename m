Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6394F3B3894;
	Fri, 10 Jul 2026 08:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673656; cv=none; b=aM6sHplQ4zFCAfd22F+g7SNIQ+1tkeTPsWjDSmwJmri8Y4aKOCLxEcM9inowrtXmgo5uhr6nab1KEYPoUz7r9v/W59ApjKmMycMHFhJ08pmiTrAF/AkDRw+tEdL4yXZKt+nx0gXZakKJt0uyOn1pMG3FTURYt8IK6+tnQ8AHR30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673656; c=relaxed/simple;
	bh=wRr7eFnl8vfufclDpTftJAd15sF4NfbmiR/cbIBdOiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1Kh1yBIgrvBem0MJPchZRzM8gsVXQoCf0AkjLTHdrZuOwc2buPDlXlcw8St1dx2qpW5Wtf4J6krCRT5k8UyuFolTtgyA2anrObKpRSAI9bWC59jcmpi9kH0VW1IpNYfNdp43PgIrQ7OsT4HlqRAHyqwzXQmDCotfR6Ngsdm8ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4LJD5lm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4LJD5lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C791F00A3A;
	Fri, 10 Jul 2026 08:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673655;
	bh=gWGHAsVEWDN5q0AsAxjKzOwxRUm3dDFZ1Y+hUuQVafs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4LJD5lmFH9jU7mhpJmp7RZNQ2FfTX191mZ2lexxoX1sCIxDwosQeCmXGpaQ+pSRR
	 Br5lNxMoVU4Rej5uLFkOoSeD6fhBuprspL5twzl/7Xry/3j+/73tvI2yjpq4jYuU1Q
	 ZJkPX6RCjLxxP5I9kCvo+AI0bDz3d8bnWFMOEFYxL6S3mcDGUVqAzI1kDW07zuOGE3
	 iZ7nnqyfpggy+UY9UO67KnOEQPRopWuXPiRAJLKJMScQHzyHKYFu4NyvMOoTz+x+eT
	 vW746JG0Q2/lfmLhyt45CWmX6OXQaG33Wd8SZAVhzmv/7hsCr8bvLfkgbNd5BGsJ1o
	 /F1Ba+xV9OwXg==
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
Subject: [PATCH v11 17/20] xfs: advertise fs-verity being available on filesystem
Date: Fri, 10 Jul 2026 10:52:45 +0200
Message-ID: <20260710085256.3464201-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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

