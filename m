Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FJEGAe122860 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 13:14:26 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B9513040D5
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 11:15:04 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH V2] mkfs: fix mkfs.xfs -dfile,name=$NAME for new files
Date: Fri, 15 Jan 2010 13:11:29 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A697D@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <4B50B848.2010108@sandeen.net>
From: "Alex Elder" <aelder@sgi.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> # /sbin/mkfs.xfs -dfile,name=grrr,size=100g
> mkfs.xfs: Use the -f option to force overwrite.
> 
> check_overwrite is failing, because  blkid_new_probe_from_filename()
> is failing, because the (new) image file is 0 length.
> 
> It's easy to test for 0 length, and if found, there is
> nothing to overwrite so return 0.
> 
> Also, if testing itself failed for some reason, print
> a message to that effect:
> 
> # mkfs/mkfs.xfs -dfile,name=newfile,size=1g
> mkfs.xfs: probe of newfile failed, cannot detect existing filesystem.
> mkfs.xfs: Use the -f option to force overwrite.

This looks good.

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Reviewed-by: Alex Elder <aelder@sgi.com>

> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index faaafed..b6801dd 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -283,27 +283,47 @@ calc_stripe_factors(
>  }
> 
>  #ifdef ENABLE_BLKID
> +/*
> + * Check for existing filesystem or partition table on device.
> + * Returns:
> + *	 1 for existing fs or partition
> + *	 0 for nothing found
> + *	-1 for internal error
> + */
>  static int
>  check_overwrite(
>  	char		*device)
>  {
>  	const char	*type;
> -	blkid_probe	pr;
> -	int		ret = 0;
> +	blkid_probe	pr = NULL;
> +	int		ret;
> +	struct stat	statbuf;
> 
>  	if (!device || !*device)
>  		return 0;
> 
> +	ret = -1; /* will reset on success of all setup calls */
> +
> +	if (stat(device, &statbuf) < 0)
> +		goto out;
> +
> +	/* nothing to overwrite on a 0-length device */
> +	if (statbuf.st_size == 0) {
> +		ret = 0;
> +		goto out;
> +	}
> +
>  	pr = blkid_new_probe_from_filename(device);
>  	if (!pr)
> -		return -1;
> +		goto out;
> 
>  	if (blkid_probe_enable_partitions(pr, 1))
> -		goto out_free_probe;
> +		goto out;
> 
>  	if (blkid_do_fullprobe(pr))
> -		goto out_free_probe;
> +		goto out;
> 
> +	ret = 0;
>  	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
>  		fprintf(stderr,
>  			_("%s: %s appears to contain an existing "
> @@ -316,8 +336,13 @@ check_overwrite(
>  		ret = 1;
>  	}
> 
> -out_free_probe:
> -	blkid_free_probe(pr);
> +out:
> +	if (pr)
> +		blkid_free_probe(pr);
> +	if (ret == -1)
> +		fprintf(stderr,
> +			_("%s: probe of %s failed, cannot detect "
> +			  "existing filesystem.\n"), progname, device);
>  	return ret;
>  }
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
