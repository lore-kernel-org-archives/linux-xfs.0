Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DEC3A4513
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719575; cv=none; b=kIZmQv5HI9gURLVpkaq4OpBnb7V/z7HZ0XkCtEuQBpY6scGvKQnMPfUSQi6V8VBeiZM1vuNRE8C0Mgr2cfQHRY+hbwFp8T5ylrywMfxsKV8K5jBgNkYboY7lC7J3L0q6rbYmN03+JE30aYa1J4bx4pJ9CpiIvt4Fge3/QeWuurA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719575; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q94YFvhImxnQ5Nbwi7zbYtnqwDb/EVr/ODVfy1+mbNvltP64qHYQ8kWdjAe+9S/E2swZ/EkcLkwsRwJU01hnh/HiSvp1wABHRGALHo9xJDZG88HM73zpJoEAXT2ODN4QkClwcNKfPZMryWMuSIaeg70auadwDue/2mrllqexW20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mxc5lLdx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mxc5lLdx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Mxc5lLdxLJEgvpL7/GWvYfDTEO
	rFLWI9WyxKBJZNTXgaXbOXBIvGBTukjWUQNBOFhqU2pWzwEZCfbVk3XRyVSqRCSJvl+LesBnSGQ+U
	+OVSQEGGKT7/FpwWAo/AmuVsOacfBPou5RMuadEEXW96esstykqZDp+BjlGw7wyPbBqkS8M56Uo/W
	bc9S2lUO1QZHARmhuwzNuLt83mc+cOCNRfP5yqQKOPH6ciX7XLqBmh2Rghvfzz2r/nPhZj7uU+ZPU
	Zrc29lIKx/kfI5tG4HnCc+5sIWFs3LX5KCnVLyKfqtSSpWGa5HjwYjmMd/yT0sM8nif5jv1avJs7h
	9udNTV7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9LB-00000001vHi-1QEj;
	Thu, 05 Mar 2026 14:06:13 +0000
Date: Thu, 5 Mar 2026 06:06:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix undersized l_iclog_roundoff values
Message-ID: <aamN1cHDffukLS8w@infradead.org>
References: <20260305042620.GC57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305042620.GC57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

