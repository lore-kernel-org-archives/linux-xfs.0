Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EFC322C99
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 05:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773034484; cv=none; b=DSCqUhjkXadpYf3sJndTLVORTljHEVtc3kc+qywtelHSbKAzdhQKC1Q8xEAio3pwG+fNJv+ePVOpzbyUcyrbFqohaU5081vkJWq8Kv6b9DbtUJ4Y6H/u7Jf4x1bob0jrs9OqgyFOO21YDyP1WEymUimOcH3JA7CsFP8Mee3V1nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773034484; c=relaxed/simple;
	bh=gjoh2aBUmwpTg5oa9Gc8Nq6R9oc6b3jqB6391/6635A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=f487GAimPpGQlhCM0BdDALPxv5LfUD+gyBMj70FKHcx/773RKUkfAzY++DqGG+YrKyFx25WDEhIH0oO10W3fBIP+pkwrUxtYyjnmIxgMiHi21RMCMcRahBG0bqJdR1OMmr9415L0QQAF1oomiCYtv8KUgsDuoLoeBiWRV6JG5JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JO/Y8BGu; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JO/Y8BGu"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260309053439epoutp04766e53c7aa667ab8d978c1ee3fa0cbbb~bFXb48rRy0325903259epoutp04l
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 05:34:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260309053439epoutp04766e53c7aa667ab8d978c1ee3fa0cbbb~bFXb48rRy0325903259epoutp04l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773034479;
	bh=NFPEB0YbFwrkO2+cZ3PSAuT4sZuEeXUeB09VRdcM7/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JO/Y8BGuFUShVXyEl8s6r7F+wwiHTvSFtd0ge91XgjqpHSf9XoHxAyMGwkCgZEUl9
	 82YK3DT45WhI4oWAdIO3m1zl9RXBlG//h1TQyrCqkzo9UyvNmSEZsmI0xY7htfLiP+
	 4KUR75zqmlmq5UYGYLdom6kHsT15Wa9GHRDNl9mg=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260309053438epcas5p4dd91c5b1eef04d3ac2fbaac41e6d9785~bFXbZy6un1828218282epcas5p4B;
	Mon,  9 Mar 2026 05:34:38 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4fTm0s3j8Cz3hhT9; Mon,  9 Mar
	2026 05:34:37 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260309053436epcas5p3cdfff99c945032dc50503774770f4317~bFXZug-bU3071830718epcas5p3R;
	Mon,  9 Mar 2026 05:34:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260309053434epsmtip204ca109b3b8216661863d102f25395e1~bFXXyxbiv1941719417epsmtip2k;
	Mon,  9 Mar 2026 05:34:34 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, jack@suse.cz,
	cem@kernel.org, kbusch@kernel.org, axboe@kernel.dk
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 5/5] xfs: introduce software write streams
Date: Mon,  9 Mar 2026 10:59:44 +0530
Message-Id: <20260309052944.156054-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260309052944.156054-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260309053436epcas5p3cdfff99c945032dc50503774770f4317
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260309053436epcas5p3cdfff99c945032dc50503774770f4317
References: <20260309052944.156054-1-joshi.k@samsung.com>
	<CGME20260309053436epcas5p3cdfff99c945032dc50503774770f4317@epcas5p3.samsung.com>

Even when the underlying block device does not advertise write streams,
XFS can choose do so as write-stream based AG allocation can improve the
concurrency and reduce interleaving of concurrent block allocation as well
as logical fragmentation.

Use a simple 3-tier (low/medium/high) AG count based heuristic to
publish streams. This enables logical spatial isolation for standard
storage, execluding rotational media and rtvolume.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_inode.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e93141d2cd8b..6c26cf03a261 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -44,7 +44,7 @@
 #include "xfs_xattr.h"
 #include "xfs_inode_util.h"
 #include "xfs_metafile.h"
-
+#define XFS_MAX_WRITE_STREAMS			(32)
 struct kmem_cache *xfs_inode_cache;
 
 int
@@ -53,6 +53,8 @@ xfs_inode_max_write_streams(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct block_device	*bdev;
+	int			hw_streams, sw_streams;
+	xfs_agnumber_t		nr_ags;
 
 	if (XFS_IS_REALTIME_INODE(ip))
 		bdev = mp->m_rtdev_targp ? mp->m_rtdev_targp->bt_bdev : NULL;
@@ -62,7 +64,22 @@ xfs_inode_max_write_streams(
 	if (!bdev)
 		return 0;
 
-	return bdev_max_write_streams(bdev);
+	hw_streams = bdev_max_write_streams(bdev);
+	if (hw_streams > 0)
+		return hw_streams;
+	/* fallback to software-only write streams, excluding some cases */
+	if (bdev_rot(bdev) || XFS_IS_REALTIME_INODE(ip))
+		return 0;
+	nr_ags = mp->m_sb.sb_agcount;
+	/* heuristic: 3-tier (large/mid/small) split of AGs into streams */
+	if (nr_ags >= 32)
+		sw_streams = nr_ags / 4;
+	else if (nr_ags >= 8)
+		sw_streams = nr_ags / 2;
+	else
+		sw_streams = nr_ags;
+
+	return min_t(int, sw_streams, XFS_MAX_WRITE_STREAMS);
 }
 
 uint8_t
-- 
2.25.1

