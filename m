Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2A448A8CA
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330216; cv=none; b=WrjQ+zhdtIGRThSR217U2NAE29P836Q6TWomGP09xsoXVT5aR9CIJZU7B481Olzv0dj9mFRZGaTunDRFEBw+VmXeUttjPRI0eUfDhEkKDaVKhIqN3ypIoK/jpuxwC1VcVbnRaOwvIYU73ybvg8aguZVIYgOUkej1ga1x2+ygCfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330216; c=relaxed/simple;
	bh=P3al4mUrJjVNr7vv0vbo3TEfTD3l5LaBACsecmrVHoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsJaZqov2491pJFf8k8xwxhr2ywA1aCgeSKsdW0hygPFjVzNvi56/l8nAiu0VLi6rmpqzlp0mQG0dJkclQe7zAGdQ7VxRUywup8ClhazplWLN0E00uTg0dp+uMPOiZwgwCy1V8B32dbOvotAU6Kti2K3AQufRLU/QQmjiI4HZyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=guUanVDb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="guUanVDb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HT1g/VFzatvzhRjDHv7+ea6/Fy/ovprkeb+2pQ0sg0c=; b=guUanVDbS5HwOUvPbETE+zpcbT
	yAPf4RcGAzDPWFO7ZfxGnEZmP0PqnBnwNf+veCHWUYeHKu9ybw6qP39manUKX/dej1YhHlUKiJnlc
	3giPywoewl11bb3a7+PTqKHvHVIlLJviT8Vh4JqsGES5o9GVjWxhuBvC3+X38wDfWoupa2FRQdhfG
	UZpsQXfMAYPtsRcqd1EKL4x0h6YZ/K0U47mCjdP/S4d2VEhkcupIKqSkLatJCOMN2fOZ8x8uKdsAd
	orecmdYLJINuzkUK/y1k6IYpAkJH2X7FJAtZKMywKji2ReNotMvCsfIfwoe/U2+gn0rsf6vur9yze
	tPSeyXIw==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wY-00000004Wks-3aRt;
	Wed, 29 Jul 2026 13:03:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/16] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
Date: Wed, 29 Jul 2026 15:03:10 +0200
Message-ID: <20260729130320.2282183-12-hch@lst.de>
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

Split out a helper for XFS_IOC_FREE_EOFBLOCKS to keep the stack variables
out of xfs_file_ioctl and to clean up the main ioctl handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 52 ++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 25e01648bb7b..bf3be8b4eaf0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1369,6 +1369,33 @@ xfs_ioc_error_injection(
 	return xfs_errortag_add(mp, in.errtag);
 }
 
+static int
+xfs_ioc_free_eofblocks(
+	struct xfs_mount	*mp,
+	struct xfs_fs_eofblocks	__user *arg)
+{
+	struct xfs_fs_eofblocks	eofb;
+	struct xfs_icwalk	icw;
+	int			error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (xfs_is_readonly(mp))
+		return -EROFS;
+
+	if (copy_from_user(&eofb, arg, sizeof(eofb)))
+		return -EFAULT;
+
+	error = xfs_fs_eofblocks_from_user(&eofb, &icw);
+	if (error)
+		return error;
+
+	trace_xfs_ioc_free_eofblocks(mp, &icw, _RET_IP_);
+
+	guard(super_write)(mp->m_super);
+	return xfs_blockgc_free_space(mp, &icw);
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1388,7 +1415,6 @@ xfs_file_ioctl(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	void			__user *arg = (void __user *)p;
-	int			error;
 
 	trace_xfs_file_ioctl(ip);
 
@@ -1494,28 +1520,8 @@ xfs_file_ioctl(
 			return -EPERM;
 		return xfs_errortag_clearall(mp);
 
-	case XFS_IOC_FREE_EOFBLOCKS: {
-		struct xfs_fs_eofblocks	eofb;
-		struct xfs_icwalk	icw;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (xfs_is_readonly(mp))
-			return -EROFS;
-
-		if (copy_from_user(&eofb, arg, sizeof(eofb)))
-			return -EFAULT;
-
-		error = xfs_fs_eofblocks_from_user(&eofb, &icw);
-		if (error)
-			return error;
-
-		trace_xfs_ioc_free_eofblocks(mp, &icw, _RET_IP_);
-
-		guard(super_write)(mp->m_super);
-		return xfs_blockgc_free_space(mp, &icw);
-	}
+	case XFS_IOC_FREE_EOFBLOCKS:
+		return xfs_ioc_free_eofblocks(mp, arg);
 
 	case XFS_IOC_EXCHANGE_RANGE:
 		return xfs_ioc_exchange_range(filp, arg);
-- 
2.53.0

