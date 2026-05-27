Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B698126C17;
	Wed, 27 May 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779856323; cv=none; b=O4hwIvV1G2ggKIDN3M0Y0XikQBH1dys++kSVhCPeZfEqiPBNRY4dlIpDyifKXu16z6Vj94WEBWDR80+LNojoLEEsFHrEmmWo0M0QGwl+o3DGQXAbpa5k5lX6rYnfgrkSkDhFXdpjR9Pid+JPJ3O0sp4gOaJwD09F/hfKSFLiONQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779856323; c=relaxed/simple;
	bh=4WZxcL3oP90+HiKPdo7+6P/u75+zE+eZYIY8aoFWn8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RqsxBCM/K6FG8hIGG1iRaFJuJp1XwzhwP4fR9hkUoIZ5y+Yz3ZCaclLz14HxFT0c3yb5jevaYaLviTD9B/25b+9NFoIz7O/WPsGSgDl2MENu94aUgTPuw8BhtC86WaJYq1oNHFZvTEp1qW3WF9dw5yLjQFUMGwLPKbP0Ab4syFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=cyKa0Gvv; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="cyKa0Gvv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779856303;
	bh=y7v0gItugS+AwpyKa9q+jZxZ2HLmCou8+QGbKgDJ0Y8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=cyKa0Gvv2YDtl9VNairG2olLSR0qIy+tw+EyvvwrbxIJP6qHcjVOzJ78tclgROLYj
	 fXIwUrrB8Mhg6khOINooRkb0zm2DWsW6COh8g26CCueBJoEkShowOdeBFYhFpVojr1
	 uGosbtWkYe+aPYiLbFU/cWCeiaoAnaIbxWYX1gLo=
X-QQ-mid: zesmtpgz6t1779856298ta69fe32a
X-QQ-Originating-IP: zQQRemQyTTbLNSa0d07DTFRoP8/FQdUFi9TIeuToSkw=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 12:31:36 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11172373720802476331
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH v3 0/2] xfs: fix CoW fork repair error handling
Date: Wed, 27 May 2026 12:31:32 +0800
Message-Id: <20260527043134.1550710-1-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
References: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: OdNXl1RIKsDgqdt+RJKADkFDRTZi09m1pJntOdG3gIg9px+JPYm8jxg/
	ZAvgXVkYMFP+S3biNDVehN49SRNMFaJOrZa6KI7fSdvIlo0G2kbrB4AJW9rH2G363cz650G
	NuJ9KScn7GcMood0XwuLBevDfIQUUI0+gxjksHNqPmvU0Qdu0p6vuadZ0il2sZoQH+c8WLM
	nF2O5kSYk/BVlebkX62+NLftAWYRaOP3lbc/wr1Kktbhj/63B9jA9NILj94UeOryXpkwRTM
	vYdgWLMBq7AQYdJMUX/WCTXdFIYzgdMcaRj8VO3+61RABMseiVhdXGXr5aH0KA7rU+qGc+l
	7f8uthfNEarwqRxKELt56dtxgIHNvVa7h0idIfwN06IrWKZcBbeh/1LfigO/v/c0uCkIdpT
	tWTYLhMxoud7URV+/aD5HVSzcxUJfBQgjb5o+wJn96qUukWXhiV0adLTwl0Fw37D/2HjF4c
	kQ6YHutWU6onnml4lL0bQCK7KB3VqAC1YxznoIvpt1kFLW8AP7KPwpS/wbvpWMu5DJYijaL
	YZZ0CZ7g/CvVVdk/F8UxI5U2Ss723ZTmPnOs7UTk7LvMaGZMCj8h0qB222B41AoLBcAyUrR
	xsocaB524G0+UtSAB1oLhZmjI0AnhVqEyE3y9XFxL9XGQUHbQy0Z+DmYsmUtIYXASFY5MZK
	1WeCD8M2ubFm2NORbyiOX8Q59bNy0CKs25mz1jg/7oz7T3OZzNbBCRpcKNUiO0ln4FR9YAh
	dM0QAmE5RrzYaRz5+fmjbtAP5fo/x5McI7/Jh6rwUSSsQnc42rba24hhzJzTD7kQxi4szBZ
	4CJ6iUHsHeq3M3Xlv9xVslsPUSGx3WInsmeivX7VouB3KOAa4HkLkJBrxHc2bgv/APRvwY3
	v3iRjnxJge/PbagbHFoYIGhChAqasTWWH3ao+/xoJlU0FX/Gwf8A2e1+wgsWCE4ii4OQAQA
	JcwmJ2QJuxN56LCAfD7nVYsw4sC+JbeXT1bCTECe08T2EvnIsB5745HGL2e9wz8TLRthBfh
	9yENfWdzZs9uO2ZT0IVmz/1zvV/D43xW4Idu7/5kkX5aT2dw7de3H+yyIMG6nLeZcdoMB0W
	1Xq2wNcx9VNpHwSLmrTQLR2koJ2BEE3FEwi1tOg8pDW
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Fix two error handling paths in CoW fork repair.

Patch 1 makes xrep_cow_find_bad() return saved errors after cleanup.
It also lets a force-rebuild bitmap error fall through to the cleanup
labels instead of returning directly.

Patch 2 applies the same fall-through pattern to the realtime helper
so that scrub rtgroup state is released before returning.

Changes since v2:
  - Drop the braces around the single-statement force-rebuild if bodies
    in both patches.

v2:
  https://lore.kernel.org/linux-xfs/20260527033902.1524007-1-gaoyingjie@uniontech.com/

Changes since v1:
  - Let the force-rebuild error paths fall through instead of adding
    gotos, as Carlos pointed out.

v1:
  https://lore.kernel.org/linux-xfs/20260526123243.1078867-1-gaoyingjie@uniontech.com/

Yingjie Gao (2):
  xfs: fix error returns in CoW fork repair
  xfs: fix rtgroup cleanup in CoW fork repair

 fs/xfs/scrub/cow_repair.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

-- 
2.20.1
