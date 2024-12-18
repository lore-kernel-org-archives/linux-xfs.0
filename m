Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299FC1514F6
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 06:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504852; cv=none; b=Wb2uRyQD1ufP7kGzKWwDeCWXDwjyDER0PDvPbOo2Q3yo3rjZ2xpX2T/vbAKAoxs+NkqruB1huZqNsAdzvE6gxSInjsYLtuSGubLb2FGnTuSRi+idrWaH+BnF+LrQaX9byJ2wMjC9m98YYoHjshhDq2Dm8gUlZsS5ZdsN4/UngAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504852; c=relaxed/simple;
	bh=aiG/2GwwscRU7+oLC30nVG3YUKQIoPrmD+MMYVe/GGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQXl8rBmO+51GeCkLHfrWI3rvvF3x2VnOhNVMlJE3xyfv+ho1xVk/kwNXISv4xExtgyeXVVCJHr/ZZRjfcinnVdM/x5vpkEBZtItMJ7QqXA1CiNxorzQXxPYG3HR/lTsWxOgsOrfM9HZPkQpvTyuOdzxOd9lUyNLTGFtCgsjn74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HMnh64W4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HMnh64W4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aiG/2GwwscRU7+oLC30nVG3YUKQIoPrmD+MMYVe/GGM=; b=HMnh64W4KkKyg6pLVTmukZf73Y
	r2OL2pRTmYHjX0qbGwVVg9TZDxDPMOhZa6gQf3QVEHdGxp2q/jaitjz27ClS0dWFMH7veq2aoAOQt
	+AT1ux1wSCaiV8pj+gerVsgqVb3BIWFEVx4rMOL+fER2JIyGz5b8Rc5LS0PbMkblRHUQ87gogcgtq
	5TLpWnAJ3J3hSsNW+m38KBhyix9JDRXxfTqCkU1Sg4EyNnNnZqZ0iaLz5USlTFdOrUS7cr7D/1H1Q
	ZlcOGO6epbOiOSw1M+/WL9bjprSQ1Hl6tAnZ8z6enkCqQOHkH2ZgCeLnOfsd4vaeA/j4VBbfjxfLq
	rdXSjw+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNnwe-0000000FlZX-2BeT;
	Wed, 18 Dec 2024 06:54:08 +0000
Date: Tue, 17 Dec 2024 22:54:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>,
	Emmanuel Florac <eflorac@intellique.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't over-report free space or inodes in statvfs
Message-ID: <Z2JxkBd9eyBSc7Qq@infradead.org>
References: <20241217174446.GN6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217174446.GN6174@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

We should probably wire up the reproducer to xfstests as well.

