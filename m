Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F0C470117
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046086; cv=none; b=NeiV6Qk+3YTNB015ZbgQoFZqGe/lRxvSa4ij+R5zMMdPFNx9KfiEYmInZbM0K4H/fxDygCycsSthdgTnZNi238LJLbxHt0NlvkAr8wV1c3KDsO0xxVR+5phul/5L+XzrBnRN4TLrA6UresdJGSnHt2UcRq9AIaFCsv7CGfvl1bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046086; c=relaxed/simple;
	bh=H+VsTCZHJUgsLO+Pe9IV5/Zsm/dNaXGlzFUjenPjcgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=UspMwuxLMIhaLYeN833dD0nxs31GwUPeZXpwg7ok9lMjvpKri1T19FwwWT1RdK6hIb9Fq1RrEOo8QGP/7x/BKzvJPODRwJXRnNukxoSV6v5TgLU1wGCAawXqgz8u1AkJ3STErK924u6M12WLGwdNlFoLOyoE90q8VRoo9UhRAuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PUc4Wc+G; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PUc4Wc+G"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261015063443epoutp031108a00b21a376811501a79570e154ae~eoGsQTvDF2310223102epoutp03M
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261015063443epoutp031108a00b21a376811501a79570e154ae~eoGsQTvDF2310223102epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792046083;
	bh=BNpdHtJixOW6lgJz3MrKaIRTUiVvFZknGcYMJ52YNj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUc4Wc+GieQ36mS4qmySh0kpS6pKa6ijnbh4VlkikXDccEPD6QC4Fxe8xe2crikoL
	 vtpsK/rpYlWODH/9RKHLsOB9/fliGiRO2pOCl993INar8D0BdOiad3vN8T5iVUex+y
	 1bRLZzU7bUjOG0wj9Z2gUExm6VFDOZ527Mhyd9G4=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261015063442epcas5p460fa543516650bdaf4010097370add0a~eoGrzs0uI2209622096epcas5p4E;
	Thu, 15 Oct 2026 06:34:42 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j4ywf1hSTz3hhT8; Thu, 15 Oct
	2026 06:34:42 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261015063441epcas5p23a5d6365ff5a5a4ac45dda0b24f92a3f~eoGquI8Ip2703227032epcas5p2i;
	Thu, 15 Oct 2026 06:34:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015063439epsmtip16cf5f96d4db7ae333141220a63784e34~eoGo3UVsx1173211732epsmtip1J;
	Thu, 15 Oct 2026 06:34:39 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v6 7/8] iomap: introduce and propagate write_stream
Date: Thu, 15 Oct 2026 12:02:45 +0530
Message-Id: <20261015063246.103433-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261015063246.103433-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015063441epcas5p23a5d6365ff5a5a4ac45dda0b24f92a3f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063441epcas5p23a5d6365ff5a5a4ac45dda0b24f92a3f
References: <20261015063246.103433-1-joshi.k@samsung.com>
	<CGME20261015063441epcas5p23a5d6365ff5a5a4ac45dda0b24f92a3f@epcas5p2.samsung.com>

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
index 8b4039d16ce8..eae8ebf627c8 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -318,6 +318,7 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 				  REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
 	fscrypt_set_bio_crypt_ctx(bio, inode, pos, GFP_KERNEL);
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
+	bio->bi_write_stream = iter->iomap.write_stream;
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
@@ -349,6 +350,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	fscrypt_set_bio_crypt_ctx(bio, iter->inode, pos, GFP_KERNEL);
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
 	bio->bi_write_hint = iter->inode->i_write_hint;
+	bio->bi_write_stream = iter->iomap.write_stream;
 	bio->bi_ioprio = dio->iocb->ki_ioprio;
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 7bbbb417f915..31a229c12b13 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -166,6 +166,7 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
 	bio->bi_write_hint = wpc->inode->i_write_hint;
+	bio->bi_write_stream = wpc->iomap.write_stream;
 	wbc_init_bio(wpc->wbc, bio);
 	wpc->nr_folios = 0;
 	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
@@ -189,6 +190,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
 	if (!(wpc->iomap.flags & IOMAP_F_ANON_WRITE) &&
 	    iomap_sector(&wpc->iomap, pos) != bio_end_sector(&ioend->io_bio))
 		return false;
+	if (wpc->iomap.write_stream != ioend->io_bio.bi_write_stream)
+		return false;
 	/*
 	 * Limit ioend bio chain lengths to minimise IO completion latency. This
 	 * also prevents long tight loops ending page writeback on all the
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc7ae6327dbf..f923778f08bd 100644
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

