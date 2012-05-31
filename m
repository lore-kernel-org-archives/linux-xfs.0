Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4VKnjQO071969 for <xfs@oss.sgi.com>; Thu, 31 May 2012 15:49:45 -0500
Date: Thu, 31 May 2012 15:55:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] xfs_repair: Fix fragmented multiblock dir2
	handling in blkmap_getn()
Message-ID: <20120531205540.GI4721@sgi.com>
References: <4FBABCAB.20300@redhat.com>
 <4FBABD3E.2050700@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FBABD3E.2050700@redhat.com>
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

Hey Eric,

On Mon, May 21, 2012 at 05:10:06PM -0500, Eric Sandeen wrote:
> blkmap_getn() contains a loop which populates an array of extents
> with mapping information for a dir2 "block," which may consist
> of multiple filesystem blocks.
> 
> As written, the loop re-allocates the array for each new extent,
> leaking the previously allocated memory and worse, losing the
> previously filled-in extent information.
> 
> Fix this by only allocating the array once, for the maximum
> possible number of extents - the number of fs blocks in the dir
> block.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/bmap.c b/repair/bmap.c
> index 2f1c307..c43ca7f 100644
> --- a/repair/bmap.c
> +++ b/repair/bmap.c
> @@ -168,7 +168,8 @@ blkmap_getn(
>  		/*
>  		 * rare case - multiple extents for a single dir block
>  		 */
> -		bmp = malloc(nb * sizeof(bmap_ext_t));
> +		if (!bmp)
> +			bmp = malloc(nb * sizeof(bmap_ext_t));

Cool.  That's an area where we don't have much test coverage.  I don't see a
single '-n size' in xfstests.

This looks good to me.  FWICS all the callers free it later.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
