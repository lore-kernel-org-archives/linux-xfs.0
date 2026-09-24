Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE232937A;
	Thu, 24 Sep 2026 05:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229431; cv=none; b=q/HEA6ITdzIwMn0sQdbbUKXRlERV6A1umakrMdldfr0kemKMRWSigtENVIdNQeOUNf7TA6L2o6X3S3BdPYtVaWktB2WPtXSREIn8QIkgsfOInAYXangGUtwNuWrYEqAB3El50RZsvrjbokHMeEvW3eBvZxIssXppBE2Jib4ClJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229431; c=relaxed/simple;
	bh=G8czFsptjPoD6SpQdbsHPcCLNtwVCZmvpLf8IdCR+Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIdXuV699Xa7vxk/qP/1MUX0RXun5he9NqVm5D/9/KVyqEwLhxNfA8iokpTcbfD+NHDxle8zCBj0+PN4Yefo8JED2BoouiBkA6x8cnRdgaaxSWIphOFMLObvqjY0V8iwVELDFqc1E2C41+lADsqzHk9CfGgaksSImNOOQ+tJ+aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SC05FQmi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SC05FQmi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=msHVE3NTGcvZGUN04+af803abnSrp8Y4D5b3gniRnOg=; b=SC05FQmiQX9MSl2Nd/kGlWvn76
	PiWRmRws5b0flOASRx1T9cZNGFYP96BfjgLe6d4ElNOgrtWBoT5y46pByBK1hDc6lp+BsZJe40yMt
	h/eQBeVVPIF4r/uWTtQaBkgAh4lHZOQjR6RM3BnubpaFtvcaPHDH2zm+9LzF9usYtgXjF+bNBFTbw
	idBq4WczkrfzWTz/2+HA3HEnUfDtpsAlxUIcAywwc7o0VurQVFM+oTUQuvgSAe7rRS+1MzvZ21AzF
	6Mm0GpSdLXX/VecVBXa9MRwvi/wKicHkMJ57nUVKi+fp3yVyekFWA9m4lPV3h9KXqkcJMaSP+5GwF
	H/QxiQ8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cSD-0000000A65W-34UA;
	Thu, 24 Sep 2026 05:57:09 +0000
Date: Wed, 23 Sep 2026 22:57:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: avoid cross-rtgroup reaping after a repair
Message-ID: <arS7tTCQGhyHjoou@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159798.1875436.7915121855965899039.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159798.1875436.7915121855965899039.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 11:03:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that the extents stored in a xrtb_bitmap (aka xfs_rtblock
> bitmap) can span multiple rtgroups due to two circumstances.  The first
> is that the size of an rtgroup is an exact power of two, which means
> that rtgroups are adjacent in the segmented xfs_rtblock_t address space.
> This is fairly common to reduce the amount of multiplication and
> division needed to handle space on the rt volume.
> 
> The second is that (unlike in the original rtgroups design), rtgroups do
> not have fixed-location metadata like AGs do, which means that there's
> nothing to force a break between rtgroups.
> 
> Therefore, we must loop through the rtgroups in xreap_rtmeta_extent to
> avoid running off the end of an rtgroup while reaping.

This fix looks good.

Sashiko complains this could use some additional input sanitization,
though.

