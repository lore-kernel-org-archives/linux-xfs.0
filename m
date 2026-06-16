Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C14047B42C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633579; cv=none; b=IRfZbtmQSUpkt1YRmwN7tC58UG0hT0hogJoiLArPDGbJ/YTZEhAMwLZcrFZbCwT83B1Z2Ey87ROXMEPC4d940HVxN58Kp3tNcfPHbapUvHF6FEXLuaybO+6OA8aEyZjnNPd1eVvO5tpSRL/CktJCG0YxMwRMYaWS6rMjirxonPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633579; c=relaxed/simple;
	bh=fHGZuwbZwe8u2aq3t9mT9Smsjpuqm7+QoAqTHWbXDYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=LUXb8PTTQ7NLRUNIaj3qnx8psP4cu+dGe4D/k7S/F/y88xsPnG2Y5hDLWF2Sr8tMCmWGK7MP0DWsl+8zzzkGvGAJ0HMSn61M9te0t6FH/chjUKoqvUm5OjaN5YfTg7hTj9sVKeSAd87Q0ZCKI5jrxeMOE2XvpBcRSvXpH18uySM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=i93GnJa4; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="i93GnJa4"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260616181255epoutp04ee41829c63f55b5e5653ab42094256ee~5okwvq4ER0241702417epoutp04O
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260616181255epoutp04ee41829c63f55b5e5653ab42094256ee~5okwvq4ER0241702417epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781633575;
	bh=gb30r2inM25OKn9pEp4wraeOHcYG2I5NnvabRp/eOXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i93GnJa47uwezqVLCmdW98leO7bQU9/My6aytTZ00y+phpNRB2IXzHNWef/V/H/ju
	 3rhZu3m9/GuOhs30T5dcAsTc+ezUzuZ7TwT5APo3gGcdXtQmexiasQ2ZwH6DGQaGpF
	 avuVvVn/2j20b1h5QcTqpPfe0U6xDKal+2m2jaQk=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260616181255epcas5p492026b342503e1f9fa210894583f5c22~5okwQ62Da0246302463epcas5p4K;
	Tue, 16 Jun 2026 18:12:55 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.87]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gfw861g60z6B9m5; Tue, 16 Jun
	2026 18:12:54 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260616181253epcas5p382d4c14e3d3c2ab9a6ef52f650e456ea~5okumpeso1541715417epcas5p3T;
	Tue, 16 Jun 2026 18:12:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260616181251epsmtip1cfd2e2f1d1d072f53f6301b5fb8e418d~5oksy71Tw0265902659epsmtip1k;
	Tue, 16 Jun 2026 18:12:51 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 6/6] xfs: introduce software write streams
Date: Tue, 16 Jun 2026 23:35:55 +0530
Message-Id: <20260616180555.33338-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260616180555.33338-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260616181253epcas5p382d4c14e3d3c2ab9a6ef52f650e456ea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260616181253epcas5p382d4c14e3d3c2ab9a6ef52f650e456ea
References: <20260616180555.33338-1-joshi.k@samsung.com>
	<CGME20260616181253epcas5p382d4c14e3d3c2ab9a6ef52f650e456ea@epcas5p3.samsung.com>

Even when the underlying block device does not advertise write streams,
XFS can choose do so, as that enables logical spatial isolation and
dynamic AG-set based concurrency for the standard storage, excluding
rtvolume.

Use AG count based heuristic to derive AG set size and software streams.
Larger filesystem (i.e., more AGs) get wider fanout (i.e., larger AG-set).

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_inode.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2e7c61d71b48..10ffed130dce 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -45,6 +45,7 @@
 #include "xfs_inode_util.h"
 #include "xfs_metafile.h"
 
+#define XFS_MAX_USER_WRITE_STREAMS		(16)
 struct kmem_cache *xfs_inode_cache;
 
 int
@@ -52,12 +53,34 @@ xfs_inode_max_write_streams(
 	struct xfs_inode	*ip)
 {
 	struct block_device	*bdev;
+	struct xfs_mount	*mp = ip->i_mount;
+	int nr_streams;
+	xfs_agnumber_t nr_ags, ag_set_size;
 
 	bdev = xfs_inode_buftarg(ip)->bt_bdev;
 	if (!bdev)
 		return 0;
 
-	return bdev_max_write_streams(bdev);
+	nr_streams = bdev_max_write_streams(bdev);
+	if (nr_streams > 0)
+		return nr_streams;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return 0;
+	/*
+	 * Enable software-only streams if hardware streams are not available.
+	 * This helps to
+	 * - improve isolation; reduce allocation interleaving.
+	 * - improve concurrency using AG-set based steering within and across streams.
+	 */
+	nr_ags = mp->m_sb.sb_agcount;
+	if (nr_ags >= 32)
+		ag_set_size = 4;
+	else if (nr_ags >= 8)
+		ag_set_size = 2;
+	else
+		ag_set_size = 1;
+	nr_streams = nr_ags / ag_set_size;
+	return min_t(uint16_t, nr_streams, XFS_MAX_USER_WRITE_STREAMS);
 }
 
 uint16_t
-- 
2.25.1

