Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11E1194C98;
	Wed, 27 May 2026 03:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779853164; cv=none; b=DggofpxcCQwI5BjEHndnJlbWu/QKmmwQXt5BV2JUAhalReuN4pvpVDvzVUy/dED6b+15PcMF91ifj0U59QqboEBLZ2uR2h/sC/CV0UIxYRxM+udcfUps6QtZ1RzrTUiNC5N24mubZasohaZyvfOgWkdpEjDBKBgbwt+oJxHRVKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779853164; c=relaxed/simple;
	bh=FFv1JFfqfOBG2bhW27LTPx0G91m8Z70jFuA9p5RvWcg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=al+BqXanhT/j42AiyKwnQmBqOYih/vSsVzdiZ07ue09ODTlerqJhxoBDNeNHAqKeSCWI0Giz6RoiLGhQZh4mZS7zQdSBWIPCYSmNiT8KnfvPnS5KTG6jBiKtQ0BdMtNqDtwsNc9Q0hXdIGar41IAe0kwBPmsl+jj4nBtpi/1cB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=IJdKxSjH; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="IJdKxSjH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779853151;
	bh=MB9EumoxKhmesIgqjMWxnJL5J1kliUEsdFEuZgG0IGQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=IJdKxSjHnVpZ43EpGiM4Amm5d3U4O6hLV+SBJyR11GX3+7PgKpsph4gcUidf3WCez
	 TS6Q3DrwEkqsPy5PoVlyZUZJBVml1P8KCypP1Q5w3jre8EOBnOuMIQOqQM8IEn/Nbx
	 MZOLYtxHDl50nbScwpEGNNf6fYVfVBwmDGEu4RAM=
X-QQ-mid: esmtpsz10t1779853147t9b2d6711
X-QQ-Originating-IP: dbZcrn1ZduKjE/hK6zLXTTQnUQ9ivsQ08ndNELqLm0g=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 11:39:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12036807008155810846
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH v2 0/2] xfs: fix CoW fork repair error handling
Date: Wed, 27 May 2026 11:39:00 +0800
Message-Id: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
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
X-QQ-XMAILINFO: Oe8iwmjPdG65ScQ39I2N0ZRqKRwGYqchMyFB11GJeY8GI7yWfDywrUaT
	CMR/b6uukl7/bLXEjDjefE2n6FJ5ylf0xXqRJnUs7niD59E2/vobzD6Go9TTO/M3gNzmEag
	j0wxYvcqClFQYcK/3AWxRUt1YYBdMS8vuUjhQblXm0QQ6MJiBOl0W6eIq32xDrW1cnKC5qb
	rZbss1cBVBDLeb5Kq3+QWOHvO6E9tYUUcak7hdkT7PAuhzAngowno6YjlsLmtt8mQ+ypwDr
	9jdScAn9ZMCbUQnKyuxsJWxU4HKgbvpRzu6U6wWVk7Cn6X6XSdjg2DWYwPuzVLQ5envnTuO
	83Yu0DgzrmXDo0+YtUqRzK+7VLMiGPw1NWfLLwaHS13IEq2GV98iLz2xsoT/IRKrRddUL9h
	du8Ws5zeLuSsNLpWyusrYhYsSh4Q2pUR+NCU5qHDbBcPOP8K0Suo0BjrqerbtyujCPi801I
	ywYBb1PsudFny0Osud6t+3kidlnAe797PtYaLqtiI+cXfIBtR5Psp5RA016rCWptC/O1vmJ
	ncbe1WhteyuIBhLl86UDJ62WxJV2hqE6v/NceLSeayuzJqciGw/hvZc/UQ4kLlfmHdlQzsv
	2cFBujJPxQUhJmZlakLFpYZRCwD6pTu8OHYI0gcVwqXchwtvh5PWd3W7K2yISOB9xvAuv7/
	reKKULI+OFfr7BHXuirkhuYp6Ex181gLzBDONDKYbqVHXbebEgfv3ta3tRoC4vC5Taagqd3
	+WiO46ESgXGOgkEjhNrpZjLlQsgYhNpq9nRVvRByLojjmwHAAaeHbquNl+C6Glf88Jp5Gh0
	hlWVr6k0Mvs/l8Lv157FuaaW9AAzgtPv0lydf3b1b4fd3enmp8qP+Zw8fUiEbT9NEmngA1g
	D5qHpNTtjhYLsNHoTr0o/+XsTPzoGaMw5O5jXFHN23pcUy7eiUUDqTck+p/ycXCwcZt7cww
	QwzAFUznoY8H68pxPXs/gRI3Yh34E+6XoisYu+UQ8O8lnt70Z5MV9qcyysxwtpq+k0ZcaCF
	ICm0tORCVnpCAnzc08j7JTmvUJJpOLjOKDiMZT5rv6U6FmVeLjOW2keftpIGQ=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Fix two error handling paths in CoW fork repair.

Patch 1 makes xrep_cow_find_bad() return saved errors after cleanup.
It also lets a force-rebuild bitmap error fall through to the cleanup
labels instead of returning directly.

Patch 2 applies the same fall-through pattern to the realtime helper
so that scrub rtgroup state is released before returning.

Changes since v1:
  - Let the force-rebuild error paths fall through instead of adding
    gotos, as Carlos pointed out.

v1:
  https://lore.kernel.org/linux-xfs/20260526123243.1078867-1-gaoyingjie@uniontech.com/

Yingjie Gao (2):
  xfs: fix error returns in CoW fork repair
  xfs: fix rtgroup cleanup in CoW fork repair

 fs/xfs/scrub/cow_repair.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

-- 
2.20.1
