Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F4517752
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855067; cv=none; b=Ceke0SCRlr5tDYQnr3mHgwcDEAaxundEnXJ/6EFa+gW4TMe+X9wlbZhkuwpqWCP6R2p3l6w85CvEtq+OmqznmWAJRb0MB41wRJAvPYT0fEIPvO20BnyV7WQncUAv4u7yE7SIyI2utsywylqFJwq/4Wl/5Vf9Mwk6rmGiIOiBPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855067; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdJLU8gTqDqu9yeoF1W70tfQQyCTmwjTBMVvX3VkBz7HOsNO8RujPXHDt8JVUsl5cxgPbTrWvzm3K1uQC4wyn4rssn+Moo0tFynCG/yClIghNSD7PXIIlivRgq0Aq7foWHen/qeanWMX18fdwo2V3F3P1uVLn94dYEBxmK/AoIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D1oxuTNc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D1oxuTNc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D1oxuTNcUUyUoR9mN8sDodKfgZ
	8xTPpC3d2IKRXRpo7PFO8t8sc6AG6ITDFWvguizAtS7hhyEz4M7EgTg6G4nppFVfnWOEv7UXrDOLg
	1Fg+sJoRyBCNopWEtN2fwjY+oqMQhTwABkkGFUFcaN4epAmwwEiOeZsFCC4ZXD5LKIzUJ841WdZ99
	PMME9SvLgZVRfQcbcxCe9r4ozP2qyvk5FApvwkYNHUPlMg9QEymDGvdRB6Z3hsmVtmpQo18+CiQWt
	IZi/MIsbnYxgJFfSOVktpFKA1od3t9OojA4KYpFz8PYcf1uC3WYK44Pm00Zx8+e1Q2QYz4eSAfBky
	XBGs24Mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmyQ-0000000APPp-16PO;
	Fri, 02 Feb 2024 06:24:26 +0000
Date: Thu, 1 Feb 2024 22:24:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/23] xfs: create predicate to determine if cursor is at
 inode root level
Message-ID: <ZbyKmqMiZlxwBxIj@infradead.org>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681334318.1604831.14019767811861690726.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681334318.1604831.14019767811861690726.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
