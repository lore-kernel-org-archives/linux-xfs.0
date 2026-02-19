Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B44A29B79B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 21:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771537921; cv=none; b=EYCzHdZvQAH0YZINpp+JQtEl1ZjDBYzWY6TOA5VJFoLy6dT4kSY2R1UBpWmBv71w6JJz8sc6GcUuv3cwwIXsTePRmAzmr2WwJ/LQPm95VRY8O8AKC7AIWrkSE3wu638Q+6N/DkyMCIKNtuA5ym/myNtNYyT0Kag+xbQljEQPUy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771537921; c=relaxed/simple;
	bh=TtO4lRHZG2Pr9eBNWVI4Zagk57OWuu198v67spanBek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQBc5x7rKv3+d+pTKcZ/Z1R7N+ayef9xqpt9+gaYvml1+SpPGB0QeymfhG/IgmeCEOQT1y5CY4nOOR3GtORhqPquwSwoqlXyGnJilqrqFnrV24z19G35iH4LVFKHQ98r/ULxUu64naetOkeVwkjryrexD6OUeHQQ5sU64AX+Yo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+Gu/M1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+Gu/M1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48D3C4CEF7;
	Thu, 19 Feb 2026 21:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771537920;
	bh=TtO4lRHZG2Pr9eBNWVI4Zagk57OWuu198v67spanBek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+Gu/M1nE1y4ObG5E576HDShvxG4BAuy6bzGThTkG5XNkRFHuZGnuh8+l5hk4M+5G
	 rMgsW6fvnW0ZGaqUu1CehdJXJJKkA34NkRJXVYGrItKdF96C439bXrwhPzWeSHuCoL
	 ZAVTKF+LKgcLiEewtUWW6hqTa+H0RJ0zPq0kCY1kZq7GpWS4L+PAZsH4m9PcsWHyCp
	 bfc3Cg1WSvwX+oO/pxf68XdYR6QAKeC7mv3Q/Rlks+duXYcLoHwXc520fwpODYJ4fw
	 Vrw2EnegHpQ147X16ryvCt2PTaVvdr4qiOnlJwMr0BJavSZi3p6rBhkx3gV9aM5PCg
	 0WjhjnPcNOM5g==
Date: Thu, 19 Feb 2026 13:52:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix potential pointer access race in
 xfs_healthmon_get
Message-ID: <20260219215200.GR6490@frogsfrogsfrogs>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925494.401799.17980890890269795712.stgit@frogsfrogsfrogs>
 <aZaxI4PzJKqUc7a_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZaxI4PzJKqUc7a_@infradead.org>

On Wed, Feb 18, 2026 at 10:43:47PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 10:01:45PM -0800, Darrick J. Wong wrote:
> >  
> > -	XFS_M((struct super_block *)hm->mount_cookie)->m_healthmon = NULL;
> > +	rcu_assign_pointer(XFS_M(
> > +			(struct super_block *)hm->mount_cookie)->m_healthmon,
> > +			NULL);
> 
> Just a nitpick, but factoring the cookie to sb thing into a helper
> or at least separate assignment would really clean this up.

Ok, I'll do that.

	mp = XFS_M((struct super_block *)hm->mount_cookie);
	rcu_assign_pointer(mp->m_healthmon, NULL);

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for the reviews!

--D
