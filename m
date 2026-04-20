Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4347C39EF05;
	Mon, 20 Apr 2026 11:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685709; cv=none; b=P8NL1uytza40MXaCJwIT2dpzuEDHm4J4LDTJHjOfFP6XNypQzv8qjyaLWrKlcibuNZcbgavoGhX+LHF/bJBVKDL6WvAsHxy0T2NxwnDDwAJyYMdKpv+FNYYRzTCk00uk197bYSHXQH+qdy6RogO+HylNZMo1iVPNO2fcMVDYkDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685709; c=relaxed/simple;
	bh=Aq0ZUSqSUefcts6LfugDkZmOSMW+4m4ueZMlzDmeXr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfAvUya9d2UaZ+QQPv+B6wOQrTvhjUNqGi4hYcBJBLAwVXHM4WxaZ5RMQsEyxX7Hdpazdj2e5sMi9n4PNv7sdHkAhZkE1cBHoWHoY5wImZUFNDxl+Wkf7f507sVOXDZs+pqpe/h4qnF36a8zIdUuaHk+r0taK6cptMJur7SIjlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3XXiqno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3XXiqno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ABBC19425;
	Mon, 20 Apr 2026 11:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685708;
	bh=Aq0ZUSqSUefcts6LfugDkZmOSMW+4m4ueZMlzDmeXr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3XXiqnoNOxaVrterQ0sDIvw7wwZrlWLLA7noy0oKOBLHeE+FFNcS9n9e7HWCBT5n
	 CUvq1duMCyZOcbXnafs5Ey7xl2TiLHiwaNlcLu4ytWOqWP3U1+1mqVyNj0xyHWyauY
	 yG6jY0MVtHNU3xMWEQ20WXJu/cb49c8chjEcaVluaeQJMFuZY/Xad9f1O7EgimFDGq
	 wVgV26Rjnc6PXrKLULt2SIWeh6LYQnib+tB0wnKUcfaB9NrtbuE0MJFTczfHaX2Sye
	 gbhz+bpsTDSe5zwEMl1o6hLixKvQOwf5anaiJiLJ+CwY2FszQtJPzUKRy4KL/BOLwH
	 xNYGl5wOw/cVg==
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
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 18/22] xfs: add fs-verity ioctls
Date: Mon, 20 Apr 2026 13:47:05 +0200
Message-ID: <20260420114714.1621982-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
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

