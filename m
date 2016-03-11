Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B07D37CA0
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 05:06:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78292304051
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 03:06:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lfbEqmF85jDii6Hi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 03:05:59 -0800 (PST)
Date: Fri, 11 Mar 2016 12:05:54 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: always set rvalp in xfs_dir2_node_trim_free
Message-ID: <20160311110554.GA3163@redhat.com>
References: <1457689337-4018-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457689337-4018-1-git-send-email-hch@lst.de>
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
Cc: hch@lst.de

I was just sending this patch when I saw yours.

Looks good to me:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Fri, Mar 11, 2016 at 10:42:17AM +0100, Christoph Hellwig wrote:
> xfs_dir2_node_trim_free can return with setting the rvalp argument
> pointer.  Initialize it to 0 at the beginning of the function and
> only update it to 1 if we succeeded trimming a freespace block.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 63ee03d..75a5574 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -2235,6 +2235,9 @@ xfs_dir2_node_trim_free(
>  
>  	dp = args->dp;
>  	tp = args->trans;
> +
> +	*rvalp = 0;
> +
>  	/*
>  	 * Read the freespace block.
>  	 */
> @@ -2255,7 +2258,6 @@ xfs_dir2_node_trim_free(
>  	 */
>  	if (freehdr.nused > 0) {
>  		xfs_trans_brelse(tp, bp);
> -		*rvalp = 0;
>  		return 0;
>  	}
>  	/*
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
