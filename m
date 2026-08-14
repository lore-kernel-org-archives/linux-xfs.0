Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B980140B6F9;
	Fri, 14 Aug 2026 09:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699641; cv=none; b=ukyWHIgz4z9NP62736tYBgudhFaCg0bLCE3NBEMiL6c6Y1ktaZky8Tyo3B0e3xq7YPyQ0GEcsbmv6Uu9IczoBaOmHnh2M/Lbfo+X+LUUVVbiqtvezkpkbU4sg0znFrDfeloscFqM9qmfsI4LW0BSofwcbevVnH5JrVpt+xUB7mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699641; c=relaxed/simple;
	bh=VelucZJPsab2F5jxEpX3NBOniOMrZ0GVGPAxyUbHahM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc+QkF5fhrv0c2uhjldPfSaLt2dAej+LnPAlU5pt8RU76uvSUAz/hRPjNRT2rMzO7eRQGcXJjioFd+T8BJ2Zpl0JDCS7ZTKQWMq8uO4DLUJukC75QGaLf6nfv+3dken4VoAh58/t6dlcxuTerkGI96lSuGzAgJ4/kjUlNhBf3sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HonV7aqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HonV7aqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158541F00A3D;
	Fri, 14 Aug 2026 09:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699640;
	bh=dse18FWQSUIoP6yquYEBISwJ2j8wLduiXGfJxJRjVuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HonV7aqfeQsMGvoCrLXNJWRL8SiztkR8OhKouolUR45inLrS6t/Ein2YBoSi/i4hS
	 RoU0RmnrN0tgf2wga5a7DPKlexWrUKwBH2zrOgQPTlgqTigIwZBuuvSzyMReUxsncK
	 P1d2xSMwuLzHQ5knbrPlKDXCfri3rDlWG1rcTf8YYam0OwxOnWeJHyDGgsV0joue9N
	 MAgEa+FePdFgHpAs+lCnWtohVGKMc/EX6PWw13mRjAPNd/xlQQb23MLVGQstZ4VSBv
	 X76/PJoS3GHGrDtwKbrAoe6UJ19C4rNFxkikJl+69l3m2x28QPk1/j4RSyY1oYA1l3
	 Hxira+zhhGE8Q==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 21/25] xfs: add fs-verity ioctls
Date: Fri, 14 Aug 2026 11:24:38 +0200
Message-ID: <20260814092448.1818082-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

[djwong: remove unnecessary casting]

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1b53701bebea..fc7860a8b5ab 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -49,6 +49,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1466,6 +1467,19 @@ xfs_file_ioctl(
 	case XFS_IOC_VERIFY_MEDIA:
 		return xfs_ioc_verify_media(filp, arg);
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, arg);
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, arg);
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.54.0

