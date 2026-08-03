Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71CD40F732;
	Mon,  3 Aug 2026 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787803; cv=none; b=cE7hushZSs3Gwf5VKLEvhIGu8B/bxAYNkN/4RMbXJ1pSOMYEeSUzlLFAnXG1x3Z2DhypzbcRBqkl+KBdAZzIDO+68QgORx+jlVLcmigjvfAuX0TPGrX98m7UZOog4Q3LSyZLGh4cDPS/1S0Nn1pA6D7CD3xGnIvnBu/U0++CdWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787803; c=relaxed/simple;
	bh=wRr7eFnl8vfufclDpTftJAd15sF4NfbmiR/cbIBdOiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TV0d/mOHtqxa3lveBUnUibSmu/c4Wri0ZULmaAlxBo9ELUwOiCfLetK59pcA1LPZuNTS2jsowEBpLXanyrJAzYvuWrJ2wJnaHuArYgQCR76SLfJjq28aVoE4jBK5IsH4BvTrgdRjCleNS6TmCfl9L7d26X4BIKQSSzI4IA3owNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJUWGuU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJUWGuU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DDF1F000E9;
	Mon,  3 Aug 2026 20:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787802;
	bh=gWGHAsVEWDN5q0AsAxjKzOwxRUm3dDFZ1Y+hUuQVafs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJUWGuU68K50f9tsYLbeSR+kY4ToTSodbBbblzqamjIdfW2V7acEjis7wDm/TSZZf
	 8vFfuGJcYasnhhLny3IkKQs+zW6jUaX8FEIy8cnWPLNFflD/RdVpDPLcsG29fZ8gFH
	 nX6hxjMpjffzvI1J3XqtSahRHSH8HD04APtfvGlXLAXkruoddHs/1dOIxRetSfeCZb
	 YvVRhl+ASpQ/7xxfQf0MiCx5T1Ayz2qrszr413SwN64H+utZIGkyTrzCITJLWBhjYN
	 3gbCIEAK1/v5db3qwrikVNWdUpFuxptW7DBNRi4OmK2aGUU4IlPC+1X8H+2vFD6pS9
	 FPVzeMSnHMXfg==
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
Subject: [PATCH v14 18/21] xfs: advertise fs-verity being available on filesystem
Date: Mon,  3 Aug 2026 22:08:08 +0200
Message-ID: <20260803200820.393203-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
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

