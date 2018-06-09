Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753092AbeFIL0U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Jun 2018 07:26:20 -0400
Date: Sat, 9 Jun 2018 07:26:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: allow delwri requeue of wait listed buffers
Message-ID: <20180609112617.GA2166@bfoster>
References: <20180607124125.38700-1-bfoster@redhat.com>
 <20180607124125.38700-3-bfoster@redhat.com>
 <20180607232713.GV10363@dastard>
 <20180608120709.GA23628@bfoster>
 <20180608224909.GC10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180608224909.GC10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jun 09, 2018 at 08:49:09AM +1000, Dave Chinner wrote:
> On Fri, Jun 08, 2018 at 08:07:09AM -0400, Brian Foster wrote:
> > On Fri, Jun 08, 2018 at 09:27:13AM +1000, Dave Chinner wrote:
> > > On Thu, Jun 07, 2018 at 08:41:25AM -0400, Brian Foster wrote:
> > > > If a delwri queue occurs of a buffer that was previously submitted
> > > > from a delwri queue but has not yet been removed from a wait list,
> > > > the queue sets _XBF_DELWRI_Q without changing the state of ->b_list.
> > > > This occurs, for example, if another thread beats the submitter
> > > > thread to the buffer lock after I/O completion. Once the submitter
> > > > acquires the lock, it removes the buffer from the wait list and
> > > > leaves a buffer with _XBF_DELWRI_Q set but not populated on a list.
> > > > This results in a lost buffer submission and in turn can result in
> > > > assert failures due to _XBF_DELWRI_Q being set on buffer reclaim or
> > > > filesystem lockups if the buffer happens to cover an item in the
> > > > AIL.
> > > 
> > > I just so happened to have this ASSERT happen over night on
> > > generic/232 testing some code I wrote yesterday. It never ceases to
> > > amaze me how bugs that have been around for ages always seem to be
> > > hit at the same time by different people in completely different
> > > contexts....
> > > 
> > 
> > Interesting, out of curiosity was this in a memory limited environment?
> 
> No. had GBs of free RAM, but it's on a fakenuma setup so a node
> could have been low on free memory and hence running the quota
> shrinker....
> 

Ok.

> ....
> > > This seems all a bit broken.
> > 
> > Yes, the premise of this was to do something that didn't break it
> > further. ;) I figured using sync I/O would also address the problem, but
> > would introduce terrible submission->completion serialization...
> 
> *nod*
> 
> > So essentially take apart sync buffer I/O so we can do batched
> > submission/completion. That sounds like a nice idea to me.
> 
> *nod*
> 
> > Feedback on the code to follow. That aside, are you planning to turn
> > this into a real patch submission or would you like me to do it?
> 
> I've got plenty of other things to do - if you want to take it an
> run I'm fine with that :P
> 

Heh, no problem. I'll work this into something next week and throw some
testing at it. Thanks for getting it started.

Brian

> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index a9678c2f3810..40f441e96dc5 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -1453,27 +1453,20 @@ _xfs_buf_ioapply(
> > >  }
> > >  
> > >  /*
> > > - * Asynchronous IO submission path. This transfers the buffer lock ownership and
> > > - * the current reference to the IO. It is not safe to reference the buffer after
> > > - * a call to this function unless the caller holds an additional reference
> > > - * itself.
> > > + * Internal I/O submission helpers for split submission and waiting actions.
> > >   */
> > > -void
> > > -xfs_buf_submit(
> > > +static int
> > > +__xfs_buf_submit(
> > 
> > It looks like the buffer submission refactoring could be a separate
> > patch from the delwri queue race fix.
> 
> Yup, it probably should be.
> 
> > > @@ -1483,12 +1476,8 @@ xfs_buf_submit(
> > >  	bp->b_io_error = 0;
> > >  
> > >  	/*
> > > -	 * The caller's reference is released during I/O completion.
> > > -	 * This occurs some time after the last b_io_remaining reference is
> > > -	 * released, so after we drop our Io reference we have to have some
> > > -	 * other reference to ensure the buffer doesn't go away from underneath
> > > -	 * us. Take a direct reference to ensure we have safe access to the
> > > -	 * buffer until we are finished with it.
> > > +	 * I/O needs a reference, because the caller may go away before we are
> > > +	 * done with the IO. Completion will deal with it.
> > >  	 */
> > >  	xfs_buf_hold(bp);
> > 
> > I think this should be lifted in the callers. For one, it's confusing to
> > follow.
> 
> Both paths take a reference here, both take it because the IO itself
> needs a reference. The only difference is when it is dropped.
> 
> > Second, it looks like xfs_buf_submit() unconditionally drops a
> > reference whereas __xfs_buf_submit() may not acquire one (i.e. when we
> > return an error).
> >
> > ISTM that the buffer reference calls could be balanced in the top-level
> > submit functions rather than split between the common submission path
> > and unique sync completion path.
> 
> Yes, that may end up being cleaner, because the delwri path has to
> take a reference across submit/complete anyway. I just chopped
> quickl away at the code without thinking about this stuff too
> deeply. I did say "untested", right? :P
> 
> > >  void *
> > > @@ -2045,14 +2035,21 @@ xfs_buf_delwri_submit_buffers(
> > >  		 * at this point so the caller can still access it.
> > >  		 */
> > >  		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
> > > -		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
> > > +		bp->b_flags |= XBF_WRITE;
> > 
> > We set XBF_ASYNC below in the specific case, but this doesn't tell us
> > anything about whether it might have already been set on the buffer. Is
> > it not the responsibility of this function to set/clear XBF_ASYNC
> > appropriately?
> 
> XBF_ASYNC should be clear (as the buffer is not under IO) buti, yes,
> I agree that it would be a good idea to clear it anyway.
> 
> > >  		if (wait_list) {
> > > +			/*
> > > +			 * Split synchronous IO - we wait later, so we need ai
> > > +			 * reference until we run completion processing and drop
> > > +			 * the buffer lock ourselves
> > > +			 */
> > 
> > Might as well merge this with the comment above, which needs fixing
> > anyways since we no longer "do all IO submission async."
> > 
> > >  			xfs_buf_hold(bp);
> > 
> > I think the buffer reference counting is now broken here.
> 
> More than likely. :P
> 
> ....
> > >  			list_move_tail(&bp->b_list, wait_list);
> > > -		} else
> > > +			__xfs_buf_submit(bp);
> > 
> > I suspect we need to handle submission errors here, otherwise we wait on
> > a buffer that was never submitted.
> 
> Yup.
> 
> > One final thought.. ISTM that the nature of batched sync buffer
> > submission means that once we wait on one or two of those buffers,
> > there's a good chance many of the remaining buffer physical I/Os will
> > have completed by the time we get to the associated iowait. That means
> > that the current behavior of large (sync) delwri buffer completions
> > running in the async completion workqueue most likely changes to running
> > from __xfs_buf_iowait()->xfs_buf_ioend() context. I'm not sure that
> > really matters, but just something to note.
> 
> Yup, that's something that crossed my mind. But we only wait for
> buffers to complete in log recovery, quota check and the /quota
> shrinker/ (now the generic/232 failure makes sense, doesn't it? :).
> 
> Hence I don't think there's a performance issue we need to worry
> about - correctness is more important...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
