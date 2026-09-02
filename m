Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5458949C4A7;
	Wed,  2 Sep 2026 13:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355032; cv=none; b=M0E2bzvAR3r9eHC13fW+pUmfD+aMW+PlaHtDw7oandaZNZwmoCk8/nACYEklg9vAOZ3KCj+a+lmHDai0jamzIwPevvX8SfUy7wCpGJScUfy9d+j+YCrpyDzSuwDTkonbymj54x9AiGuv8P53bZzOpSkIcfD5uCu6c4m24OsHKPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355032; c=relaxed/simple;
	bh=TnTqbNMLF5Z+vLR1FN6ZoYU9BwJQaoye8xp2+br8tvg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GnCGCzPyOn3Y+XcrBJiMQK75mpdMVE+dRYb6KhZKn1I5KPcipFkxe9BFijjawa7GnqF2cAQJzw03f5B4swNEzCe9R4UUzvNAK2uE0ekoM5JaCeO8tUAv4xc9NuJphfScREoW2kbL9rGGCBEXhKE/1iKwNfIwTjAKAvnOGSpXVBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=b0wTimjL; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="b0wTimjL"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8Vx1ScIjzS7o5RooSf6BJ0hm6c4fipiuqGVHNi/yfPc=;
	b=b0wTimjL5yFHsuCctPVCTE2FOh8S5GitqHT22vK8JOB+49aUeA9Vqe+MAMTt64JwHR17H0BtU
	ZXDdThC2FXwumgtxxhexKeOrHkX6hFzYi51twKBje7cBcrGCDdLqv1FH/Vu3qre/cAzAylFjoOK
	c84eBNRDdjtou0MoSr/1qtI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hZjdb19D2z12LDV;
	Wed,  2 Sep 2026 21:05:39 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 5DFF24058C;
	Wed,  2 Sep 2026 21:16:55 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 2 Sep
 2026 21:16:54 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 0/4] mm: replace PF_KCOMPACTD/PF_KSWAPD with kthread_func()
Date: Wed, 2 Sep 2026 21:16:49 +0800
Message-ID: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300003.china.huawei.com (7.202.195.93)

The task_struct->flags field is a limited 32-bit resource. Two flag bits,
PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
is kcompactd or kswapd. Converting these to use kthread_func() frees up
two valuable flag bits for future use.

Kefeng Wang (4):
  xfs: remove dead kswapd flag inheritance from btree split worker
  iomap: simplify writepages reclaim guard
  mm: replace PF_KSWAPD flag with kthread_func() check
  mm: replace PF_KCOMPACTD flag with kthread_func() check

 fs/iomap/buffered-io.c                   |  3 +--
 fs/xfs/libxfs/xfs_btree.c                | 18 +-----------------
 fs/xfs/xfs_platform.h                    |  4 ----
 include/linux/compaction.h               | 11 ++++++-----
 include/linux/sched.h                    |  4 ++--
 include/linux/swap.h                     |  7 +------
 mm/compaction.c                          |  9 ++++++---
 mm/vmscan.c                              | 10 ++++++++--
 tools/sched_ext/include/scx/common.bpf.h |  2 --
 9 files changed, 25 insertions(+), 43 deletions(-)

-- 
2.55.0

