Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1039038AbdDUMSo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Apr 2017 08:18:44 -0400
Date: Fri, 21 Apr 2017 08:18:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: push buffer of flush locked dquot to avoid
 quotacheck deadlock
Message-ID: <20170421121842.GC3487@bfoster.bfoster>
References: <1487966001-63263-3-git-send-email-bfoster@redhat.com>
 <20170410050001.GI23007@dastard>
 <20170410141521.GB3991@bfoster.bfoster>
 <20170410235525.GA12369@dastard>
 <20170411145300.GA12111@bfoster.bfoster>
 <20170418023548.GX17542@dastard>
 <20170418135529.GA46764@bfoster.bfoster>
 <20170419024649.GG12369@dastard>
 <20170419195519.GC5205@birch.djwong.org>
 <20170419204646.GB42820@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419204646.GB42820@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>

On Wed, Apr 19, 2017 at 04:46:46PM -0400, Brian Foster wrote:
> On Wed, Apr 19, 2017 at 12:55:19PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 19, 2017 at 12:46:49PM +1000, Dave Chinner wrote:
> > > On Tue, Apr 18, 2017 at 09:55:31AM -0400, Brian Foster wrote:
> > > > On Tue, Apr 18, 2017 at 12:35:48PM +1000, Dave Chinner wrote:
> > > > > On Tue, Apr 11, 2017 at 10:53:03AM -0400, Brian Foster wrote:
> > > > > > On Tue, Apr 11, 2017 at 09:55:25AM +1000, Dave Chinner wrote:
> > > > > > > So why can't we just modify the dquot in the buffer?  We already
> > > > > > > hold all the locks needed to guarantee exclusive access to the dquot
> > > > > > > and buffer, and they are all we hold when we do the initial flush to
> > > > > > > the buffer. So why do we need to do IO to unlock the dquot flush
> > > > > > > lock when we could just rewrite before we submit the buffer for IO?
> > > > > > > 
> > > > > > 
> > > > > > Are you suggesting to essentially ignore the flush lock? I suppose we
> > > > > > could get away with this in dq_flush_one() since it is only called from
> > > > > > quotacheck, but we may have to kill off any assertions that expect the
> > > > > > flush lock in xfs_dqflush(), and perhaps refactor that code to accept a
> > > > > > locked buffer as a param.
> > > > > 
> > > > > No, I'm not suggesting we ignore the flush lock. What the flush
> > > > > "lock" does is prevent higher layer attempts to flush the dquot to
> > > > > the backing buffer whilst IO may be in progress. It's higher level
> > > > > function is to allows async log item state updates to be done
> > > > > correctly w.r.t. relogging and flushing, as we allow transactional
> > > > > modifications to inodes and dquots while they are under IO.
> > > > > 
> > > > 
> > > > Ok. What I was trying to recall previously was some discussion around
> > > > the flush lock retry problem where it was noted that we can't unlock the
> > > > flush lock until the currently flushed state makes it to disk[1]. Is the
> > > > conceptual difference here that we are not proposing to unlock the flush
> > > > lock, but rather co-opt it to perform another flush?
> > > 
> > > I wouldn't use that wording, but you've got the idea.
> > > 
> > > [...]
> > > 
> > > > > > I don't see anything that would break off hand, but my first reaction is
> > > > > > it sounds more hackish than this patch or the previous patch that just
> > > > > > disabled reclaim during quotacheck.
> > > > > 
> > > > > I thought we'd done that discussion. i.e. we can't disable reclaim
> > > > > in quotacheck because that can set off the OOM killer...
> > > > > 
> > > > 
> > > > Huh? The only reason disabling of dquot reclaim during quotacheck was
> > > > proposed in the first place is because it is 100% superfluous.
> > > 
> > > ISTR that we broke dquot reclaim during quotacheck by moving to
> > > private delwri lists. I'm working under the impression that dquot
> > > reclaim during quotacheck used to work just fine. maybe I'm wrong,
> > > but ....
> > > 
> > > > Quotacheck, by design, does not allow reclaim to free memory. Therefore
> > > > reclaim does not and afaict never has prevented or even mitigated OOM
> > > > during quotacheck.
> > > 
> > > .... the intent has always been to allow dquot reclaim to run when
> > > quotacheck is active because we've had our fair share of OOM
> > > problems in quotacheck over the past 10 years. Bugs notwithstanding,
> > > we really should be trying to ensure the code fulfils that intent
> > > rather than sweep it under the carpet and tell users "too bad, so
> > > sad" when quotacheck OOMs...
> > > 
> > > [...]
> > > 
> > > > P.S., To be completely clear of my position on this issue at this
> > > > point... given the amount of time I've already spent responding to
> > > > handwavy arguments (ultimately resulting in discussing trailing off
> > > > until a repost occurs), or experimenting with a known bogus quotacheck
> > > > rework (which is still left without feedback, I believe), etc.,
> > > > clarification on the correctness of this alternate approach (while
> > > > interesting) is not nearly convincing enough for me to start over on
> > > > this bug. I don't mind handwavy questions if the "caller" is receptive
> > > > to or attempting to process (or debate) clarification, but I don't get
> > > > the impression that is the case here.
> > > > 
> > > > If you feel strongly enough about a certain approach, feel free to just
> > > > send a patch. At this point, I'm happy to help review anything from the
> > > > sole perspective of technical correctness (regardless of whether the I
> > > > think the approach is ugly), but I'm not personally wasting any more
> > > > time than I already have to implement and test such an approach without
> > > > a more logical and convincing argument. IMO, the feedback to this patch
> > > > doesn't fairly or reasonably justify the level of pushback.
> > > 
> > > I just responded to the code that was posted, pointing out a
> > > list of things that concerned me and, I thought, we've been working
> > > through that quite amicably.
> > > 
> > > Really, it is up to the maintainer whether to merge the code or not.
> > > That's not me - I'm now just someone who knows the code and it's
> > > history.  This is where the maintainer needs to step in and make a
> > > decision one way or the other....
> > 
> > So I do have a few (more) comments:
> > 
> > The first point I have to make is that the quotacheck OOM still seems to
> > happen infrequently, so at the point that this thread started going, I
> > was (and still am) fine with letting the discussion continue until we
> > run out of questions. :)
> > 
> > As far as the patch itself goes, it took me a while to figure out what's
> > going on with the delwri buffer list shuffling.  The part where the
> > buffer comes back from xfs_buf_delwri_submit_buffers during _pushbuf
> > still attached to a delwri queue and yet we still have to re-add the
> > DELWRI_Q flag raised my eyebrows.  I thought it was a little odd, but
> > in those particular circumstances (quotacheck and reclaim) I didn't find
> > anything that made me think it would fail, even if it probably wasn't
> > what the designers had in mind.
> > 
> > However, Dave's comments inspired me to take a second look.  Sorry if
> > this has been covered already, but what if dquot_isolate noticed when
> > xfs_buf_delwri_queue doesn't actually put the buffer on isol->buffers
> > (i.e. something else already put it on another delwri queue, which
> > afaict only happens during quotacheck?) and simply dqfunlock's the
> > buffer?  Reclaim will have already formatted the in-core dquot into the
> > on-disk buffer and can free the dquot, and quotacheck is still on the
> > hook to issue the IO.  (FWIW even that doesn't quite smell right since
> > it seems weird to push metadata to the buffer layer but someone else
> > writes it to disk.)
> > 
> 
> FWIW, I did also consider something similar on the reclaim side of
> things. Not to unlock the flush lock (I think we don't generally unlock
> a flush lock until state reaches disk, even though technically it may
> not be a problem from quotacheck context), but to avoid acquiring it in
> the first place if the underlying buffer appeared to already belong on a
> delwri queue (or something along those lines).
> 
> I don't recall the exact details off the top of my head, but I didn't
> like how it turned out enough such that it never turned into something
> post-worthy (I may still have that around somewhere, though).
> 

I don't appear to have any code around for the above, unfortunately.
Having thought about this a bit more, I think one of the reasons I
didn't prefer that approach (or the latest alternative proposal) is that
all things being equal, I'd rather not complicate external, core
infrastructure bits of code such as reclaim or dquot flushing with a
hack that is only necessary to deal with quotacheck.

IOW, the problem is primarily with the quotacheck implementation, so IMO
the most appropriate place for whatever hacks are necessary to make it
work correctly is in quotacheck itself. Then it's more straightforward
to improve the whole implementation going forward (and possibly replace
or remove the code being added here), rather than have to reassess
whatever hacks we've sprinkled elsewhere in the codebase.

That's just my .02, of course. v3 incoming...

Brian

> > In any case, it would be helpful to document how the delwri queues work,
> > whether or not the list is allowed to change, and what relation the
> > _XBF_DELWRI_Q flag has to the value of b_list.  For example, I didn't
> > know that one wasn't supposed to bounce buffers between lists.  Can that
> > documentation be part of whatever patch series we end up committing,
> > please?
> > 
> 
> I'm not aware of any such limitation.
> 
> > (It's hard for me to make decisions when I know I don't have enough info...)
> > 
> > Also, I think Brian said that he'd post updated patches with at least a
> > fix to a problem with dropped xfs_buf_delwri_pushbuf return codes, so
> > I'd still like to see that.
> > 
> 
> That was my intent, though I realized I haven't even made those changes
> locally yet because this appears to be going nowhere fast, afaict. I can
> post another update if that is actually useful, however.
> 
> (As noted in my previous mail, though, I don't really expect you to
> consider merging a patch with outstanding objections.)
> 
> Brian
> 
> > As far as testing goes I'm happ(ier) that /one/ of the original
> > complainants says that he could move on with the patches applied.  I
> > haven't observed any breakage w/ xfstests, though that doesn't prove it
> > right.
> > 
> > --D
> > 
> > > 
> > > -Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
