Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A5C53AC
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414407; cv=none; b=TSEXa+EA4b3op0OU7u0oxdoEOF6+XjLg0f5yYeo9nF3Xboz7cLrlTnzBj2rUK1tim91DIpWBmiRIoR25hsYutqDmOugGYrsWcu0EMigqCE2rNN7pU4T+im6uXo0HN5gh9hC2qshBO0c38OT8I5J/EhOjXSX/ekYfRjQyLNbmMFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414407; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqqWGGQtShKewvFXqti8waiArF1SM3F463vmrDjYULq7DpbUBK4KRYsTsqg3QsKzGAsMCgQdYfhk1q5uXF5jHy5tYbxlk5w9moBpJ/EX/MX5KukjVifoW4IpPsOSuQC1g/JkFDYly1t9Tt4d7fJJdZbZLH52qjy8WtNCVTPPjig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Esgta4i0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Esgta4i0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Esgta4i0fE0LstxTh2yaHJyA1b
	eCoVz8wdCKDdPy1FW+t/2UMtdLRgbsif9SN0pIoy6ZCUsdsVL5UTM21HvG1O095WuWXEV3cSqgPMJ
	KaDDefWqBPnIZzyZMXVRPvArY0Fw28XLYZlL+5wQl32jydudizRCHzsIZTedWPlHC7gIh8JqmLgCq
	9RFIG6tlKQS5Jq6SwyRDRfl52gT06YLgYvozYjeKaOA6x0m9zrvl6j8c0oLhfZPypUYiHUfU2iIg9
	8q5xR8KtMryPt5q1n1+echntJSsvAntUL/4+fh6j/OiZBaslgk1aDir7WjUEcHD1Umkz0yJ7HAVcv
	aoY+G/ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJME-00000000tiP-0azi;
	Thu, 18 Apr 2024 04:26:46 +0000
Date: Wed, 17 Apr 2024 21:26:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org, Bill O'Donnell <bodonnel@redhat.com>
Subject: Re: [PATCH v4 3/4] xfs_scrub: don't call phase_end if phase_rusage
 was not initialized
Message-ID: <ZiChBpl7-MEhnNbf@infradead.org>
References: <20240417161646.963612-1-aalbersh@redhat.com>
 <20240417161646.963612-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417161646.963612-4-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

