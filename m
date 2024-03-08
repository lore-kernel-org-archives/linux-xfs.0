Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76C2524A;
	Fri,  8 Mar 2024 15:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709911285; cv=none; b=FVAkwrf6csGiwJDjdtDdV098raf1S7819FyLvSGREyxNYPIQgB43Y/iPfhcNxy3sYdi4GXurnhXwUhPi+F5EWQt7qRmBk6jH9YfDzaWf/diETUofGj9Fd1YY3gyXu/2iclxpy+2quOZaBapXCYLYMlY9n5xLVfmknjCFiTI+pJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709911285; c=relaxed/simple;
	bh=OcvBwmITIvUPchMVRcVtw+oRPmjpPp7/ghqf067yQ8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzVg/y5i0EntkwFbmK8CvMRqcAlGok3reLHcP/S90PSMDzwQxJAQQTeif8PNsa5J2eJofvpINPAOxRtN47pqEYtxriONzCCdFUo+YBk3aIz32ePjmlyGuOsOWVbCpBj5ZByjyL+xm2b8cmxGBBLKaabCrrNFGvukAkFTk/pFXfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4CA3C68BEB; Fri,  8 Mar 2024 16:21:13 +0100 (CET)
Date: Fri, 8 Mar 2024 16:21:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] ext4: switch to using blk_next_discard_bio
 directly
Message-ID: <20240308152112.GA11963@lst.de>
References: <20240307151157.466013-1-hch@lst.de> <20240307151157.466013-7-hch@lst.de> <ZennjRhWR2PVtoGU@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZennjRhWR2PVtoGU@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 07, 2024 at 09:13:01AM -0700, Keith Busch wrote:
> On Thu, Mar 07, 2024 at 08:11:53AM -0700, Christoph Hellwig wrote:
> > @@ -3840,12 +3840,16 @@ static inline int ext4_issue_discard(struct super_block *sb,
> >  	trace_ext4_discard_blocks(sb,
> >  			(unsigned long long) discard_block, count);
> >  	if (biop) {
> 
> Does this 'if' case even need to exist? It looks unreachable since there
> are only two callers of ext4_issue_discard(), and they both set 'biop'
> to NULL. It looks like the last remaining caller using 'biop' was
> removed with 55cdd0af2bc5ffc ("ext4: get discard out of jbd2 commit
> kthread contex")

Yeah.  I didn't really want to dig so far into code I don't know well
for this series, though :)

> > +		while (blk_next_discard_bio(sb->s_bdev, biop, &sector,
> > +				&nr_sects, GFP_NOFS))
> > +			;
> 
> This pattern is repeated often in this series, so perhaps a helper
> function for this common use case.

Well, it's 2-3 lines vs 1 line for a much better interface.
