Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBD51CoT138615 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 23:01:12 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E96F51BC7507
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 21:01:10 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id EPShzvxJYZxDe4zt for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 21:01:10 -0800 (PST)
Message-ID: <4EE6DC15.2080203@sandeen.net>
Date: Mon, 12 Dec 2011 23:01:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: Refuse to initialize a misaligned device if not
	forced using libblkid
References: <1322828095-10939-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1322828095-10939-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 12/2/11 6:14 AM, Carlos Maiolino wrote:
> The patch fix the problem about the usage of 4k sector devices when the
> device is not properly aligned. It makes mkfs to refuse to initialize a
> xfs filesystem if the -f option is not passed at the command line, and
> forces a 512b sector size if the user chooses to force the device
> initialization.

[editor]

In mkfs, ensure that the partition is aligned to the device's
physical sector size, so that we do not break atomic IO guarantees
due to read modify write for IOs that span physical blocks.

If an override is forced, set the sector size to the device's
logical sector size as a next-best backup plan.

[/editor]

I think that reads better?  (And I think it is correct?)

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  mkfs/xfs_mkfs.c |   35 +++++++++++++++++++++++++++++------
>  1 files changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f527f3d..159bf60 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -369,8 +369,14 @@ out:
>  	return ret;
>  }
>  
> -static void blkid_get_topology(const char *device, int *sunit, int *swidth, int *sectorsize)
> +static void blkid_get_topology(
> +	const char *device,
> +	int *sunit,
> +	int *swidth,
> +	int *sectorsize,
> +	int force_overwrite)
>  {
> +
>  	blkid_topology tp;
>  	blkid_probe pr;
>  	unsigned long val;
> @@ -409,6 +415,15 @@ static void blkid_get_topology(const char *device, int *sunit, int *swidth, int
>  		fprintf(stderr,
>  			_("warning: device is not properly aligned %s\n"),
>  			device);
> +
> +		if(!force_overwrite) {
> +			fprintf(stderr,
> +			_("Use -f to force usage of a misaligned device\n"));
> +
> +			exit(EXIT_FAILURE);
> +		}

I think it might be better to send in *offset rather than force_overwrite;
that way the _caller_ can decide what to do with a misaligned partition.
I suppose by that token maybe the warning should be moved out too.

> +	/* Force a 512b sector size if the device is misaligned*/

space before "*/" - but perhaps the caller should do this.
This function should just get the topology, not handle commandline
switches, exits, etc IMHO.

> +	*sectorsize = BBSIZE;
>  	}
>  
>  	blkid_free_probe(pr);
> @@ -421,19 +436,23 @@ out_free_probe:
>  		device);
>  }
>  
> -static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
> +static void get_topology(
> +	libxfs_init_t *xi,
> +	struct fs_topology *ft,
> +	int force_overwrite)
>  {
>  	if (!xi->disfile) {
>  		const char *dfile = xi->volname ? xi->volname : xi->dname;
>  
>  		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
> -				   &ft->sectorsize);
> +				   &ft->sectorsize, force_overwrite);
>  	}
>  
>  	if (xi->rtname && !xi->risfile) {
>  		int dummy;
>  
> -		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth, &dummy);
> +		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth,
> +				   &dummy, force_overwrite);
>  	}

so here I'd check alignment, and decide what to do, i.e. something like:

if (!force && (data_offset || rt_offset)) {
	sprintf(" ... bad alignment!\n");
	sprintf("use -f to force this geometry\n");
	exit(EXIT_FAILURE);
}

-Eric

>  }
>  #else /* ENABLE_BLKID */
> @@ -460,8 +479,12 @@ check_overwrite(
>  	return 0;
>  }
>  
> -static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
> +static void get_topology(
> +	libxfs_init_t *xi,
> +	struct fs_topology *ft,
> +	int force_overwrite)
>  {
> +
>  	char *dfile = xi->volname ? xi->volname : xi->dname;
>  	int bsz = BBSIZE;
>  
> @@ -1625,7 +1648,7 @@ main(
>  	}
>  
>  	memset(&ft, 0, sizeof(ft));
> -	get_topology(&xi, &ft);
> +	get_topology(&xi, &ft, force_overwrite);
>  
>  	if (ft.sectoralign) {
>  		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
