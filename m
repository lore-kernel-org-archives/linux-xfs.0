Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FDC1F77AC
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 09:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731489709; cv=none; b=UWD2V1nCv9CTeEu/bCeCcq+NVsRNPC175FPShp1J5gnU/W/d39XmL8R6LiBkQjajn1EcY2LKRU+++M5gpgEk1SDaKoNs71ToWZR0KHIF/nIgO9j4qsDI3IasFehVdDUcsxiXNTSJZqit4Oc2EQOYD5XBALGXIUimwvAMdpQ3Y64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731489709; c=relaxed/simple;
	bh=TU5DrqFalqesnP8Ky6qfRhv5Aumf5V1cAEe95qZxczY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LfnvgsZjqrJUAXhAhin4cmfS+yQ1Lem6Xiv/LEqJLhSZfw4Pu2TNiEeCJctVxCwBSYS3SLeNm2prt2+HXQVq8Ii00B6nBenA20KtZyn3oGEhoI403aUMIDqjej7TBQ+cm2yOWnyET1+/cV4PW9wBb9gF2kVWpQOCmudxxe/pYWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4XpHq249l6z1ypcG;
	Wed, 13 Nov 2024 17:21:50 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 15CED1A0190;
	Wed, 13 Nov 2024 17:21:39 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Nov
 2024 17:21:38 +0800
From: Long Li <leo.lilong@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH v2 2/2] xfs: clean up xfs_end_ioend() to reuse local variables
Date: Wed, 13 Nov 2024 17:19:07 +0800
Message-ID: <20241113091907.56937-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241113091907.56937-1-leo.lilong@huawei.com>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500017.china.huawei.com (7.185.36.126)

Use already initialized local variables 'offset' and 'size' instead
of accessing ioend members directly in xfs_setfilesize() call.

This is just a code cleanup with no functional changes.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 559a3a577097..67877c36ed11 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -131,7 +131,7 @@ xfs_end_ioend(
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
 
 	if (!error && xfs_ioend_is_append(ioend))
-		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
+		error = xfs_setfilesize(ip, offset, size);
 done:
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
-- 
2.39.2

