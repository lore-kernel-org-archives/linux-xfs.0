Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CHtwVn116391 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 12:55:59 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ftUUTg36bNaGJwf5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 10:55:57 -0700 (PDT)
Date: Mon, 12 Mar 2012 18:55:51 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120312175551.GI5998@quack.suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-12-git-send-email-jack@suse.cz>
	<20120308232041.GU3592@dastard>
	<20120309142253.GB14159@quack.suse.cz>
	<20120311224537.GV5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120311224537.GV5091@dastard>
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

On Mon 12-03-12 09:45:37, Dave Chinner wrote:
> On Fri, Mar 09, 2012 at 03:22:53PM +0100, Jan Kara wrote:
> > On Fri 09-03-12 10:20:41, Dave Chinner wrote:
> > > On Mon, Mar 05, 2012 at 05:01:09PM +0100, Jan Kara wrote:
> > > > Generic code now blocks all writers from standard write paths. So we block all
> > > > writers coming from ioctl and replace blocking of transactions on frozen
> > > > filesystem with a debugging check. As a bonus, we get a protection of ioctl
> > > > against racing remount read-only. We also convert xfs_file_aio_write() to a
> > > > non-racy freeze protection.
> > > ....
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index 329b06a..6468a2a 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> > > > @@ -577,7 +577,6 @@ xfs_trans_alloc(
> > > >  	xfs_mount_t	*mp,
> > > >  	uint		type)
> > > >  {
> > > > -	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> > > >  	return _xfs_trans_alloc(mp, type, KM_SLEEP);
> > > >  }
> > > 
> > > So what is there to stop internal XFS threads from starting
> > > transactions when the filesystem is frozen? Previously this
> > > SB_FREEZE_TRANS would guarantee even internal fucntions would get
> > > stopped, but now there's nothing?
> >   I've checked XFS now and I didn't find any work that would be done on a
> > clean filesystem. I found:
> > _xfs_mru_cache_reap() - doesn't seem to do any IO
> 
> Causes iput() on inodes, which if dropping the last reference to the
> inode can cause them to enter reclaim and hence have transactions
> run on them to either truncate blocks beyonds EOF or to do the
> second phase of an unlink(). So it will definitely break the freeze
> model.
  OK, I've missed this. I'll fix it.

> > xfs_end_io(), xfs_buf_iodone_work() - shouldn't be a problem either since only
> >   reads can happen on a frozen filesystem
> > xfs_reclaim_worker() - everything is clean so no IO should happen
> 
> It will do work as other things push inodes into reclaim. e.g.
> filestreams inode expiry. And it will still run to reclaim clean
> inodes...
  Sure. But reclaim will start a transaction only if inode is dirty. And
inode must not be dirty on a frozen filesystem.
 
> > xfs_flush_worker() - everything is clean so no IO should happen
> > xfs_sync_worker() - again the same if I understand the code right
> 
> xfs_sync_worker() will always trigger a log force, so if there is
> anything that has dirtied the journal, it will trigger IO. We have
> no protection against the journal being dirtied anymore, so no
> guarantees can be given here.
  Yes, it would be a bug if something dirtied a journal while the
filesystem is frozen. To catch issues like this, I've added WARN_ON in
xfs_trans_alloc() to actually warn when transaction would be started on a
frozen filesystem. My testing never triggered it with the latest patch set.

> Basically, your patchset creates a "shell" around the outside of the
> filesystem that catches all the external modifications that can
> occur through the VFS and ioctls. The "shell" is now the only layer
> of defense because the patchset removes the layer of protection that
> prevents internal modifications from occurring.
  Yes. I'd just note that the "shell" is there already to provide reliable
remounting read only. I just had to change some properties of the shell to
be usable for freezing as well. But the shell has to be maintained
regardless of how we decide to do freezing.

Also believe me that I've initially tried to fix the freezing without the
external shell. But it just isn't enough to prevent dirty inodes from being
created (e.g. from directory operations) while sync during freezing is
running.

Sure I could keep the freezing mechanism on transaction start. But it
seemed like a cleaner approach to me to protect all the places properly
with the generic mechanism than having two mechanisms and unclear
(especially locking) interactions between them.

But in the end, if you guys really feel strongly about it and decide that
XFS wants to keep it's mechanism of freezing on transaction start, then I
won't stop you. Although it would mean XFS would have to have three
counters to protect freezing while other filesystems will need only two.
Anyway I'm confident enough to remove that mechanism from ext3/4 and ocfs2
but I don't know XFS internals enough to really argue...

> For example, the XFS patch added a bunch of protection to ioctls on
> XFS that only modify file metadata and so never were protected
> against data freezes - they were all implicitly protected by the inner
> transaction subsystem freeze. All of the above cases were protected
> by the inner layer of defense, which is now gone.
  Yes, but all these ioctls are currently buggy with respect to remounting
read only (not the whole filesystem, just one mountpoint of many where
filesystem may be mounted). So I'd argue that these particular changes are
actually bug fixes.

> Not to mention the shrinkers. The inode cache shrinkers can
> cause inodes to enter reclaim which can trigger EOF truncation just
> like _xfs_mru_cache_reap(). The dquot cache shrinker can also issue
> IO, and dquots will be dirtied by EOF truncation. Same with buffers,
> and the buffer cache shrinker.
  OK, now I see that even iput() of a clean inode can cause truncation to
happen for XFS. Thanks for the pointer. I'll see what we could do about
this.

> I'm sure other filesystems have just as complex or even more complex
> internal paths that trigger dirtying and IO that the "freeze shell"
> model does not prevent. I don't think auditing is good enough - the
> shell model is, IMO, too easy to break and too hard to test for
> breakage...
  Well, actually I don't know filesystem which would have as complex
interactions as XFS has. But maybe there are some. In either case I don't
think maintaining the "shell" is that hard. You have to maintain the one
facing to userspace anyway due to remounting. For the internal filesystem
threads, you have to be aware when you can cause write and be protected
against freezing in that case. I don't think it's that complex, although I
agree that the current test coverage will be small (freezing isn't used
very often) so bugs can go unnoticed for a long time.

Maybe we could add a test in xfs_trans_alloc() checking that fs is
protected against freezing? That would increase the test coverage a lot.
Although the test should be probably enabled only for XFS_DEBUG because it
will be an expensive one.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
