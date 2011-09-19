Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JGawjm261945 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 11:36:58 -0500
Subject: Re: [PATCH] xfs: check the return value of xfs_trans_get_buf()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1315411298.9298.5.camel@chandra-lucid.austin.ibm.com>
References: <1315411298.9298.5.camel@chandra-lucid.austin.ibm.com>
Date: Mon, 19 Sep 2011 11:36:53 -0500
Message-ID: <1316450213.2941.20.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: sekharan@us.ibm.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, 2011-09-07 at 11:01 -0500, Chandra Seetharaman wrote:
> Check the return value of xfs_trans_get_buf() and fail appropriately.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Sorry it took a while to get to this.

I started following back some of the paths that
now (with your patch) return ENOMEM where they
might not have before.  But I soon gave up because
it explodes a bit in the number of possibilities.
I did verify that the places that now return ENOMEM
have callers that check for an error return, so I'm
going to just trust that's OK and that you have
ensured there aren't any spots that do something
unwanted in the event ENOMEM gets returned.

I did find something that may be a problem, so
I'd like you to take another look and either
explain why it's OK, or send an update to correct
it.

Thanks.

					-Alex

. . .

> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index c2ff0fc..a4f3624 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -308,6 +308,8 @@ xfs_inactive_symlink_rmt(
>  		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
>  			XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
>  			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
> +		if (!bp) 
> +			goto error1;

In this function, simply going to error1 will result
in a 0 getting returned to the caller, because error
had value 0 at this point.  I think you want something
more like:
			if (!bp) {
				error = ENOMEM;
				goto error1;
			}


>  		xfs_trans_binval(tp, bp);
>  	}
>  	/*
> @@ -1648,7 +1650,8 @@ xfs_symlink(
>  			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
>  			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
>  					       BTOBB(byte_cnt), 0);
> -			ASSERT(!xfs_buf_geterror(bp));
> +			if (!bp)
> +				goto error2;

Same thing here.  I think you want to set error to
something before the "goto error2".

>  			if (pathlen < byte_cnt) {
>  				byte_cnt = pathlen;
>  			}
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
