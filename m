Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C50D3E832D;
	Tue,  9 Jun 2026 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780992056; cv=none; b=vAxZ8+KwfWHLqSIlXnSyE5HCkff94doIE0oxpt1kXR3FFeWfyZv20d86mzhgmvXNIts9PcsSjmoIpk4WYujEUr1DK/UPpuf2ZNe5tCjWN4TsMIgh2iMusnrXY/YP7/LbvDmygKnC5zvpcF1mnSk51+0sG7Q6CJEWwv/Qtf2n0ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780992056; c=relaxed/simple;
	bh=fEqs1i6zzjj/jYqBOxwtEKg4XbJ/0GsZVuJ78xL5pE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xa5ZgLsploNzU6/v1ejp1O5XOp5cdLcF/hpsSR7xyYeUCHlCUhww3kQuqtS6E2LczI56Dkppjh/yZhoXl3+FMLE9oFIf1zNzsdCRVRSeOe+naU06IVDtUHCxpSz5ArQpxIXOcREDlCu4YBwKtnyY+WRrfq+JDBK9155eqmMgwHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oR+mgrmL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oR+mgrmL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=zfhDjcWU8P+qtGofHrj8T1h8x9VJl8g3nzF1Kdz9EwI=; b=oR+mgrmLZyNbi922nmfzKoBHgV
	hIRR5cheunevdJHB0RLPjbPCVluW1Ti+yLT4YhXLkrBOMEBfwXqHZOIHLrGwjo8sTNvJqxXSsWdh4
	OHRCsXOhuPLJG4DarltBqTi/+OVp77inW8WNDeSaLODOvEsb8f6KPiHpHz76aaSGR8buMjgZxAt0t
	A6NMaqe+Y+Kp5K8vEPeZy9/7Y0UEVYTzzairDkwsJ+tqH3/meKWqn79HZTyE20WTyro20cfD+LdWQ
	Tk5NJod8R004wyUkc8ACWGHkx2n+khF8U2Uw+0fgR7pPd+CJWlW7FWSo5LoG4X1iIO7Z/gHvB76uq
	NkTG2nEg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrOI-000000051GW-1iWM;
	Tue, 09 Jun 2026 08:00:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: add another RT growfs test
Date: Tue,  9 Jun 2026 10:00:42 +0200
Message-ID: <20260609080051.1712103-1-hch@lst.de>
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

this adds a test that actually tries to use the newly added space
after a RT growfs, and reproduces the currently terminally broken
zoned growfs.  It includes a special check for zoned file systems,
so that it does not hang on unfixed kernels with zoned RT devices.

