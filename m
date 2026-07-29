Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBF7488D91
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330210; cv=none; b=HPeNA6Oby67jyDIRARIamZ7AR5dyB7ag7Co2/9TPmyOOXJ85LbilnF75KZIk7hWoT32Ik4jAENJeTC6SqAHkhsaIi6aPQyQZb5CHAnkZUUr+Moeug1rZkO+pewVbTbc+EN9SzAjWd4uiimoZpy797azbFc/7KYmz4Oz55vrH/S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330210; c=relaxed/simple;
	bh=oLlr44ZO0H2CUYxBfKnzY30OFHSpJLff+V2LDRwZ1gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXtvPK9Dt56JsCfQCTLO2PSMyaSaOA22ttKeDaK8TUtbKr4tkGJiqJI8zoL8D7LxjY9clozkq58+KoHDBe+cZ6/mbCIvgXwXZ5LmmqwMQkKJpdexoHM93BlRYmN4uBgF55E+e3pLzwVk9k3xtfSXwyTDgN7+5oGLkzItLvFjxto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nX2l+E/E; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nX2l+E/E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=y68Q375xk4k3d8M1i7aXx9JF5fB4UjsVZHFz/tyGpb0=; b=nX2l+E/EGGihrPEBluHvNtgawY
	3W9PCXW2IYXO5XCkDs5A6rMy2cPe3PC5tAJc3mE2loUK7DMFfcAqgXIekn1saYfhWwMpfvQpbCelf
	BNnPOvXpccqPtNx+RQHY0hbSxN+fiLWcjMB8McFGmpRDU5zaBlKZWjvC5lnugrlq02a2qMAyMomZ2
	hUGT+7xL6lHPcTytMh7H17GIJuRE2fOBe9Juqou+Z9/6rEI5IZSkTexNiSv00F+0BiBzcVwgbr/0/
	V+Kr7l1diL3jSDZ28orXbOCkcuDqj8amA0eLYz2uV4zr4VCQqcTB6fWdlvyeSBkhA7tQ8RBKGq8GE
	XiMhgsxg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wU-00000004WkC-2Ffr;
	Wed, 29 Jul 2026 13:03:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/16] xfs: split out the handlers for XFS_IOC_.*HANDLE
Date: Wed, 29 Jul 2026 15:03:05 +0200
Message-ID: <20260729130320.2282183-7-hch@lst.de>
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

Split out helpers for XFS_IOC_.*HANDLE to keep the stack variables out of
xfs_file_ioctl and to clean up the main ioctl handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 65 ++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2924d8d0f03f..6a7c570ea535 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1226,6 +1226,42 @@ xfs_ioc_dioinfo(
 	return 0;
 }
 
+static int
+xfs_ioc_find_handle(
+	unsigned int		cmd,
+	void __user		*arg)
+{
+	struct xfs_fsop_handlereq hreq;
+
+	if (copy_from_user(&hreq, arg, sizeof(hreq)))
+		return -EFAULT;
+	return xfs_find_handle(cmd, &hreq);
+}
+
+static int
+xfs_ioc_open_by_handle(
+	struct file		*file,
+	void __user		*arg)
+{
+	struct xfs_fsop_handlereq hreq;
+
+	if (copy_from_user(&hreq, arg, sizeof(hreq)))
+		return -EFAULT;
+	return xfs_open_by_handle(file, &hreq);
+}
+
+static int
+xfs_ioc_readlink_by_handle(
+	struct file		*file,
+	void __user		*arg)
+{
+	struct xfs_fsop_handlereq hreq;
+
+	if (copy_from_user(&hreq, arg, sizeof(hreq)))
+		return -EFAULT;
+	return xfs_readlink_by_handle(file, &hreq);
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1314,31 +1350,14 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
-	case XFS_IOC_PATH_TO_FSHANDLE: {
-		xfs_fsop_handlereq_t	hreq;
-
-		if (copy_from_user(&hreq, arg, sizeof(hreq)))
-			return -EFAULT;
-		return xfs_find_handle(cmd, &hreq);
-	}
-	case XFS_IOC_OPEN_BY_HANDLE: {
-		xfs_fsop_handlereq_t	hreq;
-
-		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
-			return -EFAULT;
-		return xfs_open_by_handle(filp, &hreq);
-	}
-
-	case XFS_IOC_READLINK_BY_HANDLE: {
-		xfs_fsop_handlereq_t	hreq;
-
-		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
-			return -EFAULT;
-		return xfs_readlink_by_handle(filp, &hreq);
-	}
+	case XFS_IOC_PATH_TO_FSHANDLE:
+		return xfs_ioc_find_handle(cmd, arg);
+	case XFS_IOC_OPEN_BY_HANDLE:
+		return xfs_ioc_open_by_handle(filp, arg);
+	case XFS_IOC_READLINK_BY_HANDLE:
+		return xfs_ioc_readlink_by_handle(filp, arg);
 	case XFS_IOC_ATTRLIST_BY_HANDLE:
 		return xfs_attrlist_by_handle(filp, arg);
-
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
 		return xfs_attrmulti_by_handle(filp, arg);
 
-- 
2.53.0

