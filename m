Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752076AbeA3DyO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jan 2018 22:54:14 -0500
Subject: Re: [PATCH 4/2] mkfs: don't crash on dswidth overflow
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
 <20180130033830.GL9068@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <2f86d3e5-1ac4-9138-2847-1dfc3161719e@redhat.com>
Date: Mon, 29 Jan 2018 21:54:13 -0600
MIME-Version: 1.0
In-Reply-To: <20180130033830.GL9068@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/29/18 9:38 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I ran mkfs.xfs -d su=1048576,sw=$((18 * 1048576)), forgetting that sw
> takes a multiple of su (unlike swidth which takes any space unit).  I
> was surprised when we hit a floating point exception, which I traced
> back to an integer overflow when we calculate swidth from dsw.
> 
> So, do the 64-bit multiplication so we can detect the overflow and
> complain about it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine (if not a bit of a mouthful) ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5f1ac9f..7c9d148 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2211,6 +2211,7 @@ calc_stripe_factors(
>  	struct cli_params	*cli,
>  	struct fs_topology	*ft)
>  {
> +	long long int	big_dswidth;
>  	int		dsunit = 0;
>  	int		dswidth = 0;
>  	int		lsunit = 0;
> @@ -2251,7 +2252,14 @@ _("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
>  		}
>  
>  		dsunit  = (int)BTOBBT(dsu);
> -		dswidth = dsunit * dsw;
> +		big_dswidth = (long long int)dsunit * dsw;
> +		if (big_dswidth > INT_MAX) {
> +			fprintf(stderr,
> +_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> +				big_dswidth, dsunit);
> +			usage();
> +		}
> +		dswidth = big_dswidth;
>  	}
>  
>  	if (dsunit && (dswidth % dsunit != 0)) {
> 

