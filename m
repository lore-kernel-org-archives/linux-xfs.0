Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873E14266A5;
	Thu,  4 Jun 2026 12:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780574643; cv=none; b=ElHaMJaBUSI8/hKXm+923gSAfIp71P4vsgkPMHFKMwwLu2MnNasdVFBeaLDr3RzKkbSDZU8xc1Rg2mBlBsVkHqhGtTQG3P2NZqJpA5sNggMgPu6VNhRORTxe+YXf6dPjZn7MgRqPSyWldkyqnU8UNLQg2iDX6QJMacnkdju+1Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780574643; c=relaxed/simple;
	bh=ZM6f0eCw9JYN0eFB+IzJL2AO5YSNKkge7oh3x0mIL9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y1efq4s5RXBPwhgryp9KmrbRzJqskD7FQQm5w0ThxwzucDpdhrms9EALrVZvTWaFfAhnsIT5t7T2rjAUlj9wOqJd7rJmaQhtx/v4+HQtqIEx5qq2AvfN0tLPWfBzp8rk2IAIcfKUVYQmV2NrwX02NhZhEyL6CHxjHoTUYOmYvXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Wv9LYyop; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Wv9LYyop"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780574627;
	bh=s0SOSgnZPxT0aZX+C5VOVu4hhsXwJgTrAroZMlvrXik=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Wv9LYyopZfFF+wgWWssw6pTKXYDub7UyjG1yCx4aeDaYHxqTqXM24SuVGVYN9fk+f
	 Uz07cZEES2ZE0UBjulOy0C/jS12yR8Fg1pRv5uwmg6z0OfpuPfiEnuMyOogPmGPtty
	 AdAa07fXxHP69oDD9Fp7Hdv8hOCP+B03PUnRAkLQ=
X-QQ-mid: zesmtpsz4t1780574610tb7f59c05
X-QQ-Originating-IP: XGao/hgIYMDEWKq8wNOgeLlCI3YyVgRTcKh858Y4tQw=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 04 Jun 2026 20:03:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6098904183643236574
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] xfs: fix exchmaps reservation limit check
Date: Thu,  4 Jun 2026 20:03:17 +0800
Message-Id: <20260604120317.930273-2-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260604120317.930273-1-gaoyingjie@uniontech.com>
References: <20260604120317.930273-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: MpzYvQLGddWR8DeuEzpwGWw30dg71Z7DY36urENAZOCJyR8XI0vG4iG9
	aBw4GZY109pHZSJbAV15ZXy1oH5/nOzLnm6hu9iYFYaKzayDIgxixTj+9/b6+uX6n13mNqA
	rJEuLifjf+3LBoBfws4XRpnWecylcEsEBK5Y+e+JZVs9MbhvHj7ENtDmh9xvyg58AXBdPBS
	j/dljWdYoLQGVemFRGA8zafgOP6AuSoqWIYFHsiX4ONd3IGx8HCj7vJL0ZzMMBkXEPVDk3I
	o28DHSz9fB1MeXKGaF8Ex4aVN63ooO6+Zs8eqvm0Uz4gWc5Ax+unAGbquhE84KH7fk2IGWA
	ZfNwRe7hjkAtGrqU5AKHwQ8+YydQofA+Hr6H8FKKy0BCnjzy9kdK1BFPTXdfvWMn3THKAS4
	XH5CdtX9oDFjyFOPfteyoqPsNOEI9fR3E2TSXJguNJZQZM4EUOCdYejsmuTG+ll4IQ/Qox3
	cW5fkzGDeqshILJm6hAi6uWgVaMR4aSagZlyWcSOkkJsrxh3KULE9FxUoDySni7JixsxLsP
	qeSYfflh8Rb5dwk12MP9z0AInzhk+q9ADUtAXcKhr74djt7PrZrZLULPPmaAQ0d52j4GgDl
	aDkNr4B51bDZvywQ7aLXEQ15WuF968LJH7IutBuPN7ZY+GfStuIUE/zPTsVCmAEaSP54p0J
	EYg0TU2GTX1+6PlGr8pMQWBLGmfmfutG7t291BJSa8OoQiKu5KMUg3OWe00Kx6nDaLekOdb
	2XbOHo8duIhm5B8C2/jy1LtK/IjkNN1t/wtmfyEkkq6IhX3fe9cAwKvVtQ/aARbN5jQe50h
	gX6BMUYGncvfae2l+OId+4wDn+GmorO5qYCuTXNksGOsu/FA3SKjCQKmDeywX6jc2JTHsQo
	YAcmXgEkdeh1PPeIyewZKMD1S99+24WeNcfCDZao8Ogkt4NHftIUw1KkNlhMl8E/rlgmKq5
	EXhS8VmHeCkGFH1Xeh29r8ypp/0aaKRckdy/7cYO/xqbk+i8PFlFLZWq4HmnYa7yAZOAWWL
	hPZ7GPCj4L3+qCsfVVJJq33mTq15PKyqEA+n2Y+jP4zVtdXG/tU7Csf+FTc9C3kdZL/patV
	F8Ur2FvbNicG4FgOw++JDajtQ9yUeTYRws9Rarf5lywCg9cRe3KD6iaZyjE0EcjuA==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

xfs_exchmaps_estimate_overhead() adds the bmbt and rmapbt
overhead to a local resblks variable, but the final UINT_MAX
check still tests req->resblks.  That is the reservation value
from before the overhead was added.

The computed value is stored back in req->resblks and later passed
to xfs_trans_alloc(), whose block reservation argument is unsigned
int.  Check the computed reservation so the existing limit applies
to the value that will be used.

Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Cc: <stable@vger.kernel.org> # v6.10
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/libxfs/xfs_exchmaps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 5d28f4eac527..541e33f33167 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -711,7 +711,7 @@ xfs_exchmaps_estimate_overhead(
 		return -ENOSPC;
 
 	/* Can't actually reserve more than UINT_MAX blocks. */
-	if (req->resblks > UINT_MAX)
+	if (resblks > UINT_MAX)
 		return -ENOSPC;
 
 	req->resblks = resblks;
-- 
2.20.1

