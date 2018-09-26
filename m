Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51816 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbeI0F1Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 01:27:24 -0400
Date: Wed, 26 Sep 2018 16:12:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] scrub: remove redundant debug test
Message-ID: <20180926231201.GX20086@magnolia>
References: <05122b65-0a26-c36f-1efb-78591497ed90@sandeen.net>
 <61fa5fe2-0ad9-80b2-f009-68a37682468d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61fa5fe2-0ad9-80b2-f009-68a37682468d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Sep 26, 2018 at 04:25:12PM -0500, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> debug_tweak_on() already tests for debug.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 076a86a..33b83a5 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -425,7 +425,7 @@ run_scrub_phases(
>  	unsigned int		nr_threads;
>  	int			rshift;
>  
> -	if (debug && debug_tweak_on("XFS_SCRUB_PHASE"))
> +	if (debug_tweak_on("XFS_SCRUB_PHASE"))
>  		debug_phase = atoi(getenv("XFS_SCRUB_PHASE"));
>  
>  	/* Run all phases of the scrub tool. */
> 
