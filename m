Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46707 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbdF2RTE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 13:19:04 -0400
Date: Thu, 29 Jun 2017 10:18:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_spaceman: fix potential overflowing expression in
 trim_f()
Message-ID: <20170629171844.GG5874@birch.djwong.org>
References: <20170629171005.9886-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629171005.9886-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Jun 29, 2017 at 12:10:05PM -0500, Bill O'Donnell wrote:
> Prevent the potential overflow in expression calculating offset
> in trim_f(() by casting the first variable to off64_t (64bit signed).
> 
> Detected by CoverityScan, CID#1413771 Integer handling issues (OVERFLOW_BEFORE_WIDEN)
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  spaceman/trim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/spaceman/trim.c b/spaceman/trim.c
> index 872f68d3..6df9e6a9 100644
> --- a/spaceman/trim.c
> +++ b/spaceman/trim.c
> @@ -77,7 +77,7 @@ trim_f(
>  		length = cvtnum(file->geom.blocksize, file->geom.sectsize,
>  				argv[optind + 1]);
>  	} else if (agno) {
> -		offset = agno * file->geom.agblocks * file->geom.blocksize;
> +		offset = (off64_t)agno * file->geom.agblocks * file->geom.blocksize;
>  		length = file->geom.agblocks * file->geom.blocksize;
>  	} else {
>  		offset = 0;
> -- 
> 2.13.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
