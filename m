Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89804EAC0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 11:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="frsjx7ay"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=57AqO6U8ZqKfoU3fNBZWY80opc7vw9hGoIF8Dw7Mj0Q=; b=frsjx7ay+NEhhU+4APT5vMLvum
	xSzWFlTuk4SRjQ2AQUd/1Qzs++gDOfZdoWi8l0InYS6GpAkEuSoCT0EKQyfv6RkZ8pDgP/AopCTMH
	YJfNWn+JHLW60uNFgFcKAHiyt5DRvgWT/Mssof/CtNuBRLAu/8XDJCzcB5Fr+ChFFVFfm3PCbp9sI
	j59vPkN9A+Uy0T99rlKaUnER6L5UWcItAleZWTQT+cym9BhRCHueAgw6B6YE8xqbC/qKBTvx1c5B3
	Yxv7t+27C+G/QXLk3keusH1peI4DHp6ja2eIMxaohDW2wHZmbcUueCOFhh3UqPOLxrxJWf7QB64Kh
	UijAfqFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKd8C-007mbS-0m;
	Tue, 02 Jan 2024 11:40:24 +0000
Date: Tue, 2 Jan 2024 03:40:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: iscan batching should handle unallocated inodes
 too
Message-ID: <ZZP2KC/dDD6TeFxo@infradead.org>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826619.1747630.14010547497155037331.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404826619.1747630.14010547497155037331.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Any reason to not just fold this into the previous patch?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
