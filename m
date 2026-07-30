Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C541442C4EA
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 12:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414525; cv=none; b=IYJ/V1A0/tMWoMJsYkX0xCViwWYqqEOS6W3Q0gcWIwUsP6F915hFTzXjOvaoaX4xB0GvY4L/6LMAQSG+dWkBkUSF3hpHL/7zK+z2JEP2JXT86Ku9nHWxDZHIQMWgg2/8alvGV+wV0djSFLVIOLauRTG88Q7qGD91QHcqGA9V8Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414525; c=relaxed/simple;
	bh=K6r6+SKkfUFHwJIM+qVBAg2evkhMMtMZs8lm1GhY5Js=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ahKOB4GTGtK6S3XHrfSGJigZ8OJpoWqG0Lri+132dNfqggfDWtStbkG7U8GO/4kmNSfUFmrRX+dhbrU67oYNKBGg/fHyvzj3TwwYUMofaEO5ceR3tJsceBU+3ez/gdP/WSHV8FnwqmHbm/J9aCrwPc+K6GwKpLEAWKWedXV7mfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h6x6ClVS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h6x6ClVS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=K6r6+SKkfUFHwJIM+qVBAg2evkhMMtMZs8lm1GhY5Js=; b=h6x6ClVSU6K9l3k/DwLr56Z9Lh
	CxOc4YRb2VIz0izUUjhQnnUMa5i53SEqY1mVFOei49+dEJ3sJDKsi+T63T07dZBeatf4sAsnQFupL
	ZG7V9V37ghR3h8y5GPkNF2IatRYJ+p+v5V3BqJlqwGLiy4BeMFuE9dJ1z2PHIK3y7EaOFUP6cy1WY
	T4vqLD09q+PTtLRIgj1tt+3ZIjd3RkZR1OIDpRU1CAq/6mKn1hC8kjHa/aVg9LcbhO6L8eCAMm9Gt
	X175q9wzuucqRnNnFlaSxhzbNzxeZ5vx/W56KwqBfYv9f1etNXzAv9vqN9UgOkDh6e+Xi22Uj4NUc
	8tHPZrhA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpPsP-0000000DlSE-3X7o;
	Thu, 30 Jul 2026 12:28:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: make the size options to xfs_growfs a bit more useful v2
Date: Thu, 30 Jul 2026 14:28:14 +0200
Message-ID: <20260730122841.2591200-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Use the same cvtnum-base parsing as mkfs to allow for easy human
readable sizes in growfs.

Changes since v1:
 - a version that actually applies and compiles against for-next, sorry
