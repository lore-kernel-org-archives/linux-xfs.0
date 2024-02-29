Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB3846B9F
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 08:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709195681; cv=none; b=coMmIEs904yQJBlTJPnsHKu8EzsAh9pCanrp5V/DkD0CesLUJZkeELD/NqedWTWlw5eaxzPqSWy42ew+J8CjPeqmbb96vN2VZ7QwqQIDEYHzvc4N1JZkl5Zyf0BNPWCV6c3rPFH3+s8eCOlQ5cC6bJdbKPXQtY6yFW9KBxvneOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709195681; c=relaxed/simple;
	bh=PtmJDoA1H7SAn1CqzqBzHGTEfAfkzw/1rSUcVqWa4Ig=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pJXkCEa4TVyu8GvxyYMiVjlMwZPUmlO+HjuebGPvDmHPaJr5WEKbuIjLBxOYqzKUrN7XY1vRR34afUxQpvFDo/g17kkjRGx0V8rwH4mIz2ORlNyZrsWUsgwAzX3pg6i8EsHDkY4H+j4AiZ/WHr7FhLHrD0KRC2404Qy9EluMnTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mQLRID5R; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mQLRID5R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709195675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c4hqPXVYzAPKLJpLD1lYkRxhseQa0+qO76gLH6MQGf8=;
	b=mQLRID5RGJsIYKfmSTAqOY53BAsA4WAZ0BePYmie39/1QizuzOovA5S4I5TBOiAVyoWp3H
	CNJjh9ZM5cv+BCAsrdYIudxwvCfWG/jGFQcnfH3xj7SVFa3QkHEHr0UFNmJ4+yKZpbndt8
	jVp0H/m+WelwzyxcDMbdVU+sfssmHAs=
From: kunwu.chan@linux.dev
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] xfs: use KMEM_CACHE() to create xfs_defer_pending cache
Date: Thu, 29 Feb 2024 16:33:42 +0800
Message-Id: <20240229083342.1128686-1-kunwu.chan@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Kunwu Chan <chentao@kylinos.cn>

Use the KMEM_CACHE() macro instead of kmem_cache_create() to simplify
the creation of SLAB caches when the default values are used.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 fs/xfs/libxfs/xfs_defer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 66a17910d021..6d957fcc17f2 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -1143,9 +1143,7 @@ xfs_defer_resources_rele(
 static inline int __init
 xfs_defer_init_cache(void)
 {
-	xfs_defer_pending_cache = kmem_cache_create("xfs_defer_pending",
-			sizeof(struct xfs_defer_pending),
-			0, 0, NULL);
+	xfs_defer_pending_cache = KMEM_CACHE(xfs_defer_pending, 0);
 
 	return xfs_defer_pending_cache != NULL ? 0 : -ENOMEM;
 }
-- 
2.39.2

