Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674DF1BD9CA
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733940352; cv=none; b=EUQJuz4uEoNeqMHESpzu6wN67+/l1lq2MbvKePXnAigu7ik/+pJn3nTIsTmsmN66VPZTWS24P+lLiwhz/dEYHNhaO9sKyeFhj4Xg5bStoOxeVcHzdtNp1gAoGGptGlLLqyiImNNYhuG5NLh6KkwTP5Cx/wjnp4bP5Go/9yuRt9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733940352; c=relaxed/simple;
	bh=8ms8ReEgitalID3sGCtbiGGugJC80YWUNBFOd1GVZ3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4T12uLF9fgX4kP2MY9LHLaThALlH0ejgs2hPpAoHhAY826jsK7WDnt2xSZy9u/M44Yb0rxVU+9EsHs0y8uD3MfR22XFvB6UIiut8dhhIvW+QK5U2PEiHIG5EHJnECThXKNj2bHRlGoMMpRVGkU4gVutnyZy2V7irNgH7W2e1Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kTuTjM54; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kTuTjM54"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9mXY46LKp48D2umk1sVkkYqlb6y45R+KIWyZmo83kWg=; b=kTuTjM54Q2koLpGULH09XZvV7u
	jPuE62/FZMTKDwls8sX8Klquu3ecsVsnOb9au1YYTrmm+iwt0BaiqcIfoWYSzE7bgw3qkzJplb6SY
	/BfbCePyo4Dp32pLPeKPSJjdxLonDpQ3aFuPNBSs7azrDdvqkJrM8c5Bv9zuiVeFKoKW2FxutK9AR
	vi/ez78z6lGMT/xfL3h97lyDKcT6fSikNwPLuWGOaM6bFSqh8UUPZQ5HVqzSJSgr4jc2h8LvLH1Os
	sUsh6drndfJo6pavDoltZDd9K3lbVGhYcY9S/cxR6IyqorzRImSvhwdCx7KZuhKeOJS13ql8WO82m
	GD9fpmLQ==;
Received: from 2a02-8389-2341-5b80-99ee-4ff3-1961-a1ec.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:99ee:4ff3:1961:a1ec] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLR5o-0000000FhgZ-0tI4;
	Wed, 11 Dec 2024 18:05:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] mkfs: small rgcount man page fixup
Date: Wed, 11 Dec 2024 19:05:36 +0100
Message-ID: <20241211180542.1411428-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211180542.1411428-1-hch@lst.de>
References: <20241211180542.1411428-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All the other options that require a value spell that out, do the same
for the rgcount option.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/mkfs.xfs.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 5a4d481061ff..32361cf973fc 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1190,7 +1190,7 @@ or logical volume containing the section.
 This option disables stripe size detection, enforcing a realtime device with no
 stripe geometry.
 .TP
-.BI rgcount=
+.BI rgcount= value
 This is used to specify the number of allocation groups in the realtime
 section.
 The realtime section of the filesystem can be divided into allocation groups to
-- 
2.45.2

