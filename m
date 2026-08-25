Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC4D175A83;
	Tue, 25 Aug 2026 18:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787683020; cv=none; b=Rjw0MYC5sKqTAa9QsVgn7ZMmst6KrxHVHAZyycnIVkVh2vYD+MtRL+Dyb7i9oxABSrEddsLdwNkaTkioBuJOsy2812OHtKB5OIkFvRNweiyWNwwSEIqFILrW5sPowoHu/LFZWvnPYjW3x0+22iSBHZlbF5eSwGR2aPYT7k04E70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787683020; c=relaxed/simple;
	bh=uumKQFEa3kqhuvOY1+xLfH5sjjFkfcwFT6v/fbDM/Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4xn1rDKwelkl+9urIdIIXJyTfNOKTeu1qq5EtjpSQ5btzRxjVZuuro/Uoa2nrWAv6aLy5juaMqX+7FBeyJUYkGdp1EImYlaZiyXfDqD3qqtmvbOqKt3tTr/DU9kqKkBE0vJ8MOQY1LT5Qmn+JVmu5qePxSdG+109nGaqVdm9VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovMSEDum; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovMSEDum"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 732091F000E9;
	Tue, 25 Aug 2026 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787683018;
	bh=chZvNI5OrdFGzbSM2PHYoGX8WICYk+h0imPyR6BDYFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ovMSEDumbYipvyHK/cBSEzEK7TT3lNqLfKUoa6m7i+Rmgbwm7MS0GORFUfWUNenQE
	 kfjPSQmwlJz/memxuEq53cL7FGFqMfW+4mmdHhbozuR1f6WJ/tzxsOdHTPX+3WhoYp
	 YvjrqYkhVYszG2v57IXSnfCkiPfJ5PV5qQac6gjgAKm4JDzlfyGOQHvvdqb7/z0GHK
	 kpPVQ5c7cpCivV9bUeIA7JoAdlMJRr3KTWYbfc1IGNZSF9NG2rFYOOQkXd87kFWW5h
	 H4fvpYPiw7gSorHVfgbwsfF4Nd3f0QdAspgu8HJmEJEYmm6sPHHM7F1+3g88XOU5lM
	 QD9ffWdUrY6GA==
Date: Tue, 25 Aug 2026 11:36:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: check healthmon outbuffer space correctly
Message-ID: <20260825183658.GX6072@frogsfrogsfrogs>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
 <178760941123.944364.14413050986149192404.stgit@frogsfrogsfrogs>
 <20260825064451.GB24532@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825064451.GB24532@lst.de>

On Tue, Aug 25, 2026 at 08:44:51AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 10:36:28PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM notices that the outbuf space check in xfs_healthmon_format_pop
> > isn't quite correct -- it checks that there's enough space to write a
> > xfs_healthmon_event object, but the outbuffer is supposed to contain
> > xfs_health_monitor_event objects.  Fix this by adding a helper, and
> > refactoring all three outbuf size checks to use it.
> > 
> > Cc: <stable@vger.kernel.org> # v7.0
> > Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Assisted-by: LOLLM # finding obvious bugs
> > ---
> >  fs/xfs/xfs_healthmon.c |   16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> > index 166ef0d5864486..a2ae15a262a510 100644
> > --- a/fs/xfs/xfs_healthmon.c
> > +++ b/fs/xfs/xfs_healthmon.c
> > @@ -739,6 +739,12 @@ static const unsigned int type_map[] = {
> >  	[XFS_HEALTHMON_DATALOST]	= XFS_HEALTH_MONITOR_TYPE_DATALOST,
> >  };
> >  
> > +static inline bool
> > +xfs_healthmon_check_outbuffer_space(const struct xfs_healthmon *hm)
> > +{
> > +	return hm->bufhead + sizeof(struct xfs_health_monitor_event) <= hm->bufsize;
> 
> Overly long line.

Will fix.

> >  		memcpy(hm->buffer + hm->bufhead, &hme, sizeof(hme));
> >  		hm->bufhead += sizeof(hme);
> >  	}
> > @@ -891,7 +897,11 @@ xfs_healthmon_format_pop(
> >  {
> >  	struct xfs_healthmon_event *event;
> >  
> > -	if (hm->bufhead + sizeof(*event) > hm->bufsize)
> > +	/*
> > +	 * Don't bother if there's not enough space to format even one event in
> > +	 * the outbuffer.
> > +	 */
> > +	if (!xfs_healthmon_check_outbuffer_space(hm))
> >  		return NULL;
> >  
> >  	mutex_lock(&hm->lock);
> 
> This is a bit annoying as we now require the type name instead of an
> object, and the v0 implies there could be other formats.  But I guess
> for now it is fine..

<nod> v0 is the only format, eventually that helper would end up looking
like this:

static inline bool
xfs_healthmon_check_outbuffer_space(const struct xfs_healthmon *hm)
{
	size_t	event_sz = 0;

	switch (hm->format) {
	case XFS_HEALTHMON_V0:
		event_sz = sizeof(struct xfs_health_monitor_event);
		break;
	case XFS_HEALTHMON_V1:
		event_sz = sizeof(struct xfs_health_monitor_event_v1);
		break;
	default:
		ASSERT(0);
		break;
	}

	return hm->bufhead + event_sz <= hm->bufsize;
}

--D
