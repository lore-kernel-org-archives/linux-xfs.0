Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E582476CFC
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330210; cv=none; b=oery9XV/Zqxm4BPim5UzoGtdcrN4S/o/hZDpFt7foS23SJaakkbN4M9fUhJJEpc99CRZs7Mh4SbZWex1dLgzbtpWX0tY5f7m8H+3AoEY4fvLdTWfBBm8CW7vNpFL0a26sUIA9ZfGg2IghvpS9z+f55F9rRwmTCoXsa1tdzzTW1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330210; c=relaxed/simple;
	bh=gzuT5j9QejfZlocLUlr9+qxhiI+SyciBvqcDV69vT64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKI4VMCqjW4JbLq94uwESTnVBBJFky1BZUsVUVgaFKadZJ9+8PvhYK5JXDJtRJ3gFOXcEY7Phzn/iFipVKUKV9TyoM1thO/rL/UPdGCCXedJfgTl39tXPIllse+LuWj4qdlGyBqNcGGQKcRfJQvWjgNSRj5Oz+kQXqoRlYJPkV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oHW7ryeV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oHW7ryeV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=u+2OvuCdGAkz6m80+TZErd+esbm/yBuiZ8WoNrn3PmU=; b=oHW7ryeVLO4ckQ/0SYQuIirD2t
	pdmemV1tjTyLLgRbqMxpxcpZ53lvshWvlBoojvy3QvA9EArx81enNKHqY3un/LLe+ZW4hqLDN+8nJ
	sJLGA5FMbQ7WwqcMDGFjgg4AFve7vC8e3pL71uV8qRDVOlmaNvXi/ytaxHGyZdsorJJ+WxH3/1QT5
	xg1yU071XD18ZZyIHvtWJOvpbSqQCq/RliJdBIqSH/pqL5ZxAnif38cqRsE8xJ/xDvGfOsIyR/6Ft
	HodK4dV1q/79NDrajGbeLSnI6rBEkbrpkk+gv1eAzpoVTTDVUR59y3wO8KyeOhw2LpI1GmFw3vg/y
	RgG7qL1w==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wS-00000004Wjj-2WYC;
	Wed, 29 Jul 2026 13:03:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/16] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
Date: Wed, 29 Jul 2026 15:03:03 +0200
Message-ID: <20260729130320.2282183-5-hch@lst.de>
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

