Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JGICOp216782 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:18:28 -0500
Date: Wed, 19 Aug 2009 12:18:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/17] vfs: Remove syncing from
	generic_file_direct_write() and generic_file_buffered_write()
Message-ID: <20090819161853.GC6150@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1250697884-22288-4-git-send-email-jack@suse.cz>
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
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, hch@infradead.org, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com

On Wed, Aug 19, 2009 at 06:04:30PM +0200, Jan Kara wrote:
> generic_file_direct_write() and generic_file_buffered_write() called
> generic_osync_inode() if it was called on O_SYNC file or IS_SYNC inode. But
> this is superfluous since generic_file_aio_write() does the syncing as well.
> Also XFS and OCFS2 which call these functions directly handle syncing
> themselves. So let's have a single place where syncing happens:
> generic_file_aio_write().

Yeah, this is something that never made any sense to me.

> @@ -2187,20 +2187,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
>  		}
>  		*ppos = end;
>  	}
> -
> -	/*
> -	 * Sync the fs metadata but not the minor inode changes and
> -	 * of course not the data as we did direct DMA for the IO.
> -	 * i_mutex is held, which protects generic_osync_inode() from
> -	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
> -	 */
>  out:
> -	if ((written >= 0 || written == -EIOCBQUEUED) &&
> -	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
> -		int err = generic_osync_inode(inode, mapping, OSYNC_METADATA);
> -		if (err < 0)
> -			written = err;
> -	}
>  	return written;

Here we check (written >= 0 || written == -EIOCBQUEUED), but
generic_file_aio_write only cares about positive return values.  We
defintively do have a change here for partial AIO requests.  The
question is if the previous behaviour made in sense.  If do have an
O_SYNC aio+dio request we would have to flush out the metadata after the
request has completed and not here.

> @@ -2343,16 +2328,6 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
>  	if (likely(status >= 0)) {
>  		written += status;
>  		*ppos = pos + status;
> -
> -		/*
> -		 * For now, when the user asks for O_SYNC, we'll actually give
> -		 * O_DSYNC
> -		 */
> -		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
> -			if (!a_ops->writepage || !is_sync_kiocb(iocb))
> -				status = generic_osync_inode(inode, mapping,
> -						OSYNC_METADATA|OSYNC_DATA);
> -		}
>    	}

No problem with -EIOCBQUEUED here, but we change from doing
generic_osync_inode with OSYNC_DATA which does a full writeout of the
data to sync_page_range which only does the range writeout here.  That
should be fine (as we only need to sync that range), but should probably
be documented in the patch description.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
