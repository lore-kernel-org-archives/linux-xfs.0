Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595754;
	b=M0UCTA+vGIjz1mAK96AuVJAx5iJnCb3uHCssRTB3z4dD7Tg1UpqCLKHnLMYEy4m9ZrJx
	 1PfYYk0CtqOlp4GByXHnPRiJ25mmJS8QE8jXgzGV++4tYNHUA2R1XMDKL1s8kauL5nFwq
	 qagP1B6guvi2jI1VizEBvZWaqYvDGDOcCg9e3+9g4PivuHTVkkxS3xdGW4zBhS9PmdaI0
	 pzv12SgmoYov5pf0Cxw4kbPxJ0EFmh9TW1wi0MchEd6bxnB412UcGhMl5aroZQxtNxF7V
	 vkimKnn9r0wmW+Xcxu0RWLzf/99V0BhvYTz1sxdd05udb+D+enTY/JgBmz2CkEaFewg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595754;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=VWQ/lsKjZNhGOhoE2VNJ2uZg4zN7u4SrYf62+pN9Mcs=;
	b=GgXe8iHOLmGId4YBNye55uIAnCRi69hfHZlCEn/i1oeJwuVi2Sx4KMdz9Lfvt85YCNr0
	 iR+85NmD4ZfE3OOqCBpeLMMECzuvwdksBBDf1uRpM/M6WYJFgL0/WHT0w+xqjhZKLzpqU
	 S9SfFtLMINlIRmGKGCUw/L3BR5pdKeda8THUheFjyHxQl7iQ+G3gF6bxW/YaMzVSaiyvL
	 D4sVuPNvnjuT6A3hvixXiiKd+tCy6wghiMjDgY/hQI+prSDVwboMdlqZ1vYWWAICO7v4i
	 mhitGhT2luT84vSxNyqfTGNzjFsWOL2z3IsrGlEQrRkiioIXFuTQVNB9wHuy7jsaqnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=SeTdKDsK;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DC7606A329
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44DC7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=SeTdKDsK
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261125083551epoutp02d4be5c063e90d23ab3bc46e75dfea457~rPNKcS-sm2297522975epoutp02L
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261125083551epoutp02d4be5c063e90d23ab3bc46e75dfea457~rPNKcS-sm2297522975epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595751;
	bh=VWQ/lsKjZNhGOhoE2VNJ2uZg4zN7u4SrYf62+pN9Mcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeTdKDsKNeTPydB9fZKAUvDbVa0/hRl/s1oUzeQ66qxpq9TdFyNTmvqErtgfJWRid
	 vnGdxqTqQ+Nq7tk+bdMDwwd4V12h3y+lMqJK5VqI+gkK00uUMCNdF5mX9aTOVqcw30
	 oHvL9256knEI451TWbbsU/GlF8+PndOnZjf5nHnU=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261125083551epcas5p2ebe50a815bfb7de79f0beed0514e0f56~rPNJ5m7543005330053epcas5p27;
	Wed, 25 Nov 2026 08:35:51 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jZCgV14dJz6B9m4; Wed, 25 Nov
	2026 08:35:50 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083549epcas5p145b41e9d633820499173c72018414f29~rPNIb4fQf1553115531epcas5p1v;
	Wed, 25 Nov 2026 08:35:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083547epsmtip16592c9d78525628e66799458821ab22c~rPNG76rXQ0455204552epsmtip1L;
	Wed, 25 Nov 2026 08:35:47 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 9/9] xfs: support hardware write streams
Date: Wed, 25 Nov 2026 14:03:13 +0530
Message-Id: <20261125083313.106334-10-joshi.k@samsung.com>
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
X-CMS-MailID: 20261125083549epcas5p145b41e9d633820499173c72018414f29
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083549epcas5p145b41e9d633820499173c72018414f29
References: <20261125083313.106334-1-joshi.k@samsung.com>
	<CGME20261125083549epcas5p145b41e9d633820499173c72018414f29@epcas5p1.samsung.com>

Use the stream count reported by the data and realtime block devices
where they have one, falling back to the geometry-derived count. The
count is capped at the group count so that every stream backs onto at
least one group; a device with more streams than the filesystem groups
loses the excess, so mkfs should create at least as many groups as the
device has streams.

It is also capped at U8_MAX, the most streams the block layer can tag.

Set iomap->write_stream from the inode so that the id reaches the
device, but only when the device has write streams.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_buf.c   | 8 +++++++-
 fs/xfs/xfs_iomap.c | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d8ce03a9f49c..41c543e132cb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1711,8 +1711,14 @@ xfs_buftarg_init_streams(
 	unsigned int		nr_groups)
 {
 	unsigned int		nr_streams;
+	unsigned int		hw_streams;
 
-	nr_streams = xfs_sw_write_stream_count(nr_groups);
+	hw_streams = bdev_max_write_streams(btp->bt_bdev);
+	if (hw_streams)
+		nr_streams = min3(hw_streams, nr_groups,
+				  XFS_MAX_WRITE_STREAMS);
+	else
+		nr_streams = xfs_sw_write_stream_count(nr_groups);
 	return write_stream_pool_init(&btp->bt_stream_pool, nr_streams);
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 329c745e3120..f0d191891a06 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -144,6 +144,11 @@ xfs_bmbt_to_iomap(
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
+	/* software stream ids must not reach a device without streams */
+	if (bdev_max_write_streams(target->bt_bdev))
+		iomap->write_stream = READ_ONCE(VFS_I(ip)->i_write_stream);
+	else
+		iomap->write_stream = WRITE_STREAM_NOT_SET;
 	if (mapping_flags & IOMAP_DAX) {
 		iomap->dax_dev = target->bt_daxdev;
 	} else {
-- 
2.25.1

