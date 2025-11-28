Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B884244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311418; cv=none; b=jE4tyGDvRv1SoFyVlzOMMJhCWThid5cHNE6UYDLpyhJUx4WAL4nO+EnVjQVCNsLsEB57e5qvB6OkwwxSuQwawvmFU5EhE6fmvvjFXNXnf8QFd9Ci6k8n5p5AvjYzqQcFIuGD/2e9C7UO75BTBFOjadllORFv6M3voJ1CECc1icY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311418; c=relaxed/simple;
	bh=a35j5qUkATP4jKeTe9u6tSo/d6Ri8m34UZi1PNEWAjY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=muWeUSLOcQ74qJQ84O/hWAQyVdqxRnqINJBBpNNwrLM11ktEw015TvZz7tvZJSDQfDLv6c26xEgXYnSESPwNNwIDVy5VFqfNkYQZdPT3LEaWIz3PCKp/DJ7fnUUhfeJgAPusrpJddsJ36z3xK2wjnUkkb+MIEc/d1Yuv+T1WIcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0wsQg0la; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0wsQg0la"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=33ffcCLCSHWnTZNAo5lCqfzI5CZD4d8bMmIRit6RFLM=; b=0wsQg0laCRxjKgc9N/tn937U08
	8W0M9/IbZg2uvb/Iq0Mj3/o8MiIelvFuleR934zAMPMFFdvrr5bnP2Hk+/1gqu/6pWHE/j9s25DBE
	DO6ZEck6MQUmbjopqlDTt4d14+DCNOq0/MrWQ7kKJErZYzja4ZkTVwfXvIPKNWTt0vSwbck2iMBkI
	Kn4lU3N6KgoEdt5jX49+26Gk/YR+lvvlZxVuhRH4xcsphTTLJNLg8hjCJrRVog9HDaWzyRU8UG789
	sCzPYWWEnEnDRykY1eiqhSynPHSdX8R/eN8FaYa+1uS3Ows0NrSK3JIZGrI7+ZO+zvTHG9FjGh4Pe
	r06TA4Qg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOrzj-000000002Xl-2tjL;
	Fri, 28 Nov 2025 06:30:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: logprint cleanups, part1
Date: Fri, 28 Nov 2025 07:29:37 +0100
Message-ID: <20251128063007.1495036-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I started to look at the userspace part of my war on struct typedefs,
and while starting on logprint I got really annyoed with the quality
of the code.

This series touches to the log_misc.c code to cleanup the typedefs,
switch to standard formatting, and do various other low-effort and
mechanical cleanups.

I have similar patches for the rest of logprint (which isn't quite
as bad), as well as ideas and prototypes for some more substantial
work.  As this will be a lot of patches I'll try to split them into
batches.

