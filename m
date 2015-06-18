Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77BE97F66
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 06:03:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67861304032
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 04:03:42 -0700 (PDT)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id X9pXahhl7muCfPEs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2015 04:03:40 -0700 (PDT)
Date: Thu, 18 Jun 2015 07:03:39 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <14667996.16447259.1434625419793.JavaMail.zimbra@redhat.com>
In-Reply-To: <55820229.1010701@redhat.com>
References: <55820229.1010701@redhat.com>
Subject: Re: [PATCH] mkfs.xfs: always use underlying fs sector size when
	mkfs'ing	a file
MIME-Version: 1.0
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
Cc: xfs-oss <xfs@oss.sgi.com>



----- Original Message -----
> From: "Eric Sandeen" <sandeen@redhat.com>
> To: "xfs-oss" <xfs@oss.sgi.com>
> Sent: Thursday, June 18, 2015 1:26:33 AM
> Subject: [PATCH] mkfs.xfs: always use underlying fs sector size when mkfs'ing	a file
> 
> If we are mkfs'ing a file, and that file is on a 4k sector filesystem,
> we should make the fs image file with the same sector size, or things
> may fail when they try to do direct IO in 512 byte chunks (depending
> on whether it is a 512e or "hard" 4k device).
> 
> Earlier commits attempted this to some degree:
> 
> 5a7d59 xfsprogs: try to handle mkfs of a file on 4k sector device
> 3800a2 mkfs.xfs: don't call blkid_get_topology on existing regular files
> 
> but inexplicably missed the case where mkfs.xfs with "-d file" was
> specified.
> 
> One more try; in get_topology(), try to get the underlying fs sector
> size in *all* cases where we are mkfs'ing a file, and set the sector size
> accordingly.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (This does it for 512e as well as hard 4k drives, but I think that's
> probably ok?  If not, perhaps we should go further and attempt to
> discern logical and physical sectors for the device under the
> filesystem.  Is it worth it?  Not sure it is.)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index e2a052d..e44c390 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -462,31 +462,34 @@ static void get_topology(
>  	struct fs_topology	*ft,
>  	int			force_overwrite)
>  {
> -	if (!xi->disfile) {
> -		char *dfile = xi->volname ? xi->volname : xi->dname;
> -		struct stat statbuf;
> +	struct stat statbuf;
> +	char *dfile = xi->volname ? xi->volname : xi->dname;
>  
> -		/*
> -		 * If our target is a regular file, and xi->disfile isn't
> -		 * set (i.e. no "-d file" invocation), use platform_findsizes
> -		 * to try to obtain the underlying filesystem's requirements
> -		 * for direct IO; we'll set our sector size to that if possible.
> -		 */
> -		if (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode)) {
> -			int fd;
> -			long long dummy;
> -
> -			fd = open(dfile, O_RDONLY);
> -			if (fd >= 0) {
> -				platform_findsizes(dfile, fd, &dummy,
> -						   &ft->lsectorsize);
> -				close(fd);
> -			}
> -		} else {
> -			blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
> -					   &ft->lsectorsize, &ft->psectorsize,
> -					   force_overwrite);
> +	/*
> +	 * If our target is a regular file, use platform_findsizes
> +	 * to try to obtain the underlying filesystem's requirements
> +	 * for direct IO; we'll set our sector size to that if possible.
> +	 */
> +	if (xi->disfile ||
> +	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
> +		int fd;
> +		int flags = O_RDONLY;
> +		long long dummy;
> +
> +		/* with xi->disfile we may not have the file yet! */
> +		if (xi->disfile)
> +			flags |= O_CREAT;
> +
> +		fd = open(dfile, flags, 0666);
> +		if (fd >= 0) {
> +			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
> +			close (fd);
>  		}
> +
> +	} else {
> +		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
> +				   &ft->lsectorsize, &ft->psectorsize,
> +				   force_overwrite);
>  	}
>  
>  	if (xi->rtname && !xi->risfile) {
> 

This changes get_topology only for ENABLE_BLKID branch of #ifdef. Is that intentional, i.e. we don't expect anyone not using ENABLE_BLKID? Because otherwise, if mkfs is compiled without ENABLE_BLKID, then all we get is:

	int bsz = BBSIZE;

	if (!xi->disfile) {
		int fd;
		long long dummy;

		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
				&ft->dsunit, &ft->dswidth, &ft->sectoralign);
		fd = open(dfile, O_RDONLY);
		/* If this fails we just fall back to BBSIZE */
		if (fd >= 0) {
			platform_findsizes(dfile, fd, &dummy, &bsz);
			close(fd);
		}
	}

	ft->lsectorsize = bsz;
	ft->psectorsize = bsz;

Two definitions of get_topology looks really unfortunate - this is something I have on my radar to change.
-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
