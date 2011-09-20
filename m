Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KK0WSZ080614 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:00:32 -0500
Subject: Re: [PATCH] mkfs.xfs: don't increase agblocks past maximum
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4E77B7E2.6020805@redhat.com>
References: <4E77B7E2.6020805@redhat.com>
Date: Tue, 20 Sep 2011 15:00:28 -0500
Message-ID: <1316548828.2912.48.camel@doink>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, 2011-09-19 at 16:45 -0500, Eric Sandeen wrote:
> RH QA discovered this bug:
> 
> Steps to Reproduce:
> 1. Create 4 TB - 1 B partition
> dd if=/dev/zero of=x.img bs=1 count=0 seek=4398046511103
> 2. Create xfs fs with 512 B block size on the partition
> mkfs.xfs -b size=512 xfs.img
> 
> Actual results:
> Agsize is computed incorrectly resulting in fs creation fail:
> agsize (2147483648b) too big, maximum is 2147483647 blocks
> 
> This is due to the "rounding up" at the very end of the calculations;
> there may be other places to alleviate the problem, but it seems
> most obvious to simply skip the rounding up if it would create too
> many blocks in the AG.  Worst case, we lose 1 block per AG.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

The fix is the right way about it.

This may seem petty, but I think this would be better:

	blocks = dblocks >> shift
	if (blocks & xfs_mask32lo(shift)) {
		if (blocks < XFS_AG_MAX_BLOCKS(blocklog))
			blocks++;
	}

It emphasizes more why we'd be doing the increment,
plus I'd rather see a "real" increment rather than
adding a Boolean value.

Either way:
Reviewed-by: Alex Elder <aelder@sgi.com>

> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5b3b9a7..856a261 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -658,7 +659,9 @@ calc_default_ag_geometry(
>  	 * last bit of the filesystem. The same principle applies
>  	 * to the AG count, so we don't lose the last AG!
>  	 */
> -	blocks = (dblocks >> shift) + ((dblocks & xfs_mask32lo(shift)) != 0);
> +	blocks = (dblocks >> shift);
> +	if (blocks < XFS_AG_MAX_BLOCKS(blocklog))
> +		blocks += ((dblocks & xfs_mask32lo(shift)) != 0);
>  
>  done:
>  	*agsize = blocks;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
