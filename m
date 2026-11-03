Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705717;
	b=clOQJBHux9ESccVvkwgG7MLlCpFZ39zworWffabwE81j3eN3xq4F78IJhdJLX6V89ssB
	 oKPk/hL9LbLH44dY3u+vVjDTcvgLVrVoopp74db4FajnacDOSZc4uA4kQRRlzSQcDHtKJ
	 JWI1dQ40Qkj922DkSoq6ywy/e7626GsYWZdhS5zR1YWUpsyClj/o5uK3oS5TzeiI3luYP
	 h+95n+bleGQUBWn5go3ASbhfTqTTimAu5phkEZchDJkGnCJjzP83tBTvHyUsJrwgeJTJY
	 p+75X5dRWCNuRnlrTimIMZuORBjXn5VEK0FPuX3iTU8tj1C0ywBH2IA2iZTg38et57g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705717;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=3g5pikwtjAXZR6/IflZC3DaQOMmtFWyrNtRbG7lfsyM=;
	b=jxPtz2J9dPvG4OuhxZE3QjRE9yc2fxYSvpWkowStDoQd4UDskX20wmjYkr3FNHX4zfbg
	 JQAC6Qb8KmVM7eYiSr/84JpKt8lzqPsFlXS7cEcaHTE64eToxcN21FLtWBck19XcP1HRU
	 UhE7H2Lvx8QYPhaoWjz4psUYKGWFFojKqV3VbnWudJEw0hbGxFqhcJ8dD9hJhyu9m3jDK
	 VxDhCBg48+Y6M1f7kuJdOQ0YtHERal7iPOcnSmgFNXm0cu95DLH/80BLgofwZrnHIInaG
	 gZ/5R0fh+kY4GCFPxp2FaPp22kM7zLgAOFJOS8W4D34Xd2f+b6cGqVh+kg5iQsJBWlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=INkmSt4s;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6781A606D817
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6781A606D817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=INkmSt4s
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261103113514epoutp02836e04aed926af69d95b024e05820b48~khdgUxg4g0922009220epoutp02M
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261103113514epoutp02836e04aed926af69d95b024e05820b48~khdgUxg4g0922009220epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793705714;
	bh=3g5pikwtjAXZR6/IflZC3DaQOMmtFWyrNtRbG7lfsyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INkmSt4s+UNwhI3deuhOdSHTaadGX+2+3EioWkG0uJJLU8YLGlBBDNdWnlVJwLqLS
	 gjm2b3OPSK16nims5umFPOWXhUI/TTjh6Y8Oo2eZZCM3bBt7+6yn7upK+UkqJ0OPa9
	 EUpMpdbAS3URj+Kw/9RAvT7LOD0Ma4HHgs1NrBko=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20261103113514epcas5p1be52f5f599a7e3b9a8b3d322d69925c2~khdf2EzMs1728717287epcas5p1y;
	Tue,  3 Nov 2026 11:35:14 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.89]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jJmhd3SYtz6B9m6; Tue,  3 Nov
	2026 11:35:13 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261103111037epcas5p489e91004bb54794d6542a0a650de8568~khIA_bqUo1773117731epcas5p4N;
	Tue,  3 Nov 2026 11:10:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111036epsmtip15e53f481ec0e39bd561d93cbad0019d3~khH-OJKxb2883528835epsmtip1T;
	Tue,  3 Nov 2026 11:10:35 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v7 7/8] iomap: introduce and propagate write_stream
Date: Tue,  3 Nov 2026 16:36:39 +0530
Message-Id: <20261103110640.1000095-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261103110640.1000095-1-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261103111037epcas5p489e91004bb54794d6542a0a650de8568
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111037epcas5p489e91004bb54794d6542a0a650de8568
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111037epcas5p489e91004bb54794d6542a0a650de8568@epcas5p4.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

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

