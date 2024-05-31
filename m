Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274F854784
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717171987; cv=none; b=ZVII7m3MiNYZtPmM3DbMqvAPg5TKIwSZXcX509s09v2q+5bbGz8aNCInL55PdfzmNxmdULpJ+fYhBoPDP49jFB0y+fH3ALxL7le0AU8JbEi+fF0svTIZZARutB+s1C+KOqpkKnx1uiDcIyOJAMnnYGxaaRbflVwRVF2MEhZwmHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717171987; c=relaxed/simple;
	bh=CAbPHhnZtE+Wo9IZxCGEZ2V/lXM/PiuFVofSBnf6TnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oa4zz74lomxUUHNgf8REcHBtPe693ma8zGgcEsKkScSCT3BsdA4YxYXNqx6hMKpY8tZJde+2S7CPrNiDgCee60pi4KL3vJhJLTWNup5na7ulPHihOaR9tfUNfNMHIe6ZijGiziYROUaGxjCtR/5k4nbppRga/85wkkiBdWmAzHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tpji2Tw3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tpji2Tw3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OAYmH11VSqzV9bmAKYzNaYDnuBIp7ggpmHDb7w1hTtA=; b=tpji2Tw3Hq9OB9QbNaIqJ0+qSv
	mPa9XjOATcBD1qzgfuyHJ2IGFJ6lKrXiTeixLfHl/YTGqq9AtYRl4I9m6sUC5HFN7Z4iZ4v1gLuVy
	lQHuABedulJj9wMQ46Ttou5B0pXqz6EA5Z0gsK/9dZJMJIp/lzdVnSevwU1KvslVIUCio/pUCLPDZ
	JdhtzzDZVttokb1RuRANKWHEwlMaedWQKRs+8vSr9czUdXryXGUHxghhU1rFGneIPNcc5ptc2ov9W
	zDb5lhLvoIVwhz1yDute8KmOuvrX2Ybh40E9ZDWKwEPy5OEdjaV/fsF2PuP7tIA7d81Pv74jnPf27
	SbA2EzLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sD4sL-0000000AmZN-0eoX;
	Fri, 31 May 2024 16:13:05 +0000
Date: Fri, 31 May 2024 09:13:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Wengang Wang <wen.gang.wang@oracle.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Message-ID: <Zln3EZgz7fVnJoAU@infradead.org>
References: <20240517212621.9394-1-wen.gang.wang@oracle.com>
 <20240520180848.GI25518@frogsfrogsfrogs>
 <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>
 <20240531160053.GQ52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531160053.GQ52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 31, 2024 at 09:00:53AM -0700, Darrick J. Wong wrote:
> > Yes, The main purpose is for the later (avoid preallocating beyond).
> 
> But the user set an extent size hint, so presumably they want us to (try
> to) obey that even for unshare operations, right?
> 
> > The patch also makes unshare use delayed allocation for bigger extent.
> 
> If there's a good reason for not trying, can we avoid the iflag by
> detecting IOMAP_UNSHARE in the @flags parameter to
> xfs_buffered_write_iomap_begin and thereby use delalloc if there isn't
> an extent size hint set?

.. or (even if this is scope creep) just make delalloc work for
extent size hints.  Now that we create all extents as unwritten there
is no fundamental reason for that to be dangerous, it'll just need
a little more work.

> (IOWs I don't really like that an upper layer of the fs sets a flag for
> a lower layer to catch based on the context of whatever operation it's
> doing, and in the meantime another thread could observe that state and
> make different decisions.)

Yes, that's pretty much a no-go.

