Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E058C0B;
	Wed, 19 Feb 2025 07:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949455; cv=none; b=qipCFPCxJFaGnu7Rpzle2oSG2pQrA5At8djP6nCtNNtGzburQ0Mo4MGWWoXDP8yARWRsBGNyrbb8pdZTLxJhf51qHO2iVPuMHsYJn9ZeAMCOZOkRHOhiLgbPp06JEePTvDzWShdtGKI9u+AE+lROP03PzO+t47iLCKHagRkT2ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949455; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGBP65sHE8COkEALsXkC9ACBQC7sU/JiSWrVQoUUlgHWHOWuP+dJ0/MbJPICjrdfrdAU/HIoaeQbXHHGiR5rxT+JhImtKP/mqrRV/1K/gDsqKDP3u7YJVdxw1uinPFxeXBmcyL7clVVjkhRT7+/Dk/MnIn7+qOsl0xgK3agnNmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w9/LPfK8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w9/LPfK8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=w9/LPfK8Ni6UBB4GaHSj6G25Nj
	V3JoeVIEaAJ+pWafY+V9bz1lxAmph3caXCsdQAAphjL2DfDTx+L8W2dLVVVHm/oFnetg8ryAWkQmY
	RgJkGnkFCiGowsEwxPj+9JCEBY4M36mJkUGfVwKcRAKmszRk37KQKS7v38bMvhpHtPfmpmceGfypQ
	Hyni/R9ho7Z8PE9WxDMjr12qNPKiki66Sgue0gjGs7+7nY6cFk7NszrZkNxY5iot2RO0gC4VEBR75
	w49Li7N9FTnoe5CF+34YZx1hn7LFWS5BT2qqpR7sz4RK+Pfb8HKdmDchkVNyY+GEu5WWKHqr8IWOi
	kWLQ9gMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeKs-0000000BCRo-0QYs;
	Wed, 19 Feb 2025 07:17:34 +0000
Date: Tue, 18 Feb 2025 23:17:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 13/15] common/xfs: capture realtime devices during
 metadump/mdrestore
Message-ID: <Z7WFjoYvrIUEl4Wv@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589419.4079457.7193155898233380338.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589419.4079457.7193155898233380338.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

