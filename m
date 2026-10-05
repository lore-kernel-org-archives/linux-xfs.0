Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A624854E4;
	Mon,  5 Oct 2026 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206574; cv=none; b=ttulklKJXjJeA6c+qW7TBqTmYwZNc+aaMxUDl+iwGS18mL1xpnuROpRgYsksnZGJK2dsXzQ9MBZE1e1bDopm302OG8AXHS8bFDfYZ0LEieR3IyXdi1oMfMUKgOrSPMLSh4ikJ8FB9e5I6v+b6gn84YQ2MmPDZhn0Xvspf5Yr5+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206574; c=relaxed/simple;
	bh=0a4mdBpRiz0YYDBhh3UdT1eu3Gk6zIkjKGr64APGxlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZ1dvGHZVD+YgNHBXAEvzki8wpqqFgmZlBu4bPhAmVJX0IsxzgWU5mcqwNFs4zHFRszTBLhkPvclaPEh7h2HHeniPa0WNAQfhtID/uLSGa8fiEJaxMAaa4gWNAtI8BwjsKGcpZ+o7Bg3qOjqsomyWFb6wvpvm12Ulv5jGFwb5yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C4E768AFE; Mon,  5 Oct 2026 15:22:29 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:22:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs/2302: add a basic data checksum test
Message-ID: <20261005132229.GL26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-8-hch@lst.de> <20260929014834.GJ2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929014834.GJ2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:48:34PM -0700, Darrick J. Wong wrote:
> > +_require_test
> > +_require_loop
> > +_require_zloop
> > +# hack to only run for block based file systems
> > +_require_block_device $SCRATCH_DEV
> 
> What XFS filesystem isn't block-based?

None that I know of, not even the magic cluster slop :)

I guess this came from whatever generic test I started with.

