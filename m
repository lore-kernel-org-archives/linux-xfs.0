Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDBC3AD539
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 07:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974734; cv=none; b=uc4Cugy7xTkI02t3/CmCZexW5Nj9n+rUZPE8WrPzmqRt8YwSKxzfWvpE8Krwcy8TIjIBMcDYVKkSiQCOwezsK0gQTBCr33kdwiczuqSMbgQkpBwlyVDZp5b9KaNssj4gKr0bXRXuYNYTEwAIw28KkhdkMuFsnJJIR63ZhB/K5Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974734; c=relaxed/simple;
	bh=JrekxlfDwA8kPLoFmEQe8yRcz20YSkzIKpXa0QA+XFw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fElyFTkwzBsQpvzpWXBJAsGNpwSk3Rx5Y2Q32T0rsphO28NIAgEiavhp06tKiKSvqKKON2o8oWxSOZypZ1wiBEyguFORi4c3I6nQUEuvVwZ2IqIckfA9M6oJrB09QfWRkfTk6bWxDBVp0/T8n8HbQ4cxeb/30MBe/Z+o7hVlh8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ZBTPNeee; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ZBTPNeee"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kOtIhrtAK3VRQN/wXtktiF4Fp0nrnaNCBDKlaZmCLts=;
	b=ZBTPNeee6TGEApMmzebnLV7Q6HFs/1TbNfqIVnIGauC82uOXkshBza/l9sKT+T6oEN07O/MRh
	p5WESVJ+MeMzxfFvrzbEA9ES/WHVk6Qy9J6YsRosxUh4N4Xy5h+wxC41zSApoTLDTLw40YGGbtG
	FEcQEV2ONxzoxiCQlMLcMqk=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hpDdn0541zcb4j;
	Mon, 21 Sep 2026 15:00:45 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 70D564057F;
	Mon, 21 Sep 2026 15:12:05 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 21 Sep
 2026 15:12:04 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Carlos Maiolino <cem@kernel.org>, <linux-xfs@vger.kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, Dave Chinner <dchinner@redhat.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, Christoph Hellwig <hch@lst.de>, Brian Foster
	<bfoster@redhat.com>
Subject: [PATCH for-next v3] xfs: fix NOFS state corruption in btree split worker
Date: Mon, 21 Sep 2026 15:10:30 +0800
Message-ID: <20260921071030.3214538-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
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
v3:
- Using correct unsigned int type for nofs_flags, per Darrick

v2:
- Send bugfix only based on xfs-linux/for-next, suggested by Carlos[1]
  https://lore.kernel.org/linux-xfs/aqqGiu9W0G7dquoY@nidhogg.toxiclabs.cc/
v1:
- https://lore.kernel.org/linux-xfs/20260911104227.2028941-1-wangkefeng.wang@huawei.com/

 fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 60ef7f08b1d3..239741132914 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3010,6 +3010,7 @@ xfs_btree_split_worker(
 						struct xfs_btree_split_args, work);
 	unsigned long		pflags;
 	unsigned long		new_pflags = 0;
+	unsigned int		nofs_flags;
 
 	/*
 	 * we are in a transaction context here, but may also be doing work
@@ -3021,12 +3022,17 @@ xfs_btree_split_worker(
 		new_pflags |= PF_MEMALLOC | PF_KSWAPD;
 
 	current_set_flags_nested(&pflags, new_pflags);
-	xfs_trans_set_context(args->cur->bc_tp);
+
+	/*
+	 * Don't use xfs_trans_set_context() here: it would overwrite the
+	 * caller's saved NOFS state in tp->t_pflags. Use a local scope.
+	 */
+	nofs_flags = memalloc_nofs_save();
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
 
-	xfs_trans_clear_context(args->cur->bc_tp);
+	memalloc_nofs_restore(nofs_flags);
 	current_restore_flags_nested(&pflags, new_pflags);
 
 	/*
-- 
2.55.0

