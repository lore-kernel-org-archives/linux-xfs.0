Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD711B813
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275764; cv=none; b=MSZj8ayPV5NHCHVuG65dc2BWZEe0P/ooteHVZtzhYAuAFqfOz0LIEYFtjSWE3aY/1ER8SlFOYSXqdIQ85busnihyGy3/Br40XeT+KCh8v4Nma4SZHfHjUPmxYy3Gc6lZeuExdiCYIDiH+nqKiTklBeVHfXBmgE3vDnmn2LUzgZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275764; c=relaxed/simple;
	bh=0O3umDhpwBrYPcAB1MwVEbbSSCRQgaiOYi6s9Ly2onI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lB4KLWGlLodrOWQEelrXc7w+pj4SM5IH0tv2nSptKmlB59nG1IyvoKjKv4TXb1r0kNkp7YTBv6Tz7RdC58wXJODxm5XE8/YfR3Wq590jf3rqrtmt6aIUrv4ouxO/Qv0KP5bCyJgeX4PmZ+01ucyQohOR3cgIjMfrFAMUXSZtzug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jH19Kj60; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jH19Kj60"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=N3rE3t+7Sfh1ch+jG4/rL3OFi8MZBkGfEkeN2S3CLmM=; b=jH19Kj60uBDT5ZT7yUS36ynTVX
	cmD+U0mwww+RdyWA75x0RtpSmsuslCrGZVbWSAdM8/55p49Tc77N8oFKzsOHo6pQGPJuRyxxQkvLE
	QvkBzZtnVnWU9sMc44kK35fu+5k9buUPG28aqwHXTgvAaG1YhVhrnnjAAhSQuGGmeiXsaMrUrvwZ0
	G2PvG0AEf7veIxjQ1TmXlO1ee7RCEBnM6wrkCqjBv3Z3+XVcmOtlDnSEL4XlCRJRQMNvre6lkyLim
	yCgcL0EWFEACRe4+puqj0/shszRBRqMYMaOVC7pEDfEgc3jBaWn9a5mn5pm3wpUEp0nlXBpI3YG9V
	JWpJIosQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMGo-00000004Ccm-01iG;
	Fri, 26 Jan 2024 13:29:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/21] shmem: move the shmem_mapping assert into shmem_get_folio_gfp
Date: Fri, 26 Jan 2024 14:28:46 +0100
Message-Id: <20240126132903.2700077-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the check that the inode really is a shmemfs one from
shmem_read_folio_gfp to shmem_get_folio_gfp given that shmem_get_folio
can also be called from outside of shmem.c.  Also turn it into a
WARN_ON_ONCE and error return instead of BUG_ON to be less severe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1900916aa84d13..ad533b2f0721a7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1972,6 +1972,9 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	int error;
 	bool alloced;
 
+	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
+		return -EINVAL;
+
 	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
 		return -EFBIG;
 repeat:
@@ -4915,7 +4918,6 @@ struct folio *shmem_read_folio_gfp(struct address_space *mapping,
 	struct folio *folio;
 	int error;
 
-	BUG_ON(!shmem_mapping(mapping));
 	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
 				    gfp, NULL, NULL);
 	if (error)
-- 
2.39.2

