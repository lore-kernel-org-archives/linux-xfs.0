Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 00:30:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l577UkWt011519
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 00:30:49 -0700
Date: Thu, 7 Jun 2007 17:30:34 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: xfs_growfs_data_private() not logging agf length change
Message-ID: <20070607073034.GP86004887@sgi.com>
References: <4667ADAF.7000904@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667ADAF.7000904@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Thu, Jun 07, 2007 at 05:03:11PM +1000, Tim Shimmin wrote:
> Looks like we forgot to log the agf_length change here.
> 
> (cut 'n' pasted patch)
> 
> --Tim
> 
> ===========================================================================
> Index: fs/xfs/xfs_fsops.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_fsops.c    2007-04-17 18:02:46.000000000 +1000
> +++ b/fs/xfs/xfs_fsops.c    2007-04-17 17:59:44.467987572 +1000
> @@ -328,6 +328,7 @@ xfs_growfs_data_private(
>         be32_add(&agf->agf_length, new);
>         ASSERT(be32_to_cpu(agf->agf_length) ==
>                be32_to_cpu(agi->agi_length));
> +        xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
>         /*
>          * Free the new space.
>          */

Yup, looks ok to me.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
