Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BDE3148A6
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 06:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773124999; cv=none; b=VGKbOzvi2xfpgagEn5O07U7hRgb3M/7o5FzD+18994zda+RAT8/7vHXNhOaRAZ6SEL9GpnwGPnY6fTjZk33pMkeeJtfNfwHXIcQ3fF064uc4kbhXBhglGqJSS5EnLovIW3pPNMAssS561VVLld6X91m5TjA1aLUV57rlwIWTDrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773124999; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMIpGP7GSEHn5hQPxgoQr1WXRVdGjQVUIUuPE9+Fb2+2aZNMwdaj4EulMngfsUTUnokLec+M9uXlbLjSZMNL78rGn/Ke8Uhz1gu9InuWSKvjA6RtkcbgKcB5zS93lXdra3Goc0IvaFbN+3aQeWXTPtRJibM+D7CkSg8guOYgrBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RHUs4Rnk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RHUs4Rnk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RHUs4RnkCmiCqZfr1gJKKpBkOy
	KoFOubsDOUz1NJNt8K82wTJ1ajLrwVvwWoqku5G/JwCXX9lMOpVwjPbUoZ6GcARyYbBlQoIm37Rbk
	JRGiFqW89wscE9WlrM25+dcMgInNSom6/7XUAgpQUN72cGFVMRhP4DqUkulAeNC8BLlsd6mM+7tl3
	apjiKTyB/G1Oky1cXEuMMnnMC+/MuKO8dJCnSu1es55T315we60aApW2itGitrjZL87c4UjHuqyrb
	Q4rxawwal/5NhxVp7U5HQQWUJxDckqlbn+z6hlAtSzpTrJMADkV6cUqck390J4rIlKBmOr1G6qKZ1
	94fnhlrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzqoH-00000008nT1-2uD6;
	Tue, 10 Mar 2026 06:43:17 +0000
Date: Mon, 9 Mar 2026 23:43:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: fix log sunit automatic configuration
Message-ID: <aa-9hWUgZDaDoazW@infradead.org>
References: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
 <177311301552.1161719.2460209929845208189.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311301552.1161719.2460209929845208189.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

