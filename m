Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2BMjhjH198394 for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 17:45:44 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ic3oo4XDwsNa9onL for <xfs@oss.sgi.com>;
	Sun, 11 Mar 2012 15:45:41 -0700 (PDT)
Date: Mon, 12 Mar 2012 09:45:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120311224537.GV5091@dastard>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-12-git-send-email-jack@suse.cz>
	<20120308232041.GU3592@dastard>
	<20120309142253.GB14159@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120309142253.GB14159@quack.suse.cz>
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

On Fri, Mar 09, 2012 at 03:22:53PM +0100, Jan Kara wrote:
> On Fri 09-03-12 10:20:41, Dave Chinner wrote:
> > On Mon, Mar 05, 2012 at 05:01:09PM +0100, Jan Kara wrote:
> > > Generic code now blocks all writers from standard write paths. So we block all
> > > writers coming from ioctl and replace blocking of transactions on frozen
> > > filesystem with a debugging check. As a bonus, we get a protection of ioctl
> > > against racing remount read-only. We also convert xfs_file_aio_write() to a
> > > non-racy freeze protection.
> > ....
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 329b06a..6468a2a 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -577,7 +577,6 @@ xfs_trans_alloc(
> > >  	xfs_mount_t	*mp,
> > >  	uint		type)
> > >  {
> > > -	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> > >  	return _xfs_trans_alloc(mp, type, KM_SLEEP);
> > >  }
> > 
> > So what is there to stop internal XFS threads from starting
> > transactions when the filesystem is frozen? Previously this
> > SB_FREEZE_TRANS would guarantee even internal fucntions would get
> > stopped, but now there's nothing?
>   I've checked XFS now and I didn't find any work that would be done on a
> clean filesystem. I found:
> _xfs_mru_cache_reap() - doesn't seem to do any IO

Causes iput() on inodes, which if dropping the last reference to the
inode can cause them to enter reclaim and hence have transactions
run on them to either truncate blocks beyonds EOF or to do the
second phase of an unlink(). So it will definitely break the freeze
model.

> xfs_end_io(), xfs_buf_iodone_work() - shouldn't be a problem either since only
>   reads can happen on a frozen filesystem
> xfs_reclaim_worker() - everything is clean so no IO should happen

It will do work as other things push inodes into reclaim. e.g.
filestreams inode expiry. And it will still run to reclaim clean
inodes...

> xfs_flush_worker() - everything is clean so no IO should happen
> xfs_sync_worker() - again the same if I understand the code right

xfs_sync_worker() will always trigger a log force, so if there is
anything that has dirtied the journal, it will trigger IO. We have
no protection against the journal being dirtied anymore, so no
guarantees can be given here.

Basically, your patchset creates a "shell" around the outside of the
filesystem that catches all the external modifications that can
occur through the VFS and ioctls. The "shell" is now the only layer
of defense because the patchset removes the layer of protection that
prevents internal modifications from occurring.

For example, the XFS patch added a bunch of protection to ioctls on
XFS that only modify file metadata and so never were protected
against data freezes - they were all implicitly protected by the inner
transaction subsystem freeze. All of the above cases were protected
by the inner layer of defense, which is now gone.

Not to mention the shrinkers. The inode cache shrinkers can
cause inodes to enter reclaim which can trigger EOF truncation just
like _xfs_mru_cache_reap(). The dquot cache shrinker can also issue
IO, and dquots will be dirtied by EOF truncation. Same with buffers,
and the buffer cache shrinker.

I'm sure other filesystems have just as complex or even more complex
internal paths that trigger dirtying and IO that the "freeze shell"
model does not prevent. I don't think auditing is good enough - the
shell model is, IMO, too easy to break and too hard to test for
breakage...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
