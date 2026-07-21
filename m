Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4146D46EF79;
	Tue, 21 Jul 2026 18:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659492; cv=none; b=MG524dygmRPtIqkN1nu0d0kblAZ5lgWeiYnKZLbThUCSuNSt7kozzkrtEmsKHZjke+KrdZlIUkK+heZsb3KnJQPalBwdrH4xb5YFs2oEJl3o7raiAlEGBFNPssMPdmjaeDyIHLEJwFFBkq3g3OrI5IHQyOV/3wMS+o9VR55drP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659492; c=relaxed/simple;
	bh=VelucZJPsab2F5jxEpX3NBOniOMrZ0GVGPAxyUbHahM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O67d1k1Dzba+aUgKJNtd23WWYHP4tGDMWSs5H4YRFMte34WdiFhKqKMcPWF/Tdds5xgrfzGdop8xp6N9BZ54ucR909Y+5uptyG57FK1UksEIwFp4dEnTOO/Q9uoURRjQxmVEiT2KzANDSEqwkCv8ckg00fXkBGM7fM8p1Jw191s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iW7vr4CG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iW7vr4CG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C2F1F00A3A;
	Tue, 21 Jul 2026 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659491;
	bh=dse18FWQSUIoP6yquYEBISwJ2j8wLduiXGfJxJRjVuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iW7vr4CG704dDO1eJ6g5Ch8UJjFWpSsoSFkgoQ+bVXjgo29f3LJf0pLe6wTQjwif4
	 VqSKgGqXPMmotm8lMNpGKsHn5aazwu6ust4ofhSSUOOOoaVLfhsbrNHjW5Saoey6U9
	 d3+X47aJXNtIOUoBfj9BjMR8V4xRD/Cs43OapqxYMaJUQ3RoRwf2W4QcC5OkyNd3Gg
	 yi+e9slNN5vTZUEpjV4/AAe9VVK8wY0p8zUVW+fykjpe660JKD9R4GOh+kf/mYI9xm
	 ym9rfK9/gzmFKOYv/ayqQCM13/x3xixp4p+HIA7URXAeRNpcF1db403+R42BSxaMFG
	 AsvI+AwyXtFmw==
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
Subject: [PATCH v13 19/23] xfs: add fs-verity ioctls
Date: Tue, 21 Jul 2026 20:40:56 +0200
Message-ID: <20260721184346.416657-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
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

