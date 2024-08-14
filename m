Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5460D10953;
	Wed, 14 Aug 2024 03:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723607012; cv=none; b=mR+3qizZluNDImIq93BpUtf3eLr9IKz9DiAGveuty3g4jL9pBFBqn2yQQxcaS2c/oZDVH+xpoQbsGch0Gq8lnzMajeb1RqtWR8caa60B2tgVpaTeuEaquXU76nEiWRYzkdUioyF+bBYXjXTZXfLbbQMtMWeKu1QyFBeb7/tWSH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723607012; c=relaxed/simple;
	bh=WeP2TXMxno/ZnN34UY2VSHewTSzuziJk6CkTlR/O3O8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HL66lsvwKiSGNO0TO9Fxc1mWJfp8+kfhGeIPtiznSwoknw6mIJEFctibOxCu1JCQt+3tzdgEpjgT+Bd3KoFyIpNuYJCyDDWjyseeGEl0drgVf+rflZR9d+Q4jX4K950hp8nmb/Q2KJFPeyYCHLTsavDGFcDAM2+gGCRA2sxzYC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9D662227A88; Wed, 14 Aug 2024 05:43:25 +0200 (CEST)
Date: Wed, 14 Aug 2024 05:43:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] add a new min_dio_alignment helper
Message-ID: <20240814034325.GA29861@lst.de>
References: <20240813073527.81072-1-hch@lst.de> <20240813073527.81072-3-hch@lst.de> <20240813144004.GD6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144004.GD6047@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 13, 2024 at 07:40:04AM -0700, Darrick J. Wong wrote:
> > +	/*
> > +	 * No support for STATX_DIOALIGN and not a block device:
> > +	 * default to PAGE_SIZE.
> 
> Should we try DIOINFO here as a second to last gasp?

I implemented this last night, but have second thoughts now:

DIOINFO is only implemented for XFS, which both implemented
STATX_DIOALIGN from the start, and where the block size hack works
and is equivalent to the DIOINFO output.  So I don't think this
buys us anything but costs an extra syscall per invocation.

So I plan to drop this again before submission.

