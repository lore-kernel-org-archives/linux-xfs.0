Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0SExduq142089 for <xfs@oss.sgi.com>; Sat, 28 Jan 2012 08:59:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	p8TPiYscdw2qZQeL (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Jan 2012 06:59:36 -0800 (PST)
Date: Sat, 28 Jan 2012 09:59:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: honor the O_SYNC flag for aysnchronous direct
	I/O requests
Message-ID: <20120128145933.GA10931@infradead.org>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-2-git-send-email-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1327698949-12616-2-git-send-email-jmoyer@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

This looks pretty good.  Did this past xfstests?  I'd also like to add
tests actually executing this code path just, to be sure.  E.g. variants
of aio-stress actually using O_SYNC.  We can't easily test data really
made it to disk that way, although at least we make sure the code
doesn't break.

On Fri, Jan 27, 2012 at 04:15:47PM -0500, Jeff Moyer wrote:
> Hi,
> 
> If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
> flushed after the write completion.  Instead, it's flushed *before* the
> I/O is sent to the disk (in __generic_file_aio_write).

XFS doesn't actually use __generic_file_aio_write, so this sentence
isn't correct for XFS.

> +	} else if (xfs_ioend_needs_cache_flush(ioend)) {
> +		struct xfs_inode *ip = XFS_I(ioend->io_inode);
> +		struct xfs_mount *mp = ip->i_mount;
> +		int	err;
> +		int	log_flushed = 0;
> +
> +		/*
> +		 * Check to see if we only need to sync data.  If so,
> +		 * we can skip the log flush.
> +		 */
> +		if (IS_SYNC(ioend->io_inode) ||
> +		    (ioend->io_iocb->ki_filp->f_flags & __O_SYNC)) {

> +			err = _xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);

Can you add a TODO comment that this actually is synchronous and thus
will block the I/O completion work queue?

Also you can use _xfs_log_force_lsn here as don't need to flush the
whole log, just up to the last lsn that touched the inode.  Copy, or
better factor the code from xfs_dir_fsync for that.

Last but not least this won't catch timestamp updates.  Given that I'm
about to send a series making timestamp updates transaction I would not
recommend you to bother with that, but if you want to take a look
at how xfs_file_fsync deals with them.  Given that this series touches
the same area I'd also like to take your xfs patch in through the xfs tree
to avoid conflicts.

> @@ -47,6 +47,7 @@ STATIC int xfsbufd(void *);
>  static struct workqueue_struct *xfslogd_workqueue;
>  struct workqueue_struct *xfsdatad_workqueue;
>  struct workqueue_struct *xfsconvertd_workqueue;
> +struct workqueue_struct *xfsflushd_workqueue;
>  
>  #ifdef XFS_BUF_LOCK_TRACKING
>  # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
> @@ -1802,8 +1803,15 @@ xfs_buf_init(void)
>  	if (!xfsconvertd_workqueue)
>  		goto out_destroy_xfsdatad_workqueue;
>  
> +	xfsflushd_workqueue = alloc_workqueue("xfsflushd",
> +					      WQ_MEM_RECLAIM, 1);

This should allow a higher concurrently level, it's probably a good
idea to pass 0 and use the default.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
