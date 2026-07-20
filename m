Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1713D333D;
	Mon, 20 Jul 2026 09:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538346; cv=none; b=orky5EjqnF6WvC6H3mZ8pE0tw2+ihvzlnxPhAYrPb4JLo2VQG1xJSf30pl4zIY7UdqBsE7+x31jtprgFwItHFyKuV2qcZeQn+KOU1itVNubyazyzqNFdSzdqvOmNSQqHQG0TS/XHR2Y99teGqGLrFUnwP7NnV0I0YXdTIQXPLQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538346; c=relaxed/simple;
	bh=VelucZJPsab2F5jxEpX3NBOniOMrZ0GVGPAxyUbHahM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fipPUULRk/+47nb4U4Gtsl8TpQmHXhH5dP4P69nPRo+napYU/sxOm147APptYrrpvPUoTfouGaDB8zDSdI4CBHjG5ZX/BP/WRFCN+kFi6CIZR5ML3QEoaZmn/wIXG+WCTKXbAisg2to/hP+SvIeBc4bDPpDuqf9/jBlmDZpXrGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+SszIlF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+SszIlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929061F00A3A;
	Mon, 20 Jul 2026 09:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538345;
	bh=dse18FWQSUIoP6yquYEBISwJ2j8wLduiXGfJxJRjVuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+SszIlFNTzGW4LOemaLFqrtiMtA+IVGcFPJxVhiaE4sxc/UNc2pdjs49H2nls8rC
	 vm4dU9fpj23dyPoA8lNMsJJ7WblVxyb65XY9h01m1WEhCT2MKjVAbERIaryvJMsAPQ
	 vReJhG7UjnRe/BqVyxyYrBgZ2c2UOF35of2W1UPLdPj373bC5LDHQsHEDSZl4ihskn
	 xM2/odDgElYW9bxIEsL20sV2P0yuMqS70rvaBzjbq2rCUtO0zOm7U/tElKyyxQke4M
	 +LdDtJvA8lUGLXhwuBcNILR8X9Y9VPfRsfPzYuRjmS1MWfDwiSIEIxHcTaoCuTrwDh
	 Vdh8ST9k663TA==
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
Subject: [PATCH v12 17/21] xfs: add fs-verity ioctls
Date: Mon, 20 Jul 2026 11:03:45 +0200
Message-ID: <20260720090410.3487990-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
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

