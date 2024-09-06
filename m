Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774CA5FB9C
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 06:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725603385; cv=none; b=HcTU4bXHnJ90UHY2fzC58S16K46JqH1jXqChvb6/dsRBR5zEVfH8pPs9Dd/RCM9GpUwruDp3MfhcKBpYPoGqpna47QQoSJGeM1lTgIouEWo5yCgJRwqYfN8I1HWQrNWwKpB5BzaLFqyu76lpqaQ5KScHT2moeILQr7+317PZEn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725603385; c=relaxed/simple;
	bh=fKKmyximnW8NbbY+vZbJ+Kl3P7Vrc3ExN1ew/hkFD5I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k7yoXNMI6/hxLDiYjAPeHA9xNjUdG3md2d1x0tU59I+F/FpNbhTT2AhEJn3Gc4q7Ic+ogEQEPBjpp3OqlO9HY/eGGwhTTq//zB9N/o+E+8Sx6uvwhl2y4vC/GHaB+L8+ZUlbxNdRxN7+A2+W1Ui257CwIhoqsp9umowaCn8g6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4X0Qpf0kzdz20mgx;
	Fri,  6 Sep 2024 14:11:22 +0800 (CST)
Received: from kwepemf500003.china.huawei.com (unknown [7.202.181.241])
	by mail.maildlp.com (Postfix) with ESMTPS id 28DFD1400DB;
	Fri,  6 Sep 2024 14:16:21 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemf500003.china.huawei.com
 (7.202.181.241) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Sep
 2024 14:16:20 +0800
From: Zhang Zekun <zhangzekun11@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>
CC: <chenjun102@huawei.com>, <zhangzekun11@huawei.com>
Subject: [PATCH] xfs: Remove empty declartion in header file
Date: Fri, 6 Sep 2024 14:02:43 +0800
Message-ID: <20240906060243.4502-1-zhangzekun11@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemf500003.china.huawei.com (7.202.181.241)

The definition of xfs_attr_use_log_assist() has been removed since
commit d9c61ccb3b09 ("xfs: move xfs_attr_use_log_assist out of xfs_log.c").
So, Remove the empty declartion in header files.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
---
 fs/xfs/xfs_log.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 67c539cc9305..13455854365f 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -158,6 +158,4 @@ bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 
 bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
 
-int xfs_attr_use_log_assist(struct xfs_mount *mp);
-
 #endif	/* __XFS_LOG_H__ */
-- 
2.17.1

