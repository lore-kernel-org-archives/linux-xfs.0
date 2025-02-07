Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A4315E5B8
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904126; cv=none; b=qh/cKIT4T9XdOf0v/c9nIsRZxd9v/F290AU9pazXnK4uAJiwy17nK4i9tvh/226BBIhwPMDtU2pBVIpqkjBu/6Dw1bxBcXCT8JDu+J4bVI309bimTH5PSvLQ1zxp0L4SpNkDhA+kDeuI9wmVX3qQFxhus1t0hvBx4yOX6Y9FibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904126; c=relaxed/simple;
	bh=fKXV1HBWKhY/zKM7sAKDCSSt6lc292tfAhl/Yw7ywZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sjM7P4K5I66iPuP/6wV/qU80ohyEhef1AlPDMnxjXdiGyEOIwxm8p2eN7qJ7MZlk+sipgBQhuMDRDVeOPYIcHZufBRMezxTNB8jCksGP8FRprBvBzAwzI4HKmwUUY85eJGOoXLaX3qyYOUdAwHC94j+ncQLAGiWgWmfzlGCIY7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 28AE868C4E; Fri,  7 Feb 2025 05:55:21 +0100 (CET)
Date: Fri, 7 Feb 2025 05:55:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/43] xfs: enable fsmap reporting for internal RT
 devices
Message-ID: <20250207045520.GB6694@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-34-hch@lst.de> <20250207043901.GP21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207043901.GP21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 08:39:01PM -0800, Darrick J. Wong wrote:
> > The bmbt values are all relative to rtstart, the daddr translation is
> > what adds the offset.  So if we want to take the offset out of the
> > fsmap reporting, I'll need new helpers to not add it or manually
> > subtract it afterwards.  If that's preferred it should be doable, even
> > if the fsmap code keeps confusing me more each time I look at it.
> 
> The fmr_physical addresses of the fsmaps reported for the "XFS_DEV_RT"
> device (aka when sb_rtstart > 0) are relative to the start of the data
> device, right?

Yes.

> In a way, that makes it easier to figure out how to set
> up a media scan or a block device to file translation, because the
> fmr_physical number you feed in and get out of fsmap always matches the
> device LBA.

Yes.

