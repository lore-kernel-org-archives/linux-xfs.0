Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B0523EAAA
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 06:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763016521; cv=none; b=hhyx01l6WHOzOy/D4VNxXWkSoaQMZwB1DgJzI5g5nBLoHReQzKo2Ws/gHl4lcRhaQCTUziuKmSzN+k9KKwAfbnkrd7B1DvOdJgqFAcg97lHcTX+AtAvjllYeA2tlFQoWRP2fLqRglV7lxwvhE54/gmTsh3/vA+qysLWamknDXNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763016521; c=relaxed/simple;
	bh=YROUopYWe/0gOYwKFo507zDSX/1oJRlQc2C4hrYTlkw=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=hAwDBTyO9MiLl/CnQGon0UfVsRWNgaBWwQkDoZpVocBsDCTqR1i6vZHFYKbJ4yfGXO729n0rDW4q+2PbvbCnyB2wbtbQyT1fRLlUfAy8X07X0wccLdVKKlr1XS4W46Aauz+4Dy1DBxYA8rqB8NX0F05H7JMcFMbGkAvM69uskLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=NU7ZxOoS; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="NU7ZxOoS"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hn0KKtStKm7r6si39dNPhTZC49/tA3eu15X4/2McHAI=;
	b=NU7ZxOoSBbUe/iLT2AwkU7zF5JsqjLYGCmc1eKAzpYW1IgHAgDAI173GnEZvx5KSuKm2XTxFM
	d4DxLvngjEfrk7PH27HHpDfRyMIt7o0beBhmXuh55wFBJrHQMmf7U1rVf+kZOCLWezfKaVrulDl
	YUAhDqrX9apIle/mJRSahZ4=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4d6W5p1Llnz1prMy;
	Thu, 13 Nov 2025 14:46:54 +0800 (CST)
Received: from kwepemj500016.china.huawei.com (unknown [7.202.194.46])
	by mail.maildlp.com (Postfix) with ESMTPS id D63031401E0;
	Thu, 13 Nov 2025 14:48:34 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemj500016.china.huawei.com (7.202.194.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Nov 2025 14:48:34 +0800
Message-ID: <7ae57ed5-75bd-277b-8cb7-970e65761dcd@huawei.com>
Date: Thu, 13 Nov 2025 14:48:34 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <yangyun50@huawei.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] libxfs: remove the duplicate allocation of
 xfs_extfree_item_cache
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj500016.china.huawei.com (7.202.194.46)

In init_caches()，the xfs_extfree_item_cache is being repeatedly initialized.
The code flow is as follows:

init_caches()
    ...
    xfs_defer_init_item_caches()
        xfs_extfree_intent_init_cache()
            // first alloc
            xfs_extfree_item_cache = kmem_cache_create("xfs_extfree_intent",...);
    ...
    // second alloc
    xfs_extfree_item_cache = kmem_cache_init(..., "xfs_extfree_item");

So, remove the duplicate allocation code.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 libxfs/init.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 393a9467..a5e89853 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -214,9 +214,6 @@ init_caches(void)
 		fprintf(stderr, "Could not allocate btree cursor caches.\n");
 		abort();
 	}
-	xfs_extfree_item_cache = kmem_cache_init(
-			sizeof(struct xfs_extent_free_item),
-			"xfs_extfree_item");
 	xfs_trans_cache = kmem_cache_init(
 			sizeof(struct xfs_trans), "xfs_trans");
 	xfs_parent_args_cache = kmem_cache_init(
@@ -236,7 +233,6 @@ destroy_caches(void)
 	leaked += kmem_cache_destroy(xfs_da_state_cache);
 	xfs_defer_destroy_item_caches();
 	xfs_btree_destroy_cur_caches();
-	leaked += kmem_cache_destroy(xfs_extfree_item_cache);
 	leaked += kmem_cache_destroy(xfs_trans_cache);
 	leaked += kmem_cache_destroy(xfs_parent_args_cache);

-- 
2.27.0
