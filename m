Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2C488DA0
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330215; cv=none; b=jDl9t14+JFKZEax81cPMf/n/CEz5ubvBNoGeGjWU0NK/6MoyAcddYbPQGxkjZJPWGBcItJJHosRpsAJ9otzU+/DpNeczxXYVjfuRLX0AOyzbHDw0Z8Y3lgFxekVdlO3z0cTo4J8Mue2opCMiARQ1Qbn4NvR7S1D7AHcJCfd0dxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330215; c=relaxed/simple;
	bh=isVzOcuXDYMXsA5fAUhImrmYdjx62jpK3V3IBRzsAWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6WuAFkU/2seIrbH5uW5yzj8WDru2lZXGIntUKDywMms4yUiqwvWV+FaHcYUwWaNMY5ij7XMmUQYTZt3JmfvrFDbQUEuW46fWVzr30Rar/DV7fveat/yPl0Dg+ZzK3dgx9U4DHJn3hHHiDLbFi2u2V0NlXukVeF6IQcxMaAegPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jSeyV65h; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jSeyV65h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=6BQr7dGJdCj0eLrcq5pH0Jib4OYd0nAQbK4mAK30q2Q=; b=jSeyV65hzX4l+99FYrfOi/IX9F
	JdoZdp0RMlWbCCOa9jdWgHkBQZYcxjs3MifLmywyBqe0kOShNvwRN8467e86vahM/0V0TX8QngwqM
	VBXe966RoP6YhZkJqis24QQwW1oaerKwG/NtR8LYEbXSmqbXsrNJBefCBdfjJQf+SbvIKExheUm8g
	UQZJIXDukOIbvCapaI7RQahiPyR8GTYDc2ao37i3zI4wdDhzb664D+PqJlvvrJmozdchqyG3eMYTY
	gHW30Mr/Bsf/qmYJyf3CMrwD4lYYiks+rJrsnEXRrj6iOKqIRbpCzY/kT7dw6h9iV3sWSdXZm5gaq
	8/e4o3ZA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wX-00000004Wkl-4B8N;
	Wed, 29 Jul 2026 13:03:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/16] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
Date: Wed, 29 Jul 2026 15:03:09 +0200
Message-ID: <20260729130320.2282183-11-hch@lst.de>
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

Split out a helper for XFS_IOC_ERROR_INJECTION to keep the stack
variables out of xfs_file_ioctl and to clean up the main ioctl handler
flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3db8f33e9440..25e01648bb7b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1355,6 +1355,20 @@ xfs_ioc_goingdown(
 	return xfs_fs_goingdown(mp, in);
 }
 
+static int
+xfs_ioc_error_injection(
+	struct xfs_mount	*mp,
+	struct xfs_error_injection __user *arg)
+{
+	struct xfs_error_injection in;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (copy_from_user(&in, arg, sizeof(in)))
+		return -EFAULT;
+	return xfs_errortag_add(mp, in.errtag);
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1473,22 +1487,11 @@ xfs_file_ioctl(
 
 	case XFS_IOC_GOINGDOWN:
 		return xfs_ioc_goingdown(mp, arg);
-	case XFS_IOC_ERROR_INJECTION: {
-		xfs_error_injection_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -EFAULT;
-
-		return xfs_errortag_add(mp, in.errtag);
-	}
-
+	case XFS_IOC_ERROR_INJECTION:
+		return xfs_ioc_error_injection(mp, arg);
 	case XFS_IOC_ERROR_CLEARALL:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-
 		return xfs_errortag_clearall(mp);
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
-- 
2.53.0

