Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050DA3F6C48;
	Fri, 10 Jul 2026 08:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673653; cv=none; b=JzdFQFhqKlu9Rq/3952qa8Ioz5TV71iFnW/1fOmLZ0hn5J61c9jE5rSEUJp5I5uyAsAj7maKuycRSTp9ZomdtveMJKJyLR/ODKf2u2/qb491Y/HE/GTgVeXvXiJolpmokkpgrkB2j4JI2sV2U2rQkS3FitY0Hj2GzeVowrKFSR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673653; c=relaxed/simple;
	bh=VelucZJPsab2F5jxEpX3NBOniOMrZ0GVGPAxyUbHahM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrYwIVFjRq++F+gy5RwDUN/OFpqhGfvlwWpoU0NnGie5df55v+x40jBWwfUUCRfE75WpJlM76E6RYQEd2VZ4Zt2nOIi6/hJ6NfsecwXWsgVY/M5yu2yQdTKK/3ablUT1ktfO4G0UM+vbnuglM1hVt00Uu8bnF+3VogIQw58rxVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhdigcX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhdigcX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7951F000E9;
	Fri, 10 Jul 2026 08:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673651;
	bh=dse18FWQSUIoP6yquYEBISwJ2j8wLduiXGfJxJRjVuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhdigcX65clBi/gdDokeBRhEkUrnfX7/31pH2a8l3l0KFBK1TKGudxMKO6i1iWdXo
	 GfRzD/uV4C4iwAMhVgWI8fsZZhR3BIPeuOAcVfHrq0mZLKaqX95NyBFRqe32JVWRLr
	 2vWT2DDDkq0uId4KXygZ+p1Xr9B9Ic9M1CV7tou1+Ce/Krs6tmI1JRAjsH/vKjBt12
	 H73IHfi8nUxlq3yFcnCv08imTptZqrqeoaKVCDV977akB9YOFIObESun0g14HF677O
	 IlunfQAMqcj7nXDhY+bjozhH8RtKPU8cIlyChyfDwcmFdp7XNTat8ac25YezKSeVyX
	 rggoiCTK+S3hg==
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
Subject: [PATCH v11 16/20] xfs: add fs-verity ioctls
Date: Fri, 10 Jul 2026 10:52:44 +0200
Message-ID: <20260710085256.3464201-17-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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

