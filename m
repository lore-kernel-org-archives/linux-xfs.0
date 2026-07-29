Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ACD48877C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330211; cv=none; b=LPr9KWRzgrV2M+G3S+NKOxtJGtnS7XDlhB+yqDvTA/u/efl2F+rRIC32j6e/BoTuYWkA50KnFXyMu4vIjXQKDbAIZIqYj9Z4bpZRMX68ioDRxKEygPEyOGPqHthDpzo6pfD//jjjA5jxVp+5Np67f7igIAVdRUCN8iPaBuC3MEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330211; c=relaxed/simple;
	bh=hyuSnHvlFDG9ZVD4+oLOPAmcakhek/HH1tLxtrkcCgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klsGyLkhPR005WiSKlyoYKIO/AQhjdWJk+gDhKa9UrZRwKHqHh5fXnmpJmDh0VXySrPoCyUGf8IA0IFoHjliujfdfqlRZh3HM4ZxF1sYzbHMfrzdw3sLdz23wJEBn+MKIJbvf6pKDYlAZt0blPFfM64E8VVWajV303BY66ttKeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SjS3PtpO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SjS3PtpO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=9EVlyWBPKdGSSP/FLSwkDzxiYPoXwyH6kuqKMwbF7uk=; b=SjS3PtpOmWol5qRChf728nsLVn
	8aKNmmA21xp+cyVkwUtbM8SQrLGDk23rqFCxlb+SiNc/i11hnjIGRF4LfdwbPhvsJoNz3/JlkaRgr
	zcT93jxhOSl5YSV/SuWVXaKElhXld+jAWKbL7j3/UaFoitRjRPHLSqxU/ysr6WG6kj45spYQvBKOG
	tlH3O9YJbzA2MXzLdlv1ZU7uAUUqvQ+K+ErYIeaTYdsatxWoAxoYn1zOkm45d5uTCOK4foeZRC5oh
	UExCViEW/+KA24P4FrlGCaPOMOa0N4kqSYv00NUvOXQqSVwEPI7RYgbyne+WPoSF1iWaCc54xVPnS
	c9CyxDKQ==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wT-00000004Wjp-1vl5;
	Wed, 29 Jul 2026 13:03:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/16] xfs: split out the handler for XFS_IOC_DIOINFO
Date: Wed, 29 Jul 2026 15:03:04 +0200
Message-ID: <20260729130320.2282183-6-hch@lst.de>
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

Split out a helper for XFS_IOC_DIOINFO to keep the stack variables out of
xfs_file_ioctl and to clean up the main ioctl handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 47 +++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9d8ef646e0f8..2924d8d0f03f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1200,6 +1200,32 @@ xfs_ioc_fs_counts(
 	return 0;
 }
 
+static int
+xfs_ioc_dioinfo(
+	struct file		*file,
+	void __user		*arg)
+{
+	struct kstat		st;
+	struct dioattr		da;
+	int			error;
+
+	error = vfs_getattr(&file->f_path, &st, STATX_DIOALIGN, 0);
+	if (error)
+		return error;
+
+	/*
+	 * Some userspace directly feeds the return value to posix_memalign,
+	 * which fails for values that are smaller than the pointer size.
+	 * Round up the value to not break userspace.
+	 */
+	da.d_mem = roundup(st.dio_mem_align, sizeof(void *));
+	da.d_miniosz = st.dio_offset_align;
+	da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
+	if (copy_to_user(arg, &da, sizeof(da)))
+		return -EFAULT;
+	return 0;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1238,26 +1264,9 @@ xfs_file_ioctl(
 	"%s should use fallocate; XFS_IOC_{ALLOC,FREE}SP ioctl unsupported",
 				current->comm);
 		return -ENOTTY;
-	case XFS_IOC_DIOINFO: {
-		struct kstat		st;
-		struct dioattr		da;
-
-		error = vfs_getattr(&filp->f_path, &st, STATX_DIOALIGN, 0);
-		if (error)
-			return error;
 
-		/*
-		 * Some userspace directly feeds the return value to
-		 * posix_memalign, which fails for values that are smaller than
-		 * the pointer size.  Round up the value to not break userspace.
-		 */
-		da.d_mem = roundup(st.dio_mem_align, sizeof(void *));
-		da.d_miniosz = st.dio_offset_align;
-		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
-		if (copy_to_user(arg, &da, sizeof(da)))
-			return -EFAULT;
-		return 0;
-	}
+	case XFS_IOC_DIOINFO:
+		return xfs_ioc_dioinfo(filp, arg);
 
 	case XFS_IOC_FSBULKSTAT_SINGLE:
 	case XFS_IOC_FSBULKSTAT:
-- 
2.53.0

