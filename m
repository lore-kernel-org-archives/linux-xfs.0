Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q558hRWa062732 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 03:43:27 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id i8qumac2VxOazQZA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 01:43:25 -0700 (PDT)
Date: Tue, 5 Jun 2012 10:43:21 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 18/27] xfs: Convert to new freezing code
Message-ID: <20120605084321.GA17438@quack.suse.cz>
References: <1338589841-9568-1-git-send-email-jack@suse.cz>
	<1338589841-9568-19-git-send-email-jack@suse.cz>
	<20120605041546.GB3019@devil.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120605041546.GB3019@devil.redhat.com>
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
To: Dave Chinner <dchinner@redhat.com>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org

On Tue 05-06-12 14:15:46, Dave Chinner wrote:
> On Sat, Jun 02, 2012 at 12:30:32AM +0200, Jan Kara wrote:
> > Generic code now blocks all writers from standard write paths. So we add
> > blocking of all writers coming from ioctl (we get a protection of ioctl against
> > racing remount read-only as a bonus) and convert xfs_file_aio_write() to a
> > non-racy freeze protection. We also keep freeze protection on transaction
> > start to block internal filesystem writes such as removal of preallocated
> > blocks.
> 
> I don't think this will apply to a current TOT XFS - the end_io
> context hunks look wrong. Perhaps your rebased this before the XFS
> tree was merged?
  Umm, doesn't look like that. I've based my patches on top of
51eab603f5c86dd1eae4c525df3e7f7eeab401d6 which is after XFS merge. 

> > CC: Ben Myers <bpm@sgi.com>
> > CC: Alex Elder <elder@kernel.org>
> > CC: xfs@oss.sgi.com
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_aops.c    |   18 ++++++++++++++++
> >  fs/xfs/xfs_file.c    |   10 ++++++--
> >  fs/xfs/xfs_ioctl.c   |   55 +++++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_ioctl32.c |   12 ++++++++++
> >  fs/xfs/xfs_iomap.c   |    4 +-
> >  fs/xfs/xfs_mount.c   |    2 +-
> >  fs/xfs/xfs_mount.h   |    3 --
> >  fs/xfs/xfs_sync.c    |    2 +-
> >  fs/xfs/xfs_trans.c   |   17 ++++++++++++--
> >  fs/xfs/xfs_trans.h   |    2 +
> >  10 files changed, 109 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index ae31c31..4a001b8 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -124,6 +124,12 @@ xfs_setfilesize_trans_alloc(
> >  	ioend->io_append_trans = tp;
> >  
> >  	/*
> > +	 * We will pass freeze protection with a transaction.  So tell lockdep
> > +	 * we released it.
> > +	 */
> > +	rwsem_release(&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
> > +		      1, _THIS_IP_);
> > +	/*
> 
> Oh, that's rather ugly. If this is necessary where a transaction
> handle is passed to another thread and completed there, then this
> really needs to be wrapped in helper functions so it is always done
> correctly when the PF_TRANS flag is also transferred. That can be
> done later, though. It will also need to be done to the allocation
> code which passes allocation off to a workqueue, but that is
> currently synchronous so won't be a problem for this change right
> now...
  This lockdep magic is necessary because lockdep freaks out if you acquire
lock in one process and release it in another one. But wrapping that inside a
function is a good idea.

> > @@ -631,7 +638,11 @@ xfs_ioc_space(
> >  	if (ioflags & IO_INVIS)
> >  		attr_flags |= XFS_ATTR_DMI;
> >  
> > +	error = mnt_want_write_file(filp);
> > +	if (error)
> > +		return error;
> >  	error = xfs_change_file_space(ip, cmd, bf, filp->f_pos, attr_flags);
> > +	mnt_drop_write_file(filp);
> >  	return -error;
> 
> Those positive/negative error conversions are starting to get
> confusing and difficult to get right. I'm going to have to convert
> XFS at some point to return negative errors everywhere so we can get
> rid of that problem once and for all...
  Yeah, it's a bit messy.

> Otherwise, this looks OK. I'll need to pull this in and test it, but
> the I was using the previous version of the patch series for almost
> the entire 3.4-rc cycle and didn't come across any problems with
> it....
  Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
