Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4BE477289
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325219; cv=none; b=GlsspR5i5O2BMI4vPFbKvyVxFCaxRrOLg/7mySx4IPf8AMLVpmq2MJqBPQcs8/38+bJm+isrwXQYQUvKswhxenn1Rfa5EEDCgXJ+INWic2aoB7I7VNMbtAmE7Sv6r/6Cpkeec2CRWPqXCEGMYWsn4DcnqVDWgupEJ74R7KyVj2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325219; c=relaxed/simple;
	bh=9ECNl3sWm7M5ZhzBIX/V9ZGyOla31wn5gGKQ51oMYWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfP9SAmi37mMmCLCvxB8rVgXFEu8Bp74Mr7JLkvQMDgc3bq1DNdir6MZN7agd4uno6eHJZK3naKE7IuQsXmAd462CttrVWJljL3Ijkc2Ri+I2oZefkxK5PbMn5Ec8Xqu0sf1JfkvhfH7AKyoSCvQZocGQ2T5gXHOJptyhx3bYqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=utW62dT3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="utW62dT3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gXY3Uc47jHnIxrFJAOm8GI3GTUhTIDWV2QrBQbihg6Q=; b=utW62dT3rIoP+QG/iBolBAu9La
	mrAgtR25TVnQSdSjWye7KxpzZJ8vNxnXl9Y1M3yhevR+gFcfhJH9IGtPb6P4v78Qh0GowKi7eeIEH
	IJzt7//ClcZRW6iKcGOt2DVmwH8onqdqVjGVmMJPNuinV0Ute8+VKL3Lap4Oy2lhTBc1a8cE8ikfl
	mF4jjKTEB5UaWKOhJyfVeV+Ji+Pkc1iXHRIadns41L6GhPO7tsrq/hMI7cJ2JoCvvrW0e6DG7BNcM
	Zcw/BiOuCCHWKsdBjIT7bji0zRrC38wujMAThm4O0bA4GWP2OkuzNzMqgfc0u6O2PCPCS1xurrkQ/
	pt4aM7pw==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2dz-00000007l3i-46jy;
	Wed, 29 Jul 2026 11:40:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/16] xfs: split out the handler for XFS_IOC_SWAPEXT
Date: Wed, 29 Jul 2026 13:39:07 +0200
Message-ID: <20260729113952.2255638-8-hch@lst.de>
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

Split out a helper for XFS_IOC_SWAPEXT to keep the stack variables out of
xfs_file_ioctl and to clean up the main ioctl handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6a7c570ea535..eeff0678d5bf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1262,6 +1262,25 @@ xfs_ioc_readlink_by_handle(
 	return xfs_readlink_by_handle(file, &hreq);
 }
 
+static int
+xfs_ioc_swapext(
+	struct file		*file,
+	void __user		*arg)
+{
+	struct xfs_swapext	sxp;
+	int			error;
+
+	if (copy_from_user(&sxp, arg, sizeof(sxp)))
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
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1361,18 +1380,8 @@ xfs_file_ioctl(
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
 		return xfs_attrmulti_by_handle(filp, arg);
 
-	case XFS_IOC_SWAPEXT: {
-		struct xfs_swapext	sxp;
-
-		if (copy_from_user(&sxp, arg, sizeof(xfs_swapext_t)))
-			return -EFAULT;
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_swapext(&sxp);
-		mnt_drop_write_file(filp);
-		return error;
-	}
+	case XFS_IOC_SWAPEXT:
+		return xfs_ioc_swapext(filp, arg);
 
 	case XFS_IOC_FSCOUNTS:
 		return xfs_ioc_fs_counts(mp, arg);
-- 
2.53.0

