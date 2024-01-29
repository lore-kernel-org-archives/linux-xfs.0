Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D66965BA7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538919; cv=none; b=Brlq3hp5eumzQemkErdjuxWcLVpdQSoXquVnjBvb9uPOO0F1MranhrAY2yG1AoWeLt4BD0OD0/z9wdLhdEZVGeoua6Jk9RwYE0ITxFHRwEbPk4GCZNtsrADZbmHYyJqmi35QrCqj/s3Y9JJkrJpiz/GVTD214qI6PamXT1Ep/nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538919; c=relaxed/simple;
	bh=OiRuYQv8KlX4oE0JEntn+ZL5FG5owlUlPQit+fW/9DE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HjS8RBKAgxmyQnw5rzPOW6fFU1v3tTer7NXPokYjf8MEPRqK19mF9+icYKbBy1A1xUrfr/YBlUiPzbCmQkF81sk7H5Dnb/4o4athk53TJFFkPUYsP+JjCMN4+7tgsuRlHOH+PB5H58tCm6d4TsHNkAg5l/me3sUjLzWueLglIGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tZh4RayM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tZh4RayM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m8bNau9njavlNFAZK08RacrmSpqtfTJnRVvJoaaL3Z8=; b=tZh4RayMLGDoQRkvd8Hg0t+1Kv
	I48W9YLDAjraY8q9ek8/PmGGt0ycArACUm7FRgz74BLRwh8nyQR3jL09fw7Re5UstEhSLvSvLopvb
	zPzfJ4gUy6/2S8uZD5ChkpaRNEOQ4qE325YSzD5fexgdt8hoxfsyPIzgmaeZR+UFlo1BdiZJh2Gbc
	nz3v/spFo/dYrhPH1p8CoWFWf29nSZAA8G3YLoFJiWOzlhIHnrEGubomA5xm71S/mlCp1we6ZP5fP
	Ay739fM3+N+Y4zjkTWojQeFoQ8kxoiwsDevwbqRJv7xSVd2DchMNqpbjrFNRa9gETU1jh+wfzMyg9
	meCkoVgg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjE-0000000D66L-0Tvd;
	Mon, 29 Jan 2024 14:35:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 03/20] shmem: set a_ops earlier in shmem_symlink
Date: Mon, 29 Jan 2024 15:34:45 +0100
Message-Id: <20240129143502.189370-4-hch@lst.de>
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

Set the a_ops in shmem_symlink before reading a folio from the mapping
to prepare for asserting that shmem_get_folio is only called on shmem
mappings.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index f607b0cab7e4e2..1900916aa84d13 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3506,10 +3506,10 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		inode->i_op = &shmem_short_symlink_operations;
 	} else {
 		inode_nohighmem(inode);
+		inode->i_mapping->a_ops = &shmem_aops;
 		error = shmem_get_folio(inode, 0, &folio, SGP_WRITE);
 		if (error)
 			goto out_remove_offset;
-		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
 		folio_mark_uptodate(folio);
-- 
2.39.2

