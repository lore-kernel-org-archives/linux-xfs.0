Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A447D3FAE0C
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293002; cv=none; b=RkouoIQh5TL/iuH8V1Q1PZwd8m6qMu1UbCYgvrcB2IApjJ62lha7IIQ37OKmCLgdmnjGHs/zyu7qsjAxS0P6MGh4UaITVnAi/DhoIc+ByGl3cU8vkt4ZyBqlyJEAqUu0t2L3tax8OfB+B6k+eBJnRz488MmNfrjGl2ZazzsX3jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293002; c=relaxed/simple;
	bh=LcygAO5eYE4EGFv7udID9rGj3qDnf3al/NMz8bFPlcg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bJ8I4565n/cpw2GgN3I1a4iNamVIc7VioM/opK3PbvWtid458u0rr3j9eZNKax2/fqEhIBwnWuEMGNNqWTxFvJUS/1bq1x3mfmrHbqUhcdNUE0Lo812dXd+lv+JsrEnVM4p82btlliVvrC88mAnTuZdlxdtne+pNtb3J3Rz75AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Al5KViI+; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Al5KViI+"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260717125632epoutp02687b560f255d514cce8fa6ac0f22ebae~DFQXpvKW63089230892epoutp020
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260717125632epoutp02687b560f255d514cce8fa6ac0f22ebae~DFQXpvKW63089230892epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784292992;
	bh=u7QmUTrANUZMp+v3inIoxHzFt55POwZ12RGxl6WmS9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al5KViI+kYSPj0VvFD92nnBtPCPWVTAHHpfxDg+c4X04uB/JMl/d788j4Bca4I4W9
	 jULn0tktt2fw86nDfmFx9ps/KdmQjHvfhQC84qqwlbdNPIQSDi5Q5qB07yrp8NqGjF
	 4EsFmsm9n2xSk6MGYPFYQCrI0n3+iw6hCQzZboFQ=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260717125632epcas5p3023ab9ae8ddf7d44a6fe9fb956c89cca~DFQXMenhW1956419564epcas5p3E;
	Fri, 17 Jul 2026 12:56:32 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4h1qfl0RCkz3hhT8; Fri, 17 Jul
	2026 12:56:31 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260717125630epcas5p362b2f527ed32de9cd4d59a89bc6d64e2~DFQVvM67M1965319653epcas5p3C;
	Fri, 17 Jul 2026 12:56:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260717125627epsmtip228b7732d86c393cfef5d36160fe693da~DFQTNq3QH1798617986epsmtip2M;
	Fri, 17 Jul 2026 12:56:27 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v4 2/6] iomap: introduce and propagate write_stream
Date: Fri, 17 Jul 2026 18:25:34 +0530
Message-Id: <20260717125538.508925-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717125538.508925-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260717125630epcas5p362b2f527ed32de9cd4d59a89bc6d64e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125630epcas5p362b2f527ed32de9cd4d59a89bc6d64e2
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125630epcas5p362b2f527ed32de9cd4d59a89bc6d64e2@epcas5p3.samsung.com>

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
index e2cd5f92babe..b7771a25c1c7 100644
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
index 0565328764c1..5ea2c68993cf 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -165,6 +165,7 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
 	bio->bi_write_hint = wpc->inode->i_write_hint;
+	bio->bi_write_stream = wpc->iomap.write_stream;
 	wbc_init_bio(wpc->wbc, bio);
 	wpc->nr_folios = 0;
 	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
@@ -188,6 +189,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
 	if (!(wpc->iomap.flags & IOMAP_F_ANON_WRITE) &&
 	    iomap_sector(&wpc->iomap, pos) != bio_end_sector(&ioend->io_bio))
 		return false;
+	if (wpc->iomap.write_stream != ioend->io_bio.bi_write_stream)
+		return false;
 	/*
 	 * Limit ioend bio chain lengths to minimise IO completion latency. This
 	 * also prevents long tight loops ending page writeback on all the
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 56b43d594e6e..4dc71da598f9 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -132,6 +132,8 @@ struct iomap {
 	u64			length;	/* length of mapping, bytes */
 	u16			type;	/* type of mapping */
 	u16			flags;	/* flags for mapping */
+	u16			write_stream; /* write stream for I/O */
+	/* 2 bytes padding hole here */
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
-- 
2.25.1

