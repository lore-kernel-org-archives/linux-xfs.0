Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DABB4E36C9;
	Fri, 18 Sep 2026 11:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730208; cv=none; b=C3f8TtqMJN/A/mFo/t6wF+C5MuQuxWSsB7wRn3nfFa/8JV7pVXvpA1cxhoyDWGOxOULzluU9yRpjidTfV6TNwOqVMMTyzVupKZDnaknZ1qwqPrYrLAe2neMb4DSNWHDFAEAM3tVNbQpLm7BLTeUPWJHOEb8Ze4UefPFpCZWnEsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730208; c=relaxed/simple;
	bh=lG0XvtN47lrmr2yjGsrjuEbv5pnG0/i67p2cCRVww04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxMfOUih6BZjsO+FACeKrfkFp7qTI3BZyDW/xsyrmnfPEzLDWZ4iwbjVe1xraRHoERxfafxGfLKDEdJwLEWnRV/gr7oIGX/pRpaXhz1He/W4dOu/Jql5pT/juutQW6EL0qMhoKlTgZOo1rThiDjaDNG0e71Pz1K1lf8lRPBUhCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIGh1bCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIGh1bCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104631F000FF;
	Fri, 18 Sep 2026 11:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730207;
	bh=HrtmR+UhuIlkdLxqdHwsV1MPMtkWUuoZJKrA9HvlOJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jIGh1bCCHg3BhkViWBsaJivhESxfYbOwhZGv200dU2SW/TxAz+7XcZkqMSkRsoKVE
	 JVv8OBX95iQXui/22wg4SDYw1lAFgPJ8Lwailg9kP/OEHs1Hkx/cGYwbat0X1t09jJ
	 /uttCCuiFVw62vWmtdaoB0N6qugIdxc6YtQyFMENFHxNoAy9gOi3ZYIcKEQPqNXvvX
	 RrKy7LGdO+Q8bRz5GACKfRU4/KQROEd5NmBFLM29pbmVAZ0sPwzaFCJew7onGKfJ5y
	 t9KDGRrxPA5QqlQDMaOIF0p/PKZYdgnq+pmhyfVGVDPG21qPzRTgBXqJ7q5V0gKpve
	 /LBFZRO5exAgg==
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
Subject: [PATCH v16 17/21] xfs: add fs-verity ioctls
Date: Fri, 18 Sep 2026 13:15:29 +0200
Message-ID: <20260918111539.1003439-18-aalbersh@kernel.org>
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

