Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7FA3BBF2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 05:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719983402; cv=none; b=OHCNMA2MuCDQ9NNQRf3U3R5+ggXSYcst73bFa+0Pn+gZQ4AIa+YY5UccH3IE5O02dMP8jNNaDwD0zZbgpx7YbtPMc+x3eGZhtqMpVaNMMh5Gg+UJcwQgWfcLP3bOyMVbXBndilXWxp6vurrWP4xf9b4AhnN830cAviC8c8dXBs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719983402; c=relaxed/simple;
	bh=Unv86JBAeEiJNfGBQ3fXneOssD+mDOlnz2hDQD2sjQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGcjSk6/Opl621H88p9I3fvqKkrQu1KtN/90FGAHEEyxcTYEl0xv7d2Gl/JWa6VKCsqO3G4dVpEHgr6GGE6d4wJzeyhrubbpaE2vpNmRd/DiZKW+LFxF2d48iWCre5jaYxcfGWTZ0eFVQDeIm6VCNeS7SUJJC0IW3E7EYybnh0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRjY4CNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRjY4CNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A62C32781;
	Wed,  3 Jul 2024 05:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719983402;
	bh=Unv86JBAeEiJNfGBQ3fXneOssD+mDOlnz2hDQD2sjQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LRjY4CNQzUtCHnIRloLg9Q93iNPW0mKR0sGbyiY3sgoAODV5EqRPkqPTrVHu8TtT8
	 +xlmiIdh3sTAwPkyjMWo2yl31LYyn2wtgK/Pv+Y349ZVGIg4hK6NTTduun/BOKWO0U
	 YZBCHUoe/RqWzWf7X89vai0M6MBG39pN3WtY8LHIxK6fkdR4Gor1gQ+g4N81YLpTTA
	 Ed7wM4w9P+6mi5Q5cZx+kl3dTL1rHfFPtXkyNgvU93WqpkVtREJ65brfjz9Y57/9R+
	 Obuc84eJAV6EmyhoqWm+9z7Dgr+LaJ9LI8aRBuCqdBH/VyWtv2Y9GM641uqixSoAV8
	 yv5EGbNIhuY3w==
Date: Tue, 2 Jul 2024 22:10:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/11] xfs: skip flushing log items during push
Message-ID: <20240703051001.GE612460@frogsfrogsfrogs>
References: <20240620072146.530267-1-hch@lst.de>
 <20240620072146.530267-12-hch@lst.de>
 <20240620195142.GG103034@frogsfrogsfrogs>
 <20240621054808.GB15738@lst.de>
 <20240621174645.GF3058325@frogsfrogsfrogs>
 <20240702185120.GL612460@frogsfrogsfrogs>
 <ZoSNa2NkSVKb3ecl@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoSNa2NkSVKb3ecl@dread.disaster.area>

On Wed, Jul 03, 2024 at 09:29:47AM +1000, Dave Chinner wrote:
> On Tue, Jul 02, 2024 at 11:51:20AM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 21, 2024 at 10:46:45AM -0700, Darrick J. Wong wrote:
> > > On Fri, Jun 21, 2024 at 07:48:08AM +0200, Christoph Hellwig wrote:
> > > > On Thu, Jun 20, 2024 at 12:51:42PM -0700, Darrick J. Wong wrote:
> > > > > > Further with no backoff we don't need to gather huge delwri lists to
> > > > > > mitigate the impact of backoffs, so we can submit IO more frequently
> > > > > > and reduce the time log items spend in flushing state by breaking
> > > > > > out of the item push loop once we've gathered enough IO to batch
> > > > > > submission effectively.
> > > > > 
> > > > > Is that what the new count > 1000 branch does?
> > > > 
> > > > That's my interpreation anyway.  I'll let Dave chime in if he disagrees.
> 
> Yes, that's correct. I didn't finish this patch - I never wrote the
> comments in the code to explain this because I don't bother doing
> that until I've validated the heuristic and know it mostly works
> as desired. I simply hadn't closed the loop.
> 
> Please add comments to the code to explain what the magic "1000"
> is...

Something along the lines of

	/*
	 * Submit IO more frequently and reduce the time log items spend
	 * in flushing state by breaking out of the item push loop once
	 * we've gathered enough IO to batch submission effectively.
	 */
	if (lip->li_lsn != lsn && count > 1000)
		break;

Maybe?

> > > <nod> I'll await a response on this...
> > 
> > <shrug> No response after 11 days, I'll not hold this up further over a
> > minor point.
> 
> I've been on PTO for the last couple of weeks, and I'm still
> catching up on email. You could have just pinged me on #xfs asking
> if I'd seen this, just like jlayton did about the mgtime stuff last
> week. I answered even though I was on PTO. You always used to do
> this when you wanted an answer to a question - I'm curious as to why
> have you stopped using #xfs to ask questions about code, bugs and
> patch reviews?

I think you told me you had some PTO coming up the month after LSF so I
did not choose to bother you during your time off with something that
didn't seem all /that/ urgent.  At worst, we merge it, try to tweak it,
and either make it better or revert it.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
