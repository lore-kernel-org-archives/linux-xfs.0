Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296B719CD1D;
	Wed,  7 Jan 2026 06:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767765667; cv=none; b=NXNQZnOQlb+UMg854oQqpEKwpWeD+MzF7z4XleUDinKlK5pUiQHKvVrF3bqioZ7SnyJbMjGtEJPH/aGxIfYWd1/lbpbZiC/Y5Iu8c1SNSjlhi/P81dEfsOZdA1CU8jIGx//HHbn0pWPlYlCFBh8ADRGFlwIFfG31Q97Rz0jemnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767765667; c=relaxed/simple;
	bh=iNpHSrqM/YKGUxmGPvsJTfoCyukWxzgImYsjJ1yX85s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwkquqVGV96BHNAiOyM8aYMCtWI7rdBz0jbxd+Yb2tRyWwzIZ1rqs58cEl9Wv/0/+A/+rol4J3Bp+MKJMSIPj4ZLy8C4T2UHmsZujRdue/eY5QhAFP8hYE3FoQQOW8d9mADCRAamBkLSXq9mIXcB34UO8P7zaw2QDi1K8MS5Sm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TpLo7KN4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TpLo7KN4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HX+RWCYcvyaGxDKA7PAvcLWAk3L5YhLDhSqHG6WWoBI=; b=TpLo7KN4Frey8UY+NrKMURiJ4C
	F/FMXh/Z7EBYQapcK44342v/P0WmiXhDPhtnfldSOo2Ili5mtiCe5QXhZZYtcs6n81ZA746pTJuTq
	jjm5yRE9heX99LKaK2t30JbClNKJ4EViv60ezp2b/v7C5RlM4hNJEV/0JNHLVPjUH4hky05Ndz7+9
	6GMNOlnCkCBwYAa5TCqYV6K0YxAQteWPQRlBiq8gss2DbzdavdKXUrx7Y+jF7v9a4qzA/u45CiR4C
	Z30Bmk6yj5S/pujjvrB1yxNGyB51pCEzacNIVnd66/RW0c6uEpZkRkRbXubp4CmmgH7ts2PEQ/ANJ
	C6ycFX3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdMbN-0000000EC84-17nD;
	Wed, 07 Jan 2026 06:01:01 +0000
Date: Tue, 6 Jan 2026 22:01:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mark Tinguely <mark.tinguely@oracle.com>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix NULL ptr in xfs_attr_leaf_get
Message-ID: <aV32nTIWTacVXqIw@infradead.org>
References: <20251230190029.32684-1-mark.tinguely@oracle.com>
 <17cd5bef-e787-4dc9-9536-112d1e2cda2d@oracle.com>
 <aVzDNYiygzgjMAkA@infradead.org>
 <20260106154026.GA191501@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106154026.GA191501@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 06, 2026 at 07:40:26AM -0800, Darrick J. Wong wrote:
> > > Fixes v5.8-rc4-95-g07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> > > No reproducer.
> > 
> > Eww, what a mess.  I think we're better off to always leave releasing
> > bp to the caller.  Something like the patch below.  Only compile tested
> > for now, but I'll kick off an xfstests run.
> > 
> > Or maybe we might just kill off xfs_attr_leaf_hasname entirely and open
> > code it in the three callers, which might end up being more readable?
> 
> ...unless this is yet another case of the block layer returning ENODATA,
> which is then mistaken for returning ENOATTR-but-here's-your-buffer by
> the xfs_attr code?

Not really and unless.  This patch (and the full removal that I've
prepared in the meantime) still fix the missing buffer release in that
case and make the code easier to follow.  But yes, they would not fix
the underlying issue, which is why I still think we should not blindly
propagate block layer errors into b_error.

