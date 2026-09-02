Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791A949EC65;
	Wed,  2 Sep 2026 13:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355031; cv=none; b=ohZ48j3yxEsoxOEqhcC++ipzkFH0AO33nVfvv6b5WdphA0Js6Dej8AeMRcWI1s6mCS/4sxivlV3YQdO4pIcGiddxgLNK3CGSfaCq65kDkclI4wnuSsWOUWfi10YX53lLy2QGxPmQ15dDAe5AKx7MBpY4D1xgxrkTFH269BGhEfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355031; c=relaxed/simple;
	bh=FYd4TyB1H+lGzCqw0X4fzpyPftb+f1/FwMG5bgRpz6E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JM3SY03bux9pfe38+wPT26xMxL07zKHuC/gSy+fv25f6kqpdIpHi/I5HYr5U6orfpIlYlG33TzBBZRWZn8/pk04AS2DpDNM/jM2hh5peoyjtp+s06CMqlK2P+tHAJOA9sEw9uhxSqs83vBHSv24+/j8IW0LZYYhb1wAlyH3sm2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=2RG9sDFc; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="2RG9sDFc"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nsItdggoL/pH70R61fsubbblLKE8u/0wryCQVrxs0VM=;
	b=2RG9sDFcgMpmLnKYwyCd+Aat75j5gFfE2K+rc2lyv6wU3o2Lnnetiw/ZC4yS+kihU5WUmZbe4
	o5KIP8sxOK31IxMMaFG84XSa9pv4RE0SRfYSAymq2wlfboEwxY20a5x/dyYI8mR17lIslcRVKvJ
	MQYc1jht7/h6/RE7RTFEF1A=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hZjfB3RfCzcb0T;
	Wed,  2 Sep 2026 21:06:10 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 71F94202E6;
	Wed,  2 Sep 2026 21:16:56 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 2 Sep
 2026 21:16:55 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 2/4] iomap: simplify writepages reclaim guard
Date: Wed, 2 Sep 2026 21:16:51 +0800
Message-ID: <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
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

Now that kswapd can no longer reach filesystem writeback (pageout()
returns PAGE_ACTIVATE for non-shmem, non-anon folios), any PF_MEMALLOC
context in iomap_writepages() indicates a VM regression, simplify
the check by removing PF_KSWAPD.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 fs/iomap/buffered-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..6306ca747f3b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -2077,8 +2077,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
 	 * Writeback from reclaim context should never happen except in the case
 	 * of a VM regression so warn about it and refuse to write the data.
 	 */
-	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
-			PF_MEMALLOC))
+	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
 		return -EIO;
 
 	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
-- 
2.55.0

