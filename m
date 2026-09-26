Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5C221A459;
	Sat, 26 Sep 2026 06:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790402832; cv=none; b=TTVP5/dRjarSeKJpCnueWgb7F7eQlmRN2IEz6OLCcHHTVGe5HuXr0OyfhDctWuxCuu6zOVrZ9bZsrQEFceL4qF+FWCN4z9UDhId6LrB9gHaCQO2tUIiVFHtrObAJ/lmEWM28F1/kT89+RjSBkBXzmKn7YZamT9bZA1zLK2KqBpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790402832; c=relaxed/simple;
	bh=hEjaODduVcrYR0vvx9th7plRKPnx1VIiv4lKUID7QW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r6bXOFPmxM8hGEqhG4Os082mgO7eYX8i+PCzTA9XqzqtiJO4sNOg8AAaQKoYxIwlf0UwI0v2swC36lxDFFgTjmmxTqEhqt4W+/iCFNnBuHDwHdY19Uds1bLhz/pdDpWbrn72vzw7Ih64oTh87XzjFHC7bAXgZF2Ks7jKaLZrL1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZfXxoQV0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZfXxoQV0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0fOD7pQjECabMbDxifPoG81v62o+BaP3qLyt/KM1OH8=; b=ZfXxoQV0TFkF9tHD3stGfCPJc2
	0Vl7A1fHL9HPr7nvAbpTavuP5aCxWAWMzg7+I10wf8PfuDPYy2Vmdz/DOPRldbOWd5yQNqIcbYLVv
	A7eiq7ty12xdvBB4r6ijcJJtVRUXeuoWYmF6PkFjrEaTu8c/CInJ//UNUCFoUbnikaGYTpCpthWPw
	0OdtPxiZBdFpHWHuf32wmDBVMnYuE5yt7R15roNJwX7Zf4pamt7ENkYFZiIBd8VxvwBpcnuEn7ddj
	YIMMxKRHPMc0yvvQIX/Tvel3lkp8EplAJQETGoFDSRiwbpTt2/3/AOBXpiTZcmNl5l/0cZqd0OJ90
	oVY+pgUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xALYy-0000000F3pE-1YFS;
	Sat, 26 Sep 2026 06:07:08 +0000
Date: Fri, 25 Sep 2026 23:07:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Steve Shoecraft <spshoecraft@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC] MXFS: a shared-disk clustered filesystem derived from XFS
Message-ID: <ardhDI-Ko7b5RccH@infradead.org>
References: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I don't think too many people are going to care about your LLM dump,
or even review it.  But please make sure you use different magic numbers
so that a mxfs image left in the wild is not mistaken for an xfs one.

