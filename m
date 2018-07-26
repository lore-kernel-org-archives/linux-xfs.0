Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45070 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbeGZB31 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 21:29:27 -0400
Subject: Re: [PATCH v2] xfs_quota: don't stop the directory tree walk when
 DEPTH is hit
References: <C26C67884C4B7A48980D574635594864034842C9@BPXM20GP.gisp.nec.co.jp>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d7fd65eb-cdc9-9258-162f-96eebc4595e8@sandeen.net>
Date: Wed, 25 Jul 2018 17:15:15 -0700
MIME-Version: 1.0
In-Reply-To: <C26C67884C4B7A48980D574635594864034842C9@BPXM20GP.gisp.nec.co.jp>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kazuya Mio <k-mio@sx.jp.nec.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On 6/22/18 1:44 AM, Kazuya Mio wrote:
> To set/check/clear a project quota, xfs_quota performs a pre-order tree
> traversal by using nftw(3).  The documentation states that the -d option
> can be used to skip subtrees below a certain level in the directory
> hierarchy.  Unfortunately, {check,setup,clear}_project returns -1 when
> DEPTH is hit, which stops the directory tree walk immediately.  We only
> wanted to skip the subtree, so return 0 instead.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Getting this merged now, but an xfstests would be really, really good
to validate this behavior.  (hint, hint).

Thanks,
-Eric

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
> 
