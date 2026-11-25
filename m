Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595752;
	b=JZuOjfKQ1MTTNi9meWU5rNz9TQ6B2vJgg88R2CNZIE5u0FnMLKRWZj0ESnkwQ+MX0+5a
	 Ji7uehGGo7sYKM/WyBZLXsYBKPTAEWNBpFda2npoAv/pgAxVQ7i9ki606I90tHRpRGhvP
	 znQObm9VCIXGPxiuzFPR3HkDdC7Sqa8T59vs1HQDBCqUUReC8rzH35ESonU2JyyRJ7w+n
	 JRccfh8yY3lI+nJjLtSmdqwkoroaxP+1UcbMuVEZuI9gB8X/PmSsKDsgHbVZE+KMvpWeH
	 oqrK6troFp7ZZar/ohLPTZV7xnAKquMgUgkH3djr+sXT1M724FVfhSOjOu219se+I+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595752;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=ve/ljQIy5CpcYYNIJckKc8AnyilCdBOcjIPhHcUKNgk=;
	b=1tYodc0nXpbtBk1rRRaNNOuRZhKlIjDWN5rqFe6JwJz/75ko9OuQ4dlbqxmBwibLdkKe
	 q9RxO3kuR+QqRMhiXV04CpncQ2uexjwoM+9zKZikWZSiOO77CfSQJZsWDdmtkkjaAafOV
	 PnOyIEgA11zHwkjnXyQOmrymLCn0s/vyBNEONEcwvy1Wj5g55tlX7+aLVtTmboef3Pugz
	 TRzoo0XAxxIwUHRG66xV3gmpEyiG5RJBNgILCOdIvzVKL4JqzCWX72rreVbILV2fayhb6
	 fe/4j/BLStOAxWCkPPxwi/GJK97INt+hIovh4EtU0cpBmmwfQ+RdRAleQbwyozXPa0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Hl5o7IMz;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBE6606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DBE6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Hl5o7IMz
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261125083549epoutp021d839f2d21dc5c03656b04b282c901d2~rPNIqfDfe2293022930epoutp02I
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261125083549epoutp021d839f2d21dc5c03656b04b282c901d2~rPNIqfDfe2293022930epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595749;
	bh=ve/ljQIy5CpcYYNIJckKc8AnyilCdBOcjIPhHcUKNgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hl5o7IMzfOZADAGNIPE8CjSYgzUnwXOHmlsdhpLbUEQRbtCeOzO+AIoX7tDYbcy7D
	 OzZLsH092KsT5NiU6ws8ZeKLtZyeuAx2J/dRKX/R3lxyyrVCdVE5hPZytVs08klvYq
	 DrDSxQF5+cekSWglFbIgiAOavTCV9iyOUhYNfiz0=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261125083549epcas5p2086d2ae04230049afb03064478be28ee~rPNIQgEf73005230052epcas5p2u;
	Wed, 25 Nov 2026 08:35:49 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jZCgS4lYhz2SSKb; Wed, 25 Nov
	2026 08:35:48 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261125083547epcas5p24b542d1cd460dd41bc8c072872caf4ca~rPNGs-ZdF3005330053epcas5p2v;
	Wed, 25 Nov 2026 08:35:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083546epsmtip14f7da7838f5cc55d3d72a50ddcb05639~rPNFNVkgI0496704967epsmtip1M;
	Wed, 25 Nov 2026 08:35:45 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 8/9] iomap: introduce and propagate write_stream
Date: Wed, 25 Nov 2026 14:03:12 +0530
Message-Id: <20261125083313.106334-9-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261125083313.106334-1-joshi.k@samsung.com>
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
X-CMS-MailID: 20261125083547epcas5p24b542d1cd460dd41bc8c072872caf4ca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083547epcas5p24b542d1cd460dd41bc8c072872caf4ca
References: <20261125083313.106334-1-joshi.k@samsung.com>
	<CGME20261125083547epcas5p24b542d1cd460dd41bc8c072872caf4ca@epcas5p2.samsung.com>

Add a new write_stream field to struct iomap. Propagate write_stream from
iomap to bio in both direct I/O and buffered writeback paths.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/iomap/direct-io.c  | 2 ++
 fs/iomap/ioend.c      | 3 +++
 include/linux/iomap.h | 1 +
 3 files changed, 6 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ad041ac3252a..fe27cacd73dd 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -326,6 +326,7 @@ static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 				  REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
 	fscrypt_set_bio_crypt_ctx(bio, inode, pos, GFP_KERNEL);
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
+	bio->bi_write_stream = iter->iomap.write_stream;
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
@@ -356,6 +357,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	fscrypt_set_bio_crypt_ctx(bio, iter->inode, pos, GFP_KERNEL);
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
 	bio->bi_write_hint = iter->inode->i_write_hint;
+	bio->bi_write_stream = iter->iomap.write_stream;
 	bio->bi_ioprio = dio->iocb->ki_ioprio;
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 4da248ff99f8..72a116f77cee 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -123,6 +123,7 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
 	bio->bi_write_hint = wpc->inode->i_write_hint;
+	bio->bi_write_stream = wpc->iomap.write_stream;
 	wbc_init_bio(wpc->wbc, bio);
 	wpc->nr_folios = 0;
 	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
@@ -145,6 +146,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
 	if (!(wpc->iomap.flags & IOMAP_F_ANON_WRITE) &&
 	    iomap_sector(&wpc->iomap, pos) != bio_end_sector(&ioend->io_bio))
 		return false;
+	if (wpc->iomap.write_stream != ioend->io_bio.bi_write_stream)
+		return false;
 	/*
 	 * Limit ioend bio chain lengths to minimise IO completion latency. This
 	 * also prevents long tight loops ending page writeback on all the
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 5254430844b2..8969eb7bb065 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -133,6 +133,7 @@ struct iomap {
 	u64			length;	/* length of mapping, bytes */
 	u16			type;	/* type of mapping */
 	u16			flags;	/* flags for mapping */
+	u16			write_stream; /* write stream for I/O */
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
-- 
2.25.1

