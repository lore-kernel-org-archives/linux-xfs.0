Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAD33F7A82;
	Tue, 26 May 2026 12:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779798801; cv=none; b=XJ8/90cSmSZ0yMpO1MmqHXMxSQkoc32VV/+G/Kt036z6tz8V0wnE+Kbea7xlCw0Caxs1IVr30cw1FiF8NDjIx7/GIXzGE+Sb8ZrMFHeyQIVyTXNw/HLxe7gjaeZZn3zUrHtVpZFFslMtN4P0jtvur5qLuueu25H6VNd05A2ASgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779798801; c=relaxed/simple;
	bh=lqZx1n1Q5AGAZrMchbnMcQzHA3rt1w75o3QGv84JgXE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GyA/XyV3nJ6JssaPJFb0qGU2dhfxoZSWcnDAkVdWqhQESfYGlL2V5Fj5x8OXYVqyvzDUB8snBXt/wMtPRnXBv7kyEFFz3uWGG7Eq3oPD9lEeL2UkAn+1DI+o7Q6rXVVPhNsHwLuAKes28bqnnYsvXnDxMDhFmP+ujLFTFOtIbyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dviJ5/uZ; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dviJ5/uZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779798780;
	bh=b2TGr66TxG71n4gVQ7lKB85drS4BhXt8ftql4mur/GY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=dviJ5/uZP4Ki8jAp1o4hIeZ6ST9BGzZtF+tXDnIxOxl6vO56sGHFNbprHUM9UJy8Z
	 vxyUMOlqdN/O6sTmcRJ/X8mIMv7Ca124+Rfxns7lrwnWJ9QYbFwHSCUUQaBuSdRbnm
	 doGLkQScelQPijGlN8Mg+ln8PWvqRgIb/FXDxl5c=
X-QQ-mid: esmtpsz20t1779798776t2bc0846a
X-QQ-Originating-IP: zaGli83rFYizyqOhxiQabr+t9qK8uw9jBsbXKjpCEp0=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 26 May 2026 20:32:54 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7825738485686643237
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH 2/2] xfs: fix rtgroup cleanup in CoW fork repair
Date: Tue, 26 May 2026 20:32:43 +0800
Message-Id: <20260526123243.1078867-3-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
References: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: OB2Lc9hvzYNzyoR9SmMv8TzFqu06dkn+dm18N0/hbnVg7zFwQViZVcTO
	YZkXQWypx8Q+klOZKVRCUUGNgYNfEs+Kd0H3x7kArMJQNwjLRsUHCsH+oLQDf8/OuewTf1S
	aMw+EwX3m/fc7ihgJ/T5u4b9TF813v9fijYAiFp9tURGis+mrN9kUwNUrjn4WVhcDiWO6QH
	R7mwZskwcRmD7nJYwu13ge9k6GuIydismI8P06oS4XYbetSYZGY9na2OznkrtnM9x8SJCzw
	PljxUiFhETIsODAvCeazw0q/35gnA++dNhTcEMpaFVCYmquNVXmIGiXK270xfiJN8U4ffBG
	C1yCvIYZV0x31/Ttx1rIGe8wH9mZZoX2CNtWWmqrVB7wrD7f99oSIHMtobPqGGMjdUSD5h/
	I5hiCToDQG8Qzqgi7kzHeNlCLWNqcNo9zdOjU9m3JzGjvCrBQK53R2CBt/VPmSnJVSA42VA
	vaCcspCKTdFrX+i7AUgAXgscd0jqTbgXVhjw7FGAj5d4fJ16ber22BS5y8RokAtwaezJehZ
	vMF9jy0jCy34tcY7o3ZY5pFFByfKDErEwOlJgfujdCseRCEo48B1kz7tCkwTQmqGddWmITc
	QRmKIe4wXrpm2nzeoeVCsAIx7TP44tqbCk71lhHu2WyskYadDJzPs1jb8C2QNu8u+Al6VJZ
	e+fNjyIpXLuYnpBCk6C4fGEQBkIhdcWpSeoYN45sKHdntjN6a2FJaJ6PygLoiSpWB9RXDA/
	/65OIUzZ8grKe/QqMRkAMwGfZ2qTonwsMbpu3BAF6270UIV9laRex8zEVk6ZNLREn365t26
	520UEjh29ss2pgv4Nu6IQLTuOAwg0PW7FtYev0P/PY3IBofQ9qdWWUpGsCeMd/g0MN2L3eb
	Z8QPt+ql88QnLm8IBoCdbtMMaE3aRU7yYGpVXLvwLOWFKD5/sb4st4VcYWoLPj6E5zbr9Qc
	h98jYUODLKpn/xA5BGnSpskY7GKHLC6wq+V8kXCuZoARnJl+278g8TmFZ+BmtbPDjihZLzJ
	WsW0raOOWO81WeCmB5zitvszYoFUmqn3ooXgs+Y5SvJbEDX9C7ZpB/TSAzH2CyLro78yZ6V
	QYjFXJ5bmQcK74fDLAtaJrZYEdtzS+k1HRpzESE7UvLtwb6rNjQWE6hvl/9V6KlOA==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

The realtime CoW fork repair scan initializes scrub rtgroup state
before it checks whether the whole mapping should be rebuilt.  That
state includes realtime btree cursors, rtgroup locks, and an extra
sr->rtg reference.

If marking the full mapping fails in the force-rebuild path, the code
jumps directly to out_rtg.  That only drops the local rtgroup reference
and skips the scrub rtgroup cleanup, leaving the cursors, lock, and
sr->rtg reference behind.

Jump to out_sr instead so this error path matches the other failures
after xrep_rtgroup_init().

Fixes: fd97fe111208 ("xfs: fix CoW forks for realtime files")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/scrub/cow_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index bc3838bac71a..bff25cf74e29 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -389,7 +389,7 @@ xrep_cow_find_bad_rt(
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
 		if (error)
-			goto out_rtg;
+			goto out_sr;
 	}
 
 out_sr:
-- 
2.20.1

