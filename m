Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 04:25:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9ABPBaA031977
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 04:25:16 -0700
Date: Wed, 10 Oct 2007 21:25:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: use correct buffer flags when reading superblock
Message-ID: <20071010112505.GH23367404@sgi.com>
References: <470C8F5B.90705@sgi.com> <20071010093451.GA7655@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010093451.GA7655@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 10, 2007 at 10:34:51AM +0100, Christoph Hellwig wrote:
> On Wed, Oct 10, 2007 at 06:37:47PM +1000, Lachlan McIlroy wrote:
> > When reading the superblock during log recovery we are not setting
> > the correct buffer flags.  Specifically we are not turning off flags
> > we do not need such as XBF_ASYNC that is causing the synchronous
> > xfs_iowait() to hang.  We should also turn off XBF_WRITE and remove
> > the buffer from the delay write queue just to be safe.
> 
> Where are these set up in the first time?  AFAICS the buffer only written
> out by xfs_unmountfs_writesb, xfs_syncsub and xfs_trans_log_buf, and all
> these should only ever happen after log recovery has finished.

It can also be written by xfsbufd when it has been bdwrite()
or as a result of log tail pushing.

And in the case of log recovery, if the superblock buffer is in a
transaction that is recovered, xlog_recover_do_buffer_trans() will
bdwrite() it after it has been recovered. Hence it will be on the
delwri list.

Once recovery is complete, xlog_do_recover() then calls XFS_bflush()
to write them all out and wait for them. This is down by
xfs_flush_buftarg() with the wait flag set, so the async flag on the
buffer should be cleared. This is normally the case.

The issue here is that when we openteh buftarg, we start up the
xfsbufd which will periodically flush the delwri list
asynchronously. If recovery takes long enough, it may flush the
delwri list before recovery completes.In this case, instead of doing
a sync write we'll get an async write being done and that leaves the
XBF_ASYNC flag hanging around on the buffer at I/O completion. 

Because the superblock buffer is XBF_FS_MANAGED, it does not get
torn down when it is clean and has no references, so the XBF_ASYNC
flag never gets cleared unless the fs specifically clears it. If the
superblock is then not recovered out of any further transactions
during recovery after xfsbufd flushed it, the XBF_ASYNC flag remains
set for the re-read that is issued in xlog_do_recover() and we
hang.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
