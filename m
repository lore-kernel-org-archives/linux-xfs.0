Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738403EA97
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712120097; cv=none; b=q9RS+m/sb3tVrYz1zTJaa3yz4SUXor7mb395bXQ4vfdrRnXZRjdENHPcfIUUPtiLeggco9SvUcMP6Zd0TdFPar4SDgjItuMTsUJ5rpPu94K+5InMUq0IHN50lLNr8QO80FcIK3U4nOcuO8kjaoGv+fbpApGoaGoXgKJ6PH7D18w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712120097; c=relaxed/simple;
	bh=lPTuXckgkYgaxCtbV6Yea9tUbbxWMnmYULZyPEuJdcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNjPpz7qVXnjz/XVdRTEN4kS/blznEFSJf4hc2/lcv5AKlyEZI8lhY+yRUrAX4SGoRPRKNPWTCyNMm+4B+pq6QhuyVqEzJmiVqzrgS2LgR2WVLTV6GrQhYZfpJjOQ0YDlmMeo8Jc8jeFsXWKgsKPAqb1zvEKoZy5SHzHqMF3isg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2een1BV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2een1BV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6E2C433F1;
	Wed,  3 Apr 2024 04:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712120097;
	bh=lPTuXckgkYgaxCtbV6Yea9tUbbxWMnmYULZyPEuJdcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p2een1BVtyV7MerKgBIwSmlDOGQbTnNujLvQWCDltOwJXa1wmfeH5CWVh8dXkzP+u
	 P+pWMHtcoTsYy5gzA9a5YC0vyt2lD/GkIoHqeM3xSCMgiDhU2wt3iazSrBxXpF/MP5
	 CFl80Ygbn2DCHSWJOJ31sWzXVbN0R2br1iK3WGfr1X/n4SH9pkn+V1vdrfYr6xhSO6
	 dw10Kx/ao4gwuZKp1Yq4aYxFjuDCiit3VTGzjcXxOYQMY8Yo7xThjv6mCyUKchifm9
	 /RVyW03/4l6LhNRSZgrZWrwVnRcVoq+R1LdorP/l+ftU9ZVzwDzGk/FZexsNLGZxdS
	 R2Yx61HdhOHxg==
Date: Tue, 2 Apr 2024 21:54:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org
Subject: Re: [PATCH 3/4] xfs: handle allocation failure in
 xfs_dquot_disk_alloc()
Message-ID: <20240403045456.GR6390@frogsfrogsfrogs>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-4-david@fromorbit.com>
 <ZgzeFIJhkWp40-t7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgzeFIJhkWp40-t7@infradead.org>

On Tue, Apr 02, 2024 at 09:41:56PM -0700, Christoph Hellwig wrote:
> > +	if (nmaps == 0) {
> > +		/*
> > +		 * Unexpected ENOSPC - the transaction reservation should have
> > +		 * guaranteed that this allocation will succeed. We don't know
> > +		 * why this happened, so just back out gracefully.
> > +		 *
> > +		 * We commit the transaction instead of cancelling it as it may
> > +		 * be dirty due to extent count upgrade. This avoids a potential
> > +		 * filesystem shutdown when this happens. We ignore any error
> > +		 * from the transaction commit - we always return -ENOSPC to the
> > +		 * caller here so we really don't care if the commit fails for
> > +		 * some unknown reason...
> > +		 */
> > +		xfs_trans_commit(tp);
> > +		return -ENOSPC;
> 
> A cancel and thus shutdown does seem like the right behavior for a trap
> for an unknown bug..

Usually this will result in the file write erroring out, right?

--D
