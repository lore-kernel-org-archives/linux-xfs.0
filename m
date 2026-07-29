Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0127D443AB5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330214; cv=none; b=JhHzIv8po9Cdrgg51wedAvL2MTxpEsFtaRK0+vnbnOVfeHxwJGKxBk6N8zN3vvUjHsAzqAzREnlC4CTx9Hkvv43lXmkanMZdOIQz0vzO5UkaBkJJvihFIXfbGsXQjJHEUY0qEHu5sJxYxxh7LAZZxfQVs1jYNbxVUo+z6jVKrxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330214; c=relaxed/simple;
	bh=4bnUr6iJwANvfF+Ts33N663UIWRfT0tMOdyd4XyfDAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsFWPlPoIoE18sZusX1iX4xcd+Clx19S1zh/kvmjnX0nhrUeUacPqkUMP0hL86PfAGGXWWfrH2PhyGJsF/v67aOA4cPpLZG2tJXuFOMbjqej2HBwLWYkkSfklzi7z/NxSiCM5vybMMP3V94OQSsQO9Ja1uKkpJoRMUkD1vjt+wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MGgkUth8; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MGgkUth8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=QdwRwi4VOrurVwD2Tr1Mt07ELWav2/kuRkqF09H8CFw=; b=MGgkUth8FD3NBoO7wcwPcBABLN
	/Rg4OYK9Xy7TgW7XlRlYBtFqc/uezSRVO6xs/CFtQlIisfYwROy5rVP/34U3x2zuGp901m6qegPvE
	iQo6XgvJ2UI63/Msa+orvvwKBPvjs9YekIBtx9trC4a1qX+FZxQoeReCqHJr171gB4SQowy5orCYL
	vPruRr65PwTw7GBR2p838courmnYpbMY4MxUkKJWIiHHvHbM6sG3+wgBNo/kKz0IM6gPcraSAVZFd
	+1aIYzgurr5o/KgmWT3jTY2AH4FV5ZJ9kxnLzdGDLvllUmcWFwr7HSlnxJOIAsJlCAEbzgEhL2Tgi
	+trevT4Q==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wX-00000004WkU-0d5J;
	Wed, 29 Jul 2026 13:03:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/16] xfs: split out the handler for XFS_IOC_GOINGDOWN
Date: Wed, 29 Jul 2026 15:03:08 +0200
Message-ID: <20260729130320.2282183-10-hch@lst.de>
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

Split out a helper for XFS_IOC_GOINGDOWN to keep the stack variables out
of xfs_file_ioctl and to clean up the main ioctl handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0b5ae79e4aaf..3db8f33e9440 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1341,6 +1341,20 @@ xfs_ioc_growfs_rt(
 	return error;
 }
 
+static int
+xfs_ioc_goingdown(
+	struct xfs_mount	*mp,
+	uint32_t __user		*arg)
+{
+	uint32_t		in;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (get_user(in, arg))
+		return -EFAULT;
+	return xfs_fs_goingdown(mp, in);
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1457,18 +1471,8 @@ xfs_file_ioctl(
 	case XFS_IOC_FSGROWFSRT:
 		return xfs_ioc_growfs_rt(filp, mp, arg);
 
-	case XFS_IOC_GOINGDOWN: {
-		uint32_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (get_user(in, (uint32_t __user *)arg))
-			return -EFAULT;
-
-		return xfs_fs_goingdown(mp, in);
-	}
-
+	case XFS_IOC_GOINGDOWN:
+		return xfs_ioc_goingdown(mp, arg);
 	case XFS_IOC_ERROR_INJECTION: {
 		xfs_error_injection_t in;
 
-- 
2.53.0

