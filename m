Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FBE15351B
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538930; cv=none; b=GG8ZXQXZaprnIFUBooTUv6+vLFgi158VBWlWoFPWF8Obq9jzEPm1MtRinSQMw2j1fHksSZ6boS8Ri1yCt4KmMjvD5m820nnaspGp5YJidO5MSclWFissXWc6woJ+U+1nZ1n2z0xsNgsMcx72FJxB3JiTa9CzMDTGbROcEjOoIc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538930; c=relaxed/simple;
	bh=v3ncVI9KaGl6mCObmPUg5GIQB19MKg2sjYweLTbjjmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pQSuv+YA9T/IaVufD9B74ClX+Q74tVLL6AgrP+s1G4OADl1oog7KQoRBcXjhpwAgkupqnsmj9A/dlMYRNw7UZL38U5EyIYKGCQ9ZfQ0EqiltSwaPikcbBCDH6GagZwfJ455gzJ5e///q/PkkzUOvohHR1itt48q0L4Zyny9+Gns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OS98c4u6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OS98c4u6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Mb0aKytFq1BGb2HbWrZKS2O+ruK+bI9H1a6C537e2bg=; b=OS98c4u60FTr62PDOGi7enyjZK
	xFXKPLlrimdvB2Iu4fpeltNoMQ2ZC9g1x7jRTBgyNUqupRnsfGawClI8K//Q7U7ki+gOEzcMmXDZx
	KmLXLMElm44yX2DCrBeGpGjgabWiVCJJ34xQRVUsk6fbAz/7Lw+9NyUjPnXjSW1Dd02/E9HEl9Zr8
	MVC31vAdt7xB8N1LsrPdhlQ4fHaYflH5XPOKBVmhmtS//lHZcq+dEyH71ytQQHzBWZ95vRGQRq7Sj
	5pgCMxOInG3gOFVxzhTJ1rjkjWmRPxKvuOLpEFut7zP5598KykeJFd/DiWTCGAsBAQ8FVHn+4zvI0
	txVJ7Z7A==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjO-0000000D6Bk-3Mce;
	Mon, 29 Jan 2024 14:35:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 06/20] shmem: export shmem_kernel_file_setup
Date: Mon, 29 Jan 2024 15:34:48 +0100
Message-Id: <20240129143502.189370-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

XFS wants to use this for it's internal in-memory data structures and
currently duplicates the functionality.  Export shmem_kernel_file_setup
to allow XFS to switch over to using the proper kernel API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index dae684cd3c99fb..e89fb5eccb0c0a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4856,6 +4856,7 @@ struct file *shmem_kernel_file_setup(const char *name, loff_t size, unsigned lon
 {
 	return __shmem_file_setup(shm_mnt, name, size, flags, S_PRIVATE);
 }
+EXPORT_SYMBOL_GPL(shmem_kernel_file_setup);
 
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
-- 
2.39.2

