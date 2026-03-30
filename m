Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197403D3CE4
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 13:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774876578; cv=none; b=G8hxfVvoJVeH7tYuG416NyyIldxQXG9RFLtGJBdGm0bBw3JR4a9IyJ8nDjS1weNkBB6KLsGEKIvwb/jjfOQLWGNFl5ldvesY/sKGIhIOxoaxKy3PNXyMZVAFJ8NkxqkjRldhBDz5SkHFFYhLCPL6KyCHkm9afMFlgJqNmluyqfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774876578; c=relaxed/simple;
	bh=EC1M5P9ByYyqW3ZdLwhsCB5mvCePEP707GVzvgmfl8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0DMX3k2lNWOI07OirG9GuRUAVIBJoQZJKoQWEvSXl3Vmtr3LIKR0txdek75BE8zu+Nlu2Hti2q55dXeCqKvLZbqc1Gzfd70Y0s5z45TOqnnvOYSYPGEp86XQwFiJstGg/syc+ZHq2dyLPF4ARB5cnKbXvTL3QVWAjFYOu9HXcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LLSyUei1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LLSyUei1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nRBXZDnzA+j7dLOyvKWaK4IolBovAM4sUlz0J3FgCPc=; b=LLSyUei1+JUnbwIJtuOYd3ddMx
	WzSK91ds9USUgW09G6fldor31rG3E2GSfhLoiNO2UmFNu+RWV+L91hxlLoYH4iJzM49vxnOyWkXEa
	oHD956GOlxZsTNnHjgxhCfAqOnwTsc4IfqCMvZQSpmmwwWLpPc/0Flq/hXXPKPlLCB3Bjmb6zKoIE
	Z9NHRjdosC7X+tDHfUJJ84okdXBqwALmLiGd76g7Z6r2NTgxZsOEEknfdX942EjqzmxRmrog9kMt9
	pEoKWEsgZn9DFUq/rCuUuvQCWdLBpjcoHBgXezbYroGMrNot0jZXTmYPcdMbj5FNz/FN4FQxNWABr
	58g1H50g==;
Received: from [94.154.173.90] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7CTX-0000000BKTV-1NuS;
	Mon, 30 Mar 2026 13:16:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: fold xfs_setattr_size into xfs_vn_setattr_size
Date: Mon, 30 Mar 2026 15:16:00 +0200
Message-ID: <20260330131607.3904269-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330131607.3904269-1-hch@lst.de>
References: <20260330131607.3904269-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_vn_setattr_size is the only caller of xfs_setattr_size, so merge the
two functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 38 +++++++++++---------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b0256a4a8aa8..325c2200c501 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -901,20 +901,18 @@ xfs_setattr_nonsize(
 
 /*
  * Truncate file.  Must have write permission and not be a directory.
- *
- * Caution: The caller of this function is responsible for calling
- * setattr_prepare() or otherwise verifying the change is fine.
  */
-STATIC int
-xfs_setattr_size(
+int
+xfs_vn_setattr_size(
 	struct mnt_idmap	*idmap,
 	struct dentry		*dentry,
-	struct xfs_inode	*ip,
 	struct iattr		*iattr)
 {
+	struct inode		*inode = d_inode(dentry);
+	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct inode		*inode = VFS_I(ip);
-	xfs_off_t		oldsize, newsize;
+	xfs_off_t		oldsize = inode->i_size;
+	xfs_off_t		newsize = iattr->ia_size;
 	struct xfs_trans	*tp;
 	int			error;
 	uint			lock_flags = 0;
@@ -927,8 +925,11 @@ xfs_setattr_size(
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
 		ATTR_MTIME_SET|ATTR_TIMES_SET)) == 0);
 
-	oldsize = inode->i_size;
-	newsize = iattr->ia_size;
+	trace_xfs_setattr(ip);
+
+	error = xfs_vn_change_ok(idmap, dentry, iattr);
+	if (error)
+		return error;
 
 	/*
 	 * Short circuit the truncate case for zero length files.
@@ -1128,23 +1129,6 @@ xfs_setattr_size(
 	goto out_unlock;
 }
 
-int
-xfs_vn_setattr_size(
-	struct mnt_idmap	*idmap,
-	struct dentry		*dentry,
-	struct iattr		*iattr)
-{
-	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
-	int error;
-
-	trace_xfs_setattr(ip);
-
-	error = xfs_vn_change_ok(idmap, dentry, iattr);
-	if (error)
-		return error;
-	return xfs_setattr_size(idmap, dentry, ip, iattr);
-}
-
 STATIC int
 xfs_vn_setattr(
 	struct mnt_idmap	*idmap,
-- 
2.47.3

