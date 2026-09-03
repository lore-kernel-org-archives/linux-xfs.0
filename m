Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F413AA4E0;
	Thu,  3 Sep 2026 13:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442712; cv=none; b=R2tK72uaYwlNN7+jAoz+0KkaZzGyfjK9OKSw1tWc2sThueUM+eymJ8l+zm1vv8x6ocjIqePXqNnHshtgl1LBADxFd7hCzwOANTlAt4bFxNzCkvLmcFiFcRKOtg81BBwKCHfMHzD71crfBenWCNhR81V2a19R6VRr6sR0uXYHzpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442712; c=relaxed/simple;
	bh=Z2UagyXiU6J9vG0POM7gjJjTVUwyU2C2/RJWeNEy7MI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JxucEV7EfItGWYCpxvFWDKU9FSfTvxyOCedkK5hKWpv2i/hH/3MdN8RvkzlHdU/q/e0g7zvPFQ1kKag1RHMxgra+GXJartsAg0Ix8sRPYObd1Tlv8gQcWZyqI+zDAL4mStEd4Y2OL4d1a8Pzidikbd9uv45cRpHZfX24hgRFUSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=l3w4IgOW; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="l3w4IgOW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fiWQq5+ihJfXwau/fHxalzj9WsMWUJ0C6TkAvMp/42s=;
	b=l3w4IgOWPc8+ahx7EWh/E+tBVIL4lmWJdsQM+unCvia5mFwFmSn8FQmNfnyqzo6pthuO4fQL3
	Bmj8t/QIqO2pEVpQ5D39fStsRY1nmHyKog/ZrmUamS+2/OSzUTewwdLWGzylB/9a3ExM7VTCpMC
	dcAv2B8OawtchPBPvMUiYJE=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hbL403QLXz1prLc;
	Thu,  3 Sep 2026 21:27:12 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id E01AD40561;
	Thu,  3 Sep 2026 21:38:04 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 3 Sep
 2026 21:38:04 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] xfs: fix NOFS state corruption in btree split worker
Date: Thu, 3 Sep 2026 21:37:56 +0800
Message-ID: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
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
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6738d9d1511b..8ae4b94e6995 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3007,12 +3007,18 @@ xfs_btree_split_worker(
 {
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
-	xfs_trans_set_context(args->cur->bc_tp);
+	unsigned int			nofs_flags;
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

