Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E5A2F7EF5;
	Tue, 25 Aug 2026 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787682790; cv=none; b=klpftLtEjBNEdvTepTeQkZb+PeLniPuAs0fHHuPB2Xl5uQvDTyvOF4MqQLLb+24FRNz2jYztF0yTZBoQ80uPUtpBrQ/EHc9tEt4PiWh7/ozypK1wMuaM3ucDXpKL39Vh0xJF6NybUwm4odkNpl5/95l7AK9+3iSAUD8I5u8o0V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787682790; c=relaxed/simple;
	bh=4K01LHN6qb5PtX6z6TN1QScw5jNk4evkNGwp0rqp8Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fS8yk16oXXn9Q53Rc2FQBHEdzyYESdrFbe5ThN/fRV1MvGsS1BYArffJQjNCP91CgwsmWBK+dgZo9DlLfpLKZyYFXs/Mlk386EByTApvSeSbJN421onjT2MBZZXLR6aTjzRQWb9U/F6zTVU83qDxVXIBWrsZG5rrAlAzSic9w8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ptgcm8q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ptgcm8q0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EA0E21F000E9;
	Tue, 25 Aug 2026 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787682789;
	bh=E4pjEVfIBYcDkbvVtMTqNuQnn3UBD9+nNXnxWS4ELdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ptgcm8q0P8Q2kAi1T1huXYgjtAY5fGGe90vLLCHn8DrvNMpUnd1YRf5xDyYLINRYX
	 C3DHX8pf46WNGOJC8MH4eftUrJYDQnyppOqpJHuL+As04VzTx057otS0wPOb2Q+tBp
	 jhnax1SqD0SEsU9eoMzKztgyixdx3YAyPwsPhE3hX6+lMMEl81A3jzjdPvhOAniJhy
	 uHqq9IP2gtWgJNHyXmoMEm196ugEhUTpfdMrGp9YtL59i5z11JNWRSedf4yRxXMHb+
	 99N+EJajwC39Vk8sadOFmDMAUtWbF9JAdM+ILU7bHDb5fhbUAqoTji8tgHpX86Aco1
	 NVFOpcZkGVM6w==
Date: Tue, 25 Aug 2026 11:33:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: always set xfs_healthmon::first_event when
 inserting at front of list
Message-ID: <20260825183308.GW6072@frogsfrogsfrogs>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
 <178760941102.944364.11828316232110118627.stgit@frogsfrogsfrogs>
 <20260825064017.GA24532@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825064017.GA24532@lst.de>

On Tue, Aug 25, 2026 at 08:40:17AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 10:36:12PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM complains that __xfs_healthmon_insert purports to insert a
> > xfs_healthmon_event event at the start of the event list, but neglects
> > to update first_event to point to the unmount event if there were
> > already events in the queue.  That results in list corruption, so let's
> > fix this problem.
> 
> I can't really follow this..

Let me try again:

"LOLLM complains that while __xfs_healthmon_insert is supposed to insert
an event at the head of the list, it doesn't do that correctly if the
list isn't empty.  In that case it *should* make our new event point to
the current head, and then make the head point to the new event, but
it doesn't actually update the head."

> > diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> > index d8b95af33a3e9f..166ef0d5864486 100644
> > --- a/fs/xfs/xfs_healthmon.c
> > +++ b/fs/xfs/xfs_healthmon.c
> > @@ -276,8 +276,7 @@ __xfs_healthmon_insert(
> >  	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
> >  
> >  	event->next = hm->first_event;
> > -	if (!hm->first_event)
> > -		hm->first_event = event;
> > +	hm->first_event = event;
> >  	if (!hm->last_event)
> >  		hm->last_event = event;
> 
> event is the newly inserted event.  We want to queue it at the
> head of the list (why, btw?).

The only event that gets inserted at the front is the unmount event.
This signals that the filesystem is being completely unmounted (not just
detached from a mount ns) and there's nothing further that xfs_healer
can do to fix the filesystem.  Therefore we put the unmount item first
in the list so that xfs_healer won't waste time trying to find the
mount to do repairs that it won't be able to make.

> The next point in event points to
> first_event (which can be NULL).  And first should always point
> to event, otherwise we potentially never queue anything up?  I.e.
> we never ever actually set first?  Not sure how that is related
> to umount.

xfs_healthmon_push will set first_event if the list is empty.

(for context, all other events are _pushed on to the end of the list)

> Maybe this should just use standard list_head-based lists even
> if they waste an extra pointer in the event structure?

Yes, that at least wouldn't increase the size of xfs_healthmon_event.

--D
