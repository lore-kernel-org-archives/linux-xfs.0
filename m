Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F43C2C8
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 05:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734240702; cv=none; b=lpo7cmnBBqPWy47SMhR1itMgelRVEMrFajNrCg21KhU02WW9FxNlIWXL/ahFoZDJKbrnssZ0pG3Q3YipgQVn/ldvfqnN58uSnIA2m5UkQcJg1/hHBDXa6fyn7vBGMfi9hfIbkGFOuSCqHFkYI3gxj4tGlgxXa+5/KoSNkJU3Aog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734240702; c=relaxed/simple;
	bh=2JeJd5YTr/1q484oUFWenwmDacvUnUX2aCj2jn9oDew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zi0hjPHEDAmeRGw+26tksVq4K7TJV//9dZOMGTt9N+G9jh7FRQnGm/mdUQrKkQ93vcRFAA7aZpq+ypzq+vIOBLtfVPAQlMkBHEZaATpmUoD/JoFw4VJibfjuw8YUwErICWZgSrrCFZsEHbvrQc9nONTNeRLPGj21S03YmWYoI6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 962A468C7B; Sun, 15 Dec 2024 06:31:35 +0100 (CET)
Date: Sun, 15 Dec 2024 06:31:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: add support for zoned space reservations
Message-ID: <20241215053135.GE10051@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-26-hch@lst.de> <20241213210140.GO6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213210140.GO6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 01:01:40PM -0800, Darrick J. Wong wrote:
> > +#define XFS_ZR_GREEDY		(1U << 0)
> > +#define XFS_ZR_NOWAIT		(1U << 1)
> > +#define XFS_ZR_RESERVED		(1U << 2)
> 
> What do these flag values mean?  Can we put that into comments?

Sure.

> > + * For XC_FREE_RTAVAILABLE only the smaller reservation required for GC and
> > + * block zeroing is excluded from the user capacity, while XC_FREE_RTEXTENTS
> > + * is further restricted by at least one zone as well as the optional
> > + * persistently reserved blocks.  This allows the allocator to run more
> > + * smoothly by not always triggering GC.
> 
> Hmm, so _RTAVAILABLE really means _RTNOGC?  That makes sense.

Yes, it means block available without doing further work.
I can't say _RTNOGC is very descriptive either, but I would not mind
a better name if someone came up with a good one :)

> > +		spin_unlock(&zi->zi_reservation_lock);
> > +		schedule();
> > +		spin_lock(&zi->zi_reservation_lock);
> > +	}
> > +	list_del(&reservation.entry);
> > +	spin_unlock(&zi->zi_reservation_lock);
> 
> Hmm.  So if I'm understanding correctly, threads wanting to write to a
> file try to locklessly reserve space from RTAVAILABLE.

At least if there are no waiters yet, yes.

> If they can't
> get space because the zone is nearly full / needs gc / etc then everyone
> gets to wait FIFO style in the reclaim_reservations list.

Yes (In a way modelled after the log grant waits).

> They can be
> woken up from the wait if either (a) someone gives back reserved space
> or (b) the copygc empties out this zone.
> 
> Or if the thread isn't willing to wait, we skip the fifo and either fail
> up to userspace

Yes.

> or just move on to the next zone?

No other zone to move to.

> I think I understand the general idea, but I don't quite know when we're
> going to use the greedy algorithm.  Later I see XFS_ZR_GREEDY gets used
> from the buffered write path, but there doesn't seem to be an obvious
> reason why?

Posix/Linux semantics for buffered writes require us to implement
short writes.  That is if a single (p)write(v) syscall for say 10MB
only find 512k of space it should write those instead of failing
with ENOSPC.  The XFS_ZR_GREEDY implements that by backing down to
what we can allocate (and the current implementation for that is
a little ugly, I plan to find some time for changes to the core
percpu_counters to improve this after the code is merged).

