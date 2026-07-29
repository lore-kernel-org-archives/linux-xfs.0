Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F1486636
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330207; cv=none; b=jFVnOuPOVeJ1uS/mlVHnaVXUWPw+LOhedAg9LSJVrFRkeFZ6j0YLcL0gpvYKQ4jnQ5Wzsm7gM5aBpIM+JKfIrpBgX5lf8Nl1XGxhntGbgbugF4gdDoV3unnn3hCaqANUigXWHbrAOsjhT5Shwbgsz//j+k3z1LbXtDmqZ1dlN5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330207; c=relaxed/simple;
	bh=JR9RiABUKToetL3Grr4PvtJzj7rpc+V10KDHbSrsvI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/mebPiKv2GIk1CYdxWWtSNMmJvMqp11BY+wckm+EfBvRa2oOU19czGjQSKSesiy3W0LRITdoclEr8ceN72CPmuuqa45HNrdHgWlZxPt4DghPBi0cuY6o+dTk5TmZpo5UeFHMbvbti101aW2Rqm2/oM85vwJt79190zfJpNQAGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mV/UtvmT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mV/UtvmT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=UIin6cU9+7wUl9tnXN2YmEUTLXt9MVe3nR116Xd5+Kg=; b=mV/UtvmTd5riNQ3Ba4N/HKWtfS
	G8FhcXRXYNxEwoQAo8UErlgzUAdJbTYxpCnA2jsA5OxC5nEJNLta8pTWWUixEeo0CPdMcXHqK9S4U
	whwPfzrlAyoTARne+ZehJocEvwXIyds+5do2q+7uhknj70rd24ySc+IQI0uvtCfON4MOR//AdjXqi
	/62CGHs/rrJHuna+qIDYasoUPS1bV56vSiP3011nsmXmIKYQepnCf9Rk3RQlUz+C4CHvHv1F/xY6M
	xOd6nIEXPqjBJOdzMlfb5GevJNF+Faz0O2sleqPn/Wvv3KnvNsISxv/6Kfws4VNiVfHXU47VSZzxK
	m1NKrDCw==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wP-00000004WjP-3oLd;
	Wed, 29 Jul 2026 13:03:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/16] xfs: remove an outdated comment above xfs_file_ioctl
Date: Wed, 29 Jul 2026 15:03:00 +0200
Message-ID: <20260729130320.2282183-2-hch@lst.de>
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

