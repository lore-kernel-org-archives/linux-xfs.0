Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C072D17BB35;
	Sat, 17 May 2025 07:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747468111; cv=none; b=GubASjiXV2czWyHRo4AFqhVzkrGVxlXcdh13qDktdY0SgoS5pwb3JG4Kf5P2aTsQpfeLbcVlNYCzsp1dWzpNXbvQ1/PH57RnuyeG+f+cSEOVvQSflsAQNQ/HH1jlfdWMR+/uTm9iFcM7q4n3LoFB5Rl9eZaLr64XiS9/eDiHIp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747468111; c=relaxed/simple;
	bh=ZSikwAU7c0F2dt8+o8xJqgllizx/j0y5JYScJWfyImo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aAR9dg6fHKu9ey+WNkbEr2nCnN+jbj0laklYsCwW3wpnI8Ss81lpY4/YkM4+LAcCQSQ5VRGs3iFaF7VaVi16unOEQ/3makRNetWKLx/WBGiDf1WWpUKHPC3vJjJefkN3RAEvDtvS9Y0YKlxh+c29zRNqDljj+dsJwQPjElaKFb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZzwyG4WV7ztR28;
	Sat, 17 May 2025 15:47:02 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 08A0D14020C;
	Sat, 17 May 2025 15:48:19 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 May 2025 15:48:18 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <cem@kernel.org>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>, <leo.lilong@huawei.com>
Subject: [PATCH] xfs: Remove unnecessary checks in functions related to xfs_fsmap
Date: Sat, 17 May 2025 15:43:41 +0800
Message-ID: <20250517074341.3841468-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemf100017.china.huawei.com (7.202.181.16)

From: Zizhi Wo <wozizhi@huaweicloud.com>

In __xfs_getfsmap_datadev(), if "pag_agno(pag) == end_ag", we don't need
to check the result of query_fn(), because there won't be another iteration
of the loop anyway. Also, both before and after the change, info->group
will eventually be set to NULL and the reference count of xfs_group will
also be decremented before exiting the iteration.

The same logic applies to other similar functions as well, so related
cleanup operations are performed together.

Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/xfs_fsmap.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 414b27a86458..792282aa8a29 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -579,8 +579,6 @@ __xfs_getfsmap_datadev(
 		if (pag_agno(pag) == end_ag) {
 			info->last = true;
 			error = query_fn(tp, info, &bt_cur, priv);
-			if (error)
-				break;
 		}
 		info->group = NULL;
 	}
@@ -813,8 +811,6 @@ xfs_getfsmap_rtdev_rtbitmap(
 			info->last = true;
 			error = xfs_getfsmap_rtdev_rtbitmap_helper(rtg, tp,
 					&ahigh, info);
-			if (error)
-				break;
 		}
 
 		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
@@ -1018,8 +1014,6 @@ xfs_getfsmap_rtdev_rmapbt(
 			info->last = true;
 			error = xfs_getfsmap_rtdev_rmapbt_helper(bt_cur,
 					&info->high, info);
-			if (error)
-				break;
 		}
 		info->group = NULL;
 	}
-- 
2.39.2

