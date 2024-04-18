Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5E13BB47
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414079; cv=none; b=GEm96o8URuYCOmSSf0HJ9G4FCEl9Vh+6mMipn7E25llDPGbUFQYxxtq1qg4JSheqdfqPRGO3ApnSCvNaVSehsBXEWRVw6pRf68Zp1dei6gx34QYbujrojv+Zck49ag4zX9EyYy9qT8yPrZP7CAVlanR++0mN6f184KwcRo6gn64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414079; c=relaxed/simple;
	bh=O3fLud0TJknlRsoXSgLgvSFD6uet0rquXSUueDIASaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzbWyOsVKVEQvawIR7jhyya+XIR6p6VIEVtm3Qf1ueEv+k4cv8qST4XngVGzSlzrtznPqT2zSAC7f3Ww+pJSUorm6J4J/ALMRAS7fPdweHhpDbIGcUGgN2ALKASK19a3YwN9sLGzHRw2Jlksckxx83a9YyOLTCt4BuTrhxf2mVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2rt/pkWv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2rt/pkWv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vlzmRpvb+zuvYSMJFDl5aDomyFmfvHsx1KjXouBQ6xM=; b=2rt/pkWvNx2UrfTzEMMq8XdRK/
	YEHsWU1uUwGMkoDOpcr3ZjEpKaSFxEQ6AbNMw9ZimOGw11CxL2PnjxsQkFkKEjTxCQ0rt5Pd/Lznp
	jh6IkNLYyQZHLaWc3DhA0oHj+1DRAB0D5g/w5+VidvtnwGQyCuH3YKujBRxRgQA8nwLWe0Vb5KcyS
	6gV1suyIVd7mAd5Fzfh1wo1wNXB7c4AVQyx4K7/zUslfgK7PopUscAzn/ExvagcIziAwYDf7Fy7oe
	s3lI9Mh/YLJCjOYLfGiJHPWnE3nrqdB9w4YodSszqBtYOK1FSb1AJn2QWCcGqPqkClrGG1CAdEEiV
	O9MjxzxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJGt-00000000t3b-41y6;
	Thu, 18 Apr 2024 04:21:15 +0000
Date: Wed, 17 Apr 2024 21:21:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
	hch@infradead.org, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com
Subject: Re: [PATCH v13.2.1 26/31] xfs: add parent pointer ioctls
Message-ID: <ZiCfu8Et9Fnmoy8T@infradead.org>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs>
 <20240417024955.GL11948@frogsfrogsfrogs>
 <20240417222503.GC11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417222503.GC11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 17, 2024 at 03:25:03PM -0700, Darrick J. Wong wrote:
> > +	/* parent pointer ioctls */
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	32);
> 
> It turns out that the i386 (or probably just 32-bit) build robots trip
> over this statement, probably because of the implied padding after the
> gpr_name[] flexarray.  I'll change this to:
> 
> 	XFS_CHECK_OFFSET(struct xfs_getparents_rec, gpr_name,	26);
> 
> and let's see what they say.  armhf checks out locally.

Please make the padding explicit and keep the
XFS_CHECK_STRUCT_SIZE, otherwise the ioctl won't work for 32-bit
i386 binaries on an x86_64 kernel.

