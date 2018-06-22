Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56164 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933382AbeFVT3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 15:29:11 -0400
Date: Fri, 22 Jun 2018 12:29:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs_quota: don't stop the directory tree walk when
 DEPTH is hit
Message-ID: <20180622192905.GS4838@magnolia>
References: <C26C67884C4B7A48980D574635594864034842C9@BPXM20GP.gisp.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C26C67884C4B7A48980D574635594864034842C9@BPXM20GP.gisp.nec.co.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Fri, Jun 22, 2018 at 08:44:21AM +0000, Kazuya Mio wrote:
> To set/check/clear a project quota, xfs_quota performs a pre-order tree
> traversal by using nftw(3).  The documentation states that the -d option
> can be used to skip subtrees below a certain level in the directory
> hierarchy.  Unfortunately, {check,setup,clear}_project returns -1 when
> DEPTH is hit, which stops the directory tree walk immediately.  We only
> wanted to skip the subtree, so return 0 instead.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  quota/project.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> diff --git a/quota/project.c b/quota/project.c
> index e4e7a01..20bc01b 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -101,7 +101,7 @@ check_project(
>  	int			fd;
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
> -		return -1;
> +		return 0;
>  
>  	if (flag == FTW_NS ){
>  		exitcode = 1;
> @@ -146,7 +146,7 @@ clear_project(
>  	int			fd;
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
> -		return -1;
> +		return 0;
>  
>  	if (flag == FTW_NS ){
>  		exitcode = 1;
> @@ -193,7 +193,7 @@ setup_project(
>  	int			fd;
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
> -		return -1;
> +		return 0;
>  
>  	if (flag == FTW_NS ){
>  		exitcode = 1;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
