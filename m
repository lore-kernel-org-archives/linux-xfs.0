Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFA81FC7
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 02:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773712962; cv=none; b=UJdMCgbr4Vf2nEybMQCfclrPCa3q+5NYAyruR5qdBMqtXncxD5AGkae8NzirsgRMRyOod28JJsRPNOS/s+zHLf8yi1sUlywjb18pCDIFDoZpfs9f50ZfVgGvH7aypc0iQDxbMUnuESMmY5+SjKm6c/ZJAVF6D5PiFJZ6MYjCvEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773712962; c=relaxed/simple;
	bh=cJAkeJvihkEVTFrQb8UxvRKSFvkI/rqQcoFKEXIQ3BU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bcxnE+jXhsKSGasLgZQZaJHVunBtKYRRBuQ+uMkh2N2nCqJExBtDn7iw4DRddCAfnMS391rRtoVeKqu7moeyVsSu4Wh839fnsf2+u2SGrdlIHdqgh9PhPKcxrstNeNTjd6jv6khSpU6b5/a1c06Ed3FsjgozZm5sPTosgKEHegU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=CjIrihv0; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="CjIrihv0"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+m1r00usAOVWL0madypsr3hYAtadbZi1CU33TVAO6N0=;
	b=CjIrihv0hBVU0rq4wyUz3gmP+S3OFISFck8cbp5Vrjbq39E9JOtrCe5HEtQqv5+docdp7rCIY
	b1ZeT2hVB0sVsLewdi17xqAhDIvmOpD80IodPA37MzPzgNpo0SUKOreomIGJCLkxGdWEbeKdrw8
	Xp9J3YV9WKe0WKHB7SffgVk=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fZZpm1462z1prKM;
	Tue, 17 Mar 2026 09:57:36 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CEE52022B;
	Tue, 17 Mar 2026 10:02:37 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 10:02:33 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 17 Mar
 2026 10:02:32 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v3 1/4] xfs: only assert new size for datafork during truncate extents
Date: Tue, 17 Mar 2026 09:51:52 +0800
Message-ID: <20260317015155.589955-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260317015155.589955-1-leo.lilong@huawei.com>
References: <20260317015155.589955-1-leo.lilong@huawei.com>
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

The assertion functions properly because we currently only truncate the
attr to a zero size. Any other new size of the attr is not preempted.
Make this assertion is specific to the datafork, preparing for
subsequent patches to truncate the attribute to a non-zero size.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 50c0404f9064..beaa26ec62da 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1048,7 +1048,8 @@ xfs_itruncate_extents_flags(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	if (icount_read(VFS_I(ip)))
 		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
-	ASSERT(new_size <= XFS_ISIZE(ip));
+	if (whichfork == XFS_DATA_FORK)
+		ASSERT(new_size <= XFS_ISIZE(ip));
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(ip->i_itemp->ili_lock_flags == 0);
-- 
2.39.2

