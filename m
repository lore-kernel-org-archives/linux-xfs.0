Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D4931960A
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 05:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773034484; cv=none; b=Lj6HRNFfi7o8IABpK/e8S+lM6GmQUk0a0p/DmLt+NFaiPX4GOKTdMyQo4oAFhsSMwS4gIIScOxzyJ+qwXDNhhGOcAnWbhIxpqCnel5VO0LPU0WV4/cNm1/lXZbJBusaY/Vwj8L8KORNpsonyNc8epgXlP/ptbq4Icdlk5gDwE8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773034484; c=relaxed/simple;
	bh=WWb2RdHEM9qosKfkPMuU44SZxHLp0wZCvSFiF3ptktE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dVvYLFU7znnSztili1Avjt4bEcs/OQXXhcXLXvqXchEnYC58pGOTh5R7JBouMkX+yodfHx5V04ACN0Ei4DaTOe2hBrIy4UxaAZFnmChACO+307N28L6dIzWt/YkM26hE/yFB+ILHz9YXfeq7obAgaXs9L7Bh4faDWM5A/md852E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gx5kHYvO; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gx5kHYvO"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260309053432epoutp010e9d76f99f51704b5477d6ac01a0f547~bFXVha0iR1015310153epoutp01k
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 05:34:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260309053432epoutp010e9d76f99f51704b5477d6ac01a0f547~bFXVha0iR1015310153epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773034472;
	bh=ZV7vHGKd86ci7tpJDG93f/uO4dpBPLwF2oya7Gr7xdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gx5kHYvOU9+DdTrz7wKjZEtnFShm5ULhhAIWSnLMMH1FIYSqiIVZIa5OXVRui0AC7
	 7u7niLRm2D+P+4zUXVkrZZalt09p8OFe35pDl4LGSboRfkKirrHA3eyzD8ouguODrw
	 C1D7ux3l0xcjLiuf13fGnUv6aGkD8rD9RT5ESzC4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260309053431epcas5p27498b8d52a211b6118f8f235fd85f713~bFXVFmpyb1306813068epcas5p2O;
	Mon,  9 Mar 2026 05:34:31 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fTm0k4F5Lz6B9m9; Mon,  9 Mar
	2026 05:34:30 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260309053430epcas5p3db87d346a4a816f385becac0212cd3ab~bFXTqvKty0574505745epcas5p3B;
	Mon,  9 Mar 2026 05:34:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260309053428epsmtip22aeedc1cbf50ff6356776ca293f5cfdc~bFXRz95jM2004820048epsmtip2S;
	Mon,  9 Mar 2026 05:34:28 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, jack@suse.cz,
	cem@kernel.org, kbusch@kernel.org, axboe@kernel.dk
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 2/5] iomap: introduce and propagate write_stream
Date: Mon,  9 Mar 2026 10:59:41 +0530
Message-Id: <20260309052944.156054-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260309052944.156054-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260309053430epcas5p3db87d346a4a816f385becac0212cd3ab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260309053430epcas5p3db87d346a4a816f385becac0212cd3ab
References: <20260309052944.156054-1-joshi.k@samsung.com>
	<CGME20260309053430epcas5p3db87d346a4a816f385becac0212cd3ab@epcas5p3.samsung.com>

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
index 95254aa1b654..086530c0471e 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -333,6 +333,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 			pos >> iter->inode->i_blkbits, GFP_KERNEL);
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
 	bio->bi_write_hint = iter->inode->i_write_hint;
+	bio->bi_write_stream = iter->iomap.write_stream;
 	bio->bi_ioprio = dio->iocb->ki_ioprio;
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 4d1ef8a2cee9..6a9c8e0c7536 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -159,6 +159,7 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
 	bio->bi_write_hint = wpc->inode->i_write_hint;
+	bio->bi_write_stream = wpc->iomap.write_stream;
 	wbc_init_bio(wpc->wbc, bio);
 	wpc->nr_folios = 0;
 	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
@@ -179,6 +180,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
 	if (!(wpc->iomap.flags & IOMAP_F_ANON_WRITE) &&
 	    iomap_sector(&wpc->iomap, pos) != bio_end_sector(&ioend->io_bio))
 		return false;
+	if (wpc->iomap.write_stream != ioend->io_bio.bi_write_stream)
+		return false;
 	/*
 	 * Limit ioend bio chain lengths to minimise IO completion latency. This
 	 * also prevents long tight loops ending page writeback on all the
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 99b7209dabd7..e087818d11d4 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -113,6 +113,8 @@ struct iomap {
 	u64			length;	/* length of mapping, bytes */
 	u16			type;	/* type of mapping */
 	u16			flags;	/* flags for mapping */
+	/* 4-byte padding hole here */
+	u8			write_stream; /* write stream for I/O */
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
-- 
2.25.1

