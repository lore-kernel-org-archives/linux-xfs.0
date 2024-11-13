Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0065516DEB4
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 09:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731489573; cv=none; b=JJMh1sN87gnAktHnSlfO2DNCvWRoXYjCXDzprX5irWI5Ao9PePzl9vtgJ2JiaM+F6g2VPau9Jgz7WwYaHhhZpIHTTuTyrW8ChMX1b8nKPsyJ92n5oYLR/1HF0AXclSJWhRn6S8Px6u1MCT/IfGrah7S/43niTz8cU8yBYo0AJNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731489573; c=relaxed/simple;
	bh=04Ze6zFPWw2ixN2wutNNRRtwwRf88wUs0ngMO2nplEc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K9LV1ivS4vE7ZAH61hEleWNpBDXH5JTxMUFnaOzmO0Kzt8C1i5mAy9UT9MiIcydcJzMrZrgvqGhmIaU1K27uT7mBdAuYmYs/8mkqwTSLekI3GjxAybeCr7sjUqPYuJInW4uLI6xxfe8o0hxhCCVeGFWMmHtoAfhIGMe82rPQHgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XpHjC4X55zDqV9;
	Wed, 13 Nov 2024 17:16:47 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id B6D141800F2;
	Wed, 13 Nov 2024 17:19:27 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Nov
 2024 17:19:27 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2] xfs: remove unknown compat feature check in superblock write validation
Date: Wed, 13 Nov 2024 17:17:15 +0800
Message-ID: <20241113091715.54565-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf500017.china.huawei.com (7.185.36.126)

Compat features are new features that older kernels can safely ignore,
allowing read-write mounts without issues. The current sb write validation
implementation returns -EFSCORRUPTED for unknown compat features,
preventing filesystem write operations and contradicting the feature's
definition.

Additionally, if the mounted image is unclean, the log recovery may need
to write to the superblock. Returning an error for unknown compat features
during sb write validation can cause mount failures.

Although XFS currently does not use compat feature flags, this issue
affects current kernels' ability to mount images that may use compat
feature flags in the future.

Since superblock read validation already warns about unknown compat
features, it's unnecessary to repeat this warning during write validation.
Therefore, the relevant code in write validation is being removed.

Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
V2: Collect reviewed tags and cc stable mail list.

 fs/xfs/libxfs/xfs_sb.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d95409f3cba6..02ebcbc4882f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -297,13 +297,6 @@ xfs_validate_sb_write(
 	 * the kernel cannot support since we checked for unsupported bits in
 	 * the read verifier, which means that memory is corrupt.
 	 */
-	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
-		xfs_warn(mp,
-"Corruption detected in superblock compatible features (0x%x)!",
-			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
-		return -EFSCORRUPTED;
-	}
-
 	if (!xfs_is_readonly(mp) &&
 	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_alert(mp,
-- 
2.39.2

