Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA6376A06;
	Wed,  9 Sep 2026 06:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934182; cv=none; b=l6tr9mpPAwApKNTIYxnM41ZaV+/n3mesPdxy1w0E/c9YYymurtOD5z5BL9KA7K4jkYkjGEJRwmZK4zsa6w9eyh5txvKbkucH4E7/wyps0B33jDWI8DodcS9L2BVeeti4zrgDfRHdfPYib/i8pmT9BZWNYJKzMU+03bDxrXrkPtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934182; c=relaxed/simple;
	bh=eSdJxmF4qtKVb5F6qCXDPO1SptMEg9ej4+cbhdnUfrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB0ZCxfa/1A5Ii+PQkYTMuJwOyD1X2++8bGqTB6kG8raWlbMFaEdbNyr3a05RV227q0ElCiNMqW+Jn4U2VSiK9rJCi9bwVVQ3F7IIkpxz1P+RlPNnCiCn3SwZ22fZfXp9MLclGsS+BLyG3jSkfMPTLUE1U6952+frCgow/wa+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SXB3j+IK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SXB3j+IK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7NN4Voey1t++Xc37FHFZjkNHG/PbAtszZEutWmegmgk=; b=SXB3j+IKuTz17iBH+t1+be5Mfv
	uWLvMdJg/i941ZRB4A8p12dWpjuGLL2TRfJMShWvuOUzh+LgF5flGPEKTxCLTPCO5AGNIP/FX/uj8
	UaVNduFFIarmhqrqlhM7LBn79S0gbYXPrw5OOG+4IRCmHoH8b//p1/gy/4XGgHeJcIA5DiaFsI0cJ
	7px/hcu1X+Gu2VcsaMEUtRgxBhR2kvNc8+8dgt73fbxvmNwaC4H+h1Z3Vz6sc5cxUpXp6e6dSCxrw
	IOb3yu0EdDIgnLNz/AKbop8JmNSuLOXJB7zJBW2IEU77wzQJA8xnc7BIPuxkDY1zXHwr5LuoFA2in
	EtkBwdTA==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BV5-0000000Aqfl-2n2W;
	Wed, 09 Sep 2026 06:09:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 02/16] block: export fs_bio_integrity_{alloc,free}
Date: Wed,  9 Sep 2026 09:08:51 +0300
Message-ID: <20260909060924.1102037-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
References: <20260909060924.1102037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We'll move integrity generation and verification into the iomap
submission helpers, which means they will be needed in modular file
system code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 block/bio-integrity-fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 692403dfa047..4f67b34bf289 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -31,6 +31,7 @@ unsigned int fs_bio_integrity_alloc(struct bio *bio)
 		bio_integrity_setup_default(bio);
 	return action;
 }
+EXPORT_SYMBOL_GPL(fs_bio_integrity_alloc);
 
 void fs_bio_integrity_free(struct bio *bio)
 {
@@ -43,6 +44,7 @@ void fs_bio_integrity_free(struct bio *bio)
 	bio->bi_integrity = NULL;
 	bio->bi_opf &= ~REQ_INTEGRITY;
 }
+EXPORT_SYMBOL_GPL(fs_bio_integrity_free);
 
 void fs_bio_integrity_generate(struct bio *bio)
 {
-- 
2.53.0

