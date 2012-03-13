Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DLUP3l073489 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 16:30:25 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 5rht1wA4AsWWuVZz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 14:30:23 -0700 (PDT)
Date: Tue, 13 Mar 2012 22:30:20 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120313213020.GE20451@quack.suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-12-git-send-email-jack@suse.cz>
	<20120308232041.GU3592@dastard>
	<20120309142253.GB14159@quack.suse.cz>
	<20120311224537.GV5091@dastard>
	<20120312175551.GI5998@quack.suse.cz>
	<20120312234817.GA5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120312234817.GA5091@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Al Viro <viro@ZenIV.linux.org.uk>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org

On Tue 13-03-12 10:48:17, Dave Chinner wrote:
> On Mon, Mar 12, 2012 at 06:55:51PM +0100, Jan Kara wrote:
> > On Mon 12-03-12 09:45:37, Dave Chinner wrote:
> > > On Fri, Mar 09, 2012 at 03:22:53PM +0100, Jan Kara wrote:
> > > It will do work as other things push inodes into reclaim. e.g.
> > > filestreams inode expiry. And it will still run to reclaim clean
> > > inodes...
> >   Sure. But reclaim will start a transaction only if inode is dirty. And
> > inode must not be dirty on a frozen filesystem.
> 
> That's what I've been trying to tell you - even clean inodes can be
> dirtied in reclaim on XFS, so ensuring the FS is clean is not a good
> enough guarantee.  And not just through the shrinkers - just closing
> a file descriptor can trigger truncation as well via .release. See
> xfs_release:
> 
> 	/* If this is a read-only mount, don't do this (would generate I/O) */
> 	if (mp->m_flags & XFS_MOUNT_RDONLY)
> 		goto out;
  Yes, I've noticed this while writing the email but forgot to update the
beginning. Sorry for confusion.

> > > Basically, your patchset creates a "shell" around the outside of the
> > > filesystem that catches all the external modifications that can
> > > occur through the VFS and ioctls. The "shell" is now the only layer
> > > of defense because the patchset removes the layer of protection that
> > > prevents internal modifications from occurring.
> >   Yes. I'd just note that the "shell" is there already to provide reliable
> > remounting read only.
> 
> But it doesn't provide reliable read-only behaviour - internal
> filesystem triggers still need to check and disarm to make read-only
> mounts reliable. Indeed, XFS has many internal checks for read only
> mounts, and the places we are talking about here are similar to the
> places where you've removed freeze protection from by gutting the
> transaction level freezing.
  And indeed your read-only checks are racy the same way freezing was...
But that's a different story. You have actually a good point that freezing
protection and read-only mount protection should be at the same places.

> > I just had to change some properties of the shell to
> > be usable for freezing as well. But the shell has to be maintained
> > regardless of how we decide to do freezing.
> > 
> > Also believe me that I've initially tried to fix the freezing without the
> > external shell. But it just isn't enough to prevent dirty inodes from being
> > created (e.g. from directory operations) while sync during freezing is
> > running.
> 
> Sure - the old mechanism was "freeze data" which only protected data
> modification paths, followed by "freeze trans" which protected
> metadata modification paths (like directory operations). You started
> by removing the metadata modification path protection - it is any
> wonder that those operations continued to dirty inodes until you
> expanded the "freeze data" shell to mean "freeze data and metadata"?
  That's just not true. Remember older versions of this patch set. Old
model is doing:
   freeze data
   sync
   freeze metadata (via freezing transations)
and it is broken mainly because while sync is running, new metadata are
dirtied and thus you end up with dirty metadata on a frozen filesystem.
Forcing the journal commit in ->freeze_fs() pushes changes to disk but
inodes still remain dirty and actually, it can be too late for flusher
thread anyway because it can be already hanging trying to start a
transaction.

Then there are also other less severe problems like that mark_inode_dirty()
could race with freezing in such a way that it was added to dirty list
after filesystem was fully frozen. 

> > Sure I could keep the freezing mechanism on transaction start. But it
> > seemed like a cleaner approach to me to protect all the places properly
> > with the generic mechanism than having two mechanisms and unclear
> > (especially locking) interactions between them.
> 
> Once again, that's a view that does not take into account that
> modifcations don't all come through the VFS.
  "all the places" in my sentence meant "including the internal sources of
modification"...

> It's like the hard shelli/soft center security model - it protects
> well from external attackers, but once they get inside, there's no
> protection. Indeed, there is zero protection from inside jobs, and
> thats where multiple layers of defense are needed.
> 
> Your freeze changes provide us with a hard outer shell, but it's got
> a really, really soft center. We can't use the outer shell defenses
> deep inside the shell because of the locking orders that have been
> defined (freeze protection must be outermost), so we need another
> layer....
  I think there are two different issues. One is your complaint that
extending the shell to cover also internal sources of fs modification will
be too fragile if not done implicitely on transaction start.

Another is a question whether we could reasonably fend off internal
modification using the current two counters. The MRU thread or ->release
can be easily handled with them (->release can be handled by the counter
ranking below mmap_sem). For shrinkers, I'm not that certain. Certainly the
outer counter won't work. The inner one with lock ranking just below
mmap_sem might work - depends on whether there are any XFS locks under
mmap_sem from within which we'd do GFP_KERNEL allocations. But here I agree
issues might be nasty enough to warrant another counter.

This is connected with another somewhat related issue: Do we want shrinkers
to block on frozen filesystem? That could result in unrelated processes
blocking on frozen filesystem. I'd find it nicer if we just skipped
the writes if the filesystem is frozen as it seems to me
xfs_free_eofblocks() is somewhat optional. Is it true?

> > But in the end, if you guys really feel strongly about it and decide that
> > XFS wants to keep it's mechanism of freezing on transaction start, then I
> > won't stop you. Although it would mean XFS would have to have three
> > counters to protect freezing while other filesystems will need only two.
> 
> There is two counters only to avoid lockdep problems because the
> different entry points to the outer shell have different locking
> orders. I fail to see why adding a third counter to provide an
> innermost freeze lock that retains the current level of protection
> is a big deal because all that it really needs to work is a
> different lock order.
  The two counters are needed to avoid deadlocks, not just because of
lockdep... The third counter can be added but per-cpu counters are not
exactly cheap (in terms of memory) so I don't want to add it without a good
reason. Lock ordering constraints in shrinkers might be this good reason.

Also fitting the XFS transaction system to freezing was a bit ugly (because
you need to log a dummy transaction on a frozen filesystem and you have
things like xfs_trans_dup() which requires us to bump the counter even
though the filesystem is already in freezing process) so I'd be happier if
we could avoid it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
