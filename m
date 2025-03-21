Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D0F1EBFE3;
	Fri, 21 Mar 2025 07:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541733; cv=none; b=PmPQ1sVGHjuMk8Tw53Pu/3XTLrLRSmhOgGCB/eNo/qevM+YMIczxegfJD8Guhkw5mjWJ7Co36E3e4q38zCicvmZnWUtqOs0eyowy/yMkrhtDBHof4PHkGOFcAinVAq01mx4tzCYs7pObJObMDujlUXRoAFzWyi2T2hecIUvCFZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541733; c=relaxed/simple;
	bh=J8NdVGjLuVcT3mulWVOnqIC/aOhjhTUc3GxvyvYO6lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aydv9IQGfvUnTKzN6E3Uy+Xp6XdZUh7QXnBkfg4kpreWobASXfLHWBz8FKTvDjqtNlnUAzGLR/7la0tG60dU4/8SzxSMYnzhCkfwXLoe7vZVKaj8fF0Q5TsVQ2d6diHbuLo2dahRRhq2bM0AEk1yIzyBfumi2LOIdX4Qfa9sYb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lrHau7Ew; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lrHau7Ew"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oSgj4h4YDOLOkVMeR44E0x7ZiyX7i8jirGdxi0X7Pgs=; b=lrHau7EwFVbILcNPxvgoAI+HAT
	qfOs+/R1tlrKN2eM7nO/3IIYlNO6wgdKPHkyPQ/Ogvcvk9cj4atQ4r1X8RIS23/SmEGAEmnagZb7g
	xLxFel4jhq4Uc5vlmDJjdLB+7LVirvq/d8uZkrm2k6RBXAFqbJbenvWgeROO0clB8BLFPvCqMIrD/
	JAzSJjHwyJbAEKeye/+DN56tVPa3SUqnMbDdoetT6Nry4M63cRvtKo03TFflZmgq1DnAnSmAT8VH2
	qQivc5VjYEcntby3C4miIC02DDZjz3zNOkkw+1M/F8Uv/O+sSe4gSqQLRabz6tHF+S+6iTtLPda7r
	UH2JmZ6g==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhn-0000000E5ID-0zhe;
	Fri, 21 Mar 2025 07:22:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/13] xfs: skip filestreams tests on internal RT devices
Date: Fri, 21 Mar 2025 08:21:39 +0100
Message-ID: <20250321072145.1675257-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321072145.1675257-1-hch@lst.de>
References: <20250321072145.1675257-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The filestreams tests using _test_streams force a run on the data
section, but for internal RT zoned devices the data section can be tiny
and might not provide enough space.  Skip these tests as they aren't
really useful when testing a zoned config anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/filestreams | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/filestreams b/common/filestreams
index 00b28066873f..bb8459405b3e 100644
--- a/common/filestreams
+++ b/common/filestreams
@@ -108,6 +108,11 @@ _test_streams() {
 		_scratch_mount
 	fi
 
+	# Skip these tests on zoned file systems as filestreams don't work
+	# with the zoned allocator, and the above would force it into the
+	# tiny data section only used for metadata anyway.
+	_require_xfs_scratch_non_zoned
+
 	cd $SCRATCH_MNT
 
 	# start $stream_count streams
-- 
2.45.2

