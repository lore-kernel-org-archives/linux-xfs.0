Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F054A24;
	Mon, 12 Aug 2024 01:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723425556; cv=none; b=iXMpvu+mje4p0FTvx6r+3XVxovJpr2BEiL30KBp759Q4fkeHr6H7p373xk45z97fcHMmvyzr3DCQ87+xr5Qff7FBe2YMeTyr5rn9ZGPCOo2+PfiRizQCLP+ULVzbKDp++8dIUdNq1QG4zEhHNN9WxeKos+CVHcgfF1KX10BpwGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723425556; c=relaxed/simple;
	bh=YjZJe1cSNfHl+nTh2MTlon4jGnSimUTrrrz87c0ksNM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fKhz+ajU/q9/hecS4cbKb9D9xVLXiIDmuLiJMY3xOQlpYuG8l2s8My57TsrLzjRg8baNdpsXflRak1m5s8lmbZtBaXJC6o7RWKTzdMgpCDBESh5ggrYF7Bt0FOxrGjs52rOsR2JLWY+rv6anbsF9zsNmzs9jZsZ7ns+Quk3Dulk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WhxPp6fybz20lNP;
	Mon, 12 Aug 2024 09:14:38 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 421F014022D;
	Mon, 12 Aug 2024 09:19:10 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Aug 2024 09:19:09 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH V3 0/2] Some bugfix for xfs fsmap
Date: Mon, 12 Aug 2024 09:15:03 +0800
Message-ID: <20240812011505.1414130-1-wozizhi@huawei.com>
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
 kwepemf100017.china.huawei.com (7.202.181.16)

Changes since V2[1]:
 - Split the original patch into two, each for a different problem.
 - The fix focuses solely on addressing the omission problem and does not
   involve the precision of intervals.

This patch set contains two patches to repair fsmap. Although they are both
problems of missing query intervals, the root causes of the two are
inconsistent, so two patches are proposed.

Patch 1: The fix addresses the interval omission issue caused by the
incorrect setting of "rm_owner" in the high_key during rmap queries. In
this scenario, fsmap finds the record on the rmapbt, but due to the
incorrect setting of the "rm_owner", the key of the record is larger than
the high_key, causing the query result to be incorrect. This issue is
resolved by fixing the "rm_owner" setup logic.

Patch 2: The fix addresses the interval omission issue caused by bit
shifting during gap queries in fsmap. In this scenario, fsmap does not
find the record on the rmapbt, so it needs to locate it by the gap of the
info->next_daddr and high_key address. However, due to the shift, the
two are reduced to 0, so the query error is caused. The issue is resolved
by introducing the "end_daddr" field in the xfs_getfsmap_info structure to
store the high_key at the sector granularity.

[1] https://lore.kernel.org/all/20240808144759.1330237-1-wozizhi@huawei.com/

Zizhi Wo (2):
  xfs: Fix the owner setting issue for rmap query in xfs fsmap
  xfs: Fix missing interval for missing_owner in xfs fsmap

 fs/xfs/xfs_fsmap.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

-- 
2.39.2

