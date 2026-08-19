Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADC93B27D6
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 20:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787170315; cv=none; b=da0xtkewkzzBNVqtVDZcAiKvMWEuojBkMaw8hyaISRQdrZg8Dz0wY26aX6UDlXtlB6Jgn1ObqunhbJ0i36CIcw96QS/Y40+IeL/sqVRutgz1PMVek8Dena2cT/UmqvRWdVELS580a5Bk4ftNr93dDRriR5mXXn+4nhWs3Q9mTVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787170315; c=relaxed/simple;
	bh=XRBeurOgXAVd0MaHMkVvwW/6NKgz7Qu5uo/yWzWhryQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAzGta2w45ZYkGqS8BY23AOvKHM1+EpX4ZFF7YspMf3jzIeU7V4Bwo6BRs3SyH/noQYUE767Z6izru8HhOtuzkLaDhTUMwKgPhkwJEvJmfxVE9i0FdwFSCFBH96tH6NFJvlh/iwvskeWFH9fLeIKN6LWUQWvZL74OWHk48N+rbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGSFhvIV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGSFhvIV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787170312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zBnfwUazkP6Ln1CCvglQANThPj56vBgOkhvC1fKSUFw=;
	b=BGSFhvIV24MC1qgJ5OrJGLgmDwXguvdOpARhV+ijSBJgZE72gMgVQlLfSjHero5LjIYpKv
	wW5kPLkp/MMKXb0Kwaho/xlnaU4mUO/pOEowqbokooNTqrBjw0FpNyyuohdK8Pgb0Aapq6
	VxS1fNidB1qA8ucJFBDsclS+1V6neSE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-fxZGSTh9NmWYG1R2lSSD4w-1; Wed,
 19 Aug 2026 16:11:40 -0400
X-MC-Unique: fxZGSTh9NmWYG1R2lSSD4w-1
X-Mimecast-MFC-AGG-ID: fxZGSTh9NmWYG1R2lSSD4w_1787170299
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B02D919560AD;
	Wed, 19 Aug 2026 20:11:39 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB2D6423;
	Wed, 19 Aug 2026 20:11:38 +0000 (UTC)
Date: Wed, 19 Aug 2026 16:11:36 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH v2 1/3] xfs: set minleft correctly for sparse chunk
 errortag allocation
Message-ID: <aoYN-HbYzFXNfXXY@bfoster>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-2-bfoster@redhat.com>
 <aoOKYRBTK7ocCBrY@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoOKYRBTK7ocCBrY@dread>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Tue, Aug 18, 2026 at 08:25:37AM +1000, Dave Chinner wrote:
> On Fri, Aug 14, 2026 at 09:22:37AM -0400, Brian Foster wrote:
> > The errortag instrumentation for forced sparse chunk allocation
> > jumps straight to the allocation path without setting args.minleft.
> > minleft is unconditionally set to ->inobt_maxlevels for the normal
> > allocation path. Lift the assignment to the initial args setup so
> > it covers all possible paths.
> > 
> > Assisted-by: LLM
> > Fixes: 1cdadee11f8d ("xfs: randomly do sparse inode allocations in DEBUG mode")
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index ffcdd1f691fd..633b2d6e42c5 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -733,6 +733,10 @@ xfs_ialloc_ag_alloc(
> >  							igeo->maxicount)
> >  		return -ENOSPC;
> >  	args.minlen = args.maxlen = igeo->ialloc_blks;
> > +
> > +	/* Allow space for the inode btree to split. */
> > +	args.minleft = igeo->inobt_maxlevels;
> 
> As an extra question: is that reservation even correct? We can split
> both the inobt and the finobt on insert, and this only reserves
> space for a inobt split....
> 

I think I mentioned in one of the earlier postings that finobt is
covered by the metadata perag res, so minleft isn't necessary. One of
the longer term ideas worth considering is to perhaps revisit why inobt
blocks aren't reserved and see if it's worth doing that.

> Secondly, why always reserve space for a max level split? The amount
> we need is depedent on the current level of the btree, and for all
> other btree types our reservations are based on the current level.
> i.e. we know the math needed to make this dependent on current btree
> levels, and we know that we are inserting into multiple btrees of
> different heights here, so maybe we should fix this reservation
> whilst we are here, too?
> 

I thought the reason we do this historically is because we haven't
selected an AG at this point, but that could be wrong. The current code
looks like it has the AGI buffer at this point at least, so technically
I think we could tailor minleft to the current AG if we wanted to.

That said, I'm skeptical of the value for one.. how many blocks would we
expect to make available in the best case? Enough for an extra chunk or
two? Second, I really don't want to turn this into a squeeze more blocks
out of -ENOSPC exercise so if we do want to dig into something like
this, I'd prefer to defer it to a follow on series.

Brian

> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 

