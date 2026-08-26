Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C18B35E1A3;
	Wed, 26 Aug 2026 04:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787720083; cv=none; b=ADDoJc9Qq1H9NCBUXHmMKXO8iG/GyewYd76CroGptO3EWAmZ50ASbvdqUW0zAKUb+lyXM/HJzv1Ze+9Q+3YWVrYwEw/SokpkggzGkIYEC0+inPKsAgqAsK+HKp3SyMnRscHFf0vMxIucoBUJ3bzb8tD5MRnjMGvLpz3ZXTJK3S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787720083; c=relaxed/simple;
	bh=5wbD3cyqrv2jjPC9tljM0veoE09XMATfDTSMCe3gqfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6gG0UkMX4YGuLSZjEEsLrvFQ62vgkNP58RW+4XR9ws88GGq11iQ5DzgbF3/2yh+PCzWzPNzhDt2DAAT0FVcWTiZSNdY822Xc5dc4lyb+0+IBF4LdomX9uZwDe8KZ7RgNLbmRi5RHmfuimE47S2fmOm/7fgB/ZBWbhYmHRUPIqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxVIsuL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxVIsuL3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 611A11F000E9;
	Wed, 26 Aug 2026 04:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787720072;
	bh=EfKRCaZYYqk4e8Gg/7xhVyvD0+YDQw4Q78I18i2Jn8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oxVIsuL3HzYtPG366E/Uifqa5DisbQRmdFlLCwrjR5xqAhLt7KcczBlEUUBgVIzv3
	 UzDON6y+60cC2OQnrGkMz8DhvtzAnwMBPIktakTmHXgPI729YbSlNQiXE/TqUOXUnd
	 BJum3TWbaUok5NbaKIywhPX7BTx+YnzlspytsFl7DbD/nrkmqM9bV2iJp9x0iEs64M
	 /zj1RZI6yLAzc6yN3UpFtX0+zJ8gVZPl/whNek0Hr0utWfHq/zrhBNoXLFwMvSnmUZ
	 FF1HHDnF40UdI5syI7EpqCRhj7wItrJvHR9mcZTyX/Rg9DrhWg8pJSKKY1XaEMGv21
	 0H+4eBP8N/q2w==
Date: Tue, 25 Aug 2026 21:54:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: always set xfs_healthmon::first_event when
 inserting at front of list
Message-ID: <20260826045432.GB2114998@frogsfrogsfrogs>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
 <178760941102.944364.11828316232110118627.stgit@frogsfrogsfrogs>
 <20260825064017.GA24532@lst.de>
 <20260825183308.GW6072@frogsfrogsfrogs>
 <20260826044820.GC14936@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826044820.GC14936@lst.de>

On Wed, Aug 26, 2026 at 06:48:20AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 25, 2026 at 11:33:08AM -0700, Darrick J. Wong wrote:
> > Let me try again:
> > 
> > "LOLLM complains that while __xfs_healthmon_insert is supposed to insert
> > an event at the head of the list, it doesn't do that correctly if the
> > list isn't empty.  In that case it *should* make our new event point to
> > the current head, and then make the head point to the new event, but
> > it doesn't actually update the head."
> 
> > > event is the newly inserted event.  We want to queue it at the
> > > head of the list (why, btw?).
> > 
> > The only event that gets inserted at the front is the unmount event.
> > This signals that the filesystem is being completely unmounted (not just
> > detached from a mount ns) and there's nothing further that xfs_healer
> > can do to fix the filesystem.  Therefore we put the unmount item first
> > in the list so that xfs_healer won't waste time trying to find the
> > mount to do repairs that it won't be able to make.
> 
> Ok, me forgetting about two different ways to insert events was the
> reason I had a really hard time with the commit log.

<nod>

> > 
> > > The next point in event points to
> > > first_event (which can be NULL).  And first should always point
> > > to event, otherwise we potentially never queue anything up?  I.e.
> > > we never ever actually set first?  Not sure how that is related
> > > to umount.
> > 
> > xfs_healthmon_push will set first_event if the list is empty.
> > 
> > (for context, all other events are _pushed on to the end of the list)
> > 
> > > Maybe this should just use standard list_head-based lists even
> > > if they waste an extra pointer in the event structure?
> > 
> > Yes, that at least wouldn't increase the size of xfs_healthmon_event.
> 
> I think we should do this.  And merge __xfs_healthmon_push and
> __xfs_healthmon_insert that has a at_head argument to switch between
> list_add vs list_add_tail.  Thart would make this code much easier
> to understand and maintain.

Ok.  Do you want me to mash the list conversion into this patch?  Or
just do the bare fix here and the list_head stuff in the next patch?

--D
