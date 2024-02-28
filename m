Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B1115D5D5
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135427; cv=none; b=R5UHOH7ndoqvtofYSnnVAA4qkF0YA/u/HWCFCqlhSBl3iGUQ6x4r07AEq3ZYz+nkskeayK9ZgdAcU/3cirJJLhuYMB+Z6FJLcAlw0B6p91WqPNvjX5f4P+7FMnZs9y8jNE0KYQLW18gAkeSpc8kiU6MoNCHa8Ll+D4EIbjADHAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135427; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTELPLiXBgG5TY0w0dUOURic5NkItaZnGlU/RF/T/aTe9vc+KgGG9Iid7AC/oemuPyt2e1dqjjnNQx5JrgnKr1MRpLETSN+PtaM9Vgs++w/6NfhSA4m6K7pqiplWuOgcdvoZSDUQMUv75TV8SEkCUt8NMFPK8fgny1rYXSyprzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CQShL4Rc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CQShL4Rc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CQShL4RcQ+j0g83Ha00zr9XSXz
	J0iuze01bZv4SuyEpDXLDX/XOQTPJLRvAulHU/dfbRAdsjDg8dv0MTBpI0c3Yql/BP6SLXH1c+q1g
	jPT81kQYJ/VH7sJunZ7/pLYrRbEi7LGyfqqvyGkb7nyDzT105frS+z8BMNaamdKz65BvlEH7NpWsS
	XsgLapAJTyp3TcSsBY8PziKyv1ucdXRF1fdzcp9MVgfca8gNu13ztD4QEB/e2/ickM4fhEkILGEMm
	bwRzJFoe6YME0cEl/e4GR9xZeqBSJ8gxDG7cf5vijdCHvhBpY/X0SOA+dtoC4lsZW2pgNILtoryN3
	5U8RYw3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMCO-00000009yiw-2Hb6;
	Wed, 28 Feb 2024 15:50:24 +0000
Date: Wed, 28 Feb 2024 07:50:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/14] xfs: add error injection to test file mapping
 exchange recovery
Message-ID: <Zd9WQJRMCktiL438@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011758.938268.1094556064125267882.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011758.938268.1094556064125267882.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
