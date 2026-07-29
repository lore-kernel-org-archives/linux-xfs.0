Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3A3485CEB
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330216; cv=none; b=rk6LcAqhbeDNhXiatkN+EZmcRuLZe3/OqmgtWOsUSSXn8OqnyAS1nvcCInZn3tdgj2CQP4HinjOhiccEqGLoVehiGijkZt9WUo1X7C1ovV9oNOXTA8H5smnlOM+WfINQJdJMhh276OCssvkrSh3XhOJTJ6CkYnJlHJqQK0GMGsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330216; c=relaxed/simple;
	bh=wIbO2l1D7QUXIuI9R4V3vrSMJzrwn5q+GxydwcVjgY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOuB2asw4csT/xt1SwU6uiZ2wIxsTdMMdKx+1XbkD/yb0Ex7UINXizfGrEcN+oI8bZ/uFXKy9Xx8Ge9ZQyTcHRldlYLomULdMWvE/XkfdcS+oeM9WEZi0mOQzUqkdfPt10UO9c3B6XlIWmbSXajf3U8tsqtan/zgXdi2eSbKQeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CzQGhC/j; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CzQGhC/j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=SsBlSb2VAQ47+gTk/tt0snER4/QNXhVteb5yhrSS1kk=; b=CzQGhC/jvhZuIMNWtQDe98kAY1
	8vurh7y1WVIJDIHOIBN3wfZ8tr3XSrUaXyMeujfDeOhEvr4nOQ20w9vPwim4PSz7+H7qlmJfbqnJF
	Mj/8+TzQLUYq404aTpwEUPbKcBewP9IdwRqvKDZ1koUEvfoehsMTLPpIy3YdM1kuN/8m9HoPd4ZH+
	r2niH4d3YLSp3Qyk0zP+pnIK+2awbwF9jECUTT0XM5DxdqA0TS8vJFay22zNihtW0aAH/+jTVt3Bm
	qffSXputmhIYskqXGsZ4IFk9ubSjQJM/lSdyiQBCjL6V+IEEnKUGP6qO/tinOIKeNlc0kOHQYHZoQ
	yeFzLomA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wZ-00000004Wl3-32Cc;
	Wed, 29 Jul 2026 13:03:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/16] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
Date: Wed, 29 Jul 2026 15:03:11 +0200
Message-ID: <20260729130320.2282183-13-hch@lst.de>
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

Split out helpers for XFS_IOC_FSGROWFS_*_32 to keep the stack variables
out of xfs_file_compat_ioctl and to clean up the main compat ioctl
handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 76 ++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 250df2bbf214..2162eda01743 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -44,26 +44,46 @@ xfs_compat_ioc_fsgeometry_v1(
 	return 0;
 }
 
-STATIC int
-xfs_compat_growfs_data_copyin(
-	struct xfs_growfs_data	 *in,
-	compat_xfs_growfs_data_t __user *arg32)
+static int
+xfs_compat_ioc_growfs_data(
+	struct file		*file,
+	struct xfs_mount	*mp,
+	struct compat_xfs_growfs_data __user *arg32)
 {
-	if (get_user(in->newblocks, &arg32->newblocks) ||
-	    get_user(in->imaxpct,   &arg32->imaxpct))
+	struct xfs_growfs_data	in = { };
+	int			error;
+
+	if (get_user(in.newblocks, &arg32->newblocks) ||
+	    get_user(in.imaxpct, &arg32->imaxpct))
 		return -EFAULT;
-	return 0;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_growfs_data(mp, &in);
+	mnt_drop_write_file(file);
+	return error;
 }
 
-STATIC int
-xfs_compat_growfs_rt_copyin(
-	struct xfs_growfs_rt	 *in,
-	compat_xfs_growfs_rt_t	__user *arg32)
+static int
+xfs_compat_ioc_growfs_rt(
+	struct file		*file,
+	struct xfs_mount	*mp,
+	struct compat_xfs_growfs_rt __user *arg32)
 {
-	if (get_user(in->newblocks, &arg32->newblocks) ||
-	    get_user(in->extsize,   &arg32->extsize))
+	struct xfs_growfs_rt	in = {};
+	int			error;
+
+	if (get_user(in.newblocks, &arg32->newblocks) ||
+	    get_user(in.extsize, &arg32->extsize))
 		return -EFAULT;
-	return 0;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_growfs_rt(mp, &in);
+	mnt_drop_write_file(file);
+	return error;
 }
 
 STATIC int
@@ -434,30 +454,10 @@ xfs_file_compat_ioctl(
 #if defined(BROKEN_X86_ALIGNMENT)
 	case XFS_IOC_FSGEOMETRY_V1_32:
 		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
-	case XFS_IOC_FSGROWFSDATA_32: {
-		struct xfs_growfs_data	in;
-
-		if (xfs_compat_growfs_data_copyin(&in, arg))
-			return -EFAULT;
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_growfs_data(ip->i_mount, &in);
-		mnt_drop_write_file(filp);
-		return error;
-	}
-	case XFS_IOC_FSGROWFSRT_32: {
-		struct xfs_growfs_rt	in;
-
-		if (xfs_compat_growfs_rt_copyin(&in, arg))
-			return -EFAULT;
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_growfs_rt(ip->i_mount, &in);
-		mnt_drop_write_file(filp);
-		return error;
-	}
+	case XFS_IOC_FSGROWFSDATA_32:
+		return xfs_compat_ioc_growfs_data(filp, ip->i_mount, arg);
+	case XFS_IOC_FSGROWFSRT_32:
+		return xfs_compat_ioc_growfs_rt(filp, ip->i_mount, arg);
 #endif
 	/* long changes size, but xfs only copiese out 32 bits */
 	case XFS_IOC_GETVERSION_32:
-- 
2.53.0

