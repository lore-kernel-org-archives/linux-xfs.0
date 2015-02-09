Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 12DA97F9F
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 12:25:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01E8E8F804C
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 10:25:45 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Zelwo7xhgQyGPs9N (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 10:25:44 -0800 (PST)
Date: Mon, 9 Feb 2015 13:25:38 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: only trace buffer items if they exist
Message-ID: <20150209182538.GG18336@laptop.bfoster>
References: <1423198008-30748-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423198008-30748-1-git-send-email-david@fromorbit.com>
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
Cc: y@disappointment.disaster, xfs@oss.sgi.com

On Fri, Feb 06, 2015 at 03:46:48PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The commit 2d3d0c5 ("xfs: lobotomise xfs_trans_read_buf_map()") left
> a landmine in the tracing code: trace_xfs_trans_buf_read() is now
> call on all buffers that are read through this interface rather than
> just buffers in transactions. For buffers outside transaction
> context, bp->b_fspriv is null, and so the buf log item tracing
> functions cannot be called. This causes a NULL pointer dereference
> in the trace_xfs_trans_buf_read() function when tracing is turned
> on.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Ah, I hit this a week or so ago and completely forgot to dig into it.
Thanks!

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans_buf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 0a4d4ab..7579841 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -327,9 +327,10 @@ xfs_trans_read_buf_map(
>  		return -EIO;
>  	}
>  
> -	if (tp)
> +	if (tp) {
>  		_xfs_trans_bjoin(tp, bp, 1);
> -	trace_xfs_trans_read_buf(bp->b_fspriv);
> +		trace_xfs_trans_read_buf(bp->b_fspriv);
> +	}
>  	*bpp = bp;
>  	return 0;
>  
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
