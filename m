Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE002148310
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734454795; cv=none; b=UxaGQ+KJ4FextMFeHf2FMYi2va4Bd7cJkRqLdpXxdhckyRiq1KtQAwzVnuBV0ddKWZxntst3YgAE0MGwT9oYfzEOr9WEw/Gq+489lBrUtNDZ/vFL+TM187ar47tvEsNjyWgO4j+KxgZncZWmmsbibE0VX+xlLM1Q/gOW2bGPvaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734454795; c=relaxed/simple;
	bh=MVt+AvATfWfKwRotpvyj+cNJkh0OtctkB7S2uQf9uVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdvxkTGuO82h9/x3af3NyANrId1aj1KRhibcQdCz6WV654n+XnmSmDfv7Y/s8/3yLmOFrRDfZfMltASq1e/FlkVvafLPShoSQniXl2a9e0fHWiNi97go059stqiL+m5P7gQgxHBBZl4JpIVwMRWwjeJoaQu1ndBsFJcpcCVYXWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRueyCr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRueyCr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DE5C4CED3;
	Tue, 17 Dec 2024 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734454795;
	bh=MVt+AvATfWfKwRotpvyj+cNJkh0OtctkB7S2uQf9uVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bRueyCr0z9O2xk/L6HvnPmFfWxApJUn6+OeXXTZbGB0HZKTxHmKbtXrXphq1U1Lru
	 D4O9v0S2QKsBOvf0H12Yl/2nS/02tHXbU7MFcJzS2o5nR/U+1FfHvF3fQnLDNML+PW
	 pBojPuWNe0d8qcH+344xvwOmoeuLn7EJMsG1RAuWwo//TD2B1k8UDgK/s1lxLc9hWu
	 lRyc5b4r6G9HDfBwIvLZweCpWqbW0wO3qLw7cBkTzyMt5aLB0ay3SKOyoZvkjpeBeO
	 yiUKpb4NhNTKX4NT5CLkZ4IyVv0voD+kZUxCiLvyWmDII9Aw5uQkj/Qt/D19q8eDPB
	 YGhcukLQ7zuYg==
Date: Tue, 17 Dec 2024 08:59:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: add support for zoned space reservations
Message-ID: <20241217165955.GG6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-26-hch@lst.de>
 <20241213210140.GO6678@frogsfrogsfrogs>
 <20241215053135.GE10051@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241215053135.GE10051@lst.de>

On Sun, Dec 15, 2024 at 06:31:35AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 13, 2024 at 01:01:40PM -0800, Darrick J. Wong wrote:
> > > +#define XFS_ZR_GREEDY		(1U << 0)
> > > +#define XFS_ZR_NOWAIT		(1U << 1)
> > > +#define XFS_ZR_RESERVED		(1U << 2)
> > 
> > What do these flag values mean?  Can we put that into comments?
> 
> Sure.
> 
> > > + * For XC_FREE_RTAVAILABLE only the smaller reservation required for GC and
> > > + * block zeroing is excluded from the user capacity, while XC_FREE_RTEXTENTS
> > > + * is further restricted by at least one zone as well as the optional
> > > + * persistently reserved blocks.  This allows the allocator to run more
> > > + * smoothly by not always triggering GC.
> > 
> > Hmm, so _RTAVAILABLE really means _RTNOGC?  That makes sense.
> 
> Yes, it means block available without doing further work.
> I can't say _RTNOGC is very descriptive either, but I would not mind
> a better name if someone came up with a good one :)

Hrmm, they're rt extents that are available "now", or "for cheap"...

XC_FREE_NOW_RTEXTENTS

XC_FREE_RTEXTENTS_IMMED

XC_FREE_RTEXTENTS_CHEAP

Eh, I'm not enthusiastic about any of those.  The best I can think of
is:

	XC_FREE_RTEXTENTS_NOGC,	/* space available without gc */

> > > +		spin_unlock(&zi->zi_reservation_lock);
> > > +		schedule();
> > > +		spin_lock(&zi->zi_reservation_lock);
> > > +	}
> > > +	list_del(&reservation.entry);
> > > +	spin_unlock(&zi->zi_reservation_lock);
> > 
> > Hmm.  So if I'm understanding correctly, threads wanting to write to a
> > file try to locklessly reserve space from RTAVAILABLE.
> 
> At least if there are no waiters yet, yes.
> 
> > If they can't
> > get space because the zone is nearly full / needs gc / etc then everyone
> > gets to wait FIFO style in the reclaim_reservations list.
> 
> Yes (In a way modelled after the log grant waits).
> 
> > They can be
> > woken up from the wait if either (a) someone gives back reserved space
> > or (b) the copygc empties out this zone.
> > 
> > Or if the thread isn't willing to wait, we skip the fifo and either fail
> > up to userspace
> 
> Yes.
> 
> > or just move on to the next zone?
> 
> No other zone to move to.

<nod>

> > I think I understand the general idea, but I don't quite know when we're
> > going to use the greedy algorithm.  Later I see XFS_ZR_GREEDY gets used
> > from the buffered write path, but there doesn't seem to be an obvious
> > reason why?
> 
> Posix/Linux semantics for buffered writes require us to implement
> short writes.  That is if a single (p)write(v) syscall for say 10MB
> only find 512k of space it should write those instead of failing
> with ENOSPC.  The XFS_ZR_GREEDY implements that by backing down to
> what we can allocate (and the current implementation for that is
> a little ugly, I plan to find some time for changes to the core
> percpu_counters to improve this after the code is merged).

Ah, ok.  Can you put that in the comments defining XFS_ZR_GREEDY?

--D
