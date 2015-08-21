Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AAA47F56
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 09:39:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F7BB8F8035
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 07:39:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id L2ekhITnCgAjSwUi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 07:39:28 -0700 (PDT)
Date: Fri, 21 Aug 2015 10:39:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: v5 filesystem corruption due to log recovery lsn ordering
Message-ID: <20150821143923.GC46372@bfoster.bfoster>
References: <20150819183904.GB49174@bfoster.bfoster>
	<20150819224453.GL3902@dastard>
	<20150820162529.GB13033@bfoster.bfoster>
	<20150821003449.GU714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150821003449.GU714@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 21, 2015 at 10:34:49AM +1000, Dave Chinner wrote:
> On Thu, Aug 20, 2015 at 12:25:29PM -0400, Brian Foster wrote:
> > On Thu, Aug 20, 2015 at 08:44:53AM +1000, Dave Chinner wrote:
> > > On Wed, Aug 19, 2015 at 02:39:05PM -0400, Brian Foster wrote:
...
> > Using the inode chunk allocation and inode modification example...
> > clearly the transactions have to commit in order because the inodes must
> > be allocated before they can be used/modified. At what point after that
> > is reordering possible? Are we talking about reordering of the items
> > from the cil/log buffers to the on-disk log, or reordering of the items
> > during recovery (or both)?
> 
> Both. Look at inode allocation buffers, which are pinned in the AIL
> so they can't be moved forward by subsequent modifications (e.g.
> inode unlinks) until the newly initialised buffers have been written
> to disk. Look at them again in log recovery, where they are
> re-ordered to the start of a transaction so they are replayed before
> inode log items and inode unlink buffer operations.
> 

Thanks, I'll dig into this...

... 
> 
> Most users won't/can't upgrade to a kernel that will solve the
> problem - it's often much easier to get them a userspace package
> that minimises their exposure to a problem caused by their current
> userspace package....
> 

Perhaps... I think it's debateable that it's caused by the userspace
package, but I really don't care as much where it's fixed as opposed to
that the overall fix is comprehensive.

I wasn't initially expecting a userspace fix because the recovery
reordering mechanism seemed like the problem. A userspace change seems
reasonable with the approach of maintaining the current log recovery
behavior and fixing up the current LSN such that it is always correct.

> > > Then, on the kernel side, we need is a reliable way to detect that
> > > the log head/tail pointers have been reset in the kernel. This means
> > > we can - at minimum - issue a warning during log recovery that this
> > > has been detected.
> > > 
> > > Finally, we need to work out how to handle recovery in the situation
> > > that the log has been zeroed and the filesystem has a mix of new and
> > > old, stale LSNs. I think the simplest way around this is not to
> > > handle it in log recovery at all, but to avoid it altogether.
> > > 
> > > That is, when we find the log head/tail point to a zeroed log, we
> > > pull the current LSN from, say, the superblock (and maybe other
> > > metadata such as AG headers) and initialise the log head/tail to the
> > > cycle number + some offset so that every new transaction is
> > > guaranteed to have a cycle number more recent than any other LSN in
> > > the filesystem and ordering is preserved, even if the log has been
> > > zeroed.
> > > 
> > 
> > That's an interesting idea, but I wonder if it truly fixes the problem
> > or just makes it potentially more difficult to reproduce. One concern is
> > that even with this in place, all it takes to reintroduce the problem is
> > for a filesystem to run a bit on an older kernel in a situation where
> > the LSN is reset and enough modification has occurred to update whatever
> > key metadata we determine as important with the reset LSNs.
> 
> We can't prevent that - that horse has already bolted.
> 

Well, the feature bit can potentially do that. I'm not terribly fond of
it (overkill) and the goal was't to fix older kernels so much as to
prevent the problem from being reintroduced on newer kernels going
forward (provided newer kernels implemented this mount-time LSN
inheritance scheme).

In other words, the proposed solution depends on trust of the metadata
LSNs. One way we can trust those metadata LSNs is to prevent older
kernels/xfsprogs from messing with them.

> > A mount
> > alone is enough to pollute the superblock in this manner. Further
> > modification is probably necessary to affect the agi/agf headers,
> > however. It might not be the most likely scenario, but what is more
> > concerning is that if it does occur, it's completely invisible to our
> > detection on updated kernels. Would we want to consider a new
> > ro-incompat feature bit for this mechanism to prevent that?
> 
> We could, but preventing people from downgrading from new kernels
> because of a problem 99.9% of current users are never going to see?
> And with a fixed and upgraded userspace, it will be problem that
> they'll never see, either?
> 

I'm just trying to explore what might be necessary for a comprehensive
fix, even if we didn't ultimately implement all the way through (e.g.,
if it wasn't worth the usability/compatibility tradeoffs, etc.).

That said, I don't really agree with the assertion that upgraded
userspace alone sufficiently alleviates the problem. A filesystem that's
been around a while and has more recently been repaired is susceptible
to this problem for the foreseeable future, upgraded userspace or not,
until either all metadata with stale LSNs is updated or the problem is
identified and repaired explicitly.

> > Another concern is that we're assuming that the key metadata will always
> > have the most recent LSN. I think the closest thing to a guarantee we
> > have of that is the superblock being updated on umount and every so
> > often by xfs_log_worker() to cover the log. After a bit of playing
> > around, I'm not so sure that is enough.
> 
> Sure, I just threw it out as a way to get a more recent LSN. The
> only way to reliably get the highest LSN is to walk all the metadata
> in the filesystem. We can't do that at mount time, so perhaps it
> is best to just refuse to mount read-write and issue a warning to
> upgrade xfsprogs and re-run xfs_repair.
> 

Indeed, that sounds like a nicer approach to me. We're really only
considering the superblock at mount time though (note that repair resets
AG header LSNs), so we're not going to be guaranteed the mount fails for
all affected fs'. What do you think about also firing a (one-time,
probably) warning if we ever update a bit of metadata with a smaller
LSN?

That bit of metadata is now "fixed" once written out, but the point is
that the log item for this metadata was probably not effective and to
notify the user that the fs' LSNs are potentially out of whack and a
repair is in order.

> > So now we have reset the LSN according to the log. Presumably the mount
> > now inspects the superblock and each AG header and inherits the largest
> > LSN plus some offset as the current LSN: LSN X+N. Directory d2 still has
> > LSN Y, however, and we have no guarantee that N > Y-X. In other words, I
> > think we can end up right back where we started. Make a modification to
> > directory d2 at this point, crash the fs, and recovery might or might
> > not replay a log record with LSN X+N against a target directory buffer
> > with LSN Y.
> 
> These scenarios all result from running xfs_repair. It's the source
> of the problem, so let's treat it primarily as a bug in xfs_repair.
> The number of users that run xfs_repair are very small compared to
> the wider user-base, so having the kernel say "upgrade xfsprogs
> and repair" is probably the most reliable way to fix the problem.
> 

That sounds fine to me.

> So, to repair: have it record LSNs as it walks the metadata and
> at the start of phase 5 have it select a new cycle number higher
> than the highest LSN found in the filesystem. Stamp the log with
> that cycle number as well as all metadata that is being rebuilt
> in phase 5, and all the superblocks.
> 
> Problem solved.
> 

Yeah, I was thinking of just using the current head of the log, as
described in my random note. Using the LSN from the metadata is probably
necessary in the cases where the log might be corrupted, however.

> > Again, that's a contrived and probably unlikely scenario, but could be
> > extremely difficult to detect or root cause if it ever does occur. :/
> > Thoughts? Is there something further we can do to mitigate this, or am I
> > missing something else?
> 
> IMO, you're over-complicating the situation. We can't go back and
> change history, nor make people upgrade to systems that won't suffer
> from this problem. Hence we're just going to have to live with it,
> just like all the other log recovery bugs we've lived with since
> finding and fixing them.
> 
> If we do the simple thing and just detect zeroed logs in the kernel
> and refuse read-write mounts, that's something we can easily
> backport to all stable kernels that we support CRCs on (i.e. 3.16 to
> present). And with a fixed xfs_repair, the problem goes away as
> users and distros pull new in the new package, even if they are
> running old kernels.
> 

The situation is what it is, I'm just trying to cover all the angles. :)
I'm not claiming to have the right fix, so don't read too much into my
initial ideas. I'm throwing those out there hoping you'll come up with
improvements. ;) As noted above, the goal was not explicitly to prevent
downgrading and things as opposed to preventing the problem going
forward (e.g., if an fs can't be mounted with an old kernel, then it
can't be broken in this manner for newer kernels).

The solution of detection in the kernel and a fix in repair sounds
pretty good to me provided the detection is robust (e.g., the point
above wrt a warning). Then we have something in current kernels that can
effectively handle the problem regardless of how it might have been
(re)introduced and it's fairly simple as well.

> > Also, a random thought: I wonder if an update to the log zeroing
> > mechanism to ensure that a subsequent mount picked up the LSN where it
> > left off would be enough to get around much of this. That could mean
> > stamping the log appropriately in repair, or adding something like a new
> > continue_lsn field in the superblock to be used by anybody who zeroes
> > the log and picked up on the next mount, etc...
> 
> Sure - that's just a variant my first suggestion (of don't zero the
> log in xfs_repair). Remember that you said "I don't think that helps
> us very much". :)
> 

The first suggestion was to not zero the log by default as a means of
problem mitigation. I still don't think that helps us very much. :)
(IMO, neither does doing the above without the kernel detection side of
things.)

In fact, I think we've reached a prospective solution that technically
could preserve the current repair log clearing behavior. At least, I
view that as a separate change at this point. The only difference now is
that "clearing the log" means to stamp in log records that effectively
bookmark the current LSN for v5 filesystems.

As usual, thanks for the feedback.

Brian

> And, FWIW, my "read the LSN from metadata and use the highest" idea
> above is just a further refinement of the two, so we can fix
> zeroed logs from existing xfs_repair binaries without needing to do
> anything extra in the kernel other than detect a zeroed log...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
