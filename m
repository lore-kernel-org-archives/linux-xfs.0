Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE18200A8
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324056; cv=none; b=MiR+rQQU6paZL6UttguGh8YHFmPP7vgXKecMeBVmcB7lErK4ogA7rwZT4dmyXJUYephgmwUgknYZbrztXhE2ySB0yL1IJvzh6fy5aP+LGuYOFRDShGwBpqAhBHNAs0zLX/Egv9laETo3DgfQ9tW8gL6FT8Sfq/fXvYbO6CE7Qw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324056; c=relaxed/simple;
	bh=OiRuYQv8KlX4oE0JEntn+ZL5FG5owlUlPQit+fW/9DE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pi+Ov1lcmm6OYwZHveESssQedSQ70X8ds6nMuc6mOyiTOarppbco6iXguTlp5Lk/gPRbXzKixu7DVZrtCO1Ldo53tIqyB6SLyfEcRwoJUepRxqGbzfl8mVOAoLUgNTa5myVy9AZWj4MdkqMRpo/LkR5qnsASZloX1Zp1HMyGMCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xUYvP8bm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xUYvP8bm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m8bNau9njavlNFAZK08RacrmSpqtfTJnRVvJoaaL3Z8=; b=xUYvP8bmy68OOaUGaiZ2KblmiK
	Q6infFV0+/plG4Pe9Q8zhlzEhPB323U+1SH228ltswSLMJzahDZdFotcxBQ4ym6dwwzEJNam+gqwy
	zXfe5poLm5sH4xqTHQTKZVBv4SGz1vof7MZXE8TNwvm0t8O5fFb2ht8JwUQm1W17+Ig8taf62QK4C
	L3NyW0Cjp+qxKNJGT+ehURX4TvSxLgAFGmxdfRwJyIMdDReWN0GwbRIVt+bqCFsXalyTNDMT/qoiW
	vuyQHh5P0dr/PE6oJzAFNqHJl5cT5ayNbEXTiiBpZEOKEWEw/WdTiLmExogVgLgX3s0wMEvYh2237
	TJqD93dA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7k-00000009F6h-0Pst;
	Mon, 19 Feb 2024 06:27:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 03/22] shmem: set a_ops earlier in shmem_symlink
Date: Mon, 19 Feb 2024 07:27:11 +0100
Message-Id: <20240219062730.3031391-4-hch@lst.de>
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

