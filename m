Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC792441A6
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 01:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883029; cv=none; b=RHednU1FmJZtQj4opAxbf4OPbEqRP8b8Tk31ZOJA5IL9KX7nqx+KQw3qvdaDKKcwCg4DA0pwaU3FJ3fjd1Odbb4yShsAEHwp/HXLGrJ8tvt14z8IxgPz54fNDjmhetgSY7FqIM5B30Z/kItPnmNC495TubzKFIzJ2gcmCsRgX5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883029; c=relaxed/simple;
	bh=XPbTsxhdjApXwdbRUf18hY9fsj59n5BF/he5h57L3zw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmZ6n4HXI65Xau90rrjmD+mjiQmQ4GVqTlEbAwxFt5fRtEnl43Tgpf1n+vjMuymeXMqF3QMyWd4re3HTTSYKbzbpUrWX95XIDy3zh2IoQ5Jl00hKS1VYY7KlQUWP/e4r5xql3bByYueGUIz0KZ/Z0RAqzwZSiKlNCU4edcuWtkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=LJhFVODf; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="LJhFVODf"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gWYtibv1Q4mnFFkcyl2KWymJp7yjzfyRk9OXap/+57c=;
	b=LJhFVODfDqe/5OF2t+1f3yFd2ZoR1PklKtL42LtaVUNJhbOBEnaFSQJ4edJnr07jjRXaAHje6
	XiSzD+AVRw+his6ZVDCRBC6o7xrkCzJ+SEBAbbNo2U9DhUTTBArjEhnLe9SGGMXdLrpAc1dgLtM
	Wv0t30sN3Jvf4vE/NRwjIVc=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fbnhW59q3zcZyc;
	Thu, 19 Mar 2026 09:11:23 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0896340569;
	Thu, 19 Mar 2026 09:17:04 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 19 Mar 2026 09:17:03 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 19 Mar
 2026 09:17:03 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2 1/3] xfs: fix possible null pointer dereference in xfs_attri_recover_work
Date: Thu, 19 Mar 2026 09:06:16 +0800
Message-ID: <20260319010618.722448-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260319010618.722448-1-leo.lilong@huawei.com>
References: <20260319010618.722448-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemn100013.china.huawei.com (7.202.194.116)

When xlog_recover_iget() or xlog_recover_iget_handle() fails, ip is
not guaranteed to be initialized. Calling xfs_irele(ip) unconditionally
in the error path may dereference a null pointer.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: ae673f534a30 ("xfs: record inode generation in xattr update log intent items")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_attr_item.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 354472bf45f1..8ebdd0926b89 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -633,7 +633,7 @@ xfs_attri_recover_work(
 {
 	struct xfs_attr_intent		*attr;
 	struct xfs_da_args		*args;
-	struct xfs_inode		*ip;
+	struct xfs_inode		*ip = NULL;
 	int				local;
 	int				error;
 
@@ -653,7 +653,8 @@ xfs_attri_recover_work(
 		break;
 	}
 	if (error) {
-		xfs_irele(ip);
+		if (ip)
+			xfs_irele(ip);
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
 				sizeof(*attrp));
 		return ERR_PTR(-EFSCORRUPTED);
-- 
2.39.2

