Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E26182A2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XniNRlGp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JlH8UoH4gf0aBQ2yCBHbzkzUIg8ZGDdici8nR6/XNN8=; b=XniNRlGp7AkbZwALFoj2xvXQnH
	vPjeUfHlMb/q3zWmlZnIKQd2+AhipEq0AZ6VRzSPPbH4l2wvCPEMVQr0UsJxiri77g/VS34FQSX1g
	dqGZOGTTWh1fIa1XiGqZ8nADwC/L5Yq1PgFG7fQq650+EypgpZITgP2HmrqKmQW34myrNmhghWcrO
	vPH+ufeoy3igPt4HF8hdf8dvxVi0qWJR8/hCnwMS0IKq3NFrXsekcarEER0wl4iGHtcVOWkZ8rahz
	tyuiw6lyqNOWyU4JmZU2z5COeDjvufmF+I9E7j8rpm1wJgxv3NNducuerNKI09/fVpdEh6zprmnTA
	7Ic53zBg==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwon-00A6Y4-0n;
	Wed, 03 Jan 2024 08:41:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/15] shmem: export shmem_get_folio
Date: Wed,  3 Jan 2024 08:41:13 +0000
Message-Id: <20240103084126.513354-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103084126.513354-1-hch@lst.de>
References: <20240103084126.513354-1-hch@lst.de>
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
---
 mm/shmem.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3349df6d4e0360..328eb3dbea9f1c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2116,12 +2116,27 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
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

