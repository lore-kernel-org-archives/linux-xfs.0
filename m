Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1A43AFD0F;
	Tue,  9 Jun 2026 11:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781003886; cv=none; b=gJJhecayr3ruuxWkXFaEeZEhP95mvfKXzN1qREDISS0pZ9AzCKvS7+7xdUi0YZoHZY6FONU9I/fIZI3PNwx7u2A3IHtAdvHLXw2zJWl8oKix2kYNJhBiBGBn+5ehI5vWlepytu854sv5xGYDyOmgvmjlN90IXH9bNakdGGi1rRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781003886; c=relaxed/simple;
	bh=HqSjYXFzvgFjnuY/T/UC5g9ZPIQWWePvTyN2YXHyYRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lv0eW5qia/JWlYBRm02eqd8Tg2Xp5LzlleL2Hq8EKHfYYbd3eNcXcN2e8wdf07ECTtdrWP9GGsmYV0byFc7uLCcnLZpXtd5OeC/zLzvzyLPrwUEo1evwWFsVNntV6r4w+XbUg+beUgLVC+euyTDZVRk2oqe4lMmIB+TGXM0mIXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=C6BHhY46; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="C6BHhY46"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781003863;
	bh=HfKB3NFhYt9Qklt0zvqgg1BnrYq0qQXgIUfb3iapmek=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=C6BHhY46s/US8X6oguSUDNwaINGbIKy74PsHEYM8OW3U0nCAovxnMR/ih3QB8iDIl
	 9DTbNPvW9so8vUJhMUjPqvXN2rSfLJTsOSOnieoiUCPrFfp30iWc6dfK4tz875WHRS
	 yqsTOTo5pq/67p8km76AJazNCJS/dahfI8I0N8rk=
X-QQ-mid: zesmtpgz5t1781003847taa9da4aa
X-QQ-Originating-IP: NA9sj2Id/sCXTG7UclQp0KVCGUN69dLUikY+vgeTK0c=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 09 Jun 2026 19:17:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6743455896570649818
EX-QQ-RecipientCnt: 6
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] xfs: fix inode ref leak in attr intent recovery
Date: Tue,  9 Jun 2026 19:16:18 +0800
Message-Id: <20260609111619.1866748-2-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: Mr/o/c6gDciS83J1T2YOPTsrLE5drGjbYIAhej4hHUtHN/ehkr9EglkD
	FJK9gUOtz0cKAK/obBJ2cyZhwnZZmHhfoP4UJZbE+Z8bQ6rksEU22Beih50Ipt9vTKULmZ9
	g4PDZ2mTxcwsRZOCDRAgWzi/4I4gTBJWXu8k6cp4QUEUifnD0pvZPlmkhWH5vm7LQINvzK/
	YWMAnpriwjsbq48ep2z7m226sTHGGq6AD2vbFpLBA0gJvF4rBz9dd95LilqSGoxJOlHCkoF
	N6o884FJqoqpeLunVxrZK+Vmkh6tiL0+/YN/xtBTIhel75iP54R/KqJot4Y4mvp6VwWngqa
	j/ewLXbY78DJERuxUDkK1JaYU1OwB8XngbLfZmUchs05AKz+13zsBhnityGODDEOK0S541X
	KPcj+ym1a3DJUVnZHxQ9hJIs7q2xRbnMfwRM6ms/P/Z5MvrM+asS+SNpRB7aFwRnxer/tq+
	UoakI++9igYnksZEZfxsB4tkOUGRe3r74LexgiMnmxrBSsrE8T/E7f8tykJ5MemCqnP1mnU
	td2YtGlxTaccjq8/pv0rIm4YY+1QxwPe7g0NgTZ7KMEeo6+4/O4trXJ5MRwLTrZfBvVZyJ9
	M4eMLeuaeRHCB/Fqh57rXusSD3Mqmulk8b6h2S7ROCtznyZZfoVVDSEJIhgV2OGiG0Cvsem
	n7U+VOi3WqXw+7kVfj2wd0Yh0cW2/5L+RffBVuMUTNsPt+LNlWUveZhQSoqVGCGzyyN9xeF
	L2sjbhXKwPfebYZeXBSA8ikPZtVJXheQw9nSnhcsKaY9B42/8D+5Do6mGyvhYGE0m3XqVx+
	JKkSHu/VPfSkgF28Rt+9nP2pfIbYtHwUuHOLlbqdAfMtZk+G12jUdVj05QGpz1fs+hNEQJC
	nwT+bK/HrILWBP1EaoCnTlKt0eskk6NpPltTmSM34xPhv8Sa4uuOzqXinB/oQ5a6mLv5xcd
	eVAqdQjYdUzNq2Hbx+C4ooJqG1QOJH8FtOq13SEr6yibyjWh94hOmY0uxb2mIKJdFDfiIhw
	eopinDugmtzBYKx75qFNDe1BPgOtStfLvcbhu95BuLyq3OjTnt
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

xfs_attri_recover_work() grabs the target inode, attaches it to the
reconstructed attr work item, and adds that work item to the defer
pending list.

If xfs_attr_recover_work() fails to allocate the recovery transaction,
it returns immediately without dropping the inode reference.  The later
cancel path only frees the attr work item state, so the inode reference
leaks.

Release the inode before returning the transaction allocation failure.

Fixes: e70fb328d527 ("xfs: recreate work items when recovering intent items")
Cc: <stable@vger.kernel.org> # v6.8
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/xfs_attr_item.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index deab14f31b38..c3d96c7a5bca 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -773,8 +773,10 @@ xfs_attr_recover_work(
 	}
 	resv = xlog_recover_resv(&resv);
 	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
-	if (error)
+	if (error) {
+		xfs_irele(ip);
 		return error;
+	}
 	args->trans = tp;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-- 
2.20.1

