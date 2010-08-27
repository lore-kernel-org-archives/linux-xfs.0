Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7RJkdOl108674 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 14:46:39 -0500
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1276764799-4837-1-git-send-email-tao.ma@oracle.com>
References: <20100614122912.GD6590@dastard>
	<1276764799-4837-1-git-send-email-tao.ma@oracle.com>
Date: Fri, 27 Aug 2010 14:46:55 -0500
Message-ID: <1282938415.2450.109.camel@doink>
Mime-Version: 1.0
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
To: Tao Ma <tao.ma@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, 2010-06-17 at 16:53 +0800, Tao Ma wrote:
> Hi Dave,
> On 06/14/2010 08:29 PM, Dave Chinner wrote:
> > I just had a thought - if you want to avoid holes being reported to
> > fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
> > holes in the mappin gloop when this flag is set. That will make
> > fiemap fill in the full number of extents without hacking the
> > extent count...
> Here is the updated one. I have used BVM_IF_NO_HOLES in xfs_getbmap
> to skip increasing index 'cur_ext'. It is a bit ugly, see my commit
> log. I guess maybe we can add another flag in xfs_bmapi so that it
> don't even give us the holes?

Dave said he would commit this but it hasn't been done
yet, so there's still time to comment!

. . .

> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 99587de..d49107d 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -5744,12 +5744,24 @@ xfs_getbmap(
>  					map[i].br_startblock))
>  				goto out_free_map;
>  
> -			nexleft--;
>  			bmv->bmv_offset =
>  				out[cur_ext].bmv_offset +
>  				out[cur_ext].bmv_length;
>  			bmv->bmv_length =
>  				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
> +
> +			/*
> +			 * In case we don't want to return the hole,
> +			 * don't increase cur_ext so that we can reuse
> +			 * it in the next loop.
> +			 */
> +			if ((iflags & BMV_IF_NO_HOLES) &&
> +			    out[cur_ext].bmv_block == -1LL) {

I personally would prefer this to use:
		if ((iflags & BMV_IF_NO_HOLES) &&
			map[i].br_startblock == HOLESTARTBLOCK) {

I think this is more obvious that this "extent" represents
a hole (as opposed to bmv_block == -1, which is how
xfs_getbmapx_fix_eof_hole() encodes this).

Otherwise looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



> +				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
> +				continue;
> +			}
> +
> +			nexleft--;
>  			bmv->bmv_entries++;
>  			cur_ext++;
>  		}
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 7cf7220..87c2e9d 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -114,8 +114,10 @@ struct getbmapx {
>  #define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
>  #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
>  #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
> +#define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
>  #define BMV_IF_VALID	\
> -	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|BMV_IF_DELALLOC)
> +	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
> +	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES)
>  
>  /*	bmv_oflags values - returned for each non-header segment */
>  #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
