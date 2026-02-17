Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1988429E114;
	Tue, 17 Feb 2026 23:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370495; cv=none; b=OUnR8dPiYGFiA/A1nPmiTwfQfxXTNh/T7jTzzk384sPZEun0WgMlD0KkDOSb5xxPIBNf+LNCefziL5e2JsV0LEMFEO4wsIz8OQGR9Qin29o+9++2azCUmBzbA7Xb3p57L5AwzAxPbt44JrQz/JufeSK8doWcbelLFZJgNwc3Quk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370495; c=relaxed/simple;
	bh=6oK56CMRUyNmRHwTZQKh9FqFHzl5/p4OECqtyMqOAfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMHGVy7IUcn2EPAFVDVOi3axvinRKprGsJpMrVps3zHCIsmvUXfrjV63aRi0l5rmH4/NoLubHAI99rSFfUY7TztbNm52dijBwiFGlnno0un4xLdvdQxzg20g5fhydQRZj/DSkVNtkhQ8mhy9UXgc00E0iDNaeRMFWiF2KuI+PCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NifWuU/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NifWuU/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EF1C2BC9E;
	Tue, 17 Feb 2026 23:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370495;
	bh=6oK56CMRUyNmRHwTZQKh9FqFHzl5/p4OECqtyMqOAfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NifWuU/8TvZBvgzHu2i1Zp7nrhiR+wzgsmVqcuXxzopUEY6P+Lb1caDk/F/AoV7AX
	 d+sIpczi9sDMWWkjzu733aVib+o94O4LBMbPE7yLxsj6L0mx2KUvrdZNVBCGqSAy9n
	 T18zPJ+yEVE+jAf+f+K9VTZ5q6EwJZE8HLSxAtFEPlfoT0M1HfRTiwtw2EsYw+WVPz
	 qI4/GzTFwBi+yUor5dbgIpzQ4h/fn3fmNbwLRO2/YWMhLF2rRRo/zsO9NxfhJCNGjh
	 LS9DEJKbrerpdbXkEs4XJy/zJIpWcAlXYPT2Y3qjF8nGVaVN120o37nnUcqWEHKaFW
	 dpYAhgpu1VWFg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 29/35] xfs: add fs-verity ioctls
Date: Wed, 18 Feb 2026 00:19:29 +0100
Message-ID: <20260217231937.1183679-30-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
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
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 59eaad774371..d343af6aa0c6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -44,6 +44,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1419,6 +1420,21 @@ xfs_file_ioctl(
 	case XFS_IOC_COMMIT_RANGE:
 		return xfs_ioc_commit_range(filp, arg);
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, arg);
+
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, arg);
+
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.51.2

