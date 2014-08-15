Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B09967F3F
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 08:10:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73AA18F8089
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 06:10:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CzsAbCThTgyHv5v3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 06:10:20 -0700 (PDT)
Date: Fri, 15 Aug 2014 06:10:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20140815131020.GB27856@infradead.org>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408084747-4540-9-git-send-email-david@fromorbit.com>
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

> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2f1e30d..c53cc03 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1157,12 +1157,7 @@ xfs_zero_remaining_bytes(

xfs_zero_remaining_bytes really should be switched to
xfs_buf_read_uncached + xfs_bwrite instead of all this mess just to
micro-optimize a few memory allocation away that don't even happen for
the common case of blocksize == PAGE_SIZE.  I'm not even sure we
should be using the buffer cache at all for something inside a regular
file, but that's a discussion for another time.

>  void
> +xfs_buf_submit(
> +	struct xfs_buf	*bp)
>  {
>  	trace_xfs_buf_iorequest(bp, _RET_IP_);

I suspect these two should have properly name and separate trace
points now?

It also seems like a lot of the guts of the two functions are
still the same, so factoring that into a __xfs_buf_submit helper
would be useful.

> +	 * If _xfs_buf_ioapply failed, 
> +	 * we can get back here with only the IO
>  	 * reference we took above.  _xfs_buf_ioend will drop it to zero, so
>  	 * we'd better run completion processing synchronously so that the we
> +	 * don't return to the caller with completion still pending.
> +	 * this allows the caller to check b_error safely without
> +	 * waiting
>  	 */
>  	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
>  		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))

I don't think the !ASYNC case can happen here, can it?

> +		if (!wait)
>  			list_del_init(&bp->b_list);
> +		else
> +			xfs_buf_hold(bp);

Maybe switch this around to avoid the negated condition in the if else?

Also might this be worth a change of it's own?

> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -286,18 +286,13 @@ xfs_trans_read_buf_map(
>  			bp->b_flags |= XBF_READ;
>  			bp->b_ops = ops;
>  
> +			error = xfs_buf_submit_wait(bp);
>  			if (error) {
> +				if (!XFS_FORCED_SHUTDOWN(mp)) {
> +					xfs_buf_ioerror_alert(bp, __func__);
> +					goto out_do_shutdown;
> +				}
> +				goto out_stale;

Again maybe reverse the conditions here for a cleaner flow?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
