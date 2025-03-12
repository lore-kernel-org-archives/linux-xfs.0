Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E3978F30;
	Wed, 12 Mar 2025 01:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741743911; cv=none; b=ODnzmD+JCWjznBrJfF1+bAQnb35B/KMx02WbVepMFW1jnjr72sptKYwL9EnVZWFAxn4XiArSz512Ns8bw2Q3mDyxyNSUO6T3vPLA1OJPe0pLbCmzTJdKBAgs/a9XC/1v4f9zS9wpzjE1SHSa3XIJSSO8cOhHjOh3Iyw4V1vbNLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741743911; c=relaxed/simple;
	bh=GivvgG8lfGdY0Kmz/LN1jlH3ZWLs+dnJB14mcCSRecc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DtXgT0wHP+nqxE7oF7vQrYs3ezaf9MkrUxP2LSR9ZLvxlhDoPpHxjYUh1QywfZafe8n29tDJQQD0PLcHbJryU5zIzKqH5286iMw1NDXn/MySqbljPBcKn7+ifoW4rU5+SaRqTpyhFCoCGJkC40osC3Jy4M2Vp4Ac0MSxdOkLXts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VzwIHCer; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VzwIHCer"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1741743899; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=vuAO3EJFf0bueNKsegzqGUfxbY2wokyOplPHXl39vvM=;
	b=VzwIHCerK9OUykWLMkkT0slM2MLY+yDTVCV/MPGWuxKo4SIiEj9cWkeuRXMLUK/n6ZWHyjGzS4BLsfuPp5PAuaVg8JxeY4ccJXZdR6T5ClElBwHElwssE4IW3FQP+shwwc4p1J6E8jWh7XZxspndIQgORqqiq54hjnGWknGJn90=
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0WRAkkgt_1741743892 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Mar 2025 09:44:59 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] xfs: Remove duplicate xfs_rtbitmap.h header
Date: Wed, 12 Mar 2025 09:44:51 +0800
Message-Id: <20250312014451.101719-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./fs/xfs/libxfs/xfs_sb.c: xfs_rtbitmap.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=19446
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/xfs/libxfs/xfs_sb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e42bfd04a7c6..711e180f9ebb 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -30,7 +30,6 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
-#include "xfs_rtbitmap.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
-- 
2.32.0.3.g01195cf9f

