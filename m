Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2C41DC07D
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 06:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762888; cv=none; b=NKAYxf71SRaTSo3WT9OvJhiJpgZoZ5NW5/Z4g5iGL305WHxJCGy6mwK1N0OSu37RIuqmKUxCeFFCYF7onjY9l4gU941RpQBz/mHpOosZZDdU3a3o8Sbw2bVzXrU4wORvd3+ju+SUX0iPVgFfxI6HEfQqCJT6zL9aFugLINdjEng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762888; c=relaxed/simple;
	bh=84jwR0vlJP3XtHlzW4UcMxrZ+CQtMyC3J+Z1+qcun5s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P4HWTG4jeiZ6BSYjEXfAPRIVtFnVEeHm8VsC4Q0feM9FS0qWRjoZPw4+CwWaT7k6tWe9c4OlUr6bBxBz+Y/1gcNGnZE2oV+Cd1HOQ1J62ndzi9z6M85ijXXib1qMMmUACE7Et5sHm/rsYI4KyxAcQlWRgk8ZUpvvj0DVQz2OCGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4YFZGR33L1z21mGR;
	Sat, 21 Dec 2024 14:32:47 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id D39B0140158;
	Sat, 21 Dec 2024 14:34:42 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 21 Dec
 2024 14:34:42 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 0/2] xfs: two small cleanup
Date: Sat, 21 Dec 2024 14:30:41 +0800
Message-ID: <20241221063043.106037-1-leo.lilong@huawei.com>
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
 dggpemf500017.china.huawei.com (7.185.36.126)

This series contains two small cleanup patches. No functional changes.

Long Li (2):
  xfs: remove redundant update for t_curr_res in xfs_log_ticket_regrant
  xfs: remove bp->b_error check in xfs_attr3_root_inactive

 fs/xfs/xfs_attr_inactive.c | 5 -----
 fs/xfs/xfs_log.c           | 2 --
 2 files changed, 7 deletions(-)

-- 
2.39.2

