Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D240748EBC0
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983169; cv=none; b=gkNMikj0cLEJJ8XgD8QsczcZ/nNr2UFsczx5/U1wQpaE9J4WDY6J91xYG1mVbXtus+Ie4kyH6Mtu38IxyhuXqlgu4wUftnzvrMK7QOk9IGZUM1X9ybnPhSQ2bJupGYrlcqOjGd+khBHj5ZjWoL1oXVx3h6QLrrD8VfjXtQ32ADg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983169; c=relaxed/simple;
	bh=KkrNHFuWda4WDK3in+nNei1fA3IaX7jNBbpmewN+b+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nIKTzn8aC3tThmwSDQXkxbibdGyKKmO/8RfmPdIOTyEavmfuALWHlj+unnAGCkCJkI7VTagVhSNhMtf1x/8VO1SbAZf5dpV8f74MI+mKHL9uAihdSpt40U2F6ijvpNk5v7GbhbBrmodEXqqqe+esJZPu/gp2vO4qKosR9Tp6qFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BVOsXIwR; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BVOsXIwR"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260921093246epoutp02bbba71dba90b5697e3b23b2212c2c614~XTDS1AWIF1117411174epoutp02N
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260921093246epoutp02bbba71dba90b5697e3b23b2212c2c614~XTDS1AWIF1117411174epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789983166;
	bh=b3EmipzCDeygsKO8nKf/pwotVRZs32xx4eqUrlDTM9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVOsXIwRURdJPtu10W6SDoTgjP9endUc+2n2amfbckBo0LfbOFR7tHeDiDkgbXCb3
	 8xPdFe7ra7gZFRaEFN1i/pRe+MprdWhqFtZe159phqaZUwpkFidWg2NRnOzG3H8AGN
	 fHiMtrxd37GysWVF0MdRKee3Zhj/Ry+eHCtXCDwA=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260921093245epcas5p3f1f51b1abf75e695c8a6c654bdae6942~XTDR9OSrw2335623356epcas5p33;
	Mon, 21 Sep 2026 09:32:45 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hpJ183lJ1z2SSKd; Mon, 21 Sep
	2026 09:32:44 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260921093244epcas5p4adc575cb555ea3d0005fb9d147452cea~XTDQ66yOG0763107631epcas5p4X;
	Mon, 21 Sep 2026 09:32:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260921093242epsmtip1b4c0cdb0b6ac8613c40c37ef272f1a72~XTDPQZ6Np0536305363epsmtip1V;
	Mon, 21 Sep 2026 09:32:42 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v5 7/8] iomap: introduce and propagate write_stream
Date: Mon, 21 Sep 2026 15:01:46 +0530
Message-Id: <20260921093147.59935-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921093147.59935-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260921093244epcas5p4adc575cb555ea3d0005fb9d147452cea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921093244epcas5p4adc575cb555ea3d0005fb9d147452cea
References: <20260921093147.59935-1-joshi.k@samsung.com>
	<CGME20260921093244epcas5p4adc575cb555ea3d0005fb9d147452cea@epcas5p4.samsung.com>

Add a new write_stream field to struct iomap. Propagate write_stream from
iomap to bio in both direct I/O and buffered writeback paths.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/iomap/direct-io.c  | 1 +
 fs/iomap/ioend.c      | 3 +++
 include/linux/iomap.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b4039d16ce8..f406a7bc8804 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -349,6 +349,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
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

