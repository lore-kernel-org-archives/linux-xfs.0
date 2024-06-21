Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FD4EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945505; cv=none; b=IxPIyRMZpEte+ky6UoyV+IyT+wOmaqpEgo2v87BmxYz1CjKl05J5scorbXtLJvvlsPPnVlRwes/lc5LI5oP2w2eDkxMt4ubPktrv6f6+F8LTla7JB7AHkLLFck33+Q54Jfb/J1L2Xd//iHrBKwlKXmOVz0KS8FCyqCluTNoPvK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945505; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGKlEhbn1Jd0x3xqDqOb1TvBLWCY6hR596tPaP1r1EhAdjcEEoa7HE7Iu6ORVlG/9Bt6BZ2vVx/oXMC4nult1ou6wLTFXZ8BFokLj5VyS9HA/6qNKxuYwM2HvK5HLN3vtR9B0gJFkoQRcweVCik/saJ51jXdSfTGeffnbauVvmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bYUOi86U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bYUOi86U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bYUOi86U+gyEpbFIdGlFCwkzDw
	FrOGdiqIFvAbd7gPrbNuFZp36EsO5vKo4MMJODwA1FoAlE2B/G90v3el0uCG9Sdodd0jzB4lrnZH/
	r7B9Dr3e+kQTcQrXt125/xe6kBYeS0WmUO9QrTBoG+Eb3RrMsigqIvh1m0+9ZmVV7K8HoLspUYy81
	zj5t10DQVjDmvsjvmBITREI527M1Aq+pqvae4irqsYAKB6lPh/BqcBYghD2/9RwADwb5L+7li+OaN
	ZIafza4lh4OWOsFzodLUEEKtiJJYgMaw57GePHezl5UQlGTTYvQ2iqnv2biJpowHIm1VzW8Lwzcxk
	QIM/+sqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWFU-00000007gnP-00YY;
	Fri, 21 Jun 2024 04:51:44 +0000
Date: Thu, 20 Jun 2024 21:51:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: create specialized classes for refcount
 tracepoints
Message-ID: <ZnUG3_7HaOMrcStl@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419806.3184748.4482333777418540364.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419806.3184748.4482333777418540364.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

