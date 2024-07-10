Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED35110F1;
	Wed, 10 Jul 2024 02:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720579541; cv=none; b=uBglMVPZZC8VzmT098M7AaXRn4OrJw0H5s5R7Q8y3Vz6Z/l/tjfiyenzTxjEzJHxLM45FPxTsNIc29a72IbdDf1zhawE5CGhYHZ7dYCrKXcPAlYpdut+GFueT4POVS4W/Bxk8zts0FoSuXbp1dHKeFe/iPIAjgJ5+zAAChqde9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720579541; c=relaxed/simple;
	bh=ksdQjq+1KUig1fjJdA1BXJDDhIyqzuZEd/8ozbkGAJ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i8A6g1RqyREgGqBRrTPK/IV9Sm4caxi77oLQAq7+28ez4Xm9bN6sMDzZOQz4Mtf1IxGDgY55c3xVryjNwTAh/84aHsOMxYmD+GUs9iY4ENFqodRqmoWvR4jRc4YwU8GFNdkbCrGj+TRTun6W5ZgzPU0bUzGU4WRYgdgiIXFZXMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NN+StjTj; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NN+StjTj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1720579531; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=1jVY+iHmbpWBDePtYh7pU1F1dZO6NtiTS/7Fv1KbDfc=;
	b=NN+StjTjpfQ4UNrKZYmrEOoLOjIFDos4J1YiczVok0Vk7V3EHvnhG6tnsHuvN/BvQmP4YFyZ3ZsC12he2KUbYf+taWLmJdW81cQfWVZ3ro+hQMMKJqsBmisn62gwEvnmZ6Ts0zhhbjHZYL8eESlgBYJ7YZeT/IrKEWZp8Dckcyg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045220184;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0WADVMcw_1720579519;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0WADVMcw_1720579519)
          by smtp.aliyun-inc.com;
          Wed, 10 Jul 2024 10:45:31 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] xfs: Remove duplicate xfs_trans_priv.h header
Date: Wed, 10 Jul 2024 10:45:14 +0800
Message-Id: <20240710024514.49176-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./fs/xfs/libxfs/xfs_defer.c: xfs_trans_priv.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9491
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/xfs/libxfs/xfs_defer.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 40021849b42f..2cd212ad2c1d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -28,7 +28,6 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
-#include "xfs_trans_priv.h"
 #include "xfs_exchmaps.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
-- 
2.20.1.7.g153144c

