Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5AE1C5D72;
	Tue, 22 Sep 2026 05:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054403; cv=none; b=Dgamxyc4+l3CItQg9Cj8yGcvZ2UbV3gE3VybPO4CQS+iCq1ozOAb6zFGACGCFyYVFf//xhmVBQz5YMSZWP+YxBHIaTRV5y1FmWgqE1fhevSsrAT8XhdKspOFfqo3yOILkRK2YVSWSLwr2q3kw1bLTHICE4PrdY8xvirFxn+5pn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054403; c=relaxed/simple;
	bh=fgIcSbaPrAuFnTyWxqLlTepnLdY0dSLaaTpICfDGmDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVXrw8d0Y0U5Isv8n8JwUkYrIJ26I6dd/6lBfRIAQmkRDzx1zFiSYezgIHeOj6gfviDp13hshqFxwQevwm1LP4v1noXdfrjWWUKj/BSCVMD9ufXFSmDL6HMPFpodR5VbZvSotLBNi49n7dj1nCGLBslIUHfH0oZmc+V+3aqg854=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TWFmv4ZN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TWFmv4ZN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C+bC4FigBuL8+5nnYI69zDC0i37fdC+WpiYtFHJK32Q=; b=TWFmv4ZNktdizH/N0pm4SSA4XH
	zq+QkgiponDASPCpGVzfEdg6KXAl1ssJStYQOcikMYCqY4sWGOUut1eO4/PRDKn5te2QVX+NejF3D
	wXUErW+wnv+7PoZuxDb36fl5rzBwOJ4mg0aEK14JTs7EPUHgbov/RiLK5n8ostsDYjEBXaokLHDcQ
	O3NMJmdyTTpTHjsqrUuGFhWUXIJL0gxebKvGHzKMG+/V9hCczLC0ST+eDKHNsjeqqUSUkp/ArC3Fj
	NG3To19TrmCfkwhpVV1rHijmWoM8kSxbaLJYMpCUO8LT2+0gxjaMZCdEFIxagMi/x6V21+hXSsHrv
	g4xg57VA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8svB-00000004EkD-0hD5;
	Tue, 22 Sep 2026 05:20:01 +0000
Date: Mon, 21 Sep 2026 22:20:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/14] xfs: fix xfs_rename_space_res for non-pptr
 filesystems
Message-ID: <arIQAfUjbdiWmx6P@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120679.181988.11124162026436295653.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120679.181988.11124162026436295653.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:16:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We don't need to reserve space for a parent pointer update for an
> existing target if parent pointers are disabled.  Fix this regression
> (which LOLLM noticed) so that rename reservations go back to what they
> were before parent pointers.
> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: 5a8338c88284df ("xfs: Add parent pointers to rename")

This just relaxed a reservation.  I don't think this is a stable/7.3
candidate and probably should not have a fixes tag that causes folks
to backport it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
