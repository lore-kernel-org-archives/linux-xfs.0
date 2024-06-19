Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9181813DDC7
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 11:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798089; cv=none; b=nx2M173OR/nFVnDig8/1OLYETOjCPpRgMfnvpmVU7P+WZ39JgIfLH7pkItcGYr1GG6jEH94KM/XdzcgdFvsc7lQ23y5vH8gtm1Ad3/6eSPkNT9bqIuFaNLjGmKMgYjD0dXxYXSm+JIyZQDZiZekNRcTVtaQp2lN61+2Zke2zFQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798089; c=relaxed/simple;
	bh=EGuhpdQFTZDqOPgi604OcaZHbtU3I7M8UHTzKbJJ2Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGv/scfcV9baAuoi1RDhhKw6YzNUMDkkw/5qKzlAmTpIwdm0+BUhNoKreRyqlbwPr7+qaDekYTxNqjACUC0yxC2n3HgJcCLobCSjmUAS8VDHwkFw552w1M34D47y7JsC1d/XFnyezyJCExKMflL3gcgMbTEHD2Gobisw6VTbhaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QEZRA5P4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QEZRA5P4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dVkcFIKTnQqpP50J0F+2aXWkddNXrZdnZb1hiar8ji4=; b=QEZRA5P41x1hCC26ZahmVK4weR
	GbyOCLRqsC7oR2Lqmi8jxwICDr9/FXSF/r+ZaKg1M9clX1kXkeB4FJDwFfapa7ODPknHaDb6kLwcX
	eJclFglPLYfKQ7/Sk+LedSM0II129Mg7+saCL7F5OG9AzSLzpmLy4Hqfb6olJ8+WDPICyyYqd6x0l
	OFXByalbSLHpUHVpEMQzCbcfhAA4hWWOP3hxZWiOwDQDKeBzRYbWt6fSMRuBBaieT/cGnW4xiKP7H
	9hhgACnQ/nFzrvSUBhsJmMnF2XGXESYPN39vyWXIr1Vh83uzWgeLsgkTKj6ZzARxaZi0umjMefmbL
	N3Crpzxw==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJtth-000000014Pg-30F1;
	Wed, 19 Jun 2024 11:54:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: always take XFS_MMAPLOCK shared in xfs_dax_fault
Date: Wed, 19 Jun 2024 13:53:55 +0200
Message-ID: <20240619115426.332708-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240619115426.332708-1-hch@lst.de>
References: <20240619115426.332708-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

After the previous refactoring, xfs_dax_fault is now never used for write
faults, so don't bother with the xfs_ilock_for_write_fault logic to
protect against writes when remapping is in progress.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 51e50afd935895..62a69ed796f2fd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1279,12 +1279,11 @@ xfs_dax_fault(
 	unsigned int		order)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(vmf->vma->vm_file));
-	unsigned int		lock_mode;
 	vm_fault_t		ret;
 
-	lock_mode = xfs_ilock_for_write_fault(ip);
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
 	ret = xfs_dax_fault_locked(vmf, order, false);
-	xfs_iunlock(ip, lock_mode);
+	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
 
 	return ret;
 }
-- 
2.43.0

