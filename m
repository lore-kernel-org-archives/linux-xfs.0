Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D76D1DD874
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 16:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738772904; cv=none; b=XYA9zKlzHTyJJxzAAC3gDjyWiloq2/YnlNwNXAQqw1UZ+CFI081MVCH04VmadiqpqcpGNEn9pukyYIiSwEoL40i1mHVMdPM3fa+MRwHykL2I9ZT3QUmkN6kQDU3+5ulgzl53XE8oDXilKaP+KyanYXFLhEY+yFPIXkzYXrMfbd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738772904; c=relaxed/simple;
	bh=EKnVXDAOLuJ8w+0WZjlR57sMy6UP1eFS5Dy/n5bOug4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3VxptRCH/Q/TQPs+UULm4Wj2tcH5tArtpl/lRcmFAkjw+muLEyFNqH87psfCkSPSuSqcrLNQCNncEchRSioKdNW+/gVoFdhzt8UUzNvqOZR2jy7R47uznTaMwYuuTt2huN7a4pDogIrRv5MPadCx4JIvtAVYcpRAg2JPwPT2cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KjqTgiIR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KjqTgiIR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=N9iIEQWKnW71rDjlUFoyd7I3gN4uR3XGrZZ4UxUMnl4=; b=KjqTgiIRQXCgRBB9KBTm8LSQ3B
	RsNoQ2OGCs90/N91Nd25aVBSbz9cIBcZkfePveIreOD14WIDKZ11E7g1GNjPBPkHI/llQ9waYTLnC
	y2qV0Fj0KRjTvg6ySxAsnyv2HTaf1F2JylOLjs3mwl1qAl3wj+sarfsFrhBgOfyIHzCzQfGWhTtP9
	tyB6BiJR+KRteDTJwxC+4+bplVQfS8ahEH3usUO073mwnFdrLGVLjd2f9IoDgEcuPtjV2lgriYj+d
	lFfg7e+xuKp+QZUqBdwG6+4iRj7RBNbypXqmffKpLeNPrdOqRoglzQ25lDlOgm0bKtkugq3w/StnD
	OYLLyYzQ==;
Received: from 2a02-8389-2341-5b80-839d-6dcb-449a-ed13.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:839d:6dcb:449a:ed13] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfiGE-00000003yo0-1L7i;
	Wed, 05 Feb 2025 16:28:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: rename xfs_iomap_swapfile_activate to xfs_vm_swap_activate
Date: Wed,  5 Feb 2025 17:28:01 +0100
Message-ID: <20250205162813.2249154-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250205162813.2249154-1-hch@lst.de>
References: <20250205162813.2249154-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Match the method name and the naming convention or address_space
operations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c792297aa0a3..fc492a1724c3 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -681,7 +681,7 @@ xfs_vm_readahead(
 }
 
 static int
-xfs_iomap_swapfile_activate(
+xfs_vm_swap_activate(
 	struct swap_info_struct		*sis,
 	struct file			*swap_file,
 	sector_t			*span)
@@ -717,11 +717,11 @@ const struct address_space_operations xfs_address_space_operations = {
 	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate  = iomap_is_partially_uptodate,
 	.error_remove_folio	= generic_error_remove_folio,
-	.swap_activate		= xfs_iomap_swapfile_activate,
+	.swap_activate		= xfs_vm_swap_activate,
 };
 
 const struct address_space_operations xfs_dax_aops = {
 	.writepages		= xfs_dax_writepages,
 	.dirty_folio		= noop_dirty_folio,
-	.swap_activate		= xfs_iomap_swapfile_activate,
+	.swap_activate		= xfs_vm_swap_activate,
 };
-- 
2.45.2

