Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCAAE7F6A
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 19:42:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C5FFAC009
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 17:42:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FpCM7O4g6AETtrYT for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 17:42:23 -0700 (PDT)
Date: Fri, 21 Aug 2015 10:34:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: v5 filesystem corruption due to log recovery lsn ordering
Message-ID: <20150821003449.GU714@dastard>
References: <20150819183904.GB49174@bfoster.bfoster>
	<20150819224453.GL3902@dastard>
	<20150820162529.GB13033@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150820162529.GB13033@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 20, 2015 at 12:25:29PM -0400, Brian Foster wrote:
> On Thu, Aug 20, 2015 at 08:44:53AM +1000, Dave Chinner wrote:
> > On Wed, Aug 19, 2015 at 02:39:05PM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > Here's another issue I've run into from recent log recovery testing...
> > > 
> > > Many on-disk data structures for v5 filesystems have the LSN from the
> > > last modification stamped the associated header. As of the following
> > > commit, log recovery compares the recovery item LSN against the LSN of
> > > the on-disk structure to avoid restoration of stale contents:
> > > 
> > >   50d5c8d xfs: check LSN ordering for v5 superblocks during recovery
> > > 
> > > This presumably addresses some problems where recovery of the stale
> > > contents leads to CRC failure. The problem here is that xfs_repair
> > > clears the log (even when the fs is clean) and resets the current LSN on
> > > the next mount. This creates a situation where logging is ineffective
> > > for any structure that has not yet been modified since the current LSN
> > > was reset.
> > 
> > Well, that was a bit of an oversight...
> > 
> > ....
> > 
> > > 
> > > The larger question is how to resolve this problem? I don't think this
> > > is something that is ultimately addressed in xfs_repair. Even if we
> > > stopped clearing the log, that doesn't help users who might have had to
stori> > > forcibly zero the log to recover a filesystem. Another option in theory
> > > might be to unconditionally reset the LSN of everything on disk, but
> > > that sounds like overkill just to preserve the current kernel
> > > workaround.
> > 
> > Well, it's relatively easy to detect a log that has been zeroed if
> > the cycle count is more than a cycle or two lower than the LSN in
> > important metadata, but I'm not sure we can reliably detect that.
> > 
> > > It sounds more to me that we have to adjust this behavior on the kernel
> > > side. That said, the original commit presumably addresses some log
> > > recovery shutdown problems that we do not want to reintroduce. I haven't
> > > yet wrapped my head around what that original problem was, but I wanted
> > > to get this reported. If the issue was early buffer I/O submission,
> > > perhaps we need a new mechanism to defer this I/O submission until a
> > > point that CRC verification is expected to pass (or otherwise generate a
> > > filesystem error)? Or perhaps do something similar with CRC
> > > verification? Any other thoughts, issues or things I might have missed
> > > here?
> > 
> > The issue that the LSN ordering fixes is that of unsynchronised
> > recovery of different log records that contain the same objects.
> > e.g. ordering of inode chunk allocation (in buffers) vs inode object
> > modification (in inode items). v4 filesystems have a serious problem
> > where inode chunk allocation can be run after the inode item
> > modifications, resulting in recovery "losing" file size updates that
> > sync flushed to the log.
> > 
> 
> Hmm, so I would have expected these kind of operations to generally
> occur in order. I'm clearly still missing some context on the overall
> log item lifecycle to understand how this might occur.

They do now for v5 filesystems - all the changes that led up to
where we are now got us to this point...

> Using the inode chunk allocation and inode modification example...
> clearly the transactions have to commit in order because the inodes must
> be allocated before they can be used/modified. At what point after that
> is reordering possible? Are we talking about reordering of the items
> from the cil/log buffers to the on-disk log, or reordering of the items
> during recovery (or both)?

Both. Look at inode allocation buffers, which are pinned in the AIL
so they can't be moved forward by subsequent modifications (e.g.
inode unlinks) until the newly initialised buffers have been written
to disk. Look at them again in log recovery, where they are
re-ordered to the start of a transaction so they are replayed before
inode log items and inode unlink buffer operations.

> > i.e. create just the right number of small files, sync, crash and
> > recovery gives a number of zero length files in certain inode chunks
> > because the ordering of item recovery was wrong.
> > 
> > Another problem with inode logging is the flushiter field, which is
> > used to try to avoid replaying changes in the log that have already
> > been flushed to disk. This could also lead to lost inode
> > modifications after a sync because the flushiter is reset to zero
> > after each time the inode item is recovered. This was mostly avoided
> > by logging all inode modifications and using delayed logging, but
> > could still occur...
> > 
> > There was a long history of these sorts of problems occurring (I
> > first analysed the inode allocation/inode item update failure mode
> > back in 2006), and I found several other possible issues like this
> > to do with the inode flushiter at the same time. I also suspected
> > that there were problems with directory recovery due to the same
> > inode item vs buffer item ordering issues, but could never pin them
> > down.
> > 
> > So the solution was to record the LSN of the last modification in
> > every item as it is written to disk, thereby ensuring we knew
> > exactly what transaction the item was last modified in. This means
> > we can skip modifications in transaction recovery that are already
> > on disk.
> > 
> 
> Given the reordering is possible (despite my lingering questions wrt to
> exactly how, above) this makes sense as a mechanism to address that
> problem.

Yup, that's what we have done in the past with hacks and algorithm
fixes. What the LSN stamping also gives us iis the freedom to move
beyond logging every change we make in full to the log. e.g. intent
based logging using ordered buffers that move through the AIL and
hence pin the log until they are written (e.g. swap extents BMBT
owner change).

> > ----
> > 
> > The first thing we need to do is not zero the log in xfs_repair when
> > the log is clean to minimise future exposure to this issue on
> > existing systems.
> > 
> 
> Eh, I'm not really sure this helps us that much. We still have to deal
> with the issue so long as current xfsprogs versions are out there. We
> also have no real way of knowing whether a filesystem could have been
> affected by the problem or not.

Yup, so let's take steps to ensure that the future xfsprogs don't
cause us problems, and then we can also tell users to upgrade
to the latest xfsprogs to solve the issue.

> FWIW, xfs_metadump also results in
> similar behavior, which means that technically it's possible for
> different behavior on a restored metadump from the original fs. That's
> less critical, but clearly not ideal and something to be aware of.

So we fix metadump, too.

> That said, I think it is somewhat strange for xfs_repair to zero the log
> unconditionally, this issue aside. So I'm not really against that change
> in general. I just think we need a kernel fix first and foremost.

Most users won't/can't upgrade to a kernel that will solve the
problem - it's often much easier to get them a userspace package
that minimises their exposure to a problem caused by their current
userspace package....

> > Then, on the kernel side, we need is a reliable way to detect that
> > the log head/tail pointers have been reset in the kernel. This means
> > we can - at minimum - issue a warning during log recovery that this
> > has been detected.
> > 
> > Finally, we need to work out how to handle recovery in the situation
> > that the log has been zeroed and the filesystem has a mix of new and
> > old, stale LSNs. I think the simplest way around this is not to
> > handle it in log recovery at all, but to avoid it altogether.
> > 
> > That is, when we find the log head/tail point to a zeroed log, we
> > pull the current LSN from, say, the superblock (and maybe other
> > metadata such as AG headers) and initialise the log head/tail to the
> > cycle number + some offset so that every new transaction is
> > guaranteed to have a cycle number more recent than any other LSN in
> > the filesystem and ordering is preserved, even if the log has been
> > zeroed.
> > 
> 
> That's an interesting idea, but I wonder if it truly fixes the problem
> or just makes it potentially more difficult to reproduce. One concern is
> that even with this in place, all it takes to reintroduce the problem is
> for a filesystem to run a bit on an older kernel in a situation where
> the LSN is reset and enough modification has occurred to update whatever
> key metadata we determine as important with the reset LSNs.

We can't prevent that - that horse has already bolted.

> A mount
> alone is enough to pollute the superblock in this manner. Further
> modification is probably necessary to affect the agi/agf headers,
> however. It might not be the most likely scenario, but what is more
> concerning is that if it does occur, it's completely invisible to our
> detection on updated kernels. Would we want to consider a new
> ro-incompat feature bit for this mechanism to prevent that?

We could, but preventing people from downgrading from new kernels
because of a problem 99.9% of current users are never going to see?
And with a fixed and upgraded userspace, it will be problem that
they'll never see, either?

> Another concern is that we're assuming that the key metadata will always
> have the most recent LSN. I think the closest thing to a guarantee we
> have of that is the superblock being updated on umount and every so
> often by xfs_log_worker() to cover the log. After a bit of playing
> around, I'm not so sure that is enough.

Sure, I just threw it out as a way to get a more recent LSN. The
only way to reliably get the highest LSN is to walk all the metadata
in the filesystem. We can't do that at mount time, so perhaps it
is best to just refuse to mount read-write and issue a warning to
upgrade xfsprogs and re-run xfs_repair.

> So now we have reset the LSN according to the log. Presumably the mount
> now inspects the superblock and each AG header and inherits the largest
> LSN plus some offset as the current LSN: LSN X+N. Directory d2 still has
> LSN Y, however, and we have no guarantee that N > Y-X. In other words, I
> think we can end up right back where we started. Make a modification to
> directory d2 at this point, crash the fs, and recovery might or might
> not replay a log record with LSN X+N against a target directory buffer
> with LSN Y.

These scenarios all result from running xfs_repair. It's the source
of the problem, so let's treat it primarily as a bug in xfs_repair.
The number of users that run xfs_repair are very small compared to
the wider user-base, so having the kernel say "upgrade xfsprogs
and repair" is probably the most reliable way to fix the problem.

So, to repair: have it record LSNs as it walks the metadata and
at the start of phase 5 have it select a new cycle number higher
than the highest LSN found in the filesystem. Stamp the log with
that cycle number as well as all metadata that is being rebuilt
in phase 5, and all the superblocks.

Problem solved.

> Again, that's a contrived and probably unlikely scenario, but could be
> extremely difficult to detect or root cause if it ever does occur. :/
> Thoughts? Is there something further we can do to mitigate this, or am I
> missing something else?

IMO, you're over-complicating the situation. We can't go back and
change history, nor make people upgrade to systems that won't suffer
from this problem. Hence we're just going to have to live with it,
just like all the other log recovery bugs we've lived with since
finding and fixing them.

If we do the simple thing and just detect zeroed logs in the kernel
and refuse read-write mounts, that's something we can easily
backport to all stable kernels that we support CRCs on (i.e. 3.16 to
present). And with a fixed xfs_repair, the problem goes away as
users and distros pull new in the new package, even if they are
running old kernels.

> Also, a random thought: I wonder if an update to the log zeroing
> mechanism to ensure that a subsequent mount picked up the LSN where it
> left off would be enough to get around much of this. That could mean
> stamping the log appropriately in repair, or adding something like a new
> continue_lsn field in the superblock to be used by anybody who zeroes
> the log and picked up on the next mount, etc...

Sure - that's just a variant my first suggestion (of don't zero the
log in xfs_repair). Remember that you said "I don't think that helps
us very much". :)

And, FWIW, my "read the LSN from metadata and use the highest" idea
above is just a further refinement of the two, so we can fix
zeroed logs from existing xfs_repair binaries without needing to do
anything extra in the kernel other than detect a zeroed log...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
