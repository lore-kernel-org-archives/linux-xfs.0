Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C16E183CC3
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046089; cv=none; b=OGrjPlWSeeQuuGacnZi0Z4Z+1lu7sHPpufldXhqYaLeYfIfzTeqAZ4fMxIsm60qntxxgCQ+KUXO1pARkQZHLrfLz4An2RqTpOizEYATkbSD1O6ohGKHldij7Lo+P6mWu/4+RZrs2pUziyEpIAv26PYULlegO6Yobm30JOKWAZyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046089; c=relaxed/simple;
	bh=fD3XE7+a5cdy9Sl3VK5T+JRMNubQ+PyjBv0NxAzoJUw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Rq89KKernrwf8PetDqOGwLLbS5GjMSFeecRQRhC/NF7xkxu+UOiXcACAGCwnEhF5Fadb/mu/9MFC0DXcqyiVNC92X7e0xLG5tR96w//6+KQc/l26pqlpvtXgYM0RFi6UsLpqM3nZa/TDoUlDwTqr6Ip5YJlNI+JaMNbtlY9pDSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mG3AyjPT; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mG3AyjPT"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261015063446epoutp01094ed452e5529842e0fa92fdc70b4b73~eoGu_vebC1854718547epoutp01M
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261015063446epoutp01094ed452e5529842e0fa92fdc70b4b73~eoGu_vebC1854718547epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792046086;
	bh=GV+MlYtgZFwQaPzixkYPLweoy22qTG3JY3F2M/0gE30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mG3AyjPTD6COF1kz8P1pxGcrcjOlvzxYvMKq31Gei5kHJHMw+FImHCNXX/Bm4ecNZ
	 uiy9ZPPAmvPTdf2aPMPIlXj+NRVYZZxRZQz4NEK7MNwIDgPRVaL6ety0HUQIfa6SH3
	 CrGAv0V8GKNuU5XMqMTa20zrmh5OmEoGMWLRW01o=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261015063445epcas5p3f92844a7345cc39e5f4e1c13db152ae7~eoGuVMQ283173331733epcas5p3H;
	Thu, 15 Oct 2026 06:34:45 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4j4ywh4WV0z2SSKY; Thu, 15 Oct
	2026 06:34:44 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261015063444epcas5p3263a59092e6dc54ff61ac5b35827f697~eoGs1_xwC3173331733epcas5p3F;
	Thu, 15 Oct 2026 06:34:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015063442epsmtip198c209240a349d25a1a57c30f628c7ca~eoGq-Xw2X1173211732epsmtip1K;
	Thu, 15 Oct 2026 06:34:41 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v6 8/8] xfs: support hardware write streams
Date: Thu, 15 Oct 2026 12:02:46 +0530
Message-Id: <20261015063246.103433-9-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261015063246.103433-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015063444epcas5p3263a59092e6dc54ff61ac5b35827f697
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063444epcas5p3263a59092e6dc54ff61ac5b35827f697
References: <20261015063246.103433-1-joshi.k@samsung.com>
	<CGME20261015063444epcas5p3263a59092e6dc54ff61ac5b35827f697@epcas5p3.samsung.com>

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
 fs/xfs/xfs_buf.c   | 8 +++++++-
 fs/xfs/xfs_iomap.c | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a96f67630362..e1b67d0b2aa9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1710,8 +1710,14 @@ xfs_buftarg_init_streams(
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

