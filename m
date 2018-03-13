Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752411AbeCML1a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Mar 2018 07:27:30 -0400
Date: Tue, 13 Mar 2018 07:27:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: convert between packed and unpacked agfls
 on-demand
Message-ID: <20180313112724.GA33955@bfoster.bfoster>
References: <20180308140354.pk25gd54cqjzbecs@odin.usersys.redhat.com>
 <20180309131628.GA3445@bfoster.bfoster>
 <20180309173318.GD18989@magnolia>
 <20180309183727.GA17046@bfoster.bfoster>
 <20180309190832.GH18989@magnolia>
 <20180309212031.GA19019@bfoster.bfoster>
 <20180309223757.GA4865@magnolia>
 <20180312131157.GA29810@bfoster.bfoster>
 <20180312173552.GA30332@bfoster.bfoster>
 <20180312211455.GY18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180312211455.GY18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Tue, Mar 13, 2018 at 08:14:55AM +1100, Dave Chinner wrote:
> On Mon, Mar 12, 2018 at 01:35:53PM -0400, Brian Foster wrote:
> > On Mon, Mar 12, 2018 at 09:11:58AM -0400, Brian Foster wrote:
> > > On Fri, Mar 09, 2018 at 02:37:57PM -0800, Darrick J. Wong wrote:
> > > > On Fri, Mar 09, 2018 at 04:20:31PM -0500, Brian Foster wrote:
> > > > > On Fri, Mar 09, 2018 at 11:08:32AM -0800, Darrick J. Wong wrote:
> > > > > > On Fri, Mar 09, 2018 at 01:37:28PM -0500, Brian Foster wrote:
> > > > > > > On Fri, Mar 09, 2018 at 09:33:18AM -0800, Darrick J. Wong wrote:
> > ...
> > > > <nod> I've been mulling over rewriting your previous rfc patch that put
> > > > all the scanning/lifting in {get,put}_freelist but having it reset the
> > > > agfl instead of doing the swizzling stuff.
> > > > 
> > > 
> > > Something to be careful of... emptying the agfl obviously means the
> > > subsequent fixup is a btree block allocation. That may limit the context
> > > of where the fixup can be performed. IOW, deferring it to
> > > _get_freelist() might no longer be safe. Instead, I think we'd have to
> > > implement it such that the on-disk flcount is completely untrusted when
> > > the mismatch is detected.
> > > 
> > ...
> > 
> > Here's a variant of that patch that does a reset. It's definitely much
> > simpler. Thoughts?
> 
> I like it - it is so much simpler than the other proposals, and it's
> done on demand rather than by a brute-force mount/unmount scan.
> 
> > Brian
> > 
> > --- 8< ---
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index c02781a4c091..7d313bb4677d 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2053,6 +2053,59 @@ xfs_alloc_space_available(
> >  	return true;
> >  }
> >  
> > +static bool
> > +xfs_agf_verify_flcount(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_agf		*agf)
> 
> Needs a comment explaining what it's checking and the return value.
> Might actually read better as "xfs_agf_need_flcount_reset()"
> returning true if fixup is required, especially at the caller
> site...
> 

I changed it from something like that (see the original patch), but more
just because I expected the simpler logic would now cover more general
things than just the padding issue rather than any technical reason. The
_need_reset() name probably accomplishes the same thing so I'll go back
to the earlier logic.

I plan to add some actual comments and fix up the warning message into
something more usable.

> > +{
> > +	int			f = be32_to_cpu(agf->agf_flfirst);
> > +	int			l = be32_to_cpu(agf->agf_fllast);
> > +	int			c = be32_to_cpu(agf->agf_flcount);
> 
> These should probably be uint32_t - they are unsigned on disk.
> 

Ok.

> > +	int			active = c;
> > +	int			agfl_size = XFS_AGFL_SIZE(mp);
> > +
> > +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> > +		return true;
> > +
> > +	if (c && l >= f)
> > +		active = l - f + 1;
> > +	else if (c)
> > +		active = agfl_size - f + l + 1;
> 
> 	else
> 		active = 0;
> 
> To move all the initialisation of active into the one logic
> statement and not make it dependent on the original value in the
> AGF?
> 

I think that should work.

> > +	if (active != c)
> > +		return false;
> > +	if (f >= agfl_size || l >= agfl_size)
> > +		return false;
> 
> Shouldn't we be range checking these first? Also should probably
> checking c the same way.
> 

I'll move the l/f checks to before the active calculation.

We can also add a check for c > agfl_size but note that technically
these are superfluous checks because they are checked in the read
verifier. The f/l range checks were there to cover the case of a packed
-> unpacked conversion. That would also require a downstream read
verifier tweak to handle a +1 sized valid agfl range. The verifier tweak
is not included here because going backwards as such is not something we
want to support upstream.

IOW, the read verifier dictates a subset of general agfl corruption that
this fixup is allowed to handle. All that said, the extra checks don't
hurt and it's probably smart to consistently check the fields we're
going to feed into calculations. I'll add a count check with a comment
for added context.

> > +
> > +	return true;
> > +}
> > +
...
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 945de08af7ba..678d602dc400 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3339,6 +3339,24 @@ TRACE_EVENT(xfs_trans_resv_calc,
> >  		  __entry->logflags)
> >  );
> >  
> > +TRACE_EVENT(xfs_agfl_reset,
> > +	TP_PROTO(struct xfs_perag *pag),
> > +	TP_ARGS(pag),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(int, flcount)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = pag->pag_mount->m_super->s_dev;
> > +		__entry->agno = pag->pag_agno;
> > +		__entry->flcount = pag->pagf_flcount;
> > +	),
> > +	TP_printk("dev %d:%d agno %u flcount %d",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->agno, __entry->flcount)
> > +);
> 
> Do we need a new tracepoint? Wouldn't it be better to just
> call trace_xfs_agf() which will dump all the information in the AGF
> just before we do the reset? We'll know it's a reset from the caller
> information that is dumped by that tracepoint....
> 

Yeah, I missed that tracepoint. I may see if I can turn that into an
event class so we can still use a unique name. trace_xfs_agf() looks
like it refers to logging the agf which is already triggered by this
path after we reset the agfl pointers. Otherwise I'll just add a
pre-reset call so we have the original field values.

Thanks for the feedback..

Brian

> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
