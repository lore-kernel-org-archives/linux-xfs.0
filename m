Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57CA14F70
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 05:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771219825; cv=none; b=qxcQSa6rqTK5F85p5rqT3CTnbx1FcesHAyIGRivyIgDbkWuiDZv0Zj8Cyujs5Y8jWuZx4GhRnKZeA0xUtgds3THb2OkA878usFWKo2t8Xlkz1QSMLNelwGUBTzVzoEpLGwiRuNZ3EZe5G9572Num4vbssn27QZFwYKqShsBg/u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771219825; c=relaxed/simple;
	bh=2S1Uqfq6crA0Tg9XHeAvte7p4aFJp+C1Vn0X879uJ5w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=AhJRoJim8ZB9KytimmeFqRkvhiJ2EptIDCIFEVfHPuI4S80EuExfwFYUohXSRhaGs0NYeyTzsII83EdSHoED5GvgNZ1/A2X/Fm/pWCL/1VFxnLclY7guivI9GoZDYHgkNS6YQ8tQAN8UtV3Muxlpob3bGV2Ga4XTjQIqIg+g350=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=B1b2z+T7; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="B1b2z+T7"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260216053021epoutp0219b68202297da9d1d4577ac176ddab9b~Uowsaev562229822298epoutp02A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 05:30:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260216053021epoutp0219b68202297da9d1d4577ac176ddab9b~Uowsaev562229822298epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771219821;
	bh=xg5zCaVrLFRJteK76DQu6a5unFnWHTutpcUCOUeBAeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1b2z+T79/7E/W48/P+m0kkjLOhkdKYjr1sEU5X/5ymkFBf77ZYBTMvgce2MEU/i3
	 W4GcSGczh+RruPIJ9q+2UsnVHsCSDaqBaFkWEtCYOP6UpPU3xRaET9fwQlgoKANIjT
	 vTtjwTccK1lKsRr7dW6jk5LAHiJECyPffCnxf1bA=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260216053020epcas5p3f67ad803eb1143d1d4405293359706a6~Uowr1zSJY1375013750epcas5p39;
	Mon, 16 Feb 2026 05:30:20 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4fDrvY6Rzgz2SSKX; Mon, 16 Feb
	2026 05:30:17 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260216053017epcas5p2d6492dd8c33c6d2453b15d79819d97eb~UowoNicVB0350003500epcas5p2f;
	Mon, 16 Feb 2026 05:30:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260216053015epsmtip18d14fb1eddfb8146485dcd3a5d64dc92~UowmxijSF1607516075epsmtip1B;
	Mon, 16 Feb 2026 05:30:15 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: hch@lst.de, brauner@kernel.org, jack@suse.cz, djwong@kernel.org,
	axboe@kernel.dk, kbusch@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH 1/4] fs: add write-stream management file_operations
Date: Mon, 16 Feb 2026 10:55:37 +0530
Message-Id: <20260216052540.217920-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260216052540.217920-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260216053017epcas5p2d6492dd8c33c6d2453b15d79819d97eb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260216053017epcas5p2d6492dd8c33c6d2453b15d79819d97eb
References: <20260216052540.217920-1-joshi.k@samsung.com>
	<CGME20260216053017epcas5p2d6492dd8c33c6d2453b15d79819d97eb@epcas5p2.samsung.com>

Add three new hooks in struct file_operations to allow fileystems to
manage write streams at per-file level.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2e4d1e8b0e71..ff9aa391eda7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1967,6 +1967,12 @@ struct file_operations {
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
 	int (*mmap_prepare)(struct vm_area_desc *);
+	/* To fetch number of streams that are available for a file */
+	int (*get_max_write_streams)(struct file *);
+	/* To set write stream on a file */
+	int (*set_write_stream)(struct file *, unsigned long);
+	/* To query the write stream on a file */
+	int (*get_write_stream)(struct file *);
 } __randomize_layout;
 
 /* Supports async buffered reads */
-- 
2.25.1

