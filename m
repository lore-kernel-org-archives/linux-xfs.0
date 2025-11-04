Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C77021FF47;
	Tue,  4 Nov 2025 09:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762248974; cv=none; b=tEFHKRn9av+DO5qz3MN3yAMUm23843sxZVFAWg7q997Evt8gEXA2EeleqRWZAs2wV2KGWhpvGqljwH1y1oJnSoeaOwjxU8cvnMrG5y1UWBDZwx4PkeZrHfMPfR9v5jsdGbmfIxTiyY4fq7y8+BAvhUGkDB4wUkl/GBuAj0eO33I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762248974; c=relaxed/simple;
	bh=dRUGXfYeACsEaLRPUhjJcWbtimfoTFK+PgSLMNC6gUs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tdXoJrsyNSJHPITDr7kXHoEsHrETpC+Jrr5T47zLk/lt5ALJpiW55yS6LEnWQ7fuLw5djU0uitwQ0tGObmKyvSjPi3IRBWCPQo1oaC3TuRzdcRinYraQu7JwUJbBKAoL1I4+tti651ZkeTtflYG7C2rp/aPKr7+ahdvNgVStvD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=EYEiNM3E; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="EYEiNM3E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1762248931;
	bh=jmGhMAgaBUM0BajBlocMSy6qJhGOcjmpM0oQwDNPRRM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=EYEiNM3EoYmJd9jFxYUQ2cUaTYEifLxpT01cFNWoMVirWK02PdAR3jEq/GJojFDWN
	 V9Z98w87s+h72UfKKAN2gHDQwr0EyyVUqd2UQ0clEpDogdDaYfh2WNj5Zu+vP1Mcj4
	 bsuDhcPyrr3/lL+Y5uDhWYDaVXZeRMqK7QTR8cQg=
X-QQ-mid: zesmtpsz4t1762248911t51d15bed
X-QQ-Originating-IP: se3KyUxOOCabbjx22pKi04RZr2zGRV6ZOgOzhQpzaeA=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 04 Nov 2025 17:35:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5451745896443902141
EX-QQ-RecipientCnt: 7
From: Gou Hao <gouhao@uniontech.com>
To: cem@kernel.org,
	corbet@lwn.net
Cc: linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gouhaojake@163.com,
	guanwentao@uniontech.com
Subject: [PATCH] xfs-doc: Fix typo error
Date: Tue,  4 Nov 2025 17:34:06 +0800
Message-Id: <20251104093406.9135-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: OAv5WZ8gfM/qx/hcYtFNWbd0ImY6K/x+CvPrjM5EzVpWaOT0G4KLkSFq
	ulaQWkeAdK1fj9fXyF0Z5fsYMti9RCzlJ0bj5lB9mG+gufL1OsXiirLjn0P01M+D5oE9Hnb
	tW2kIldyIQqryrxNd/VG4Nmr+fiEehBbRe1lB7aEexDNlCi10BweTaCEkd9G4wZc1J5yZXO
	6Z7bG5en7M/NFrP1YTCWCgR4XQpnhBccsGRGcHkwYieG0yp9BFkSLqctAzqa6Jw56Kfe/Gh
	qJ8Xt9/6WT9TU3HAbbhEEY5BQrDSUgsz4WD9dOEv1VdmMvTUqh/f91LPC2/BTpNNYsuZPF3
	BnWalk0TCuZMwdF5M/RhrZwmgo1rQTjC6GcBUUUb8I11Ss8tIRd3OGx5ewJFXuKFi84Wfoo
	2ppV9LA1QYvtpjAqk6L3QYwb8J+GIi2J/n/+R1Q2UcXLbKLE8YDO2LLVSzoKTCjAQ1G/KAE
	6JRGQhyd4NYgspjnRY5RRNLGyj+eRRj7+C+36IkXPc3OrDIiVifjUe1Xk82h2lArXbaU/4z
	QUdXRA3SreA6aObq8KpzKS/9LDPSNlbAwNBHo88B0WOB7WD4cZN64Y5ZW++9t6KxpSgjxw0
	pswK3uIaue8Bo/RA7mRKJD2lcHiiQ1/kVc38R64DeeKJJ8QgqJMp/fJiLEMb4DEczSQNOIV
	hzeNjUOlsbwJvPI5unLXJy4QI3gJtrBQbjc0TRpOM7wpgQRwFr/B8OE10Z6Myyu2vm1Z5gZ
	X64+D3w2IurLNsC9H5iStCX9TDAPOO5e/M5ISgOb3rD7lCv/ch5tbyi57o0XHQF+dAdtVim
	AZk/pSuPdr2+1CmU3+Ji0LDN7HUtujrUzujZ+M9RagDUaY0a9hzE3hfdAZYNXcFh2ANY5Fy
	Z87SfI0vRZvDWDO/zToj4Ot1uUhpImuv6dsENTW1uvoGLITlRCr+iCynzLtUKN4G9WdMNkL
	KimjVrZ/FgcpB53giFE5P6OWfu1WSBpMQ3votbZMWt18JjM8T80tgX5RepVTIBspMQe5kIE
	jH0+b4C71HsRZ5Jp118sXX8hm+26dgrwW+sIRGwW1p4h6NGLy2bWJKNfdWsK63A9vqJigKG
	+9RFBdVH8bIwvvYm0WYB99IDOh/n5G5/w==
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

online fsck may take longer than offline fsck...

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 Documentation/filesystems/xfs/xfs-online-fsck-design.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 8cbcd3c26434..55e727b5f12e 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -249,7 +249,7 @@ sharing and lock acquisition rules as the regular filesystem.
 This means that scrub cannot take *any* shortcuts to save time, because doing
 so could lead to concurrency problems.
 In other words, online fsck is not a complete replacement for offline fsck, and
-a complete run of online fsck may take longer than online fsck.
+a complete run of online fsck may take longer than offline fsck.
 However, both of these limitations are acceptable tradeoffs to satisfy the
 different motivations of online fsck, which are to **minimize system downtime**
 and to **increase predictability of operation**.
-- 
2.20.1

