Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CD83D88FB
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 05:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779083089; cv=none; b=AnRloaZH+W0KusdzRtZ/qKxqGQ/N44kjeFNNCKtb8cc0gbkIKPZWdKaZBv49VVaAaRZlo+JSl4xyUZSDD8HK78fhd2Kw+n/7VZYTiyN4JyyEN66qvjHfGUELJJiXUHvbwzoLYlTnlIsflwNH7tgSFe8iHzbJWk2Dq6X73vKs7z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779083089; c=relaxed/simple;
	bh=1Zj9jyVa+pMC2q5vwXBkcCHkt1MmMJo5FqojAUPc+sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PlIoxWh5g+Q+6UxCXdA2/G1ot9fz2M7vooFu7/cSVZESyVa44lgEVS9xEkPBPoAGQpePIB2D0cQ+RYrDoYiebEOA5INN9qrb0Iu+Te/InVC49eoR6uhpyFFwR0atntLS7pxgBX+gbEbXlUGARxCmFBQHSoVPTt3UE+z85aFDhgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5395C68C4E; Mon, 18 May 2026 07:44:37 +0200 (CEST)
Date: Mon, 18 May 2026 07:44:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a buffer lookup against removal race
Message-ID: <20260518054437.GA10057@lst.de>
References: <20260515133212.4039831-1-hch@lst.de> <20260515133212.4039831-2-hch@lst.de> <ageXNcsKQinCWyV1@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ageXNcsKQinCWyV1@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 16, 2026 at 07:59:17AM +1000, Dave Chinner wrote:
> > +	if (bp) {
> > +		/*
> > +		 * If there is an existing buffer with a dead lockref, retry
> > +		 * until the new buffer is added or usable buffer is found.
> > +		 */
> > +		if (!lockref_get_not_dead(&bp->b_lockref)) {
> > +			rcu_read_unlock();
> > +			goto retry;
> > +		}
> 
> Like the inode cache, there probably should be a delay here rather
> than spinning hard. There is no guarantee that the object actually
> appears removed from the cache until the RCU grace period expires,
> though typically races that find objects being removed are much
> shorter duration than that.

I don't think in the current version we need it because it is
basically imposisble to hit.  But with your comment below fixed
we do need it, so I'll add it.

> Also, is it safe to run lockref_get_not_dead() whilst some other
> thread is racing to get lockref.lock and calls lockref_mark_dead()
> on it? 

Yes, it is specifically designed for that: the lockref idea is that you
can do fast path increment/decrements using atomics that are serialized
as if you'd always take the lock around manual opeations on the count
field.  The ability to mark it dead under the lock and synchronize
against atomic increments one of the most important aspects of that.

> That'll cause issues. RCU algorithms require the object to be marked
> dead before it is removed from the index so that RCU lookup races
> that find it after removal (i.e.  during the RCU grace period) see
> the object as dead, not as a valid buffer (think RT preemption
> between remove and mark dead).

Yes, this should be switched around.  And with that the retry loop
above becomes more likely and needs the cpu_relax().

I wrote a version doing this and ran it through test over the weekend,
which I'll post soon.
