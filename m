Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1Ikbu177938 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:46 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4BE61269E21
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	2kF3AAP6QK3TLDH6 for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:39 -0700 (PDT)
Date: Mon, 12 Apr 2010 16:52:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 7/10] xfs: tidy up some goto labels
Message-ID: <20100412065232.GI2493@dastard>
References: <1270852163.7840.154.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270852163.7840.154.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 09, 2010 at 05:29:23PM -0500, Alex Elder wrote:
> Rename a label used in xlog_find_head() that I thought was poorly
> chosen.  Also combine two adjacent labels xlog_find_tail() into
> a single label, and give it a more generic name.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
> fs/xfs/xfs_log_recover.c |   83 ++++++++++++++++++++++++-----------------------
>  fs/xfs/xfs_log_recover.c |   20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -739,7 +739,7 @@ xlog_find_head(
>  			goto bp_err;
>  		if (new_blk != -1) {
>  			head_blk = new_blk;
> -			goto bad_blk;
> +			goto fine_tune;
>  		}
>  
>  		/*
> @@ -757,7 +757,7 @@ xlog_find_head(
>  			head_blk = new_blk;
>  	}
>  
> - bad_blk:
> +fine_tune:
>  	/*
>  	 * Now we need to make sure head_blk is not pointing to a block in
>  	 * the middle of a log record.

I don't think "fine_tune" really matches what is being done here
either. "bad_blk" makes sense when you consider that the search is
being terminated due to a log block being found that didn't match
the search criteria. i.e. it is bad.

What we are really doing there at "bad_blk" is validating the head
block we have found, so if you are going to change the label then
"validate_head" makes more sense to me...

> @@ -864,12 +864,12 @@ xlog_find_tail(
>  	if (*head_blk == 0) {				/* special case */
>  		error = xlog_bread(log, 0, 1, bp, &offset);
>  		if (error)
> -			goto bread_err;
> +			goto done;
>  
>  		if (xlog_get_cycle(offset) == 0) {
>  			*tail_blk = 0;
>  			/* leave all other log inited values alone */
> -			goto exit;
> +			goto done;
>  		}
>  	}

These changes look fine, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
