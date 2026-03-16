Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6852821D3E4
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 01:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773624899; cv=none; b=hPvZcveoKKaNBe+4Krv/xO3ujAUVvNCMl58dZxT8dHra9k2HHlZi+ukX8tnyDb9Lo0hwtHJxnqrwjdLQlzHzYn8h2MWEX0WhMJiHgtw5CSOFa89wkub5IYmZ9vbMnqY22dffcn7AB1mOcqjieVOATs/3n52Gh369PBhshH3aLCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773624899; c=relaxed/simple;
	bh=iB/UTbb6o+wMf78wZzaQF/osLSHoo1tv8Gwfu9Qc8Y8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r6P22j5C3aWizM/HN1Sf6txbCosD5Cs/vZjgl3wId7R1TTn3kERSX81Dlk+FN3euuFLHk4C+1e9AlkxW0hjmzkkfYWvi35kpjhIf2IT3Qv/SK1susjv+DI8u3+q29+HOECn4OGfPpBZeCKDS7Y0a8R6XSF7w0xDIbGNHLdwkTaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=fA1OH0dY; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="fA1OH0dY"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LNVpmgc5E+2m1qUXjMs8fRitFh1ZrHWm0nd+TKM0R5g=;
	b=fA1OH0dYtGOH1EitwqVZUEOckGD65SvPc8Cypz2NXxljLG1EnfYW3+J6Bl403mmLw6sCNvIfv
	w+Goxs3fMXHBdrsufi7jc+AFmHthmq43JaR45cmQ7iDphB3fz9//ppOGRUd5ZrYsL+R6kh6QmkB
	kGSYhqoi9JCbeMulmPYAdDk=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fYyFB26nczKm5q;
	Mon, 16 Mar 2026 09:29:50 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C50D40562;
	Mon, 16 Mar 2026 09:34:49 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 09:34:48 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 16 Mar
 2026 09:34:48 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 1/3] xfs: fix possible null pointer dereference in xfs_attri_recover_work
Date: Mon, 16 Mar 2026 09:24:14 +0800
Message-ID: <20260316012416.2413909-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260316012416.2413909-1-leo.lilong@huawei.com>
References: <20260316012416.2413909-1-leo.lilong@huawei.com>
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

When xlog_recover_iget() or xlog_recover_iget_handle() fails, ip is
not guaranteed to be initialized. Calling xfs_irele(ip) unconditionally
in the error path may dereference a null pointer.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: ae673f534a30 ("xfs: record inode generation in xattr update log intent items")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_attr_item.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 354472bf45f1..3d3ac8dad519 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
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

