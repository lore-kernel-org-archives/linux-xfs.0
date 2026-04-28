Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51113D410C;
	Tue, 28 Apr 2026 08:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365288; cv=none; b=qRIOOtoX+rzELSBIFFR0DfSmjWo7BACTVx3ZpsJQ2tHEEpKfI6ySEbcyJSv7yqkhCwwgiVg9gRwMW23GaUGFVBIYBt9TTH5AoHElIFBsWIQX/HVDykQIdjRgLpUa42sPXxJznUC3Hm1YrtW4FvH5ssX5XnJtN/ASnM5GCoynONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365288; c=relaxed/simple;
	bh=Aq0ZUSqSUefcts6LfugDkZmOSMW+4m4ueZMlzDmeXr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jd2G53HF+mw+/W4NU23H9lsi34iK/xmz6UoDpI7cfpkaZZKgqyvunkvhMyMYQClxkak1uUzfzo0RmpkCd2zEokhhdA7K5dhS7w/QnmU0O0ytwcnzLjsYUw540epiu7HpSxvotTVf0T86s0gMLQ/kR73aPUtBo5r9+5bX+v8UlZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IprwRXJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IprwRXJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47857C4AF0C;
	Tue, 28 Apr 2026 08:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365288;
	bh=Aq0ZUSqSUefcts6LfugDkZmOSMW+4m4ueZMlzDmeXr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IprwRXJCWRo55iClilMfq2t3DPMoB2rvZ3Fzl0J+HO6tOVe19cTJxslCXwj4MqxKF
	 yuQEhDLqK5hmKf86In0+zG5J/5gkdOCa/IlHep/aFi0MbJoa2rsezYxGz0IHkmr3Tr
	 iPlrV35uLHTdczcCJmwx69CNVekNRBKZInEXq+8tPTpCvb69VlkFvgjP3KEcTtA5v0
	 /ywciA+bjYE8LKf07iwoJ0gm2hYE3B8kMDASbd0pi+zVjOjYG7+fr3nwTVBCQ/lRWV
	 N9/SBo/0UjxNy7ytKqnWDFdEaNhm23TiluKY9nIKNyJDXKh0qN1DUw2XXphGL3Fn7F
	 M9XMxixyDor1w==
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
Subject: [PATCH v9 18/22] xfs: add fs-verity ioctls
Date: Tue, 28 Apr 2026 10:33:24 +0200
Message-ID: <20260428083332.768693-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260428083332.768693-1-aalbersh@kernel.org>
References: <20260428083332.768693-1-aalbersh@kernel.org>
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

