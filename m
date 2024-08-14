Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512DE365;
	Wed, 14 Aug 2024 04:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611166; cv=none; b=ce1zfg6H0Wezk32eUSzf+yDHS5qkz/h/cTsjTxeIHyQ9BqKT2/VnCZRse0h33wp/SSJ93yJPQ/1EDVmN83R8/pBEmkiytTjSmjJBHDBs8Lt12JWkpq1zWXuR71U41lIyBBnb92v1GDXEFLIO6fPrPPfy7UgmAYxqzo55soj4xok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611166; c=relaxed/simple;
	bh=JNF+jw/F299AfHLBt47AOMKtG64Oabh4PP4SEgB2Z6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNhNKvagLxqlbPLHJsEO+27oBugYi4YAMKrNlJ9pCSQS9Ogd6P89o7TGwcBUb5kFEouw3gCgg3417TOSAvCTT2SY6uS8THstpHv7sU1x2em0F72St2+mLOC1cnWXH7UDWPbKF3o8+Vc59j1/yTxXn9DJn+iYhsr01U2UQJcdikA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pDBVwdIv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pDBVwdIv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rF2jhC21J6tTctc13r8QzT1gux9V1Wt3p4gIKPWlG7s=; b=pDBVwdIvXIIGLgTrhd1eEXwZpJ
	8hEhQBPwoeQh7zS7IpGRfpbvBex2AWqMD0xwRx3uOuu1ikl8+mO3QApeL5Vn8XBMJtEz5u4WFIbrK
	DMqH2JMa2yOKlR/lPCAiLPjCKfY6I9Dkfrt5WdSZASp26yH37U62UeZQkxjDvuh4GVR0L6gbbaqu9
	rELnIFtgRDV8Sa2gA2ZIRxb87uXSzqXF61Oa/gP7CRNJTxvaFzSS2woIFn96osv7alcByu8XndEKv
	OhNW8QuSaz0ysqYBMpOXMqVbERagM4JqX+U469aoWRKAuPtkQ/vUQ7jMd7JV4FVa4wOWUL64PZSFu
	KLBoB4Mg==;
Received: from 2a02-8389-2341-5b80-fd16-64b9-63e2-2d30.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fd16:64b9:63e2:2d30] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1se604-00000005jNo-2Jup;
	Wed, 14 Aug 2024 04:52:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] generic: don't use _min_dio_alignment without a device argument
Date: Wed, 14 Aug 2024 06:52:13 +0200
Message-ID: <20240814045232.21189-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240814045232.21189-1-hch@lst.de>
References: <20240814045232.21189-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace calls to _min_dio_alignment that do not provide a device to
check with calls to the feature utility to query the page size, as that
is what these calls actually do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/521 | 2 +-
 tests/generic/617 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/521 b/tests/generic/521
index 24eab8342..5f3aac570 100755
--- a/tests/generic/521
+++ b/tests/generic/521
@@ -22,7 +22,7 @@ nr_ops=$((1000000 * TIME_FACTOR))
 op_sz=$((128000 * LOAD_FACTOR))
 file_sz=$((600000 * LOAD_FACTOR))
 fsx_file=$TEST_DIR/fsx.$seq
-min_dio_sz=$(_min_dio_alignment)
+min_dio_sz=$($here/src/feature -s)
 
 fsx_args=(-q)
 fsx_args+=(-N $nr_ops)
diff --git a/tests/generic/617 b/tests/generic/617
index eb50a2da3..297d75538 100755
--- a/tests/generic/617
+++ b/tests/generic/617
@@ -24,7 +24,7 @@ nr_ops=$((20000 * TIME_FACTOR))
 op_sz=$((128000 * LOAD_FACTOR))
 file_sz=$((600000 * LOAD_FACTOR))
 fsx_file=$TEST_DIR/fsx.$seq
-min_dio_sz=$(_min_dio_alignment)
+min_dio_sz=$($here/src/feature -s)
 
 fsx_args=(-S 0)
 fsx_args+=(-U)
-- 
2.43.0

