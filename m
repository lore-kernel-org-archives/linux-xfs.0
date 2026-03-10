Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBC03D813C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146575; cv=none; b=M+02bQWvhhd7NYy6IbZ+PCdcIXwFR0Q3q7Ox3H+MBk8hdd5aObQhePshd3wZMmkudIm++ayBFUlA3EIaFnr7o4m7YRXaw2lmoUtf0Pp748n3L5Fb0XWVNxN42VTvJaLNarMudDbO3uaEyyuLpUcnbilVsPjk4PDvZCJwPR9aEF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146575; c=relaxed/simple;
	bh=1W36W53BQXOIG/Biz0wacygmpbpK8oHczuot6VOxbjE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GXhi4STViZifoPmTjAg9hnvwtL4y3bX/g6izjYGRdap7opKK+SRGeguNT8xGfifBjmZHonqHal2kzr7aEJFGmdBG7OzedKYVmV7VNCAzBXE3yrNkIBgpwG1S3/xb7OFZpA5Q/f7ucDyF4yGhIBTdMpJqFO0PrzGisOSlenFA2sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=AG0tgMXN; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="AG0tgMXN"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mAC7Dw8R4Xml+fdXxusFDLWcXHUNj6bBygGRPLlaPYU=;
	b=AG0tgMXN8ZLGT9F/8fXW4NX1lhGR7lh/30E+oIfrjjDr8Y7W59Wf5KizbN7fzFo6bMS+ipGI6
	lxE2BJcwKq45VSbVN53h/AwGpBQWY4iy794IRV/Kz2hmnksIXDC3eNiDGPg3I+BIDJd1cjAaizQ
	Iwk0jan4EDuh+qxeuLgwO2I=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fVYLd334RzKm4X;
	Tue, 10 Mar 2026 20:37:45 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id DBA2D40563;
	Tue, 10 Mar 2026 20:42:40 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 20:42:40 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 10 Mar
 2026 20:42:39 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH] xfs: fix integer overflow in bmap intent sort comparator
Date: Tue, 10 Mar 2026 20:32:33 +0800
Message-ID: <20260310123233.449659-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

xfs_bmap_update_diff_items() sorts bmap intents by inode number using
a subtraction of two xfs_ino_t (uint64_t) values, with the result
truncated to int. This is incorrect when two inode numbers differ by
more than INT_MAX (2^31 - 1), which is entirely possible on large XFS
filesystems.

Fix this by replacing the subtraction with cmp_int().

Cc: <stable@vger.kernel.org>
Fixes: 9f3afb57d5f1 ("xfs: implement deferred bmbt map/unmap operations")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_bmap_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e8775f254c89..b237a25d6045 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -245,7 +245,7 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
 }
 
 /* Log bmap updates in the intent item. */
-- 
2.39.2

