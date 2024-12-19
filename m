Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E861FAC3B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 05:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734587464; cv=none; b=Dt4nHd13g2en8wyLEgBIji25q6NM1fetvSnB6wHab6p1g86CHOBtguXjGQKntNIP+g4xU51JpC79miUShlzsCGyGaglqw4qf06vMokwDi+SpKkuAN1iDewKkUxAJ1VlJJ8smMMFn2PJORhzHfIX71tuFvuMgAMhEKbSYIAUXLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734587464; c=relaxed/simple;
	bh=RXAOjlVr8o/E4OAOyN5XRIA5U5dqF+D8n2UuxxV6+TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7kJ92lxRGZTnR1zNbhPyVjPJ55ucOSKdf3djEiRGWuEhBkRjnSnORRchpdiT+RbNg8lG9sC7NpDCKoBwymtwnXedZfx1j51r6zIYhxhcDqHaBYW/5ZpWetOvpMxe1wVOnCPy4iNH5KYpmcP+ISZep4LUxhnWw6X/GBbGEQ7e1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3A07B68AFE; Thu, 19 Dec 2024 06:50:59 +0100 (CET)
Date: Thu, 19 Dec 2024 06:50:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: add support for zoned space reservations
Message-ID: <20241219055059.GA19058@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-26-hch@lst.de> <20241213210140.GO6678@frogsfrogsfrogs> <20241215053135.GE10051@lst.de> <20241217165955.GG6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217165955.GG6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 17, 2024 at 08:59:55AM -0800, Darrick J. Wong wrote:
> Hrmm, they're rt extents that are available "now", or "for cheap"...
> 
> XC_FREE_NOW_RTEXTENTS
> 
> XC_FREE_RTEXTENTS_IMMED
> 
> XC_FREE_RTEXTENTS_CHEAP
> 
> Eh, I'm not enthusiastic about any of those.  The best I can think of
> is:
> 
> 	XC_FREE_RTEXTENTS_NOGC,	/* space available without gc */

I really hate that, as it encodes the policy how to get (or not) the
blocks vs what they are.

> > > going to use the greedy algorithm.  Later I see XFS_ZR_GREEDY gets used
> > > from the buffered write path, but there doesn't seem to be an obvious
> > > reason why?
> > 
> > Posix/Linux semantics for buffered writes require us to implement
> > short writes.  That is if a single (p)write(v) syscall for say 10MB
> > only find 512k of space it should write those instead of failing
> > with ENOSPC.  The XFS_ZR_GREEDY implements that by backing down to
> > what we can allocate (and the current implementation for that is
> > a little ugly, I plan to find some time for changes to the core
> > percpu_counters to improve this after the code is merged).
> 
> Ah, ok.  Can you put that in the comments defining XFS_ZR_GREEDY?

This is what I added earlier this week:

/*
 * Grab any available space, even if it is less than what the caller asked for.
 */
#define XFS_ZR_GREEDY           (1U << 0)

Do you want the glory details on why we're doing it here as well?
I guess it if can't be left as an exercise to the reader I'd probably
rather place it in the caller.

