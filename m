Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4VLLJkM073718 for <xfs@oss.sgi.com>; Thu, 31 May 2012 16:21:19 -0500
Date: Thu, 31 May 2012 16:27:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/3] xfs_repair: Document & robustify blkmap_next_off()
Message-ID: <20120531212714.GJ4721@sgi.com>
References: <4FBABCAB.20300@redhat.com>
 <4FBABD6A.6070800@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FBABD6A.6070800@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, May 21, 2012 at 05:10:50PM -0500, Eric Sandeen wrote:
> blkmap_next_off() was cryptic (to me), so document what it does.
> Also catch cases when the passed in extent index 't' is beyond
> the number of extents in the blkmap, so that:
> 
>         ext = blkmap->exts + *t;
> 
> doesn't walk off the end of the array into garbage.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/bmap.c b/repair/bmap.c
> index c43ca7f..85d66dc 100644
> --- a/repair/bmap.c
> +++ b/repair/bmap.c
> @@ -206,8 +206,25 @@ blkmap_last_off(
>  	return ext->startoff + ext->blockcount;
>  }
>  
> -/*
> - * Return the next offset in a block map.
> +/**
> + * blkmap_next_off - Return next logical block offset in a block map.
> + * @blkmap:	blockmap to use
> + * @o:		current file logical block number
> + * @t:		current extent index into blockmap (in/out)
> + *
> + * Given a logical block offset in a file, return the next mapped logical offset
> + * The map index "t" tracks the current extent number in the block map, and
> + * is updated automatically if the returned offset resides within the next
> + * mapped extent.
> + *
> + * If the blockmap contains no extents, or no more logical offsets are mapped,
> + * or the extent index exceeds the number of extents in the map,
> + * return NULLDFILOFF.
> + *
> + * If offset o is beyond extent index t, the first offset in the next extent
> + * after extent t will be returned.
> + *
> + * Intended to be called starting with offset 0, index 0, and iterated.
>   */
>  xfs_dfiloff_t
>  blkmap_next_off(
> @@ -223,10 +240,12 @@ blkmap_next_off(
>  		*t = 0;
>  		return blkmap->exts[0].startoff;
>  	}
> +	if (*t >= blkmap->nexts)
> +		return NULLDFILOFF;
>  	ext = blkmap->exts + *t;
>  	if (o < ext->startoff + ext->blockcount - 1)
>  		return o + 1;
> -	if (*t >= blkmap->nexts - 1)
> +	if (*t == blkmap->nexts - 1)
>  		return NULLDFILOFF;
>  	(*t)++;
>  	return ext[1].startoff;

Ok, so you have 50 extents, and when *t == 49 you don't want to go looking at
ext[50].startoff.  Looks good to me.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
