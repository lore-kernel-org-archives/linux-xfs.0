Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 126147FA4
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 15:21:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F09AC8F8068
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 13:21:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KYKVInB9oupumeqy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 13:21:43 -0700 (PDT)
Date: Fri, 10 Apr 2015 16:21:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: DIO requires an ioend for writes
Message-ID: <20150410202137.GA2846@laptop.bfoster>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
	<1428673080-23052-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428673080-23052-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 10, 2015 at 11:37:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Right now unwritten extent conversion information is passed by
> making the end IO private data non-null, which does not enable us to
> pass any information from submission context to completion context,
> which we need to use the standard IO completion paths.
> 
> Allocate an ioend in block allocation for direct IO and attach it to
> the mapping buffer used during direct IO block allocation. Factor
> the mapping code to make it obvious that this is happening only for
> direct IO writes, and and place the mapping info and IO type
> directly into the ioend for use in completion context.
> 
> The completion is changed to check the ioend type to determine if
> unwritten extent completion is necessary or not.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 79 ++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 61 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 3a9b7a1..d95a42b 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1233,6 +1233,57 @@ xfs_vm_releasepage(
>  	return try_to_free_buffers(page);
>  }
>  
> +static void
> +xfs_get_blocks_map_buffer(
> +	struct inode		*inode,
> +	struct buffer_head	*bh_result,
> +	int			create,
> +	int			direct,
> +	struct xfs_bmbt_irec	*imap,
> +	xfs_off_t		offset,
> +	ssize_t			size)
> +{
> +	struct xfs_ioend	*ioend;
> +	int			type;
> +
> +	if (!create) {
> +		/*
> +		 * Unwritten extents do not report a disk address for
> +		 * the read case (treat as if we're reading into a hole).
> +		 */
> +		if (!ISUNWRITTEN(imap))
> +			xfs_map_buffer(inode, bh_result, imap, offset);
> +		return;
> +	}

This logic was kind of ugly to begin with, but I think the refactoring
exposes it further. There's rather twisty logic here just for a case
where we don't do anything. In other words, the fact that we have early
return logic in this function that ultimately jumps us back up through
two levels of scope (e.g., this function, the if branch in the caller)
is good indication that the logic could be improved.

I think we could lift the (!create && ISUNWRITTEN()) case up into the
top most check, along with the comment as to why, and skip the entire
codepath in that case. That also kills the duplicate xfs_map_buffer()
call above so long as we do something like this:

> +
> +	xfs_map_buffer(inode, bh_result, imap, offset);
	if (!create)
		return;

... but I think we could clean it up even further than that. This
function gets rather busy in the subsequent patch so I think there's
value in isolating it to managing direct I/O and lifting the common
stuff back into xfs_get_blocks() (see below). This means we could also
kill both of the create and direct parameters because they aren't used
at all beyond the !direct check a few lines below.

> +
> +	if (ISUNWRITTEN(imap))
> +		set_buffer_unwritten(bh_result);
> +
> +	if (!direct)
> +		return;
> +
> +	/*
> +	 * Direct IO writes require an ioend to be allocated and
> +	 * passed via the returned mapping. This allows the end
> +	 * io function to determine the correct course of
> +	 * action.
> +	 */
> +
> +	if (ISUNWRITTEN(imap)) {
> +		type = XFS_IO_UNWRITTEN;
> +		set_buffer_defer_completion(bh_result);
> +	} else
> +		type = XFS_IO_OVERWRITE;
> +	ioend = xfs_alloc_ioend(inode, type);
> +	ioend->io_offset = offset;
> +	ioend->io_size = size;
> +	bh_result->b_private = ioend;
> +
> +	return;

Pointless return... not a big deal given this is converted from a void
function in the subsequent patch.

> +}
> +
>  STATIC int
>  __xfs_get_blocks(
>  	struct inode		*inode,
> @@ -1252,6 +1303,7 @@ __xfs_get_blocks(
>  	ssize_t			size;
>  	int			new = 0;
>  
> +
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> @@ -1332,21 +1384,9 @@ __xfs_get_blocks(
>  	}
>  
>  	if (imap.br_startblock != HOLESTARTBLOCK &&
> -	    imap.br_startblock != DELAYSTARTBLOCK) {
> -		/*
> -		 * For unwritten extents do not report a disk address on
> -		 * the read case (treat as if we're reading into a hole).
> -		 */
> -		if (create || !ISUNWRITTEN(&imap))
> -			xfs_map_buffer(inode, bh_result, &imap, offset);
> -		if (create && ISUNWRITTEN(&imap)) {
> -			if (direct) {
> -				bh_result->b_private = inode;
> -				set_buffer_defer_completion(bh_result);
> -			}
> -			set_buffer_unwritten(bh_result);
> -		}
> -	}
> +	    imap.br_startblock != DELAYSTARTBLOCK)
> +		xfs_get_blocks_map_buffer(inode, bh_result, create, direct,
> +					  &imap, offset, size);

So if we pull some of the bits from xfs_get_blocks_map_buffer() back up,
I end up with something like the the following here. Compile tested
only, but illustrates the point:

        /*
         * Map the buffer as long as we have physical blocks and this isn't a
         * read of an unwritten extent. Treat reads into unwritten extents as
         * holes and thus do not return a mapping.
         */
        if (imap.br_startblock != HOLESTARTBLOCK &&
            imap.br_startblock != DELAYSTARTBLOCK &&
            (create || !ISUNWRITTEN(&imap))) {
                xfs_map_buffer(inode, bh_result, &imap, offset);
		/* unwritten implies create due to check above */
                if (ISUNWRITTEN(&imap))
                        set_buffer_unwritten(bh_result);
                /* direct writes have a special mapping */
                if (create && direct) {
                        error = xfs_map_direct(inode, bh_result, &imap, offset);
                        if (error)
                                return error;
                }
        }

I renamed the helper to xfs_map_direct(), killed everything therein up
through the !direct check and killed both the create and direct params.
Thoughts?

Brian

>  
>  	/*
>  	 * If this is a realtime file, data may be on a different device.
> @@ -1455,9 +1495,10 @@ xfs_end_io_direct_write(
>  	struct inode		*inode = file_inode(iocb->ki_filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ioend	*ioend = private;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> -		return;
> +		goto out_destroy_ioend;
>  
>  	/*
>  	 * While the generic direct I/O code updates the inode size, it does
> @@ -1477,7 +1518,7 @@ xfs_end_io_direct_write(
>  	 * we can pass the ioend to the direct IO allocation callbacks and
>  	 * avoid nesting that way.
>  	 */
> -	if (private && size > 0) {
> +	if (ioend->io_type == XFS_IO_UNWRITTEN && size > 0) {
>  		xfs_iomap_write_unwritten(ip, offset, size);
>  	} else if (offset + size > ip->i_d.di_size) {
>  		struct xfs_trans	*tp;
> @@ -1487,11 +1528,13 @@ xfs_end_io_direct_write(
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
>  		if (error) {
>  			xfs_trans_cancel(tp, 0);
> -			return;
> +			goto out_destroy_ioend;
>  		}
>  
>  		xfs_setfilesize(ip, tp, offset, size);
>  	}
> +out_destroy_ioend:
> +	xfs_destroy_ioend(ioend);
>  }
>  
>  STATIC ssize_t
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
