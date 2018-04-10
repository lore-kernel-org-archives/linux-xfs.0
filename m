Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60248 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754103AbeDJXhp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 19:37:45 -0400
Subject: Re: [PATCH 03/14] xfs_scrub: don't complain about different
 normalization
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160359862.8288.13397778165305364775.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0ea0ac19-9f26-a5ed-77e5-f1dc3c364c6f@sandeen.net>
Date: Tue, 10 Apr 2018 18:37:44 -0500
MIME-Version: 1.0
In-Reply-To: <152160359862.8288.13397778165305364775.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 3/20/18 10:39 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since there are different ways to normalize utf8 names, don't complain
> when we find a name that is normalized in a different way than the NFKC
> that we use to find duplicate names.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

insofar as I understand any of this,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/unicrash.c |   13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> index 0b5d1fa..10d7c14 100644
> --- a/scrub/unicrash.c
> +++ b/scrub/unicrash.c
> @@ -256,7 +256,6 @@ unicrash_complain(
>  	struct unicrash		*uc,
>  	const char		*descr,
>  	const char		*what,
> -	bool			normal,
>  	bool			unique,
>  	const char		*name,
>  	uint8_t			*uniname)
> @@ -267,10 +266,6 @@ unicrash_complain(
>  	bad1 = string_escape(name);
>  	bad2 = string_escape((char *)uniname);
>  
> -	if (!normal && should_warn_about_name(uc->ctx))
> -		str_info(uc->ctx, descr,
> -_("Unicode name \"%s\" in %s should be normalized as \"%s\"."),
> -				bad1, what, bad2);
>  	if (!unique)
>  		str_warn(uc->ctx, descr,
>  _("Duplicate normalized Unicode name \"%s\" found in %s."),
> @@ -342,20 +337,18 @@ __unicrash_check_name(
>  {
>  	uint8_t			uniname[(NAME_MAX * 2) + 1];
>  	bool			moveon;
> -	bool			normal;
>  	bool			unique;
>  
>  	memset(uniname, 0, (NAME_MAX * 2) + 1);
> -	normal = unicrash_normalize(name, uniname, NAME_MAX * 2);
> +	unicrash_normalize(name, uniname, NAME_MAX * 2);
>  	moveon = unicrash_add(uc, uniname, ino, &unique);
>  	if (!moveon)
>  		return false;
>  
> -	if (normal && unique)
> +	if (unique)
>  		return true;
>  
> -	unicrash_complain(uc, descr, namedescr, normal, unique, name,
> -			uniname);
> +	unicrash_complain(uc, descr, namedescr, unique, name, uniname);
>  	return true;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
