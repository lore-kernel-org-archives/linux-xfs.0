Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98C1D29E04
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 09:29:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 376BCAC003
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 07:29:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YKcjqoCepLpZiayi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 07:29:27 -0800 (PST)
Date: Mon, 8 Feb 2016 10:29:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: reinitialise recycled VFS inode correctly
Message-ID: <20160208152925.GC19597@bfoster.bfoster>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454905461-2773-6-git-send-email-david@fromorbit.com>
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

On Mon, Feb 08, 2016 at 03:24:17PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we keep certain on-disk information in the VFS inode rather
> than in a separate XFS specific stucture, we have to be careful of
> the VFS code clearing that information when we re-initialise
> reclaimable cached inodes during lookup. If we don't do this, then
> we lose critical information from the inode and that results in
> corruption being detected.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7c26f86..9ca28655 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -135,6 +135,26 @@ xfs_inode_free(
>  }
>  
>  /*
> + * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
> + * part of the structure. This is made more complex by the fact we store
> + * information about the on-disk values in the VFS inode and so we can't just
> + * overwrite it's values unconditionally. Hence we save the parameters we
> + * need to retain across reinitialisation, and rewrite them into the VFS inode
> + * after resetting it's state even if resetting fails.
> + */
> +static int
> +xfs_reinit_inode(
> +	struct xfs_mount	*mp,
> +	struct inode		*inode)
> +{
> +	int		error;
> +
> +	error = inode_init_always(mp->m_super, inode);
> +
> +	return error;
> +}
> +
> +/*
>   * Check the validity of the inode we just found it the cache
>   */
>  static int
> @@ -208,7 +228,7 @@ xfs_iget_cache_hit(
>  		spin_unlock(&ip->i_flags_lock);
>  		rcu_read_unlock();
>  
> -		error = inode_init_always(mp->m_super, inode);
> +		error = xfs_reinit_inode(mp, inode);
>  		if (error) {
>  			/*
>  			 * Re-initializing the inode failed, and we are in deep
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
