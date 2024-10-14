Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F7315990C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894388; cv=none; b=fa/Cst2o1ITIm5avjyupWPRnEedeqoZiRVayCa78pQv4C3kDD7YjbAGcleHJHhl2CYUu0zGkhT6uCHOBh9tUOBh12I2S41yn0+1Kuw9xCXNfLSvJrCSmOi9ria6hk9jVGqHtb102hWrwoIGpgNo/3FTV/cB1kL9N8yr4C+m6HFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894388; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NeRYFaSGnbo2m8kjank9khDzQ02NsoKynnGkwf97qLMc/m1yVYgvX9snoaIusKRiYUgyOJxjbRKQfswgo+9ysNZTVu5EBi+2ZfCxLzfUAfEDS4Qn7vw9wDUU5/pW+nHSPo3UP9gJtTD64NZYlD4Q5Bw7RfJ/lNBTh1bO5J2wAvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q0XDZ7e3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q0XDZ7e3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=q0XDZ7e31Wy5KGbBGHo1CmWxvF
	PfBuihrnaoFLEUlSOcfZvrKpo/JWZRUQM1XDnsje+MlM47e22AzhWafHsczN/ysqFhHNrQQwY0fGn
	NScUOtao1Rc/jCHOPntZmk3kcM/zfxj7d12NldQEMdelD777EErc/FbLmhIHvsHVrcFNqk446amuZ
	vRhGm6Pq+YM3cA94C0l49bQu02d36AdIZg5Ghn4vgCabz8w9n1PZMNVbldSTmxfC5e+M8qjguYxZL
	VT9MsBR5vQ8FLf0wFWCZKUhIIATCZYbgll0fcsDzgC5SIlvpk0OCDfa/VNR9pM8voq/Zc6Tum71WU
	0qEjg9jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GPK-00000004H5W-2dXj;
	Mon, 14 Oct 2024 08:26:26 +0000
Date: Mon, 14 Oct 2024 01:26:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: report realtime block quota limits on realtime
 directories
Message-ID: <ZwzVsmi1IcPDn-mM@infradead.org>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
 <172860645728.4180109.10342852954128462806.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860645728.4180109.10342852954128462806.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
