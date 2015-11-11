Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E92137F50
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 06:48:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC11D8F8049
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 04:48:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TyWt0zaiq9DVYXgX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 04:48:35 -0800 (PST)
Date: Wed, 11 Nov 2015 07:48:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] libxfs: Optimize the loop for xfs_bitmap_empty
Message-ID: <20151111124833.GB52153@bfoster.bfoster>
References: <20151110125403.GC21670@bfoster.bfoster>
	<1447228141-17408-1-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447228141-17408-1-git-send-email-hejianet@gmail.com>
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
To: Jia He <hejianet@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 11, 2015 at 03:49:01PM +0800, Jia He wrote:
> If there is any non zero bit in a long bitmap, it can jump out of the
> loop and finish the function as soon as possible.
> 
> Signed-off-by: Jia He <hejianet@gmail.com>
> Cc: Dave Chinner <david@fromorbit.com> 
> Cc: Brian Foster <bfoster@redhat.com> 
> ---

Looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bit.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
> index 0e8885a..0a94cce 100644
> --- a/fs/xfs/libxfs/xfs_bit.c
> +++ b/fs/xfs/libxfs/xfs_bit.c
> @@ -32,13 +32,13 @@ int
>  xfs_bitmap_empty(uint *map, uint size)
>  {
>  	uint i;
> -	uint ret = 0;
>  
>  	for (i = 0; i < size; i++) {
> -		ret |= map[i];
> +		if (map[i] != 0)
> +			return 0;
>  	}
>  
> -	return (ret == 0);
> +	return 1;
>  }
>  
>  /*
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
