Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA4E48E0FD
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983172; cv=none; b=jZkCifUk71Bcjzwtq2AgQVDwEe3Kttw3v0Whufm138FqFdLhOM5/aX4FC5SbTMk6eMMRSADoB6YZN2tqaC91u51u2pal+dDc7WfbXCY4w+cvlG4LagGgs4OjgezGE6GZU7BlpZm36G98JNO2Mvn2+YcAo/1EEgnAcKVmCS1Plww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983172; c=relaxed/simple;
	bh=CvteL92xIAlI8Bo+8BkfM608A31NpWvGSHOy8OFQKeI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uIUR9skBil6QJekIFJDmUgfm/VOFrgXqQ2PaxIkS2Wk+uYs3G+B2JCm3YXe5iVZPW/bpzMwp22vZx1H68xY6a2u1QuR4VG6Mj9c8yk74Z3o/qMRGDH8bo+TIfdDBgtjv/IAUyjaMup9iy3D6lBfnO7FPHj2qe8e3EOSJyulxJLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HeLG3A8q; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HeLG3A8q"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260921093248epoutp034b24b7a916198a54e306f8052a7a2538~XTDVBj5Hp0518805188epoutp03h
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260921093248epoutp034b24b7a916198a54e306f8052a7a2538~XTDVBj5Hp0518805188epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789983168;
	bh=BIaLx8MToKqqHtll3n4ENY65PLF9waN6hhaq4jCWEeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeLG3A8qlDT83JNjxC8l+GaBnGP56qqNQ8b5gUlj4VrPxCbywOW0rmTzV6VZi1Gu3
	 o9US8ENrmyxz5ipxzEN6Y0nnW2n3hD/bDUexElikB9aKZu3GLkxfEK0mPFg0iN42MP
	 /9BUeDu/R2wLbHc5WO/lBidNf1tQodzF7wa5lcZo=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260921093247epcas5p3992d9d3fd3005ca4a7fce9016e3b4164~XTDUQ3Rw92336323363epcas5p35;
	Mon, 21 Sep 2026 09:32:47 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hpJ1B4QHNz3hhT8; Mon, 21 Sep
	2026 09:32:46 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260921093246epcas5p270a7064df8313c4ca52bc761c1b51757~XTDS0xUnB0725807258epcas5p2N;
	Mon, 21 Sep 2026 09:32:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260921093244epsmtip180afff650f26953efdcadafd6cc40993~XTDRKApCb0536305363epsmtip1W;
	Mon, 21 Sep 2026 09:32:44 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v5 8/8] xfs: support hardware write streams
Date: Mon, 21 Sep 2026 15:01:47 +0530
Message-Id: <20260921093147.59935-9-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921093147.59935-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260921093246epcas5p270a7064df8313c4ca52bc761c1b51757
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921093246epcas5p270a7064df8313c4ca52bc761c1b51757
References: <20260921093147.59935-1-joshi.k@samsung.com>
	<CGME20260921093246epcas5p270a7064df8313c4ca52bc761c1b51757@epcas5p2.samsung.com>

Use the stream count reported by the data and realtime block devices
where they have one, falling back to the geometry-derived count. The
count is capped at the group count so that every stream backs onto at
least one group; a device with more streams than the filesystem has
groups loses the excess, so mkfs should create at least as many groups
as the device has streams.

Set iomap->write_stream from the inode so that the id reaches the
device.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_buf.c   | 7 ++++++-
 fs/xfs/xfs_iomap.c | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e84528b05cb..1748be9aa7d6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1709,8 +1709,13 @@ xfs_buftarg_init_streams(
 	unsigned int		nr_groups)
 {
 	unsigned int		nr_streams;
+	unsigned int		hw_streams;
 
-	nr_streams = xfs_sw_write_stream_count(nr_groups);
+	hw_streams = bdev_max_write_streams(btp->bt_bdev);
+	if (hw_streams)
+		nr_streams = min(hw_streams, nr_groups);
+	else
+		nr_streams = xfs_sw_write_stream_count(nr_groups);
 	return write_stream_pool_init(&btp->bt_stream_pool, nr_streams);
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7c6238fed61e..3e9df790a544 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -144,6 +144,7 @@ xfs_bmbt_to_iomap(
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
+	iomap->write_stream = READ_ONCE(VFS_I(ip)->i_write_stream);
 	if (mapping_flags & IOMAP_DAX) {
 		iomap->dax_dev = target->bt_daxdev;
 	} else {
-- 
2.25.1

