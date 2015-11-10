Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 831157F37
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 06:54:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 718B58F8033
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 04:54:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o8DdPx4ELZdoYJM3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 04:54:05 -0800 (PST)
Date: Tue, 10 Nov 2015 07:54:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] libxfs: Optimize the loop for xfs_bitmap_empty
Message-ID: <20151110125403.GC21670@bfoster.bfoster>
References: <1447079482-10650-1-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447079482-10650-1-git-send-email-hejianet@gmail.com>
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

On Mon, Nov 09, 2015 at 10:31:22PM +0800, Jia He wrote:
> If there is any non zero bit in a long bitmap, it can jump out of the for 
> loop and finish the function as soon as possible.
> 
> Signed-off-by: Jia He <hejianet@gmail.com>
> Cc: Dave Chinner <david@fromorbit.com> 
> Cc: Brian Foster <bfoster@redhat.com> 
> ---
>  fs/xfs/libxfs/xfs_bit.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
> index 0e8885a..84614b0 100644
> --- a/fs/xfs/libxfs/xfs_bit.c
> +++ b/fs/xfs/libxfs/xfs_bit.c
> @@ -36,6 +36,8 @@ xfs_bitmap_empty(uint *map, uint size)
>  
>  	for (i = 0; i < size; i++) {
>  		ret |= map[i];
> +		if (ret != 0)
> +			return 0;
>  	}
>  

Seems Ok to me, but if we're going to do this, why not just kill ret
entirely? For example, check 'if (map[i] != 0) return 0;' in the loop
and unconditionally return 1 if we make it to the end.

Brian

>  	return (ret == 0);
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
