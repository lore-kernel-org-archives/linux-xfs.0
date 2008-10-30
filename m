Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 01:50:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9U8oQTP018683
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 01:50:27 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EFCEB0EBFF
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 01:50:24 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id x7rSd34PGbLzf7OU for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 01:50:24 -0700 (PDT)
Date: Thu, 30 Oct 2008 19:50:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: do_sync() and XFSQA test 182 failures....
Message-ID: <20081030085020.GP17077@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Folks,

I think I've finally found the bug(s) that is causing XFSQA test 182
to fail. Test 182 writes a bunch of files, then runs sync, then
shuts the filesystem down. It then unmounts and remounts the fs and
checks that all the files are the correct length and have the
correct contents. i.e. that sync semantics have been correctly
observed.

The cause of the failure is that log recovery is replaying inode
allocation and overwriting the last inode writes that contained
unlogged changes (i.e. the inode size update that occurs at I/O
completion).

The problem is that we've never been able to work out why recovery
is doing this.  What has been nagging at the back of my mind for
quite some time is the fact that we do actually write these inodes
to disk and that should allow the tail of the log to move forward
past the inode allocation transaction and hence it should not be
replayed during recovery.

A solution that has been proposed in the past (by Lachlan) is to log
the inode size updates instead of writing the inode to disk.  In
that case, recovery also replays the inode modification transactions
and so we don't lose anything. It is a solution that would fix the
problem. However, always logging inodes instead of writing unlogged
changes has other performance implications that we'd prefer to avoid
(i.e. the number of extra transactions it will cause).

This solution also seemed to me to be papering over the real problem
which we hadn't yet found because it did not explain why we were
replaying an allocation that we should not need to. Hence the
problem has gone unfixed since Lachlan first discovered it despite
trying several times to get to the bottom of the problem.
Now I think I finally have.

I started by instrumenting the sync code and the inode dirtying and
writeback code to confirm the order of data, inode and sync
operations, with a view to understanding why the tail of the log was
not moving forwards when the inode clusters were written out during
the sync. To start with, let's look at what do_sync() does:

24 static void do_sync(unsigned long wait)
 25 {
 26         wakeup_pdflush(0);
 27         sync_inodes(0);         /* All mappings, inodes and their blockdevs */
 28         DQUOT_SYNC(NULL);
 29         sync_supers();          /* Write the superblocks */
 30         sync_filesystems(0);    /* Start syncing the filesystems */
 31         sync_filesystems(wait); /* Waitingly sync the filesystems */
 32         sync_inodes(wait);      /* Mappings, inodes and blockdevs, again. */
 33         if (!wait)
 34                 printk("Emergency Sync complete\n");
 35         if (unlikely(laptop_mode))
 36                 laptop_sync_completion();
 37 }

Let's translate this into what XFS does:

	wakeup_pdflush(0) [*]	- run a concurrent background
				  sync of the fs via pdflush.

	sync_inodes(0)		- walks the superblock dirty inode
				  list doing an async flush of
				  inodes and their data.

	sync_supers()		- writes the superblock, forces the
				  log to disk

	sync_filesystems(0)	- non block filesystem sync. XFS
				  writes the superblock

	sync_filesystems(1)	- XFS writes all dirty data to disk
				  and waits for it. Dirties the
				  superblock and the log. Does not
				  write inodes.

	sync_inodes(1)		- walk the superblock dirty inode
				  list *twice*, first doing an async
				  flush of dirty data and inodes, secondly
				  doing a sync flush of remaining
				  dirty data and inodes.

[*] Starting pdflush to sync data in the background when we are
    about to start flushing ourselves is self-defeating. instead of
    having a single thread doing optimal writeout patterns, we now
    have two threads trying to sync the same filesystems and
    competing with each other to write out dirty inodes.  This
    actually causes bugs in sync because pdflush is doing async
    flushes. Hence if pdflush races and wins during the sync flush
    part of the sync process, sync_inodes(1) will return before all
    the data/metadata is on disk because it can't be found to be
    waited on.

Now the sync is _supposedly_ complete. But we still have a dirty
log and superblock thanks to delayed allocation that may have
occurred after the sync_supers() call. Hence we can immediately
see that we cannot *ever* do a proper sync of an XFS filesystem
in Linux without modifying do_sync() to do more callouts.

Worse, XFS can also still have *dirty inodes* because sync_inodes(1)
will remove inodes from the dirty list in the async pass, but they
can get dirtied a short time later (if they had dirty data) when the
data I/O completes. Hence if the second sync pass completes before
the inode is dirtied again we'll miss flushing it. This will mean we
don't write inode size updates during sync. This is the same race
that pdflush running in the background can trigger.

Clearly this is broken, but this particular problem is an XFS bug
and is fixed by XFS marking the inode dirty before I/O dispatch if
the end offset of the I/O is beyond the current EOF so there is no
window where the inode is temporarily clean. This, however, does
not fix the race condition between the sync thread and pdflush,
just the async-then-sync problem within the flush thread.

Back to do_sync(), the order of operations we need to reliably sync
a journalling filesystem that uses delayed allocation and updates
metadata on data I/O completion is effectively as follows:

	- flush all dirty data
	- wait for all metadata updates caused by data flush to
	  complete
	- force unwritten async transactions to disk to unpin dirty metadata
	- flush all dirty metadata
	- write the superblock

In generic speak, this effectively requires:

	sync_filesystems(0)	[**]
	sync_filesystems(1)
	sync_supers()
	sync_inodes(1)		[***]
	sync_supers()

[**] async flush optimisation
[***] async flush optimisation is implemented internally to
  sync_inodes() for sync flushes.

This leads to the following callouts and the behaviour that XFS
would need for the callouts:

	sync_filesystems(0)
		->sync_fs()		- async flush all dirty data
	sync_filesystems(1)
		->sync_fs()		- sync flush remaining dirty data
	sync_supers()
		->write_super()		- write super, force the log
	sync_inodes(1)		[****]
		sync_inodes_sb(0)	- async flush of dirty inodes
		sync_inodes_sb(1)	- sync flush of remaining inodes
	sync_supers()
		->write_super()		- write sb, force the log.

[****] sync_inodes() really needs to fall down to a ->sync_inodes()
callout for the filesystem to be able to implement an optimal
inode flushing strategy.

However, even with this order in place, test 182 still fails.

So I looked at the filesystem prior to log recovery (mount -o
ro,norecovery) and saw that all the data is on disk, all the inode
sizes are correct, the superblock is up to date and everything looks
OK. That is, the sync did everything it was supposed to and the
above order of writing out the filesystem is working correctly.

As soon as I ran recovery, though, I saw a small number of inodes
go back to having an inode size of zero - they regress. The reason
for this is that the log tail location (l_tail_lsn) at the end of
the sync is was not updated on disk at the end of the sync and
hence recovery is replaying transactions.

At this point I wondered if the log covering code was not working
properly. I'd never really looked at it in any detail, and as soon
as I read the description I knew that it was not working. The
problem log covering is supposed to solve is as follows (from
fs/xfs/xfs_log_priv.h):

161  * These states are used to insert dummy log entries to cover
162  * space allocation transactions which can undo non-transactional changes
163  * after a crash. Writes to a file with space
164  * already allocated do not result in any transactions. Allocations
165  * might include space beyond the EOF. So if we just push the EOF a
166  * little, the last transaction for the file could contain the wrong
167  * size. If there is no file system activity, after an allocation
168  * transaction, and the system crashes, the allocation transaction
169  * will get replayed and the file will be truncated. This could
170  * be hours/days/... after the allocation occurred.

Immediately it is was obvious that we're seeing the above problem
and that log covering is a method for ensuring that the state of the
log on disk is the same as that in memory at the end of a sync.

Hence, as the last part of the sync we need to try to cover the log
with a dummy transaction to update the real location of the log tail
in the log. Therefore we will no longer replay the inode allocation
transactions because the tail in the log matches the in memory state
after the inodes have been flushed.

With the current do_sync() code, we have no callout once the inodes
are written to issue a dummy transactions to cover the log
correctly.  The do_sync() process needs to end with a sync_supers()
to get the correct callout to XFS to allow this to happen. i.e.
whenever we try to write the superblock we also should be trying to
initiate the log covering process, and we can't do this right now.
Once the log is covered, the recovery-overwriting-inodes problem
goes away because recovery is not needed.

Everyone understand the problem now? ;)

<phew>

FWIW, XFS has had this log covering code since, well, forever. It
came from Irix and it worked on Irix. I don't think that it has ever
worked on Linux, though, because of the lack of a sync_supers() call
at the end of do_sync(1). We've just never noticed it until we
corrected the infamous NULL files problems in 2.6.22 which hid this
particular cause of file size mismatches after a crash.

With a bunch of hacks in place, test 182 now passes and sync(1) on
XFS finally does what it is supposed to.  I'm not going to post the
hacky, full-of-garbage, debuggy patch I have that I used to discover
this - I'll clean it up first to just have the bits needed to fix
the problem, then post it. That'll be tomorrow....

However, I have a problem - I'm an expert in XFS, not the other tens
of Linux filesystems so I can't begin to guess what the impact of
changing do_sync() would be on those many filesystems. How many
filesystems would such a change break? Indeed - how many are broken
right now by having dirty inodes and superblocks slip through
sync(1)?

And then the big question - how the hell does one test such change?

I can test XFS easily enough because it has shutdown ioctls that
effectively simulate a power failure - that what test 182 uses. I
don't think any other filesystem has such an ioctl, though, and I
don't have the time or hardware to repeatedly crash test every
filesystem out there to prove that a change to do_sync() doesn't
negatively impact them.

What are the alternatives? do_sync() operates above any particular
filesystem, so it's hard to provide a filesystem specific ->do_sync
method to avoid changing sync order for all filesystems. Do we
change do_sync() to completely sync a superblock at a time instead
of doing each operation across all superblocks before moving onto
the next operation? Is there any particular reason (e.g. performance, locking) for the current
method that would prevent changing to completely-sync-a-superblock
iteration algorithm so we can provide a custom ->do_sync method?

Are there any other ways that we can get a custom ->do_sync
method for XFS? I'd prefer a custom method so we don't have to
revalidate every linux filesystem, especially as XFS already has
everything it needs to provide it's own sync method (used for
freezing) and a test suite to validate it is working correctly.....

Are there any other options for solving this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
