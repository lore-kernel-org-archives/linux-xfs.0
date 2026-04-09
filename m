Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADED3B52EB;
	Thu,  9 Apr 2026 13:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740504; cv=none; b=gNpk6MpwZrJrpO45EmoWIiwd9PahISw/QtGK4Zgtau986Hj0OvxmIRP84vt8q6IhXW7BzNfzeqf4MafQgvAWynrY3mL2IkXKq+IoS/amkYmGtnBdWiIpN3Ibr4dFZl8j12AK2Msw6hxRyDIdUE1RHYl9fys8jGG1r9iEAh1osbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740504; c=relaxed/simple;
	bh=Aq0ZUSqSUefcts6LfugDkZmOSMW+4m4ueZMlzDmeXr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEiOxGtNQKHGP5/ae6LwPFstho87IOMXaiE90IVDa43dgqMn0DopE15wdVk0x/rqrt8krWDniKA2kURq9cV0p5WxtTIUbRDe0ufW4kwfCCVThKgCNGJQ9N019ETmOB+tIKXY9YngFwkfPs5EVNp2M2NgDR8NMY6D1r44SCPNzbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q33568AO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q33568AO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA001C19424;
	Thu,  9 Apr 2026 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740504;
	bh=Aq0ZUSqSUefcts6LfugDkZmOSMW+4m4ueZMlzDmeXr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q33568AO7AWxTHl3fgruq7ouHkVLuiTVv9J32J96bBb8Q6dpu1gAGXS0LGUXLN+Zy
	 vn08JYzzAA5dg2Nq9+dyKTjhyDHZkvjXLY1m3qYQ9A0X77OtDNwJBIytldwYEYRRzs
	 318K2zDvGNZn7F3QoQ6TLyIeGP3ZyrQiuO5nSWrYYNUDH747RJbfOAqvc6kHS1bIf2
	 6bg6ZKYwAaaFlwBPCpXMfmt122V9IFZSOA60LRgNRAj2UX0avAwcm4nrebAe9Aj0Ep
	 s3cu9LGlDuRt57qOUC6JzG7LZcAfYXi4KWRZ53U/sqcTM2UtZ3Ibzkdc8E+jALdswC
	 xUtClO3WoGw7A==
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
Subject: [PATCH v7 18/22] xfs: add fs-verity ioctls
Date: Thu,  9 Apr 2026 15:13:50 +0200
Message-ID: <20260409131404.1545834-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
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

