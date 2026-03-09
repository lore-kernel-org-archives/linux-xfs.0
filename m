Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839FA364955;
	Mon,  9 Mar 2026 19:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084313; cv=none; b=pmijdaMA2uw/mgUN/MA6K5uoH684T9do83UvUEnpoKeK29gddgOb7Df1IfLRXMsDk6kSesihLJwZcLHE/5hD2d5NG1DSQ6yc08hvRzwQmJR7sC10ubzXYriXucIcw9J2MzOswVWvSKu+WmW7Rcrwy3R+FZsTKdeZS8G854V4sVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084313; c=relaxed/simple;
	bh=jIkT/LcGwVGK1Mj4yHo/JEL/qmv264sooEL83XrUgxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pszBphuJxlwO1SG+9L3E2JxRFpvlQcNMwFK1FleWvD9g4/5lJUE8pQLDacz/WqsYv//SZ2oYmiMaFntbyHMuugw8Exnqvpkd8ZNsXofKrepHT3Bl3CyWeHwHyEfe7rth7QbTQRgc8z6+y8USXfn6UZmuwUuij6YkEisp3q3u7mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+FqWf0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+FqWf0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C4EC2BC87;
	Mon,  9 Mar 2026 19:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084313;
	bh=jIkT/LcGwVGK1Mj4yHo/JEL/qmv264sooEL83XrUgxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+FqWf0ZOIeq4130hehzhrGBlB0fQevoAK+ecGVEPqSdm0IU4r4iHeDWyI+X2vtii
	 jXOm+6VhGgXaTr0ZHLClG+gYUyKdeRry74CsD2QXBRv7mLtQV/tQ9BsYAYZm5LTUF/
	 sBSnFHuAgC2Bh1JKpuiI51IOU9anmhy+cOuxiYZzPmkfr8FgZqwJ1LUFe1I7AU30sb
	 q9SYo2ylBUceg+fwi8z55XCT4NSy8YW3bnq2BFh+dZyNSWjkhNxB51+/eZm58iY6xz
	 btW/Qq69MC2Ai1ifOWIaEkEYBzZD7nMa+qG5bEqy580R1JU9MvZcsEiXyy/RhquffU
	 1PohqSjuG0gdA==
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
Subject: [PATCH v4 20/25] xfs: add fs-verity ioctls
Date: Mon,  9 Mar 2026 20:23:35 +0100
Message-ID: <20260309192355.176980-21-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
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

