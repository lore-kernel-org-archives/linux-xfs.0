Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4DC200AC
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324064; cv=none; b=qvqYm129JJFZWOuZa5Ue17hOaLbTKF09t3HRBZC92tCgunkmhmDI0T6OvNO7wqZC04nxd9C27xGGENtgCp4An49z13FNiO8oQct6dEPpjqFMcFYOCIEKuyVGv5bglHjcfKmuc4OIySOoNOMEjjznDLRuUPA6huxgaSyiFTV68vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324064; c=relaxed/simple;
	bh=R07qcNCPlu/wrAuHSYgN6WL4/uBXFfy0t7FoR5qDQkc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nTdSU89rw5glv91b3sxxge07x5NFFGd+D0Ve2zz0cR15FfsNDe6UQBUyzj4uC3LT53nJQpJA/JiIlinGxoCb5ChPWZrdeCB4GjYIXS3gE2WfUR42kq5bI8KbavlEZ66Cem01O7nRG/Q9hTRiEWUgW1Q5zirYkIxhcNcIBxofBj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sqglayHM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sqglayHM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zrbE42e/OVazoBf8Nd73psWLWVAH63CkeaWayWbz09E=; b=sqglayHMnjeZktr2yE3GlcoLVD
	kmxvXFZHAbq73iU6WBOl4bqM6ih8JGhmWEcQWxcvM/vHyUHdHHsZPaVygaLDlQtHc3TbtX3c4Cc1O
	LN3EJAlnNDfFZ0WmacAHKayvz9aSwkNaG8S3MtacZVSsKqt4U7Hqcf4G+yKBjUGkLWhu7MJVLv2hx
	l7U5aMCGsmI6puL0/jEAYGjUhFmvE3QwixSp71lBRTRPzg/QiLDrpTvFoxZ/btPKF8avE86j8zFMl
	WL5t52+2LcOgfNutDItqffIz5j647Ku/8IHIB9kTgkexb3WfQEfhkd/kRsvWy7hP4031NU0h3lCd0
	jXEu9wow==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7r-00000009F8U-2tmE;
	Mon, 19 Feb 2024 06:27:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 06/22] shmem: export shmem_kernel_file_setup
Date: Mon, 19 Feb 2024 07:27:14 +0100
Message-Id: <20240219062730.3031391-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index aeb1fd19ea3f72..95e70e9ea060f3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4861,6 +4861,7 @@ struct file *shmem_kernel_file_setup(const char *name, loff_t size, unsigned lon
 {
 	return __shmem_file_setup(shm_mnt, name, size, flags, S_PRIVATE);
 }
+EXPORT_SYMBOL_GPL(shmem_kernel_file_setup);
 
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
-- 
2.39.2

