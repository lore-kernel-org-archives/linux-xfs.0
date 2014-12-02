Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73F757F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 10:59:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42FAE304059
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 08:59:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 2P7aA3CnfHmSPWbi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 08:59:30 -0800 (PST)
Date: Tue, 2 Dec 2014 08:59:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: lobotomise xfs_trans_read_buf_map()
Message-ID: <20141202165930.GA28571@infradead.org>
References: <1417473290-17544-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417473290-17544-1-git-send-email-david@fromorbit.com>
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

On Tue, Dec 02, 2014 at 09:34:50AM +1100, Dave Chinner wrote:
> The only way we can find a buffer that has not had IO completed on
> it is if it had readahead issued on it, but we never do readahead on
> buffers that we have already joined into a transaction. Hence this
> condition cannot occur, and buffers locked and joined into a
> transaction should always be marked done and not under IO.

Should we add an ASSERT that would trigger when someone tries
to issue readahead on a buffer with b_transp set?

>  	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
> -	if (bp == NULL) {
> -		*bpp = NULL;
> -		return (flags & XBF_TRYLOCK) ?
> -					0 : -ENOMEM;
> +	if (!bp) {
> +		if (!(flags & XBF_TRYLOCK))
> +			return -ENOMEM;
> +		return tp ? 0 : -EAGAIN;

Can you fix the inconsistent return for the trylock case in a follow on
patch?  This difference doesn't look intentional to me, and I would
be surprised if it's correctly handled in the callers.

>  	}
> +
>  	if (bp->b_error) {
>  		error = bp->b_error;
> +		if (!XFS_FORCED_SHUTDOWN(mp))
> +			xfs_buf_ioerror_alert(bp, __func__);
> +		bp->b_flags &= ~XBF_DONE;
>  		xfs_buf_stale(bp);
> -		XFS_BUF_DONE(bp);

The old non-tp case did a XFS_BUF_UNDONE, which you open code here,
while the with-tp case did a XFS_BUF_DONE.  I think this change needs
a little explanation.

>  #ifdef DEBUG
> -	if (xfs_do_error && !(tp->t_flags & XFS_TRANS_DIRTY)) {
> +	if (xfs_do_error && (!tp || !(tp->t_flags & XFS_TRANS_DIRTY))) {
>  		if (xfs_error_target == target) {
>  			if (((xfs_req_num++) % xfs_error_mod) == 0) {
> -				xfs_force_shutdown(tp->t_mountp,
> -						   SHUTDOWN_META_IO_ERROR);
>  				xfs_buf_relse(bp);
> -				xfs_debug(mp, "Returning trans error!");
> +				xfs_debug(mp, "Returning error!");
>  				return -EIO;
>  			}
>  		}

I would suggest to kill this xfs_do_error error code, it's the last
use of the never initialized xfs_do_error and xfs_error_target
variables.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
