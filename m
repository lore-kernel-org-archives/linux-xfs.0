Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9215055E6B
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538112; cv=none; b=TlgdQLGlLhIPpx5C8etF2jFQed+FB00C5hBGLdCMdf+YdJ7x7xNDfho113uvqNL6iuEzrqEEVrKPLBjfeEAsMABd1kxV8PnmD8bvqHQWGY+lO8VMo0+saUVt+UwDON/GftwKvyGZb9HvZw9mesC6eE/qNd2gSYGYpyw1bz8l0Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538112; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SFXuEMM7WdtDbupbJ3oi42pSPXM0ysEx+YQilc5f7H0HqklDfPBiuNoYldmF5jx8GMPtllLK4wejk43CL0Rij/ZFnI4bi3v6JIQzcb+NdKOjgejYlZPp86kK4i8vRpcF7pJ13JQ3m9oF6xxkh7545DVShvAmG8Ap9eO0lodskpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pvgIvdHg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pvgIvdHg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pvgIvdHg/KDwWdHdWu53NMn2Ru
	RxxvyAIvJJ6cp7n02AH1lcgVsZMcEz7dfe88/8CDOq4v9js2NcUJydVzZwLRpcNArzHiWEVGEfO5A
	S1MuZEDSs84KwhpJLhZabWI85+YjX+35t1lbcwgrLXrMtY+v9eb9ivNw43+XyIxY9NvEPM/ZZ/ofr
	Snd/kkGEaobI9KwdBRb9AMUPbB3AWxgN1g/kGHJzDT+Y2jYGPRVIg0rsz3+TdnNewfmKrUB7yJdyE
	tjfpLqOw7FM3P/IciqWbgFTKu8DI6GiYy0A8u+MRqjm0Eh3zvUOGqGuf7Q4IBoq0s0J5j3q7vWAcY
	WWJhZIIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRFP-00000008ZQW-0b5H;
	Wed, 27 Mar 2024 11:15:11 +0000
Date: Wed, 27 Mar 2024 04:15:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: create an xattr iteration function for scrub
Message-ID: <ZgP_vy7rOJfmyPig@infradead.org>
References: <171150382650.3217666.5736938027118830430.stgit@frogsfrogsfrogs>
 <171150382786.3217666.9345698825963380599.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150382786.3217666.9345698825963380599.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
