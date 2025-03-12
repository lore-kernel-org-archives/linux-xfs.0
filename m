Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19CE1BDCF;
	Wed, 12 Mar 2025 06:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761960; cv=none; b=OEtHFnLmpncQ2xBx9lf47WLoDeZ0rT8CIGY54ggF4/ULUw956zilXz+BJoUqY7nMDkpM8JAQPiA0GUjlAqCTQaNUWYqGLPErw6XgbgL2xOcIOhUAjMLhqgy0X+qk3iiIxF7weOEh+mAy0xYWVHjgcrx+B3NSK3ntKViA4ifPQsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761960; c=relaxed/simple;
	bh=+Xuj5VA7y01AhdIDZ/geAs3ML5Zb372MjRzV+oz/qEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZwO3kFc4ugMKyR1Mls2pdn00J3z4RPQ3Rde8Sc/xSw6jHELlTPfN4Q47K+f8O4tbMJtSfpTCDXY/8dg98shXgs/4tCMtEYNsw5h8cL6L0qHty4EInCHJ75kCmI8pChw97lNGl3dsmJ/0kJlj9YHPTOiPBO2ycGP9cPj4zatHFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J+kTwcVz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J+kTwcVz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oXx5SGtYGzCvPp6FRQRsfdvy/uQe6idPiW6r5ocEjeQ=; b=J+kTwcVzMeimG/lShKjDk6HVvI
	95q1Rkqf1flDZEZNO7EHJehuKuUk39aDFzl5slRnpLNe4ibfcqeDalhdXwLLAMTR16hdTOGLJ6J/r
	bp6sFubW2k4IivOYXoitM8KB8b12E3ACDQvue/t9PfDBPserFiWWlS/HEO1RfmF58dMzQo+JlagEi
	lHrEWaSxibdaP22b5yFdyI6zzZ7q/yxuI2fJPTkqtEoqo4xiDGXL2+XgpKNEfTcJVmPQJ3UTAuZwJ
	QqV9iyahFCb92eI+RihuXTe+hncP8czVcMA2GCVwpUqs0AEqX1J7uOCU5+yQ1NvukfxswxsWmu737
	+muIviGA==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqo-00000007cmG-09KT;
	Wed, 12 Mar 2025 06:45:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/17] common: allow _require_non_zoned_device without an argument
Date: Wed, 12 Mar 2025 07:44:57 +0100
Message-ID: <20250312064541.664334-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

That way it can also be used for RT and log devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 753e86f91a04..b0131526380a 100644
--- a/common/rc
+++ b/common/rc
@@ -2545,8 +2545,7 @@ _require_non_zoned_device()
 {
 	local target=$1
 	if [ -z $target ]; then
-		echo "Usage: _require_non_zoned_device <device>"
-		exit 1
+		return
 	fi
 
 	local type=`_zone_type ${target}`
-- 
2.45.2

