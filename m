Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C8D937F53
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:54:42 -0500 (CDT)
Date: Thu, 25 Jul 2013 15:54:41 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 18/48] xfs: add buffer types to directory and attribute
	buffers
Message-ID: <20130725205441.GF3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-19-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:41AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add buffer types to the buffer log items so that log recovery can
> validate the buffers and calculate CRCs correctly after the buffers
> are recovered.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Corresponds to commit d75afeb3d3020.

> diff --git a/libxfs/xfs.h b/libxfs/xfs.h
> index c69dc4a..6bec18e 100644
> --- a/libxfs/xfs.h
> +++ b/libxfs/xfs.h
> @@ -255,6 +255,7 @@ roundup_pow_of_two(uint v)
>  #define	xfs_trans_agflist_delta(tp, d)
>  #define	xfs_trans_agbtree_delta(tp, d)
>  #define xfs_trans_buf_set_type(tp, bp, t)
> +#define xfs_trans_buf_copy_type(dbp, sbp)

Looks like he's not called but needs to be defined to compile.

> diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
> index f00b23c..3d1ec23 100644
> --- a/libxfs/xfs_dir2_leaf.c
> +++ b/libxfs/xfs_dir2_leaf.c

There is probably a change later in the series that makes
xfs_dir3_leaf1_buf_ops not static.

> @@ -232,7 +239,8 @@ xfs_dir3_free_get_buf(
>  	if (error)
>  		return error;
>  
> -	bp->b_ops = &xfs_dir3_free_buf_ops;;

Oh good.  Got rid of the extra ;

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
