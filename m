Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F9487F50
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 11:25:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5DD688F8052
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 09:25:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1d7Bb9evAtWJKGup (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 09:25:32 -0700 (PDT)
Date: Thu, 20 Aug 2015 12:25:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: v5 filesystem corruption due to log recovery lsn ordering
Message-ID: <20150820162529.GB13033@bfoster.bfoster>
References: <20150819183904.GB49174@bfoster.bfoster>
	<20150819224453.GL3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150819224453.GL3902@dastard>
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

On Thu, Aug 20, 2015 at 08:44:53AM +1000, Dave Chinner wrote:
> On Wed, Aug 19, 2015 at 02:39:05PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > Here's another issue I've run into from recent log recovery testing...
> > 
> > Many on-disk data structures for v5 filesystems have the LSN from the
> > last modification stamped the associated header. As of the following
> > commit, log recovery compares the recovery item LSN against the LSN of
> > the on-disk structure to avoid restoration of stale contents:
> > 
> >   50d5c8d xfs: check LSN ordering for v5 superblocks during recovery
> > 
> > This presumably addresses some problems where recovery of the stale
> > contents leads to CRC failure. The problem here is that xfs_repair
> > clears the log (even when the fs is clean) and resets the current LSN on
> > the next mount. This creates a situation where logging is ineffective
> > for any structure that has not yet been modified since the current LSN
> > was reset.
> 
> Well, that was a bit of an oversight...
> 
> ....
> 
> > 
> > The larger question is how to resolve this problem? I don't think this
> > is something that is ultimately addressed in xfs_repair. Even if we
> > stopped clearing the log, that doesn't help users who might have had to
> > forcibly zero the log to recover a filesystem. Another option in theory
> > might be to unconditionally reset the LSN of everything on disk, but
> > that sounds like overkill just to preserve the current kernel
> > workaround.
> 
> Well, it's relatively easy to detect a log that has been zeroed if
> the cycle count is more than a cycle or two lower than the LSN in
> important metadata, but I'm not sure we can reliably detect that.
> 
> > It sounds more to me that we have to adjust this behavior on the kernel
> > side. That said, the original commit presumably addresses some log
> > recovery shutdown problems that we do not want to reintroduce. I haven't
> > yet wrapped my head around what that original problem was, but I wanted
> > to get this reported. If the issue was early buffer I/O submission,
> > perhaps we need a new mechanism to defer this I/O submission until a
> > point that CRC verification is expected to pass (or otherwise generate a
> > filesystem error)? Or perhaps do something similar with CRC
> > verification? Any other thoughts, issues or things I might have missed
> > here?
> 
> The issue that the LSN ordering fixes is that of unsynchronised
> recovery of different log records that contain the same objects.
> e.g. ordering of inode chunk allocation (in buffers) vs inode object
> modification (in inode items). v4 filesystems have a serious problem
> where inode chunk allocation can be run after the inode item
> modifications, resulting in recovery "losing" file size updates that
> sync flushed to the log.
> 

Hmm, so I would have expected these kind of operations to generally
occur in order. I'm clearly still missing some context on the overall
log item lifecycle to understand how this might occur.

Using the inode chunk allocation and inode modification example...
clearly the transactions have to commit in order because the inodes must
be allocated before they can be used/modified. At what point after that
is reordering possible? Are we talking about reordering of the items
from the cil/log buffers to the on-disk log, or reordering of the items
during recovery (or both)?

> i.e. create just the right number of small files, sync, crash and
> recovery gives a number of zero length files in certain inode chunks
> because the ordering of item recovery was wrong.
> 
> Another problem with inode logging is the flushiter field, which is
> used to try to avoid replaying changes in the log that have already
> been flushed to disk. This could also lead to lost inode
> modifications after a sync because the flushiter is reset to zero
> after each time the inode item is recovered. This was mostly avoided
> by logging all inode modifications and using delayed logging, but
> could still occur...
> 
> There was a long history of these sorts of problems occurring (I
> first analysed the inode allocation/inode item update failure mode
> back in 2006), and I found several other possible issues like this
> to do with the inode flushiter at the same time. I also suspected
> that there were problems with directory recovery due to the same
> inode item vs buffer item ordering issues, but could never pin them
> down.
> 
> So the solution was to record the LSN of the last modification in
> every item as it is written to disk, thereby ensuring we knew
> exactly what transaction the item was last modified in. This means
> we can skip modifications in transaction recovery that are already
> on disk.
> 

Given the reordering is possible (despite my lingering questions wrt to
exactly how, above) this makes sense as a mechanism to address that
problem.

> ----
> 
> The first thing we need to do is not zero the log in xfs_repair when
> the log is clean to minimise future exposure to this issue on
> existing systems.
> 

Eh, I'm not really sure this helps us that much. We still have to deal
with the issue so long as current xfsprogs versions are out there. We
also have no real way of knowing whether a filesystem could have been
affected by the problem or not. FWIW, xfs_metadump also results in
similar behavior, which means that technically it's possible for
different behavior on a restored metadump from the original fs. That's
less critical, but clearly not ideal and something to be aware of.

That said, I think it is somewhat strange for xfs_repair to zero the log
unconditionally, this issue aside. So I'm not really against that change
in general. I just think we need a kernel fix first and foremost.

> Then, on the kernel side, we need is a reliable way to detect that
> the log head/tail pointers have been reset in the kernel. This means
> we can - at minimum - issue a warning during log recovery that this
> has been detected.
> 
> Finally, we need to work out how to handle recovery in the situation
> that the log has been zeroed and the filesystem has a mix of new and
> old, stale LSNs. I think the simplest way around this is not to
> handle it in log recovery at all, but to avoid it altogether.
> 
> That is, when we find the log head/tail point to a zeroed log, we
> pull the current LSN from, say, the superblock (and maybe other
> metadata such as AG headers) and initialise the log head/tail to the
> cycle number + some offset so that every new transaction is
> guaranteed to have a cycle number more recent than any other LSN in
> the filesystem and ordering is preserved, even if the log has been
> zeroed.
> 

That's an interesting idea, but I wonder if it truly fixes the problem
or just makes it potentially more difficult to reproduce. One concern is
that even with this in place, all it takes to reintroduce the problem is
for a filesystem to run a bit on an older kernel in a situation where
the LSN is reset and enough modification has occurred to update whatever
key metadata we determine as important with the reset LSNs. A mount
alone is enough to pollute the superblock in this manner. Further
modification is probably necessary to affect the agi/agf headers,
however. It might not be the most likely scenario, but what is more
concerning is that if it does occur, it's completely invisible to our
detection on updated kernels. Would we want to consider a new
ro-incompat feature bit for this mechanism to prevent that?

Another concern is that we're assuming that the key metadata will always
have the most recent LSN. I think the closest thing to a guarantee we
have of that is the superblock being updated on umount and every so
often by xfs_log_worker() to cover the log. After a bit of playing
around, I'm not so sure that is enough. Not all workloads result in
superblock or AG header updates. Further, such an adverse workload that
runs in a constant manner seems to defer covering the log indefinitely
(not to mention that the frequency is also user-configurable via /proc).

Consider the following example along with some observations:

- mkfs, mount
- create a directory d1, populated with files
- create a directory d2, populated with files and hard links
- run a constant non-sb, non-ag header updating workload (e.g., repeated
  file truncates that do not involve allocation) on d1
- wait a bit...

The superblock and/or AG headers are updated to LSN X at some point here
due to the inode allocations for the directory creations and whatnot.
The constant truncate workload continuously pushes the log forward
without ever updating the LSN of any AGI/AGF or the superblock.

After some time passes, the current LSN pushes forward to some increased
value Y. At that point:

- unlink a hard link from directory d2
- wait a bit once more...

After some more time passes, the d2 directory blocks are written back
and the LSN of those blocks is updated to Y. Note that the superblock
and AGI/AGF headers are still at LSN X. From here:

- shutdown the fs, umount
- repair and force zero the log
- mount the fs

So now we have reset the LSN according to the log. Presumably the mount
now inspects the superblock and each AG header and inherits the largest
LSN plus some offset as the current LSN: LSN X+N. Directory d2 still has
LSN Y, however, and we have no guarantee that N > Y-X. In other words, I
think we can end up right back where we started. Make a modification to
directory d2 at this point, crash the fs, and recovery might or might
not replay a log record with LSN X+N against a target directory buffer
with LSN Y.

Again, that's a contrived and probably unlikely scenario, but could be
extremely difficult to detect or root cause if it ever does occur. :/
Thoughts? Is there something further we can do to mitigate this, or am I
missing something else?

Brian

P.S.,

After running through the above, I noticed that xfs_repair zeroes the
LSN of the agi/agf and associated btrees and whatnot. I also noticed
that lazy sb counters can avoid superblock updates for many allocation
operations (xfs_trans_mod_sb()). While this probably mitigates ag
corruption due to this issue, I suspect this means that the above
workload might actually be able to get away with some allocations
without inhibiting the ability reproduce.

Also, a random thought: I wonder if an update to the log zeroing
mechanism to ensure that a subsequent mount picked up the LSN where it
left off would be enough to get around much of this. That could mean
stamping the log appropriately in repair, or adding something like a new
continue_lsn field in the superblock to be used by anybody who zeroes
the log and picked up on the next mount, etc...

> This means dirty log recovery requires no changes at all, we only
> need to change xlog_recover() to detect the empty, clean log and
> set:
> 
> 	l_curr_cycle
> 	l_curr_block
> 	l_last_sync_lsn
> 	l_tail_lsn
> 	reserve_head
> 	write_head
> 
> appropriately for the new cycle number we've given the log. This is
> pretty much how it is already done in xlog_find_tail() with the
> initialisation information coming from the log record found at the
> head of the log - we're just making it up a different source. ;)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
