Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D690C1428E3
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724411376; cv=none; b=QpazXjLu4pT2sowhBF5qaLTZX6BW+yTEJrIYZPzbvXvd0Jll6+BtjEybskycGwH9Grlx22DxwMntL7B/oj78p2TUnmDFWHUCR/13lnOQmdvkC2BpGcOPdvA63D0ER8AfG4YtkY1O1n7YntRSmekjI+5CPIKehs1IurPGwowoUkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724411376; c=relaxed/simple;
	bh=q8Y7RO1nKYnI2Jq5fKi7ENkb6cSqh/Fx37E52xrJyeo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JVVPtF5AbJyEmDGvAYQ+fzzo+haRTgFSPh8YhG78JSgpNos2tRv1UtNFAtMcLnWlcsXSVTqm64f7OwYSGsHbkagP57IXFLBq2lIX4VbmF0JKimVjdwxlvBpCh+ihPs5f6Lf9MOY4/oo3gdl2CX7ZiWKTbg1NIrqNdKMTDj6prwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wqy1P5Nm5z1HH3s;
	Fri, 23 Aug 2024 19:06:17 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D8D31A016C;
	Fri, 23 Aug 2024 19:09:32 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 dggpemf500017.china.huawei.com (7.185.36.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Aug 2024 19:09:31 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 0/5] xfs: fix and cleanups for log item push
Date: Fri, 23 Aug 2024 19:04:34 +0800
Message-ID: <20240823110439.1585041-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
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

Hi all,

This patch series fix some issues during item push, The following is a
brief overview of the patches, see the patches for more details.

Patch 1 : Simple clean code.
Patch 2 : Fixed an issue where the tail lsn was moved forward abnormally
          due to deleting log item from AIL before log shutdown.
Patch 3-5 : Fix log item access UAF after inode/dquot item pushed.


Long Li (5):
  xfs: remove redundant set null for ip->i_itemp
  xfs: ensuere deleting item from AIL after shutdown in dquot flush
  xfs: add XFS_ITEM_UNSAFE for log item push return result
  xfs: fix a UAF when dquot item push
  xfs: fix a UAF when inode item push

 fs/xfs/xfs_dquot.c      |  8 +++++++-
 fs/xfs/xfs_dquot_item.c | 10 +++++++++-
 fs/xfs/xfs_icache.c     |  1 -
 fs/xfs/xfs_inode_item.c | 21 ++++++++++++++-------
 fs/xfs/xfs_stats.h      |  1 +
 fs/xfs/xfs_trans.h      |  1 +
 fs/xfs/xfs_trans_ail.c  |  7 +++++++
 7 files changed, 39 insertions(+), 10 deletions(-)

-- 
2.39.2

