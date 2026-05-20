Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81BA3E3158;
	Wed, 20 May 2026 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280694; cv=none; b=sdwg461B7vkpok4WqSy5TZwUzigCqAymPr69BflnkDZOqNDYICTsnwn3HZ2F4iOxAV2/QSFP3HCOmXoeXWfOj4izSy6S8dRH3aZqpUZAhBmdyMNAigE43WmECND1lrGnkZizlEwmHiELx9njVMHbHdDXeCTPgGWrccKnTKDKwCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280694; c=relaxed/simple;
	bh=OXHDc6p2KY2Ob2ruRnf+AlLCT69XEhND7ctSrARe+30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpxgRrRVgZgx8FCrxGls2Vy9tUJBppyu/+aEIUOCRpy82GP1bChS8BxE9o6zHwmLgcmWAYytpbzdEch69h5EvziVlnR2aTBHR2wRtpVUCeHies4VNykQQ2u38auIclZE8FxYAg+ORz5n9KdRe1SlxGuAt4cJXxtHc4K/mUqkO5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VaxDcVuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VaxDcVuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871CD1F00896;
	Wed, 20 May 2026 12:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280692;
	bh=XyaTEum6ayosvS4JuNWMJtSuDVSnOoX0XTEMccL3PFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaxDcVuzdIy6fM8JDky8Y42v0bXFL0F2l+Tu8XfW+w87gG8SF+Z4bk1EoSQLqexiq
	 6fXL/9VQPhRl74HMSB4Djzxvhz1Y9C4eITK2ogwh7vhd/OJt2zjDH3s5A9+Nvm175l
	 swNQG9TdnF4uOuvi9KgiUSYnoqe5FjlsHbh425OjTtvBrUic2pK3mqUumibdbGpRo+
	 7HoG2WxTjLjNEpaTwDq1sQqpXFUhSunj0c4+iQxxN+3uhDYtzRkU6Jcgyiw1dzrLM1
	 itD7L2f+9PPMT61FtL/eECmJAgjQo3VmcM084xzznJztGRhSDi+6DZVc5hkOJhjDFg
	 rMYgkDrjvjKTg==
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
Subject: [PATCH v10 18/22] xfs: add fs-verity ioctls
Date: Wed, 20 May 2026 14:37:16 +0200
Message-ID: <20260520123722.405752-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
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
index 46e234863644..e7cc64b2b56b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -49,6 +49,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1445,6 +1446,19 @@ xfs_file_ioctl(
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

