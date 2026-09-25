Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D619B33F599;
	Fri, 25 Sep 2026 05:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314917; cv=none; b=AxYku3Qq+IGYjJ/FmeuQbBg/czN1HDmV1DmFBIQgyIkzsuzzP15hKqYwmMigBa0lF35yRiE4v18GkRg9J2gyD+302pwlDUMFextg27YKA/Y3yx0N3RgDLEDdPsW2p615nWc/atSecs44eMgrfRAPdNmUQ9lR7n6x2S4/MnMDL0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314917; c=relaxed/simple;
	bh=jW4JSKHyXE9Q69rzZcjc0gQqZDVxTxRdrVf2QYtC/fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpwYBCTg4N9wk7bF0Joezg5fu7BSS7iwD8RZM/vmezesINyp0qU0xK+zELfun+ePdlfGnVEYpYgsQlQz6kIAn0azRocMJwNTiTb9wP2SD2KZsYA16g/SFg2V2D4lviYS2RRFCSOvK2ue+4KkjWGDiiJ9d1HKKOscg8wcoScKh1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mtLd9lBH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mtLd9lBH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zciBQ9LMhCc8XnbA8H0jO8Y2JXaXDyEryDgskbWo8f8=; b=mtLd9lBHdps7AmXTHyAU/2emr4
	KlQHhWsUX7+2TOXF16v59BEAk9xMkFzBU//MS2pxhhq1eYTrj+VBY+33zQ4YxAk/WHjgHzmIfaeyA
	nRZuT4kRd6aCD0ibli7jQH1nAmi5RkFTh4o7BKJ+ayfg8jAH4ggvRo3kgBWPI/w3Qxoxum6yVC/ta
	UAjXFEmuKDBHDjuq+P1wIXeEkvugQSjNP4m1UoGXJdLyl+Eem8Uht7nr/EoZbVJ/4HfQxkKDWcbZD
	sqebnOKnwgRSnwYEwLrMenT0ETjh+11ix7hiD1FrrYqN1CS2rp3nV4q5IczjD52lk4wzmYdzkTAKx
	7oRovMEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yh0-0000000Ci4A-3nmB;
	Fri, 25 Sep 2026 05:41:54 +0000
Date: Thu, 24 Sep 2026 22:41:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 09/12] xfs: break out of zoned reservation loop if
 signals are pending
Message-ID: <arYJouxwjLL4O2GY@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932240.3344850.15431918414180548991.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932240.3344850.15431918414180548991.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 24, 2026 at 09:12:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I noticed that if you run generic/476 for long enough on a zoned
> filesystem that it runs out of space in the zoned section, fsstress gets
> stuck in this loop trying to reserve space, failing, and kicking off the
> gc.

I guess this is not directly fixed here, right?

> The garbage collector in turn is continuously running (so we don't
> break out of the loop) but the process is no longer responsive to
> signals and can't be killed.
> 
> Fix this by backing out to userspace for any pending signal.  This
> should be safe because space reservation is usually the first step in
> any modification to a zoned file.
> 
> Cc: <hch@lst.de>
> Cc: <stable@vger.kernel.org> # v6.15
> Fixes: 0bb2193056b596 ("xfs: add support for zoned space reservations")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_zone_space_resv.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> index 7aa3c74fb2e01a..8edc82025abbd5 100644
> --- a/fs/xfs/xfs_zone_space_resv.c
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -157,6 +157,11 @@ xfs_zoned_reserve_available(
>  		if (error != -ENOSPC)
>  			break;
>  
> +		if (signal_pending(current)) {
> +			error = -ERESTARTSYS;
> +			break;
> +		}

I don't think normal fs read/write semantics allow for -ERESTARTSYS
on arbitrary signals.  So this should probably be limited to
fatal_signal_pending().

