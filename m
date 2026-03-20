Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E820827B32C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 02:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773973347; cv=none; b=qv1/W0wb7f7r+U4JyaB2o/b1idbZd769p7PvV5cUF5SnXUsBIBG2Y8VnKJkXMgeDFQ/qSa8wkQ+G/iigprfzuWYiVrEbEeLdYXkrQi5V7gBZY5S7UJS7gl0CgsXXOdUtAPTGFVz+m2poNc83viJjLP5uCzkvMC4TdvZz6FDIzz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773973347; c=relaxed/simple;
	bh=zfNwoYyy6DAI1/tja6xk5FkCSS6LTpxTTDtuwhs0O50=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l+IjIGKQhjGJAPB5Y8rbrRKQjRLllgN14aoUH8Fa3InSkgaaJnptR2l+WcpthJ9O5x81XwqniGhBEvHtfQTWHc8/jcVgO9eu3/JrJDTKufFSWC58qq4g/S4KtZtosEq8va+3CcyrruwfwlfZHGGLUdYlvp3UYYgEQv/mnWvi+q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=IvjqDofW; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="IvjqDofW"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xzstVlzEHwW0Qb9UlkI/+CoZuALpjxf5GSt7fliIHpo=;
	b=IvjqDofW73qo9+A9nflFK94ydiJ7kfll7x3fHesm1sOf2s2sSCKg6z4hjYs27yiB/4cV+fMN0
	vDMVg0Uzz0Ws9Q+bXfnOcQ5G/FK8lhkQuoIeEpSm9BDGS1c8DzJhzCfd+q4rW+mLrGhtPAY7b7f
	JjBtif1YDe+Y3snMsJgLpcs=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fcR6443h7zKm4t;
	Fri, 20 Mar 2026 10:17:16 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id CD5E34055B;
	Fri, 20 Mar 2026 10:22:17 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 10:22:17 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 20 Mar
 2026 10:22:16 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v3 0/2] xfs: fixes and clean up for attr item
Date: Fri, 20 Mar 2026 10:11:28 +0800
Message-ID: <20260320021130.2936657-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

This patch set fixes and cleans up several minor issues in the attr item.

V2->v3:
- Patch1 is discarded, as Darrick has already fixed it.
- Update the comments and add the reviewed tag

V1->V2:
- Fix ip is not initialized issuse in patch-1
- Add the reproduction script in patch-2.
- Delete only the redundant code, and leave the rest unchanged in patch-3.


Long Li (2):
  xfs: fix ri_total validation in xlog_recover_attri_commit_pass2
  xfs: remove redundant validation in xlog_recover_attri_commit_pass2

 fs/xfs/xfs_attr_item.c | 50 ++----------------------------------------
 1 file changed, 2 insertions(+), 48 deletions(-)

-- 
2.39.2

