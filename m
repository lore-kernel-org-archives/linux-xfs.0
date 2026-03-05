Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34BF245031
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 08:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772701166; cv=none; b=BupI6YK42qwE9DsrHEUgvVOxIB7gNjzAoLLzxCU6MbwpEeiCPaeog9Ex2YXgSpjq8c2DteO6fIL2ik//VO1/DEb5dao8frt3blwQaoYDobg51zMUVICdLdDEqRTvKJlq5x845bO/CI3/inecwBKma+rUyb/tM/lswLZZBq0v/X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772701166; c=relaxed/simple;
	bh=OUkfSEzaWG+A8z/v1pgoSZwLnL+MnEXZudQu4KzjvMw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BChr16J9MnB9N2ueEsQs/N+zAYIPMQwQa9mRoAJTN0QQDI+V3ibi3eauSXvBU1q/ZRBFd1hrgQsnFp33tdn3/Aqntv4omWkMl+NZjtmtYjREZq0YHjTiqmIqe/3xwCliB8okqxlluDFBZXXp7VZdvTV2JMEYc66kTnwlBbIEZwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=RWGAblqe; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="RWGAblqe"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WMAbf8w4W0XfIjzUnS/iJsbAErVP1jbi46nXbGVGxtQ=;
	b=RWGAblqeJKwpqM+s0WQyEOCGqdMMi1yN9An/3liudkLrhM7OJRkv51y3flbCdjCoHoR42Ajel
	K/siFISh8TS8wxqWDhnSg5cHOUw6Af+DMkVglTtku6oPx2982xnMs8mpCf5mjebEBWiXpNvO54X
	1Hmb13B6SibiXz5WWjYCtio=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fRNdL20W1zRhSc;
	Thu,  5 Mar 2026 16:54:30 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 43F9F40561;
	Thu,  5 Mar 2026 16:59:21 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Mar 2026 16:59:21 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 5 Mar
 2026 16:59:20 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 0/2] xfs: code cleanup and item deletion fix
Date: Thu, 5 Mar 2026 16:49:20 +0800
Message-ID: <20260305084922.800699-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

This patch series contains the first two patches from the previously
unfinished patch set [1]. I'm resubmitting them separately since patch 2
addresses an corner case issue that should be fixed. At the same time, I
rewrote the commit message and comments of patch 2.

Patch 1 : Simple clean code.
Patch 2 : Fixes a issue where the tail LSN was incorrectly moved forward
	  due to improper deletion of log items from the AIL before log
	  shutdown. 

[1] https://patchwork.kernel.org/project/xfs/patch/20240823110439.1585041-1-leo.lilong@huawei.com/

Long Li (2):
  xfs: remove redundant set null for ip->i_itemp
  xfs: ensure dquot item is deleted from AIL only after log shutdown

 fs/xfs/xfs_dquot.c  | 8 +++++++-
 fs/xfs/xfs_icache.c | 1 -
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.39.2

