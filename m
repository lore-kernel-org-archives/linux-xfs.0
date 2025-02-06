Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD7C13FD72
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738822515; cv=none; b=ZXUbsJg1GRohno8N57vnE4vw97AE0p4jzXr7+qVY5CP4rLDmn8FvIR5dICHyhlaHw6Ez9NVhISbM2eKaR1062k/sC0d9IyVAyZqwmr/Upk7TAnA19oI8MRv49W3GgLQ1uFF1OnNJqvVMoKffjG6Rq+F/UpMBHDwx8uJzartYcCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738822515; c=relaxed/simple;
	bh=GAsTlJoQx8zUJmUCzFnV4DDcM0A4i9YHAI0dTSL0oCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WTH2qrKjWH6brA5mCfHawp+VnqsWNd4arvlkGmhI//+b/WVcjJoU2ihcmaGklp5vrhkWJ80pcO85d6VLo1ioX8fTh7Cm1SnXtgdNwP/U5l761CgVauAyLqQOMVO+PLSjEGEYWmkcoifWBGrHoW2GBV5yIv3Qj61j0Vr0ecn7OZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k/+ezfOS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k/+ezfOS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=GAsTlJoQx8zUJmUCzFnV4DDcM0A4i9YHAI0dTSL0oCQ=; b=k/+ezfOSpjdDD82GuM6UrlQA1q
	ulbvNgW2bofzxDcZN+aHJjYxl1zeI+1cgyBrqjlpVP/03MOgy5DiXUROT+pgTpQkyLNY6xlSGUMwp
	Esa03z8vc4Sw817yAWk5hzdyJ9UXGbYxINbTOOZyV5taCe4eE2vQ5TxhVd2r2lIaeKepn6zPJWp6p
	3jka7PIEogBTV+l07/QAXzKmHZEfkLh3GpWsH6V5FFtLDCsvidDmVGrt2FvYsrgIO8mJjN5V5cQkq
	p0SLXPzevbQ094yHH0wCDVqWL+c7yWwEOL8zFeirkiNcL/TRFa8GHpNFf5qNQjRX9AGkyhZZm7vMT
	LqNXZssw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvAO-00000005MgV-1jfQ;
	Thu, 06 Feb 2025 06:15:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix swapon for recently unshared blocks v2
Date: Thu,  6 Feb 2025 07:14:59 +0100
Message-ID: <20250206061507.2320090-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

the first patch fixes the recently added generic/370, and the
second one does a bit of naming cleanup in the area.

Changes since v1:
 - expand the comment based on text from Dave Chinner
 - add a Fixes tag
