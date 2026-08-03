Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41433AB294;
	Mon,  3 Aug 2026 20:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787800; cv=none; b=YU3msuDdgXP5+etDtdtWGU4l9Zg3fsh5Rsi2KZWmWh1dZibrgRh2F1+d3ZgbiGdIzPlFgLUGPdcXs+QTrjmdTYakhQ3ZjBGOjziPaZ2Z6UHsEnYvmOsIj1zZJOr4fkjcZHRqsup0SW/ezUQ4F8f5Av0AeAsZN0r9t6dZXPy8DsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787800; c=relaxed/simple;
	bh=VelucZJPsab2F5jxEpX3NBOniOMrZ0GVGPAxyUbHahM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6wDc2woQZC5gShQv8gl60fbxIVHrziB0aTJEQ7fQkTTVYbIWhxEAYYjOdYBvH0w5G9D0PHxrvuUvFK4rtG6TU1U7iAXSiIgbABSHKJvbreF+s/YvEqyClFHmWXBh5p6VMz5N80WKQyxGr4BkSu5A02fZYMXWzHtxutvNnWiNl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGrjjPeB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGrjjPeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA27C1F00A3D;
	Mon,  3 Aug 2026 20:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787799;
	bh=dse18FWQSUIoP6yquYEBISwJ2j8wLduiXGfJxJRjVuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGrjjPeBqoBomI0FnqUUAOZbXZ1ILjTbKhgkYyNGC5d5PFY1qAlmAp0ZvKM7oKiq6
	 Jk52r2hsVctNjtaTZzdBf9pZ77z7BQcgq9FQoIOIfHFVUoY78DZedjSmIUclsv/0UF
	 cOj5bHdTM40SvO3yD8pKzBhiff5Rh26wxLfGWRtb1CNHZk4hHC62enCdpqf2H9VSBw
	 Qh7Uz47nzUf78OZFrfPX25OK5z8LxRgHzLyROdg5MvGZj/hBdAfFWsW7XT8rOLPzZI
	 tk+0iWSxynD9q2aM3cY5p8X52FLvtvRQhz7SSbVjOW8Ye2uVJTgJAS91TbBNPJRmQ6
	 jbeam8h1tXZOw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v14 17/21] xfs: add fs-verity ioctls
Date: Mon,  3 Aug 2026 22:08:07 +0200
Message-ID: <20260803200820.393203-18-aalbersh@kernel.org>
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

