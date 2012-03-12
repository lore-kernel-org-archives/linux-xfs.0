Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CNmNag168621 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 18:48:23 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bwuA3lrGufz6Xv1d for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 16:48:21 -0700 (PDT)
Date: Tue, 13 Mar 2012 10:48:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120312234817.GA5091@dastard>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-12-git-send-email-jack@suse.cz>
	<20120308232041.GU3592@dastard>
	<20120309142253.GB14159@quack.suse.cz>
	<20120311224537.GV5091@dastard>
	<20120312175551.GI5998@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120312175551.GI5998@quack.suse.cz>
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
Cc: sandeen@redhat.com, Alex Elder <elder@kernel.org>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Al Viro <viro@ZenIV.linux.org.uk>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org

On Mon, Mar 12, 2012 at 06:55:51PM +0100, Jan Kara wrote:
> On Mon 12-03-12 09:45:37, Dave Chinner wrote:
> > On Fri, Mar 09, 2012 at 03:22:53PM +0100, Jan Kara wrote:
> > It will do work as other things push inodes into reclaim. e.g.
> > filestreams inode expiry. And it will still run to reclaim clean
> > inodes...
>   Sure. But reclaim will start a transaction only if inode is dirty. And
> inode must not be dirty on a frozen filesystem.

That's what I've been trying to tell you - even clean inodes can be
dirtied in reclaim on XFS, so ensuring the FS is clean is not a good
enough guarantee.  And not just through the shrinkers - just closing
a file descriptor can trigger truncation as well via .release. See
xfs_release:

	/* If this is a read-only mount, don't do this (would generate I/O) */
	if (mp->m_flags & XFS_MOUNT_RDONLY)
		goto out;

> > > xfs_flush_worker() - everything is clean so no IO should happen
> > > xfs_sync_worker() - again the same if I understand the code right
> > 
> > xfs_sync_worker() will always trigger a log force, so if there is
> > anything that has dirtied the journal, it will trigger IO. We have
> > no protection against the journal being dirtied anymore, so no
> > guarantees can be given here.
>   Yes, it would be a bug if something dirtied a journal while the
> filesystem is frozen. To catch issues like this, I've added WARN_ON in
> xfs_trans_alloc() to actually warn when transaction would be started on a
> frozen filesystem. My testing never triggered it with the latest patch set.

Just hold a file descriptor open for a large write over the freeze
(don't get it caught in the freeze), and then close it after the
filesystem is frozen. Perhaps even drop the slab caches.

> > Basically, your patchset creates a "shell" around the outside of the
> > filesystem that catches all the external modifications that can
> > occur through the VFS and ioctls. The "shell" is now the only layer
> > of defense because the patchset removes the layer of protection that
> > prevents internal modifications from occurring.
>   Yes. I'd just note that the "shell" is there already to provide reliable
> remounting read only.

But it doesn't provide reliable read-only behaviour - internal
filesystem triggers still need to check and disarm to make read-only
mounts reliable. Indeed, XFS has many internal checks for read only
mounts, and the places we are talking about here are similar to the
places where you've removed freeze protection from by gutting the
transaction level freezing.

> I just had to change some properties of the shell to
> be usable for freezing as well. But the shell has to be maintained
> regardless of how we decide to do freezing.
> 
> Also believe me that I've initially tried to fix the freezing without the
> external shell. But it just isn't enough to prevent dirty inodes from being
> created (e.g. from directory operations) while sync during freezing is
> running.

Sure - the old mechanism was "freeze data" which only protected data
modification paths, followed by "freeze trans" which protected
metadata modification paths (like directory operations). You started
by removing the metadata modification path protection - it is any
wonder that those operations continued to dirty inodes until you
expanded the "freeze data" shell to mean "freeze data and metadata"?

> Sure I could keep the freezing mechanism on transaction start. But it
> seemed like a cleaner approach to me to protect all the places properly
> with the generic mechanism than having two mechanisms and unclear
> (especially locking) interactions between them.

Once again, that's a view that does not take into account that
modifcations don't all come through the VFS.

It's like the hard shelli/soft center security model - it protects
well from external attackers, but once they get inside, there's no
protection. Indeed, there is zero protection from inside jobs, and
thats where multiple layers of defense are needed.

Your freeze changes provide us with a hard outer shell, but it's got
a really, really soft center. We can't use the outer shell defenses
deep inside the shell because of the locking orders that have been
defined (freeze protection must be outermost), so we need another
layer....

> But in the end, if you guys really feel strongly about it and decide that
> XFS wants to keep it's mechanism of freezing on transaction start, then I
> won't stop you. Although it would mean XFS would have to have three
> counters to protect freezing while other filesystems will need only two.

There is two counters only to avoid lockdep problems because the
different entry points to the outer shell have different locking
orders. I fail to see why adding a third counter to provide an
innermost freeze lock that retains the current level of protection
is a big deal because all that it really needs to work is a
different lock order.

Also, ext4 could retain it's current outer/inner protection, so I
don't see that this behaviour is XFS specific.....

> Anyway I'm confident enough to remove that mechanism from ext3/4 and ocfs2
> but I don't know XFS internals enough to really argue...

... especially given the reported ext4 regression. I have much less
confidence than you that the outer shell is sufficient for ext4 or
any other complex filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
