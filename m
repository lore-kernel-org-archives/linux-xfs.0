Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 May 2008 22:31:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m475UY7F003494
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 22:30:36 -0700
Date: Wed, 7 May 2008 15:31:08 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: question about xfs_alloc_fix_freelist()
Message-ID: <20080507053108.GV103491721@sgi.com>
References: <20080504235048.GC155679365@sgi.com> <4820CBF5.8090206@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4820CBF5.8090206@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, May 06, 2008 at 02:21:57PM -0700, Michael Nishimoto wrote:
> David Chinner wrote:
> >On Fri, May 02, 2008 at 02:01:47PM -0700, Michael Nishimoto wrote:
> > >
> > > The following code can be found near the end of xfs_alloc_fix_freelist:
> > >
> > >                 if (targs.agbno == NULLAGBLOCK) {
> > >                         if (flags & XFS_ALLOC_FLAG_FREEING)
> > >                                 break;
> > >                         xfs_trans_brelse(tp, agflbp);
> > >                         args->agbp = NULL;
> > >                         return 0;
> > >                 }
> > >
> > > Don't we need to release agbp too by calling xfs_trans_brelse(tp, agbp)?
> >
> >I don't think so. AFAICT, The agbp (agf block) is linked into the
> >transaction and by this point we may have modified the AGF (think
> >multiple iterations of the loop to fill the free list). Given that
> >it may be modified, we shouldn't release it here but instead allow
> >the transaction commit/abort to do that for us at the appropriate
> >time.
> 
> I understood that the transaction abort code will free resources/locks
> when passing back an error.  However, by returning args->agbp = NULL,
> aren't we telling the calling code that we have not satisfied the request
> in the current AG?

Yes.

> I do see the part of about the AGF possibly getting modified.
> 
> It would help to have a clear comment description of possible inputs vs.
> expected outputs for this function. :-)

Like a lot of code, not just XFS. :/

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
