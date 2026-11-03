Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705720;
	b=YCKwVn+MGISmjvzUHk3Uw3Iys02Qp6chntqu/BcZb1ThBeCREixwB4YzSYvhzSeVXem0
	 Ks3ypST5XgE6UCxrLivMEgiunEW4jcehqGzu0UD/cnPBZb9HaFCUr3BMvbiE+YmsoUPL2
	 l34BBOzyP2GniqMoQ3SCcnxtRZz2YZM6Xt756cTleRcr9YYh5jO+vQl7g282foqbjcuht
	 4pVLP8LN7aYA/l0tqv1rHa4jbsSPhCH8BmXUHwLgcBWm86UhiTNu93niT2wNZ5BOrCQuD
	 ORPEZR2S8mjVphqJeKf+KamdYkRMMFM6ZNizFVecFHcBbnRod5qN2mSjKIu9mfER4PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705720;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=yOHgOKVVrAnZwvqX0b+HwaBJS8g19XVDczb/De2t6XQ=;
	b=csAURM7KfsWjmiHl5DXxrn4QMkkJl/KrZFO5FwwwmDOu4T3ChCoOi/X1PUzu6TEpUWgW
	 gZPz1hf7mN0uCGnVLDKAONfor8iS501QnqzxOTHBLOIwbR51SWTlEiLG4L+hZfRArG1ju
	 0wBZHNf2U6DMuI6X36zBBh14g/+abrccFFUHtsugVgarY16SO/Yl4EBnJirLkgYPkAwmG
	 1w0zqTbPWFXz///BBXRKk3h6X/Jg9wm8W0o96INhDlttUzzZ2we2G7wq32hdDErJmhhPW
	 9a4dURQhjFAtNbrJ3b0KM5Dss/D1m89GmTdq4R75koXecod28H79QzimQhhRBkmV01A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="cx6/VZXU";
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94023606A33C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94023606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=cx6/VZXU
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261103113517epoutp021b4aa27f4542486166bd88fc25fde83f~khdjHnDUP0809008090epoutp02Q
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261103113517epoutp021b4aa27f4542486166bd88fc25fde83f~khdjHnDUP0809008090epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793705717;
	bh=yOHgOKVVrAnZwvqX0b+HwaBJS8g19XVDczb/De2t6XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cx6/VZXUiNgip72YhhrHmLixYlsJhBVE0aOjZVIkvb944ZuaLgRpN28iT4bc5RWhY
	 570eVwRozHsU+4aGP7l3eZklnbiGMFsFmkkyv6C8GG9HmqDlL3WeRCm9HeP/pbT1S7
	 4KErm7fQKQ0NeZEBR7g4WOw0J5LwJWhP0LZkbpek=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261103113516epcas5p228118e7ca1ecf863b1be86a246602f11~khdh-g2z_2045420454epcas5p2a;
	Tue,  3 Nov 2026 11:35:16 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jJmhg3vypz2SSKZ; Tue,  3 Nov
	2026 11:35:15 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261103111040epcas5p4551a5991750e8fc65847ac9041756cfa~khIC60K1y1738217382epcas5p4Q;
	Tue,  3 Nov 2026 11:10:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111038epsmtip1ebf075ae36a8f308134b40223bb53747~khIBOXv9w2961029610epsmtip1Z;
	Tue,  3 Nov 2026 11:10:38 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v7 8/8] xfs: support hardware write streams
Date: Tue,  3 Nov 2026 16:36:40 +0530
Message-Id: <20261103110640.1000095-9-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261103111040epcas5p4551a5991750e8fc65847ac9041756cfa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111040epcas5p4551a5991750e8fc65847ac9041756cfa
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111040epcas5p4551a5991750e8fc65847ac9041756cfa@epcas5p4.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

Use the stream count reported by the data and realtime block devices
where they have one, falling back to the geometry-derived count. The
count is capped at the group count so that every stream backs onto at
least one group; a device with more streams than the filesystem has
groups loses the excess, so mkfs should create at least as many groups
as the device has streams. It is also capped at U8_MAX, the most
streams the block layer can tag.

Set iomap->write_stream from the inode so that the id reaches the
device, but only when the device has write streams. Otherwise, for
example on a partition of an FDP device, the id names a software stream
and must not be taken for a placement handle.

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

