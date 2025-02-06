Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6426224AF9
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738822525; cv=none; b=NqXggFwVRWgYEnfgJ29mfffQxvVMJ1zA3pFK6ynCYaH02VZrd37fxlEKH1yB1oBcpRxcpEXh3QPyzpDvgfe5fHzHbhpjbfcJqXo3r3Xg9pVEW0Jqg181tQ9GZpS8e9ud7zRv+kfH0gausVyU5WzSFNthHbAQmR2y1bBuoinSZPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738822525; c=relaxed/simple;
	bh=GAYkTd78uBU0vPFRO+OuiRO6xkUxlIDobnRx2LWfwnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQpQlVR6d9vY7uorwMQcqGx25jlwoAQOEs/pOlRYYtecEBPkdIoam2PN5hGMpS2PurYWLvLoQR+zU/reePIG310Byi6cYnWFiuUG2fV1VSDQtg6o15Tbx2bl/Hj6Ds1o3YH7/2QpEo/APdJgUl59vSnPNf8yLObfzUfrKxZqnoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B7rZKsL/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B7rZKsL/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PIIjDHCQcEQxvX2dGsJuWv0PPN5e7MQWTQkLfMCHHdg=; b=B7rZKsL/ueuIY5Gl5+phMcqgq3
	+opiZdG1PrunGQ4l5OYmUR7NhLk82ZJPVtoxCohRvSsWN/UH6hXBDLBVi/1SnVGLXISFzqZhCl0Il
	3nWPO2UNlYyUjwlTjRufbPFz490zkMc6H3D0W/g3TfXv4NdnM0cagl/gDtFmvkmxZSEeiWc0uXSxZ
	fP+VXpYai/86LtpVG00Raguv7GtMjrmY7I5qgjdhJ/PG7bKN1JPxv2CoIvEIUoe1KxsXK7QFnYtdp
	zndJ/k/G4wCnYUHaxFkWm/V9+p85v+A63z6Gxn3S3PbnFQ/j3D3B1xqyZZih5kXWcXjsmvLB0y5Ij
	T5oLnJiQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvAY-00000005Mi0-2mTV;
	Thu, 06 Feb 2025 06:15:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: rename xfs_iomap_swapfile_activate to xfs_vm_swap_activate
Date: Thu,  6 Feb 2025 07:15:01 +0100
Message-ID: <20250206061507.2320090-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206061507.2320090-1-hch@lst.de>
References: <20250206061507.2320090-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9ff1a0b07303..fb99b663138c 100644
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
@@ -734,11 +734,11 @@ const struct address_space_operations xfs_address_space_operations = {
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

