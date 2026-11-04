Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782778;
	b=FOYM5UsL0qNtcJxCjWv0jPErW2blywjidvxKKlHzf90nuttyZTuV1DhgfXJ8UrFDDfpd
	 87m6LylvoJv9mvR43iaWp0+9IyZOr/DfBy7pz5VNiFM7o9JfV2uMLHxD2z4aww29RWH71
	 uzmHuPVW4o4TLsZAR7e+FqAERbLYjQX4h0Kni6ECud7fl7I+tvyGeOzz5uw/IF3a5c7CN
	 Kkx8+ifjbcP/jifnBtE8QY8E3jxO/bxosDKaaFIA1W56cK1BoIyNz87jdb9f05vJ5MpWA
	 aW0LqLveBxOFDZtjELVzZ8h+d6cCPqV5hskfigUl9FwkfUzR2CVmmTYOYSCITxn08lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782778;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=iIIac8rRaPh4NN2FkWFeMGtRqRIOVgIqI12HcROzgLI=;
	b=2Uv0ouILxbkUu1XNMpm7Javo4sakL5uRVoi0LTi/2TXM4jrGZv7NRcc2Nji3/ZkgU7+I
	 BQVzJqXlv9ImOiaYcDlzkqFjhMJh3n+ZatW2G9APWNyLqlXaJQgkIIcx8ypgyG74hM3RS
	 U88B0vTWbWKsaXt83oI1bLb7yGT9GycisD2Xz74v5/SOqfeTGu7wNP1k1eZI5VLBxC6z8
	 Q/iVCiOKlchvcbAhyLWZcrWA/iAi06v1a7/PyCRkOHxo6JYz8T8TmxdCtd51wBJY6E+Tb
	 ve1pLyK5+WWgweO6DoTqZT4mg4k71NRIJILY1vE87QuzqRKLncnB9s1M9lBCfWzLVoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nXpC77wS;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946FE606A32E;
	Wed,  4 Nov 2026 08:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 946FE606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nXpC77wS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iIIac8rRaPh4NN2FkWFeMGtRqRIOVgIqI12HcROzgLI=; b=nXpC77wSJv8C5p9gNFnkYcHpMg
	5PT+So+i6+banEm8nw9Xh8VduOr1qlkUp+4N34Uyj+EZJ7V0iuyirH3rt1VigsPvoRN53Wp4pdjJF
	t9hmeSZ5ps68KzDoGNgXwPq8mUFD38acMz/rm3vPgG0wHVCQyED/YUelvZqMrXRvr90aASF+KZUAb
	GnXDpZKeuy9giecGMwIP5uq6OjC4b6VE4I3opcHFJy5Q9hgZ7sf/8UYLiNPKEl8Y7m8NzJXvnkcHI
	N9uXulWNu5NFqwscD5fbJqwalzR+T+pcdbQJP4zP90uhvpC+S8uJ5REXmlHBq21zg21ndbV61s3fz
	ezoKEuxA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqG-00000004oJC-1QER;
	Wed, 04 Nov 2026 08:59:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 01/25] block: export fs_bio_integrity_verify
Date: Wed,  4 Nov 2026 09:57:05 +0100
Message-ID: <20261104085929.317544-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Damien Le Moal <dlemoal@kernel.org>

XFS will need to call this in the iomap_write_ops.read_folio_range
implementation.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 block/bio-integrity-fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index c8e91ada8ca6..20d0a3d52932 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -74,6 +74,7 @@ int fs_bio_integrity_verify(struct bio *bio, struct bvec_iter *data_iter)
 		bio_integrity_bytes(bi, data_iter->bi_size >> SECTOR_SHIFT);
 	return blk_status_to_errno(bio_integrity_verify(bio, data_iter));
 }
+EXPORT_SYMBOL_GPL(fs_bio_integrity_verify);
 
 static int __init fs_bio_integrity_init(void)
 {
-- 
2.53.0

