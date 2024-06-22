Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6125114C587
	for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 08:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719044881; cv=none; b=B5zXYsPc737ITUbnTRvW63WofRNW9EyZzjkmxhwEQTQlokVaiT18DAUBXLnGInMpiP3OjxvLDVji1gHjH3hXIybB4mhyfhSlI0dIodgGNGjqpm1w6HzjtiLGYJoUHXU+DdxnKq/zJIclVfKiF9Zx4M2X8U22BGMuqNwqE7I9itA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719044881; c=relaxed/simple;
	bh=odwjcLc/tptYob+CvG8KtvjyFrme85YpPqVsTljQjTM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SbhZW+byd1SLR4nJBhjtVwn3nOwR4TOw7c2mubhB11N8JzeC99N4gZGjKlOd31MAiYFWlkaeyLHtHqME2iYuMTQh5IR0xVxQADLxfPfgv65Gz1KQN3nB21543uH27LNaoovDsyGFKXZ9bboe4WDHEKwbCaaJI7tGKIpFR29eLrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W5nKW6CHTznVbP;
	Sat, 22 Jun 2024 16:22:55 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id BC06B1800CD;
	Sat, 22 Jun 2024 16:27:39 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 22 Jun 2024 16:27:38 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH] xfs: eliminate lockdep false positives in xfs_attr_shortform_list
Date: Sat, 22 Jun 2024 16:26:31 +0800
Message-ID: <20240622082631.2661148-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)

xfs_attr_shortform_list() only called from a non-transactional context, it
hold ilock before alloc memory and maybe trapped in memory reclaim. Since
commit 204fae32d5f7("xfs: clean up remaining GFP_NOFS users") removed
GFP_NOFS flag, lockdep warning will be report as [1]. Eliminate lockdep
false positives by use __GFP_NOLOCKDEP to alloc memory
in xfs_attr_shortform_list().

[1] https://lore.kernel.org/linux-xfs/000000000000e33add0616358204@google.com/
Reported-by: syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_attr_list.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 5c947e5ce8b8..8cd6088e6190 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -114,7 +114,8 @@ xfs_attr_shortform_list(
 	 * It didn't all fit, so we have to sort everything on hashval.
 	 */
 	sbsize = sf->count * sizeof(*sbuf);
-	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
+	sbp = sbuf = kmalloc(sbsize,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 
 	/*
 	 * Scan the attribute list for the rest of the entries, storing
-- 
2.39.2

