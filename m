Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196FD548EB
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414326; cv=none; b=AkTLsyA/lBbcbcrwQXQA5vWEfjlXDa85dDD0xEqaaDc4ueiUsh6qdKWSkw4xolkxgejTpL0fmemotLcgJDJ86Rd84Ko3nC+78IeD7uUt2KO+XMSPvyPPvouT3ilOwojuuZlznncHLmC1w27/4X2sACSyFc52l3tWT5m/h4aZy+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414326; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SF+ZAwQIZtuDw+CxxHgLR5clnzlBiHeWokoaQQcGtfddKVa4atg3MIobmjqY0Xtod+HhSJO9EQ7p6ltbIEQoHGy3uuzD+8FnwnpGQ/wyDmmNEJr/EN0LWWr1t2dP30AtcCUQbdgwwVI+yqXP9OzIxN3mSAhbsP3jgxLahAZmE4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dPFCd+Rc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dPFCd+Rc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dPFCd+RcOoyt3C3PTD9nbIeGMR
	Gew+zkj/Gejd2EOFhHoqAt5q4/TA+JIiW0+UI0HzCP/EzhSa+CXA0zsQGZBlhGcfURCYZugG8xPdR
	VZmqNQ8D/FU1s5VM0VUmAlFWf4SJIxnqy9Svy/uErh+IKp/pdv1UYAKLTfy0hQQfHO0rGZU8a/QpW
	OAjKq0flJ10lB/TeQ8Q10GJu1FgIRjl69Ty7UMuJXPLtpzGCiAV6oWECOg1VPFH5zvsCElaMidkUq
	d7jqfX32zOIuJyMjj4Wi7ZibIfojwVD2brzarGi92NnHN6pttyF3G3/dY5+UUYu+Mk2OqG8oYe0it
	y3x6zFgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJKt-00000000tTy-3Vyj;
	Thu, 18 Apr 2024 04:25:23 +0000
Date: Wed, 17 Apr 2024 21:25:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/4] xfs: invalidate dentries for a file before moving it
 to the orphanage
Message-ID: <ZiCgs3EM8SbVdI5M@infradead.org>
References: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
 <171339556030.2000000.7320068975384720564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171339556030.2000000.7320068975384720564.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
