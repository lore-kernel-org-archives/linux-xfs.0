Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30613C4555;
	Fri,  2 Oct 2026 22:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980693; cv=none; b=riajVIjSisg1jFpDXTLRE0AMGdsfkqAwOqK45MtNDABdqXs4gbeI3ZoDzjUQ1lK1n59lYtgYGuRbTkg6NnGAqjTPFtA0nx5MZlnpujNIOvHQt1Sjgqg+EnWtJKmfVmFRuqIy25zS44bs85dbjb0y4ymxbTDYG4COgZixG5jKdnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980693; c=relaxed/simple;
	bh=lG0XvtN47lrmr2yjGsrjuEbv5pnG0/i67p2cCRVww04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjz1klh6cUkr4WGlbotuuy3IVrC8SDc9R3sTUKeLrAAWoT7uCuq3OgkZGeOazudx0gYCVsO0inIPFd4K6ODfD4EsvOyDHtIeMwaJ2tiFHf+oCQuYXtt3Eb2ikGMxTjU/9dE295RsmoNLSQKLW44tMqulTwwujZldUsF1NvC8k7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNlQY51U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNlQY51U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDFB1F00893;
	Fri,  2 Oct 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980692;
	bh=HrtmR+UhuIlkdLxqdHwsV1MPMtkWUuoZJKrA9HvlOJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNlQY51UK2aqkIyJmyZ4Kim5Wn44NuJ+ZNK1ATX3nI/r5cLKmuq7G252oExQojpgI
	 9SM8z0Tr9CdqjmM5/YGd6GjVMDQn9BOO+/lr6Xu+J8AvFDMf00x5UHdB2R9QPpFoxw
	 1TWiyZYwFj4gaI1ngJwCtiSbozEY2/RtEuurfiBiUmP5/AQjkk3T5Ca2ugVqLE19Ap
	 oXLg7Uq09YlGPJGh2BGRT4sp5HrfI6HsRTgl0wekMCyWb2LZGoPHNKiLmRSa65BT9w
	 lh95gpeOl2mCy1MGIunwV/zMEAGdR8Mcft7QLyK2dmGlcjKlfTgmZ5WQm/UnubyiK1
	 yFTRZmuMdNw1Q==
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
	david@fromorbit.com
Subject: [PATCH v17 17/21] xfs: add fs-verity ioctls
Date: Sat,  3 Oct 2026 00:36:58 +0200
Message-ID: <20261002223705.2175542-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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
index 96ca3e480cb9..ac4c36f381b8 100644
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

