Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2BRuUm069652 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 05:27:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D16A6294441
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 03:27:55 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	r9g2Ngc8qq5c90j5 for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 03:27:55 -0800 (PST)
Date: Fri, 2 Dec 2011 06:27:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: Refuse to initialize a misaligned device if not
	forced using libblkid
Message-ID: <20111202112754.GB17319@infradead.org>
References: <1322743465-17175-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1322743465-17175-1-git-send-email-cmaiolino@redhat.com>
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

On Thu, Dec 01, 2011 at 10:44:25AM -0200, Carlos Maiolino wrote:
> This is the first patch proposal to fix the problem about the usage of
> 4k sector devices when the device is not properly aligned
> 
> The patch make mkfs to refuse to initialize a xfs filesystem if the -f
> option is not passed at the command line, and forces a 512b sector size
> if the user opt to force the device initialization
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  mkfs/xfs_mkfs.c |   24 ++++++++++++++++++------
>  1 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f527f3d..495c70d 100644
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
> @@ -409,6 +415,12 @@ static void blkid_get_topology(const char *device, int *sunit, int *swidth, int
>  		fprintf(stderr,
>  			_("warning: device is not properly aligned %s\n"),
>  			device);
> +
> +		if(!force_overwrite){
> +			fprintf(stderr, _("Use -f to force usage of a misaligned device\n"));
> +			exit(EXIT_FAILURE);
> +		}
> +	*sectorsize = BBSIZE;  /* Force a 512b sector size if the device is misaligned*/
>  	}

style issues:

	- always use whitespaces beforew and after braces, except in
	  function calls e.g.

		if (!force_overwrite) {

avoid 80 character lines if possible, e.g.


		fprintf(stderr,
	_("Use -f to force usage of a misaligned device\n"));

and

	/* Force a 512b sector size if the device is misaligned */
	*sectorsize = BBSIZE;

> -		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth, &dummy);
> +		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth, &dummy, force_overwrite);

needs linebreak, too.

>  	}
>  }
>  #else /* ENABLE_BLKID */
> @@ -460,7 +472,7 @@ check_overwrite(
>  	return 0;
>  }
>  
> -static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
> +static void get_topology(libxfs_init_t *xi, struct fs_topology *ft, int force_overwrite)

same here

otherwise this looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
