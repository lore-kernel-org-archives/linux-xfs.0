Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38672 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbeBXEk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Feb 2018 23:40:26 -0500
Date: Fri, 23 Feb 2018 20:40:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_scrub: make interpreter explicit to python3
Message-ID: <20180224044018.GA19312@magnolia>
References: <20180224021512.23819-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180224021512.23819-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Fri, Feb 23, 2018 at 06:15:12PM -0800, Luis R. Rodriguez wrote:
> Using #!/usr/bin/env makes some package dependency tools
> such as rpm complain given that it cannot verify package
> dependencies. Making it explicit resolves this lint rant.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  scrub/xfs_scrub_all.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
> index fff05da3ea7a..80f07d5c8b02 100644
> --- a/scrub/xfs_scrub_all.in
> +++ b/scrub/xfs_scrub_all.in
> @@ -1,4 +1,4 @@
> -#!/usr/bin/env python3
> +#!/usr/bin/python3
>  
>  # Run online scrubbers in parallel, but avoid thrashing.
>  #
> -- 
> 2.16.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
