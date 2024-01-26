Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB95D1B940;
	Fri, 26 Jan 2024 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276045; cv=none; b=i6dAxRXJj+k16xFBOFILFbd075FIouTXrFjHk/4YpWWXzzFo0IFK//jEq64SnFLtWR9EwSpbmEnn/XoJS9VzsCt+Y7VOulhQPReq3wc7dxZFj2p/IRsX9Ot5FTXHjKatEueKg4Uv2JkhNQmP2l90qW+5LDledN++k8YWRw32YLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276045; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwLyo28NSnJlqsOnmXX2Gf3/tCcj1KS6pxX/edVKdCnS+CUfoiXBBJnXIkWT6uC8wiphKEe5jwZyYWSc5C1WCvP3yqOzjKMlCDRxpR1kKEiaGJ329NL+/Qc6tG7QG/Cw91haQ0KijaHsRUbVC3wCnEhZdAQhm3jkdyMqO4lgLww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ybGWX+Dd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ybGWX+Dd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ybGWX+DdvVyc6CU4jlFCJbzPmz
	KXE6On4mOhSCr+PVfA7x4x/TmQbnj5ywS39IZJcl4C2yLaSwxOXxKrC7HNcgu5/Ya/rn1DnFsF6yl
	GAgR150f7ytFq0YFL/vY8uFDvMcKVikFHGzppuggx+2UxXWsas13erCWeYEsqHB9V8qSpV5tdqUbJ
	i616ID9fD1C+uHpwyjlH3wwWvx31RJaX/DBQaMy0K119aadh9ZtOk1tuKE1Uam+fKUIIrS/GSmKbT
	W5URxcyHYdV7VwywzlDERv7AvoyMgA+5mJ5kC2jJeetoTflGkQ4OOfWd2fXfjOW3j7U1l2TNY0pM3
	Wvu8Lqug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMLM-00000004Ddg-1mFg;
	Fri, 26 Jan 2024 13:34:04 +0000
Date: Fri, 26 Jan 2024 05:34:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 05/10] common: refactor metadump v1 and v2 tests
Message-ID: <ZbO0zP75lNF_N_zV@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924435.3283496.2022458241568622607.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924435.3283496.2022458241568622607.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
