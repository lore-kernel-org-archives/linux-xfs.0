Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752804AbdEXN0J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 09:26:09 -0400
Date: Wed, 24 May 2017 15:26:04 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170524132604.bsti3quyepmbzjzv@eorzea.usersys.redhat.com>
References: <20170519002227.GS17542@dastard>
 <20170519112659.GB64091@bfoster.bfoster>
 <20170519233900.GT17542@dastard>
 <20170520114654.GA3888@bfoster.bfoster>
 <20170521231906.GU17542@dastard>
 <20170522125110.GA11578@bfoster.bfoster>
 <20170523112318.GX17542@dastard>
 <20170523162202.GB7632@bfoster.bfoster>
 <20170524010601.GX12369@dastard>
 <20170524124244.GA11089@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170524124244.GA11089@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, May 24, 2017 at 08:42:47AM -0400, Brian Foster wrote:
> On Wed, May 24, 2017 at 11:06:01AM +1000, Dave Chinner wrote:
> > On Tue, May 23, 2017 at 12:22:04PM -0400, Brian Foster wrote:
> > > On Tue, May 23, 2017 at 09:23:18PM +1000, Dave Chinner wrote:
> > > > On Mon, May 22, 2017 at 08:51:13AM -0400, Brian Foster wrote:
> > > > > On Mon, May 22, 2017 at 09:19:06AM +1000, Dave Chinner wrote:
> > > > > > On Sat, May 20, 2017 at 07:46:56AM -0400, Brian Foster wrote:
> > > > > > > On Sat, May 20, 2017 at 09:39:00AM +1000, Dave Chinner wrote:
> > > > > > > > Adding new flags to the same field that can be asynchronously
> > > > > > > > updated by RMW operations outside the ailp->xa_lock will cause
> > > > > > > > problems in future. There *may not* be a problem right now, but it
> > > > > > > > is poor programming practice to have different coherency processes
> > > > > > > > for the same variable that is updated via RMW operations. In these
> > > > > > > > situations, the only safe way to update the variable is to use an
> > > > > > > > atomic operation.
> > > > > > > > 
> > > > > > > 
> > > > > > > So is there a reason why we couldn't acquire ->xa_lock to fail the log
> > > > > > > items as we would have done anyways if the metadata writeback had
> > > > > > > succeeded and we were removing the log items from the AIL..
> > > > > > 
> > > > > > Yes. the alip->xa_lock protects AIL state is a highly contended
> > > > > > lock. It should not be used for things that aren't AIL related
> > > > > > because that will have performance and scalability implications.
> > > > > > 
> > > > > 
> > > > > The purpose of this flag is to control AIL retry processing, how is this
> > > > > not AIL related?
> > > > 
> > > > It's IO state, not AIL state. IO submission occurs from more places
> > > > than and AIL push (e.g. inode reclaim, inode clustering, etc) and
> > > > there's no way we should be exposing the internal AIL state lock in
> > > > places like that.
> > > > 
> > > 
> > > That's reasonable, though it suggests different code from what this
> > > patchset currently does. This would be far more useful if we could focus
> > > on correctness of the code first and foremost. If the code we commit
> > > actually warrants this kind of change, then this becomes a much easier
> > > (i.e., pointless :P) discussion from my end.
> > 
> > Hmmm - this is not the first time recently you've said something
> > similar in a review discussion where you didn't like this issues
> > have been pointed out. Last time is was "handwavey", now it's
> > "pointless". We haven't worked out a solution that solves all the
> > known problems, so these sorts of comments really don't help close
> > on one....
> > 
> 
> You misinterpret what I wrote. What I am saying is that _my_ argument
> would become pointless if you could provide context around what locking
> specifically leads to your performance/scalability concern.
> 
> I.e., just above you refer to taking the AIL lock in various places that
> are not modified by this patch. Since this patch does not touch those
> areas, I can only assume you see something wrong with the patch that
> would actually require locking or some additional changes in those
> areas. If that is the case, and you could explicitly point out where/why
> that extra locking is necessary, then that would clearly undermine my
> argument that there is no risk of performance degradation here. Instead,
> you are just asserting that there is additional lock contention and I'm
> kind of left guessing where these mysterious ->xa_lock acquisitions are,
> because I haven't suggested using it anywhere outside of I/O completion.
> 
> Indeed, from this most recent mail, ISTM that your concern comes from
> the implication that AIL locking would be required in various other I/O
> submission contexts to clear the failed flags. More on that below...
> 
> (And I don't see what any of this has to do with the quotacheck deadlock
> thing.)
> 
> > > As it is, this patch only ever clears the flag on AIL resubmission. ISTM
> > > you are indirectly suggesting that should occur in other contexts as
> > > well (e.g., consider a reclaim and flush of another inode backed by a
> > > buffer that is already failed, and has other inodes sitting in the AIL
> > > flush locked). If that is the case, please elaborate, because otherwise
> > > it is kind of impossible to evaluate and discuss without specifics.
> > 
> > All I've done is take the deadlock scenario you pointed
> > out and applied to it other places we block on the flush lock.
> > 
> 
> Ok...
> 
> > Go look at inode reclaim - it can do blocking reclaim and so will
> > block on the flush lock. How is this code supposed to handle hitting
> > a failed, flush locked inode?  If it just blocks, then it's a likely
> > deadlock vector as you've already pointed out. Hence we'll need the
> > same failed write checks to trigger buffer resubmission before we
> > retry the inode reclaim process.
> > 
> 
> I'm aware we take the flush lock there, but I'm not convinced that is a
> deadlock vector. AFAICT, nothing in that callpath blocks the subsequent
> AIL retries from occurring. If that AIL retry eventually succeeds, this
> all unwinds and we carry on as normal.
> 
> If _blocking_ as such is a problem for the codepath in question, then
> that seems like more of a question of whether a trylock is more
> appropriate.
> 
> > [....]
> > 
> > > As it is, this patch would only add an acquisition of ->xa_lock in
> > > completion context on I/O failure. Exactly what workload would you
> > > expect to be affected by changes to I/O error handling? How would it be
> > > any different than what we already do on normal I/O completion?
> > 
> > If you want to check and clear the failed flag in the log item in a
> > non-racy way  in IO submission (because we have to do this outside
> > the flush lock) then we'd have to hold the AIL lock. And that means
> > the AIL lock is then in the hot path of inode flushing in all
> > situations, not just in IO completion.
> > 
> 
> Personally, I have no specific desire to clear the failed flags in I/O
> submission context as a general solution. The AIL retry originally did
> that as a sort of an optimization to avoid looking up the buffer for
> every flush locked inode (rightly and based on your suggestion).
> 
> This appears to have clouded the fact that we still need to clear the
> failed flag on successful I/O completion (I thought I called that out on
> a previous iteration, but I've lost track so maybe not. I also haven't
> got to Carlos' latest version.).
> 
> Conditionally relying on clearing the failed flag from submission
> context (as this patch does) is not sufficient because it is still
> possible to modify and flush an inode to an already failed buffer (and
> thus the buffer has pre-existing failed inodes). If an AIL push ended up
> resubmitting the buffer due to the newly flushed/notfailed inode, it
> never clears the failed flags on the other inodes attached to the
> buffer. I haven't combed through all of the codepaths there, but I
> wouldn't be surprised to see a data loss bug lurking in there. (Note
> again that this is based on the code in this patch.)
> 
> This _could_ imply that all submission contexts need to unconditionally
> check for and clear failed items on the buffer or that the buffer needs
> a flag too, but it would be much more simple and straightforward to
> clear the flag after successful I/O completion (when ->xa_lock is
> already held). This avoids the need for extra flags or serialization
> requirements. To be fair, this _may_ require an additional ->xa_lock
> cycle on I/O completion to clear the flag from relogged items so they
> are flushed correctly again on a subsequent push (without having left
> the AIL), but again, that should only occur after an I/O error has
> occurred.
> 
> [NOTE: After reading the rest of the email and coming back here, I see
> you suggested the same notion of clearing the flag after I/O success in
> your flush lock rework idea, so I suspect I'm not totally off the rails
> here. ;)]
> 
> If that all works, there is no need to acquire the AIL lock in any
> context we don't already have it in general. Again, if I'm missing
> something there, please point it out.
> 
> > We've known for a long time that the AIL lock is the second most
> > contended lock in the filesystem (behind the CIL context lock), and
> > that it is most heavily contended on inode IO completion because
> > completion runs on the CPU that the interrupt is delivered to and
> > so the AIL lock gets contended from multiple CPUs at once on
> > multi-disk filesystems (see xfs_iflush_done() for more info).
> > As such, we do not want to increase it's use anywhere in the inode
> > IO submission/completion path at all if we can possibly avoid it.
> > 
> 
> Understood and agreed. But as mentioned previously, I've not suggested
> taking ->xa_lock anywhere else outside of when I/O errors occur and so
> performance in general is not affected.
> 
> > So with all the problems that leaving failed inodes flush locked
> > presents, I'm starting to think that the inode failed callback
> > should remove the inode from the buffer and drop the flush lock
> > rather than leave it held and attached to the buffer. We can check
> > the LI_FAILED flag in xfs_iflush_int() and simply skip the inode
> > flush to the buffer to effectively "resubmit" the inode unchanged.
> > If we then clear the LI_FAILED flag in xfs_iflush_done() (i.e. only
> > when a successful write occurs), we don't need to jump through hoops
> > to clear the flag at IO submission time. We'd probably also need a
> > failed flag on the buffer (maybe with a hold ref, too) so that it
> > isn't reclaimed by memory pressure while we have inodes in the
> > failed state pending writeback.
> > 
> 
> A couple thoughts... first on the idea itself and second on the
> trajectory of this particular patch series.
> 
> 1.) Interesting idea. Some of my initial questions/thoughts on the idea
> itself...
> 
> It's not clear to me how we'd manage whether a failed (and
> flush-unlocked) inode has been subsequently modified and actually needs
> to be flushed again. I'm also not following how we'd propagate
> successful completion state back to the parent inodes if they had been
> previously removed from the buffer due to an I/O failure.
> 
> It sounds like this _may_ conflict with providing a generic solution to
> this problem (i.e., we have to fix this problem for dquots as well, and
> hence this patch is focused on providing a generic solution). Is that
> not the case, or would we have to repeat this pattern for every flush
> locked item?
> 
> Finally, I'm a bit skeptical that it's wise to provide such a
> fundamental shift in flush locking behavior based on the rare case of an
> I/O error. That means every case that currently acquires a flush lock
> has a new state to consider (IOW, we've effectively changed the meaning
> of the lock). My experience is that our error handling
> testing/regression capabilities are fairly poor as it is (which I don't
> think is something unique to us), and thus error path regressions are
> generally easier to introduce and tend to go undetected for quite some
> time (how long has AIL retry been broken? ;).
> 
> Of course, this is just a first impression and could all be alleviated
> with further discussion and/or code.
> 
> 2.) Independent of whether we want to do something like the above, I
> disagree with the premise that this series causes any new problems with
> regard to flush locked metadata items (as explained above). It is
> focused on fixing a particular AIL retry bug in the uncommon I/O error
> case within the AIL retry framework that has been in place for quite
> some time. Once the kinks are worked out, I think this is now very close
> to fixing that bug succinctly, correctly and without any performance
> side effects.
> 
> As such, I would very much prefer that we actually make progress on
> fixing this specific bug before moving on to the new shiny design that
> redefines flush locking. If there are still fundamental flush lock
> issues beyond what this patch is intended to fix, we can address those
> incrementally and rework flush locking along with LI_FAILED handling on
> top of a known working base provided by this patch. At the absolute very
> least, I'd prefer that we work out the remaining kinks in this patchset
> (even if it is not ultimately merged) to provide a common reference for
> a correct solution. If there is a hard technical impasse with this fix,
> then that would at least help Carlos and I understand where the actual
> problems lie.
> 
> That's just my .02 and is ultimately contingent on Carlos' preferred
> approach, since he's the one doing the heavy lifting here (though I
> suspect he would also prefer the incremental approach).
> 
> Brian

I need to give some more thinking about Dave's suggestion on this new flush
locking design Dave suggested. This really looks a nice idea that needs some
polish before the implementation, and I can certainly work on that, but, from my
POV, I'll agree with Brian here.

Reworking in the flush lock design will take time, more discussions, more
patches, etc. In the mean time, we have an increasing number in users hitting
this bug, with the increasing usage of DM-Thin, this tends to increase quick,
once, the bug is easily triggered when using dm-thin.

The unmount hang is just one of the symptoms of the problem, but there are
several other things that go wrong and might be unnoticed by the user. The
unmount is the most noticeable symptom an user will see, and I believe we can
just polish what needed to be polished on my patchset, fix the bug, then move on
and I'll work on this design Dave suggested.

My patchset shouldn't introduce any new bug or regression (saving it still needs
that a successful IO completion clears the LI_FAILED flag), and fixes a bug that
is appearing more and more often in a reasonable way.

Then I move on and look over the design Dave mentioned, instead of stick with
this bug in the code for... who knows how longer.

Anyway, I'm not trying to 'sell my fish' here saying this patchset is the best
solution, I'm far away from doing things like that, but this patchset uses the
approach we took weeks to decide, then, why not use this now, fix the bug and
improve it when at least users are not hitting the bug anymore?

Cheers.


> 
> > This leaves the rest of the submission code completely unchanged -
> > including the write clustering.  It also gets rid of all the flush
> > lock deadlock scenarios because we always unlock the flush lock on
> > IO completion, regardless of whether the buffer IO succeeded or not.
> > ANd we don't have to change any infrastructure, either - it all just
> > works as it is because the LI_FAILED flag is handled at the lowest
> > levels possible.
> > 
> > This, to me, seems like a far cleaner solution than anything we've
> > discussed so far....
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
