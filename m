Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ED9F503
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600457; cv=none; b=pTeWKtp57PTFRWq9JM+RbRGhWuI3iz6UFwYjY4w/Hfzjdw8jsPmUH3e8xd1GRlDCytrtfLLsOfFbVOwLbq7nupcnEUJpZQXNjqbQKt9DK358WUCXH2yhJGopBayZ/6Gdh/wJszXT8Hz97X5TPZRt4u6oDGipzoMoxxOe6TIJ62M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600457; c=relaxed/simple;
	bh=+JaDbRr5xg+kRsQzM4qzQZVAdJHmlu4C6/PS/YoVo+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFAv8MnNVrGRTc2r94K5zg/WIRiU3+YGEbsb8obdWhr2yC+tRqHUWGWKdAY9bmIdAEqsHYewtybDuIIRSXumF92sF1Af1n9EIX4vkd0Ow42siBBT3rVJ9HU7udQtpYKHImEz7a70QOJ/fMWgWhmBoF0xCJ943d0I/lCn7LfzX1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D1D068B05; Thu, 28 Mar 2024 05:34:12 +0100 (CET)
Date: Thu, 28 Mar 2024 05:34:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240328043411.GA13860@lst.de>
References: <20240327110318.2776850-1-hch@lst.de> <20240327110318.2776850-10-hch@lst.de> <ZgTxuNgPIy6/PujI@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgTxuNgPIy6/PujI@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 03:27:36PM +1100, Dave Chinner wrote:
> >  	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
> > -	percpu_counter_set(&mp->m_frextents, fsc->frextents);
> > +	percpu_counter_set(&mp->m_frextents,
> > +		fsc->frextents - fsc->frextents_delayed);
> >  	mp->m_sb.sb_frextents = fsc->frextents;
> 
> Why do we set mp->m_frextents differently to mp->m_fdblocks?
> Surely if we have to care about delalloc blocks here, we have to
> process both data device and rt device delalloc block accounting the
> same way, right?

Unfortunately there are different.  For data device blocks we use the
lazy sb counters and thus never updated the sb version for any file
system new enough to support scrub.  For RT extents lazy sb counters
only appear half way down Darrick's giant stack and aren't even
upstream yet.

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
---end quoted text---
