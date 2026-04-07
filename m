Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948FD37C11B;
	Tue,  7 Apr 2026 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775543232; cv=none; b=CneKpPsTzpiWc9ATx+J1YFOp44WJqoMhTK1YV5Jskm5RUAFb7QuYw9FkmNxAz63J0ujmYFeVqTNDFBde8F1h5yHTUt44tldQKIXq+iE4sABvYcQYRH7jIjKmGXRH9uFEFWBQ7AyiX9zn7h/6OQEYk/A4uDFFnJB2a8Te7w/ylow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775543232; c=relaxed/simple;
	bh=UskVC7sNLwX68jWNnuOkgr2jPov8fp4A5nPK54jf8K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RV+Pr7cZDoO1klNFT8O3DLbLDSRxYQ5H0ncEXzwGwg5pJUx2Y06OSPbpWsEaKonPDRfKUf1TSwCqU8otoOz+87lsnq8dPcU4SStTYvUx5ReGrjLfkbe6FO3zShwu2+oxgE77Z8owAYLj3HtdIy38T7N/UhFRst2Llxgc+akForM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 43F5168C4E; Tue,  7 Apr 2026 08:27:07 +0200 (CEST)
Date: Tue, 7 Apr 2026 08:27:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <20260407062707.GA6937@lst.de>
References: <20260331152341.4047725-1-hch@lst.de> <20260331211807.gofhlabxlr3mdxnr@doltdoltdolt> <20260401061828.GA24293@lst.de> <20260401075952.ifuz3kqfq3g7c4gf@doltdoltdolt> <20260401140646.GA21703@lst.de> <20260406170528.sxcm3qcndjhwm7pp@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406170528.sxcm3qcndjhwm7pp@doltdoltdolt>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 07, 2026 at 01:05:28AM +0800, Zorro Lang wrote:
> > 
> > I think _notrun if mkfs or the initial mount fails might be easier and
> > better here.
> 
> How about a _require_xfs_mkfs_zoned ?
> 
> And about `_scratch_mount -o max_open_zones=${open_zones}`, if max_open_zones
> mount option isn't supported, _scratch_mount will fail directly. So how about
> 
>   _try_scratch_mount -o max_open_zones=${open_zones} || \
>           _notrun "max_open_zones option is not supported"
> 
> Or we can have a helper for that, as xfs/642~644 and xfs/668 also need that.

I'll take a look.  max_open_zones is always supported for zoned xfs
file systems - the notrun is intended to cover the case where the kernel
can't mount zoned file systems - either because it is too old, or because
XFS_RT is not enabled.

