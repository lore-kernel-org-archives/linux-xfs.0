Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2E32hao106443 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 22:02:43 -0500
Date: Wed, 14 Mar 2012 14:00:52 +1100
From: Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120314030052.GF2706@devil.redhat.com>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-12-git-send-email-jack@suse.cz>
	<20120308232041.GU3592@dastard>
	<20120309142253.GB14159@quack.suse.cz>
	<20120311224537.GV5091@dastard>
	<20120312175551.GI5998@quack.suse.cz>
	<20120312234817.GA5091@dastard>
	<20120313213020.GE20451@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313213020.GE20451@quack.suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: sandeen@redhat.com, Alex Elder <elder@kernel.org>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org

On Tue, Mar 13, 2012 at 10:30:20PM +0100, Jan Kara wrote:
> On Tue 13-03-12 10:48:17, Dave Chinner wrote:
> > On Mon, Mar 12, 2012 at 06:55:51PM +0100, Jan Kara wrote:
> > > On Mon 12-03-12 09:45:37, Dave Chinner wrote:
> > > I just had to change some properties of the shell to
> > > be usable for freezing as well. But the shell has to be maintained
> > > regardless of how we decide to do freezing.
> > > 
> > > Also believe me that I've initially tried to fix the freezing without the
> > > external shell. But it just isn't enough to prevent dirty inodes from being
> > > created (e.g. from directory operations) while sync during freezing is
> > > running.
> > 
> > Sure - the old mechanism was "freeze data" which only protected data
> > modification paths, followed by "freeze trans" which protected
> > metadata modification paths (like directory operations). You started
> > by removing the metadata modification path protection - it is any
> > wonder that those operations continued to dirty inodes until you
> > expanded the "freeze data" shell to mean "freeze data and metadata"?
>   That's just not true. Remember older versions of this patch set. Old
> model is doing:
>    freeze data
>    sync
>    freeze metadata (via freezing transations)
> and it is broken mainly because while sync is running, new metadata are
> dirtied and thus you end up with dirty metadata on a frozen filesystem.

But that exactly the issue that the filesystem .freeze_fs
method is supposed to handle.  It's supposed to finish the
freeze process by finishing all outstanding metadata operations and
cleaning all remaining dirty metadata. It still has to guarantee
this regardless of the model used prior to this.

> Forcing the journal commit in ->freeze_fs() pushes changes to disk but
> inodes still remain dirty and actually, it can be too late for flusher
> thread anyway because it can be already hanging trying to start a
> transaction.

If the changes are already in the journal, then there is no new
transaction work needed to clean the VFS state.  Indeed, .freezefs
needs to write back all dirty metadata objects that it is tracking
internally in the journal so that a snapshot of the frozen image is
consistent and can be mounted read-only without running recovery...

> > It's like the hard shelli/soft center security model - it protects
> > well from external attackers, but once they get inside, there's no
> > protection. Indeed, there is zero protection from inside jobs, and
> > thats where multiple layers of defense are needed.
> > 
> > Your freeze changes provide us with a hard outer shell, but it's got
> > a really, really soft center. We can't use the outer shell defenses
> > deep inside the shell because of the locking orders that have been
> > defined (freeze protection must be outermost), so we need another
> > layer....
>   I think there are two different issues. One is your complaint that
> extending the shell to cover also internal sources of fs modification will
> be too fragile if not done implicitely on transaction start.

Most definitely. It means that we have to have freeze behaviour in
mind whether doing any async/background work. That's usually the
furthest think from people's minds when implementing stuff like
background inode initialisation...

> Another is a question whether we could reasonably fend off internal
> modification using the current two counters. The MRU thread or ->release
> can be easily handled with them (->release can be handled by the counter
> ranking below mmap_sem). For shrinkers, I'm not that certain. Certainly the
> outer counter won't work. The inner one with lock ranking just below
> mmap_sem might work - depends on whether there are any XFS locks under
> mmap_sem from within which we'd do GFP_KERNEL allocations. But here I agree
> issues might be nasty enough to warrant another counter.

Might be nasty? There's no question about it in my mind that it
*would* be nasty....

> This is connected with another somewhat related issue: Do we want shrinkers
> to block on frozen filesystem? That could result in unrelated processes
> blocking on frozen filesystem. I'd find it nicer if we just skipped
> the writes if the filesystem is frozen as it seems to me
> xfs_free_eofblocks() is somewhat optional. Is it true?

Not really. It needs to be done on rw filesytems[*].

Besides, this isn't really an XFS specific problem - the shrinkers
need to operate on frozen filesystems. e.g. run a directory
traversal of a frozen filesystem, and if you stop the shrinkers from
running then the dcache/icache growth will run the system out of
memory.

Sure, blocking a shrinker can be considered antisocial, but if you
can't free memory because it will dirty inodes on a frozen
filesystem then it is better to block the shrinker until the
filesytem is unfrozen than it is to allow the shrinker to fail and
eventually OOM the machine. Freezing filesysetms is supposed to be a
short term, workload-invisible operation. Kicking the OOM killer
because you can't free inodes is far more antisocial than having
those applications pause while the fs is frozen.

[*] Right now we are discussing adding a new background/async worker
that that does speculative preallocation removal to make it occur
faster than it currently does. So skipping it is not really an
option and this is exactly the sort of "new feature needs to
consider how to deal with freeze" problem I'm talking about.

> > > But in the end, if you guys really feel strongly about it and decide that
> > > XFS wants to keep it's mechanism of freezing on transaction start, then I
> > > won't stop you. Although it would mean XFS would have to have three
> > > counters to protect freezing while other filesystems will need only two.
> > 
> > There is two counters only to avoid lockdep problems because the
> > different entry points to the outer shell have different locking
> > orders. I fail to see why adding a third counter to provide an
> > innermost freeze lock that retains the current level of protection
> > is a big deal because all that it really needs to work is a
> > different lock order.
>   The two counters are needed to avoid deadlocks, not just because of
> lockdep... The third counter can be added but per-cpu counters are not
> exactly cheap (in terms of memory) so I don't want to add it without a good
> reason. Lock ordering constraints in shrinkers might be this good reason.

An additional percpu counter is far, far cheaper than the cost of
always needing to consider how not to break filesystem freezing for
the forseeable future.

> Also fitting the XFS transaction system to freezing was a bit ugly (because
> you need to log a dummy transaction on a frozen filesystem

Sure - that's to ensure the log is dirty so that open-but-unlinked
inodes are handled correctly by recovery if the system crashes while the
filesystem is frozen. But the last patch in your series would prevent
freezing filesystems while there are open-but-unlinked files
present, so all that grot could be removed.

Indeed, when that patch goes to mainline, the XFS code for
handling remount,ro and freeze can be made identical....

> and you have
> things like xfs_trans_dup() which requires us to bump the counter even
> though the filesystem is already in freezing process) so I'd be happier if
> we could avoid it...

The only additional infrastructure that you need to provide is a
"start_nested" operation for xfs_trans_dup() that increments the
percpu counter. I don't think that's a difficult problem to solve.

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
