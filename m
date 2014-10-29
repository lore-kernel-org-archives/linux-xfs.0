Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F8CC7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:37:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C5C5304032
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:37:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4yAoVZ6SKUME1G8j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 11:37:29 -0700 (PDT)
Date: Wed, 29 Oct 2014 14:37:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfsprogs: ignore stripe geom if sunit or swidth ==
	physical sector size
Message-ID: <20141029183721.GA4226@bfoster.laptop>
References: <544FD3E1.1060000@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <544FD3E1.1060000@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 28, 2014 at 12:35:29PM -0500, Eric Sandeen wrote:
> Today, this geometry:
> 
> # modprobe scsi_debug  opt_blks=2048 dev_size_mb=2048
> # blockdev --getpbsz --getss --getiomin --getioopt  /dev/sdd
> 512
> 512
> 512
> 1048576
> 
> will result in a warning at mkfs time, like this:
> 
> # mkfs.xfs -f -d su=64k,sw=12 -l su=64k /dev/sdd
> mkfs.xfs: Specified data stripe width 1536 is not the same as the volume stripe width 2048
> 
> because our geometry discovery thinks it looks like a
> valid striping setup which the commandline is overriding. 
> However, a stripe unit of 512 really isn't indicative of
> a proper stripe geometry.
> 

So the assumption is that the storage reports a non-physical block size
for minimum and optimal I/O sizes for geometry detection. There was a
real world scenario of this, right? Any idea of the configuration
details (e.g., raid layout) that resulted in an increased optimal I/O
size but not minimum I/O size?

This seems reasonable to me and the code looks fine, save a trailing
whitespace instance below. I'm just curious if there are any weird
corner cases where there's value in the reported optimal I/O size or the
real world situation was just noise.

> Prior to this patch, we reset only sunit *or* swidth,
> if either was equal to physical block size, but not
> necessarily both.
> 
> Change the heuristic so that if either the discovered
> sunit or the discovered swidth is physical block size,
> we reset *both* to zero and ignore the geom completely.
> 
> While we're at it, don't pass &dummy in for multiple 
> arguments to blkid_get_topology(); that'll mean that
> inside the function, the last assignment wins, and could
> lead to unexpected results.
> 
> Reported-by: Stan Hoeppner <stan@hardwarefreak.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4546e35..a0fed31 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -410,21 +410,27 @@ static void blkid_get_topology(
>  	*lsectorsize = val;
>  	val = blkid_topology_get_physical_sector_size(tp);
>  	*psectorsize = val;
> +	val = blkid_topology_get_minimum_io_size(tp);
> +	*sunit = val;
> +	val = blkid_topology_get_optimal_io_size(tp);
> +	*swidth = val;
>  
>  	/*
> -	 * Blkid reports the information in terms of bytes, but we want it in
> -	 * terms of 512 bytes blocks (just to convert it to bytes later..)
> -	 *
>  	 * If the reported values are the same as the physical sector size
> -	 * do not bother to report anything.  It will just cause warnings
> +	 * do not bother to report anything.  It will only cause warnings
>  	 * if people specify larger stripe units or widths manually.
>  	 */
> -	val = blkid_topology_get_minimum_io_size(tp);
> -	if (val > *psectorsize)
> -		*sunit = val >> 9;
> -	val = blkid_topology_get_optimal_io_size(tp);
> -	if (val > *psectorsize)
> -		*swidth = val >> 9;
> +	if (*sunit == *psectorsize || *swidth == *psectorsize) {
> +		*sunit = 0;
> +		*swidth = 0;
> +	}
> +
> +	/*
> +	 * Blkid reports the information in terms of bytes, but we want it in
> +	 * terms of 512 bytes blocks (only to convert it to bytes later..)
> +	 */
> +	*sunit = *sunit >> 9;
> +	*swidth = *swidth >> 9;	

Trailing whitespace here.

Brian

>  
>  	if (blkid_topology_get_alignment_offset(tp) != 0) {
>  		fprintf(stderr,
> @@ -484,10 +490,10 @@ static void get_topology(
>  	}
>  
>  	if (xi->rtname && !xi->risfile) {
> -		int dummy;
> +		int sunit, lsectorsize, psectorsize;
>  
> -		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth,
> -				   &dummy, &dummy, force_overwrite);
> +		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
> +				   &lsectorsize, &psectorsize, force_overwrite);
>  	}
>  }
>  #else /* ENABLE_BLKID */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
