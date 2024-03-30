Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8EB79F0
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711778280; cv=none; b=Qq7GxyaDwftcHSIeNiwtLWcvyhhXPRu3JlI7fb9swk31UkS1L+DDWDHuE93Mrjgb/qNXRQyBEU5hDSMUd7tjV4UPdjhPk3FCju75qI3UV81Ft3eBi8c0ENoU+oZ5cqrQZXgjMk8XBiQxKsEtTl1OBbNtlXwC8Qwpkcti4sx0oVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711778280; c=relaxed/simple;
	bh=KSg/yEosg2ik6H/uCCnBAoV5QRkLExhQaIX9k8BhNVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ncy3QGrOo6CkM/GMtfz8uYXfTdsIEFX4H7YsbXrZkKKs3jrCzJuVsX67nfqn03VsY8luYXbkU3ESRPHhJS2X7I8C6e3Z8hYB7ppGN3MNGbnNLCduYSY48aWlhAhLpwa261HW1olYW63OhiA5Y6gWMtHW8Z6RycyG9JSLPGQhmpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B768A68B05; Sat, 30 Mar 2024 06:57:55 +0100 (CET)
Date: Sat, 30 Mar 2024 06:57:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: xfs_quota_unreserve_blkres can't fail
Message-ID: <20240330055755.GB24680@lst.de>
References: <20240328070256.2918605-1-hch@lst.de> <20240328070256.2918605-4-hch@lst.de> <20240329162123.GG6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329162123.GG6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 29, 2024 at 09:21:23AM -0700, Darrick J. Wong wrote:
> > +static inline void
> >  xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
> >  {
> > -	return xfs_quota_reserve_blkres(ip, -blocks);
> > +	/* don't return an error as unreserving quotas can't fail */
> > +	xfs_quota_reserve_blkres(ip, -blocks);
> 
> xfs_quota_reserve_blkres only doesn't fail if the nblks argument is
> actually negative.  Can we have an ASSERT(blocks >= 0) here to guard
> against someone accidentally passing in a negative @blocks here?

Sure.  Or even better just mark blocks as unsigned?

