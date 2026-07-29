Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE176486BB2
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330219; cv=none; b=re2xXFzJzoi/TQvN1YL3fwuWl0hw+upSahQEt04savF/Rlyve0bfjnhvC14m8bEMkasbHFI74IYt/kiwA2OsOevhUbpyeLYpatHnoksgkCwa+wkzuYoiNaaeYiGZykmHQuXcvTdO3QlbT+tb+XP9FDc6Oui605dcsYc7Spff/F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330219; c=relaxed/simple;
	bh=mSKHcBQPKpW8RTki4J3NO20S/elEkJbt0Pi2U984sPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5lva0bMjx9f7z/qRDPUH4PcupTedr5kqyTm93RrSiTIY/hcZVCZTY7/9BCWRVCDfBLBTX5zZ+IJaAAk358p6o54dXpYFibpWl3wv44+wVoIhNP4FgLYYTGhuvMTTeAAKMWccORxVKuYUH7T1fB4YnLNTkAGtK+Dq+Hni5kBA3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UR6cR2ux; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UR6cR2ux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xjeV5Dtf+fEsajxpwcYUgZFWkkatQD2eLCKiLFYoF5E=; b=UR6cR2uxe1XY2fZmJ3vHRvojvt
	lP7uWAsBNtbxgTdE3uALwjo80S1ORzA6vJdrdBg5MunK4k3ViuPJfD4aJj8p8maXzRo+RJAo73+zy
	uOA65VPuNyQQOEp68xSllA2sora3xBs9pP5iilXIlhBAmjjJhcT2Mj8TRdM2gD+BcJ89XNIoVseGJ
	gizfFRpv6e+gBo0zlAoxREvXR2tHot5QEC0tgSKS/aKec6S7pgpOCY5TCSQR4RPW0aMXncT5ZvG3x
	Bg7pZEtRTt/AwwiVh6Xb7Ml0rasgsOtJ7GbLN/Z1EF3I1aCXh9M24j4aYujkAFyi6KdtrKXxsyaqA
	onVz+uEQ==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wb-00000004WlU-1j3V;
	Wed, 29 Jul 2026 13:03:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/16] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
Date: Wed, 29 Jul 2026 15:03:13 +0200
Message-ID: <20260729130320.2282183-15-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729130320.2282183-1-hch@lst.de>
References: <20260729130320.2282183-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Split out a helper for XFS_IOC_SWAPEXT_32 to keep the stack variables out
of xfs_file_compat_ioctl and to clean up the main compat ioctl handler
flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index ede890d4cbc3..a6e3b35db6e2 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -158,6 +158,27 @@ xfs_ioctl32_bstat_copyin(
 	return 0;
 }
 
+static int
+xfs_compat_ioc_swapext(
+	struct file		*file,
+	struct compat_xfs_swapext __user *sxu)
+{
+	struct xfs_swapext	  sxp;
+	int			error;
+
+	/* Bulk copy in up to the sx_stat field, then copy bstat */
+	if (copy_from_user(&sxp, sxu, offsetof(struct xfs_swapext, sx_stat)) ||
+	    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
+		return -EFAULT;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_swapext(&sxp);
+	mnt_drop_write_file(file);
+	return error;
+}
+
 /* XFS_IOC_FSBULKSTAT and friends */
 
 STATIC int
@@ -446,7 +467,6 @@ xfs_file_compat_ioctl(
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
 	void			__user *arg = compat_ptr(p);
-	int			error;
 
 	trace_xfs_file_compat_ioctl(ip);
 
@@ -462,22 +482,8 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GETVERSION_32:
 		/* long changes size, but xfs only copies out 32 bits */
 		return xfs_file_ioctl(filp, _NATIVE_IOC(cmd, long), p);
-	case XFS_IOC_SWAPEXT_32: {
-		struct xfs_swapext	  sxp;
-		struct compat_xfs_swapext __user *sxu = arg;
-
-		/* Bulk copy in up to the sx_stat field, then copy bstat */
-		if (copy_from_user(&sxp, sxu,
-				   offsetof(struct xfs_swapext, sx_stat)) ||
-		    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
-			return -EFAULT;
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_swapext(&sxp);
-		mnt_drop_write_file(filp);
-		return error;
-	}
+	case XFS_IOC_SWAPEXT_32:
+		return xfs_compat_ioc_swapext(filp, arg);
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
-- 
2.53.0

