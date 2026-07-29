Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832A9477281
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325201; cv=none; b=PZCzsm1OkQAWdWMZVGKF4w+I+zNNBsnqJmpAFX4Y7ubCqCfBluGyafWutkrA0Ghn0eB33sRojUaN33RK3Mtls1HWup0V38jCiV6LeZzaZ5SwsZvT8dx8VISxeL2em0NTPd/6G4Wbwi39usGX7YHSE62HNUwvzXT4xydCQUeCo4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325201; c=relaxed/simple;
	bh=JR9RiABUKToetL3Grr4PvtJzj7rpc+V10KDHbSrsvI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTcu/dP1TVoFrW/dNYBuOWaIahEH6xPVvtdi6ZGRtJa2ch5PsKzVkaqgT5CGfRKNSCNfQHfs7SbKklsd++cKwuHCy3fTpGcdmSp9ZRKMZ01giKnV7gk4Rlbz2R72GwgM9GevtHqQGEbszKsRtNxVzBI7Pa224X2HloijGHDtCjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kUCpb8J+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kUCpb8J+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UIin6cU9+7wUl9tnXN2YmEUTLXt9MVe3nR116Xd5+Kg=; b=kUCpb8J+1XXTqZcfcMKb9FvEC+
	TQPHWX/jn/tiJkFXlYh8jeQbiAAyRdXM20t1M3y66Q6OKXU89t2YyzQpCR9zYc8eJ2T3mNtpOXKUu
	sxbsT183EMcD+92bBDY6FFQRvDazcI9AOYSZsWodBtPiB9Qx/IAjv/VotE6PEVo1CENLszPYInalK
	bp9daT6T/MVg6pmErjxLblH7xgf84WSFku/NIr7vCWXBDq9Z4G/w09XCJtvw4fJ7fSnM7mXgBYfND
	DaZQp5jLiYCPuvra2gHRptQUCRzi1ewSDSlijlvjxivHKbElb3NXXm4J5Mycs8Jm8ETgt9CVCO9Dj
	2EASXdBg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2di-00000007kzP-0IlZ;
	Wed, 29 Jul 2026 11:39:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/16] xfs: remove an outdated comment above xfs_file_ioctl
Date: Wed, 29 Jul 2026 13:39:01 +0200
Message-ID: <20260729113952.2255638-2-hch@lst.de>
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

The return code sign flipping at the method boundary is long gone in XFS,
so remove this comment documenting an exception from it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1b53701bebea..ec5412a9eb1d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1209,12 +1209,6 @@ xfs_ioctl_fs_counts(
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 
-/*
- * Note: some of the ioctl's return positive numbers as a
- * byte count indicating success, such as readlink_by_handle.
- * So we don't "sign flip" like most other routines.  This means
- * true errors need to be returned as a negative value.
- */
 long
 xfs_file_ioctl(
 	struct file		*filp,
-- 
2.53.0

