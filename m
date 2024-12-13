Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10702A1BB
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081439; cv=none; b=hOA8qSAj9jlxFD5oxJV2XFOAqPrbEh3jYoVMRTGNCvXa1URAeVeZb1Nno4rB3zPfaq6lU1POqsaHjGE0/f+hIK+nqLEnO2YAK97xyIJYmfhZ5YFdllVfxvEDw2NICElL0Wah6Er9vGtnwkv9Smp4NNOroVD1Q9hMzysqSwp2Es8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081439; c=relaxed/simple;
	bh=1umyAol6qJ52sj688B0QitsfoTQEqbkW4R/EnVJiSfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUt5ME/MKjyfr3dPkD9JcPmY6bC8t0MVNGaWj/f/4gfbQjuFHmtikAjRXNYXNM4bnW4fZ64YkfVJQW/WY6vZxGRjBUAeywGkqmpqcvybkhQ1XhavCMBINrg8zOx8wovfnkQnOva1w0z5BGlefBrVGD3TcAyoimOx09gfUgKZ8+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BizFP3TP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BizFP3TP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1umyAol6qJ52sj688B0QitsfoTQEqbkW4R/EnVJiSfk=; b=BizFP3TP7SLDNH0nesLjPfmUGD
	iooaXUzYQulw8U3lEWk967/Ayig/dW0zjNZ7LTqVwkSNHVnH11anfBz/VbGnAbbOcg8kKivybvez/
	0IP/8eMJ+96qJzJzyQ6eW1TX2L7eYcKLPA9/IW5N3b1eUfeKtxZNiP8g8TnYycKVBDpLdeoG5u/n9
	c4PHkYX0FKUxMhFZeOKmGcj7KbSO6IX4r2gVX9qVXXUh0JAOCJGuMYsW/LWkPHmfqHB5qdRe9t+xc
	llN0zMc/5I6kWv4LCOxBb769ZgvBSoFiDEfHsMObMSWz0Z4AtiFRKoNFRox2ewCeVELwzT+PfD8Pz
	TzPxkLoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1nR-00000003DV9-2Lxc;
	Fri, 13 Dec 2024 09:17:17 +0000
Date: Fri, 13 Dec 2024 01:17:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/43] xfs: check that the rtrefcount maxlevels doesn't
 increase when growing fs
Message-ID: <Z1v7nV283MnAVnL4@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125012.1182620.2980242584015172989.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125012.1182620.2980242584015172989.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Reviewed-by: Christoph Hellwig <hch@lst.de>
