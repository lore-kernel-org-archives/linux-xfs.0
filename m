Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C954339ACC
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 05:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729660118; cv=none; b=KaIutn/VxwmN/RRtaPgoPvaO7B5JMIsfV3s2C4qarf65QFhQL4tOesucHIxF1TMAZrfwBAFZqrgD4EFq57JHFxEMvAFHW3G006ZJchf3q/uQUpkzV3CZ4zBwSHY6oxkVwNjBHzuzvXG3sC8o76JpZBgBppKi1fANBYJtSEXP2nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729660118; c=relaxed/simple;
	bh=f5TEMtxT/StIcEhQjsNEQDAj7TOGftx9NebJkdIiyKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rHXsxWcSpJ6FTw4c0CdQimbqROobFeaGpzKlir3EWK/YZiIuEz4vsUiHP/S4TKIIlLmLpy/99TrBFMOux9BNQPasn05pAuni0e98DTXev0B2VPq10Hy5TLnOoiQ6UOiMc30ZSbzi5ZTskVWv6v59GSq1QLNj5Mxv4Dtj7MpKxMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 31737227A87; Wed, 23 Oct 2024 07:08:34 +0200 (CEST)
Date: Wed, 23 Oct 2024 07:08:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: streamline xfs_filestream_pick_ag
Message-ID: <20241023050833.GB1051@lst.de>
References: <20241022121355.261836-1-hch@lst.de> <20241022121355.261836-2-hch@lst.de> <20241022180535.GF21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022180535.GF21853@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 22, 2024 at 11:05:35AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 22, 2024 at 02:13:37PM +0200, Christoph Hellwig wrote:
> > Directly return the error from xfs_bmap_longest_free_extent instead
> > of breaking from the loop and handling it there, and use a done
> > label to directly jump to the exist when we found a suitable perag
> > structure to reduce the indentation level and pag/max_pag check
> > complexity in the tail of the function.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> So the key change here is that now the function can exit directly from
> the for_each_perag_wrap loop if it finds a suitable perag, and that the
> rest of the function has less indentation?

Yes.

> Ok, sounds good to me though the bugfix probably should've come first.

I needed the refactor to understand the mess in the function :)
But I'll reorder it.

