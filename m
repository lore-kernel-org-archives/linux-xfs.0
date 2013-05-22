Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 08A787CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 12:01:21 -0500 (CDT)
Date: Wed, 22 May 2013 12:01:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/11] xfs: correctly map remote attr buffers during
	removal
Message-ID: <20130522170117.GO20028@sgi.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369123330-9579-6-git-send-email-david@fromorbit.com>
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

On Tue, May 21, 2013 at 06:02:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we don't map the buffers correctly (same as for get/set
> operations) then the incore buffer lookup will fail. If a block
> number matches but a length is wrong, then debug kernels will ASSERT
> fail in _xfs_buf_find() due to the length mismatch. Ensure that we
> map the buffers correctly by basing the length of the buffer on the
> attribute data length rather than the remote block count.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Yeah.  Looks fine.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_attr_remote.c |   27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index e207bf0..d8bcb2d 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -468,19 +468,25 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
>  	mp = args->dp->i_mount;
>  
>  	/*
> -	 * Roll through the "value", invalidating the attribute value's
> -	 * blocks.
> +	 * Roll through the "value", invalidating the attribute value's blocks.
> +	 * Note that args->rmtblkcnt is the minimum number of data blocks we'll
> +	 * see for a CRC enabled remote attribute. Each extent will have a
> +	 * header, and so we may have more blocks than we realise here.  If we
> +	 * fail to map the blocks correctly, we'll have problems with the buffer
> +	 * lookups.
>  	 */
>  	lblkno = args->rmtblkno;
> -	valuelen = args->rmtblkcnt;
> +	valuelen = args->valuelen;
> +	blkcnt = xfs_attr3_rmt_blocks(mp, valuelen);
>  	while (valuelen > 0) {
> +		int dblkcnt;
> +
>  		/*
>  		 * Try to remember where we decided to put the value.
>  		 */
>  		nmap = 1;
>  		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
> -				       args->rmtblkcnt, &map, &nmap,
> -				       XFS_BMAPI_ATTRFORK);
> +				       blkcnt, &map, &nmap, XFS_BMAPI_ATTRFORK);
>  		if (error)
>  			return(error);
>  		ASSERT(nmap == 1);
> @@ -488,28 +494,31 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
>  		       (map.br_startblock != HOLESTARTBLOCK));
>  
>  		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
> -		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
> +		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
>  
>  		/*
>  		 * If the "remote" value is in the cache, remove it.
>  		 */
> -		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt, XBF_TRYLOCK);
> +		bp = xfs_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
>  		if (bp) {
>  			xfs_buf_stale(bp);
>  			xfs_buf_relse(bp);
>  			bp = NULL;
>  		}
>  
> -		valuelen -= map.br_blockcount;
> +		valuelen -= XFS_ATTR3_RMT_BUF_SPACE(mp,
> +					XFS_FSB_TO_B(mp, map.br_blockcount));
>  
>  		lblkno += map.br_blockcount;
> +		blkcnt -= map.br_blockcount;
> +		blkcnt = max(blkcnt, xfs_attr3_rmt_blocks(mp, valuelen));

max for fragmentation... can be removed once its header per block, i think.



>  	}
>  
>  	/*
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
> +	blkcnt = lblkno - args->rmtblkno;
>  	lblkno = args->rmtblkno;
> -	blkcnt = args->rmtblkcnt;
>  	done = 0;
>  	while (!done) {
>  		xfs_bmap_init(args->flist, args->firstblock);
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
