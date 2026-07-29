Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070C547ACED
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330219; cv=none; b=GfxbL7r0or9WUPhsUTFDgCcEXYlp75IASwHeqXHtj8NdwrukdYv778s3xlbd73I3kv/xmrsaOFnyBPG8koBXpaTjzHedOi9A0W53VdM34tyj6mYuzDctB+t1w4XvNjyfPItv70IzdSvSJqYu7YzV989Tx82mAx1yDW/I6qrQXEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330219; c=relaxed/simple;
	bh=I7l6POzJM5c5RlbbKeUQBKFw5v9bOdF9BR/PykxyFeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUDEoIs/hjn/7HLA0e/6z0xw96CiarQUpDCU2JJQyMea1fDlyykYFSx4xfDFrzR6A1gJkn40GbbfSKBw/JiXBXRIjZzu/SyLiWsUWi0lH4HgR1b9VDLf1HnkIgxd6KH6OIu0udS7AQETRsGKdTr2EGrEoHOAtxS+XFFDVk6+I04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MXzfh07m; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MXzfh07m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=r39LbRFdKpWh4J+WaluFYvveQnn5VGztSVxzz6v+2Bo=; b=MXzfh07m531ZXNj5WdH0t6fGCI
	PVk1k3TKjBZVu0hq5S1MWzxEb+DURXfqmDcCryLLsQimh4URpU1ytk27tqqCk74AczRZRlxWSeXIq
	CGjtSM5R0ELk+LfsvFi4KFC8cIsSvfgENlw+M4bXA7UAeaqePeUG47vbTCM4vFzlExf1/MxWzuSr+
	TmCXBIv93SZ7Ej5kwOTF9yIpIKjKfQhaAazn3Ein7/XA0LQrGDiS5WWmLQnVwbK0LF2HQfnsvJbdn
	YDsl9sNwbsn1oBbU06iZ5SMY+HZcSiKVk7V6EaPXGvAoiu/1GS1KxVbapenP91vn3LPMMfO2540O4
	EPkvyFHA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wc-00000004Wlf-2Iiq;
	Wed, 29 Jul 2026 13:03:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
Date: Wed, 29 Jul 2026 15:03:14 +0200
Message-ID: <20260729130320.2282183-16-hch@lst.de>
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

Split out helpers for XFS_IOC_*_BY_HANDLE_32 to keep the stack variables
out of xfs_file_compat_ioctl and to clean up the main compat ioctl
handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 65 +++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index a6e3b35db6e2..688eb3300495 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -379,6 +379,43 @@ xfs_compat_handlereq_to_dentry(
 			compat_ptr(hreq->ihandle), hreq->ihandlen);
 }
 
+static int
+xfs_compat_ioc_find_handle(
+	unsigned int		cmd,
+	void __user		*arg)
+{
+	struct xfs_fsop_handlereq hreq;
+
+	if (xfs_compat_handlereq_copyin(&hreq, arg))
+		return -EFAULT;
+	return xfs_find_handle(_NATIVE_IOC(cmd, struct xfs_fsop_handlereq),
+			&hreq);
+}
+
+static int
+xfs_compat_ioc_open_by_handle(
+	struct file		*file,
+	void __user		*arg)
+{
+	struct xfs_fsop_handlereq hreq;
+
+	if (xfs_compat_handlereq_copyin(&hreq, arg))
+		return -EFAULT;
+	return xfs_open_by_handle(file, &hreq);
+}
+
+static int
+xfs_compat_ioc_readlink_by_handle(
+	struct file		*file,
+	void __user		*arg)
+{
+	struct xfs_fsop_handlereq hreq;
+
+	if (xfs_compat_handlereq_copyin(&hreq, arg))
+		return -EFAULT;
+	return xfs_readlink_by_handle(file, &hreq);
+}
+
 STATIC int
 xfs_compat_attrlist_by_handle(
 	struct file		*parfilp,
@@ -490,28 +527,12 @@ xfs_file_compat_ioctl(
 		return xfs_compat_ioc_fsbulkstat(filp, cmd, arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
-	case XFS_IOC_PATH_TO_FSHANDLE_32: {
-		struct xfs_fsop_handlereq	hreq;
-
-		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -EFAULT;
-		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
-		return xfs_find_handle(cmd, &hreq);
-	}
-	case XFS_IOC_OPEN_BY_HANDLE_32: {
-		struct xfs_fsop_handlereq	hreq;
-
-		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -EFAULT;
-		return xfs_open_by_handle(filp, &hreq);
-	}
-	case XFS_IOC_READLINK_BY_HANDLE_32: {
-		struct xfs_fsop_handlereq	hreq;
-
-		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -EFAULT;
-		return xfs_readlink_by_handle(filp, &hreq);
-	}
+	case XFS_IOC_PATH_TO_FSHANDLE_32:
+		return xfs_compat_ioc_find_handle(cmd, arg);
+	case XFS_IOC_OPEN_BY_HANDLE_32:
+		return xfs_compat_ioc_open_by_handle(filp, arg);
+	case XFS_IOC_READLINK_BY_HANDLE_32:
+		return xfs_compat_ioc_readlink_by_handle(filp, arg);
 	case XFS_IOC_ATTRLIST_BY_HANDLE_32:
 		return xfs_compat_attrlist_by_handle(filp, arg);
 	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
-- 
2.53.0

