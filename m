Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BE54825B8
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046932; cv=none; b=uJVG7CX3PWFg4IO5Ccz8DI9nuL49jknOQgG6n/RGBDeS299inG22moI5SO/tw4KTB5Do9FNvp/u0Qei1nVfGAkHSbasEUKek4WNUQRLYYkdBjLPFB2LXvRWOGBREAm/rvQlgwb1cH44mwrVQ4RYL7Q62pdhDcibA1p7M49xNwKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046932; c=relaxed/simple;
	bh=SC0LSEJMbv3KWLWgr7JvkrYCnbVNv30I1W7ZCUZqEGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YZJM7AHygMgM9+f5CuPzFSECDBkhOJD+gDCQ7CgehjpmFRWEELSE9K6cfCHrPs7OUhIZs6K9sjc4ep1DwGX8lwirQTXf0UaEDUbzvGWMnj0nI0d0+cIuM26ruzLhk3yQ/Ai+RjCn4OsZJ58CZkhy+kLBylkcl0pnXZJ8xYAVI4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hldqlwBB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hldqlwBB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gYZGGwffGSzFJHP5Z4nfevcuBpVerS7aCSE7s+ZDK3s=; b=hldqlwBBm545nem6mKGNtHSF19
	w6qpRUgP4LIdudoPpaUUfzObLdzO3BSNT6hTrV0e1V8QOw9+Dh1niQTKr6DkYeP9YSghoSiC1aJah
	VHryYra5uc55KXACiZNz+waDh7JK8SHleyQRfQdngpW3mx+VrOBPC6q4AbWFsma2weMQpUoor2Ul4
	32Y7cRMGaEe1/rBNy7avCmMFHDLqnZnXBa0Xxh3J8F1IUr2RZ6uA3yZW0KzMb0B7HeXHjUZdvTgG3
	CK8mwIn9DPbLh/nVtyPYqVMNiZ5HD5WxPWNjYMg+kwrGZPw7W10dCdiFClcPN/r3Fhq60Kho3RUVP
	RD4csQIw==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4epa-0000000ESrM-3nNp;
	Thu, 10 Sep 2026 13:28:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: reduce libxfs divergence from the kernel
Date: Thu, 10 Sep 2026 15:28:30 +0200
Message-ID: <20260910132840.1541283-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series tries to reduce the amount of difference the shared code has
from the kernel version, mostly by adding more stub headers.  To ease
maintenance of these stubs headers, it also moves them to a new
directory.

There's probably a few more that we could add and together with small
kernel changes we should be able to keep the files 100% in sync, but
I'd like to test the waters before investing more effort.
