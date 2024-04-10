Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6B61170D
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725647; cv=none; b=OvRHfjYhbNBz1fjhhL1Y+5Q1ODMfnFAt5o/vHAmVIR7UAoSkbsRuKaZJcKiGn8+LbcCdMcr5FDj12pbaI32X+4pg3kR+xk//pf+HTaPDZI3VKlG5L3THrjxGlKcOOpJb83V5qKUgI2VsjlKqwFM/yjgCirVoGaX+1yjMoGixmSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725647; c=relaxed/simple;
	bh=bgJcGPsLtvZz0zqo00oAyA+IEWIxgFSeINhqINZCzI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxR+ZFSq4SruVA9EVdKK0gafX9y8lETHueFE3ymuDa0wv+xVNQPBpyJ6YMmx5NbyGiDYRRmQvbyAKvEqXafl7PF+iSacoHlrzIPqp9pb4boWSsi4bxyc8Q8gojrwFf1MYa124MJQmZ+EE53aAIs5gfvRulXjJXAZyXx6ltmFLTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W1ywlh9P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W1ywlh9P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UkoZqsP/Zutz6/Xd4ZX2fZ8QP2bDNUpVDkT4vftYIlA=; b=W1ywlh9PXsPLV3JQbXO96k3cPX
	Zdku+MUYKcPZYSSzvPbj/469BkSzagpmrrwz0HRFgb+nXu74cS4Cn3So7msVTLw55zSN1gnD2qj2U
	syu/SpT/P9FV9wF0L5Rc5B5f+4yNP8TDXrZq6K6e74okjdbO5jTREoZHLAaU4SH++TfMNvR0pIW2x
	whOs3CLnUsrqfyX60D7oa0J6cXIxccK0pOxjsgu+sKJc5yc5MwzsRA42dWRPCC/ukd2H5c02Pee0u
	zyiAdG1/gcMbnObxlsRNwuZZ7bcPwyzuoNCS6tO3fFtNJw589ZNB+nwXKZs2f5TuKAksN+X4bE8n6
	oBzSbwMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQBC-000000057az-1l7O;
	Wed, 10 Apr 2024 05:07:26 +0000
Date: Tue, 9 Apr 2024 22:07:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: restructure xfs_attr_complete_op a bit
Message-ID: <ZhYejtTWWGVzunCm@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968950.3631545.4788373736144068333.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968950.3631545.4788373736144068333.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:51:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Eliminate the local variable from this function so that we can
> streamline things a bit later when we add the PPTR_REPLACE op code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
