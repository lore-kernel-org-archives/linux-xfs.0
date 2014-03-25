Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 182487F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 07:58:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00DE08F8049
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 05:58:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 03apvM2rjxp0ZPEG for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 05:58:32 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2PCw6IU003446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 08:58:11 -0400
Date: Tue, 25 Mar 2014 08:58:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix buffer use after free on IO error
Message-ID: <20140325125754.GA18691@bfoster.bfoster>
References: <532CFA12.4040104@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <532CFA12.4040104@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 21, 2014 at 09:48:50PM -0500, Eric Sandeen wrote:
> When testing exhaustion of dm snapshots, the following appeared
> with CONFIG_DEBUG_OBJECTS_FREE enabled:
> 
> ODEBUG: free active (active state 0) object type: work_struct hint: xfs_buf_iodone_work+0x0/0x1d0 [xfs]
> 
> indicating that we'd freed a buffer which still had a pending reference,
> down this path:
> 
> [  190.867975]  [<ffffffff8133e6fb>] debug_check_no_obj_freed+0x22b/0x270
> [  190.880820]  [<ffffffff811da1d0>] kmem_cache_free+0xd0/0x370
> [  190.892615]  [<ffffffffa02c5924>] xfs_buf_free+0xe4/0x210 [xfs]
> [  190.905629]  [<ffffffffa02c6167>] xfs_buf_rele+0xe7/0x270 [xfs]
> [  190.911770]  [<ffffffffa034c826>] xfs_trans_read_buf_map+0x7b6/0xac0 [xfs]
> 
> At issue is the fact that if IO fails in xfs_buf_iorequest,
> we'll queue completion unconditionally, and then call
> xfs_buf_rele; but if IO failed, there are no IOs remaining,
> and xfs_buf_rele will free the bp while work is still queued.
> 
> Fix this by not scheduling completion if the buffer has
> an error on it; run it immediately.  The rest is only comment
> changes.
> 
> Thanks to dchinner for spotting the root cause.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. or maybe this could be moved into _xfs_buf_ioend ...
> I think I see some nice cleanups for xfs_buf_ioend vs.
> _xfs_buf_ioend w.r.t. when "schedule" is true, so maybe
> I can clean it up then.
> 
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9c061ef..45eb5ef 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1361,21 +1361,29 @@ xfs_buf_iorequest(
>  		xfs_buf_wait_unpin(bp);
>  	xfs_buf_hold(bp);
>  
> -	/* Set the count to 1 initially, this will stop an I/O
> +	/*
> +	 * Set the count to 1 initially, this will stop an I/O
>  	 * completion callout which happens before we have started
>  	 * all the I/O from calling xfs_buf_ioend too early.
>  	 */
>  	atomic_set(&bp->b_io_remaining, 1);
>  	_xfs_buf_ioapply(bp);
> -	_xfs_buf_ioend(bp, 1);
> +	/*
> +	 * If _xfs_buf_ioapply failed, we'll get back here with
> +	 * only the reference we took above.  _xfs_buf_ioend will
> +	 * drop it to zero, so we'd better not queue it for later,
> +	 * or we'll free it before it's done.
> +	 */
> +	_xfs_buf_ioend(bp, bp->b_error ? 0 : 1);
>  

Out of curiosity, is there any major reason we don't use 0 here
unconditionally? Are we worried about I/O completing before we have a
chance to decrement the reference?

Looks good to me either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	xfs_buf_rele(bp);
>  }
>  
>  /*
>   * Waits for I/O to complete on the buffer supplied.  It returns immediately if
> - * no I/O is pending or there is already a pending error on the buffer.  It
> - * returns the I/O error code, if any, or 0 if there was no error.
> + * no I/O is pending or there is already a pending error on the buffer, in which
> + * case nothing will ever complete.  It returns the I/O error code, if any, or
> + * 0 if there was no error.
>   */
>  int
>  xfs_buf_iowait(
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
