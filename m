Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A16114F9FB;
	Fri, 14 Mar 2025 06:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741933772; cv=none; b=LU3cvfcZRXiBtDXEXS/gNcdCVjDAL9T+NcGJt73uETYPKgAWo1/+FRUd6ExCdewGFnBeIVEroYjunTpZRrUv3UgckxeFrTYFODG9T9HAe5xEkhdBtXbcF02LW66j3uwDirFTMcGbpk23aGunT5fgaIltK4FJSZAu4Fpe2PXiOq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741933772; c=relaxed/simple;
	bh=fdG7Zm21jVty5Th/nDfRD+WBbkdOq/e5tzr3KeOthsc=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=d3uuZ/gXphi7qwbultkHZOekGmSEv8TAVr7sde/pg9/USkyhvHJ7JMaZhNXtd+aVkcrS1/BJbOzIdRmX4lYldzv37WubmEgu3kREh6WgM8JNhks6fvqAry0E/onH/blbdD2WmS+0hv8zXv0OrUtJ5NRNxVK8sFrI1Klhfo3EB9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4ZDZGG6RL5z5B1Kr;
	Fri, 14 Mar 2025 14:29:26 +0800 (CST)
Received: from njb2app06.zte.com.cn ([10.55.23.119])
	by mse-fl2.zte.com.cn with SMTP id 52E6T5XF001112;
	Fri, 14 Mar 2025 14:29:06 +0800 (+08)
	(envelope-from long.yunjian@zte.com.cn)
Received: from mapi (njy2app08[null])
	by mapi (Zmail) with MAPI id mid201;
	Fri, 14 Mar 2025 14:29:07 +0800 (CST)
Date: Fri, 14 Mar 2025 14:29:07 +0800 (CST)
X-Zmail-TransId: 2b0067d3ccb31d8-0e125
X-Mailer: Zmail v1.0
Message-ID: <20250314142907818PyT07oeDc9Sr9svXo7qLc@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <long.yunjian@zte.com.cn>
To: <djwong@kernel.org>
Cc: <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mou.yi@zte.com.cn>,
        <zhang.xianwei8@zte.com.cn>, <ouyang.maochun@zte.com.cn>,
        <jiang.xuexin@zte.com.cn>, <xu.lifeng1@zte.com.cn>,
        <lv.mengzhao@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSB4ZnM6IEZpeCBzcGVsbGluZyBtaXN0YWtlICJkcml0eSIgLT4gImRpcnR5Ig==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 52E6T5XF001112
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 67D3CCC6.004/4ZDZGG6RL5z5B1Kr

From: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
There is a spelling mistake in fs/xfs/xfs_log.c. Fix it.
Signed-off-by: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
---
fs/xfs/xfs_log.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f8851ff835de..ba700785759a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2887,7 +2887,7 @@ xlog_force_and_check_iclog(
*
*     1. the current iclog is active and has no data; the previous iclog
*             is in the active or dirty state.
- *     2. the current iclog is drity, and the previous iclog is in the
+ *     2. the current iclog is dirty, and the previous iclog is in the
*             active or dirty state.
*
* We may sleep if:
--
2.27.0
