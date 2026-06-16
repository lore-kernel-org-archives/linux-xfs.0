Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C723D8104
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633575; cv=none; b=IAmOjupAtP5djG2TY86kZZ4bH0OPju7fyDSHh1diBfFe4MDWkEYflRP56j3+1PXl87OHg59srOa8eBzjBXsSPMFBBDciGNYOg6fZTnqzAl0J2j+4kS2cQbzYfeYy/TfzP50Q399stDEFMl3yJxeMMSVraAcWkbdBuOH/sv4qTSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633575; c=relaxed/simple;
	bh=bGtbALp/PtECF7TzrppoH2zn0O5MlUxA6txSNjDqx/g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=n2cREnf5ivmXvOmKgdxJSW5T1cO2s3hzAGjSnsfclrx4DAq+H2BCbf3/yoYaVGMKAZXqSFxgroO2r46ZdFf/9YBFTgTlY1s8eYHM1SkO9s8ovmqZUI6bm7YxSV4RawAhyff71GJQxwjGIRP0wqwr4MHC8oa3lJWzxHWGh6xpw68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hm7u419+; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hm7u419+"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260616181246epoutp02d15f8dc153588281205c7b6857769b1a~5okoXKuwd2316523165epoutp02S
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260616181246epoutp02d15f8dc153588281205c7b6857769b1a~5okoXKuwd2316523165epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781633566;
	bh=Pn8kHlugm9wLeXOctq9lRNgyUbAgtz7Q5ZnWAI7iihk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hm7u419+hrt15/zAf3lZIQG+a11x9H7PcWHAvIQUS2eAH392VxKh1LScD9lsKCoJ+
	 AAxwIXZOfWU2woLiOauQqCCgWGvM5dP82lRgWzgIsWTXbeImukjyR9KUf80vPB2LEo
	 YLT9eGCHBD8kK+dFDMSBh3ssXSNuM3N8vOLwip2I=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260616181245epcas5p3ed8aaa0d85ad13212919ab40df6cc592~5oknf30ZB1246912469epcas5p3F;
	Tue, 16 Jun 2026 18:12:45 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gfw7w615nz6B9m6; Tue, 16 Jun
	2026 18:12:44 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260616181244epcas5p318804096b125c240c2155e54f76e2e07~5okmOD9XX2405524055epcas5p3y;
	Tue, 16 Jun 2026 18:12:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260616181242epsmtip10a6066beb76fdf0f08dd77dadd36f1d3~5okkacrRD0783307833epsmtip1e;
	Tue, 16 Jun 2026 18:12:42 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 2/6] iomap: introduce and propagate write_stream
Date: Tue, 16 Jun 2026 23:35:51 +0530
Message-Id: <20260616180555.33338-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260616180555.33338-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260616181244epcas5p318804096b125c240c2155e54f76e2e07
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260616181244epcas5p318804096b125c240c2155e54f76e2e07
References: <20260616180555.33338-1-joshi.k@samsung.com>
	<CGME20260616181244epcas5p318804096b125c240c2155e54f76e2e07@epcas5p3.samsung.com>

Add a new write_stream field to struct iomap. Existing hole is used to
place the new field.
Propagate write_stream from iomap to bio in both direct I/O and buffered
writeback paths.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/iomap/direct-io.c  | 1 +
 fs/iomap/ioend.c      | 3 +++
 include/linux/iomap.h | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b36ee619cdcd..455fd5d97d25 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -348,6 +348,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	fscrypt_set_bio_crypt_ctx(bio, iter->inode, pos, GFP_KERNEL);
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
 	bio->bi_write_hint = iter->inode->i_write_hint;
+	bio->bi_write_stream = iter->iomap.write_stream;
 	bio->bi_ioprio = dio->iocb->ki_ioprio;
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index acf3cf98b23a..56ed5ba6a421 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -164,6 +164,7 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
 	bio->bi_write_hint = wpc->inode->i_write_hint;
+	bio->bi_write_stream = wpc->iomap.write_stream;
 	wbc_init_bio(wpc->wbc, bio);
 	wpc->nr_folios = 0;
 	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
@@ -187,6 +188,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
 	if (!(wpc->iomap.flags & IOMAP_F_ANON_WRITE) &&
 	    iomap_sector(&wpc->iomap, pos) != bio_end_sector(&ioend->io_bio))
 		return false;
+	if (wpc->iomap.write_stream != ioend->io_bio.bi_write_stream)
+		return false;
 	/*
 	 * Limit ioend bio chain lengths to minimise IO completion latency. This
 	 * also prevents long tight loops ending page writeback on all the
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 2c5685adf3a9..44583429ffa4 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -120,6 +120,8 @@ struct iomap {
 	u64			length;	/* length of mapping, bytes */
 	u16			type;	/* type of mapping */
 	u16			flags;	/* flags for mapping */
+	u8			write_stream; /* write stream for I/O */
+	/* 3 bytes padding hole here */
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
-- 
2.25.1

