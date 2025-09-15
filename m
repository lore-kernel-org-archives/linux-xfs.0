Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A752A315D27
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942834; cv=none; b=GWhpSpAGp1YK0fXnMlDQJ8zhYiIgsSMlA4OIkS3r301EzhnIA+v1q3Jk6AvFTeypyZYw7xJzdzjdtmnnDK0nTFTy9jWiGTkLO27YyqfRXOzKUxx8pSdzBYhyr4UDsIspbTrgOrJgbEiuzC42M/QXbFWIZIbvKZU2FyJzjC7QVA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942834; c=relaxed/simple;
	bh=FYwWMfHv54gc8FM33EngmSNYPP2dMQV1iAfBKmphsVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1B+orPCrGtqFSgf2nUlhVBmZE3pUDO4IdqLq/lYwhTdtZlv+CJvxVIWu/NZZ6SYXSEefDRPh0JJCcnB6hHT8h1yV07ifaI5yUKffB9uCNVd8ApTvT/5sEYvTil9Edgx0wJM1G6F/H+wj3VqXRD+HT1Eg9PNBWt4x7Idgzj6j/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZBmn6tcc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZBmn6tcc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IalGRBF+twBXcp2DG0F1kL6TPChgGKYHHzcUB7FSXlA=; b=ZBmn6tccMvg1n7TEH6bV7ilNr9
	nyMhZJqi9mwV4It8c6YxM/JT+Cpge0Kxomc2S7j3SbqdRSPoI0fsQz19+LoJLWHkNZJFsx4cEsNnS
	Dk76nSHLGy2ESoFOHSQ8aOP6MRkv1HegEIE02amg3JxyAglSRDj+rW15ovE2qQSt1Lcbubbh2fUbU
	y163Mvln4+HOr4qrNEOHUaL76zWgOynKZRbKZs6J/hZijl8ZR4iNt+8WJtIhhqHnDAC1g1VWeDIHL
	JgecOFZjf7bn0cY9Cnf0orSBR7EjqH3ouwwIXkmo+gIlSNbP/50Q5nqfEFBXFRRq7lpYpyIEhP0/X
	LqSno0JQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ee-00000004Jbd-1Gzh;
	Mon, 15 Sep 2025 13:27:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/15] xfs: remove the unused xfs_buf_log_format_t typedef
Date: Mon, 15 Sep 2025 06:27:02 -0700
Message-ID: <20250915132709.160247-13-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915132709.160247-1-hch@lst.de>
References: <20250915132709.160247-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 754838518a2f..1417da3ced32 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -532,7 +532,7 @@ struct xfs_log_dinode {
 #define __XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
 #define XFS_BLF_DATAMAP_SIZE	(__XFS_BLF_DATAMAP_SIZE + 1)
 
-typedef struct xfs_buf_log_format {
+struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
 	unsigned short	blf_size;	/* size of this item */
 	unsigned short	blf_flags;	/* misc state */
@@ -540,7 +540,7 @@ typedef struct xfs_buf_log_format {
 	int64_t		blf_blkno;	/* starting blkno of this buf */
 	unsigned int	blf_map_size;	/* used size of data bitmap in words */
 	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
-} xfs_buf_log_format_t;
+};
 
 /*
  * All buffers now need to tell recovery where the magic number
-- 
2.47.2

