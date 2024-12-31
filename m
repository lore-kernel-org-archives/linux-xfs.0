Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AEC33C9
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 02:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735612745; cv=none; b=uz067KBSKeZL9Qk+/H9c1c3FyjYBagekGA/gg/HlZ2NpXZZLON0g1ht7tmiAs+CFPnybtVQ+wxAsd38xuLS/P5kSySNmc3An/uSRmzwriTujqcwSUOCI8QE5YGVlwKqbmR0JaR7rOG1wTR6hZJ6eYbf6HXfrfIkwtV9+G1chbAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735612745; c=relaxed/simple;
	bh=MS8Xt8yb2XiuE3QdneJkhPsc4Z3Hw2iPMMs8UogwKJ0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VJTOIH7wrth3Px/NGBkUW1KRrsvm3ELczS4lPhNgSpU1psaECmDAajC04XeIMZuHWI5ofirnUShTQBLeMS0ZB2V9E7s5fZgR9VEbzaV7NDsEWZrzHpI3LCVj9KVkhAvU8sfC/iRbCLmon2k0Hf/mDNn2FiynsaD+tFN8QXQ353k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YMcXt2rZKz11Rdc;
	Tue, 31 Dec 2024 10:36:14 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EDDF140259;
	Tue, 31 Dec 2024 10:39:00 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 31 Dec
 2024 10:38:59 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 0/2]  xfs: fix two issues regarding mount failures
Date: Tue, 31 Dec 2024 10:34:21 +0800
Message-ID: <20241231023423.656128-1-leo.lilong@huawei.com>
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

This patch set fix two issue regarding mount failures, the patch 1
fixes the issue where the current kernel cannot mount a xfs disk
without realtime subvolume; the patch 2 resolves the problem of the
mount thread getting hang after a failure.

Long Li (2):
  xfs: correct the sb_rgcount when the disk not support rt volume
  xfs: fix mount hang during primary superblock recovery failure

 fs/xfs/libxfs/xfs_sb.c        | 2 +-
 fs/xfs/xfs_buf_item_recover.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.39.2

