Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7596F7F37
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 19:45:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6136F8F8035
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 17:45:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WCsu06TckgrzlcFD for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 17:45:08 -0700 (PDT)
Date: Fri, 12 Jul 2013 10:44:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] direct-io: Implement generic deferred AIO completions
Message-ID: <20130712004421.GE3438@dastard>
References: <1373493739-2243-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373493739-2243-1-git-send-email-jack@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com, hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Jul 11, 2013 at 12:02:18AM +0200, Jan Kara wrote:
> From: Christoph Hellwig <hch@infradead.org>
> 
> Add support to the core direct-io code to defer AIO completions to user
> context using a workqueue.  This replaces opencoded and less efficient
> code in XFS and ext4 and will be needed to properly support O_(D)SYNC
> for AIO.

I don't see how this is any more efficient than the deferral
that XFS already does for direct IO completion - it just changes
what queues IO for completions. And on that topic:

> Currently this creates a per-superblock unbound workqueue for these
> completions, which is taken from an earlier patch by Jan Kara.  I'm
> not really convinced about this use and would prefer a "normal" global
> workqueue with a high concurrency limit, but this needs further discussion.

Unbound workqueues sacrifice locality for immediate dispatch.
AIO-DIO performance at the high end is determined by IO submission
and completion locality - we want submission and completion to occur
on the same CPU as much as possible so cachelines are not bounced
aroundi needlessly. An unbound workqueue would seem to be the wrong
choice on this basis alone.

Further the use of @max_active = 1 means that it is a global, single
threaded workqueue. While ext4 might require single threaded
execution of unwritten extent completion, it would be introducing a
massive bottleneck into XFS which currently uses the default
concurrency depth of 256 worker threads per CPU per superblock just
for unwritten extent conversion.

Hmmmm. I notice that the next patch then does generic_write_sync()
is the IO completion handler, too. In XFS that causes log forces and
will block, so that's yet more concurrency required that is required
for this workqueue. Doing this in a single threaded workqueue and
marshalling all sync AIO through it is highly unfriendly to
concurrent IO completion.

FWIW, in XFS we queue unwritten extent conversion completions on a
different workqueue to EOF size update completions because the
latter are small, fast and rarely require IO or get blocked. The
data IO completion workqueue for EOF updates has the same
concurrency and depth as the unwritten extent work queue (i.e. 256
workers per cpu per superblock). So pushing all of this DIO and EOF
completion work into a single threaded global workqueue that can
block in every IO completion doesn't seem like a very smart idea to
me...

> -static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
> +static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
> +		bool is_async)
>  {
>  	ssize_t transferred = 0;
>  
> @@ -258,19 +262,26 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
>  	if (ret == 0)
>  		ret = transferred;
>  
> -	if (dio->end_io && dio->result) {
> -		dio->end_io(dio->iocb, offset, transferred,
> -			    dio->private, ret, is_async);
> -	} else {
> -		inode_dio_done(dio->inode);
> -		if (is_async)
> -			aio_complete(dio->iocb, ret, 0);
> -	}
> +	if (dio->end_io && dio->result)
> +		dio->end_io(dio->iocb, offset, transferred, dio->private);

Ok, so by here we are assuming all filesystem IO completion
processing is completed.

> +
> +	inode_dio_done(dio->inode);
> +	if (is_async)
> +		aio_complete(dio->iocb, ret, 0);
>  
> +	kmem_cache_free(dio_cache, dio);
>  	return ret;

Hmmm. I started wonder if this is valid, because XFS is supposed to
be doing workqueue based IO completion for appending writes and they
are supposed to be run in a workqueue.

But, looking at the XFS code, there's actually a bug in the direct
IO completion code and we are not defering completion to a workqueue
like we should be for the append case.  This code in
xfs_finish_ioend() demonstrates the intent:

                if (ioend->io_type == XFS_IO_UNWRITTEN)
                        queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
                else if (ioend->io_append_trans ||
>>>>>>                   (ioend->io_isdirect && xfs_ioend_is_append(ioend)))
                        queue_work(mp->m_data_workqueue, &ioend->io_work);

The problem is that we only ever call xfs_finish_ioend() if is_async
is true, and that will never be true for direct IO beyond the current
EOF. That's a bug, and is Bad(tm).

[ Interestingly, it turns out that dio->is_async is never set for
writes beyond EOF because of filesystems that update file sizes
before data IO completion occurs (stale data exposure issues). For
XFS, that can't happen and so dio->is_async could always be set.... ]

What this means is that there's a condition for work queue deferral
of DIO IO completion that this patch doesn't handle. Setting deferral
only on unwritten extents like this:

> @@ -1292,8 +1281,10 @@ __xfs_get_blocks(
>  		if (create || !ISUNWRITTEN(&imap))
>  			xfs_map_buffer(inode, bh_result, &imap, offset);
>  		if (create && ISUNWRITTEN(&imap)) {
> -			if (direct)
> +			if (direct) {
>  				bh_result->b_private = inode;
> +				set_buffer_defer_completion(bh_result);
> +			}
>  			set_buffer_unwritten(bh_result);
>  		}
>  	}

misses that case. I suspect Christoph's original patch predated the
changes to XFS that added transactional file size updates to IO
completion and so didn't take it into account.

> @@ -1390,9 +1381,7 @@ xfs_end_io_direct_write(
>  	struct kiocb		*iocb,
>  	loff_t			offset,
>  	ssize_t			size,
> -	void			*private,
> -	int			ret,
> -	bool			is_async)
> +	void			*private)
>  {
>  	struct xfs_ioend	*ioend = iocb->private;
>  
> @@ -1414,17 +1403,10 @@ xfs_end_io_direct_write(
>  
>  	ioend->io_offset = offset;
>  	ioend->io_size = size;
> -	ioend->io_iocb = iocb;
> -	ioend->io_result = ret;
>  	if (private && size > 0)
>  		ioend->io_type = XFS_IO_UNWRITTEN;
>  
> -	if (is_async) {
> -		ioend->io_isasync = 1;
> -		xfs_finish_ioend(ioend);
> -	} else {
> -		xfs_finish_ioend_sync(ioend);
> -	}
> +	xfs_finish_ioend_sync(ioend);
>  }

As i mentioned, the existing code here is buggy. What we should be
doing here is:

	if (is_async) {
		ioend->io_isasync = 1;
		xfs_finish_ioend(ioend);
	} else if (xfs_ioend_is_append(ioend))) {
		xfs_finish_ioend(ioend);
	} else {
		xfs_finish_ioend_sync(ioend);
	}

Which means that the new code boils down to:

	if (xfs_ioend_is_append(ioend)))
		xfs_finish_ioend(ioend);
	else
		xfs_finish_ioend_sync(ioend);

And now we see the problem with the only defering unwritten IO -
the new direct IO code will think IO is completed when all we've
done is queued it to another workqueue.

I'm not sure we can handle this in get_blocks - we don't have the
context to know how to treat allocation beyond the current EOF.
Indeed, the current block being mapped might not be beyond EOF, but
some of the IO might be (e.g. lies across an extent boundary),
so setting the deferred completion in get_blocks doesn't allow the
entire IO to be treated the same.

So I think there's a bit of re-thinking needed to aspects of this
patch to be done.

> +		 * avoids problems with pseudo filesystems which get initialized
> +		 * before workqueues can be created
> +		 */
> +		if (type->fs_flags & FS_REQUIRES_DEV) {
> +			s->s_dio_done_wq =
> +				alloc_workqueue("dio-sync", WQ_UNBOUND, 1);

The workqueue name needs to be combined with the fs_name so we know
what filesystem is having problems in sysrq-w output.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
