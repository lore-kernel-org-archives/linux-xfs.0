Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828BF3D6CCD
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 06:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782455011; cv=none; b=r9JB2XKL0KXXrw9U/UBOcakOcXSVNvlzQ8bKcKXSi0Ylf/7Q/RkkJ0uEH/RoFEL0JxwnW1tbA7VF88bxaalKqfksBttEuXFikUoGjE+rT+fWieLbbHvnwI9fBLjPwDf6IBCz8dhbFPI5RCpRXIqSNCSxaBfUoEKS/O5nMByqGt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782455011; c=relaxed/simple;
	bh=gnaJTax6e8JQrN5YD+dvpMHM4mqBGSLXSVvCwGOouU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUmxGLHIn+fbTrsQFwyR4ZGhRB5QWoTm6BS79IMgpMK5ic3tSpIsnaXzHT5/o+hHxhCy56Y0rRTwyLG6sCDyouUr3pPV0euXJInH5aORKZK5BIX4Rb33eIN89mDBYJG5uzKnpcpUn1jwzFVTej4fxQLpna5/udfGtGk6wBu3s0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4DEDF68B05; Fri, 26 Jun 2026 08:23:26 +0200 (CEST)
Date: Fri, 26 Jun 2026 08:23:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/6] xfs: also mark the buffer stale on verifier
 failure in xfs_buf_submit
Message-ID: <20260626062326.GA10546@lst.de>
References: <20260625135849.2494779-1-hch@lst.de> <20260625135849.2494779-3-hch@lst.de> <20260625180002.GG6078@frogsfrogsfrogs> <20260626043516.GD8078@lst.de> <20260626062146.GP6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626062146.GP6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 11:21:46PM -0700, Darrick J. Wong wrote:
> > ->verify_write is expected to set b_error when it fails (and yes,
> > the API in that area is awful).
> 
> Would you mind leaving a comment here, then?
> 
> 	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
> 		/* ->verify_write should have set b_error already */
> 		xfs_force_shutdown(...);
> 		goto out_ioerror;
> 	}

Sure.

