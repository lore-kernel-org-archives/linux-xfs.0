Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D8829AB1A
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325214; cv=none; b=BaREcKznRTNVlvOpLZoY9u6s5SAW2ihVJOoP9RGBVE83egq8fYmuw9D6UTEs5UHUcmWeL/XtJyvMxti2S43tG0eVrI/8x83uf2GR5sTTvUnONp9COSjG6oAxcKdLsWmDhNsJQfsFWwyZwRzBLd8gjfduCgUj/MjTRt4BIW9KSYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325214; c=relaxed/simple;
	bh=oLlr44ZO0H2CUYxBfKnzY30OFHSpJLff+V2LDRwZ1gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzmMy3OlemwCCInH5FJrnhzFGlqja32HbZoMVZwMCzV/ZsD4tR1uHT3QCWg+lMDDweZ8jpTN9CEuB1I5iYzy/JOlBD7LrbiUl4BMivQ1VzAYiEZ5P7xeTALZttZL3fOUn6aKh4ICdoDaX2AqOB63QA4iZsK2xHz1maTS7s1dvx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1IwwYG94; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1IwwYG94"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=y68Q375xk4k3d8M1i7aXx9JF5fB4UjsVZHFz/tyGpb0=; b=1IwwYG94bpJLLc8tpXOPKzq6DZ
	TCNVvv+MDguRKkinlxDqHP3N7fDJBV+nfTNE/++Bz32KlEvoZFqdWjzSJqGtlOJG6gA6dTAg8shMD
	bv7yWPFaq5x+rI3vKcswta6291hXWjur1Vsqp52Lob1Pvv3J1iiR0McsxibJokBaaxIpwLFYxRnOo
	uccQz0Plr6RziBCOzYW8uKrTRMfg1nSvo3K10DvCNW2Uu4ChtcYdG1hDR9JvDi250zVOG8WLoModm
	ExG86xnkZGQtgjvQjaphG+ozod0qd/xEg+7QwwjDd/vaqEsX188jfWbuV/hJ9kXDgfo7i7uBXYwu6
	uyYmvcBQ==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2dw-00000007l2y-32hA;
	Wed, 29 Jul 2026 11:40:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/16] xfs: split out the handlers for XFS_IOC_.*HANDLE
Date: Wed, 29 Jul 2026 13:39:06 +0200
Message-ID: <20260729113952.2255638-7-hch@lst.de>
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

