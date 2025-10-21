Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED129238C1F
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056312; cv=none; b=Mj3lPWwqJmu/sWHr+cXgOXMYKadlNLFMTeQrbeuDBSjUjnQLrTSbJRI86SuO8squfQQ0NYJ31rl0+N7P29DVzqqwBU+tRqMdQFv5gb9fOq20UvzpZV6hwIU2m3Rsza5YlRq1gSGOXNdfsRct+HCHoWWRMTtXJ+6p+ZYhqgN590U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056312; c=relaxed/simple;
	bh=3Yxm71XSwRfJ3oOGDCqCxlTnxt+ad4L76IOZ0nmQDwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDPcMJNvGjSJWYZBjjx1EV1X2XMa9/iFM0xg5bSLE2fa88PA0ug/5GMp7sXW3rBlL/TnqeCfOIRS0C1/+S79Um5MtXOAU1DGNDMX9Wt8xVR+PAIvANJZCxVUMh5aI/Z1JAoWL4CzHSSqdYeqKaXKfvYqOAG+ys35bR8lLqI3MPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 2BB1D180F2C3;
	Tue, 21 Oct 2025 16:18:26 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 24M5EyKW92ioeRoAKEJqOA:T3
	(envelope-from <lukas@herbolt.com>); Tue, 21 Oct 2025 16:18:26 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 2/2] xfs: Remove WARN_ONCE if xfs_uuid_table grows over 2x PAGE_SIZE.
Date: Tue, 21 Oct 2025 16:17:45 +0200
Message-ID: <20251021141744.1375627-4-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021141744.1375627-1-lukas@herbolt.com>
References: <20251021141744.1375627-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The krealloc prints out warning if allocation is bigger than 2x PAGE_SIZE,
lets use kvrealloc for the memory allocation.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 fs/xfs/xfs_mount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index dc32c5e34d817..e728e61c9325a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -89,7 +89,7 @@ xfs_uuid_mount(
 	}
 
 	if (hole < 0) {
-		xfs_uuid_table = krealloc(xfs_uuid_table,
+		xfs_uuid_table = kvrealloc(xfs_uuid_table,
 			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
 			GFP_KERNEL | __GFP_NOFAIL);
 		hole = xfs_uuid_table_size++;
-- 
2.51.0

