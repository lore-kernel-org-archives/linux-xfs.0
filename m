Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035C83CB2C7
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 20:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787170449; cv=none; b=Trhlp2cikptN1JsXNU9oaE2TpqvL6hYsWWj+h53P5xGK2UvS+W1+T958nxIgiCx3okd+y3PoI6lqYBtlvZtiNE1bkDHjQXatInOwdd+la5xYKK3cZALcrHOuHbTY9mkTPjKxm3f2GcPyVjTLTnXNw2owsoGNVJdzShYi6EbjThk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787170449; c=relaxed/simple;
	bh=JfqQAK49hHm/aZ6BXAUkM+aeuTni6pxo1R1dX3StElQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7YMCzsZmW42+Lx54prVbZkblenVc+D4V2q8VQYg8IQhX3saxMUOzplDQ827vQt2K60ilwzQdk8ZD9IcUjxkGOvcNEauP1MZJK9avTmObdWbzjj2K40isaS5ue5FkFFPo19V0O2mOYrhb6tuPUD9vankN2trdQcnUa+Tc9+b5lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ak1Wk1uv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ak1Wk1uv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787170446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BpEoXoFdee0J2Zeip9BnsJ55Kgo2M/aTeF0gJCUQdGM=;
	b=ak1Wk1uvA7+JdIUEiya0xnftO7Oqt3tMXQi3qQty9zG8yBae+NS0AOMuySMlOyIoGVFuq2
	ZGTmY3Bwc36m18DO+FhSOZO/Ig8govXN+pEm6LqrLyVj+pvZvDnBIZxnUdXGcZvII2lV5t
	LrFro3FVi1geynWeI88ts8ZjnallyHE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-548--4jSALLbN2qobUGFO-txcw-1; Wed,
 19 Aug 2026 16:14:03 -0400
X-MC-Unique: -4jSALLbN2qobUGFO-txcw-1
X-Mimecast-MFC-AGG-ID: -4jSALLbN2qobUGFO-txcw_1787170442
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07BB31955F7A;
	Wed, 19 Aug 2026 20:14:02 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B4027D6;
	Wed, 19 Aug 2026 20:14:01 +0000 (UTC)
Date: Wed, 19 Aug 2026 16:13:58 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH v2 3/3] xfs: incorporate increased AGFL min requirement
 for minleft allocs
Message-ID: <aoYOho8hOXlbplQC@bfoster>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-4-bfoster@redhat.com>
 <aoORV3bgMqDs5rUC@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoORV3bgMqDs5rUC@dread>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Tue, Aug 18, 2026 at 08:55:19AM +1000, Dave Chinner wrote:
> On Fri, Aug 14, 2026 at 09:22:39AM -0400, Brian Foster wrote:
...
> > 
> > Reported-by: Matt Fleming <matt@readmodwrite.com>
> > Assisted-by: LLM
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 29 ++++++++++++++++++++++++++++-
> >  fs/xfs/libxfs/xfs_alloc.h |  2 ++
> >  fs/xfs/libxfs/xfs_bmap.c  |  2 +-
> >  3 files changed, 31 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index dbb85fb6314b..74c5b587c87b 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
...
> > @@ -2533,10 +2548,22 @@ xfs_alloc_space_available(
> >  	 * Do we have enough free space remaining for the allocation? Don't
> >  	 * account extra agfl blocks because we are about to defer free them,
> >  	 * making them unavailable until the current transaction commits.
> > +	 *
> > +	 * If minleft is set, this allocation might cause an allocbt split that
> > +	 * increases the AGFL minimum for the next allocation in the
> > +	 * transaction. Reserve that space from the available block count
> > +	 * (without prematurely growing the AGFL) to prevent the subsequent
> > +	 * allocation from failing due to an increased min_free requirement.
> >  	 */
> > +	minleft = args->minleft;
> > +	if (minleft) {
> > +		minleft += xfs_alloc_min_freelist_minleft(args->mp, pag) -
> > +					min_free;
> > +	}
> 
> This seems fragile to me. It is based on the assumption that
> min_free is calculated from xfs_alloc_min_freelist() by the caller,
> and then this calculates the difference between what the caller should
> have calculated and what is actually needed.
> 
> Where this mod is placed also results in the longest available
> extent check not taking into account this modified min_free
> requirement, whereas the check in xfs_bmap_longest_free_extent() is
> modified to take this modified minleft value into account. i.e. the
> checks w.r.t. minleft and longest extents are no longer consistent
> across the layers.
> 
> I'm also concerned that this results in the
> xfs_alloc_space_available() caller using different values of "need"
> and "minleft" to what the actual space availablity calculation is
> using; that feels like a future landmine to me.
> 

I agree in principle wrt the fragility. This is kind of what I meant by
expressing preference for something more elegant in the other subthread
conversation w/ Darrick; I just haven't quite figured out what that
looks like yet.

> i.e. the xfs_alloc_space_available() caller already knows is minleft
> is set, so if it were to use xfs_alloc_min_freelist_minleft(), then
> there would not need to be this "correction" in this code and all
> the values would be consistent.
> 
> Unless I'm missing something subtle, I think that the callers should
> not need to know it should call xfs_alloc_min_freelist_minleft() or
> xfs_alloc_min_freelist() as it feels like exposing internal AGFL
> space/btree accounting requirements into an external API. All the
> caller needs to signal is whether this is the first of a chain of
> allocations or not (i.e. args->minleft != 0), and the internal alloc
> code should handle it from there.
> 

I also agree wrt to the layering confusion, though I find that the
existing API also suffers a bit from this.

> Hence I suspect it would be much cleaner just to add a 'bool
> multialloc' parameter to xfs_alloc_min_freelist() and have all
> callers set it appropriately. That would avoid the need for the
> wrapper functions and keep this AGFL reservation wart
> completely internal to the AGFL reservation calculation....
> 
> Thoughts?
> 

If I follow correctly, this centralizes the extra level calculation to
_min_freelist(). I agree the code is cleaner, but the reason I didn't do
that is because this would artificially alloc and free blocks through
the AGFL for every such multi-allocation.

I.e., a multi-alloc comes in and we calculate the multi-level worst case
bump for each allocbt, set that to min_free, bump the AGFL to the new
min_free and carry on with the alloc. The common case is going to be no
new splits (and certainly not "everything splits"), so either the next
allocation in the multi-alloc (or the next alloc thereafter) will remove
every block that was added for splits that never occurred. So IMO the
tradeoff for cleaner code here is worse behavior.

Hmmm.. I suppose we could still implement this same sort of behavior
using a multi-alloc parameter. For example, suppose we replaced
xfs_alloc_min_freelist() with an xfs_alloc_freelist() that took your
multi-alloc param and returned a min and a max. The min is the current
return value, the max is the prospective worst case (i.e. min == max if
multi-alloc == false, else +1 level).

The internal alloc path passes both min/max to _space_available() so it
can do consistent max length checks and calculate/add the delta to
minleft for the available calculation. The AGFL min_free value is still
based on the min. The bmap case passes multi-alloc = true and uses the
max for its own length checks. Hm?

Brian

> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 

