Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECD5483823;
	Mon,  5 Oct 2026 13:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206031; cv=none; b=rHnqCM5HGKVXaCS58HVrOUWwala+r2bKrWvsCxQdohReb7LfdXQ97bpwTFtI/igGSFen0cXPb47FOi2PuAWDocfjysHJ6bqreyHazp2IivG1CXFpjzFFODluOc40E6Io+SBKwVTCgym+t4/f/dV2dCBij9kTZBmyGzaA0+tMctE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206031; c=relaxed/simple;
	bh=kg+WwfYbSHCZRl9A1thufr8IFjc/PnFvVCAHQoJnNnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RoRE/Mnag1Gfj0SgOB4paSUiwLGk086FrLRWpZOwGzGLOt0hvthM+4ixXxGBYBQ7UJTC/AkV7LosiodM6dLzYTB6DM69jsvk/imPaFnhZnFxm71YPhLI3eHU8d2+i1VPjnQoyOfO0HSaA0AZAPOlEtw7lXyVD3XhQxTmEzsKKRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66D8268AFE; Mon,  5 Oct 2026 15:13:46 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:13:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 17/21] xfs: verify data checksums during media
 verification
Message-ID: <20261005131346.GE26805@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-18-hch@lst.de> <20260929011936.GY2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929011936.GY2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:19:36PM -0700, Darrick J. Wong wrote:
> > +xfs_submit_verify_bio_csum(
> 
> What's the return value convention here?  1 for media error, 0 for
> success, or negative errno if we failed to issue the read?

Yeah:

/* returns 0 for success, 1 for media error, or -errno for other errors */


> > +	bno = xfs_daddr_to_rtb(mp, *daddr);
> > +	end = xfs_daddr_to_rtb(mp, *daddr + *bbcount);
> 
> It occurs to me that xfs_daddr_to_rtb rounds its argument down.  So if
> you pass in daddr==0 and bbcount==2, you'll get bno==end==0 and do no
> verification.  I would hope that callers won't pass in parameters like
> that, but who knows?
> 
> So I think this should be:
> 
> 	end = xfs_daddr_to_rtb(mp,
> 			*daddr + *bbcount + XFS_FSB_TO_BB(mp, 1) - 1);
> 
> Which I admit is a bit gross.

Not too horrible.  We should also check for a 0 len after rounding in
case nothing is left.

