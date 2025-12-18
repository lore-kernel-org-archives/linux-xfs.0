Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D044327C15;
	Thu, 18 Dec 2025 06:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766039562; cv=none; b=fj6S+avjVOkw3w9KfwPJpBhT5H6vjwitACJk4KHUfya+ebxgdBUHRH5fUsYuD+BxzTo4bcqD64uNueDjJMZ1SvR8CrmToHI8R0yiJ+8X0pom/2rUSDDYP9PSS455CsmHRrEzRE4eT0Xvfk6t8CUBL6aY0V9BipL959RMjyE0IPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766039562; c=relaxed/simple;
	bh=2MUrIBHLEqpa31CKM73hpGCKQkVj5jobEU67OFt0ZFI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PxZIE2X97mxmjUxw+zb27iUU28NExoPSCnxLJkPF+O2fFULxiMv18BtbH9aEP5Z/+Cz/Vhrzv2hUYCgzrpU+AviSeC2vGOi9FxXTcEjrxgK8XFwZwLMg+ewQx3h5Jgbq7jyDTTYRxXMqbkeg5l4wZZoXpJwb2c6TCXW6cd61XyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KLHBdAUY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KLHBdAUY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Mz1akZVjmDFaTkAkTqsax/OU4O34Y7eoBnfFvkuHMaU=; b=KLHBdAUYknDZdnpp7GYh5yDObD
	1AxbF4XW1HlFVG4ddXqSEqi0+Pgcdi3jEZdSOfcy+47vyV6gPM1HEDvbc0UGMuXGr4hbVJYA45v81
	vTbejQZZ5SJW1fGn43/FoF9g+2VuWon9RGPNt129cYkGOR80/HgEdSsT0NcvD8fDns8+Msp2ZGPZE
	lyTHsWPyFVKSRzDtlXhfa2UCcoHyjt1l6aKsJY4ypIyuuuwnrQJesZNlyCLUStEX2YtGFIgX0P6MB
	AseXBbuMPe1sq08NgsvV94O2gnkNA0QCkIb1ZfUPGw5r5VZ/5jxlXC0hebmZAdoz0n1EZrzHlBnTB
	v0R/G9nA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW7Z0-00000007tyA-2Kgh;
	Thu, 18 Dec 2025 06:32:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: improve zoned XFS GC buffer management
Date: Thu, 18 Dec 2025 07:31:44 +0100
Message-ID: <20251218063234.1539374-1-hch@lst.de>
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

the zoned XFS GC code currently uses a weird bank switching strategy to
manage the scratch buffer.  The reason for that was that I/O could be
proceed out of order in the early days, but that actually changed before
the code was upstreamed to avoid fragmentation.  This replaced the logic
with a simple ring buffer, which makes the buffer space utilization much
more efficient.

Before that, two patches  makes the reuse of the bios a lot less fragile,
and for that we need a new block layer helper that should eventually also
be useful in other places.  Jens, let me know if merging this through the
XFS tree is ok.


Diffstat:
 block/bio.c          |   25 +++++++++++
 fs/xfs/xfs_zone_gc.c |  113 +++++++++++++++++++++++++++------------------------
 include/linux/bio.h  |    1 
 3 files changed, 86 insertions(+), 53 deletions(-)
