Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B58B229DF5
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 20:06:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 99E0A8F8040
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 18:06:15 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6imGEV3ykGZCB0dT for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 18:06:08 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8EEBA6131005
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 20:06:08 -0600 (CST)
Subject: Re: [PATCH] xfs: log recovery needs to be aware of CONFIG_XFS_RT now
References: <20160208060751.GA27429@dastard>
	<20160208153720.GG19597@bfoster.bfoster>
	<20160208195253.GI27429@dastard> <20160208233350.GO27429@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56B94990.5080707@sandeen.net>
Date: Mon, 8 Feb 2016 20:06:08 -0600
MIME-Version: 1.0
In-Reply-To: <20160208233350.GO27429@dastard>
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
To: xfs@oss.sgi.com

On 2/8/16 5:33 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> As it uses buffer verifiers that only exist when CONFIG_XFS_RT=y.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> Note: I will fold this back into the original patch that caused
> this build regression and rebuild the for-next tree.
> 
>  fs/xfs/xfs_log_recover.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 23ad143..1dc0e14 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2472,11 +2472,13 @@ xlog_recover_validate_buf_type(
>  		}
>  		bp->b_ops = &xfs_sb_buf_ops;
>  		break;
> +#ifdef CONFIG_XFS_RT
>  	case XFS_BLFT_RTBITMAP_BUF:
>  	case XFS_BLFT_RTSUMMARY_BUF:
>  		/* no magic numbers for verification of RT buffers */
>  		bp->b_ops = &xfs_rtbuf_ops;
>  		break;
> +#endif /* CONFIG_XFS_RT */
>  	default:
>  		xfs_warn(mp, "Unknown buffer type %d!",
>  			 xfs_blft_from_flags(buf_f));
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
