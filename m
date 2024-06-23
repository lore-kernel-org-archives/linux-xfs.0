Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456A9171BA
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121516; cv=none; b=E9EG1KRrC4wGN5HA6GOXAsxh4D2EsIhh20KW5d6vxDL2u9St0E7rrXoYQAuka6XYq4+u1j2ZQCovomQXvaHvt7zfvlGXFYoGipq19UUIZhYDiw6Qf944p+K+fu5IFylLTW1CBrZOhhLbu4n+Qy83gvuwP3eDi5pV+OvnCoWx2a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121516; c=relaxed/simple;
	bh=IfrfXNVlkHw3h6dPBlfVsysHBvPLyGnqHKwqPd3Rbuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQg7mBBzliENKKi5ZKL2xo0GO9FQgIaKQndmIWSunGAtiTiym/qM3ifLr6CuUwH2gsiSoR68V17FL8XRoLAKLJDnYnnqUwqLuHc09A1Ujqkk6Omkf6+pkljuGcfGV/Xy0cW+Ra+3b/smSOGQXmqBQesA89JzEcp45Tx992Lde7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JlxLP6bv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JlxLP6bv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UsFb63tZPxtvzIqQT+D+barxuGiCTisIO/VgusjO6vI=; b=JlxLP6bvNFv3YD23WGYzyfQtIl
	+57JxAxJ7Q/uQuAFXrHmXoXEOLBunr6T3hkzpinONRmq2mX8xq+heizJjb2xCoyV+Du1Qlhp3VuES
	w5bW8nEADpOfsGNCd9lWWbnXRQMybsXEcICmTuegu3Txp6oX5T7jEw/0wE491RigFLKZf8pFGoflU
	zzrUrlPq64Orq4DaoPBdEXcEo+JA+VhNaiJc1Q/acB8zPGv+2V8HKuNFmaNIFfJ0KDxDGiCFC7KAI
	uJbdMHjHYPfMs6yrFAiUmcqr1KF6CaUA6tf1fErF2wT9UOlpfzwnbmmGnATWu0tPpjV+s9Sw5uaLy
	fl4Ghd8A==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLG2M-0000000DPBK-12E4;
	Sun, 23 Jun 2024 05:45:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: simplify xfs_dax_fault
Date: Sun, 23 Jun 2024 07:44:28 +0200
Message-ID: <20240623054500.870845-4-hch@lst.de>
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

Replace the separate stub with an IS_ENABLED check, and take the call to
dax_finish_sync_fault into xfs_dax_fault instead of leaving it in the
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 74c2c8d253e69b..8aab2f66fe016f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1251,31 +1251,27 @@ xfs_file_llseek(
 	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 }
 
-#ifdef CONFIG_FS_DAX
 static inline vm_fault_t
 xfs_dax_fault(
 	struct vm_fault		*vmf,
 	unsigned int		order,
-	bool			write_fault,
-	pfn_t			*pfn)
+	bool			write_fault)
 {
-	return dax_iomap_fault(vmf, order, pfn, NULL,
+	vm_fault_t		ret;
+	pfn_t			pfn;
+
+	if (!IS_ENABLED(CONFIG_FS_DAX)) {
+		ASSERT(0);
+		return VM_FAULT_SIGBUS;
+	}
+	ret = dax_iomap_fault(vmf, order, &pfn, NULL,
 			(write_fault && !vmf->cow_page) ?
 				&xfs_dax_write_iomap_ops :
 				&xfs_read_iomap_ops);
+	if (ret & VM_FAULT_NEEDDSYNC)
+		ret = dax_finish_sync_fault(vmf, order, pfn);
+	return ret;
 }
-#else
-static inline vm_fault_t
-xfs_dax_fault(
-	struct vm_fault		*vmf,
-	unsigned int		order,
-	bool			write_fault,
-	pfn_t			*pfn)
-{
-	ASSERT(0);
-	return VM_FAULT_SIGBUS;
-}
-#endif
 
 /*
  * Locking for serialisation of IO during page faults. This results in a lock
@@ -1309,11 +1305,7 @@ __xfs_filemap_fault(
 		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
 
 	if (IS_DAX(inode)) {
-		pfn_t pfn;
-
-		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
-		if (ret & VM_FAULT_NEEDDSYNC)
-			ret = dax_finish_sync_fault(vmf, order, pfn);
+		ret = xfs_dax_fault(vmf, order, write_fault);
 	} else if (write_fault) {
 		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
 	} else {
-- 
2.43.0

