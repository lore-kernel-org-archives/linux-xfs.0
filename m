Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEAF194091;
	Sat, 15 Mar 2025 06:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742020345; cv=none; b=UOzbW/pRpARsb+4ChowzTgIu7mU0eDdN4IQuKEcqLwmnWCPfWd+nGDXcAF9A0iIkN2LvRFGNY0/Ss/y7g6zL00X2yeshESS7LOlGhzh8S3haKa1d78JRlNVXuTbD8FaokOqjlOjXH/CcIMr76wusJykfCFklDXDPPmpto0GNatA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742020345; c=relaxed/simple;
	bh=Bdvs3uwRCMr0NVGM6GmZxfEAaRANq6XlAJNJV+MsXA4=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=PjtgHNXzOYVL5Kx52kpOdCx5k+Djz1mOBs2JeaQNnf2LQFnnlHTPRWblm/7J64lXMNVQpqKkK9HGLgTkeFDnj5PGv9Dg81EwT9JuV9K9qHk1CcS7EYxNPjk5B+oO943V2ei+sK+nu4gVV42mWfNIMaJ+e+oNE9K04qyNWF36PKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4ZFBHB0Nvbz5B1J6;
	Sat, 15 Mar 2025 14:32:22 +0800 (CST)
Received: from njy2app04.zte.com.cn ([10.40.12.64])
	by mse-fl2.zte.com.cn with SMTP id 52F6WE1T061231;
	Sat, 15 Mar 2025 14:32:14 +0800 (+08)
	(envelope-from long.yunjian@zte.com.cn)
Received: from mapi (njy2app08[null])
	by mapi (Zmail) with MAPI id mid201;
	Sat, 15 Mar 2025 14:32:16 +0800 (CST)
Date: Sat, 15 Mar 2025 14:32:16 +0800 (CST)
X-Zmail-TransId: 2b0067d51ef0ffffffffda5-b674f
X-Mailer: Zmail v1.0
Message-ID: <20250315143216175uf7xlZ4jkOfP5o3oxuM4z@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <long.yunjian@zte.com.cn>
To: <djwong@kernel.org>
Cc: <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mou.yi@zte.com.cn>,
        <zhang.xianwei8@zte.com.cn>, <ouyang.maochun@zte.com.cn>,
        <jiang.xuexin@zte.com.cn>, <lv.mengzhao@zte.com.cn>,
        <xu.lifeng1@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyXSB4ZnM6IEZpeCBzcGVsbGluZyBtaXN0YWtlICJkcml0eSIgLT4gImRpcnR5Ig==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 52F6WE1T061231
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 67D51EF6.000/4ZFBHB0Nvbz5B1J6

From: Zhang Xianwei <zhang.xianwei8@zte.com.cn>

There is a spelling mistake in fs/xfs/xfs_log.c. Fix it.

Signed-off-by: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
---
v1 -> v2
fix the format of this patch
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f8851ff835de..ba700785759a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2887,7 +2887,7 @@ xlog_force_and_check_iclog(
  *
  *	1. the current iclog is active and has no data; the previous iclog
  *		is in the active or dirty state.
- *	2. the current iclog is drity, and the previous iclog is in the
+ *	2. the current iclog is dirty, and the previous iclog is in the
  *		active or dirty state.
  *
  * We may sleep if:
-- 
2.27.0
