Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778D6480947
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330208; cv=none; b=TXlNSf1oQnv/Hh6adB8wr7XWJIDjniw7X3t0UPth/PmurR8wtVuGeuGbfE8EtfqkK7DqhcjTlO4+YMwhSg3nS/cLsTevAA2Ny56KzbwmsDcyvHAkJubaisWVevL89BnEhO28ELZNmzzB0KmbKlKTDSPGqGzsv8LHo9rxuAa6uDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330208; c=relaxed/simple;
	bh=XBgeXh4VSTKCS6/yMewDTP3aMB8mEyjNsaiR2QbJUgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4OBqPQoB8feAhc+lt9XIHJZnqe6oScr/TYGpfJ8bKxyVCBxemiojbB4BgA0PkkaurpDTgava7NGnX1bCErrH2LlOTL6KSNtUp6V6BBWYZb7gIsvrOfzvYORDftLryvAZc7WEaQgHEAnd0QqNz8lVIfe1ZsPaGpnwL2wheFBhwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eOAnLt0B; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eOAnLt0B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=2ysKG/QXP9FDep+jIVlqPmyIkmLTWEAU/TcsK4C3SlI=; b=eOAnLt0B1sWFKfUN4jGhLrItTs
	ooDGEmJMvxvUm1BN/tNu4ImysnpVkfUnKAOWgq/Ckb+KiPwpZmUzv6xjmw8ShA7BzYz3OA2fv+1Xk
	XVBLb3R6Fk7msNdaz1+m7ZlWM8Pens4wVb/XZQPLv1kKWQ6MgGg9awNWzTi68bTNkLhYG6W6RkScz
	7vGAjOPGhZIyDdTpUNeByT2fVgWRNOpO3PdgplN7aFcftZyov9IWIPjAscJLBL0wXpFAK034MiW5g
	Rhje/hYB7QKzrCyIcYx26sudLGEgwLTuvLZcLrB8iqZi7p5hPmdVgUAx3G8ff8WW8eJOsTnrPqBg5
	HaPHeFtQ==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wR-00000004WjZ-2kcp;
	Wed, 29 Jul 2026 13:03:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/16] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
Date: Wed, 29 Jul 2026 15:03:02 +0200
Message-ID: <20260729130320.2282183-4-hch@lst.de>
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

Match the naming scheme of most other ioctl handlers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9a10645f5222..2d68b868b4e2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1183,7 +1183,7 @@ xfs_ioctl_getset_resblocks(
 }
 
 static int
-xfs_ioctl_fs_counts(
+xfs_ioc_fs_counts(
 	struct xfs_mount	*mp,
 	struct xfs_fsop_counts __user	*uarg)
 {
@@ -1347,7 +1347,7 @@ xfs_file_ioctl(
 	}
 
 	case XFS_IOC_FSCOUNTS:
-		return xfs_ioctl_fs_counts(mp, arg);
+		return xfs_ioc_fs_counts(mp, arg);
 
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
-- 
2.53.0

