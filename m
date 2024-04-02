Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA1D8F7D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 01:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022110; cv=none; b=ZJf/6sOhYHSuetmyT0gjjeyISIsJ+py6O6M42vkyP0vAF2NYTV9kaMdpuhUkt/psSrrupSA8mDD21naL9iZLjcbdRZe9BGTvCJmLzJMRLoMbpGXU96fdDUirNmYPROS33lbSFNKP5qfzk30QZve989l3n/tz6F4jSWHU/DHJcmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022110; c=relaxed/simple;
	bh=h3fKdBzIOjs9M7EcGbit08+T0fWrqZyPAUKrbITbKD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mpb+y/SmAiqBTRXaC/hUXZGhHEa5AjxkzcyIG9aRHxXTyLvTfxG0MmPmywy+CmFgY7mjgrLlXfLHFO2u1D9hKDaImzKyrNCY2yViUfCn134FcfqOPYBdNx3YfOBMCk+dkUYHhwNhP3NPdqXo4dc7WO4Fyk/0f3btbeFnDPRaTUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aq1yMyZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aq1yMyZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2622C433F1;
	Tue,  2 Apr 2024 01:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712022110;
	bh=h3fKdBzIOjs9M7EcGbit08+T0fWrqZyPAUKrbITbKD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aq1yMyZydafyjeUFTmzZv+Zm4ZrZhQHznnoiXvk5XpYjNDZfoiZzbug0WEd47GeDA
	 xW7hOq6/6QkyNWqddOGA3VvMfQw0+0TohKgrdJvV6I2rY9DQOO6XqyRhf4XrOihknU
	 HQ6vnd1Syw54imUePuSs4eogO4Zl4KgSGIWb7IVCHpIaHwC0THVUiuczgHOe2B0RKb
	 IVLONtOXorqZatWTnfm98vno2kbgKt1gkKyTrOSlsncl6F9p0PhWaEG1BKaPYlPbrD
	 Zc/Z83wbjftxOaUXZ29YTL8Emmm8FV4qyCeYBjhm1v0jk6NKvswGOAOTUrRzzRSqWu
	 +7werjvJzrM1A==
Date: Mon, 1 Apr 2024 18:41:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: xfs_quota_unreserve_blkres can't fail
Message-ID: <20240402014149.GS6414@frogsfrogsfrogs>
References: <20240328070256.2918605-1-hch@lst.de>
 <20240328070256.2918605-4-hch@lst.de>
 <20240329162123.GG6390@frogsfrogsfrogs>
 <20240330055755.GB24680@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240330055755.GB24680@lst.de>

On Sat, Mar 30, 2024 at 06:57:55AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 29, 2024 at 09:21:23AM -0700, Darrick J. Wong wrote:
> > > +static inline void
> > >  xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
> > >  {
> > > -	return xfs_quota_reserve_blkres(ip, -blocks);
> > > +	/* don't return an error as unreserving quotas can't fail */
> > > +	xfs_quota_reserve_blkres(ip, -blocks);
> > 
> > xfs_quota_reserve_blkres only doesn't fail if the nblks argument is
> > actually negative.  Can we have an ASSERT(blocks >= 0) here to guard
> > against someone accidentally passing in a negative @blocks here?
> 
> Sure.  Or even better just mark blocks as unsigned?

<shrug> I guess that works.

--D
