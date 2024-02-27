Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB8414830D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057945; cv=none; b=UCBdLFZT4vajNP6mJSuq/kSqGVkBCiJw2npkxnvjfFF/dYIreC+KAiPRSzX3yY1CbvoKq5/ZxTYF3AYf4wR5BmTcEdMuq/njbCMmKj6mDR/YDYGyOBcYN47qAtAq2GWA0wt0TTa/lhUfPyLT6UAiy0DVrHAbiSkQwzG5Pj4NmIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057945; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUU0tFJv8OPLMSL1zcp+tkQGgmdOgEuyDuAQ/O/u8/YLYTTggi98zPpPZZn7+sdnXHivr4bJ3yc7Usil/7zOHkf3nuT1Zie52hCGKG+AH1Y5xeaoL8HM3UVSH8bUDNGtpqy/AF7M2y6anVAFmgoeNygIPJpk5hrR0o+SCSdgno0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vvFnzhnb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vvFnzhnb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vvFnzhnb73RUBXv6IRIXiEtNky
	1EimpempAB5NYyVktUS4JDiZ0uFXigrBiuSX+tKceS12yJgLOCzD0pcj7iCXcQFk0sXgnnUDZX0Cp
	K+rPCRG3sg9oVYsD6z5m7WBwqP2mjKnyDmgXZmSoWjpLn9n2Sxi+hLX26u94PS0IuR/A8rRIcTLZx
	3sOPhwckpr4ryfSHhypEWv1QwzDOXsGxp9wAWmHrYCbHllRe5BpEKXFv/z+Bc/eL8E1tMFYWH+uWA
	elebBCZZWgo77RNRMYmnW9FfDQ4ZfmH1+4YORxKGxTEHnGWHR9XKAg69fky5p9uIQ4px9s+07SDlS
	IdFj/FNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf22h-00000006PgF-1Vkx;
	Tue, 27 Feb 2024 18:19:03 +0000
Date: Tue, 27 Feb 2024 10:19:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: online repair of realtime summaries
Message-ID: <Zd4nl-Qx2gQWTRYe@infradead.org>
References: <170900012647.938812.317435406248625314.stgit@frogsfrogsfrogs>
 <170900012703.938812.1913285500482827975.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900012703.938812.1913285500482827975.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
