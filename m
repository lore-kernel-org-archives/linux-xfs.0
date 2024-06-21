Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8455F12D1E0;
	Fri, 21 Jun 2024 04:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944549; cv=none; b=jFXyhbEMfQqHgxptSMTMNSWQgGS+GUnstCW2dtS61izJOF5eMPW1VrNWebhJxwcH3AdM0weDCzhLsBhk1RyauuoJ+dedBHrhhDyr/GL4xFUJfg/JfRPRsI5raFmVC5LovHQ9AsHGfE1gFIYHMEUlCHd+pWsV8RK7WKMFc9JjHu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944549; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bY36aPStABNrDLFpP67InLd5b2oeVkc/EaCxDhX/y9dMYdcgHJOYHx1pB700e7+fn/0vHxnHeyJgmAsGRuAvpkkZs7s++w3HvtgbdiE5+NEz+v7J2duyKfzk1sRZxIe1O4AgltziVvBOjdBndUwEL7g/RgwOsdDj1A1QXm/4xM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bv9MPry4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bv9MPry4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Bv9MPry4eRKZCTGwh2+UTyFhpv
	jpmRIY9BHgYai2HMjSGk7iXiGlUirS3VrBMfTBRFKoC/Oo585NgORcj0TNigKdmfHJ8DdabMKrz+U
	2FQMFmO9HDLN+gowj5LJbrAe8SLQafozDjKsHLlVC8F2ZpSAXgCKX4JYybLMV+JgPTYuDOkGhBfcb
	GZsnWV26reh1FYzVfjXllgfwTTtaT6wrnS41/g++SzlezT4OcFqHxwjlzSj8rdomCtZPZoNrK5Xq+
	f2DAq0z6wIF52X8mkovcvBwLVzyQ3RFW7PeGWbU/1eMFRvSUvW6c2voOdfsfYNn3guWJdkEkBTXwG
	P/70Ng3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW03-00000007eoZ-2zEm;
	Fri, 21 Jun 2024 04:35:47 +0000
Date: Thu, 20 Jun 2024 21:35:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] generic/711,xfs/537: actually fork these tests for
 exchange-range
Message-ID: <ZnUDI1zXOBtXNOiq@infradead.org>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
 <171891669174.3034840.5584811354339983628.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171891669174.3034840.5584811354339983628.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

