Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961493F8EA1;
	Tue, 26 May 2026 12:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779798795; cv=none; b=o0ioVtdvxAdhgrgXRFSdAn70ZOdtR7o2Ivl0EuQBqoct/eastdn0qkxobMvJMx8gtPVVy0RVlLTZ6usJQgDtqA5wtp+6jeDIhHy6nv0vkJGdiZlaVZY/pNg2XVRkpouWi4IYRZaiZe90Bgv0dqROHsdSLszv7g9m+bg7ky0ZOvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779798795; c=relaxed/simple;
	bh=PIeGovJWR+9qlcjuvzvAzzARUMNofNBUpzLY3R2yR64=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ODLuQQ+sX4/2nYIsQilxFzzxqyPkQantdc7mfXb9WFfMOsH+cVN99yoJjDwhxS8mgoy/1Pem+ZFlygiIK15T2Kpw3JosrxsWchDeyOOO8k8Fo0yHDbYb/bhwAAJVcyfBnL+035f8vvoh4e4wD3mlWg7jP31fwEn08tZ6Y7PUIwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=UCCZgNIE; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="UCCZgNIE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779798773;
	bh=KAsRLM2RHIoBsO0R53ZclbtIW9Og4qzgUSGzjMC8zSs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=UCCZgNIE85PA2MkuUM6cWIOIJrJ13uJw29AYiHCiXD1D3l4+vuU712MiyB9sPRn+8
	 fhK3uRHhzvifS5nYlh53zSsHEJandzuJNA3S4rUh6OKvutkhgOPGucpl81LzNA81Xb
	 Sd5cDvGUrasVR702t8XtAsoQuPMaOyr7csc9c+4M=
X-QQ-mid: esmtpsz20t1779798769t7ad6cdd0
X-QQ-Originating-IP: JSSuqM8OKOWaBQEOeWB6CHd1FVfv/hMQs99gpRihVUo=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 26 May 2026 20:32:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4177636265700696433
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH 0/2] xfs: fix CoW fork repair error handling
Date: Tue, 26 May 2026 20:32:41 +0800
Message-Id: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: NpwLs+EI9Kdrb/v3OMHCw/kqgRGqQ4bj33EO9QLge7ZRV2CpPN5FbM++
	8t0Gv6pIv1eRWJSu0BgK5Ry8FVRdh3C5IYHWy/cJQVN05xrgJbfNiRmNnmFtbUayfUciBpX
	UQ9sTzORXq5id49o+ti10p4GbzEY6uELAzSUC/grqtvKoPhKFwjj3b2p7XcbPqPXl6MzgMH
	A/7qusOLMtlaxA8b0Mf7pMXFqYZBu/Ibyz/QzLBdozgKTOBY2TxVyInFow0jC9P9DwoViIz
	UB4NABpPVrg6tj8OXZjNXqWQ1Rga/oaAIU3s0tUQc7wbwGrC1nr3a+NxaEHvT/KVvEYPoVX
	gT9uI8fYDsnTGp22lJhg+TTbQRT5TLpCHE63fD0d0c9Thast/1mT+0HxNuAm49lhYjJuq0t
	TcPe2Y5VUZk/UNz99soxtmFTxbqQsWR9YOOu10kFV+H0zIxwGweT8tJaezCyZr5KdBsdnIp
	syQ9f9CoVL5S31TT3szCrYLF3DQelSjHU45yzXuWjiCbWEeo3vswcGr/PLqNGETOhlSs26Z
	HNdABU4q87tEE1tVi6RVpuBh69SZ0LTQiESDrXyrRmavg43pPX7g1o/BJOs1KbjN2XCmFum
	QtbDorpYHmqvhJjfdiYyZ9y2M0vjK5uBWSM0eJl+WV5PemnZGx/3b4lms4hOSjReKBwkR+R
	+d8Ww416BpV6sdmHWPpnbdCAymKlzgd7MhsVuKKtIfYzKT9dAnBKdeOBsnM3Ei+XS3z35FB
	aq6AlI+kuf6QBjc/w0C7cg07/P5D9a8LCMflovqShgKviAXFoc4tmC4Urx5ow3xS8OS0bAG
	kxMgApnfIf0FI+W5XKeU0bVCMxdXbZj3MWGNg3SYgAm/0kI0dtyYAhEG545BZ26tBrsxBKq
	pXdujI2bINP1vUWcqK+KfK3OSAQV53Z48LbA/lnC8kaiRp/qY2eSZHYt38fDhjJxbbYMR9+
	tujm0wcYDtlBD2nmB98kpOcMF99z9ZdvvnIQOK9+Ob/vVtd1ZvwP+vHbilStJY/R8XOBLy0
	omDO2lQ78AML9SVOn5syPYeXkPuTNxCihi9qhCiNsJKw4QJgxFcgCtO1/MuODwuT4VRcryy
	pJaApzVzcjm2UYVFK4ms1DUO7vM00uw5h1Rdqgr3kIc
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Hi all,

This series fixes two error handling bugs in the CoW fork repair code.

The non-realtime helper can lose real failures in two different ways:
it returns success after the common cleanup labels, and the
force-rebuild path can return directly without freeing the AG repair
context.

The realtime helper has a related cleanup bug in its force-rebuild
path.  If marking the full mapping fails, the code jumps past the
rtgroup scrub cleanup and only drops the local rtgroup reference.

Split the fixes into two patches so that the non-RT and RT changes
remain easy to review and bisect independently.

Patches in this series:
  1. fix non-RT CoW fork repair error returns and cleanup
  2. fix RT CoW fork repair cleanup

Thanks,
Yingjie

Yingjie Gao (2):
  xfs: fix error returns in CoW fork repair
  xfs: fix rtgroup cleanup in CoW fork repair

 fs/xfs/scrub/cow_repair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.20.1
