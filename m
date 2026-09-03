Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FDB37756F;
	Thu,  3 Sep 2026 06:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415873; cv=none; b=LQuHGIGXY0J8drmSiKHKBdpgmFg+hUu3GIWuHyOPMB6yEfacISRdjHsI6RihvBJOvcYPuA4azDyadmc4Ibyas7za++dMyvVibmQ/ccrPZTYG7jlZ1tpmaijTiH/S9RvHwq0fVCj7oa/ul54VKqk5DMAZZWe5ystUXIM7UWgFhbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415873; c=relaxed/simple;
	bh=oE9xHVvD+a1JS4J7lWrxkiBvMpA8LSXss5x7l5D63t0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARcFt8mfZ3h5hCvK9oD81xEZ3epK9tM4ilYI25Z3KsXZCQFfReZpVI6rXBgnCUo4XQuibF6Zm24N/bhs01Z+hCF+fhftb74077T6tyF/sIZjT9tNbOD8g8jAkAJT2zaFR2ZV+Rm8qiSLB4+gOVPjb1OGE4e7jzWUIm7yTdrZQHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 193F76732A; Thu,  3 Sep 2026 08:11:09 +0200 (CEST)
Date: Thu, 3 Sep 2026 08:11:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: make the rtsummary repair fix the file size
 too
Message-ID: <20260903061108.GE17233@lst.de>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs> <178840969935.484660.8039849140582704928.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178840969935.484660.8039849140582704928.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 10:52:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that the rtsummary repair code will create a new rtsummary
> with the correct file size, but it won't force the new file size to be
> set on the existing rtsummary file, leaving the rtsummary corrupt.  Fix
> this by setting up the tempfile mapping-exchange to run to the end of
> both files, which is the magic offset needed to reset the file size.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
