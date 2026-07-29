Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84D3488774
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330217; cv=none; b=MwK9yaydldtI+s/FeoQCe0wPPpTlggWMEMgII1TENHriasPrIObynyPoXx/jOVEzBFmgABUvCK99EJ8OMGqSgk2RprI8c8xN06DYoQWl4s5ZB7gp4XzK1vVXqdrN21lug70wrsDFxIi2FQxesgZ04zk/axf/2B7iQb8+qZ4OctA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330217; c=relaxed/simple;
	bh=gK/fkTAB8E4PBnggp+vmvVCnCfMCeF26ZlpAy68M6v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTmzxhdtbFxjRNYaaEpwnh3Z9o/qENXXRrg22zrXDcNwpiULUQiuBsFz6cjFmPB7D90pBu79jaLc8Zv3AtQvnhgg+mJPI+gHDtstG/fMKhpFz8IxDYSfrpswet1sZJs8LamPFoTTMFmOlv05PvBXO9QliJyd4dGDmvs+/7Q4YB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d/6AE0hB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d/6AE0hB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Nco+GrARwS/BQVAUG8JIvnfhlT5u+w5FgHmmORfeTGk=; b=d/6AE0hBMrJJq2oWxPcpwSmhAm
	WDPnJ2ojyPSZGGgRj054Fc2qNa6axlNlJlFf7JVtzaASTOmPt6O7d8K4x3C9AM3XkRx7RT4x2Lrg7
	dNHVx3RoxMV0OwFofZhlGiIjykMkDrMZyCK3a+ayvyawwv8ZIcCPjaE616+yqPCsg92Tg1ZJPyrSQ
	wKVbnvkSOlKZkHZwW2fpVZiqh0NQ3AH8vpCfb2FK7W8w/20x16cSjm/Cp4RAIOmyJiku+NMGqfRhU
	UUmPCRkvcvDj126CbWcBhJWwYdNJO5O4OqmIzFgHl7BwYkQ9kz3CNWRik/TVNVDjEb6JTK49BVPY8
	M+4PcpPA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wa-00000004WlE-2NIG;
	Wed, 29 Jul 2026 13:03:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/16] xfs: cleanup XFS_IOC_GETVERSION_32 handling
Date: Wed, 29 Jul 2026 15:03:12 +0200
Message-ID: <20260729130320.2282183-14-hch@lst.de>
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

Move the cmd assignment into the function call, fix a spelling error in
the comment and move the comment next to the call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 2162eda01743..ede890d4cbc3 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -459,10 +459,9 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSGROWFSRT_32:
 		return xfs_compat_ioc_growfs_rt(filp, ip->i_mount, arg);
 #endif
-	/* long changes size, but xfs only copiese out 32 bits */
 	case XFS_IOC_GETVERSION_32:
-		cmd = _NATIVE_IOC(cmd, long);
-		return xfs_file_ioctl(filp, cmd, p);
+		/* long changes size, but xfs only copies out 32 bits */
+		return xfs_file_ioctl(filp, _NATIVE_IOC(cmd, long), p);
 	case XFS_IOC_SWAPEXT_32: {
 		struct xfs_swapext	  sxp;
 		struct compat_xfs_swapext __user *sxu = arg;
-- 
2.53.0

