Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755008AbeDPNdW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Apr 2018 09:33:22 -0400
Date: Mon, 16 Apr 2018 09:33:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/7] xfs: allow attach of dfops to transaction
Message-ID: <20180416133316.GA21136@bfoster.bfoster>
References: <20180410174631.4915-1-bfoster@redhat.com>
 <20180410174631.4915-3-bfoster@redhat.com>
 <20180415074400.GB5226@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180415074400.GB5226@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Sun, Apr 15, 2018 at 12:44:00AM -0700, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 087fea02c389..f3aef54257d1 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -525,6 +525,7 @@ xfs_defer_init_op_type(
> >  /* Initialize a deferred operation. */
> >  void
> >  xfs_defer_init(
> > +	struct xfs_trans		*tp,
> >  	struct xfs_defer_ops		*dop,
> >  	xfs_fsblock_t			*fbp)
> >  {
> > @@ -532,5 +533,7 @@ xfs_defer_init(
> >  	*fbp = NULLFSBLOCK;
> >  	INIT_LIST_HEAD(&dop->dop_intake);
> >  	INIT_LIST_HEAD(&dop->dop_pending);
> > -	trace_xfs_defer_init(NULL, dop);
> > +	if (tp)
> > +		tp->t_dfops = dop;
> > +	trace_xfs_defer_init(tp ? tp->t_mountp : NULL, dop);
> 
> there is really no oint un doing this massive change of prototypes
> everywhere just to move an assignment into xfs_defer_init.  Just keep
> that assignment in the caller.
> 

I was doing that in the previous versions and thought this might be more
clear in terms of ensuring new code initialized structures properly.
That said, I don't much care which approach is used so I can change it
back and (potentially) revisit when more code is switched over.

> 
> But in general I'm really concerned about making the dops in the
> transaction conditional behavior.  This is just going down the rathole
> of inconsistent behavior where some callers expect it in the transaction
> vs other explcitit and every time something really to defered ops is
> touched it will need a deep code audit.  I'd rather switch everything
> over in a go and be done with it.

Deep code audit, eh? :/ There is no such confusion in the allocator
context because there's only one way to pass the dfops: in the
transaction. The reason for doing this is essentially to optimize the
step out of manually passing down the dfops and then immediately
refactoring all that cruft out because the needed dfops-passing
callchains currently don't exist.

The purpose of this patchset is a functional fix: defer AGFL frees to
reduce tx reservation overuse from problematic contexts. It introduces
the concept of the broader refactoring (that Dave proposed on a previous
version, IIRC) purely for the scope of the fix. For example, consider
that ->t_dfops were renamed to something like ->t_agfl_dfops for the
purpose of this patch series.

Not using the transaction means we'd have to pass dfops manually into
the allocator and deep into the btree code (via da_args and btree
cursors). I could technically do that, but it creates a bunch of ugly
code that results in the same functional logic/behavior of this patch
series as is and essentially is a waste of time.

The temporary confusion that does remain is the inconsistency that some
callchains use ->t_dfops while others do not (yet). The reason/fix for
that is mostly aesthetic/mechanical and so really shouldn't be that
confusing IMO. I certainly don't think that justifies plumbing dfops
through manually only to delete it in followup patches. We could try to
reduce that confusion by dropping the xfs_defer_init() bits and renaming
->t_dfops as noted above, but note that technically drops the other
dfops-passing callchain cleanups in the series because ->t_agfl_dfops
should only be used for AGFL fixups. That would have to go away until
->t_agfl_dfops were renamed back to ->t_dfops, but would further
separate the refactoring from the functional change without creating
unnecessary work. Thoughts?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
