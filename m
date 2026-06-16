Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77785332EC8;
	Tue, 16 Jun 2026 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613861; cv=none; b=LZswYfbGsdxGopYUaBY3Yg7hPuE73xi+pe/4oEFSJUKg+nlS93H/TT8UB31d2QfXg/6r1AhaRroBXOtdTUvL/cCVtQCl2BYhpg1jomkRdJTMYysgLvBeMTwnP72+8B2coDm6LaQDAIMSayESRESlk/a/6sdYA/vsfR3rgR15bto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613861; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGpvWHVY8Nqgr/UTj7Jaaau9T2gbXqeoV0W3fbpPececHF6JRDCLRK5WG2acwH4NPuHb5BJgdNOMEqmeBAp1qJhuCSlRuM605icTs79E3NuOfZeNPzNgTdpc9SBUAQyI2r/1FlaPBeZN5pQw5c/4ZwgVpPA1RtrAbWl80liHENY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BUGo6tkE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BUGo6tkE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BUGo6tkELx82Q9HWYoFDTJnF77
	mU9AzIbR0FxvNV6pDEltizQbIM0o2arcPnd0cFLz9qGyFyyEaeSGa3Cvd9gVWfE+JVLVBm2sfJhAt
	rliIM7ocLt96IFIWThWBr0KP2IHFrZEusSIKuVcowNEeLAnEMdy6zL2L45PRi8/QMRJ0c/IiMZFvR
	LVZoxv4II8S0j+poVtCJxXEK5j0X/s7RgjqUpC+MorPfWKe08W1v7vsJL4/6/7KbW0iO0Wr0zqSyD
	i0BrN0xn1rpTTSxyugMWfnA2RZFtI4co57W86sQF/MBTzOlErDqIZom1BrHwyxsdLnHUlf/mf1KLp
	J761ZEfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZT9O-0000000Fmhm-41vj;
	Tue, 16 Jun 2026 12:44:18 +0000
Date: Tue, 16 Jun 2026 05:44:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] block: revert the iov_iter after a short copy in
 bio_iov_iter_bounce_write()
Message-ID: <ajFFItbX2NtDX8-G@infradead.org>
References: <cover.1781597506.git.wqu@suse.com>
 <c400989f227343b134110773d5acaaacf7024574.1781597506.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c400989f227343b134110773d5acaaacf7024574.1781597506.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

