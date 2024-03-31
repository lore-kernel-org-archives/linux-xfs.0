Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965DA1DDCE
	for <linux-xfs@vger.kernel.org>; Sun, 31 Mar 2024 22:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711925041; cv=none; b=j2KFBGhKqPDn7Z1tP/zuqZBA2SXzcL6AQXBXH4xDg3GHQP9e4OLb7KOW/qxQsVW/b016g683PaCj1JtoRHjgMvQ8pwvS0zOp/trLHZ5pzfhDw2RyH7Jaz1VXvMg/24GvEQbfUWBR+5h6Q/FkWspbBTiuKtMhxF25PyCKZh/pmy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711925041; c=relaxed/simple;
	bh=g05svHcki3fBYt87TBKzcE1Vay60tFmlo6OrgnGrnJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BL/Eo8Wzo5wxSqvGEAlxm1T00dQbChzRQWQU8Z3Y2nq9fWd5NmTC1MSdbWs6fpePgBx8eoapTr3UvFc0vuHYCuXOt7EV7NZyjhmppAAth53TaceRLKGBwmimYuTj+JnpV/Esi/2UizSRXB8caH6TY0EoWSEK2RH//vUxRWm1cHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsPcC9cl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsPcC9cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C8AC433F1;
	Sun, 31 Mar 2024 22:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711925041;
	bh=g05svHcki3fBYt87TBKzcE1Vay60tFmlo6OrgnGrnJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EsPcC9clFZ4r2rn5zTrobsgPZQDfjCRQ70oWsEhvG6Pdkvk8SGbK2chqlQmGyZ9Sa
	 i2CxlJl5pNfQfc0TVsUCn0Zv8IT98JD552uyjZpenOkZDOnU96Yw2JjfodTTAftYuA
	 ZMHFslePdLUq9NzxhPqHFUxOEUdo1HzwiWXPWxHezfes3zb+Oc8ZlEZmgMTezAZ6Tu
	 YYUH7nmea0wwgqInEcDurLSU4gyJUWtoY6PNX2v9H7XeIeNJy2jv1llgBLl08SE2W/
	 UkycnSi3fIUacbfDW6cWds2303t3WY7DSUxJRsl2rWiopI7RMFdrqy+vBjA5BNYeFG
	 0XCFtr5wU0RNQ==
Date: Sun, 31 Mar 2024 15:44:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <20240331224400.GW6390@frogsfrogsfrogs>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <ZgQEcLACdVZSxJ1_@infradead.org>
 <20240329213520.GQ6390@frogsfrogsfrogs>
 <ZgiBBUGqR0hMNAcI@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgiBBUGqR0hMNAcI@dread.disaster.area>

On Sun, Mar 31, 2024 at 08:15:49AM +1100, Dave Chinner wrote:
> On Fri, Mar 29, 2024 at 02:35:20PM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 27, 2024 at 04:35:12AM -0700, Christoph Hellwig wrote:
> > > On Tue, Mar 26, 2024 at 07:07:58PM -0700, Darrick J. Wong wrote:
> > > > periodically to allow other threads to do work.  This implementation
> > > > avoids the worst problems of the original code, though it lacks the
> > > > desirable attribute of freeing the biggest chunks first.
> > > 
> > > Do we really care much about freeing larger area first?  I don't think
> > > it really matters for FITRIM at all.
> > > 
> > > In other words, I suspect we're better off with only the by-bno
> > > implementation.
> > 
> > Welll... you could argue that if the underlying "thin provisioning" is
> > actually just an xfs file, that punching tons of tiny holes in that file
> > could increase the height of the bmbt.  In that case, you'd want to
> > reduce the chances of the punch failing with ENOSPC by punching out
> > larger ranges to free up more blocks.
> 
> That's true, but it's a consideration for dm-thinp, too. I've always
> considered FITRIM as an optimisation for dm-thinp systems (rather
> than a hardware device optimisation), and so "large extents first"
> make a whole lot more sense from that perspective.
> 
> That said, there's another reason for by-size searches being the
> default behaviour: FITRIM has a minimum length control parameter.
> Hence for fragmented filesystems where there are few extents larger
> than the minimum length, we needed to avoid doing an exhaustive
> search of the by-bno tree to find extents longer than the minimum
> length....

Ooooh, that's a /very/ good point.  xfs_scrub also now constructs a
histogram of free space extent lengths to see if it can reduce the
runtime of phase 8 (FITRIM) by setting minlen to something large enough
to reduce runtime by 4-5x while not missing more than a few percent of
the free space.

--D
