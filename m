Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01732BE05E
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325209; cv=none; b=jm6zZutw9cagEfE3EyLRRHy69Aiw36KgnItPx8Lvjtl0GBlYWpWmvvI3S8I9d6JbW16LsYpRPYJ10vI8V/D7YKzWUjJJtueJRZG888FkjB/uqVslfyj2c3Jqrr2bDN5qmENF608o3AVYBd8iWdLXP7yE/1oEGi7XZHWE1m+xmHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325209; c=relaxed/simple;
	bh=gzuT5j9QejfZlocLUlr9+qxhiI+SyciBvqcDV69vT64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq6RhLsG33G8NELNtvE1oHmqYBXpnKwW3VLbsSMvXeSeI1wTWrpfpcKlFT1IjFRWh3v+YcjpihI+AC6WarHNsyRbM1xr/DBdfGO0hANXtiAJCDmwQd+b/B2ui+10il3pZ4fWPzL8IByNlL/ODSWh0t8vArrnRsrNdRZZGWMySmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tCH4xCfr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tCH4xCfr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=u+2OvuCdGAkz6m80+TZErd+esbm/yBuiZ8WoNrn3PmU=; b=tCH4xCfrmbdqL3xk48xXLYUVH6
	+K6HWLfJUNSzW16RpYciKN4YFks7OMUEnsV/1B43raEcZ+Zo4HumGwDeHgWWM6hHFbYvjbwC2MVTh
	JJO0P+QWit/MCB7xNVscyWA/kvMzXVkJJiEDdELog7beq+GBifBLPp6kl4oWzYDreYB7/8nAE/PS9
	y5jfxd3e2DOkt8h2NnzgK3BF8jrNgHBkbnhW50yDM/bh6g9omcAYCjFVCkwctpYTtXTIFqBFr0yKb
	ESuzT9eL/1iU9c7n7kIQ619ykZEHx1dPDs5wthz5LSPCEH6mFkanY9+Bx4uQaJ5BtnbLk+fP6I7nO
	hEmhGMPQ==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2dq-00000007l1z-2ze3;
	Wed, 29 Jul 2026 11:40:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/16] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
Date: Wed, 29 Jul 2026 13:39:04 +0200
Message-ID: <20260729113952.2255638-5-hch@lst.de>
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

Match the naming scheme of most other ioctl handlers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2d68b868b4e2..9d8ef646e0f8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1144,7 +1144,7 @@ xfs_fs_eofblocks_from_user(
 }
 
 static int
-xfs_ioctl_getset_resblocks(
+xfs_ioc_getset_resblocks(
 	struct file		*filp,
 	unsigned int		cmd,
 	void __user		*arg)
@@ -1351,7 +1351,7 @@ xfs_file_ioctl(
 
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
-		return xfs_ioctl_getset_resblocks(filp, cmd, arg);
+		return xfs_ioc_getset_resblocks(filp, cmd, arg);
 
 	case XFS_IOC_FSGROWFSDATA: {
 		struct xfs_growfs_data in;
-- 
2.53.0

