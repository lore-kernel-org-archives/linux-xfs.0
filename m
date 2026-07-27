Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C99391E73
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 02:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785120493; cv=none; b=VZhH7aU/I1W46D0TYxl1eYLx6vgi58rHmxvdjjIbjJ2yybAB6r+/hlkKMqJKhW4MKz3FcAPLnJWDRgeXRD1ZEM/SsUuEnxLa4ReO9yfy5Aw/nLg/ccmFY2uQgTDg3MsLYMpqDnlGbXFN+XqtmDZwtBUjdT/XnhBC+zd2mXRuTWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785120493; c=relaxed/simple;
	bh=uujR5fC6X1nZ5W3vnv00GbzDrUJXr+mTNntGdd9bUXA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ubXrTsVw6vkZqPKO1FhgDocZCPWJwb7NhzbRCXO8A+SB62LukdSAEIsw1F8Js841l6/qZy51/wVZwMOdIg1oyOc/WxIL+GByz11EVQWOM/CizeQ2IjpMUzcXebP31sA+1F1769voZZJw5eGzwnbI92I3tBCfLHPuBb3tq2/PQOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=F+CxxtOo; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="F+CxxtOo"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wLEgYwaMzf+s1nbmkO7rLjI2W1RESu1h8Wj/DkLYCZU=;
	b=F+CxxtOouaF7iBUtcehjaJKuZk/skvvHQvOq9HpwLAKcki5zETRpJFf7dUKEykBZkMUDW78Rq
	vUpcz7FlLXJ16ICI36fl/ayFUSFGIKFH4COmGyWnF4/Rg9ZFXmr89BgPd3YPqFWXh55o6QaojiY
	AAgM77qHZys8rNSXfRMpJwo=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h7jSy3B5kz12LDF;
	Mon, 27 Jul 2026 10:38:26 +0800 (CST)
Received: from whupemo200016.china.huawei.com (unknown [7.152.184.223])
	by mail.maildlp.com (Postfix) with ESMTPS id 934BA4056D;
	Mon, 27 Jul 2026 10:47:57 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200016.china.huawei.com
 (7.152.184.223) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Jul
 2026 10:47:56 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 1/2] xfs: fix ilock leak on error in xfs_dq_get_next_id
Date: Mon, 27 Jul 2026 10:38:48 +0800
Message-ID: <20260727023849.3247961-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemo200016.china.huawei.com (7.152.184.223)

xfs_dq_get_next_id() takes the quota inode ILOCK before calling
xfs_iread_extents().  If xfs_iread_extents() fails, the function returns
immediately without releasing the lock, leaking the quota inode ILOCK.
This can leave the quota inode locked and cause subsequent quota
operations to hang.

Fix this by jumping to a common unlock path on error instead of returning
directly.

Fixes: bda250dbaf39f ("xfs: rewrite xfs_dq_get_next_id using xfs_iext_lookup_extent")
Cc: <stable@vger.kernel.org> # v4.12
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c311f61d9554..b4f6c594808c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -778,7 +778,7 @@ xfs_dq_get_next_id(
 	lock_flags = xfs_ilock_data_map_shared(quotip);
 	error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
 		/* contiguous chunk, bump startoff for the id calculation */
@@ -789,6 +789,7 @@ xfs_dq_get_next_id(
 		error = -ENOENT;
 	}
 
+out_unlock:
 	xfs_iunlock(quotip, lock_flags);
 
 	return error;
-- 
2.52.0

