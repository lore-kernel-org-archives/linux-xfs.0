Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732351B813
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275767; cv=none; b=dFIn1pJd6vEWe99ueWil2k66QGkVqhPCb5XeefBlFK+XtmKDu83kuBw8E4rGYUOC9ncTRuHcuGlffll+hsVxxVyeSWqX2BbT8mN4/bhtKrsAGuZ3GafUH/psRqFTaB2s70feV2MZuUmUS9uoIbaQlFPIB8yLqwoYDOqhi6cYubo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275767; c=relaxed/simple;
	bh=gv6xQKtOAkUvIwMLcWRV1dpVo86a1Ilisg8/TOPHN9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iix0X7FKm5L0/BLWBZmg0YiWkhbw+hEtiyea35CH+LA4nU/8WycXAPUlHhswB2nBgRSHtxPQUdDAi3uh+gNq86tPbwQaKXJF7c8e/mRVB40i5z5TG48yBH+IhK6zs+TDc5RReg/CV+pq3HtGs5Z42lVKYpcQVxsnlZZZxAgNBa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pum15BU6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pum15BU6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EXl5jDeu7XONmlWbPRrm0Xu8RAKAjEJ+6x3o+QggOTo=; b=pum15BU67e0aLpR1792YzR24oi
	MBaFfufHtCKkulLHA2z5SDqiyeUyDGOqykVa+NNtXdh7PNligs40WxGAynkcqKEJlXH4gbMBOARtv
	GRVUyHmGU/VqlPahIeBYDKyBRl7QUKQU0nFYi01Ic7e4cbH9acLTb2nBIRGxGdnW+oC1xSGSDhU5s
	rnVDBPv6nK+lRLt0CxXB6om0Czr+Ylfytg6QF1d8YX1TqaLJeYa2XMtRrGcWKyhoWm5iWzB5n76n7
	jzpRM5Z9aTH5QS+ToEDinsikPO9sOsZZDWXVZqAj+dy2scmGcWaZ4ycSS21fnFlZhP+TQh+/uDm3O
	Sv3vMLDQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMGq-00000004Cdo-46Cv;
	Fri, 26 Jan 2024 13:29:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/21] shmem: export shmem_get_folio
Date: Fri, 26 Jan 2024 14:28:47 +0100
Message-Id: <20240126132903.2700077-6-hch@lst.de>
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

Export shmem_get_folio as a slightly lower-level variant of
shmem_read_folio_gfp.  This will be useful for XFS xfile use cases
that want to pass SGP_NOALLOC or get a locked page, which the thin
shmem_read_folio_gfp wrapper can't provide.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ad533b2f0721a7..dae684cd3c99fb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2137,12 +2137,27 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	return error;
 }
 
+/**
+ * shmem_get_folio - find and get a reference to a shmem folio.
+ * @inode:	inode to search
+ * @index:	the page index.
+ * @foliop:	pointer to the found folio if one was found
+ * @sgp:	SGP_* flags to control behavior
+ *
+ * Looks up the page cache entry at @inode & @index.
+ *
+ * If this function returns a folio, it is returned with an increased refcount.
+ *
+ * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
+ * and no folio was found at @index, or an ERR_PTR() otherwise.
+ */
 int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
 		enum sgp_type sgp)
 {
 	return shmem_get_folio_gfp(inode, index, foliop, sgp,
 			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
 }
+EXPORT_SYMBOL_GPL(shmem_get_folio);
 
 /*
  * This is like autoremove_wake_function, but it removes the wait queue
-- 
2.39.2

