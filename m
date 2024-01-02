Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2353EEAC0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AAC6C0hi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AAC6C0hi9McUeEZGAuKQTF+078
	NUV/R+rHEszKmLgUvEttOd6xGrKYDsddDjyoFe8Rv2Pt4BTpsvkIo2xB8B6w6t4PHCvlIjWz7NX8o
	9HvOP74mNQjfD+ZqFjUXrc9daWUbsyeJb/RNcNZ/611Ap/znlakX5eZECLHjU9F7xhWY9nPdCgWbM
	jcADiPvD4sEpAXDoPbnwuCX/U5URUKT7eRSK1rjAmlBzDvZh79JEY0lgWmH33xHySJADlmJoxMYp3
	kIaA2mQLSIQp8fSAbOI1CrxLJfRvlAv4/y4+xfH4cJM4BIHsWSGyw0Dvj8thXOp6/3Do1XF2Fm7XU
	6p8UcErA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc9N-007cF9-2b;
	Tue, 02 Jan 2024 10:37:33 +0000
Date: Tue, 2 Jan 2024 02:37:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: rename btree block/buffer init functions
Message-ID: <ZZPnbcl58WTpczMJ@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830593.1749286.3343479790539802630.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830593.1749286.3343479790539802630.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
