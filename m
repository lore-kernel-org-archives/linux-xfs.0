Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6978E548EB
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414171; cv=none; b=B2yWqbYrVLhHiX41YWiays+u67ARkTYsEv3SVAWj2qh3j2nY9BtX67cNM43YeahwTDqdluf5uxGl/LYHcfMwlAOFt5+JbMpgsu7O5jdM2SJSaesjTvqnqX+d5bUEM2eWgDiodvEicmO9POnEx/KOpx4zTGNIqVbTYRjOUXBmRVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414171; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMrTjuxV7mjepcC+Iytdeyf5IzP3voPU7Qz4uwzlLfl9gXOMxzVHMWQlV3/Sh1t3Z6W7dlyGWrGF68NfSw5gK03NPKYUq6cfbbe/cGBdiDxU7o5MqxauZRP2C4SsJWIbH3vZktFkYZv//5HtCgrwoCIoh0dDsCF+Q8aYk8r8VSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hIKNLkXS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hIKNLkXS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hIKNLkXSS8nW1zuDyORIZI0ASD
	T5Z7US9kR4JWAoseOEYqiyNTVGoRMexmA2OpbUqspabCUHUxEIDroI15yjwjlTp32ryLCTvj10ZoU
	H4iJxQ/ELTsM6nopV7NJJ/C4k+cF4IHmSKpjypZVbbe1SswYW59Z2REG9QGPMYBTP3aG5jidHbDD+
	gHoRjbe+u555sGKf2yPcCi3Unyr0I9baohDH1/zwpACGQ1GqPwhyZo0I1TSDaXpsMY+LawFf+itAP
	uYq+T8HI5jN+Kik4nxcquoVdRVgP0bDBI7nMuw9KcIuMsKhmJikSyNC6LLlNVaLV16pU074FVmk/R
	X35h7/CA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJIP-00000000tCv-3zDK;
	Thu, 18 Apr 2024 04:22:49 +0000
Date: Wed, 17 Apr 2024 21:22:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <ZiCgGcDXpJ-5gS4n@infradead.org>
References: <171339555559.1999874.4456227116424200314.stgit@frogsfrogsfrogs>
 <171339555598.1999874.4695876291132839484.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171339555598.1999874.4695876291132839484.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
