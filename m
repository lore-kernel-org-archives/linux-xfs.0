Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B688483830
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329511; cv=none; b=bZnyTFMUaLpzkF4caY5s57R71Qz6dvFzO16DvbPcvutnCNjGBTxdpAXvKRHRWhyNphzIv2LCaHCrmP1shvfHZVr6i+rK2Y+3/NKQV4Sa8a+NgtxtIbWICbTXoOlvbyDQjjrJ3OQ1ltBeK/bjGZiUvl2L2rBWsflbxXL+T3E9K58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329511; c=relaxed/simple;
	bh=ay/4n1U2I7TFhTCKKg8wgXxwxXPEFiuyeLEdikSZZ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChshxfQg7LjJ3ysU8LtWF6g4Iq7cjwKEBRLMhr/vvYGpCS7i7xPb+hJ49YKpiNKwRsxglFoxm4RyTMsZD+juXcFsSlpFvyrfCzx4cd7h/t9mFoFrY6REXGr9fo+hp+Q2IxANzZ5vNIAYy2Zy/a09+I3ZWs3PLIkt3NT95gqisxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A6g8JpV3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A6g8JpV3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SQlYRFv9Dpw7RPbN9ilROdOVFgudZbiSQv//XTbFnRs=; b=A6g8JpV3ccz7hdeiH68KoKaK1g
	xkbQr/hpT218u4fzzZlsGQS0dHvciVu4TNkTrD0QmLe05Ru24671FMdedYsTHQAlB53fslzB15ZKH
	75wZJWKuKeXkJGWu+OO6iChYBZKnV0RhIcDufIHblbp5d2LJFf8r0Lr0NU7OJSFdxaDeta4f4uTcV
	YhbGu8MANymDdr84jNfjKgM81mKsgfjf8DXymsFxOaVOvRwJdHgC9OtCKi1OYJUrIApFG1dZLJo7H
	FbCtauQujO+dO20/ydV61HqxaIfvvwxErrkWGiNupfwakCLuB73eYYhSbkuCeJik+1BIwZEaROVRi
	4Ev3/LPA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3lD-00000007y0E-1oQC;
	Wed, 29 Jul 2026 12:51:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] copy: log the error number when failing to write
Date: Wed, 29 Jul 2026 14:51:33 +0200
Message-ID: <20260729125139.2280775-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729125139.2280775-1-hch@lst.de>
References: <20260729125139.2280775-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Log the string form of the errno value to help debugging a failed write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 3ba9a07e4469..ad18ceb1ac1b 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -891,8 +891,8 @@ main(int argc, char **argv)
 			off -= XFS_MAX_SECTORSIZE;
 			len = pwrite(target[i].fd, lb, XFS_MAX_SECTORSIZE, off);
 			if (len < 0) {
-				do_log(_("%s:  failed to write last block\n"),
-					progname);
+				do_log(_("%s:  failed to write last block: %s\n"),
+					progname, strerror(errno));
 				do_log(_("\tIs target \"%s\" too small?\n"),
 					target[i].name);
 				die_perror();
-- 
2.53.0

