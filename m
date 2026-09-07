Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A337382287
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 06:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788761088; cv=none; b=EBDIy5RIdNgKgbhD3vXVP5K1+fgT6qdPy1H+nsoQz3eQcSgEiCDQA5qeMZoBmJZOZdaHUbPQ4CwCw0hBY5LoYwsWs1wWIG8bgcFMOCW7YWvWZA66Og7F2kYkysVoAlDbNIiHqBrE9OYp7kIg7LzT0P6cRxKGBUJyN+3bw7cMVrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788761088; c=relaxed/simple;
	bh=l0tOpqLjZnCypssGzoZyOaJ5+yLid1n9H/Rq25LPJB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVZxquZRfsFt+tWqW0gGgPPVUtdT7AS3Oiaq/QSjifyOAGRmhWTcJUDT/ZE7FGzmVFRv7qmk7c9ScuU7ZKPjMpQuKbvaBZFtNIWXmKGN8R+1GxWL1gLpWRfh3WEgMFeN0Owl36mpYpGMX4ysQSNF0sEszDj+RtgJIshJdHlYahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4eB1xS9n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4eB1xS9n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fF+zvPRuXTs08URWISMa4CLBOXavJkoqsRyyvldddSg=; b=4eB1xS9n0/bKUa/g2MBgkZYjjq
	PIxhxxRTR1gaocVi4Y/gn/3hppG26Eks5bn6xRjOgLiSziDw5GFR3UXS+c7l1vz2IRLcN1uHdyeJL
	iTqO0zhQziN+eP19uTg2GX1xGEUUpcfDkobNarkF8OKFNlaDQhhRwgqMTo4GyAMp96nDXw61gmNWR
	vPPNIy9f31gQkL0K5BAiyI0mBSATx9vkwzKri5ThXmuq+Yb0zTkNlHVy5OOtIVGWfN4EjSxO0pMRb
	LGEucP0HEFUkkxzI9D9BE5oAW79gSXCm1paSqH2dLNHwTsRSSwxBY+wKdF7bmc1Ip0weUQrYFJMGf
	fmSRhg3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3STE-00000005zHR-2B5p;
	Mon, 07 Sep 2026 06:04:44 +0000
Date: Sun, 6 Sep 2026 23:04:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] xfs: add xfs_error_report the ability to display
 an error code
Message-ID: <ap5T_Pcvk4QAMcWb@infradead.org>
References: <20260904113231.1408890-1-cem@kernel.org>
 <20260904113231.1408890-2-cem@kernel.org>
 <20260905010851.GE1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905010851.GE1933798@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 04, 2026 at 06:08:51PM -0700, Darrick J. Wong wrote:
> > @@ -387,6 +388,10 @@ xfs_error_report(
> >  		"Internal error %s at line %d of file %s.  Caller %pS",
> >  			    tag, linenum, filename, failaddr);
> >  
> > +		if (error)
> > +			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> > +				      "Error Code: %d", error);
> 
> /me wonders, should the error erport just go in the "Internal error..."
> message above?
> 
> "Internal error $tag ($error) at line..."

Yeah, that seems much easier to follow.  Maybe make it conditional on
an error being passed.

> > +extern void xfs_error_report(const char *tag, int level, int error,
> > +			     struct xfs_mount *mp, const char *filename,
> > +			     int linenum, xfs_failaddr_t failaddr);

.. and let's drop the pointless extern here while we touch this.

> > -			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);

Overly long line here now.

