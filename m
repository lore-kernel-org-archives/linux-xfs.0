Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3B42D73BD;
	Thu, 18 Jun 2026 13:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790529; cv=none; b=JSLk0xx2WyyasYFkJfvxS2DrIdLBa/r5FEwDC5Se91fzjtUJkJ5aELGcp989Xc7bNDc0ITMo0/OKrmih8jPoMYA1/rDUp16K/uvGNDTLsP07c1Na7rpXda/xXWLrDA+MNnGUpArIaZL5JQQ80j2T40755nE8Ydb79DOFJ3ssKKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790529; c=relaxed/simple;
	bh=WIJ2NTwaa88NCP7Y3HCXQqPKOHwy3d8z5so4jDYTvNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+CoOvXafEwcVS6Ai42vXtlCS3NHLhAsnGpwOiGt4tfL7GKwxNcmrQXZMifdw5rFCgV3LevEIhyXmAFyu5hYsLyTfIrcvw42l8JC7jS8HNFQoDPAcR66SZhNuG0KkbdLbtZPhJpn1u7ux1TP4fwSIXxUSJF2awvxFoj7k+jt7Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aYo95egT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aYo95egT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HnKpMoCATMHu1zhmx34Fl0zDc33ABBUWB+bTySYfnzU=; b=aYo95egTE9ucJjW4hvS7Pq7SMI
	01N3LYfXsZ1cg7PWggZkK6KukFJ3fWy5Fhk19esrn6rg0UOKMxe86sd6UDO/uOT/GcMaOQNnmFqHI
	nRzJr+lg8jLHFpLeGYQr8niijPE/jn+sVXznf4IY8uzqQtluRtp4+1jmHl1IWk1/1qTZVaXfzdGf6
	eNll6C5St17HLKDTjCy2iN9mNc5rExqPbj615+yuq0zucMyVVLtz0Q+CT9qi1tK6BD91689Rg46kH
	zQrMZ02UfAomnm6kX9CVR2dZzc8we15RFNSMPPJewItA8Xd3IYldOmVe+pP6EfopPrCn11rhqa4w1
	ocx8HEcQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waD6t-00000001OED-24i5;
	Thu, 18 Jun 2026 13:48:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 2/2] xfs/216: disable all concurrency scaling
Date: Thu, 18 Jun 2026 15:48:26 +0200
Message-ID: <20260618134834.237647-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260618134834.237647-1-hch@lst.de>
References: <20260618134834.237647-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This test currently disables log concurrency scaling, but even the
data device concurrency scaling can create mismatching output on
systems with a large CPU count.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/216 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/216 b/tests/xfs/216
index 1749647c11f7..ce8bb528410b 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -23,7 +23,7 @@ _cleanup()
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
-	loop_mkfs_opts="-l concurrency=0"
+	loop_mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
 else
 	loop_mkfs_opts=""
 fi
-- 
2.53.0

