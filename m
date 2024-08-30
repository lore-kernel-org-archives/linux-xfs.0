Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46F82F2C;
	Fri, 30 Aug 2024 05:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997357; cv=none; b=WwD3D3QEyFCbREDEzn8NyuKtWF+peMZnHbhgmfPTdqJrfML3cv6R7a+VWSK2z13yBxlbJIVxeP4dnQbB72AVwc/z9n94XhYtpXBe4/a49HkmANBsRiPtLg8gy4ARMsaCi9EQTjDU75RF/3e/TiqLxihRlRXUptBd6/i3ZLxDG44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997357; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J//sOtAJ6DCeHkv31l3BnssnkPZ/pW3k6ugWqw4FFEpxO2hSGKpfIrD+PIWS0LyAfCDCsqorWmJX4biZLJbEULbJ/noHN4PKjnQldbJ4jOoqRCt+WwXGmTHnvlr3G18fECnElOy19ADgpcsXUbo01AQkXjsDaQOsWOQdji0DV2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J2NqTItV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J2NqTItV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=J2NqTItV22pQ2i/KetSdnk0AoF
	SNOQkIWijMXOUMp7Ju09vWr6XqWn9bdbKvoOYmrn9BgCWJhIgDyOy+DeQiRWLRkR/SYVcaNvKGUiO
	tzav/8mEx5giNvET3pGqIDcYsJIq9CgeROkq1qlVVEt7vV7Vj6Y88rkkqC8NZ8D0zce4ln4TUY49p
	/2pyKp12aAkpkcpfgXY1DOJbE3zuV4bkBtDuPBh96eE8jtrah6tYL5Io3ZsSM3zmzDuDljFitQ2Ng
	U8tO5PxZpME65JKuXBVcGfOLb8agsm5WjNsLb4hL+6ThodmxwrUKlRm2lIxZzMt6ZcBZvBIKnztO9
	sA3hErKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjubl-00000004s8p-28rL;
	Fri, 30 Aug 2024 05:55:41 +0000
Date: Thu, 29 Aug 2024 22:55:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/453: test confusable name detection with
 32-bit unicode codepoints
Message-ID: <ZtFe3Ynbuxoch9YX@infradead.org>
References: <172478422285.2039346.9658505409794335819.stgit@frogsfrogsfrogs>
 <172478422302.2039346.11815162501675799772.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172478422302.2039346.11815162501675799772.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

