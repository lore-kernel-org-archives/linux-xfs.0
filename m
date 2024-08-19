Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523DB1D555;
	Mon, 19 Aug 2024 00:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724029081; cv=none; b=AUZfUJHu4U4mmO/9MbaziQegNK9W2fEBE8FNa7qOq1q2cRvJuljdNVTH29TIFN6G0VRJF8q17lXUiFI+aOv6uppIXeeRT0R7/e4wLBYa/zQiLSY8UN7ju42w21DiY1K1uD2sl7zyvwn6qOB/d4VthRDbwKr+SaVoWFYM3oEvhMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724029081; c=relaxed/simple;
	bh=t+v1L6RykYerGcKn9EIawyURcD9jExAKYf4UT94q4N0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RAX4Ub5PrYjw6c+X/vN29pTPnRt0T5xgs9jRM4AX52IDooF1zQBkGJHh/ol9InIisoPnfgtQkqrCEQVyMKCPFahpL4dEBL3so55wq7/hZWUGU00TjOB1F7HMNQ/DFY9ejLT0FMbW4h9hl0NSqzyKv4jyl3gZKW/IijTju5KdGQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WnDbR689dz1j6cP;
	Mon, 19 Aug 2024 08:52:51 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 902C2140109;
	Mon, 19 Aug 2024 08:57:49 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Aug 2024 08:57:48 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH V4 0/2] Some bugfix for xfs fsmap
Date: Mon, 19 Aug 2024 08:53:18 +0800
Message-ID: <20240819005320.304211-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemf100017.china.huawei.com (7.202.181.16)

Changes since V3[1]:
 - For the first patch, simply place the modification logic in the
   xfs_fsmap_owner_to_rmap() function.
 - For the second patch, more detailed comments were added and related
   changes were made to the initialization of the end_daddr field.

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
info->next_daddr and high_key address. However, due to the shift, the two
are reduced to 0, so the query error is caused. The issue is resolved by
introducing the "end_daddr" field in the xfs_getfsmap_info structure to
store the high_key at the sector granularity.

[1] https://lore.kernel.org/all/20240812011505.1414130-1-wozizhi@huawei.com/

Zizhi Wo (2):
  xfs: Fix the owner setting issue for rmap query in xfs fsmap
  xfs: Fix missing interval for missing_owner in xfs fsmap

 fs/xfs/xfs_fsmap.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

-- 
2.39.2

