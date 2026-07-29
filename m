Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A89A443AB5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330208; cv=none; b=PShACr+bIc00ZMDXDyHmCOTVDuA1ZiAHtG67Gy2CxYMzimJtFJZ1H/vcfiRvWNZTTlXvgsDdvNCtA9PhDsAOk3kUsy10PQHJEQPUa+2CPGTPKZ9ayRWAVZS+ZZV02uBUV6ldZFccxtlhe/UohgnPqpcu4HeroaeHhz9xpgExEOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330208; c=relaxed/simple;
	bh=Agjr3w9AmaijXN7DE379QNe8BYbTyJIPLG+cCXWDThs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJhSEgVPcUAyxZbCcdmE/XNdv3gXrH0CPULM8yRWcNvSclcp0FKCdbLWQHszrYOhnAdeKB+XNMi3WgpwOzunEN2RlX9GBmzeunDv+LhlECxSslhZWXhRVYCro0kltG1uP1frUVrX1neUVRumSHbYve74N//1hYtNYYnTsBTvyVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eolTl6Kx; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eolTl6Kx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=VgTceEYaPkawBFBpZZGCDYed4mJoxhPZLQz5u36Xw88=; b=eolTl6KxneCdfEyAwLdKmiuEla
	ste4Drie+RQjh/W7nlR3E4Ox3qU8llHIc8g1V0y/dThjefbGDTs78Kfi/Xo8kE0pRyCCLc/I6qoer
	3UqbVo5bmMNPXk8T2JqfqxNFJzL1tiy2z+OSQEfr5MsmrS1EHLgeEuzMF7OZvR+VXR9fu81qt3j8b
	clkAE9fsshKxQfsmndVhaIZPzdOTxhZMrL1Ku86VowrHI0fNvya0O/i263O572aSMM4cTMX5Ot6hl
	02I7iOCwdfB4a/OKSEVHBaRyrgVvYG29AV4G9wjZAULhxVsLRd2ksPFd/UTgYhXS01le9uo4MOcZQ
	FddYs35A==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wQ-00000004WjT-3J7t;
	Wed, 29 Jul 2026 13:03:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/16] xfs: rename xfs_ioc_swapext to xfs_swapext
Date: Wed, 29 Jul 2026 15:03:01 +0200
Message-ID: <20260729130320.2282183-3-hch@lst.de>
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

The usual convention is that the ioc_ prefix is used for direct ioctl
handlers that take a user pointer.  The current xfs_ioc_swapext does not
fit that pattern, so rename it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c   | 8 ++++----
 fs/xfs/xfs_ioctl.h   | 4 +---
 fs/xfs/xfs_ioctl32.c | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ec5412a9eb1d..9a10645f5222 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -962,10 +962,10 @@ xfs_ioc_getbmap(
 }
 
 int
-xfs_ioc_swapext(
-	xfs_swapext_t	*sxp)
+xfs_swapext(
+	struct xfs_swapext	*sxp)
 {
-	xfs_inode_t     *ip, *tip;
+	struct xfs_inode	*ip, *tip;
 
 	/* Pull information for the target fd */
 	CLASS(fd, f)((int)sxp->sx_fdtarget);
@@ -1341,7 +1341,7 @@ xfs_file_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_ioc_swapext(&sxp);
+		error = xfs_swapext(&sxp);
 		mnt_drop_write_file(filp);
 		return error;
 	}
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index f5ed5cf9d3df..e57d8f5148bf 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -10,9 +10,7 @@ struct xfs_bstat;
 struct xfs_ibulk;
 struct xfs_inogrp;
 
-int
-xfs_ioc_swapext(
-	xfs_swapext_t	*sxp);
+int xfs_swapext(struct xfs_swapext *sxp);
 
 extern int
 xfs_fileattr_get(
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c66e192448a8..250df2bbf214 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -475,7 +475,7 @@ xfs_file_compat_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_ioc_swapext(&sxp);
+		error = xfs_swapext(&sxp);
 		mnt_drop_write_file(filp);
 		return error;
 	}
-- 
2.53.0

