Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKK6K8G208114 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 14:06:20 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SHHQ9HsOZawfIfvG for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 12:08:29 -0800 (PST)
Date: Wed, 21 Nov 2012 07:08:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: honor the O_SYNC flag for aysnchronous direct
	I/O requests
Message-ID: <20121120200827.GE2591@dastard>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120075114.25270.40680.stgit@blackbox.djwong.org>
	<20121120112038.GC2591@dastard>
	<x49wqxghxhj.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49wqxghxhj.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, djwong+kernel@djwong.org, jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org

On Tue, Nov 20, 2012 at 02:42:48PM -0500, Jeff Moyer wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > And requeuing work from one workqueue to the next is something that
> > we can avoid.  We know at IO submission time (i.e.
> > xfs_vm_direct_io)) whether an fsync completion is going to be needed
> > during Io completion.  The ioend->io_needs_fsync flag can be set
> > then, and the first pass through xfs_finish_ioend() can queue it to
> > the correct workqueue.  i.e. it only needs to be queued if it's not
> > already an unwritten or append ioend and it needs an fsync.
> >
> > As it is, all the data completion workqueues run the same completion
> > function so all you need to do is handle the fsync case at the end
> > of the existing processing - it's not an else case. i.e the end of
> > xfs_end_io() becomes:
> >
> > 	if (ioend->io_needs_fsync) {
> > 		error = xfs_ioend_fsync(ioend);
> > 		if (error)
> > 			ioend->io_error = -error;
> > 		goto done;
> > 	}
> > done:
> > 	xfs_destroy_ioend(ioend);
> 
> Works for me, that makes things simpler.
> 
> > As it is, this code is going to change before these changes go in -
> > there's a nasty regression in the DIO code that I found this
> > afternoon that requires reworking this IO completion logic to
> > avoid. The patch will appear on the list soon....
> 
> I'm not on the xfs list, so if you haven't already sent it, mind Cc-ing
> me?

http://oss.sgi.com/archives/xfs/2012-11/msg00493.html

First cut is here, but it will change a bit as review goes on...

> >> --- a/fs/xfs/xfs_mount.h
> >> +++ b/fs/xfs/xfs_mount.h
> >> @@ -209,6 +209,7 @@ typedef struct xfs_mount {
> >>  	struct workqueue_struct	*m_data_workqueue;
> >>  	struct workqueue_struct	*m_unwritten_workqueue;
> >>  	struct workqueue_struct	*m_cil_workqueue;
> >> +	struct workqueue_struct *m_aio_blkdev_flush_wq;
> >
> > 	struct workqueue_struct *m_aio_fsync_wq;
> 
> For the record, m_aio_blkdev_flush_wq is the name you chose previously.
> ;-)

<cue Led Zeppelin>

It's been a long time since I read that patch....

:)

Cheers,

Dave....
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
