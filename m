Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2118DF59;
	Wed, 26 Aug 2026 04:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787719706; cv=none; b=icdQqFYKRtPk31YGdTINg54cF/NQrYrFR/CYVwqEKoj0p1G+zm2Pw+zzGzo73JiEsPD2U1JrJ6HrIELjf4j0VdXaxNYh3fhsVpokvL3ABPZ9bJwfxWKvDNplDpexmB4aFDRgNovSDPBdsGVXL6mQ0JoG96+rZYUhuBHuHNgUQc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787719706; c=relaxed/simple;
	bh=EWF+XMxAuZgPsqmrsBRm4fkqP3HmGkjoTjzHjkzQvlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KW0N42gSFi5tz+M2IuezUUHz6quPMQi+5pFu+aaLvw9VmUPOZgCWh/MWr2F8FE9sPsCaSSRQUYhYrSfhRwto7HPjNBy8Mp1zH4n43L0/eNsf2RfpBRnxPJN/GwM4AYQioKvK2AOPqoo814mPZdIrQtRufpzMM/vSLtZ2kL5xHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 862E968AFE; Wed, 26 Aug 2026 06:48:20 +0200 (CEST)
Date: Wed, 26 Aug 2026 06:48:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: always set xfs_healthmon::first_event when
 inserting at front of list
Message-ID: <20260826044820.GC14936@lst.de>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs> <178760941102.944364.11828316232110118627.stgit@frogsfrogsfrogs> <20260825064017.GA24532@lst.de> <20260825183308.GW6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825183308.GW6072@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 25, 2026 at 11:33:08AM -0700, Darrick J. Wong wrote:
> Let me try again:
> 
> "LOLLM complains that while __xfs_healthmon_insert is supposed to insert
> an event at the head of the list, it doesn't do that correctly if the
> list isn't empty.  In that case it *should* make our new event point to
> the current head, and then make the head point to the new event, but
> it doesn't actually update the head."

> > event is the newly inserted event.  We want to queue it at the
> > head of the list (why, btw?).
> 
> The only event that gets inserted at the front is the unmount event.
> This signals that the filesystem is being completely unmounted (not just
> detached from a mount ns) and there's nothing further that xfs_healer
> can do to fix the filesystem.  Therefore we put the unmount item first
> in the list so that xfs_healer won't waste time trying to find the
> mount to do repairs that it won't be able to make.

Ok, me forgetting about two different ways to insert events was the
reason I had a really hard time with the commit log.

> 
> > The next point in event points to
> > first_event (which can be NULL).  And first should always point
> > to event, otherwise we potentially never queue anything up?  I.e.
> > we never ever actually set first?  Not sure how that is related
> > to umount.
> 
> xfs_healthmon_push will set first_event if the list is empty.
> 
> (for context, all other events are _pushed on to the end of the list)
> 
> > Maybe this should just use standard list_head-based lists even
> > if they waste an extra pointer in the event structure?
> 
> Yes, that at least wouldn't increase the size of xfs_healthmon_event.

I think we should do this.  And merge __xfs_healthmon_push and
__xfs_healthmon_insert that has a at_head argument to switch between
list_add vs list_add_tail.  Thart would make this code much easier
to understand and maintain.

