Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC315B11F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142202; cv=none; b=JoBJCY0jBJD1I0nBzN2cE8Fgy2mUlm2uij0HLUQLtBl5DNT77R5J7lv0hPDa1K8wBWS6IS8icc/h1YkvKC1oh3jc0o2sZzyi/m7/RaP5Jzru4CZn+PcLtvXQkxzJYs8LdkehnPAuytDTDSWR1jnz6NqyZNfzOb+pmQa6S2gG+WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142202; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VVgvzDE55y/YxPSaXZyu5sLGq4CiMA5eM7k32Vn1cx4F+QvuAc0fDsyMnffiCRzmjIPjww5uxuC8O8H2GArOFsjs5dFSqyt1rWE7UhIqSW+meWwc12swrtEb0vcRVno0CD8jt2RFyo5H+1tqT63cYfW68Gg5+6pLx+Zo7sIffTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wO368epx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wO368epx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wO368epxYqPpFSalAia+arLmQM
	C3SEoYJCO230irx9fce9bRZNByf6ddpR5GrKgvZ7UbH2vH5HX5OtjWxCsFmddCGEj0xWtwUyrkutt
	+VlYrTX16lKgMkgJAO8I7zo5UWrMuCg0LWWSjvNp7VvWebKgX02NJwBG9oj97L1fkoevt0s2yBib1
	gdMeNPGJTkofqNbGTluhZZjszxdbM1Ev5KZwzACnyJe+M83R0GmltJcFtG23ZqfZo+X+Kf53gUFxS
	mY+cLWKWg8J8rsJT4ZzSvlnC1nVeZ91pvPu4IbBHhtLCNPeqi4g/tLZdqi+qWf/ptuYbnMrZtzLgE
	4lzG3f1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNxh-0000000AL2M-1GnY;
	Wed, 28 Feb 2024 17:43:21 +0000
Date: Wed, 28 Feb 2024 09:43:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/4] xfs: pin inodes that would otherwise overflow link
 count
Message-ID: <Zd9wucA_xPdddcdM@infradead.org>
References: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
 <170900016091.940004.17266621911356568500.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900016091.940004.17266621911356568500.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
