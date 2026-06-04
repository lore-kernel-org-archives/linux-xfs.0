Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CE2428837
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 12:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780574643; cv=none; b=rDHKp5xh5zP/EpvV6slnz/cEEeIPDBRo09DDtQGU8mPx1/TVAuuWrFSPqpcGsSN2wqMm5AXRLFg5zhAYQ7Y0nQ6yqAsClbz+TS6q1tL8Ix20VbeHReVJgDmRrFKtJCkJxvIgbRlLdU4yVFjvVH2wk7xwEHViQUOKgUtR7xeyjC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780574643; c=relaxed/simple;
	bh=DAvVUmcnobFdqbVncJLMNEfSw6jdEA0I2vwGKprBf0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZMU0SSHln39LIlZxEdaVqgaNkXRgU34tInXjH2DPS5yoWC1V8dryucmzVwSBCMeG/lV6OYr99bhIkm/HZMiRm56ndHceBud70jeXsMVPzjGEjokqImY2a5q0/K5N3t3jP3b+UORCM+XEkkyzidmMVPeCjN1BPRc1OLaOrCXRcF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=jw6LNwLQ; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="jw6LNwLQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780574621;
	bh=pY2SKp/Wt5qqQqAQmENMfzhNhaH26HbejCTsy7dKyfg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=jw6LNwLQAQxVL7PGCiDkQy69sDMgmCM9Q5YWDfYiBK2oTgORmNA9CdBbmwdeMopH1
	 wX49Yhw39YP9TXf9t7kqU06g/Le8gSx/XA/zyc1ji2e+59JtXD0vf7eXllZpR4bnUa
	 kleU7SubP3Gx/ep1wQ+NqRkZp86V+6mJPgQ+dFas=
X-QQ-mid: zesmtpsz4t1780574606t822b0894
X-QQ-Originating-IP: VD+2jRYXwijzOxIKKXCwH9+TwdEmglgUZn11B84pA0I=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 04 Jun 2026 20:03:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6183483802608509621
EX-QQ-RecipientCnt: 4
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH 0/1] xfs: fix exchmaps reservation limit check
Date: Thu,  4 Jun 2026 20:03:16 +0800
Message-Id: <20260604120317.930273-1-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: NmqJZuAG/aVTjuMSmMkW/9pDUi5afw3ncNyOfZ6RtoT3wNZyF+zByxCa
	5o+g1lSLXO6HeGU8SrMzC8JT+ULjpbHiksi5RMe0tScHh50N3/IhSKzJnrS4sdE5Wcvlz0g
	iY0dmD+NBZLn0jaKUQsXMWCHjakRpTSmO9g5ieebd9k6jggtsxravhXEayms/q4bPigNTiv
	NmUSzbuoK/BpPY0B2sYuae8ml1B0y6hhte6Pv+YD11tgj3Tjw55UfrkhVBBIarVJjiubM0L
	nZcmU1zFXA4vKfNtzQfmwd/OOl/xbuBZ1DS8pNbPhhOUEZP1oSUZFlQ4a9Ftz/P06sBr99+
	0tNL+cld2CjhucMJidfSjV58nl70Rhjn6vtzTYrNB6os/58amnurN2B4ahpv+C5QYrp9wa4
	XIN0c4YI7Y6SJXccX68S3UTzmrF7mRw/2kWisjGZ6DwDN+P7iE8JlNW3nnwPsbnH6qHktd3
	kdopQmaeta2qDxJBS6myloxubYeXz1xGo0vNd7P6rECF6q1DLqroL4j1kB2jXR8Wr2mlB5R
	rC0haiepfoBs0LQaOB7b2/ABeDO9VOyH1AUcObHOlRml2HAV9fpC+rl6LwnuR9AVjFjNhDy
	iQrnfYppjq+5HWNOaYeJpu0b7vuWM1f7zmWos0DfW/D0NcfPa3iEEK8Tm6F8xAp+c0uBc0Q
	90S3yRlssLCAB9Uctm86wT1Ujoz5Kbd+jbHAUMmYE71oqM0bCIcbT8xCYOQWMgZQBSBgivG
	NjLKzyceKI89AfS+wanvI0/E4VdlJHBg44Krk6Z1dlxeFj03SfgS7QoPtfaF9OSQjdw6gR8
	CLMgLi0kE0PRJmSrdwuwMwoMmuaFsqqNwqtrB3HLoZ6+6lkivyaEIjQNOQWxAJSuuYgYCIK
	/PWl59LoehQC6ku/CtZbs9BzzE4VB0IEZUO5REOA8CCib1Ogy63qCOKtiyV5LLKamfUCfPE
	60IC7YUW/QT2bWPxp6t8aY2oGQueE/HRJmGcxiNAquLcPi937+EKU5aTNaEiBjQt0YmtRjs
	jgNK3Tx1zZAwfGz5EPbgyv+CayWOmxLPquISZq6CQSNuqY1/Ufn6oHZ5XOrtejrb3i9WYAn
	uJa8HPl5nB2zvdbS4WP7Gs=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Hi all,

This patch fixes the final reservation limit check in
xfs_exchmaps_estimate_overhead().

The helper adds bmbt and rmapbt overhead to a local variable, so the
UINT_MAX check should test the computed reservation rather than the
initial request value.

Thanks,
Yingjie

Yingjie Gao (1):
  xfs: fix exchmaps reservation limit check

 fs/xfs/libxfs/xfs_exchmaps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.20.1

