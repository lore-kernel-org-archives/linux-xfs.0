Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CB5347FC0
	for <linux-xfs@vger.kernel.org>; Sat, 18 Apr 2026 09:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776505201; cv=none; b=mTyt3I1Fn2hSo8iDrNDTiMAG98Jwyr8ljhhPY6N60FIpyDNDqYQ6WJCNqHYXAuT+8vL+v6AQsbrdx2v2iwx+RrngvenjVWkKl8ortv5KWzTeKrIkLA0wjbkJxqR/zE4Vn03fm8v+0CC3E4fHpSDazgbrnChlb14XOKecqSexLag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776505201; c=relaxed/simple;
	bh=aLFFi565cmAD+SH4LvaX1x8OPf+x9I1zZpuzL8PKpUQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uIRJNsAawiMCRA6xRTgW2i+sR+CsT/6FWK6v+5q/i21HiDt/nM5DSCRQCZDv51OYF9YSU5h6KBsLJ1QgsfxTu7cGoiq969AeD/3d9o3tTjLcNHsLOTBCK6Mp6AK7apeWr0w6OImyUquFX3chhTzUbu/Tw4q8svSob/GKODtDw/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Cez3X9cx; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Cez3X9cx"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oH4jHL3RIk+rgkNsrmIJJmXtfWcMbX5fMiLYqLmMzMw=;
	b=Cez3X9cxm4ByDscviZv9rxLBxri125S6z8DRTVJ1nhAjP9SKCVedq3I2pRpE03UluE42h6Ggq
	ah59bzsykrbcIRBTeBykFT2s86SlpZCE6cg9kvPmMrWqAgiqafSVQj3XADyMpKCvcBhzi/Am5dJ
	ZS6NSwbt7EsxhbUfMDYQlwk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fyRQB1LlJzpSvH;
	Sat, 18 Apr 2026 17:33:38 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E38624056D;
	Sat, 18 Apr 2026 17:39:55 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Apr 2026 17:39:55 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Sat, 18 Apr
 2026 17:39:55 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 3/3] xfs: handle ERR_PTR return from bio_split in xfs_zone_gc_split_write
Date: Sat, 18 Apr 2026 17:27:15 +0800
Message-ID: <20260418092715.375850-4-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260418092715.375850-1-leo.lilong@huawei.com>
References: <20260418092715.375850-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

bio_split() now returns ERR_PTR() on failure. xfs_zone_gc_split_write()
currently passes the return value directly to container_of() without
checking for errors, which will crash on failure.

Add an IS_ERR() check after bio_split() and propagate the error as
ERR_PTR to the caller xfs_zone_gc_write_chunk(), which handles it by
triggering a filesystem shutdown and freeing the chunk, consistent with
how other I/O errors are handled in that function.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_zone_gc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index fedcc47048af..b17782ff81af 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -811,6 +811,8 @@ xfs_zone_gc_split_write(
 	split_len = split_sectors << SECTOR_SHIFT;
 
 	split = bio_split(&chunk->bio, split_sectors, GFP_NOFS, &data->bio_set);
+	if (IS_ERR(split))
+		return ERR_CAST(split);
 	split_chunk = container_of(split, struct xfs_gc_bio, bio);
 	split_chunk->data = data;
 	ihold(VFS_I(chunk->ip));
@@ -859,8 +861,14 @@ xfs_zone_gc_write_chunk(
 	list_move_tail(&chunk->entry, &data->writing);
 
 	bio_reuse(&chunk->bio, REQ_OP_WRITE);
-	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
+	while ((split_chunk = xfs_zone_gc_split_write(data, chunk))) {
+		if (IS_ERR(split_chunk)) {
+			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+			xfs_zone_gc_free_chunk(chunk);
+			return;
+		}
 		xfs_zone_gc_submit_write(data, split_chunk);
+	}
 	xfs_zone_gc_submit_write(data, chunk);
 }
 
-- 
2.39.2

