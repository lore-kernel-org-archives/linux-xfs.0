Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14KE11x087949 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 14:14:01 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4E9B1B078B
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 12:15:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rshstfpXcjV4PUtR for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 12:15:09 -0800 (PST)
Message-ID: <4B6B2AC5.1070803@redhat.com>
Date: Thu, 04 Feb 2010 14:15:01 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs fix detection of empty devices
References: <4B6AF6FC.6030101@redhat.com> <20100204194000.GA7229@infradead.org>
In-Reply-To: <20100204194000.GA7229@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jim Meyering <meyering@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> We currently fail to detect that a device does indeed not contain any
> signature and we are indeed fine to proceed with it due to mishandling
> the return value of blkid_do_fullprobe.  Fix that up and add some
> better diagnostics of the blkid detection.  Also remove the size == 0
> check in check_overwrite as blkid handles that just fine.

Much better, thanks, minor comment below

> from RH bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=561870
> 
> # dd if=/dev/zero of=k bs=1MB count=2 seek=20; mkfs.xfs k 
> # mkfs.xfs: probe of k failed, cannot detect existing filesystem.
> # mkfs.xfs: Use the -f option to force overwrite
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2010-02-04 19:19:36.000000000 +0000
> +++ xfsprogs-dev/mkfs/xfs_mkfs.c	2010-02-04 19:33:36.000000000 +0000
> @@ -297,48 +297,47 @@ check_overwrite(
>  	const char	*type;
>  	blkid_probe	pr = NULL;
>  	int		ret;
> -	int		fd;
> -	long long	size;
> -	int		bsz;
>  
>  	if (!device || !*device)
>  		return 0;
>  
>  	ret = -1; /* will reset on success of all setup calls */
>  
> -	fd = open(device, O_RDONLY);
> -	if (fd < 0)
> -		goto out;
> -	platform_findsizes(device, fd, &size, &bsz);
> -	close(fd);
> -
> -	/* nothing to overwrite on a 0-length device */
> -	if (size == 0) {
> -		ret = 0;
> -		goto out;
> -	}
> -
>  	pr = blkid_new_probe_from_filename(device);
>  	if (!pr)
>  		goto out;
>  
> -	if (blkid_probe_enable_partitions(pr, 1))
> +	ret = blkid_probe_enable_partitions(pr, 1);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = blkid_do_fullprobe(pr);
> +	if (ret < 0)
>  		goto out;
>  
> -	if (blkid_do_fullprobe(pr))
> +	/*
> +	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
> +	 * but we want the exact opposite, so reverse the return value here.
> +	 *
> +	 * In addition print some useful diagnostics about what actually is
> +	 * on the device.
> +	 */
> +	ret = !ret;
> +	if (!ret)
>  		goto out;

that makes my brain hurt a little.  Maybe:

if (ret == 1) {	/* blkid found nothing */
	ret = 0;	/* we return 0 for nothing found */
	goto out;
} else		/* blkid found something */
	ret = 1;	/* we return 1 for something found */

it's wordy but at least not confusing.

I'm ok either way, I guess, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

unless you change anything enough that you want another review.  :)

-Eric

> -	ret = 0;
>  	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
>  		fprintf(stderr,
>  			_("%s: %s appears to contain an existing "
>  			"filesystem (%s).\n"), progname, device, type);
> -		ret = 1;
>  	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
>  		fprintf(stderr,
>  			_("%s: %s appears to contain a partition "
>  			"table (%s).\n"), progname, device, type);
> -		ret = 1;
> +	} else {
> +		fprintf(stderr,
> +			_("%s: %s appears to contain something weird "
> +			"according to blkid\n"), progname, device);
>  	}
>  
>  out:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
