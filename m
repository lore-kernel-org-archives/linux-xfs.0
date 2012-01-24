Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OJZZME068905 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 13:35:35 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id cxt5PXe9qD6AwZQN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 11:35:33 -0800 (PST)
Date: Tue, 24 Jan 2012 20:35:29 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/8] xfs: Protect xfs_file_aio_write() &
	xfs_setattr_size() with sb_start_write - sb_end_write
Message-ID: <20120124193529.GA20650@quack.suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-6-git-send-email-jack@suse.cz>
	<20120124071926.GM15102@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120124071926.GM15102@dastard>
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
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue 24-01-12 18:19:26, Dave Chinner wrote:
> On Fri, Jan 20, 2012 at 09:34:43PM +0100, Jan Kara wrote:
> > Replace racy xfs_wait_for_freeze() check in xfs_file_aio_write() with
> > a reliable sb_start_write() - sb_end_write() locking. Due to lock ranking
> > dictated by the page fault code we have to call sb_start_write() after we
> > acquire ilock.
> 
> It appears to me that you have indeed confused the ilock with the
> iolock.
> 
> > Similarly we have to protect xfs_setattr_size() because it can modify last
> > page of truncated file. Because ilock is dropped in xfs_setattr_size() we
> > have to drop and retake write access as well to avoid deadlocks.
> 
> > 
> > CC: Ben Myers <bpm@sgi.com>
> > CC: Alex Elder <elder@kernel.org>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_file.c |    6 ++++--
> >  fs/xfs/xfs_iops.c |    6 ++++++
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 753ed9b..9efd153 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -862,9 +862,11 @@ xfs_file_dio_aio_write(
> >  		*iolock = XFS_IOLOCK_SHARED;
> >  	}
> >  
> > +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
> >  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
> >  	ret = generic_file_direct_write(iocb, iovp,
> >  			&nr_segs, pos, &iocb->ki_pos, count, ocount);
> > +	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
> 
> That's inside the iolock, not the ilock. Either way, it is
> incorrect. This accounting should be outside the iolock - because
> xfs_trans_alloc() can be called with the iolock held. Therefore the
> freeze/lock order needs to be
> 
> 	sb_start_write(SB_FREEZE_WRITE)
> 	  XFS(ip)->i_iolock
> 	    XFS(ip)->i_ilock
> 	sb_end_write(SB_FREEZE_WRITE)
> 
> Which matches the current freeze/lock order.
  Hmm, so I was looking at this and I think there are following locking
constrants (please correct me if I have something wrong):
iolock -> trans start (per your claim above)
trans start -> ilock (ditto)
iolock -> mmap_sem (aio write holds iolock and copying data from userspace
  might need mmap sem if it hits page fault)
mmap_sem -> ilock (do_wp_page -> block_page_mkwrite -> __xfs_get_blocks)
freezing -> trans start (so that we can clean the filesystem during
              freezing)

So I see two choices here.
  1) Put 'freezing' above iolock as you suggest. But then handling the page
fault path becomes challenging. We cannot block there easily because we are
called with mmap_sem held. I just talked with Mel and it seems that
dropping mmap_sem in ->page_mkwrite(), blocking, retaking mmap_sem and
returning VM_FAULT_RETRY might work but we'll see whether some other mm guy
won't kill me for that ;).
  2) Put 'freezing' below mmap_sem. That would put it below iolock/i_mutex
as well. Then handling page fault is easy. We could not block in ->aio_write
but we'd have to block in ->write_begin() instead. Similarly we would have
to block in other write paths.

The first approach has the advantage that we could put lots of frozen
checks into VFS thus making them shared among filesystems (possibly even
making freezing reliable for filesystems such as ext2). The second approach
is simpler as we could do most of the freezing checks while we start a
transaction at least for filesystems that have transactions... Any
preferences?

								Honza
 
> > @@ -945,8 +949,6 @@ xfs_file_aio_write(
> >  	if (ocount == 0)
> >  		return 0;
> >  
> > -	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
> > -
> 
> that's where sb_start_write() needs to be, and the sb-end_write()
> call needs to below the generic_write_sync() calls that will trigger
> IO on O_SYNC writes. Otherwise it is not covering all the IO path
> correctly.
> 
> >  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> >  		return -EIO;
> >  
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 3579bc8..798b9c6 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -793,6 +793,7 @@ xfs_setattr_size(
> >  		return xfs_setattr_nonsize(ip, iattr, 0);
> >  	}
> >  
> > +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
> >  	/*
> >  	 * Make sure that the dquots are attached to the inode.
> >  	 */
> > @@ -849,10 +850,14 @@ xfs_setattr_size(
> >  				     xfs_get_blocks);
> >  	if (error)
> >  		goto out_unlock;
> > +	/* Drop the write access to avoid lock inversion with ilock */
> > +	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	lock_flags |= XFS_ILOCK_EXCL;
> >  
> > +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
> > +
> 
> This is caused by the previous problems I pointed out. You should
> not need to drop the freeze reference here at all.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
