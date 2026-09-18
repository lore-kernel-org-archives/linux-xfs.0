Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F81A4E4C25;
	Fri, 18 Sep 2026 11:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730213; cv=none; b=gmTog144zzNstEl0duWjMQquGOdmcgoCDxEuMfDcJtEfqqpyg+VDmrEQFiDi7VEdftsnFi3C+c0ukU4Der3V00j6+tLUww0nNVl80MFP/HMBFQNZyU/Flh1QhgLVRNJZzPeyRLxmv4ikRtsSYZZJK+wmfjeiIBSK5+n9ya97qMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730213; c=relaxed/simple;
	bh=GoZafcVwYM13EDs2y2xw2tBf35tv1AhEEm1Y2K/M1NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKlH4VF0CNjRDYI1fH0QIWNpgSCZZYU9QQN+FITj4Xd4RdFYCazdYlm1qbPnuouwRqzJiKLB7fTMrwdwZMn67UI38FWdKaYLSAMEnGThU6ajLbaCPlaVsCIc7+d2ReiZEQZWKnrb4U+JfQxDuKGWejyR8q9Hm65gb5z98bjYuxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmwAxfYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmwAxfYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B3C1F00893;
	Fri, 18 Sep 2026 11:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730210;
	bh=bSv6TKlW4NbrjSEeVlXfAwkAliMrPUfKHonbv3D6dao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmwAxfYcw+WkJlxVlaOJseqnRuyguAQo71ovBJFGBEqhxRKZGiNC4rRTB0a4o0vT8
	 K4LbmZJSWIisP3SWoMIF5XHllxreionK1gYtjkZY5PtGc7CRdZWu8Ur6RGqKl25XU1
	 ZhkejPG2a8TH1+GyL4FDIeR7p0YPQdM39PdJfo9fMIihOpkMGGVpzJXwP6AUI6ziav
	 oED5IpKHSv/rfpXCIkPFpF1s7fH/S3IsQ33VXEp1uASy2+n97HoD9jDxpxiL5S7PgT
	 Vvchi8gPvPbAFxMoQIB526dRzfyB3XGlvXOgz+Zc8hjbCpWPx40tXSIBuN+Np7inDd
	 oahp7mKSVfOAg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v16 18/21] xfs: advertise fs-verity being available on filesystem
Date: Fri, 18 Sep 2026 13:15:30 +0200
Message-ID: <20260918111539.1003439-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
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
index 985c7c6a09f2..fd06c3d6cc11 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1587,6 +1587,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.54.0

