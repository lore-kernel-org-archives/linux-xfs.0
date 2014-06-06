Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F1AB17F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 10:20:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B78A38F804C
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 08:20:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v8z4ZQs7xyzH79Ky for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 08:20:50 -0700 (PDT)
Date: Fri, 6 Jun 2014 11:20:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2 V2] xfsprogs: try to handle mkfs of a file on 4k
	sector device
Message-ID: <20140606152045.GA3048@laptop.bfoster>
References: <53852A05.5040006@redhat.com>
 <5390C13E.6030205@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5390C13E.6030205@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 05, 2014 at 02:13:02PM -0500, Eric Sandeen wrote:
> Try the xfs geometry ioctl if the mkfs target resides
> in a file; this gives us the equivalent of a device
> sector size.
> 
> If this fails, and there's a sector size mismatch
> between the host FS and the filesystem, then mkfs might
> fail - but that's no worse than it's been before.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks Ok...

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: remove warning when FSGEOMETRY fails (i.e. on non-xfs
> filesystems) for now
> 
> diff --git a/libxfs/linux.c b/libxfs/linux.c
> index 2e07d54..3796fdd 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -141,10 +141,20 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
>  		exit(1);
>  	}
>  	if ((st.st_mode & S_IFMT) == S_IFREG) {
> +		struct xfs_fsop_geom_v1 geom = { 0 };
> +
>  		*sz = (long long)(st.st_size >> 9);
> -		*bsz = BBSIZE;
> -		if (BBSIZE > max_block_alignment)
> -			max_block_alignment = BBSIZE;
> +		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
> +			/*
> +			 * fall back to BBSIZE; mkfs might fail if there's a
> +			 * size mismatch between the image & the host fs...
> +			 */
> +			*bsz = BBSIZE;
> +		} else
> +			*bsz = geom.sectsize;
> +
> +		if (*bsz > max_block_alignment)
> +			max_block_alignment = *bsz;
>  		return;
>  	}
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
