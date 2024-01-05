Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4BF5662
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="guPfHJSh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=guPfHJShE/fUsVMlLR3GXxUqfg
	4s7zjd4VgW2nmSzlZW1l172BE9yvhDLfKsm7IGlUTffXHuG9Xo/TiiN8Q9RM+arrWMfvXL6IpQ30I
	4vblErVuuu1AfHG/YnYkNKWxL3mfE/wBuH5ZJniOl+HgABJNb8cQ9rby1W8lukUt9DZU77Kp9yOcr
	Ey1EI8vGmWeM7ATn6dmgwnLRffdeHALjRGqy9Z87jPSCVP8OWHRGPwRDyULEDF156q/Hk8DqIie/9
	+jaqWhgsbAGnK99i7GpkW4qz+TNAO49PcYIv61gNAgSEyNBDNOnDZD0SNQYDia490LK62aedA4eBj
	4D11CpCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd0j-00G0MU-0w;
	Fri, 05 Jan 2024 05:44:49 +0000
Date: Thu, 4 Jan 2024 21:44:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: report quota block corruption errors to the
 health system
Message-ID: <ZZeXUaOt3guaxbc4@infradead.org>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
 <170404828426.1748329.16008537015421616486.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828426.1748329.16008537015421616486.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

