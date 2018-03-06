Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39840 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753930AbeCFRT5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 12:19:57 -0500
Subject: Re: [PATCH 06/16] xfs_scrub: don't try to scan xattrs if bstat says
 there aren't any
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993161291.22223.12229177976202068960.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0dfcacf8-3dae-6499-888a-9356029c61f8@sandeen.net>
Date: Tue, 6 Mar 2018 11:19:56 -0600
MIME-Version: 1.0
In-Reply-To: <151993161291.22223.12229177976202068960.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org



On 3/1/18 1:13 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Only try to scan the extended attributes of a file if bstat says that
> the file actually has any.  Surprisingly, this reduces the phase 5
> runtime by 40% if most of the files don't have attrs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/phase5.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 0ef6339..8e0a1be 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -256,9 +256,12 @@ xfs_scrub_connections(
>  	background_sleep();
>  
>  	/* Warn about naming problems in xattrs. */
> -	moveon = xfs_scrub_scan_fhandle_xattrs(ctx, descr, handle, bstat);
> -	if (!moveon)
> -		goto out;
> +	if (bstat->bs_xflags & FS_XFLAG_HASATTR) {
> +		moveon = xfs_scrub_scan_fhandle_xattrs(ctx, descr, handle,
> +				bstat);
> +		if (!moveon)
> +			goto out;
> +	}
>  
>  	/* Open the dir, let the kernel try to reconnect it to the root. */
>  	if (S_ISDIR(bstat->bs_mode)) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
