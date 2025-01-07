Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAD086347
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736268665; cv=none; b=Bg3b9Db2D+J5n3tX44slAov/gb7HriTEH2XHBVKE4OV2ChaNnYAasS6yHPPSiZNKdtJZNWCRVtNY5IyJbum8j82rF4Kp86w89ewtU2JR8d9WDUXd1HBUFhYl+BRh1dGGXfP3b2gpvG6+0XdsB55npe3/pb9QJC6jcAmMjxzX718=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736268665; c=relaxed/simple;
	bh=TAjzvAUBUaeScRl0hfg7U2aSBAFk6WPqYaVvV0LIU2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iihbRKl7eEPMlDY7VRJzSN1ufhNgxChkkBlMIzgLWKbxkeit5zst2d6gM9Ec6s0PnVURioEFmkNfHkA7n7h/LV1u13APAyv/eIfJeT4Rp/DY1dLaIFTQrULc4iotkf8lNGjZVC+EjaUYWsUV3lCcG14iL99QAxwfUAE4qL33qNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB13968CFE; Tue,  7 Jan 2025 17:50:57 +0100 (CET)
Date: Tue, 7 Jan 2025 17:50:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	djwong@kernel.org, david@fromorbit.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <20250107165057.GA371@lst.de>
References: <20241229133350.1192387-1-aalbersh@kernel.org> <20250106154212.GA27933@lst.de> <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 09:56:51PM +0100, Andrey Albershteyn wrote:
> On 2025-01-06 16:42:12, Christoph Hellwig wrote:
> > I've not looked in details through the entire series, but I still find
> > all the churn for trying to force fsverity into xattrs very counter
> > productive, or in fact wrong.
> 
> Have you checked
> 	[PATCH] xfs: direct mapped xattrs design documentation [1]?
> It has more detailed argumentation of this approach.

It assumes verity must be stored in the attr fork and then justifies
complexity by that.

> > xattrs are for relatively small variable sized items where each item
> > has it's own name.
> 
> Probably, but now I'm not sure that this is what I see, xattrs have
> the whole dabtree to address all the attributes and there's
> infrastructure to have quite a lot of pretty huge attributes.

fsverity has a linear mapping.  The only thing you need to map it
is the bmap btree.  Using the dabtree helps nothing with the task
at hand, quite to the contrary it makes the task really complex.
As seen both by the design document and the code.

> Taking 1T file we will have about 1908 4k merkle tree blocks ~8Mb,
> in comparison to file size, I see it as a pretty small set of
> metadata.

And you could easily map them using a single extent in the bmap
btree with no overhead at all.  Or a few more if there isn't enough
contiguous freespace.

> 
> > fsverity has been designed to be stored beyond
> > i_size inside the file.
> 
> I think the only requirement coming from fs-verity in this regard is
> that Merkle blocks are stored in Pages. This allows for PG_Checked
> optimization. Otherwise, I think it doesn't really care where the
> data comes from or where it is.

I'm not say it's a requirement.  I'm saying it's been designed with
that in mind.  In other words it is a very natural fit.  Mapping it
to some kind of xattrs is not.

> Yes, that's one of the arguments in the design doc, we can possibly
> use it for mutable files in future. Not sure how feasible it is with
> post-EOF approach.

Maybe we can used it for $HANDWAVE is not a good idea.  Hash based
verification works poorly for mutable files, so we'd rather have
a really good argument for that.

> I don't really see the advantage or much difference of storing
> fs-verity post-i_size. Dedicating post-i_size space to fs-verity
> dosn't seem to be much different from changing xattr format to align
> with fs blocks, to me.

It is much simpler, and more storage efficient by doing away with the
need for the dabtree entries and your new remote-remote header.

