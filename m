Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A68A3E0C42;
	Thu, 19 Mar 2026 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939813; cv=none; b=NJJvnkJa61J7DUlrxZB6L773P1EBPjQ1BcBIPz/dwOP3uPA2nhf6cRRq5xlKdNSDUrZlCwCG3hiO+5VzBLrcCyuENQXuyeX/EepcZ4vIm+q5OgoyuLro8NentwMlT0wk9B7sUobInglhhCuoACVfBvkVhzfg7d4Yt/tAhAzKysc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939813; c=relaxed/simple;
	bh=jIkT/LcGwVGK1Mj4yHo/JEL/qmv264sooEL83XrUgxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOdL5npciq3/fpaEAVtrkDJfx9O3zmJjHGWOAwp/WWkMa5uEMbKpgSO2Gd7I2nCBZseLSieMzy43UD5raPv0PgKl/Rj8ay5yq7qeYkwD4ipvvhIVzFVUiQ/hxFZv6LW0aM4PYPgw29iiuf3FseK18BIBcDtaPLnlE8EWvc82igQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAwF+qeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAwF+qeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A46DC2BCB2;
	Thu, 19 Mar 2026 17:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939812;
	bh=jIkT/LcGwVGK1Mj4yHo/JEL/qmv264sooEL83XrUgxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAwF+qeE9avLcqsjEKYFLdxIg3XgP0CSxs16ZMkB4IZMsU3V36Ck0T4pSdnMbQZ4Y
	 Ysk9oidoNGBZT/DYL3wWTzVs53bPY9C/91HMz8XHJ/1VF5ssxQjrDne1P9irHBCgRU
	 OiB8I4I21roHKJDa+B7tlWKgitkZ1V95LGqZZH/x26KDjrZyDSiThEo8KgKqBgdUhs
	 T3Rp6HItgBN6LUsjynE7hjO8s+kLuTflR/toFV+8NA7YNH7f5VjtrYOzfLPYzMQvZM
	 k58NqsAM46p3Me8QJaFwM8ZL9QA9eV635DCn660C5vALcxzwwVYZO9R26GYOfkDUi7
	 oG+h8agYRhoSg==
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
Subject: [PATCH v5 20/25] xfs: add fs-verity ioctls
Date: Thu, 19 Mar 2026 18:02:07 +0100
Message-ID: <20260319170231.1455553-21-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
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
 fs/xfs/xfs_ioctl.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index facffdc8dca8..e633d56cad00 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -46,6 +46,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1426,6 +1427,19 @@ xfs_file_ioctl(
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
2.51.2

