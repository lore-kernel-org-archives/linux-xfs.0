Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743474446E6
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325212; cv=none; b=bPsXy/+K7glw1Naqpl6faAlU7AU/+6ICI1M9+qUGl+Iz20ktC6NQEGqrMVQIRqf2b2e8V7nGBmakD5iJ2J6uxRWiP1v7MLpYXgEdPewqVZMB+4PTxt2R7ZpAJSoVqcRMgwUrf/NuE5bOKZZlRh1Z3DFSe+J7tmf8I0WNKze7HM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325212; c=relaxed/simple;
	bh=hyuSnHvlFDG9ZVD4+oLOPAmcakhek/HH1tLxtrkcCgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0UsB6PavtCYO+LVhTMpLuDaKmVvuvBaqIxQMnoQJhz/7PrD74bN+zPFefz7aXfLRGc9C0O0egF/9KlEzZXQBIIGhCaiVgZ0DswXTzm+npY++48mWHI/9BJWkZrHng3E4vN4MGKVwKU6AAh8Nsxm2I0NdvvD+zxEd9kNnin69zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lpiam94d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lpiam94d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9EVlyWBPKdGSSP/FLSwkDzxiYPoXwyH6kuqKMwbF7uk=; b=lpiam94dZR9SFDm/EI1wTahD+o
	FOLb2BZphBmPyj+qcYfDKfOVjAe7mc7uxTsXDGtHJpxzb85Fv4uM6tfVdUYFl4OrTx/hklraXQtdv
	6hW/7cd15bKpPV6ArRy6iG5Id5tT0JWHY6mrrULLyG/JSPQ/839n2hGB9Av0W/kQAgoNVVwXdYbXu
	pbNyPiDw6hbs+NzXfA+rvKijfKGlB+mvsvvYT6X5/h/b+uDsC7xeiLekESkZrAnOr5DKOx77OFH8G
	7Diiq7oBM6pTuOU8eO8dPZGJDj1tk4GhbT4Im2L+3CG6HW0LPFFw+loz8H6CNPbPXbNAypcHSeAve
	fV6xjxKg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2dt-00000007l2P-3QCF;
	Wed, 29 Jul 2026 11:40:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/16] xfs: split out the handler for XFS_IOC_DIOINFO
Date: Wed, 29 Jul 2026 13:39:05 +0200
Message-ID: <20260729113952.2255638-6-hch@lst.de>
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

