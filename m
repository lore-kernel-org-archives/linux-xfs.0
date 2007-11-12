Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 22:33:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAC6Xi25017022
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 22:33:47 -0800
Date: Mon, 12 Nov 2007 17:33:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [[PATCH, RESEND]] reduce imaxpct for big filesystems,
Message-ID: <20071112063343.GC66820511@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com> <1194839329-22003-1-git-send-email-xaiki@sgi.com> <1194839329-22003-2-git-send-email-xaiki@sgi.com> <1194839329-22003-3-git-send-email-xaiki@sgi.com> <1194839329-22003-4-git-send-email-xaiki@sgi.com> <1194839329-22003-5-git-send-email-xaiki@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194839329-22003-5-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xaiki@sgi.com
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2007 at 02:48:48PM +1100, xaiki@sgi.com wrote:
> From: Niv Sardi <xaiki@sgi.com>
> 
> imaxpct is set to 25% for FS < 1 TB,
> then 5% for FS < 50 TB,
> and then 1%.
> 
> It is implemented as a step function in calc_default_imaxpct()
> ---
>  xfsprogs/mkfs/xfs_mkfs.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
> index 3689eb7..78c2c77 100644
> --- a/xfsprogs/mkfs/xfs_mkfs.c
> +++ b/xfsprogs/mkfs/xfs_mkfs.c
> @@ -374,6 +374,21 @@ validate_log_size(__uint64_t logblocks, int blocklog, int min_logblocks)
>  	}
>  }
>  
> +int
> +calc_default_imaxpct(

static int

> +	int		blocklog,
> +	__uint64_t	dblocks)
> +{
> +	if (dblocks < TERABYTES(1, blocklog)) {
> +		return XFS_DFL_IMAXIMUM_PCT;
> +	} else if (dblocks < TERABYTES(50, blocklog)) {
> +		return 5;
> +	}
> +
> +	return 1;
> +}

Comment explaining what it is doing? (i.e. what I had to explain to
you in the first place ;).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
