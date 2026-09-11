Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D20F42C50F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 10:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123372; cv=none; b=XE0NaCquK+RfHEBVNF0EeIxfXwUzg7qyeuusVKI1G3I56L2N4+VOSJ784/TtCwrbX4F5Ann4QY63bcFCvhRbg15yl4gTyWTqYZwkcv34pv9lsk0D+WAJssBRmoQfMd1t8t/3SEf1LKpQWooMUvXzrTHYgyUC0H4LRcbY3yvA170=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123372; c=relaxed/simple;
	bh=joyG0BCixO1ASKVLrSZkrPkBEpV7lZG7kWpNYGccE7M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mphHWRRaQEoWcmopCvDbO7y/bBtPv9nqBMSDY7Xf8XPJKgLifbXNz2l51fY755PCTKxjAxutJC+oJpL3B8VV0axhP3lE6PGrNh4yJPc+RVLnCKsQLidQh5X/9yv76YfrH9QIk+w2DjEwVHex6AVc1tu73S60xCj5ByFp5w9T89s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=nnpT2cZm; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="nnpT2cZm"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JoVoBVxuIFJPpqnozZOrMDxgd4k13M4SmVAjlfUXrmM=;
	b=nnpT2cZmBzPvNpe5wDsrZeDU6+909TNgNIwRSH/svg5T0aZM2GLTIDI+lm6vKFWpRz2SuDObp
	FQRQGx+bdcQj8dzw4/0WUczwICkWlY/52W3Fq4lGpeyjKuwlAYnyTfgUwTPtxOBHr/4UePS8SmP
	r7HWFvu6oJen4jzIN6kRspI=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hh9nw3ffDz1K96s;
	Fri, 11 Sep 2026 18:31:48 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 4759E40563;
	Fri, 11 Sep 2026 18:42:44 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 11 Sep
 2026 18:42:43 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Carlos Maiolino <cem@kernel.org>, <linux-xfs@vger.kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, Brian Foster <bfoster@redhat.com>, Dave Chinner
	<dchinner@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Christoph
 Hellwig <hch@lst.de>
Subject: [PATCH RESEND 2/2] xfs: fix NOFS state corruption in btree split worker
Date: Fri, 11 Sep 2026 18:42:27 +0800
Message-ID: <20260911104227.2028941-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>
References: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)

xfs_btree_split_worker() calls xfs_trans_set_context() and
xfs_trans_clear_context() on the caller's transaction, overwriting
tp->t_pflags with the worker's NOFS state. When the caller already has
PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
the caller's NOFS protection.

Use memalloc_nofs_save/restore with a local variable instead so
tp->t_pflags is never touched.

Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6738d9d1511b..a0133d662096 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3007,12 +3007,18 @@ xfs_btree_split_worker(
 {
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
-	xfs_trans_set_context(args->cur->bc_tp);
+	unsigned int nofs_flags;
+
+	/*
+	 * Don't use xfs_trans_set_context() here: it would overwrite the
+	 * caller's saved NOFS state in tp->t_pflags.  Use a local scope.
+	 */
+	nofs_flags = memalloc_nofs_save();
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
 
-	xfs_trans_clear_context(args->cur->bc_tp);
+	memalloc_nofs_restore(nofs_flags);
 
 	/*
 	 * Do not access args after complete() has run here. We don't own args
-- 
2.55.0

