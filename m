Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35AC470EAE
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325221; cv=none; b=u1U0pUx9OAYL6pzexsa7LSELb+GYTVst7BxEI/gB+djTz/YX7P489N1nFOCMqub6l3rxEJdlYyBO0SpVahXBZLNwwcpuY//7m/Aq2c2t9z91+ip1Faw8qy9i5JkLuVwj/9TJG2N8z0hbhHYuAVqfnMpJMcoPzuP55UzDKRAJCV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325221; c=relaxed/simple;
	bh=ugJQTkRaBcXdLBy+03+zfgSSkIS7jWk+KmYRr04dnvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXC4ScxLnRQiYGnJSF7KjaVSPzdWWCz1P/cTsBU6YGy4Gy9r6rNvWBR1o/dC5ScIsWQgxUU+xgjFw7D9ozopKFvq9Lwu2CBLCjhMeIDRL3/xjQtRBa3ky/CaDQaG4HwuBiJBKsbWSpESROateZpcBN/d7VgWwktDzbQEfECdDL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ss6Ujj/B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ss6Ujj/B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L4r6me3X+bFa8aS3T12wICnqa+AHWUuyZsRzu2UJ8Oc=; b=ss6Ujj/BRxgpW18bIxU5iLmPdb
	+rF+tAcfWs+ct9fD2EzRSulkJyZv0lm82QVn+pXtjcgty9v4Y6HMha57LPe6p15ULPKul4NY9+7Tl
	cflgKAahgdzC1nDkZ1981406sive0yafj0j86r6Z05mtxdq6GPRNgXygcWr4lcPwQp2g7CjdSma48
	594KRURI0tgbVb4u3VAHz05kRDVKzzEA6b8M8lYrNA4TW3z7agY409vCCu8AAiCEOXpgyZjtl1Uw/
	+9+VWohRGK+lg+V4TkLyYiZvDIUpH8Lj2meQXky8lifpT+ocxoJAj6ujuQCVflG4TSCyGWRHwJKiF
	PXHt0C5A==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2e2-00000007l4F-3t4Q;
	Wed, 29 Jul 2026 11:40:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/16] xfs: split out the handlers for XFS_IOC_FSGROWFS*
Date: Wed, 29 Jul 2026 13:39:08 +0200
Message-ID: <20260729113952.2255638-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729113952.2255638-1-hch@lst.de>
References: <20260729113952.2255638-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split out helpers for XFS_IOC_FSGROWFS* to keep the stack variables out
of xfs_file_ioctl and to clean up the main ioctl handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 107 ++++++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index eeff0678d5bf..0b5ae79e4aaf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1281,6 +1281,66 @@ xfs_ioc_swapext(
 	return error;
 }
 
+static int
+xfs_ioc_growfs_data(
+	struct file		*file,
+	struct xfs_mount	*mp,
+	void __user		*arg)
+{
+	struct xfs_growfs_data	in;
+	int			error;
+
+	if (copy_from_user(&in, arg, sizeof(in)))
+		return -EFAULT;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_growfs_data(mp, &in);
+	mnt_drop_write_file(file);
+	return error;
+}
+
+static int
+xfs_ioc_growfs_log(
+	struct file		*file,
+	struct xfs_mount	*mp,
+	void  __user		*arg)
+{
+	struct xfs_growfs_log	in;
+	int			error;
+
+	if (copy_from_user(&in, arg, sizeof(in)))
+		return -EFAULT;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_growfs_log(mp, &in);
+	mnt_drop_write_file(file);
+	return error;
+}
+
+static int
+xfs_ioc_growfs_rt(
+	struct file		*file,
+	struct xfs_mount	*mp,
+	void __user		*arg)
+{
+	struct xfs_growfs_rt	in;
+	int			error;
+
+	if (copy_from_user(&in, arg, sizeof(in)))
+		return -EFAULT;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_growfs_rt(mp, &in);
+	mnt_drop_write_file(file);
+	return error;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1390,47 +1450,12 @@ xfs_file_ioctl(
 	case XFS_IOC_GET_RESBLKS:
 		return xfs_ioc_getset_resblocks(filp, cmd, arg);
 
-	case XFS_IOC_FSGROWFSDATA: {
-		struct xfs_growfs_data in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -EFAULT;
-
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_growfs_data(mp, &in);
-		mnt_drop_write_file(filp);
-		return error;
-	}
-
-	case XFS_IOC_FSGROWFSLOG: {
-		struct xfs_growfs_log in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -EFAULT;
-
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_growfs_log(mp, &in);
-		mnt_drop_write_file(filp);
-		return error;
-	}
-
-	case XFS_IOC_FSGROWFSRT: {
-		xfs_growfs_rt_t in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -EFAULT;
-
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_growfs_rt(mp, &in);
-		mnt_drop_write_file(filp);
-		return error;
-	}
+	case XFS_IOC_FSGROWFSDATA:
+		return xfs_ioc_growfs_data(filp, mp, arg);
+	case XFS_IOC_FSGROWFSLOG:
+		return xfs_ioc_growfs_log(filp, mp, arg);
+	case XFS_IOC_FSGROWFSRT:
+		return xfs_ioc_growfs_rt(filp, mp, arg);
 
 	case XFS_IOC_GOINGDOWN: {
 		uint32_t in;
-- 
2.53.0

