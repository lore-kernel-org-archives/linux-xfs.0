Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752221AbeA3DzC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jan 2018 22:55:02 -0500
Subject: Re: [PATCH 5/2] mkfs: don't call values 'illegal', they're invalid
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
 <20180130033857.GM9068@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <c31a9239-00b8-0c96-8603-cfb06a289ecf@redhat.com>
Date: Mon, 29 Jan 2018 21:55:01 -0600
MIME-Version: 1.0
In-Reply-To: <20180130033857.GM9068@magnolia>
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
> Specifying invalid inputs to mkfs does not break any (reasonable) laws,
> so the error message should complain about invalid inputs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Maybe not in your state ...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7c9d148..6285b24 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -911,7 +911,7 @@ illegal(
>  	const char	*value,
>  	const char	*opt)
>  {
> -	fprintf(stderr, _("Illegal value %s for -%s option\n"), value, opt);
> +	fprintf(stderr, _("Invalid value %s for -%s option\n"), value, opt);
>  	usage();
>  }
>  
> @@ -1267,7 +1267,7 @@ illegal_option(
>  	const char		*reason)
>  {
>  	fprintf(stderr,
> -		_("Illegal value %s for -%c %s option. %s\n"),
> +		_("Invalid value %s for -%c %s option. %s\n"),
>  		value, opts->name, opts->subopts[index],
>  		reason ? reason : "");
>  	usage();
> 

