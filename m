Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E87224CF
	for <linux-xfs@vger.kernel.org>; Sat, 19 Oct 2024 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729362222; cv=none; b=Sc5J3H1mxCGaXhdU9JpAcE0dIoQHstjbrMNMKjGYpk3sgN4r21MifN775qnY2+TaeBterFYhdsYkH5fIvtqTvjDiyvGvfeP/4N9Mux3dkkBOencgJHOiO5UPvJxNpr5kSlCQ5/Fdxh7fIvHyj/zqd72PIbbMRyLxl3/l97dvcP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729362222; c=relaxed/simple;
	bh=uDUqg5oBIzmk9W1DgWsfeX81TP/pCgSNe7gZPe9q28c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YzG89c0wv/of1QZLSom7L/CMwKGjM88J3nfOTRX08f91leG5v+3L3O8oTIA3mhU5FFVfdXSqI0AajgnGW7OjWSo43jKBGRR9kGRCQ6+c+6/NaEYLHZzDopcVSgxv6koIqz341o/o915TnJrFdO2jT+otnOUpX2o77lbNTyR7moA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=LUz5t8rE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nCJdueAK; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="LUz5t8rE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nCJdueAK"
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 42375138022E;
	Sat, 19 Oct 2024 14:23:39 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Sat, 19 Oct 2024 14:23:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1729362219; x=1729448619; bh=Yuq8Nognk73Fb+sOaq/sB
	U3NXoRFqBAurq82+QPuL8Y=; b=LUz5t8rEC7XCqom6gK/VMuTylqcsDQSj62x8n
	+iVOjnvtmcysssMK0C4u3MPbHMOHRWVcKkC8kCYWuXi4dFbP1dzxjELbTNWg54X6
	AbJRsyG8wRHjFIG8JYxITUub6awoHcVzlw6Iy9KNglXrDo3t/awZY9IgwVtyrOEF
	NoV+b6yh+ejkWxClH63xh0youEEJOlK6xszWFrAgZqsqbqaz075MT40xzX1tM1aY
	IDWe+iRIa6iPVYdJpIEeZpF6tZwVvxo1Ct1QvVt1Gt+Y7/A9eOhc5dvgLQvGjoyy
	NiCyA4SGKyNBGVxAFESLlUBq/E+8FOeSe6kVl2BG5N1ZHMSlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1729362219; x=1729448619; bh=Yuq8Nognk73Fb+sOaq/sBU3NXoRF
	qBAurq82+QPuL8Y=; b=nCJdueAKj1IRRsu6g/l/uULal4taoiHsJPYlxOJcMwRl
	DWyRIUE2hVP/8yebVzHDwf4zZeAw4Mqs8WR+YIHTgyfuWdbWHKJ8R4zC3J6HBEku
	jD+DoVkbglQNFRC46r+jq7sOMXavBl1rRNTjbCZZJCFslOY8AqcpBOddZNuF9b8A
	Ve1KYrL7w1g63VYoUHf7sBmoUDguCw6pCICL1MJkXjlWg3n52Wi5KNXA5h5jR52q
	ea90X5Pr1TjBzTvEZQ5cWjXH4Cskm1YkxXHj2cS6HtRml2/6icW15Rc28RCvJU91
	z8AOnlCDiikzUMWHz6WxRvO+oB6ZZuSSaZCSUd+vnw==
X-ME-Sender: <xms:K_kTZ6xXDNY-qJJ-ywCdpX7w1UuwlmhwBZ0rzslQ89HW-5rp8oYA7g>
    <xme:K_kTZ2T4i3zLM_fhz0tFZuyEUayKgb8iWh3KRWobnQR4odPHkHeO86VkTi_Aq-WFc
    IA2C_a1NWJij1oBVw>
X-ME-Received: <xmr:K_kTZ8XyUnSMeIcGXP_whx9rtGAkU8kKCCUDbssUiO-pqVQQhSXbLP9cXA1g-tju9BLIcDouYkIev8nI0WXxH4JdXCWfCN4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehhedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhephffvve
    fufffkofgggfestdekredtredttdenucfhrhhomheplfgrnhcurfgrlhhushcuoehjphgr
    lhhushesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpefhkedvvdegke
    fhjeduieevueeihfdukeehjefhleehudfhhfelgefgtedtteeutdenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjphgrlhhushesfhgrshhtmh
    grihhlrdgtohhmpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepjhhprghluhhssehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:K_kTZwjI7fVtFSHUovfwioI0-YZEXNqRD3tFS8HFN9maPsksbJHE0A>
    <xmx:K_kTZ8AfmetKVISygA10HWo1o-biGeSa8nODQWJFvrSDHdgsw8nBng>
    <xmx:K_kTZxKhnyg3oTZ9-sgGpaF92Ze1-8gGc8nmMvVDSPkfGOk05GwPYg>
    <xmx:K_kTZzBS40G2gkr9ClEmiCdjGOjxty8V-iY7hkK9qb3r6mwrN8Xtpw>
    <xmx:K_kTZ_NkAA3EscIrlxZ_A02tq9Za87MCi83b8Hk88pkknif1doV5BbpA>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 19 Oct 2024 14:23:38 -0400 (EDT)
From: Jan Palus <jpalus@fastmail.com>
To: linux-xfs@vger.kernel.org
Cc: Jan Palus <jpalus@fastmail.com>
Subject: [PATCH] xfs_spaceman: add dependency on libhandle target
Date: Sat, 19 Oct 2024 20:23:19 +0200
Message-ID: <20241019182320.2164208-1-jpalus@fastmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: 764d8cb8 ("xfs_spaceman: report file paths")
Signed-off-by: Jan Palus <jpalus@fastmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c40728d9..c73aa391 100644
--- a/Makefile
+++ b/Makefile
@@ -97,7 +97,7 @@ quota: libxcmd
 repair: libxlog libxcmd
 copy: libxlog
 mkfs: libxcmd
-spaceman: libxcmd
+spaceman: libxcmd libhandle
 scrub: libhandle libxcmd
 rtcp: libfrog
 
-- 
2.47.0

