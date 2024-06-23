Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3A71426F
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121528; cv=none; b=djeqZfnLsrS5mpuc97mQIO94rx5Rlrv68qp15Mw+iidk6A5nGCPpG0ppXFyZ9aPscBOSBkEf5YxNCmPkzW9OS+n/xZVgdUXF8u3PB4RX7oZYXi17GT/JfIKdLQksiI6OT63kTjojyAY5Z7GTB++dUMBn+nxTZwFWP9CbnKPoybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121528; c=relaxed/simple;
	bh=qI5IJEZpK7EDSaOEHypG9qihcPi/gmlPWYMN0pY8pcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf2M2KAxn4WQkCOPZs9wcsQZeAPuPROHOncieHt7IqlbcXKD2pxyU/5ea8+PD3PMfwdYZMteKVMByWUVEVrd/eYqN9nTrY49jmou/5DPa+BB0H1NH5kiHkes+0Wh+3HWXEMKgb3odOuwUbefxa17jLEFr5bIdB1MNNOmd8unWKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DaVJPTXe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DaVJPTXe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=s99uInmJKiAfMUcHDZCZHnsJgTIBTtv0d9iH6mT+aW0=; b=DaVJPTXeV3A2b4gzlMNCMbJ6B9
	JMsaKm871YN5hw0imhAIiBN2iwJqg4E69HvIiLhW/qAKqAXINz7DWl/fU/CnpvkwufP5G39+aVwvR
	Fw36hyFSogkChX92Zcn82MK6hJSWRSuLSNVfUEeW33DwK8so3FHp40R3Vf4SUVFiJ5bfhkLAOjKvl
	X7xQZreSW7guY4z1jqHI0WP8PP47yZhc9QqFqUqW0MCe2upR/w4xHD9632S8IxbTHe5UMLeC30JWs
	i2n6CKOg5usXXA0CqXIbiAWoKrhA/XC5XFqtuHtmSguvDLKSlKqrfP3mRJkEbwqshUrCvoxksJFwH
	2EUMpzDw==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLG2X-0000000DPDP-44JJ;
	Sun, 23 Jun 2024 05:45:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: fold xfs_ilock_for_write_fault into xfs_write_fault
Date: Sun, 23 Jun 2024 07:44:31 +0200
Message-ID: <20240623054500.870845-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623054500.870845-1-hch@lst.de>
References: <20240623054500.870845-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that the page fault handler has been refactored, the only caller
of xfs_ilock_for_write_fault is simple enough and calls it
unconditionally.  Fold the logic and expand the comments explaining it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 904be41f3e5ec6..4cdc54dc96862e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -227,21 +227,6 @@ xfs_ilock_iocb_for_write(
 	return 0;
 }
 
-static unsigned int
-xfs_ilock_for_write_fault(
-	struct xfs_inode	*ip)
-{
-	/* get a shared lock if no remapping in progress */
-	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
-	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
-		return XFS_MMAPLOCK_SHARED;
-
-	/* wait for remapping to complete */
-	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-	return XFS_MMAPLOCK_EXCL;
-}
-
 STATIC ssize_t
 xfs_file_dio_read(
 	struct kiocb		*iocb,
@@ -1294,18 +1279,30 @@ xfs_write_fault(
 	unsigned int		order)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
-	unsigned int		lock_mode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
 	vm_fault_t		ret;
 
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vmf->vma->vm_file);
 
-	lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
+	/*
+	 * Normally we only need the shared mmaplock, but if a reflink remap is
+	 * in progress we take the exclusive lock to wait for the remap to
+	 * finish before taking a write fault.
+	 */
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
+		xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+		lock_mode = XFS_MMAPLOCK_EXCL;
+	}
+
 	if (IS_DAX(inode))
 		ret = xfs_dax_fault_locked(vmf, order, true);
 	else
 		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
-	xfs_iunlock(XFS_I(inode), lock_mode);
+	xfs_iunlock(ip, lock_mode);
 
 	sb_end_pagefault(inode->i_sb);
 	return ret;
-- 
2.43.0

