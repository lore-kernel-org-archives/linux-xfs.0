Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF66328B6;
	Mon, 26 Aug 2024 03:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724642104; cv=none; b=Yw3ZJllg72yCq6qn3qX3ExObFbplrMk1q+gQM8YXlEUzcv+XS/YSwbiuxSxu7C7nEozW29zGbdHUlZTIJJ6viLIdz1P+0f4+YjeD4aRYx+COm6bVwHExpqBXpIZfAhtRER64JgC8mS+POxtBWe5IyXSLzhYOmeiDdsiotpZ7L8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724642104; c=relaxed/simple;
	bh=4AtPyHjZS9g5QSCyGx91UF9D9/GVSqoEr30OdZGHR4Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DAUADWGopReEHod02RNYD/UAij0zMp6fWs1efEHfh4McZzSimCGQZHMNJNFjVy2qhlDa5fcgCnMN37GNcIaZSzNVtaSL/SUQ2A325PCCG3dwZbfI5rDFG7/3HJDkSf3jufuQo1cD7J7QjbCKNibbun6bC/dr66ib+RumF5Cb/uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WsbNK6mQjzpTSq;
	Mon, 26 Aug 2024 11:13:21 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 6FAA01402CA;
	Mon, 26 Aug 2024 11:15:00 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 26 Aug 2024 11:14:59 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 0/2] Some boundary error bugfix related to XFS fsmap.
Date: Mon, 26 Aug 2024 11:10:03 +0800
Message-ID: <20240826031005.2493150-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemf100017.china.huawei.com (7.202.181.16)

Prior to this, I had already sent out a patchset related to xfs fsmap
bugfix, which mainly introduced "info->end_daddr" to fix omitted extents[1]
and Darrick had already sent out a patchbomb for merging into stable[2],
which included my previous patches.

However, I recently discovered two new fsmap problems...What follows is a
brief description of them:

Patch 1: In this scenario, fsmap lost one block count. The root cause is
that during the calculation of highkey, the calculation of start_block is
missing an increment by one, which leads to the last query missing one
This problem is resolved by adding a sentinel node.

Patch 2: In this scenario, the fsmap query for realtime deivce may display
extra intervals. This is due to an extra increase in "end_rtb". The issue
is resolved by adjusting the relevant calculations. And this patch depends
on the previous patch that introduced "info->end_daddr".

[1] https://lore.kernel.org/all/20240819005320.304211-1-wozizhi@huawei.com/
[2] https://lore.kernel.org/all/172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs/ 

Zizhi Wo (2):
  xfs: Fix missing block calculations in xfs datadev fsmap
  xfs: Fix incorrect parameter calculation in rt fsmap

 fs/xfs/libxfs/xfs_rtbitmap.c |  4 +---
 fs/xfs/xfs_fsmap.c           | 39 +++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 8 deletions(-)

-- 
2.39.2

