Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E34E13C918
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 02:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735612750; cv=none; b=VYZm4rT1DGxjkQTCc5QcpOpOQd5txaRuJLzmH/Mlx4ZzQrjywez3ck3uvkovIuxfX/T/10QuiUJLCWJhwthfrGrQXi1w4Q4bqwE2rI0psKRgi0j2GJ3GQRM7v54Y8AwSJp1tNg1qxHscE6VMCI+ll5wRArcdAFdDh767a6HzcMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735612750; c=relaxed/simple;
	bh=2rGgJ60G6X8IrnrWY19/+DjpZNy4yXARhWYKUKF1iZE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Onl1YvQy6RdjYaHDYv/6G1r8oWv/K5opUSoCG+fxFNeSzbgbYtMwh8cQhEjZyNdEUn/pWPLFOmfBsarl3QTIIiUmqPRQwpfsW7cUqGntQXYcqCukKfShVIVohkhCn1/jXVCg8WDmtGgQxj/oSdzi/3ZMrQQp7qioyxnpQFpT+SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YMcbT1vCLz1JGff;
	Tue, 31 Dec 2024 10:38:29 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 99B5D1A016C;
	Tue, 31 Dec 2024 10:39:05 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 31 Dec
 2024 10:39:05 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not support rt volume
Date: Tue, 31 Dec 2024 10:34:22 +0800
Message-ID: <20241231023423.656128-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241231023423.656128-1-leo.lilong@huawei.com>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf500017.china.huawei.com (7.185.36.126)

When mounting an xfs disk that incompat with metadir and has no realtime
subvolume, if CONFIG_XFS_RT is not enabled in the kernel, the mount will
fail. During superblock log recovery, since mp->m_sb.sb_rgcount is greater
than 0, updating the last rtag in-core is required, however, without
CONFIG_XFS_RT enabled, xfs_update_last_rtgroup_size() always returns
-EOPNOTSUPP, leading to mount failure.

Initializing sb_rgcount as 1 is incorrect in this scenario. If no
realtime subvolume exists, the value of sb_rgcount should be set
to zero. Fix it by initializing sb_rgcount based on the actual number
of realtime blocks.

Fixes: 87fe4c34a383 ("xfs: create incore realtime group structures")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 3b5623611eba..1ea28f04b75a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -830,7 +830,7 @@ __xfs_sb_from_disk(
 		to->sb_rsumino = NULLFSINO;
 	} else {
 		to->sb_metadirino = NULLFSINO;
-		to->sb_rgcount = 1;
+		to->sb_rgcount = to->sb_rblocks > 0 ? 1 : 0;
 		to->sb_rgextents = 0;
 	}
 }
-- 
2.39.2

